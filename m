Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4745A624403
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiKJOPX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Nov 2022 09:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiKJOPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:15:04 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5836F366
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:14:52 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-tYU5zWHKOVyRvehJvvCKmQ-1; Thu, 10 Nov 2022 09:14:48 -0500
X-MC-Unique: tYU5zWHKOVyRvehJvvCKmQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95FB5381A731;
        Thu, 10 Nov 2022 14:14:47 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.39.193.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C4E54A9256;
        Thu, 10 Nov 2022 14:14:46 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        patryk.piotrowski@intel.com, mateusz.palczewski@intel.com,
        sassmann@kpanic.de
Subject: [PATCH net] iavf: remove INITIAL_MAC_SET to allow gARP to work properly
Date:   Thu, 10 Nov 2022 15:14:44 +0100
Message-Id: <20221110141444.1308237-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kpanic.de
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IAVF_FLAG_INITIAL_MAC_SET prevents waiting on iavf_is_mac_set_handled()
the first time the MAC is set. This breaks gratuitous ARP because the
MAC address has not been updated yet when the gARP packet is sent out.

Current behaviour:
$ echo 1 > /sys/class/net/ens4f0/device/sriov_numvfs
iavf 0000:88:02.0: MAC address: ee:04:19:14:ec:ea
$ ip addr add 192.168.1.1/24 dev ens4f0v0
$ ip link set dev ens4f0v0 up
$ echo 1 > /proc/sys/net/ipv4/conf/ens4f0v0/arp_notify
$ ip link set ens4f0v0 addr 00:11:22:33:44:55
07:23:41.676611 ee:04:19:14:ec:ea > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 192.168.1.1 tell 192.168.1.1, length 28

With IAVF_FLAG_INITIAL_MAC_SET removed:
$ echo 1 > /sys/class/net/ens4f0/device/sriov_numvfs
iavf 0000:88:02.0: MAC address: 3e:8a:16:a2:37:6d
$ ip addr add 192.168.1.1/24 dev ens4f0v0
$ ip link set dev ens4f0v0 up
$ echo 1 > /proc/sys/net/ipv4/conf/ens4f0v0/arp_notify
$ ip link set ens4f0v0 addr 00:11:22:33:44:55
07:28:01.836608 00:11:22:33:44:55 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 192.168.1.1 tell 192.168.1.1, length 28

Fixes: 35a2443d0910 ("iavf: Add waiting for response from PF in set mac")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/iavf/iavf.h      | 1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 3f6187c16424..0d1bab4ac1b0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -298,7 +298,6 @@ struct iavf_adapter {
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
 #define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 #define IAVF_FLAG_REINIT_MSIX_NEEDED		BIT(20)
-#define IAVF_FLAG_INITIAL_MAC_SET		BIT(23)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 258bdf8906dd..5fc47ca1b17c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1087,12 +1087,6 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 	if (ret)
 		return ret;
 
-	/* If this is an initial set MAC during VF spawn do not wait */
-	if (adapter->flags & IAVF_FLAG_INITIAL_MAC_SET) {
-		adapter->flags &= ~IAVF_FLAG_INITIAL_MAC_SET;
-		return 0;
-	}
-
 	ret = wait_event_interruptible_timeout(adapter->vc_waitqueue,
 					       iavf_is_mac_set_handled(netdev, addr->sa_data),
 					       msecs_to_jiffies(2500));
@@ -2605,8 +2599,6 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 		ether_addr_copy(netdev->perm_addr, adapter->hw.mac.addr);
 	}
 
-	adapter->flags |= IAVF_FLAG_INITIAL_MAC_SET;
-
 	adapter->tx_desc_count = IAVF_DEFAULT_TXD;
 	adapter->rx_desc_count = IAVF_DEFAULT_RXD;
 	err = iavf_init_interrupt_scheme(adapter);
-- 
2.37.3

