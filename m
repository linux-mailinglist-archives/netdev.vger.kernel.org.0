Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7144530BE20
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhBBM0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:26:05 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41408 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229636AbhBBM0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:26:04 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@nvidia.com)
        with SMTP; 2 Feb 2021 14:25:13 +0200
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 112CPD8u009656;
        Tue, 2 Feb 2021 14:25:13 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Jiri Pirko <jiri@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@nvidia.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: [PATCH iproute2/net-next] tc: flower: Add support for ct_state reply flag
Date:   Tue,  2 Feb 2021 14:24:42 +0200
Message-Id: <1612268682-29525-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matches on conntrack rpl ct_state.

Example:
$ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
  ct_state +trk+est+rpl \
  action mirred egress redirect dev ens1f0_1
$ tc filter add dev ens1f0_1 ingress prio 1 chain 1 proto ip flower \
  ct_state +trk+est-rpl \
  action mirred egress redirect dev ens1f0_0

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 man/man8/tc-flower.8 | 2 ++
 tc/f_flower.c        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 226d1cc..f7336b6 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -387,6 +387,8 @@ new - New connection.
 .TP
 est - Established connection.
 .TP
+rpl - The packet is in the reply direction, meaning that it is in the opposite direction from the packet that initiated the connection.
+.TP
 inv - The state is invalid. The packet couldn't be associated to a connection.
 .TP
 Example: +trk+est
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 85c1043..53822a9 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -346,6 +346,7 @@ static struct flower_ct_states {
 	{ "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
 	{ "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
 	{ "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID },
+	{ "rpl", TCA_FLOWER_KEY_CT_FLAGS_REPLY },
 };
 
 static int flower_parse_ct_state(char *str, struct nlmsghdr *n)
-- 
1.8.3.1

