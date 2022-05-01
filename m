Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122EA516403
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345594AbiEALWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345546AbiEALWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:22:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1FC5838B
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:18:47 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id k27so13756632edk.4
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 04:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qhxJ8TkbsGQ2o/H5s5bVuFWnK8y7lni9lVUTJ46OVMo=;
        b=bAyhFQiyZaX/HUrZBI2x0ALy2XXJB+ThfPrs6GxgpACr9BPTXNqUUOETCXOyhlh7Pz
         M3iR5llVyhhyCet6FkXNw9t05ULkUK1gyq2/DAh1iZjmZa1+gVBDJGxNmNz3CRZFCRzm
         aqRYHGNGaKhb+85vUgbQBpoH+lgH6UDs37LIG7I7JSEil8wzUCPJEwxSuEM1z4Jeysoy
         UTMGK6mEE+AswhY04KxFvPCJITE4PP3N9J6mmEM+5UbK+s3AhyAfVL+PoILG1LNsiVYW
         NAtdHHXM7xXPWMJlpfuWcv7E2Ql9RKKMeEOamEXPKSCLWSUz7cHHHJWN4D8l7E4f5r/6
         IhgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qhxJ8TkbsGQ2o/H5s5bVuFWnK8y7lni9lVUTJ46OVMo=;
        b=KwyZLPBUHevEW8qw9PWk68P+JjetMxklsQDZl1ZMdNCiKG5j47GqdxNwePoalkRPqg
         j+Pndk9hTWxq+teWIXQVO+RQUgYjeG79gOuX5JjtSvlDbzg75JyI1p08Lg9lEigSVUrz
         pm31BF+yyhDETq6XNo6dpOIQ7ihpA/uc0MfjKOv2ZZ6CFac1AI3Rmy6xuT80tY7a0FjY
         GSBY6VOH0F4Cs1W0Ld8kq9jHIollE6JQczAosPvUNbhilki1BonlGCYkwkyMOzK7glPH
         6xHExyEfgfYMHb6QwD9ApbnTqTTgQ2mOZjOpMZdmKtMhndvNoJ7KYdtc1gbhFBLE1N6k
         E3cQ==
X-Gm-Message-State: AOAM532hcRLOPeTmwirkutE83K7iVbyWu0uK64l7+lKirqyHSuS+6wyU
        9IkyzwfBhYsnseC79y6jWo7FLQ==
X-Google-Smtp-Source: ABdhPJzvAriITX0OwgujwDSkJEdvW4OzDBWqD4Ye6sfPYXipb2d72aPIdRfVm0MeAJFCSL1zpw5xfA==
X-Received: by 2002:aa7:db48:0:b0:425:f93a:de5b with SMTP id n8-20020aa7db48000000b00425f93ade5bmr8345142edt.169.1651403926172;
        Sun, 01 May 2022 04:18:46 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id mm29-20020a170906cc5d00b006f3ef214dcesm2508630ejb.52.2022.05.01.04.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 04:18:45 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 2/6] ptp: Request cycles for TX timestamp
Date:   Sun,  1 May 2022 13:18:32 +0200
Message-Id: <20220501111836.10910-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220501111836.10910-1-gerhard@engleder-embedded.com>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The free running cycle counter of physical clocks called cycles shall be
used for hardware timestamps to enable synchronisation.

Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
provide a TX timestamp based on cycles if cycles are supported.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 include/linux/skbuff.h |  5 +++++
 net/core/skbuff.c      |  5 +++++
 net/socket.c           | 11 ++++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3270cb72e4d8..fa03e02b761d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -615,6 +615,11 @@ enum {
 	/* device driver is going to provide hardware time stamp */
 	SKBTX_IN_PROGRESS = 1 << 2,
 
+	/* generate hardware time stamp based on cycles if supported, flag is
+	 * used only for TX path
+	 */
+	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
+
 	/* generate wifi status information (where possible) */
 	SKBTX_WIFI_STATUS = 1 << 4,
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b92e93dcaa91..62d6d143dd70 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4841,6 +4841,11 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 		skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
 					     SKBTX_ANY_TSTAMP;
 		skb_shinfo(skb)->tskey = skb_shinfo(orig_skb)->tskey;
+	} else {
+		/* Do not clone SKBTX_HW_TSTAMP_USE_CYCLES flag to enable reuse
+		 * of the same bit in RX path.
+		 */
+		skb_shinfo(skb)->tx_flags &= ~SKBTX_HW_TSTAMP_USE_CYCLES;
 	}
 
 	if (hwtstamps)
diff --git a/net/socket.c b/net/socket.c
index f0c39c874665..5c1c5e6100e1 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -683,9 +683,18 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
 {
 	u8 flags = *tx_flags;
 
-	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE)
+	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE) {
 		flags |= SKBTX_HW_TSTAMP;
 
+		/* PTP hardware clocks can provide a free running cycle counter
+		 * as a time base for virtual clocks. Tell driver to use the
+		 * free running cycle counter for timestamp if socket is bound
+		 * to virtual clock.
+		 */
+		if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
+			flags |= SKBTX_HW_TSTAMP_USE_CYCLES;
+	}
+
 	if (tsflags & SOF_TIMESTAMPING_TX_SOFTWARE)
 		flags |= SKBTX_SW_TSTAMP;
 
-- 
2.20.1

