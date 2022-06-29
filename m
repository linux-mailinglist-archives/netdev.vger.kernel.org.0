Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360E255FDFE
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 12:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiF2K6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 06:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiF2K6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 06:58:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB0CE04;
        Wed, 29 Jun 2022 03:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656500287; x=1688036287;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qDwOeQCjAcCosJlIYFT+wV2S0XiAyg/mkUGTxioKq1I=;
  b=OaazYW1jwoXQeFVfgOJwrIkjNUhqUkepASGZn1j9zjU2xlk8e/P/nLQC
   q4Px9CCB9GshRRGw8eglq2/uBw3TwtA7okcyriMDPbAYlhSFMFEZhdCOe
   ibK1T3s5ava0dZJXwAnivS2yBQeJxOSMnGX5Mf/2Aj5/3ifjcuR/2Zzc8
   RHSBej9qA4Xxpbdu2MnBw6P7oCqC8uPSphUTPzvXTxF7Bwe0iW/Og2mQ5
   GG8glZu77llMOdd0kD+hmJdIP3IxB5hLHuG1c0n6LBpYQykMKraCLV9+y
   B+GBqX+rSdhuUJnMB8HK7GYolAGfLHm+IHxVZco+oVEzx64UwgdgzRZoq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282734960"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="282734960"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 03:58:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="658512957"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jun 2022 03:58:05 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf] xsk: mark napi_id on sendmsg()
Date:   Wed, 29 Jun 2022 12:57:52 +0200
Message-Id: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When application runs in zero copy busy poll mode and does not receive a
single packet but only sends them, it is currently impossible to get
into napi_busy_loop() as napi_id is only marked on Rx side in
xsk_rcv_check(). In there, napi_id is being taken from xdp_rxq_info
carried by xdp_buff. From Tx perspective, we do not have access to it.
What we have handy is the xsk pool.

Xsk pool works on a pool of internal xdp_buff wrappers called
xdp_buff_xsk. AF_XDP ZC enabled drivers call xp_set_rxq_info() so each
of xdp_buff_xsk has a valid pointer to xdp_rxq_info of underlying queue.
Therefore, on Tx side, napi_id can be pulled from
xs->pool->heads[0].xdp.rxq->napi_id.

Do this only for sockets working in ZC mode as otherwise rxq pointers
would not be initialized.

Fixes: a0731952d9cd ("xsk: Add busy-poll support for {recv,send}msg()")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 19ac872a6624..eafd512d38b1 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -637,8 +637,11 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
-	if (sk_can_busy_loop(sk))
+	if (sk_can_busy_loop(sk)) {
+		if (xs->zc)
+			__sk_mark_napi_id_once(sk, xs->pool->heads[0].xdp.rxq->napi_id);
 		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+	}
 
 	if (xs->zc && xsk_no_wakeup(sk))
 		return 0;
-- 
2.27.0

