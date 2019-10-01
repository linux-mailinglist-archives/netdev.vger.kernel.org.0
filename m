Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A5DC3C68
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389145AbfJAQv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387568AbfJAQoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8AC22168B;
        Tue,  1 Oct 2019 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948249;
        bh=EXhLy80jshL2AnL/RgoEgzVy62LVEiun2Ah8RdegCxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkny7JW3D4blVwt8rbgMgFEwQC2kkDvq6AXRPBJTG/9UjsH53VXCfd2jgiNBsYgFu
         O/VW3Wpq/48LE6Sf72RUaDGz6CiIM1dEJsibJb7Nj+pftYze0XM297AwiqyG9Ql3RS
         41hIqG5aKaJwSx+h3m3lIcbZBjZnsKrc8y/MKuKI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        Fei Liu <feliu@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 37/43] macsec: drop skb sk before calling gro_cells_receive
Date:   Tue,  1 Oct 2019 12:43:05 -0400
Message-Id: <20191001164311.15993-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit ba56d8ce38c8252fff5b745db3899cf092578ede ]

Fei Liu reported a crash when doing netperf on a topo of macsec
dev over veth:

  [  448.919128] refcount_t: underflow; use-after-free.
  [  449.090460] Call trace:
  [  449.092895]  refcount_sub_and_test+0xb4/0xc0
  [  449.097155]  tcp_wfree+0x2c/0x150
  [  449.100460]  ip_rcv+0x1d4/0x3a8
  [  449.103591]  __netif_receive_skb_core+0x554/0xae0
  [  449.108282]  __netif_receive_skb+0x28/0x78
  [  449.112366]  netif_receive_skb_internal+0x54/0x100
  [  449.117144]  napi_gro_complete+0x70/0xc0
  [  449.121054]  napi_gro_flush+0x6c/0x90
  [  449.124703]  napi_complete_done+0x50/0x130
  [  449.128788]  gro_cell_poll+0x8c/0xa8
  [  449.132351]  net_rx_action+0x16c/0x3f8
  [  449.136088]  __do_softirq+0x128/0x320

The issue was caused by skb's true_size changed without its sk's
sk_wmem_alloc increased in tcp/skb_gro_receive(). Later when the
skb is being freed and the skb's truesize is subtracted from its
sk's sk_wmem_alloc in tcp_wfree(), underflow occurs.

macsec is calling gro_cells_receive() to receive a packet, which
actually requires skb->sk to be NULL. However when macsec dev is
over veth, it's possible the skb->sk is still set if the skb was
not unshared or expanded from the peer veth.

ip_rcv() is calling skb_orphan() to drop the skb's sk for tproxy,
but it is too late for macsec's calling gro_cells_receive(). So
fix it by dropping the skb's sk earlier on rx path of macsec.

Fixes: 5491e7c6b1a9 ("macsec: enable GRO and RPS on macsec devices")
Reported-by: Xiumei Mu <xmu@redhat.com>
Reported-by: Fei Liu <feliu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 2c971357e66cf..0dc92d2faa64d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1238,6 +1238,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		macsec_rxsa_put(rx_sa);
 	macsec_rxsc_put(rx_sc);
 
+	skb_orphan(skb);
 	ret = gro_cells_receive(&macsec->gro_cells, skb);
 	if (ret == NET_RX_SUCCESS)
 		count_rx(dev, skb->len);
-- 
2.20.1

