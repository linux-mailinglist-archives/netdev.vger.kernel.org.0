Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9964A82088
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbfHEPlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:41:46 -0400
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:43047 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfHEPlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 11:41:45 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2019 11:41:44 EDT
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=ross.lagerwall@citrix.com; spf=Pass smtp.mailfrom=ross.lagerwall@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa3.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  ross.lagerwall@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa3.hc3370-68.iphmx.com;
  envelope-from="ross.lagerwall@citrix.com";
  x-sender="ross.lagerwall@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa3.hc3370-68.iphmx.com: domain of
  ross.lagerwall@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa3.hc3370-68.iphmx.com;
  envelope-from="ross.lagerwall@citrix.com";
  x-sender="ross.lagerwall@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83 ~all"
Received-SPF: None (esa3.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa3.hc3370-68.iphmx.com;
  envelope-from="ross.lagerwall@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: MG3ZYEtER2WNBLk7cKJNOdkkcuRS1CfcERDgx+KKeOAZ18birOSwVaDoGmN6J5wHyqDQuNDlPo
 2NMP/2mVtpyvDFsDetJxnpfrW62aypu0V88gQNBuncwFTW4ERaK4LcQ5Yim3TVEPVBLsctvPNu
 POCTx4WHjJdznFWGZlWrdXHDb9DPv4N3W4CvLmcgUI+QW2gyVvI6JEeLWS+x7lTTyC2SXUqAP9
 nQ+DN+jzSXNcFnY+rTEx8Fdt+FA34PQ0zoc7N8tZJPVjhAojTm1my0ZBmZCZd918eQxIJ1kxWk
 hv8=
X-SBRS: 2.7
X-MesageID: 3880647
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.64,350,1559534400"; 
   d="scan'208";a="3880647"
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
To:     <netdev@vger.kernel.org>
CC:     <xen-devel@lists.xenproject.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Durrant <paul.durrant@citrix.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Ross Lagerwall" <ross.lagerwall@citrix.com>
Subject: [PATCH] xen/netback: Reset nr_frags before freeing skb
Date:   Mon, 5 Aug 2019 16:34:34 +0100
Message-ID: <20190805153434.12144-1-ross.lagerwall@citrix.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this point nr_frags has been incremented but the frag does not yet
have a page assigned so freeing the skb results in a crash. Reset
nr_frags before freeing the skb to prevent this.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
---
 drivers/net/xen-netback/netback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1d9940d4e8c7..c9262ffeefe4 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -925,6 +925,7 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 			skb_shinfo(skb)->nr_frags = MAX_SKB_FRAGS;
 			nskb = xenvif_alloc_skb(0);
 			if (unlikely(nskb == NULL)) {
+				skb_shinfo(skb)->nr_frags = 0;
 				kfree_skb(skb);
 				xenvif_tx_err(queue, &txreq, extra_count, idx);
 				if (net_ratelimit())
@@ -940,6 +941,7 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 
 			if (xenvif_set_skb_gso(queue->vif, skb, gso)) {
 				/* Failure in xenvif_set_skb_gso is fatal. */
+				skb_shinfo(skb)->nr_frags = 0;
 				kfree_skb(skb);
 				kfree_skb(nskb);
 				break;
-- 
2.17.2

