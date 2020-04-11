Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8351A5372
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 20:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgDKSo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 14:44:59 -0400
Received: from forward102o.mail.yandex.net ([37.140.190.182]:47243 "EHLO
        forward102o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726256AbgDKSo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 14:44:58 -0400
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward102o.mail.yandex.net (Yandex) with ESMTP id 47CA6668004D
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 21:44:56 +0300 (MSK)
Received: from mxback10q.mail.yandex.net (mxback10q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b4:0:640:b6ef:cb3])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 436457080006
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 21:44:56 +0300 (MSK)
Received: from vla4-a16f3368381d.qloud-c.yandex.net (vla4-a16f3368381d.qloud-c.yandex.net [2a02:6b8:c17:d85:0:640:a16f:3368])
        by mxback10q.mail.yandex.net (mxback/Yandex) with ESMTP id xAPnw2bMfK-iuEKvMnl;
        Sat, 11 Apr 2020 21:44:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586630696;
        bh=HzURmvbhKfIA42O2iys/xHZ8rtT9VsD05fWIVyztZ6k=;
        h=In-Reply-To:Subject:To:From:References:Date:Message-Id;
        b=UBI/EyT3GUAudVyVHkzQPWXXwnVZ3e9t9NlvXVCInexanOcCrFpB+VgN0/QTHAv6I
         BhFGcO4jGKpVJdWtsTMkXFVKrIV/GX66c1EwB3KcEi6xkAwKs5BTi/TkHhbmX98k2j
         MJioX3zWSTCvgG6KTsllmqxheRkEGyDzYBiaa/6c=
Authentication-Results: mxback10q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla4-a16f3368381d.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id ixtyIXP0tC-itXqPQqN;
        Sat, 11 Apr 2020 21:44:55 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Konstantin Kharlamov <Hi-Angel@yandex.ru>
To:     netdev@vger.kernel.org
Subject: [PATCH v2] scsi: cxgb3i: fix documentation for two functions
Date:   Sat, 11 Apr 2020 21:44:45 +0300
Message-Id: <20200411184445.676087-1-Hi-Angel@yandex.ru>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410184216.0a64b1c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200410184216.0a64b1c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move documentation for push_tx_frames near the push_tx_frames function,
and likewise for release_offload_resources.

And while at it, fix parameter name s/c3cn/csk in the docs.

Signed-off-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
---

v2: Jakub Kicinski: fix parameter name s/c3cn/csk

 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 524cdbcd29aa..92e163decafd 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -375,9 +375,14 @@ static inline void make_tx_data_wr(struct cxgbi_sock *csk, struct sk_buff *skb,
 	}
 }
 
+static void arp_failure_skb_discard(struct t3cdev *dev, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+}
+
 /**
  * push_tx_frames -- start transmit
- * @c3cn: the offloaded connection
+ * @csk: the offloaded connection
  * @req_completion: request wr_ack or not
  *
  * Prepends TX_DATA_WR or CPL_CLOSE_CON_REQ headers to buffers waiting in a
@@ -385,12 +390,6 @@ static inline void make_tx_data_wr(struct cxgbi_sock *csk, struct sk_buff *skb,
  * connection's lock held.  Returns the amount of send buffer space that was
  * freed as a result of sending queued data to T3.
  */
-
-static void arp_failure_skb_discard(struct t3cdev *dev, struct sk_buff *skb)
-{
-	kfree_skb(skb);
-}
-
 static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 {
 	int total_size = 0;
@@ -886,11 +885,6 @@ static int alloc_cpls(struct cxgbi_sock *csk)
 	return -ENOMEM;
 }
 
-/**
- * release_offload_resources - release offload resource
- * @c3cn: the offloaded iscsi tcp connection.
- * Release resources held by an offload connection (TID, L2T entry, etc.)
- */
 static void l2t_put(struct cxgbi_sock *csk)
 {
 	struct t3cdev *t3dev = (struct t3cdev *)csk->cdev->lldev;
@@ -902,6 +896,11 @@ static void l2t_put(struct cxgbi_sock *csk)
 	}
 }
 
+/**
+ * release_offload_resources - release offload resource
+ * @csk: the offloaded iscsi tcp connection.
+ * Release resources held by an offload connection (TID, L2T entry, etc.)
+ */
 static void release_offload_resources(struct cxgbi_sock *csk)
 {
 	struct t3cdev *t3dev = (struct t3cdev *)csk->cdev->lldev;
-- 
2.26.0

