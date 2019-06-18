Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6444D4A477
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfFROuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:50:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46976 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729775AbfFROuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:50:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so14292414wrw.13
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sTgfT9i5a5lfBgknVrCGWbrcXTZ5IMOK7UB/FmEY8VY=;
        b=AptCJ3hDF/r3p4yUEZqYwy2ZKR8LrZbPQad1BV5ceSZXwCGPnnCPgaqNGn6ir2ncAU
         La0MsD5CgQsHwtmqeE+s5s15RO/xacaTq7fiPa+ToIOg38FCplawCm8kIyNsq5gA5YcL
         /xYjzFB0et9kStaWxqxZP+Eqm78ToYdUVFTS5a5Gt5uLbZ/62R3XUp3zgP1WfukisuZD
         sX6mfd4IgVyJDfog36seRib+MsFIfBpEKb9nxmS84wDCvz0eaQQ4EBZiNg9hvoLq1wbX
         6sIBTnBtuuL02yp0DfoB88JhO5nX8l5OQVgNDQoieDNrUCjZNtVtvgQsc3OE1Ebh5fbE
         aLsA==
X-Gm-Message-State: APjAAAVJlt4+RmwNWJWjEjoVsF2xgyHAuQcnLDzMnmLw/fM3LnfBnYhF
        D+HIYHcvskftubYn7Af38R/Q7d8icZk=
X-Google-Smtp-Source: APXvYqwQQz6+5edpynOiZBpav6rPwqz68vBbnLvGda4nbWgUS/CAdPYIzSq5ITpFMGO8YMvPayDoyQ==
X-Received: by 2002:adf:dc45:: with SMTP id m5mr14760444wrj.148.1560869414587;
        Tue, 18 Jun 2019 07:50:14 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y133sm4013788wmg.5.2019.06.18.07.50.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:50:13 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: [PATCH iproute2 v2 2/3] ip vrf: use hook to change VRF in the child
Date:   Tue, 18 Jun 2019 16:49:34 +0200
Message-Id: <20190618144935.31405-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618144935.31405-1-mcroce@redhat.com>
References: <20190618144935.31405-1-mcroce@redhat.com>
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
 ip/ipvrf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

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

