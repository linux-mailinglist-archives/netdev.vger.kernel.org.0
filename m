Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB71B493C40
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355298AbiASOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:53:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234438AbiASOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:53:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642603985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lrptr4WidKD4/MLy2k8jm8xw4obfrsFG7vi0+NE40Q0=;
        b=DvCDKlB+odnjNTkn6RV+UNCx5tiDXvxyA4nmZFib1xKMcyn0238r/KPV8nEAMdWvmW4dEh
        i1fY0rNkoqDbauPj/I91ccPoJgVk3ZQwAdE0YQagND5k2S/MA6AIdy21Gf5H4kfO9dV+gX
        qV3AsVfNVRCzAdGxupVmFkEGHpy6xYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-L7ZhN030PcmX3zKOiO9tKg-1; Wed, 19 Jan 2022 09:53:02 -0500
X-MC-Unique: L7ZhN030PcmX3zKOiO9tKg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DC288145E1;
        Wed, 19 Jan 2022 14:53:01 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-9.ams2.redhat.com [10.36.112.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2EC92A19F;
        Wed, 19 Jan 2022 14:53:00 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 617C2A80D72; Wed, 19 Jan 2022 15:52:59 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 1/2 net-next v6] igc: avoid kernel warning when changing RX ring parameters
Date:   Wed, 19 Jan 2022 15:52:58 +0100
Message-Id: <20220119145259.1790015-2-vinschen@redhat.com>
In-Reply-To: <20220119145259.1790015-1-vinschen@redhat.com>
References: <20220119145259.1790015-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling ethtool changing the RX ring parameters like this:

  $ ethtool -G eth0 rx 1024

on igc triggers kernel warnings like this:

[  225.198467] ------------[ cut here ]------------
[  225.198473] Missing unregister, handled but fix driver
[  225.198485] WARNING: CPU: 7 PID: 959 at net/core/xdp.c:168
xdp_rxq_info_reg+0x79/0xd0
[...]
[  225.198601] Call Trace:
[  225.198604]  <TASK>
[  225.198609]  igc_setup_rx_resources+0x3f/0xe0 [igc]
[  225.198617]  igc_ethtool_set_ringparam+0x30e/0x450 [igc]
[  225.198626]  ethnl_set_rings+0x18a/0x250
[  225.198631]  genl_family_rcv_msg_doit+0xca/0x110
[  225.198637]  genl_rcv_msg+0xce/0x1c0
[  225.198640]  ? rings_prepare_data+0x60/0x60
[  225.198644]  ? genl_get_cmd+0xd0/0xd0
[  225.198647]  netlink_rcv_skb+0x4e/0xf0
[  225.198652]  genl_rcv+0x24/0x40
[  225.198655]  netlink_unicast+0x20e/0x330
[  225.198659]  netlink_sendmsg+0x23f/0x480
[  225.198663]  sock_sendmsg+0x5b/0x60
[  225.198667]  __sys_sendto+0xf0/0x160
[  225.198671]  ? handle_mm_fault+0xb2/0x280
[  225.198676]  ? do_user_addr_fault+0x1eb/0x690
[  225.198680]  __x64_sys_sendto+0x20/0x30
[  225.198683]  do_syscall_64+0x38/0x90
[  225.198687]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  225.198693] RIP: 0033:0x7f7ae38ac3aa

igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
reset the xdp_rxq_info member before calling igc_setup_rx_resources().
This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.

Make sure to unregister the xdp_rxq_info structure first in
igc_setup_rx_resources.

Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
Reported-by: Lennert Buytenhek <buytenh@arista.com>
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 2f17f36e94fd..adfc3d7fff5d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -505,6 +505,9 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
 	u8 index = rx_ring->queue_index;
 	int size, desc_len, res;
 
+	/* XDP RX-queue info */
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
 			       rx_ring->q_vector->napi.napi_id);
 	if (res < 0) {
-- 
2.27.0

