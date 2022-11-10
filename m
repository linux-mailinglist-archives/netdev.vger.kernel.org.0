Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047A3623CAB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 08:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiKJHbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 02:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiKJHbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 02:31:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D35326D3;
        Wed,  9 Nov 2022 23:31:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so924070pji.0;
        Wed, 09 Nov 2022 23:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LbZXKKBD741m+fy6007yuueCSdvbrC+LAzehJa3fqi0=;
        b=FgzPsL8ax5mT2Bx8DVZYtSR68TPTIHcMPKgj5umNdVXzl9C9eOgrDvGpwbuYdcFmBZ
         +pcvufsen3b2SgWV7d9w6YAj3qLaH0gNN1itq57ioTny+RSl+Dz/Xv2L7RtjyIMfWwHC
         RJYZgroCvo6H7nob09QKqMwov02fM/yqnobI00nIyu+vJ/+jEE5nTqwAzGJ6Yiu+amdT
         3lPCFfiqtcL5ZwcN+w6f4/CAy3wRYiiomgn+iZFNJKt+M8T5syYucOoeCQ+Ph56aac+6
         i6BKSMzhwtTF96199xMWzgkcq8A5Oq3rLyFPrBLJkvp9QtuDTSaLF36lBRJqBFuRbcRe
         rgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbZXKKBD741m+fy6007yuueCSdvbrC+LAzehJa3fqi0=;
        b=zceDs8idgX+UhhJLTKpOWRyJD7Nm8DOjN0ZhCz0McWG9q4+d4zFTvJhITMEJcvV7DH
         /8Z9fnOddFSaFKyqjEshm/94aKDey4rzJB3OUzz8GF1/4xQSMIKswcE0tENbRRuIlB8C
         HCrl7J48hLjtAhUeI9lWUIfbLRM57tKzcAkTNj4qzjckeSVkMGF4GTOwgdl3XwyB3dRb
         PxGiLpfBfV+0aqvCglBJvTQJe6atlmIQ9AY7ufKkYqvxfH0oqYdou8L8/sJZ7GjCBEVN
         YO9IiokvwGVXk15xqHoh6io4zqrdFHs20npxSL2LvE6ndMy5047W3iWUmiDH066M6pOP
         eTxA==
X-Gm-Message-State: ACrzQf0iDcz1khAk2TBWrJQkimFPhj5Hsgtg012R1QpE3Mze8IL/4vej
        NvI67tAAWzmzPBfdLSlGWYc=
X-Google-Smtp-Source: AMsMyM6GNAP4EgSrMpzo2FjpKbIL1XTfylmWsdvmXcdLKjvpFx45AylRfUKfT/z+iOaYHtYLzw59mw==
X-Received: by 2002:a17:90a:e7ce:b0:213:589b:cdaf with SMTP id kb14-20020a17090ae7ce00b00213589bcdafmr79963350pjb.186.1668065502331;
        Wed, 09 Nov 2022 23:31:42 -0800 (PST)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id u8-20020a1709026e0800b0017bb38e4588sm10382197plk.135.2022.11.09.23.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 23:31:41 -0800 (PST)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: tun: rebuild error handling in tun_get_user
Date:   Thu, 10 Nov 2022 15:31:25 +0800
Message-Id: <20221110073125.692259-1-nashuiliang@gmail.com>
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
v1 -> v2:
- fix problems based on Jakub Kicinski's comments

v0 -> v1:
- rename tags

 drivers/net/tun.c | 65 +++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4bf2b268df4a..27109d1fd187 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1746,7 +1746,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	u32 rxhash = 0;
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
-	enum skb_drop_reason drop_reason;
+	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1807,10 +1807,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 * skb was created with generic XDP routine.
 		 */
 		skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);
-		if (IS_ERR(skb)) {
-			dev_core_stats_rx_dropped_inc(tun->dev);
-			return PTR_ERR(skb);
-		}
+		err = PTR_ERR_OR_ZERO(skb);
+		if (err)
+			goto drop;
 		if (!skb)
 			return total_len;
 	} else {
@@ -1835,13 +1834,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					    noblock);
 		}
 
-		if (IS_ERR(skb)) {
-			if (PTR_ERR(skb) != -EAGAIN)
-				dev_core_stats_rx_dropped_inc(tun->dev);
-			if (frags)
-				mutex_unlock(&tfile->napi_mutex);
-			return PTR_ERR(skb);
-		}
+		err = PTR_ERR_OR_ZERO(skb);
+		if (err)
+			goto drop;
 
 		if (zerocopy)
 			err = zerocopy_sg_from_iter(skb, from);
@@ -1851,27 +1846,14 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
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
+		goto free_skb;
 	}
 
 	switch (tun->flags & TUN_TYPE_MASK) {
@@ -1887,9 +1869,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 				pi.proto = htons(ETH_P_IPV6);
 				break;
 			default:
-				dev_core_stats_rx_dropped_inc(tun->dev);
-				kfree_skb(skb);
-				return -EINVAL;
+				err = -EINVAL;
+				goto drop;
 			}
 		}
 
@@ -1931,11 +1912,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			if (ret != XDP_PASS) {
 				rcu_read_unlock();
 				local_bh_enable();
-				if (frags) {
-					tfile->napi.skb = NULL;
-					mutex_unlock(&tfile->napi_mutex);
-				}
-				return total_len;
+				goto unlock_frags;
 			}
 		}
 		rcu_read_unlock();
@@ -2008,6 +1985,22 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		tun_flow_update(tun, rxhash, tfile);
 
 	return total_len;
+
+drop:
+	if (err != -EAGAIN)
+		dev_core_stats_rx_dropped_inc(tun->dev);
+
+free_skb:
+	if (!IS_ERR_OR_NULL(skb))
+		kfree_skb_reason(skb, drop_reason);
+
+unlock_frags:
+	if (frags) {
+		tfile->napi.skb = NULL;
+		mutex_unlock(&tfile->napi_mutex);
+	}
+
+	return err ?: total_len;
 }
 
 static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
-- 
2.37.2

