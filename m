Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1064F682C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbiDFRuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239626AbiDFRty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:49:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758AC27CFA;
        Wed,  6 Apr 2022 08:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649260707; x=1680796707;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dXI98OJqQW2ahS6RsWI895QYQlAECHmgbr0YBsR0OsE=;
  b=cTjkTtZHi9N0UrcRfe3OaVjhddfohfoFKPJ8PxZhMWlx8iJDVuZqeEg4
   yG52md6dZc94KRn+yFaLjKZP5C7Uq+jdh8MpMqemOJRemXTyGreqXKCD2
   xwqfvmdKUSDJSx7Io2OWD2gYh3QAlKr7wMqucguzaKEQ/yQlC9Vyj9YV0
   WpHjwoXi+bInyTcwmUCW9soqJRMSRO2ujeM1QFtU0tzw6NuYiPGfz+ypQ
   ixm4DAc2AONBKfd1SAqrw63P3EI3dXvDr9Vi6s8ceUOPuDy0OpaQ75Rxy
   C1KEIQfgKV2sk1z0O+/r+b9Y2h/BPi6xiSvhyrXX9VTTX8ufEAIkdpdwK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="261079402"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="261079402"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 08:58:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="570620691"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 06 Apr 2022 08:58:24 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, brouer@redhat.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf] xsk: fix l2fwd for copy mode + busy poll combo
Date:   Wed,  6 Apr 2022 17:58:04 +0200
Message-Id: <20220406155804.434493-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While checking AF_XDP copy mode combined with busy poll, strange
results were observed. rxdrop and txonly scenarios worked fine, but
l2fwd broke immediately.

After a deeper look, it turned out that for l2fwd, Tx side was exiting
early due to xsk_no_wakeup() returning true and in the end
xsk_generic_xmit() was never called. Note that AF_XDP Tx in copy mode is
syscall steered, so the current behavior is broken.

Txonly scenario only worked due to the fact that
sk_mark_napi_id_once_xdp() was never called - since Rx side is not in
the picture for this case and mentioned function is called in
xsk_rcv_check(), sk::sk_napi_id was never set, which in turn meant that
xsk_no_wakeup() was returning false (see the sk->sk_napi_id >=
MIN_NAPI_ID check in there).

To fix this, prefer busy poll in xsk_sendmsg() only when zero copy is
enabled on a given AF_XDP socket. By doing so, busy poll in copy mode
would not exit early on Tx side and eventually xsk_generic_xmit() will
be called.

Fixes: a0731952d9cd ("xsk: Add busy-poll support for {recv,send}msg()")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2c34caee0fd1..7d3a00cb24ec 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -639,7 +639,7 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 	if (sk_can_busy_loop(sk))
 		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
 
-	if (xsk_no_wakeup(sk))
+	if (xs->zc && xsk_no_wakeup(sk))
 		return 0;
 
 	pool = xs->pool;
-- 
2.27.0

