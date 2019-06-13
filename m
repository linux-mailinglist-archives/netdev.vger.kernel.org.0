Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26F044AA7
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfFMS22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfFMS22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:28:28 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 54F8F4E919;
        Thu, 13 Jun 2019 18:28:19 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-44.brq.redhat.com [10.40.200.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 046781001B18;
        Thu, 13 Jun 2019 18:28:18 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2CC9B3009AEFD;
        Thu, 13 Jun 2019 20:28:17 +0200 (CEST)
Subject: [PATCH net-next v1 03/11] xdp: fix leak of IDA cyclic id if
 rhashtable_insert_slow fails
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Thu, 13 Jun 2019 20:28:17 +0200
Message-ID: <156045049711.29115.2664025005921561636.stgit@firesoul>
In-Reply-To: <156045046024.29115.11802895015973488428.stgit@firesoul>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 13 Jun 2019 18:28:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix error handling case, where inserting ID with rhashtable_insert_slow
fails in xdp_rxq_info_reg_mem_model, which leads to never releasing the IDA
ID, as the lookup in xdp_rxq_info_unreg_mem_model fails and thus
ida_simple_remove() is never called.

Fix by releasing ID via ida_simple_remove(), and mark xdp_rxq->mem.id with
zero, which is already checked in xdp_rxq_info_unreg_mem_model().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 net/core/xdp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4b2b194f4f1f..762abeb89847 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -301,6 +301,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
 	if (IS_ERR(ptr)) {
+		ida_simple_remove(&mem_id_pool, xdp_rxq->mem.id);
+		xdp_rxq->mem.id = 0;
 		errno = PTR_ERR(ptr);
 		goto err;
 	}

