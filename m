Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DE42D0A86
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 07:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgLGGEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 01:04:47 -0500
Received: from mail-m973.mail.163.com ([123.126.97.3]:39652 "EHLO
        mail-m973.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgLGGEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 01:04:47 -0500
X-Greylist: delayed 2851 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2020 01:04:46 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=kwm3UwvFjmZam557Kn
        GbJbf+wxK5Q0nkBvUS2h6LNVk=; b=cRZaGxzEuxC73sAsqiNnAtSaWGU6PiZcqn
        mHarORkswDocqopEJt/HKc4Pgzw+M5hZjt6ppytaZuokhiYi0YkSpJP9f6YJlcGX
        /3lZuw6i4IDfYpnoPzfM07fE6mSe/Al8c7Urzikb3GBTz4SNF9+LG0WRdwyolaCS
        vLbc0dEjo=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp3 (Coremail) with SMTP id G9xpCgDnxZ7ogc1fwWdAOQ--.44287S4;
        Mon, 07 Dec 2020 09:14:18 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ice: fix array overflow on receiving too many fragments for a packet
Date:   Mon,  7 Dec 2020 09:14:15 +0800
Message-Id: <20201207011415.463-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: G9xpCgDnxZ7ogc1fwWdAOQ--.44287S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Xw4xAw48uryxKFykXry8Grg_yoW8JrykpF
        WDKFy7Cw1kXr4Yg3W8Za9ruFs5Jw4kGrWFgrWSkrn5Zwn8Jr92qr98KFy7Cr95ZrWY9F47
        Jr4jvr95A3WrXwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UnqXdUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbipRHyMFUMa-ekYwACs2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

If the hardware receives an oversized packet with too many rx fragments,
skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
This becomes especially visible if it corrupts the freelist pointer of
a slab page.

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index eae75260f..f0f034fa5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -823,8 +823,12 @@ ice_add_rx_frag(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 
 	if (!size)
 		return;
-	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buf->page,
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
+		skb_add_rx_frag(skb, shinfo, rx_buf->page,
 			rx_buf->page_offset, size, truesize);
+	}
 
 	/* page is being used so we must update the page offset */
 	ice_rx_buf_adjust_pg_offset(rx_buf, truesize);
-- 
2.17.1

