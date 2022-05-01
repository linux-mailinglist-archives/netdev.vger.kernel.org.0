Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B432516404
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345600AbiEALWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345385AbiEALWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:22:14 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B98258397
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:18:49 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id g6so23204350ejw.1
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 04:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y1Dm+O/mM+AJLj+sXxq233PXJNN3alKJLc+V3CdaMRc=;
        b=51XC0LQQxOXxXqMObA872OrbYtGY07NzWyYDzgulOfgAnOnRZx7WiknwSo2WkEuTlk
         7gNtq2p0t68o6UMgwNNbH2Y09HO5HoL01WF25LbonqRhGCHnFWipRmJDI9bwRe83yRDF
         YQyDHoNqVmt1SAFbgsGGd5UR3tUHNrInEl44zh4WglHkX1lWQ+KzHbkSSGHbq1GfwHTm
         LltqudPjDEld67Pft3ru4iZklg8uQhpi9Pf4nVJaFnwrWzaI/zjK3O28aRnS+Ek5c+sF
         PkoDR5mqcfWHNVBC0ZuXsyNrSkzyISA5OWBwccKjxGJ5ZQUA3HUBj0CGpSZKmnEEz6EO
         YMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y1Dm+O/mM+AJLj+sXxq233PXJNN3alKJLc+V3CdaMRc=;
        b=L2DsY8gNC3LYz0bESmRaPJQCBwUf/yj1j72VVqGhvOqps9rqp2Y4XmBvlL4KQ7Znx1
         rLPJhP+2HUj0g7vqwlx3nN1xGq76iWgP4QRDXqgsrpOXmEAztfZj3H/mXwjd7TSEO2st
         /VOey9C7iQYAIaM0BgstSVQc3yDTP30H8mlv8fLTzFON/tk/ZVdT47RPcmP/l2V0kOT8
         5UgUnEx7GwnJwO3yRP0bKc2w8phE4E0+mY4pqXDCN9JltPuzrtQZgWaCcdZK46ImjY1N
         8+AB5dLZd57Aaa2TOjf3OlA57KsWnwANBQ2NYqAWNbP8NZnUW24te1+lTh8zxU3Ll8RW
         A9KQ==
X-Gm-Message-State: AOAM532qYb3AaaJjludMEP+py5UrIm2XiN6Jj/xa7mRRFSGQFUNYOI/b
        u+UBr7gvRvBFgLBxCdRf++aWSA==
X-Google-Smtp-Source: ABdhPJzDxhCLEBT5IjkNjqsLCTXOqSiQeqOZ53pOiLnCdh2uRLDSDzEiKGvS3zVRGQj4BVYyf+O8Gw==
X-Received: by 2002:a17:907:62a9:b0:6da:7953:4df0 with SMTP id nd41-20020a17090762a900b006da79534df0mr6969617ejc.316.1651403927693;
        Sun, 01 May 2022 04:18:47 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id mm29-20020a170906cc5d00b006f3ef214dcesm2508630ejb.52.2022.05.01.04.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 04:18:47 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 3/6] ptp: Pass hwtstamp to ptp_convert_timestamp()
Date:   Sun,  1 May 2022 13:18:33 +0200
Message-Id: <20220501111836.10910-4-gerhard@engleder-embedded.com>
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

