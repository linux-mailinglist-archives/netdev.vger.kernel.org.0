Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE91D0796
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgEMG2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbgEMG2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF98C061A0E;
        Tue, 12 May 2020 23:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8TT2PxSsEHipT+e5nSL6DhUaWirp80j0qmDh4nmGKY8=; b=eiafrt7nHqCNDveJ9gIe9E9pgO
        QmFtEivvTMNAlSTpjQqGiinbccIYJpAjA983x/pBULlX0DWFGtN3Ue6Kc9mUgY54gWgOhle20hcvG
        7Q/l8DlKedLblAfymab8XyOufMUKyts5b5yvP77ZC/rCin0PckQdwJWVhLWch3GSstZDgTm98DOpF
        fCErxg2KksDxfRgQJn3oF+4/yUQk1b6vp899x1/0FRbNu8DjSUuUDC5F0CX2PZKpzmQv6hrjeuVi3
        U8ob0+DxLHA7yij0KM2glbwmY2qM4h6gKGd6viPFEFRxjYk5SZWfg2NIK2Q5B9jMAOEW0oYtlOh0Q
        2F2vwKTw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkra-0004KK-Q3; Wed, 13 May 2020 06:27:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: [PATCH 13/33] tcp: add tcp_sock_set_syncnt
Date:   Wed, 13 May 2020 08:26:28 +0200
Message-Id: <20200513062649.2100053-14-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to directly set the TCP_SYNCNT sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/tcp.c |  9 +--------
 include/linux/tcp.h     |  1 +
 net/ipv4/tcp.c          | 12 ++++++++++++
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a8070f93fd0a0..8417eeb83fcd2 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1336,14 +1336,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	}
 
 	/* Single syn retry */
-	opt = 1;
-	ret = kernel_setsockopt(queue->sock, IPPROTO_TCP, TCP_SYNCNT,
-			(char *)&opt, sizeof(opt));
-	if (ret) {
-		dev_err(nctrl->device,
-			"failed to set TCP_SYNCNT sock opt %d\n", ret);
-		goto err_sock;
-	}
+	tcp_sock_set_syncnt(queue->sock->sk, 1);
 
 	/* Set TCP no delay */
 	tcp_sock_set_nodelay(queue->sock->sk, true);
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index e7ab6da5111b5..77b832acf3398 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -497,5 +497,6 @@ int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
 void tcp_sock_set_cork(struct sock *sk, bool on);
 void tcp_sock_set_nodelay(struct sock *sk, bool on);
 void tcp_sock_set_quickack(struct sock *sk, int val);
+int tcp_sock_set_syncnt(struct sock *sk, int val);
 
 #endif	/* _LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c681f43f0bb85..773b5cd366ab7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2870,6 +2870,18 @@ void tcp_sock_set_quickack(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(tcp_sock_set_quickack);
 
+int tcp_sock_set_syncnt(struct sock *sk, int val)
+{
+	if (val < 1 || val > MAX_TCP_SYNCNT)
+		return -EINVAL;
+
+	lock_sock(sk);
+	inet_csk(sk)->icsk_syn_retries = val;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(tcp_sock_set_syncnt);
+
 /*
  *	Socket option code for TCP.
  */
-- 
2.26.2

