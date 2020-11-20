Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E20D2BB41D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbgKTSkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731641AbgKTSkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:40:39 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C64782242B;
        Fri, 20 Nov 2020 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897638;
        bh=nvGQ358IdnZ1yymOehQFBhd6nEfksDWCdHl95U47kz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cr3cakHzfRciZcI88G0gdU7jQpNQUWk0Apktg62cStEuHpFlfn1aghIzdBaP/p/xL
         FxB2qFjn97+OQxbVVztTkDIDE0weCl0Y1g8IqeVypY2TZQMYmyborc5/kQD8H6qPwO
         6D34ixS3+h+g5Udk0CCF5NDjUvAkEdxDMU2UDV2g=
Date:   Fri, 20 Nov 2020 12:40:44 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 136/141] virtio_net: Fix fall-through warnings for Clang
Message-ID: <cb9b9534572bc476f4fb7b49a73dc8646b780c84.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a goto statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/virtio_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..fd326dc586aa 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -732,6 +732,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(vi->dev, xdp_prog, act);
+			goto err_xdp;
 		case XDP_DROP:
 			goto err_xdp;
 		}
-- 
2.27.0

