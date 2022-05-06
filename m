Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82C51DFE5
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392539AbiEFUF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392501AbiEFUFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:05:51 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F285F8D7
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:02:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id i27so16350617ejd.9
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 13:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y1Dm+O/mM+AJLj+sXxq233PXJNN3alKJLc+V3CdaMRc=;
        b=vSXvwbQKckFNygZafx7S46AMCff80YbBjiR/slRIf0VL5L9WW/2maB1Se8188GPBMU
         U1EgiAVorpvBoSwmoFXrBhD39OnuF8TB7ReybtcZcIi0Ij5dBtey5kwQKgE16rVQqRl3
         akyK66VVeupIpWtqOsZVpePYCp/WkM1sXBO4PmKUdgyKdVz/tQinfSP6FR1xAIXEv8bz
         AkHUk79fdPzTUKE/mMMybC/TyAzf5kwFoEmpCywZkcpcxMal6ZspEA2xJ99NWKyKX9/l
         s34v7vkufFSZ4GgsuHNY0qsgG0QlUrEb5iQUxvfAKvAhOYmi9CdekcM4tI3igvtDW66n
         vt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y1Dm+O/mM+AJLj+sXxq233PXJNN3alKJLc+V3CdaMRc=;
        b=23Zcc3nZzhaR5/7jhOAEiMKVzpn1pmjJTtMGO+BScvs9jyzjqc1TRDDX9wD1rkh3je
         2rw7ZimPRbbIsuVVoHnmH3coFNbqMK/fhspVhdeiFQZqzGKxCUC0SZ0rowFD3qHqZ0gw
         iO6z8GSu/LIEzp8kn7/vec0BbFvj0oQ5vuVkjVHaikQilKwUYtQ8fBnqu8jnbuPUgE2g
         dHwcD0j4ogk+IJ/NhvRwtbzB5sv8apz8pvhAJPdF6SqWfr2cb0OnN6KOHyVbg+U97y3H
         LNXxc36lO3+8cOX6VyKHuuZXDUb4WJjdW63Q12AxnU8jNroQQi/x3yQ86YNAT5HgwkRi
         iDMg==
X-Gm-Message-State: AOAM531ybF865EfouswjFvRoTUQX2Aq2Xw1pLEfatDgaERqMkzWkRLH+
        X4og+IrOwl/DO4SesCt/u/Or2g==
X-Google-Smtp-Source: ABdhPJwdrWG5RyjKQ60szhv50mVY33uzwJgdjcwfu8Rw4ZO2yuKOX1cK7zdnfr42TkS0883uuP19vg==
X-Received: by 2002:a17:906:7013:b0:6f3:a9c3:6045 with SMTP id n19-20020a170906701300b006f3a9c36045mr4573268ejj.158.1651867325489;
        Fri, 06 May 2022 13:02:05 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:237:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id w5-20020a056402268500b0042617ba6389sm2719887edd.19.2022.05.06.13.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:02:05 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, willemb@google.com, kafai@fb.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 3/6] ptp: Pass hwtstamp to ptp_convert_timestamp()
Date:   Fri,  6 May 2022 22:01:39 +0200
Message-Id: <20220506200142.3329-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220506200142.3329-1-gerhard@engleder-embedded.com>
References: <20220506200142.3329-1-gerhard@engleder-embedded.com>
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

ptp_convert_timestamp() converts only the timestamp hwtstamp, which is
a field of the argument with the type struct skb_shared_hwtstamps *. So
a pointer to the hwtstamp field of this structure is sufficient.

Rework ptp_convert_timestamp() to use an argument of type ktime_t *.
This allows to add additional timestamp manipulation stages before the
call of ptp_convert_timestamp().

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_vclock.c         | 5 ++---
 include/linux/ptp_clock_kernel.h | 7 +++----
 net/socket.c                     | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 3a095eab9cc5..c30bcce2bb43 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -232,8 +232,7 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 }
 EXPORT_SYMBOL(ptp_get_vclocks_index);
 
-ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
-			      int vclock_index)
+ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 {
 	char name[PTP_CLOCK_NAME_LEN] = "";
 	struct ptp_vclock *vclock;
@@ -255,7 +254,7 @@ ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
 
 	vclock = info_to_vclock(ptp->info);
 
-	ns = ktime_to_ns(hwtstamps->hwtstamp);
+	ns = ktime_to_ns(*hwtstamp);
 
 	spin_lock_irqsave(&vclock->lock, flags);
 	ns = timecounter_cyc2time(&vclock->tc, ns);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index ad309202cf9f..92b44161408e 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -384,17 +384,16 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
 /**
  * ptp_convert_timestamp() - convert timestamp to a ptp vclock time
  *
- * @hwtstamps:    skb_shared_hwtstamps structure pointer
+ * @hwtstamp:     timestamp
  * @vclock_index: phc index of ptp vclock.
  *
  * Returns converted timestamp, or 0 on error.
  */
-ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
-			      int vclock_index);
+ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index);
 #else
 static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 { return 0; }
-static inline ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
+static inline ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp,
 					    int vclock_index)
 { return 0; }
 
diff --git a/net/socket.c b/net/socket.c
index 5c1c5e6100e1..0f680c7d968a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -888,7 +888,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
 	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
 		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
-			hwtstamp = ptp_convert_timestamp(shhwtstamps,
+			hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
 							 sk->sk_bind_phc);
 		else
 			hwtstamp = shhwtstamps->hwtstamp;
-- 
2.20.1

