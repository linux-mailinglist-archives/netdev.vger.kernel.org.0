Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F57D4F0BAB
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 19:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359721AbiDCR6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 13:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241715AbiDCR6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 13:58:09 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D3638BC4
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 10:56:02 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id d10so3742206edj.0
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 10:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AYIelJuZzI5kgsOLCvf5vPLp/YR6VGIWXEq3pdxcCmo=;
        b=eiGAHL4cZh7nWNrnEGpELYmMmttbMCdBO85UziLxP+AnO0n2Um3NBLsUsfUIk7Fbg+
         WfilwyhlRx00QfjxOovRWPT9SuJnm2d1jUIXdIdVM4hL+4VujzEjcijcEN5JKAyy+xZS
         q18UvYXQPTXsoBH5fZkwXfVyYbSA14LQrb0yyfrQGcziZOSfZ/AvsYu246Fz64Xxt0pw
         cLtXvVwhnHnIk8EFmrfCDaiCnMW5rOngRBOMX8+M+R6xGKwab1aBxk/75poZPqXYQ1Hl
         sAf/KG0KGYkg6twXIa2Ol1KiGIhfY5ONkfrWTi5Ujt9jN2MmwxBF/aJ7Lc50/egYl26M
         vhqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AYIelJuZzI5kgsOLCvf5vPLp/YR6VGIWXEq3pdxcCmo=;
        b=TNxzWjQrdV114HN4HsPWVFU972utH+gZv4zIeAOsTIceoljoxo4YRhQjRj1Fpq0NWb
         XI6Jx8mB268tRwAEq3iwe8CCGQ8cYv/Nihc1sM6GFNknnRQ4lbfatDaCJOfwWeTis77N
         uuTYB0Gy3vj810kJrUSc5AI0YBEfxYt6+NRlZIsWd851m0Kq9gIj9PifaCrEiJo/Zwpd
         BhF0S0QX5ft8Wy9+krIxcEV34Wg1aLxCz8JiCQpAw9X03r9np+PlfzjouwaXPRZ3lq7o
         agNGyqjmBfrkjswln5MsaV+Rx48iC42P5Smvd9+wRfpESJ5QlrFZ7DJQLi0hGpLyTSDw
         QYLQ==
X-Gm-Message-State: AOAM531mzHW3mJ7fWea7w3etlj1O435tX3aAlbX8swPxzqhU7eXhSLaQ
        wTFUwsAIurm7j5EB8WEXuPwblnwyKD19ltU9
X-Google-Smtp-Source: ABdhPJx9wUDITPu0YPuN/2OhgBUELZKYtLa0jx08a1vHjVQE/iZa1EDVYbW7TGdvilBOWPsBflczOg==
X-Received: by 2002:a05:6402:50cf:b0:418:ee57:ed9 with SMTP id h15-20020a05640250cf00b00418ee570ed9mr29457360edb.37.1649008561275;
        Sun, 03 Apr 2022 10:56:01 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm3451065ejo.191.2022.04.03.10.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 10:56:00 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 3/5] ptp: Pass hwtstamp to ptp_convert_timestamp()
Date:   Sun,  3 Apr 2022 19:55:42 +0200
Message-Id: <20220403175544.26556-4-gerhard@engleder-embedded.com>
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
index 3ea7110a9d70..ed6e15ead466 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -380,17 +380,16 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
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
index 03911a3d8b33..4801aeaeb285 100644
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

