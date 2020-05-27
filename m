Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E831E441F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388627AbgE0NoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:44:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40172 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387581AbgE0NoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590587062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHdNUCVNAZm2pzCNHWU6yV+i0OLxTCqdd8WctHIqMIU=;
        b=WrejjbJPnQXAFDcmJfB5QsEyVre+53q5XYZHtVaYanWfa4YZEHfSUE5wgX+09UGel2aajf
        1/iOE99FgXoXwwZ3scnkaBUWnofieUB3c6TAHfTzLHDQ860yiOW4FoSp+8cFqcEEhlN8q0
        Nc2xFLoBjvER5tZ/i7nDfQd1laItWGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-tbFpAf3iNnWzntCT9g5HTg-1; Wed, 27 May 2020 09:44:20 -0400
X-MC-Unique: tbFpAf3iNnWzntCT9g5HTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80769100960F;
        Wed, 27 May 2020 13:44:13 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79DF179598;
        Wed, 27 May 2020 13:44:10 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7158B300012C9;
        Wed, 27 May 2020 15:44:09 +0200 (CEST)
Subject: [PATCH net-next] mlx5: fix xdp data_meta setup in mlx5e_fill_xdp_buff
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 27 May 2020 15:44:09 +0200
Message-ID: <159058704935.247267.18235681992710936316.stgit@firesoul>
In-Reply-To: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
References: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper function xdp_set_data_meta_invalid() must be called after
setting xdp->data as it depends on it.

The bug was introduced in 39d6443c8daf ("mlx5, xsk: Migrate to
new MEM_TYPE_XSK_BUFF_POOL"), and cause the kernel to crash when
using BPF helper bpf_xdp_adjust_head() on mlx5 driver.

Fixes: 39d6443c8daf ("mlx5, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Reported-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6b3c82da199c..dbb1c6323967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1056,8 +1056,8 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 				u32 len, struct xdp_buff *xdp)
 {
 	xdp->data_hard_start = va;
-	xdp_set_data_meta_invalid(xdp);
 	xdp->data = va + headroom;
+	xdp_set_data_meta_invalid(xdp);
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &rq->xdp_rxq;
 	xdp->frame_sz = rq->buff.frame0_sz;


