Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEB018875
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 12:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfEIKm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 06:42:28 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:44368 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIKm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 06:42:28 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2019 06:42:26 EDT
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 98316100140;
        Thu,  9 May 2019 12:34:48 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 6C4D97A8;
        Thu,  9 May 2019 12:34:48 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.26,VDF=8.16.14.118)
X-Spam-Status: 
X-Spam-Level: 0
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id 7513D760;
        Thu,  9 May 2019 12:34:46 +0200 (CEST)
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        thomas.jarosch@intra2net.com
Subject: [PATCH] e1000e: Work around hardware unit hang by disabling TSO
Date:   Thu, 09 May 2019 12:34:46 +0200
Message-ID: <1623942.pXzBnfQ100@rocinante.m.i2n>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When forwarding traffic to a client behind NAT, some e1000e devices
become unstable, hanging and then being reset by the watchdog.

Output from syslog:

kernel: e1000e 0000:00:19.0 eth0: Detected Hardware Unit Hang:
kernel:  TDH                  <5f>
kernel:  TDT                  <8d>
kernel:  next_to_use          <8d>
kernel:  next_to_clean        <5c>
kernel: buffer_info[next_to_clean]:
kernel:  time_stamp           <6bd7b>
kernel:  next_to_watch        <5f>
kernel:  jiffies              <6c180>
kernel:  next_to_watch.status <0>
kernel: MAC Status             <40080083>
kernel: PHY Status             <796d>
kernel: PHY 1000BASE-T Status  <7800>
kernel: PHY Extended Status    <3000>
kernel: PCI Status             <10>
kernel: e1000e 0000:00:19.0 eth0: Reset adapter unexpectedly

This repeats several times and never recovers.

Disabling TCP segmentation offload (TSO) seems to be the only way to
work around this problem on the affected devices.

This issue was first reported in 14.01.2015:
https://marc.info/?l=linux-netdev&m=142124954120315

Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 8b11682ebba2..4781a45c1047 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6936,6 +6936,12 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 	if ((hw->mac.type >= e1000_pch2lan) && (netdev->mtu > ETH_DATA_LEN))
 		features &= ~NETIF_F_RXFCS;
 
+	if (adapter->pdev->device == E1000_DEV_ID_PCH2_LV_V) {
+		e_info("Disabling TSO on problematic device to avoid hardware unit hang.\n");
+		features &= ~NETIF_F_TSO;
+		features &= ~NETIF_F_TSO6;
+	}
+
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-- 
2.20.1




