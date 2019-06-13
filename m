Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1DE144AA9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfFMS2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:28:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbfFMS2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:28:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF9073E2B9;
        Thu, 13 Jun 2019 18:28:32 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-44.brq.redhat.com [10.40.200.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 271905D9C6;
        Thu, 13 Jun 2019 18:28:28 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 5011131256FCA;
        Thu, 13 Jun 2019 20:28:27 +0200 (CEST)
Subject: [PATCH net-next v1 05/11] veth: use xdp_release_frame for XDP_PASS
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Thu, 13 Jun 2019 20:28:27 +0200
Message-ID: <156045050726.29115.1623203277975334291.stgit@firesoul>
In-Reply-To: <156045046024.29115.11802895015973488428.stgit@firesoul>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 13 Jun 2019 18:28:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like cpumap use xdp_release_frame() when an xdp_frame got
converted into an SKB and send towars the network stack.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/veth.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 52110e54e621..c6916bf1017b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -547,6 +547,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 		goto err;
 	}
 
+	xdp_release_frame(frame);
 	xdp_scrub_frame(frame);
 	skb->protocol = eth_type_trans(skb, rq->dev);
 err:

