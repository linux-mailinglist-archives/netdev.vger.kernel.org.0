Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC9C67F3D7
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjA1BtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjA1BtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:49:04 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 Jan 2023 17:49:03 PST
Received: from evilolive.daedalian.us (evilolive.daedalian.us [96.126.118.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846CD7EFC7
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:49:03 -0800 (PST)
Received: by evilolive.daedalian.us (Postfix, from userid 111)
        id 62587120D9; Fri, 27 Jan 2023 17:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=daedalian.us;
        s=default; t=1674868394;
        bh=m80g/qcKyF6Y8HG7sLJ+YFMv8oIIC64vqUP0h+rSuYc=;
        h=From:To:Cc:Subject:Date:From;
        b=RuIDzcGSC3xhxkGbOjKfChdLByh9wYSAX00p+oq+IRvp0Gpju8ZNWadwVK4yMmDYP
         8TVw1Efbl+orqy9eHox3jN+qfCiaonplOXxwhbxWE/63etr07JH8lfYGPxtF3473OS
         lfYkqh2obi5WN1cCKmXoh2YMLnbXypnFkQKS6KKpeLzMe6pSGoZU05ryIOXhY1ECkE
         qgvY3c/gz64w5oOARD3QAIvUyod22RYVrRloGQD9UUKli1aidYN98NUajuilW6EQn6
         hqNfQK4fm/QS+bN0eWqewKzTYWaFC8CPgq59F3JYhgS4T6JmvyGgdkYOm3Z46sy7Wr
         LA0D8r3yHZuug==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
Received: from localhost.localdomain (static-47-181-121-78.lsan.ca.frontiernet.net [47.181.121.78])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by evilolive.daedalian.us (Postfix) with ESMTPSA id 4D6E812084;
        Fri, 27 Jan 2023 17:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=daedalian.us;
        s=default; t=1674868388;
        bh=m80g/qcKyF6Y8HG7sLJ+YFMv8oIIC64vqUP0h+rSuYc=;
        h=From:To:Cc:Subject:Date:From;
        b=LWdhKwSL1TP2BNDpHoX8FR54V51X2xLvhQuQZ1s7cpGSIMUQqPvKvKq+U5f0/npoP
         8bbbsE/nl+1flnwe29uTdqd2Na6IgRCBPNturH8x8ckRStUYWDkc6CBECd4F1u/QAC
         2pVQeaN5t8EweUJIlMAz2QvNPPijF2gwjGm4PxEWXAyWAcRr0muYlj6ISbe/i3PHZI
         ICYHVKTJSu5/C4+8RsC0/eL7aS+XiJJEWPj1Ro+ZMgN0tq4IXzZfkTpR7xH2DHdDzG
         VGcL8BiuMEkWqddjEPEhY/Q/LCMvCpqTnTOMGpcydjh1CSPdOmTrCSl4BgN2CWeS6Y
         YNICl+IGu3erg==
From:   John Hickey <jjh@daedalian.us>
To:     anthony.l.nguyen@intel.com
Cc:     John Hickey <jjh@daedalian.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] ixgbe: Panic during XDP_TX with > 64 CPUs
Date:   Fri, 27 Jan 2023 17:12:12 -0800
Message-Id: <20230128011213.150171-1-jjh@daedalian.us>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
(4fe815850bdc8d4cc94e06fe1de069424a895826), support was added to allow
XDP programs to run on systems with more than 64 CPUs by locking the
XDP TX rings and indexing them using cpu % 64 (IXGBE_MAX_XDP_QS).

Upon trying this out patch via the Intel 5.18.6 out of tree driver
on a system with more than 64 cores, the kernel paniced with an
array-index-out-of-bounds at the return in ixgbe_determine_xdp_ring in
ixgbe.h, which means ixgbe_determine_xdp_q_idx was just returning the
cpu instead of cpu % IXGBE_MAX_XDP_QS.

I think this is how it happens:

Upon loading the first XDP program on a system with more than 64 CPUs,
ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
immediately after this, the rings are reconfigured by ixgbe_setup_tc.
ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if
it is non-zero.  Commenting out the decrement in ixgbe_free_q_vector
stopped my system from panicing.

I suspect to make the original patch work, I would need to load an XDP
program and then replace it in order to get ixgbe_xdp_locking_key back
above 0 since ixgbe_setup_tc is only called when transitioning between
XDP and non-XDP ring configurations, while ixgbe_xdp_locking_key is
incremented every time ixgbe_xdp_setup is called.

Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this
becomes another path to decrement ixgbe_xdp_locking_key to 0 on systems
with greater than 64 CPUs.

For this patch, I have changed static_branch_inc to static_branch_enable
in ixgbe_setup_xdp.  We aren't counting references and I don't see any
reason to turn it off, since all the locking appears to be in the XDP_TX
path, which isn't run if a XDP program isn't loaded.

Signed-off-by: John Hickey <jjh@daedalian.us>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index f8156fe4b1dc..0ee943db3dc9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -1035,9 +1035,6 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
 	adapter->q_vector[v_idx] = NULL;
 	__netif_napi_del(&q_vector->napi);
 
-	if (static_key_enabled(&ixgbe_xdp_locking_key))
-		static_branch_dec(&ixgbe_xdp_locking_key);
-
 	/*
 	 * after a call to __netif_napi_del() napi may still be used and
 	 * ixgbe_get_stats64() might access the rings on this vector,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..cd2fb72c67be 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10283,7 +10283,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
 		return -ENOMEM;
 	else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
-		static_branch_inc(&ixgbe_xdp_locking_key);
+		static_branch_enable(&ixgbe_xdp_locking_key);
 
 	old_prog = xchg(&adapter->xdp_prog, prog);
 	need_reset = (!!prog != !!old_prog);
-- 
2.37.2

