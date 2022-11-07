Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CD761ECF7
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiKGIcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiKGIcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:32:04 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A3514002;
        Mon,  7 Nov 2022 00:32:03 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id c2so10395370plz.11;
        Mon, 07 Nov 2022 00:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BQ9Z4bc9iFOixXTMmuVqqXWRg72dHOOtqIyMVDHCuI0=;
        b=ciEc6wWN290+pHsj0unsWuRhg2OSaL7h+mJiRzgvuBUK9PYthe7IpI7JWLpI42pPBH
         lMGM3xA8cfXilotWph7PUs1DGe6NlIGg0BQW5ZfDlR4ocMJWWBWeJ1m8GrA1EoEtcC2y
         8xxXS1eIP3LVK/spN1Lah/euoh1qaRXTNG9AkIQC6jNOIlDEb5DJx10j+w0oPs6rnP5C
         LvsIXeoQwPm7mvS25W7bxfGh3H540jPma7cgF9+tvjilWnzKcrcA8+mPAxn/WgIgGuaB
         wxnTZZbnIjLuCTGsIkhlwyKQaMJnQmZO7JK1mNVMfsvqvdtSuJj5ASdquK6oEKO2Y/tY
         wN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BQ9Z4bc9iFOixXTMmuVqqXWRg72dHOOtqIyMVDHCuI0=;
        b=Ay0YUG0D/Nh9eJqgljqHHTRtiV/t3G0nLIC95JovN3KQ3t9WzUOuyTpKFmLBKyrkht
         dwYxY/9BoqGQNOgbqaGzvxiAeVNuJOb3EJaAdEdGAQTmHQvTYqL6sU2hYuljOZInAPK4
         VpYkpxI0DnXINmCBSOPc9kdDCdaR/ZQFW4uBfnVOJdFaXCk4rE1DLkNvkcgeJIrS6cL1
         T/1Sh1qdL1ZdzAYZpnqPwq6zcVkRlrs2SQ0+Mralsb/NUAd1x1Cs3sVQct4SZGKaLHG7
         jaMw+bi/N7SHGInHnMrMJmG6DTsgy1uepalJsz5vnvCs/WlQK+7y5WlhqqHQ8mQ/+Keh
         7PiA==
X-Gm-Message-State: ANoB5pnUSY5ExvLcKu+tu/faR0/bR/wO8bQF6AFk3Jy3Irfczl9tisoj
        4ZZvEXEi8qgVCWgu6NyNbf6vpl+sphY=
X-Google-Smtp-Source: AA0mqf4x9hlvHwl8La/F5SlFkVpAuwZ0Unj8UMbGtbPLhwI9sH41tZmJG1hbtJueoWmH8owdt5R8Bg==
X-Received: by 2002:a17:902:f687:b0:188:6cce:671b with SMTP id l7-20020a170902f68700b001886cce671bmr14394231plg.71.1667809922707;
        Mon, 07 Nov 2022 00:32:02 -0800 (PST)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id p1-20020a170902a40100b00177f4ef7970sm4424631plq.11.2022.11.07.00.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 00:32:02 -0800 (PST)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: tun: rebuild error handling in tun_get_user
Date:   Mon,  7 Nov 2022 16:31:44 +0800
Message-Id: <20221107083145.685824-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling in tun_get_user is very scattered.
This patch unifies error handling, reduces duplication of code, and
makes the logic clearer.

Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
 drivers/net/tun.c | 68 ++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4bf2b268df4a..6a214c2251b9 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1742,11 +1742,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	int good_linear;
 	int copylen;
 	bool zerocopy = false;
-	int err;
+	int err = 0;
 	u32 rxhash = 0;
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
-	enum skb_drop_reason drop_reason;
+	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1808,11 +1808,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 */
 		skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);
 		if (IS_ERR(skb)) {
-			dev_core_stats_rx_dropped_inc(tun->dev);
-			return PTR_ERR(skb);
+			err = PTR_ERR(skb);
+			goto drop;
 		}
 		if (!skb)
-			return total_len;
+			goto out;
 	} else {
 		if (!zerocopy) {
 			copylen = len;
@@ -1836,11 +1836,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		}
 
 		if (IS_ERR(skb)) {
-			if (PTR_ERR(skb) != -EAGAIN)
-				dev_core_stats_rx_dropped_inc(tun->dev);
-			if (frags)
-				mutex_unlock(&tfile->napi_mutex);
-			return PTR_ERR(skb);
+			err = PTR_ERR(skb);
+			goto drop;
 		}
 
 		if (zerocopy)
@@ -1851,27 +1848,14 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		if (err) {
 			err = -EFAULT;
 			drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
-drop:
-			dev_core_stats_rx_dropped_inc(tun->dev);
-			kfree_skb_reason(skb, drop_reason);
-			if (frags) {
-				tfile->napi.skb = NULL;
-				mutex_unlock(&tfile->napi_mutex);
-			}
-
-			return err;
+			goto drop;
 		}
 	}
 
 	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
-		kfree_skb(skb);
-		if (frags) {
-			tfile->napi.skb = NULL;
-			mutex_unlock(&tfile->napi_mutex);
-		}
-
-		return -EINVAL;
+		err = -EINVAL;
+		goto drop;
 	}
 
 	switch (tun->flags & TUN_TYPE_MASK) {
@@ -1887,9 +1871,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 				pi.proto = htons(ETH_P_IPV6);
 				break;
 			default:
-				dev_core_stats_rx_dropped_inc(tun->dev);
-				kfree_skb(skb);
-				return -EINVAL;
+				err = -EINVAL;
+				drop_reason = SKB_DROP_REASON_INVALID_PROTO;
+				goto drop;
 			}
 		}
 
@@ -1931,11 +1915,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			if (ret != XDP_PASS) {
 				rcu_read_unlock();
 				local_bh_enable();
-				if (frags) {
-					tfile->napi.skb = NULL;
-					mutex_unlock(&tfile->napi_mutex);
-				}
-				return total_len;
+				goto unlock_unlock;
 			}
 		}
 		rcu_read_unlock();
@@ -1952,8 +1932,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	rcu_read_lock();
 	if (unlikely(!(tun->dev->flags & IFF_UP))) {
-		err = -EIO;
 		rcu_read_unlock();
+		err = -EIO;
 		drop_reason = SKB_DROP_REASON_DEV_READY;
 		goto drop;
 	}
@@ -2007,7 +1987,23 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (rxhash)
 		tun_flow_update(tun, rxhash, tfile);
 
-	return total_len;
+	goto out;
+
+drop:
+	if (err != -EAGAIN)
+		dev_core_stats_rx_dropped_inc(tun->dev);
+
+	if (!IS_ERR_OR_NULL(skb))
+		kfree_skb_reason(skb, drop_reason);
+
+unlock_unlock:
+	if (frags) {
+		tfile->napi.skb = NULL;
+		mutex_unlock(&tfile->napi_mutex);
+	}
+
+out:
+	return err ?: total_len;
 }
 
 static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
-- 
2.37.2

