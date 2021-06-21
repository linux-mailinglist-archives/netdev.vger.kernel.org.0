Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED403AE174
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhFUBl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhFUBlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:20 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BB6C0617AD;
        Sun, 20 Jun 2021 18:39:03 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id r20so12306988qtp.3;
        Sun, 20 Jun 2021 18:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EsLFUQkwoY2X1cIK9k/Du8AhRVxEvbbwUfgHGtcJi3M=;
        b=oVKCAyQmJtAdBwDd7pY+03eCLxDwGKZ2TFpOL4QJKXPC72EqLm00Z4NWXG32QhOzWg
         k7Q5yOxUQPHHZN3Rr2tj2r1yzewqBbJh6VJ4srlHa/7Z2WtZGlzMfoylkOgcxg5iW7nR
         76t0Xnnwm8so41KowF97WEP9ZQR0GKtrw7TKwehR+KnSlV+JiUHfnC+PsPn+aMHr+Zwx
         I6z/2voTu6Q38Ge4jnPJ9yVnC2Mr+Bbu7DJNmG85VSQ0S8zNmO9x60nZhy3UAAazfLka
         H0HDKu4ZaXD41F3wpjiiEoqs5GM0HIboCCZd5i2OQwjq8fDktmKTI7nd4QOzVT1TWpic
         NnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EsLFUQkwoY2X1cIK9k/Du8AhRVxEvbbwUfgHGtcJi3M=;
        b=nWpO078EPWi5RuSoZRvHbrVllPkwYRZlWgC/IuOHLVBGaaBcAXPKKZojCRwABwgTfo
         lukpl/oj8ueUGIlJVAAQv6iksvNzzfx4IOJGIjsc7rj8iAXXNFymotR5IxkjCcaeHSxv
         pGzgtgtXR6yEzaNBcq9VV1C3QWR3q4bbcQqIdY6JnZw2jrB7lR3GVajrhYa5nRqkBPfD
         xGmw8kI0NUPY8Kfl6IRSTJS4J73bZXpxQTIyaWlsEsSvpNBgdUP9D0CfixNP2WuGtkKj
         CCprMOl6Rvl7zERQjuQY5ABbeBZ8a9Vcg3uXu1g/m/RTdj/a7oqauNTKoU8XbYzaBPEG
         ybNQ==
X-Gm-Message-State: AOAM531Vg+b4e43xOFV7VcunzBaC7CfioDUI+as1KyfONnyoAioDip9n
        l9A1v1DoXpIDuCJ7rIkXjxWtMRDkYND8vg==
X-Google-Smtp-Source: ABdhPJzKUfeMx286z+N5z78FLYGTWtNTxykMgh0qc4f6byDn1l5dAE1EPiv2P4ccoIumhmIlsAjjGg==
X-Received: by 2002:ac8:60ce:: with SMTP id i14mr22043755qtm.262.1624239542982;
        Sun, 20 Jun 2021 18:39:02 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t4sm9219108qke.7.2021.06.20.18.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:39:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 11/14] sctp: remove the unessessary hold for idev in sctp_v6_err
Date:   Sun, 20 Jun 2021 21:38:46 -0400
Message-Id: <156f251cbf9f0d94d3c0ecc44f027f54f889e033.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same as in tcp_v6_err() and __udp6_lib_err(), there's no need to
hold idev in sctp_v6_err(), so just call __in6_dev_get() instead.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index bd08807c9e44..50ed4de18069 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -126,7 +126,6 @@ static struct notifier_block sctp_inet6addr_notifier = {
 static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			u8 type, u8 code, int offset, __be32 info)
 {
-	struct inet6_dev *idev;
 	struct sock *sk;
 	struct sctp_association *asoc;
 	struct sctp_transport *transport;
@@ -135,8 +134,6 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	int err, ret = 0;
 	struct net *net = dev_net(skb->dev);
 
-	idev = in6_dev_get(skb->dev);
-
 	/* Fix up skb to look at the embedded net header. */
 	saveip	 = skb->network_header;
 	savesctp = skb->transport_header;
@@ -147,9 +144,8 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	skb->network_header   = saveip;
 	skb->transport_header = savesctp;
 	if (!sk) {
-		__ICMP6_INC_STATS(net, idev, ICMP6_MIB_INERRORS);
-		ret = -ENOENT;
-		goto out;
+		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+		return -ENOENT;
 	}
 
 	/* Warning:  The sock lock is held.  Remember to call
@@ -185,10 +181,6 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 out_unlock:
 	sctp_err_finish(sk, transport);
-out:
-	if (likely(idev != NULL))
-		in6_dev_put(idev);
-
 	return ret;
 }
 
-- 
2.27.0

