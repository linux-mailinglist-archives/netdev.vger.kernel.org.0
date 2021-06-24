Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD273B32D0
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFXPug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbhFXPuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:50:35 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF092C061574;
        Thu, 24 Jun 2021 08:48:15 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id b3so4476676qtq.6;
        Thu, 24 Jun 2021 08:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UU6DtDGiyA1vWHeojTVbBhsXsciQ4zbhSh2JaptoGlM=;
        b=SRlxey+oYCINUn9G4HTTJ0AqS9LuZVHwhL4xuNDscS4VmSHXTt406Pa3rUHVuTVs2F
         ZNVZo2onwQ/nMo47SnpFXpv3ZLulKvxgYcL38t18JJWNhmF1yoCK2T1LPBjDOScf19Vt
         qOjjLiidSwtRPpxfcPFuoaIcVF43HP2j3KdHj9OEP+osi0HpeqxgEtqFY3smFl/9jjIa
         pF3RqEEI2bm6Omznd7d9RwdK8CpER0WUoffsF6LV8pLozFjwOjB0rM5gcfFYJQjVGy+p
         w28ortidm4ra8bJCAT9S/dEHvp78ZiKY1EC6mX5lelvoWIoc79ZrFKgj9pEBRaVcROlD
         j/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UU6DtDGiyA1vWHeojTVbBhsXsciQ4zbhSh2JaptoGlM=;
        b=sZUmio3Bd7zgY+x7CXC2+pNA2IfLZxpr9LdMUzhuH95NEkIm5fPKwZWAl+Nop7a3ie
         R1xFpf0rgeDaIdLpnbobR7cO/QY9WKOsHUpwTSOXF5ABvy2kE/VbljoN8iomDKvfAJYX
         AZm7yKJK0lC1ZJdwDYJkSHe0meDnjQNO+wj6fOQydXYWP0mxU6WcR+YWkpXt32g8iRGI
         yEO3fGqnX2Zf0IXpTnwWbhICNuWqaicdf+XAhWrhTJstMP023a56ubj2yAulfxBFKw0W
         t8uA2kWnRecCZ4+90zEnAbObkPpXgvjPHB8d1NCL3QFDje6M9/vsqcfMf9xn92HWrVwR
         HVJA==
X-Gm-Message-State: AOAM5326SdDC87bQ+zgm/3NlVkBbTfKhqFihd/xoeMtqCjAcwdPnT+qL
        ngVgr7zwBR/0wBZwtDsrC2CO81KqKjjI7Q==
X-Google-Smtp-Source: ABdhPJy+QqFZolzb9n224yoPQj9aU2hzd5auCxa0gGci1GSUMuvTgjhCr+G2oomQL8CSqmbew2rPIA==
X-Received: by 2002:ac8:4a18:: with SMTP id x24mr5262672qtq.239.1624549694864;
        Thu, 24 Jun 2021 08:48:14 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j4sm2179897qtr.72.2021.06.24.08.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 08:48:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Cc:     David Laight <david.laight@aculab.com>
Subject: [PATCH net-next 2/2] sctp: send the next probe immediately once the last one is acked
Date:   Thu, 24 Jun 2021 11:48:09 -0400
Message-Id: <5ef97ff6f95741bde34124e4d4aed8c32bde0ff5.1624549642.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624549642.git.lucien.xin@gmail.com>
References: <cover.1624549642.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These is no need to wait for 'interval' period for the next probe
if the last probe is already acked in search state. The 'interval'
period waiting should be only for probe failure timeout and the
current pmtu check when it's in search complete state.

This change will shorten the probe time a lot in search state, and
also fix the document accordingly.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 12 ++++++++----
 net/sctp/sm_statefuns.c                |  5 ++++-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 8bff728b3a1e..b3fa522e4cd9 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2835,10 +2835,14 @@ encap_port - INTEGER
 	Default: 0
 
 plpmtud_probe_interval - INTEGER
-        The time interval (in milliseconds) for sending PLPMTUD probe chunks.
-        These chunks are sent at the specified interval with a variable size
-        to probe the mtu of a given path between 2 endpoints. PLPMTUD will
-        be disabled when 0 is set, and other values for it must be >= 5000.
+        The time interval (in milliseconds) for the PLPMTUD probe timer,
+        which is configured to expire after this period to receive an
+        acknowledgment to a probe packet. This is also the time interval
+        between the probes for the current pmtu when the probe search
+        is done.
+
+        PLPMTUD will be disabled when 0 is set, and other values for it
+        must be >= 5000.
 
 	Default: 0
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index d29b579da904..09a8f23ec709 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1275,7 +1275,10 @@ enum sctp_disposition sctp_sf_backbeat_8_3(struct net *net,
 			return SCTP_DISPOSITION_DISCARD;
 
 		sctp_transport_pl_recv(link);
-		return SCTP_DISPOSITION_CONSUME;
+		if (link->pl.state == SCTP_PL_COMPLETE)
+			return SCTP_DISPOSITION_CONSUME;
+
+		return sctp_sf_send_probe(net, ep, asoc, type, link, commands);
 	}
 
 	max_interval = link->hbinterval + link->rto;
-- 
2.27.0

