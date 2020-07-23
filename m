Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D92722ADF5
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgGWLnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgGWLnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:12 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A5C922B43;
        Thu, 23 Jul 2020 11:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504591;
        bh=kIdzdnR5oMJlEqKbVwcJr7xWuFT9MuTFnSq8zco5Xws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1frIJa5m8+u37LaF1Mq/PEe9zEkoVzOV12IBTUixGUwiVESGkZk1AdQZwRaLZKGR
         iGb9axurJNnGObf8PrCFkDKYgt5lPQoFZrS5yt3dpI0/8GetzTNNrgz2Di+IWDoMnL
         OwucPUF5JlYRv2kHtNQsTvTLvcuTWJ+KTsQmKWPs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 03/22] net: virtio_net: initialize mb bit of xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:15 +0200
Message-Id: <f7b4192b77bf24b43f4cb54098aabaedd5fc06cf.1595503780.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1595503780.git.lorenzo@kernel.org>
References: <cover.1595503780.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize multi-buffer bit (mb) to 0 in xdp_buff data structure.
This is a preliminary patch to enable xdp multi-buffer support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/virtio_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba38765dc490..100fa9b60026 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -690,6 +690,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		xdp.frame_sz = buflen;
+		xdp.mb = 0;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
@@ -860,6 +861,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		xdp.frame_sz = frame_sz - vi->hdr_len;
+		xdp.mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
-- 
2.26.2

