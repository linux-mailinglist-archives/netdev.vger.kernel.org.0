Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D094F0BAA
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240320AbiDCR6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 13:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240283AbiDCR6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 13:58:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6D0387BF
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 10:56:01 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id q26so912869edc.7
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 10:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7dp4BMuH/kevxy3gi0HNX8htCjjZHnuqhGGK7or5vJ0=;
        b=4KLmeYu6kd/5Xw5bDnz1/sBSctSQxxUKuuyzsK8PtagSbxupDBbno7UCdCfnwxWL/L
         j6XDl/6iAnX0FkPqTe8XhO/wnISZZJigxsZUXEx++Lp8MJSa0574zjYK7pIfvH1BtJkQ
         NhakpFrp19cb9fMeq3cQ6rGf1fN+zFtACxXkot7k6FXEBD35OuFU94xE9PKd0h+43xtn
         Hh3w9ymtdQzV8eXNWRhtVrU1UP1dXRn6rbjxDJA4rdfDwp8bnO0itkpr5wZ97wgvRC81
         3GE8Qxf6tUdisaS1UZKMWIaron2y4dEDaOHVytwO/z/MgijepCdAo1GndhsjUoLsTm/H
         baiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7dp4BMuH/kevxy3gi0HNX8htCjjZHnuqhGGK7or5vJ0=;
        b=O+M0Y1jendvanHPYZtz2LrimFP9EsyqQeSNTGxsg4oDYZz+mqr8xWIMEdpPOF4wEQC
         ZUw4qdC5kq2e3anajW0dWonCmRc4Dco1Kc0D0cVqmlWx09RCW0yEq4LB0YzD0jOGuyss
         xN/FQaNKzwUdLtgEf6apTvPoVnK8mM+R8ISu8QVVvfDKc9aHsctrMimDnTwup/dRctKV
         RKU3QVrDsrUb10RFdVp6vqSdjqqLac/Mfacy0eYwdjz2vZ9HTSUfeEU3qt3B1iYqcA6I
         CniVB45xDMb+eui8tAJlqRPCrL5rUu/kDak7uwnMbCkGJymp+AM3nW4jjkjH48QVLaLL
         e8TQ==
X-Gm-Message-State: AOAM533vEFBX/nXYfizhOG/SeqOCMHYaTPW89ubYlSrM4xAMXslxbGhZ
        YJB3VibabUcZoWq01Wp3BeyfIg==
X-Google-Smtp-Source: ABdhPJxpf365ozrjkhxIl+5LJU8tkGJOcxqvHwg60ruunIkeLeOG9NkRcuEmnYokPBYhpvapMPi0xg==
X-Received: by 2002:aa7:c88b:0:b0:41c:c3d6:ab95 with SMTP id p11-20020aa7c88b000000b0041cc3d6ab95mr2653000eds.141.1649008559856;
        Sun, 03 Apr 2022 10:55:59 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm3451065ejo.191.2022.04.03.10.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 10:55:59 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 2/5] ptp: Request cycles for TX timestamp
Date:   Sun,  3 Apr 2022 19:55:41 +0200
Message-Id: <20220403175544.26556-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220403175544.26556-1-gerhard@engleder-embedded.com>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
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
 include/linux/skbuff.h |  3 +++
 net/core/skbuff.c      |  2 ++
 net/socket.c           | 11 ++++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3a30cae8b0a5..aeb3ed4d6cf8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -578,6 +578,9 @@ enum {
 	/* device driver is going to provide hardware time stamp */
 	SKBTX_IN_PROGRESS = 1 << 2,
 
+	/* generate hardware time stamp based on cycles if supported */
+	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
+
 	/* generate wifi status information (where possible) */
 	SKBTX_WIFI_STATUS = 1 << 4,
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 10bde7c6db44..c0f8f1341c3f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4847,6 +4847,8 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 		skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
 					     SKBTX_ANY_TSTAMP;
 		skb_shinfo(skb)->tskey = skb_shinfo(orig_skb)->tskey;
+	} else {
+		skb_shinfo(skb)->tx_flags &= ~SKBTX_HW_TSTAMP_USE_CYCLES;
 	}
 
 	if (hwtstamps)
diff --git a/net/socket.c b/net/socket.c
index 6887840682bb..03911a3d8b33 100644
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

