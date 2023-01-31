Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076D96825A5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjAaHjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjAaHjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:39:31 -0500
Received: from evilolive.daedalian.us (evilolive.daedalian.us [96.126.118.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E8036441;
        Mon, 30 Jan 2023 23:39:30 -0800 (PST)
Received: by evilolive.daedalian.us (Postfix, from userid 111)
        id 03413120E7; Mon, 30 Jan 2023 23:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=daedalian.us;
        s=default; t=1675150769;
        bh=VH2cGfZJ/ASf0s5VyTB4yCiXFIqxZ/O9hH846PYQisI=;
        h=From:To:Cc:Subject:Date:From;
        b=U775xbP7PJiCLVQAqLOExe1dOuNMgpqez4WqCBMtvZsQS4k6VnEkQl68ijCCLuTYE
         cAosBdkoW0HSmF4XRWKH+2GUXjT5Fv/ZY2XVmz4dmxcFtgzxMxpT9Ni3jG3JZMbTCn
         zX8zYEBa3RUVhFTpHQJSq1TYJy5C9A28SBpJCIyuInfPz+F1WAKnJ83OyXZMQq4pZM
         93WiYHKtBBaAKBXDVgSZEPW5EnmHAFeuXi2yqka7UKij4yFxhpL3jGBsDapJSczcc9
         8YCLbQN8YMKaKlYZWk8zU1dcxoLHWyVIHaVCI4CGqxt5JZWkGlRGvrMNG6uUTPKyzu
         TEmfGDZsZofrA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from localhost.localdomain (static-47-181-121-78.lsan.ca.frontiernet.net [47.181.121.78])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by evilolive.daedalian.us (Postfix) with ESMTPSA id B784B12072;
        Mon, 30 Jan 2023 23:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=daedalian.us;
        s=default; t=1675150762;
        bh=VH2cGfZJ/ASf0s5VyTB4yCiXFIqxZ/O9hH846PYQisI=;
        h=From:To:Cc:Subject:Date:From;
        b=YbkzfWv2uV3t9u/5wUApMhQHr5z6N0c+Ss7c1byuwJq6aJYkb2M2qq9NV+01S7H5q
         YJu9qBqgwYhI1srUJwYfQ2Scv7+sXMfXfqsY5WPZfuaW8hirtszOdyG4By9z9ae/Zx
         IcZJr7zXmVKIlGBwlNMy0/gQYmue3NA61KACTlQhlxw9gurAM9cWNRDiv7j0TcCCST
         S1/GMz+BpAYpjPkCLb5bwb+ZXTuEJmVEnQtvLElEZir5UQfDCVRfXmV6EWD9/1muHV
         Umcisn1iSAkt5zOiEGhYr5iUW1GN/0prfHKIHtemsAwPXSX8gcs9NqFShADFuBlpo3
         d0w3ReRNU6Mgw==
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
        Shujin Li <lishujin@kuaishou.com>,
        Jason Xing <xingwanli@kuaishou.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net v2] ixgbe: Panic during XDP_TX with > 64 CPUs
Date:   Mon, 30 Jan 2023 23:38:15 -0800
Message-Id: <20230131073815.181341-1-jjh@daedalian.us>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
(4fe815850bdc), support was added to allow XDP programs to run on systems
with more than 64 CPUs by locking the XDP TX rings and indexing them
using cpu % 64 (IXGBE_MAX_XDP_QS).

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

Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
Signed-off-by: John Hickey <jjh@daedalian.us>
---
v1 -> v2:
	Added Fixes and net tag.  No code changes.
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

