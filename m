Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327BD44C8A7
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhKJTOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:14:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:37773 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232721AbhKJTOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 14:14:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="256439320"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="256439320"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 11:11:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="732634661"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 10 Nov 2021 11:11:33 -0800
Received: from alobakin-mobl.ger.corp.intel.com (baranski-mobl.ger.corp.intel.com [10.213.1.114])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AAJBVWe004469;
        Wed, 10 Nov 2021 19:11:31 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Antoine Tenart <atenart@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: fix premature exit from NAPI state polling in napi_disable()
Date:   Wed, 10 Nov 2021 20:11:26 +0100
Message-Id: <20211110191126.1214-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 719c57197010 ("net: make napi_disable() symmetric with
enable") accidentally introduced a bug sometimes leading to a kernel
BUG when bringing an iface up/down under heavy traffic load.

Prior to this commit, napi_disable() was polling n->state until
none of (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC) is set and then
always flip them. Now there's a possibility to get away with the
NAPIF_STATE_SCHE unset as 'continue' drops us to the cmpxchg()
call with an unitialized variable, rather than straight to
another round of the state check.

Error path looks like:

napi_disable():
unsigned long val, new; /* new is uninitialized */

do {
	val = READ_ONCE(n->state); /* NAPIF_STATE_NPSVC and/or
				      NAPIF_STATE_SCHED is set */
	if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) { /* true */
		usleep_range(20, 200);
		continue; /* go straight to the condition check */
	}
	new = val | <...>
} while (cmpxchg(&n->state, val, new) != val); /* state == val, cmpxchg()
						  writes garbage */

napi_enable():
do {
	val = READ_ONCE(n->state);
	BUG_ON(!test_bit(NAPI_STATE_SCHED, &val)); /* 50/50 boom */
<...>

while the typical BUG splat is like:

[  172.652461] ------------[ cut here ]------------
[  172.652462] kernel BUG at net/core/dev.c:6937!
[  172.656914] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  172.661966] CPU: 36 PID: 2829 Comm: xdp_redirect_cp Tainted: G          I       5.15.0 #42
[  172.670222] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0014.082620210524 08/26/2021
[  172.680646] RIP: 0010:napi_enable+0x5a/0xd0
[  172.684832] Code: 07 49 81 cc 00 01 00 00 4c 89 e2 48 89 d8 80 e6 fb f0 48 0f b1 55 10 48 39 c3 74 10 48 8b 5d 10 f6 c7 04 75 3d f6 c3 01 75 b4 <0f> 0b 5b 5d 41 5c c3 65 ff 05 b8 e5 61 53 48 c7 c6 c0 f3 34 ad 48
[  172.703578] RSP: 0018:ffffa3c9497477a8 EFLAGS: 00010246
[  172.708803] RAX: ffffa3c96615a014 RBX: 0000000000000000 RCX: ffff8a4b575301a0
< snip >
[  172.782403] Call Trace:
[  172.784857]  <TASK>
[  172.786963]  ice_up_complete+0x6f/0x210 [ice]
[  172.791349]  ice_xdp+0x136/0x320 [ice]
[  172.795108]  ? ice_change_mtu+0x180/0x180 [ice]
[  172.799648]  dev_xdp_install+0x61/0xe0
[  172.803401]  dev_xdp_attach+0x1e0/0x550
[  172.807240]  dev_change_xdp_fd+0x1e6/0x220
[  172.811338]  do_setlink+0xee8/0x1010
[  172.814917]  rtnl_setlink+0xe5/0x170
[  172.818499]  ? bpf_lsm_binder_set_context_mgr+0x10/0x10
[  172.823732]  ? security_capable+0x36/0x50
< snip >

Fix this by replacing this 'continue' with a goto to the beginning
of the loop body to restore the original behaviour.
This could be written without a goto, but would look uglier and
require one more indent level.

Fixes: 719c57197010 ("net: make napi_disable() symmetric with enable")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index edeb811c454e..5e101c53b9de 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6929,10 +6929,11 @@ void napi_disable(struct napi_struct *n)
 	set_bit(NAPI_STATE_DISABLE, &n->state);
 
 	do {
+retry:
 		val = READ_ONCE(n->state);
 		if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
 			usleep_range(20, 200);
-			continue;
+			goto retry;
 		}
 
 		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
-- 
2.33.1

