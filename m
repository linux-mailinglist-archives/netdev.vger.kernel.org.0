Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCAB4CEA1D
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 09:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiCFI6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 03:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiCFI6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 03:58:34 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7872E1B786
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 00:57:43 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id r13so26025698ejd.5
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 00:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XDNNHD8OAOxJFkw4wjhl3Pxdt/6dwSNvkD57lHXJ1ng=;
        b=KhFhyRIKIUUoX6dTRdFFHJEK5ybgR5fqm8Lz2lvycRtwVaUSVKNNrzBuLv4mulYgPE
         nEo2gjXw9NsIytgKHPiq00X5oJHCScoC5lCsD9oUYbsrPMY8nohMzkl4UiC+b9mFjr7a
         cFbDBWk+HVBQjpFYVwwTPfQaNXFAe57Vd88DOjwivogTrR64ijvHB62hXRII0/CWBpv8
         j1dTAcgOaTHzDCkF6RpBjAczcbftXWBZpi1t++xvG0qdYTbUIBgBaYs/xAQsn8AQ9rHS
         ENIUrMRAjIkSSHPs7yZePVYrN+hipyQeMOAQQJgcmpGUtry7qPwmy6kR+py8yvijglC+
         VX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XDNNHD8OAOxJFkw4wjhl3Pxdt/6dwSNvkD57lHXJ1ng=;
        b=8NBQGg8vdDHf5nkfz5yn6Zae+sNPAPtvfDX6Y9pYpTx1KlN2ig8Xs71fkG3B9J+mNz
         vkH3B2U9qlfFX6ENOacZSN+XHW7R5NzPuFvnyH+psI6RRpir2d1X2PVYWDg0p0hTEq0m
         hA963W14ti541YTRHmLe3I0w0GjyepM0a35sZot/y1nuuh97ENaVHAbTmmOnqFpJ7nzd
         RBkNOLyaJq0QvSM6g7uVbqrsjnS92JE3fCtJz9Az7sAYq4dvwb7Bk0cwhHhoxK3LeYg/
         mNcqhr+2cDBRPTq/De4mjr1F6/nuB9XHfmviEOVCJTP5aEQBetKbqAgPYZjxgvm41JQ+
         9EeQ==
X-Gm-Message-State: AOAM533aJMYK2D0J7hK1cHAQgGKQOW8pa1qv3+5gZ7q53hBI0tuYREF/
        KW6K5S0doNaQ2duUHeoUoT6M1Q==
X-Google-Smtp-Source: ABdhPJx9sYX70Ke88/sL/uyL40sPYF3Zs/87PGrwrCpSBMgL/l3QEnNFmWvdwau9fs+4+a76WXi5KQ==
X-Received: by 2002:a17:906:c113:b0:6d7:7b53:9cb with SMTP id do19-20020a170906c11300b006d77b5309cbmr5399988ejc.197.1646557061982;
        Sun, 06 Mar 2022 00:57:41 -0800 (PST)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z24-20020a170906815800b006dab4bd985dsm2663423ejw.107.2022.03.06.00.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 00:57:41 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [RFC PATCH net-next 4/6] ptp: Support time stamps based on free running time
Date:   Sun,  6 Mar 2022 09:56:56 +0100
Message-Id: <20220306085658.1943-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
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

Physical clocks are used for hardware time stamping. Also ptp vclocks
support hardware time stamps. If a physical clock additionally supports
a free running time and this time is used as base for ptp vclocks, then
also hardware time stamps based on that free running time are required.

Add hardware time stamp of additional free running time to
skb_shared_hwtstamps and use it if physical clock supports an additional
free running time.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/ptp/ptp_vclock.c | 5 ++++-
 include/linux/skbuff.h   | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 3715d75ee8bd..84f798a11bca 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -268,7 +268,10 @@ ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
 
 	vclock = info_to_vclock(ptp->info);
 
-	ns = ktime_to_ns(hwtstamps->hwtstamp);
+	if (vclock->pclock->info->getfreeruntimex64)
+		ns = ktime_to_ns(hwtstamps->hwfreeruntstamp);
+	else
+		ns = ktime_to_ns(hwtstamps->hwtstamp);
 
 	spin_lock_irqsave(&vclock->lock, flags);
 	ns = timecounter_cyc2time(&vclock->tc, ns);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2be263184d1e..2ec8d944a557 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -521,6 +521,8 @@ static inline bool skb_frag_must_loop(struct page *p)
  * struct skb_shared_hwtstamps - hardware time stamps
  * @hwtstamp:	hardware time stamp transformed into duration
  *		since arbitrary point in time
+ * @hwfreeruntstamp:	hardware time stamp based on free running time
+ *			transformed into duration since arbitrary point in time
  *
  * Software time stamps generated by ktime_get_real() are stored in
  * skb->tstamp.
@@ -533,6 +535,7 @@ static inline bool skb_frag_must_loop(struct page *p)
  */
 struct skb_shared_hwtstamps {
 	ktime_t	hwtstamp;
+	ktime_t	hwfreeruntstamp;
 };
 
 /* Definitions for tx_flags in struct skb_shared_info */
-- 
2.20.1

