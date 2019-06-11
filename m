Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69A13D1EC
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405393AbfFKQLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:11:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35819 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405250AbfFKQLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:11:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id m3so13731596wrv.2
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 09:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=idCwvuLeuHPUXqbHGmg7dQ/GLM79vVvGVdlkTrRuWKE=;
        b=dqWTpA1I+YE/SuZG6sHVKbP6biNuyfoXMINiS7uBf3rPX9incaPpg+GkUpSdZ0lxEl
         IhHk6kcM4Ur02fdSF+LOB5lyacM5rMfR7uDYcfjIjGPXEfBsfZUXUfQBVzz/zmHQs0UB
         zduq2haMyaZpwK34RvT7wOLzbUzSVLN4G/Hy7pcWdbtctyG0Tdizxy+OW4ari+D2wf9r
         XwAc0mKYHfOyRVtGfgx1EypiZeTn2kqTRWj4PklsRdy33L3MHVI6XwNiB/PHojJBga/1
         jOMr/jPJP4M06IkeXzaNPnnlNPEccnHT82888+UfoVum/24RJM+BWPetYCGO+hgfYu+B
         /uww==
X-Gm-Message-State: APjAAAXdFJTdPpgzn4NNbI0GwFFV4ACTpAF2h5BGGwUcs7Y3EGVwqXfe
        1ulFIUCEUjfp5KhZGbKvXCyPzhmXONA=
X-Google-Smtp-Source: APXvYqwik59AAPuS9Wz2SKxTMrJAgjjTgFOyy+2OeYG/QIANHP/zvuQSr+xKRBTKpLvt0TvJYAJukg==
X-Received: by 2002:a5d:4310:: with SMTP id h16mr39851503wrq.331.1560269498777;
        Tue, 11 Jun 2019 09:11:38 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y18sm4286981wmd.29.2019.06.11.09.11.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 09:11:38 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 v2 2/3] ip vrf: use hook to change VRF in the child
Date:   Tue, 11 Jun 2019 18:10:30 +0200
Message-Id: <20190611161031.12898-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611161031.12898-1-mcroce@redhat.com>
References: <20190611161031.12898-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On vrf exec, reset the VRF associations in the child process, via the
new hook added to cmd_exec(). In this way, the parent doesn't have to
reset the VRF associations before spawning other processes.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 ip/ipnetns.c |  5 -----
 ip/ipvrf.c   | 12 ++++++++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 58655676..1fff284e 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -400,11 +400,6 @@ static int do_switch(void *arg)
 {
 	char *netns = arg;
 
-	/* we just changed namespaces. clear any vrf association
-	 * with prior namespace before exec'ing command
-	 */
-	vrf_reset();
-
 	return netns_switch(netns);
 }
 
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 2b019c6c..43366f6e 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -442,6 +442,13 @@ out:
 	return rc;
 }
 
+static int do_switch(void *arg)
+{
+	char *vrf = arg;
+
+	return vrf_switch(vrf);
+}
+
 static int ipvrf_exec(int argc, char **argv)
 {
 	if (argc < 1) {
@@ -453,10 +460,7 @@ static int ipvrf_exec(int argc, char **argv)
 		return -1;
 	}
 
-	if (vrf_switch(argv[0]))
-		return -1;
-
-	return -cmd_exec(argv[1], argv + 1, !!batch_mode, NULL, NULL);
+	return -cmd_exec(argv[1], argv + 1, !!batch_mode, do_switch, argv[0]);
 }
 
 /* reset VRF association of current process to default VRF;
-- 
2.21.0

