Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C2F22AE12
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgGWLnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgGWLnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:51 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 086B422B43;
        Thu, 23 Jul 2020 11:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504630;
        bh=5TlIfe9dJYm9MAMwsEV8WNJ4SLcVkvHN3n0gxW90yqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVu6t0cIYGYG7t7/ZZKFn7NjMEs7PzFMCaptTyI0jFj4TFC+10Xta15VMP3J+mnBX
         Pv1C4gQ+Wm59KMXz9podgJqwtmVedULbhYPQZWUoLOanSWoyk4JxHF+vwGA4pc2ikO
         WT53melqleqijEknoYmVkniB+FqVd2NnsrKnMYp0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 17/22] net: tun: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:29 +0200
Message-Id: <f514de2ba0218f57b8803bfc3dcacc14786ee2e8.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/tun.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7adeb91bd368..7007fc344460 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1674,6 +1674,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		xdp.data_end = xdp.data + len;
 		xdp.rxq = &tfile->xdp_rxq;
 		xdp.frame_sz = buflen;
+		xdp.mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
@@ -2421,6 +2422,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 		xdp_set_data_meta_invalid(xdp);
 		xdp->rxq = &tfile->xdp_rxq;
 		xdp->frame_sz = buflen;
+		xdp->mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 		err = tun_xdp_act(tun, xdp_prog, xdp, act);
-- 
2.26.2

