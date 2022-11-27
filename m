Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC001639A11
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 12:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiK0LTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 06:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiK0LTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 06:19:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488311274C
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 03:18:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF66CB80AE1
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 11:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DBDC433D6;
        Sun, 27 Nov 2022 11:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669547928;
        bh=KGjlDCPoCaU7NXrV0iVKv3hrvMdNrWVtthiirnmuEEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKI1/FaRCod4kl/wfAlhkKeMGEyGTRsCsRMesyhTKmSwjkV/wXB6dv2/giR1ymKHR
         HXoL7iE1MkKw4fTsHnQFMABP/gk8ywO+koyorAEYEsX9H9Us5Co9dRTJOUSMXYxcJv
         u8qakJ86BCLs/lq0wCGeiw6SnzG9Q9HiHeporteVYB4NxjYf3lp8rXs0OGwwm0aqiN
         c8kL5yvbsxxbrKpVubMj6DwzDIGq6/cduYC7NpeMAQtjP8Z/Icwv2RD8DgVhBd9TUR
         j81Z/dy5dgu3mJkndRSsZI/FzlCwvJ8ipES6G8f9lnC09WhPhkzxfu5PQJpUrBVE32
         hWWL74EQPNeZg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next v9 8/8] xfrm: document IPsec packet offload mode
Date:   Sun, 27 Nov 2022 13:18:18 +0200
Message-Id: <4ed9580413214d7be8f2d0c8396e37851a8debc6.1669547603.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669547603.git.leonro@nvidia.com>
References: <cover.1669547603.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Extend XFRM device offload API description with newly
added packet offload mode.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/networking/xfrm_device.rst | 62 ++++++++++++++++++++----
 1 file changed, 53 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/xfrm_device.rst b/Documentation/networking/xfrm_device.rst
index 01391dfd37d9..c43ace79e320 100644
--- a/Documentation/networking/xfrm_device.rst
+++ b/Documentation/networking/xfrm_device.rst
@@ -5,6 +5,7 @@ XFRM device - offloading the IPsec computations
 ===============================================
 
 Shannon Nelson <shannon.nelson@oracle.com>
+Leon Romanovsky <leonro@nvidia.com>
 
 
 Overview
@@ -18,10 +19,21 @@ can radically increase throughput and decrease CPU utilization.  The XFRM
 Device interface allows NIC drivers to offer to the stack access to the
 hardware offload.
 
+Right now, there are two types of hardware offload that kernel supports.
+ * IPsec crypto offload:
+   * NIC performs encrypt/decrypt
+   * Kernel does everything else
+ * IPsec packet offload:
+   * NIC performs encrypt/decrypt
+   * NIC does encapsulation
+   * Kernel and NIC have SA and policy in-sync
+   * NIC handles the SA and policies states
+   * The Kernel talks to the keymanager
+
 Userland access to the offload is typically through a system such as
 libreswan or KAME/raccoon, but the iproute2 'ip xfrm' command set can
 be handy when experimenting.  An example command might look something
-like this::
+like this for crypto offload:
 
   ip x s add proto esp dst 14.0.0.70 src 14.0.0.52 spi 0x07 mode transport \
      reqid 0x07 replay-window 32 \
@@ -29,6 +41,17 @@ like this::
      sel src 14.0.0.52/24 dst 14.0.0.70/24 proto tcp \
      offload dev eth4 dir in
 
+and for packet offload
+
+  ip x s add proto esp dst 14.0.0.70 src 14.0.0.52 spi 0x07 mode transport \
+     reqid 0x07 replay-window 32 \
+     aead 'rfc4106(gcm(aes))' 0x44434241343332312423222114131211f4f3f2f1 128 \
+     sel src 14.0.0.52/24 dst 14.0.0.70/24 proto tcp \
+     offload packet dev eth4 dir in
+
+  ip x p add src 14.0.0.70 dst 14.0.0.52 offload packet dev eth4 dir in
+  tmpl src 14.0.0.70 dst 14.0.0.52 proto esp reqid 10000 mode transport
+
 Yes, that's ugly, but that's what shell scripts and/or libreswan are for.
 
 
