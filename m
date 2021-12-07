Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB9046B1B5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhLGEFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbhLGEFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:05:46 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B990C061A83
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:02:16 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id m25so13057747qtq.13
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 20:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KKIA9qDj8FQn55+aSvd8YOlaLj0ctyi5Ud6rJva2cPo=;
        b=omCi8t53spfqpIA6MrSYwRhm7ziHeeokGLK6byYkxqVvzkonGA4qlwg6d96ioyo0D+
         7W7LSo1Y90tpu91lladJLkXakH3HzQAIYkHjOzcOwcIY5boMOn66kYdR7vQaE/zPgmLT
         owZO9cVngbxbeqz1IinUecn7nSwO6bf7F6QLMQn3Pg/nR9d1UmaA60ByQqvUlYngkK2T
         IoeAtych2vtvEng1IwNjAPz82iPQdQ/yo8I0JVKIZDEABRqwyE/rUt6K88xQ5AgJhzTo
         lHjQH+6jolhlG1jykSWs1UMy2k55Es1xdpWevZaDHtq5rTEB9p4FFyL+sg5LSV/Z4boJ
         pzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KKIA9qDj8FQn55+aSvd8YOlaLj0ctyi5Ud6rJva2cPo=;
        b=QrKx1Au1mJ3Vh6Kpy9wZ5xd0gmh2OH9Gl0QMqKooLch6Z6OAeRyPcAtANJRV55mFc7
         W3x/I6bpS53mRTooxhObcPcphV57P7N8dwudAaubwZjBOIV+g7fcHWE/ScXiHaZeUb13
         HYWHk/tgYHP+MNvcVbOOl9O51kOVc/aAuhLiEy0hobef+f4KBNYqt6F7hyAjtlmCUzuR
         TCeUN3EBZ4yu+K9IDb0qghVIK2/YzN0v2aB5vHyUaweyqBRAwBFRXDbwpTZcabGxNIjD
         N70hkxoPAgd2qWq3jwVKnFWYq2t4lp0PzBtP6SnKvuPlxguASVaZkjooPm2aCTeFvqFG
         QzvQ==
X-Gm-Message-State: AOAM530UWpD3KqSiDJxxGwAzVgMypD0PSIFFYfogveQOkXEylBtHbcTx
        b6OJZyV2oU8f/fzASCME9JBgNU36gJYtsA==
X-Google-Smtp-Source: ABdhPJz5ZSL/KG2mBV5yAklPTEqtwqvjRo4CCLuKSueZ0ZobFDSRHeWv2NipKpyuPTMp89tWHabQ1A==
X-Received: by 2002:ac8:5e13:: with SMTP id h19mr44926589qtx.413.1638849735470;
        Mon, 06 Dec 2021 20:02:15 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 14sm8526393qtx.84.2021.12.06.20.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 20:02:14 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 5/5] net: track xfrm_state refcnt with obj_cnt
Date:   Mon,  6 Dec 2021 23:02:08 -0500
Message-Id: <4f368b30a1dd6434a7cbe473c6b8d5a50565e3ad.1638849511.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1638849511.git.lucien.xin@gmail.com>
References: <cover.1638849511.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two types are added into obj_cnt to count xfrm_state_hold and
xfrm_state_put*, and all it does is put obj_cnt_track_by_index()
into these two functions.

