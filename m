Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE8BBA21F
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 13:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfIVLwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 07:52:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60041 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728651AbfIVLwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 07:52:03 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Sep 2019 14:51:58 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8MBpwId007531;
        Sun, 22 Sep 2019 14:51:58 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin Shelar <pshelar@ovn.org>,
        Daniel B^Ckmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Date:   Sun, 22 Sep 2019 14:51:44 +0300
Message-Id: <1569153104-17875-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb extension is currently used for miss path of software offloading OvS rules with recirculation to tc.
However, we are also preparing patches to support the hardware side of things.

After the userspace OvS patches to support connection tracking, we'll have two users for
tc multi chain rules, one from those actually using tc and those translated from OvS rules.

With both of these use cases, there is similar issue of 'miss', from hardware to tc and tc to OvS and the skb
extension will serve to recover from both.

Consider, for example, the following multi chain tc rules:

tc filter add dev1 ... chain 0 flower dst_mac aa:bb:cc:dd:ee:ff action pedit munge ex set mac dst 02:a0:98:4e:8f:d1 pipe action goto chain 1
tc filter add dev1 ... chain 1 flower ip_dst 1.1.1.1 action mirred egress redirect dev2
tc filter add dev1 ... chain 1 flower ip_dst 2.2.2.2 action mirred egress redirect dev2

It's possible we offload the first two rules, but fail to offload the third rule, because of some hardware failure (e.g unsupported match or action).
If a packet with (dst_mac=aa:bb:cc:dd:ee:ff) and (dst ip=2.2.2.2) arrives,
we execute the goto chain 1 in hardware (and the pedit), and continue in chain 1, where we miss.

Currently we re-start the processing in tc from chain 0, even though we already did part of the processing in hardware.
The match on the dst_mac will fail as we already modified it, and we won't execute the third rule action.
In addition, if we did manage to execute any software tc rules, the packet will be counted twice.

We'll re-use this extension to solve this issue that currently exists by letting drivers tell tc on which chain to start the classification.

Regarding the config, we suggest changing the default to N and letting users decide to enable it, see attached patch.

Thanks,
Paul.


------------------------------------------------------------

Subject: [PATCH net-next] net/sched: Set default of CONFIG_NET_TC_SKB_EXT to N

This a new feature, it is prefered that it defaults to N.

Fixes: 95a7233c452a ('net: openvswitch: Set OvS recirc_id from tc chain index')
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/sched/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index b3faafe..4bb10b7 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -966,7 +966,6 @@ config NET_IFE_SKBTCINDEX
 config NET_TC_SKB_EXT
 	bool "TC recirculation support"
 	depends on NET_CLS_ACT
-	default y if NET_CLS_ACT
 	select SKB_EXTENSIONS
 
 	help
-- 
1.8.3.1