@@ -40,17 +63,24 @@ Callbacks to implement
 
   /* from include/linux/netdevice.h */
   struct xfrmdev_ops {
+        /* Crypto and Packet offload callbacks */
 	int	(*xdo_dev_state_add) (struct xfrm_state *x);
 	void	(*xdo_dev_state_delete) (struct xfrm_state *x);
 	void	(*xdo_dev_state_free) (struct xfrm_state *x);
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
 				       struct xfrm_state *x);
 	void    (*xdo_dev_state_advance_esn) (struct xfrm_state *x);
+
+        /* Solely packet offload callbacks */
+	void    (*xdo_dev_state_update_curlft) (struct xfrm_state *x);
+	int	(*xdo_dev_policy_add) (struct xfrm_policy *x);
+	void	(*xdo_dev_policy_delete) (struct xfrm_policy *x);
+	void	(*xdo_dev_policy_free) (struct xfrm_policy *x);
   };
 
-The NIC driver offering ipsec offload will need to implement these
-callbacks to make the offload available to the network stack's
-XFRM subsystem.  Additionally, the feature bits NETIF_F_HW_ESP and
+The NIC driver offering ipsec offload will need to implement callbacks
+relevant to supported offload to make the offload available to the network
+stack's XFRM subsystem. Additionally, the feature bits NETIF_F_HW_ESP and
 NETIF_F_HW_ESP_TX_CSUM will signal the availability of the offload.
 
 
@@ -79,7 +109,8 @@ and an indication of whether it is for Rx or Tx.  The driver should
 
 		===========   ===================================
 		0             success
-		-EOPNETSUPP   offload not supported, try SW IPsec
+		-EOPNETSUPP   offload not supported, try SW IPsec,
+                              not applicable for packet offload mode
 		other         fail the request
 		===========   ===================================
 
@@ -96,6 +127,7 @@ will serviceable.  This can check the packet information to be sure the
 offload can be supported (e.g. IPv4 or IPv6, no IPv4 options, etc) and
 return true of false to signify its support.
 
+Crypto offload mode:
 When ready to send, the driver needs to inspect the Tx packet for the
 offload information, including the opaque context, and set up the packet
 send accordingly::
@@ -139,13 +171,25 @@ the stack in xfrm_input().
 In ESN mode, xdo_dev_state_advance_esn() is called from xfrm_replay_advance_esn().
 Driver will check packet seq number and update HW ESN state machine if needed.
 
+Packet offload mode:
+HW adds and deletes XFRM headers. So in RX path, XFRM stack is bypassed if HW
+reported success. In TX path, the packet lefts kernel without extra header
+and not encrypted, the HW is responsible to perform it.
+
 When the SA is removed by the user, the driver's xdo_dev_state_delete()
-is asked to disable the offload.  Later, xdo_dev_state_free() is called
-from a garbage collection routine after all reference counts to the state
+and xdo_dev_policy_delete() are asked to disable the offload.  Later,
+xdo_dev_state_free() and xdo_dev_policy_free() are called from a garbage
+collection routine after all reference counts to the state and policy
 have been removed and any remaining resources can be cleared for the
 offload state.  How these are used by the driver will depend on specific
 hardware needs.
 
 As a netdev is set to DOWN the XFRM stack's netdev listener will call
-xdo_dev_state_delete() and xdo_dev_state_free() on any remaining offloaded
-states.
+xdo_dev_state_delete(), xdo_dev_policy_delete(), xdo_dev_state_free() and
+xdo_dev_policy_free() on any remaining offloaded states.
+
+Outcome of HW handling packets, the XFRM core can't count hard, soft limits.
+The HW/driver are responsible to perform it and provide accurate data when
+xdo_dev_state_update_curlft() is called. In case of one of these limits
+occuried, the driver needs to call to xfrm_state_check_expire() to make sure
+that XFRM performs rekeying sequence.
-- 
2.38.1

