Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29CE28F8CC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbgJOSmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389126AbgJOSmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 14:42:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61554C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 11:42:05 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 1so2097027ple.2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 11:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pgRjOcL3XdrzCFhXK1FsYDYa8jh3o/3R3IYC9VTrVnc=;
        b=VveFOheUQBzLsPJ9P2JeVEKw1b5b4O7caeQtRkPRWzpMHdMINvh+h14p39XUAiQ4yc
         Pbs1O1usaCOS/YCSBpCZKUnnYXWBEk/GjudyJUpgKhQ5tR8hrw1C2TqkIbf9yWcAjScN
         ysNFcGQiZ3Py7eFoddmoXOYLIygoJMqjsThYHIFSU9M89DsuF+XndPDD+TPPRpuRA96h
         BCy1aWY52h8ugq1OdoJ8PqgL0BoxVjkLMTfoQj/xgumRhEfv3DaFsuUKs3gdQtZHtHFC
         MmRZpzoPEIHOcOVW2arm6krZsZ9A/FIEC/BZkraMFzuFE+1V/KRx/SkpESn9jQp2ev3n
         2w5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pgRjOcL3XdrzCFhXK1FsYDYa8jh3o/3R3IYC9VTrVnc=;
        b=HzFaqQDLvPIQeyLh9hWeu0miul4Zg6hDlqTZQ0ILyVZUm0XvLHr7AYajojCLn8zVSj
         RbcFVak9Eh+UNVH14fTd8CgtK06G2R1tV1o4Oa2tSaX/A3hupSGLZuMIAY9cnGXPuiAn
         TvnmxyWB00fAR8DRaXBJlgjt2cmb/X0PeDCa+z73DwhDpGiCvL02HxO+OuTbl0hrIzjm
         Clg0cNExYRM47rHxhp5jjGjWb9NCTr/t0Zvx8dpPi/BDyNy4snrEyu2BGp/I3OxHKGLk
         ZCbIgY2Bp3/oPTXcDksoSd8K1JazFeC8WoGwaS2eTqmGSPHfu8DjEp3jdY7V4nsvjQ1t
         U/Bw==
X-Gm-Message-State: AOAM531XKBHR+VyPgxZk/eNK9lOBH97Nduj+93vpT+zXfpX6jhhOboF/
        OKFVgBKWSBOPUJlZ2ejHf9s=
X-Google-Smtp-Source: ABdhPJy5qencDYQcZV0ImtqBbYjwKpPf6Rq1S+yle/l1I7UV0ixAbYD6rRAGsWetmuM+u7aW9E/tBQ==
X-Received: by 2002:a17:902:8f88:b029:d4:cb17:e160 with SMTP id z8-20020a1709028f88b02900d4cb17e160mr85039plo.78.1602787324921;
        Thu, 15 Oct 2020 11:42:04 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id i5sm59822pjt.54.2020.10.15.11.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 11:42:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Keyu Man <kman001@ucr.edu>
Subject: [PATCH net] icmp: randomize the global rate limiter
Date:   Thu, 15 Oct 2020 11:42:00 -0700
Message-Id: <20201015184200.2179938-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Keyu Man reported that the ICMP rate limiter could be used
by attackers to get useful signal. Details will be provided
in an upcoming academic publication.

Our solution is to add some noise, so that the attackers
no longer can get help from the predictable token bucket limiter.

Fixes: 4cdf507d5452 ("icmp: add a global rate limitation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
---
 Documentation/networking/ip-sysctl.rst | 4 +++-
 net/ipv4/icmp.c                        | 7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 837d51f9e1fab7c0999a51184f95971fb43c1b9b..25e6673a085a0f55f1f23bd3974e806ed2706f68 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1142,13 +1142,15 @@ icmp_ratelimit - INTEGER
 icmp_msgs_per_sec - INTEGER
 	Limit maximal number of ICMP packets sent per second from this host.
 	Only messages whose type matches icmp_ratemask (see below) are
-	controlled by this limit.
+	controlled by this limit. For security reasons, the precise count
+	of messages per second is randomized.
 
 	Default: 1000
 
 icmp_msgs_burst - INTEGER
 	icmp_msgs_per_sec controls number of ICMP packets sent per second,
 	while icmp_msgs_burst controls the burst size of these packets.
+	For security reasons, the precise burst size is randomized.
 
 	Default: 50
 
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 9ea66d903c41f560093b5cf21814b494c71f669b..1e8fd77d85037f8c7b5a64fc54630ccffc3a48b1 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -239,7 +239,7 @@ static struct {
 /**
  * icmp_global_allow - Are we allowed to send one more ICMP message ?
  *
- * Uses a token bucket to limit our ICMP messages to sysctl_icmp_msgs_per_sec.
+ * Uses a token bucket to limit our ICMP messages to ~sysctl_icmp_msgs_per_sec.
  * Returns false if we reached the limit and can not send another packet.
  * Note: called with BH disabled
  */
@@ -267,7 +267,10 @@ bool icmp_global_allow(void)
 	}
 	credit = min_t(u32, icmp_global.credit + incr, sysctl_icmp_msgs_burst);
 	if (credit) {
-		credit--;
+		/* We want to use a credit of one in average, but need to randomize
+		 * it for security reasons.
+		 */
+		credit = max_t(int, credit - prandom_u32_max(3), 0);
 		rc = true;
 	}
 	WRITE_ONCE(icmp_global.credit, credit);
-- 
2.29.0.rc1.297.gfa9743e501-goog