Here is a example to track the refcnt of a xfrm_state whose spi
is 0x100:

  # sysctl -w obj_cnt.control="clear" # clear the old result

  # sysctl -w obj_cnt.type=0xc0    # enable xfrm_state_hold/put track
  # sysctl -w obj_cnt.index=0x100  # count xfrm_state_hold/put(state)
  # sysctl -w obj_cnt.nr_entries=4 # save 4 frames' call trace

  # ip link add dummy0 type dummy
  # ip link set dummy0 up
  # ip addr add 1.1.1.1/24 dev dummy0
  # ip xfrm state add src 1.1.1.1 dst 1.1.1.2 spi 0x100 proto esp enc aes \
    0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f \
    mode tunnel sel src 1.1.1.1 dst 1.1.1.2
  # ip xfrm policy add dir out src 1.1.1.1 dst 1.1.1.2 tmpl src 1.1.1.1 \
    dst 1.1.1.2 proto esp mode tunnel
  # ping 1.1.1.2 -c 1
  # ip link set dummy0 down
  # ip link del dummy0

  # sysctl -w obj_cnt.control="scan"  # print the new result
  # dmesg
  OBJ_CNT: obj_cnt_dump: obj: ffff8ca629cb0f00, type: xfrm_state_hold, cnt: 1,:
       xfrm_add_sa+0x476/0x5f0
       xfrm_user_rcv_msg+0x13c/0x250
       netlink_rcv_skb+0x50/0x100
       xfrm_netlink_rcv+0x30/0x40
  OBJ_CNT: obj_cnt_dump: obj: ffff8ca629cb0f00, type: xfrm_state_put, cnt: 2,:
       xfrm4_dst_destroy+0x110/0x130
       dst_destroy+0x37/0xe0
       rcu_do_batch+0x164/0x4b0
       rcu_core+0x249/0x350
  OBJ_CNT: obj_cnt_dump: obj: ffff8ca629cb0f00, type: xfrm_state_put, cnt: 1,:
       xfrm_add_sa+0x497/0x5f0
       xfrm_user_rcv_msg+0x13c/0x250
       netlink_rcv_skb+0x50/0x100
       xfrm_netlink_rcv+0x30/0x40

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/obj_cnt.h |  2 ++
 include/net/xfrm.h      | 11 +++++++++++
 lib/obj_cnt.c           |  4 +++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/obj_cnt.h b/include/linux/obj_cnt.h
index f014b2e613d9..42611aa321c7 100644
--- a/include/linux/obj_cnt.h
+++ b/include/linux/obj_cnt.h
@@ -9,6 +9,8 @@ enum {
 	OBJ_CNT_DST_PUT,
 	OBJ_CNT_IN6_DEV_HOLD,
 	OBJ_CNT_IN6_DEV_PUT,
+	OBJ_CNT_XFRM_STATE_HOLD,
+	OBJ_CNT_XFRM_STATE_PUT,
 	OBJ_CNT_TYPE_MAX
 };
 
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2308210793a0..543840fba068 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -772,25 +772,36 @@ static inline void xfrm_pols_put(struct xfrm_policy **pols, int npols)
 
 void __xfrm_state_destroy(struct xfrm_state *, bool);
 
+static inline void obj_cnt_track_by_index(void *obj, int index, int type)
+{
+#ifdef CONFIG_OBJ_CNT
+	obj_cnt_track(type, index, NULL, obj);
+#endif
+}
+
 static inline void __xfrm_state_put(struct xfrm_state *x)
 {
+	obj_cnt_track_by_index(x, ntohl(x->id.spi), OBJ_CNT_XFRM_STATE_PUT);
 	refcount_dec(&x->refcnt);
 }
 
 static inline void xfrm_state_put(struct xfrm_state *x)
 {
+	obj_cnt_track_by_index(x, ntohl(x->id.spi), OBJ_CNT_XFRM_STATE_PUT);
 	if (refcount_dec_and_test(&x->refcnt))
 		__xfrm_state_destroy(x, false);
 }
 
 static inline void xfrm_state_put_sync(struct xfrm_state *x)
 {
+	obj_cnt_track_by_index(x, ntohl(x->id.spi), OBJ_CNT_XFRM_STATE_PUT);
 	if (refcount_dec_and_test(&x->refcnt))
 		__xfrm_state_destroy(x, true);
 }
 
 static inline void xfrm_state_hold(struct xfrm_state *x)
 {
+	obj_cnt_track_by_index(x, ntohl(x->id.spi), OBJ_CNT_XFRM_STATE_HOLD);
 	refcount_inc(&x->refcnt);
 }
 
diff --git a/lib/obj_cnt.c b/lib/obj_cnt.c
index 8756efc005ed..f054455abe8d 100644
--- a/lib/obj_cnt.c
+++ b/lib/obj_cnt.c
@@ -20,7 +20,9 @@ static char *obj_cnt_str[OBJ_CNT_TYPE_MAX] = {
 	"dst_hold",
 	"dst_put",
 	"in6_dev_hold",
-	"in6_dev_put"
+	"in6_dev_put",
+	"xfrm_state_hold",
+	"xfrm_state_put"
 };
 
 struct obj_cnt {
-- 
2.27.0

