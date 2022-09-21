Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0964B5BF2AC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiIUBVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiIUBVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:21:13 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB5A6557B;
        Tue, 20 Sep 2022 18:21:10 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MK3mS-1oqh6W2R82-00LYqq; Wed, 21 Sep 2022 03:20:46 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 1/2] net: openvswitch: allow metering in non-initial user namespace
Date:   Wed, 21 Sep 2022 03:19:45 +0200
Message-Id: <20220921011946.250228-2-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220921011946.250228-1-michael.weiss@aisec.fraunhofer.de>
References: <20220921011946.250228-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:5hRA+EXig5KjfpBug6CUEsLbN/PydoeTXwBPvYwtnEq16oKoxfJ
 84xCuaaKEnlW37E3bMIr20VLYP9qA0gfenweCJScn/ZAG4h1MCaNFZoqSjnN8eeplv8JNbd
 07AJXjeOr5BDSwFjB5heewNWOF+zktpM/XaxJigDHv1O6V/+FQDZ1ny5QVZEwNqnr3kBQ/w
 QWQAtlCwSNIJCSeTq6Wrw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ONrPFcRfYFg=:u0b0B/j/CcdiCWeNDQKGNx
 hBFfC9cfM+neVpZdFZuH1vrkG+UijGurQVXfideKcoJlk2FQDfJCubxLiu47VJFSh4gdkyumc
 Q8lWALhHJ0NGSY5qv2jqN2CzCD9+QEMrfxAQ5pKgwRCEFBpeNuQ+LOPaxwsj+VWTFDZRlggCc
 AXNEPPzzieq8l+Hb0xHlQyAMWW+LSrhvvDmTkzWHRxjYXmvvTKWSXFAJ/GoQIx18wednwnsmQ
 2e4gDVbw61x3nlT68zXeDU+/uv9iRdJ576FoMrOgFRaJvsOpspM9bLPj3ZuB1t1U6uxY5/qW/
 1dXm51v4Z87Ot5thee6MJSM9yIf84mznJvvdDDXGYNCb103THUntGwEUdL0SOrvX/+XqUQxry
 WW6ySIQDGXfeKVJqR35rlkuGKjCaU4JSBHpHInvCyZMGfi/EiaDOeKnP3Aj13X5ZykCKf0/U6
 QEwwd8tlwiIh8U0udUE7b0rletmPj8sJKH602WeZqz6g05UdLkMjfBW7d5LvExiJrRv/MsrIC
 zVwgr4C2vth2Qq5MrU/XgNw7pSchFubLOPfn1uYiqIBBCa9ug5YBRTzJIoQ8Rj17Tl3mK0M3u
 HaLY7LGBXj3hkvCa4Y22DNshlUOOhBn60qP8yxSZsjfGl/ip5beqe41Q6LrVBXg8FisrmD29C
 Sn6Oho8UKnDegnYBSVybmtAH0FWKPvZsK0zFlVWNwuGfx6/OGm8wCGEjzwCX0CU5xksrn2woa
 dUq5tSFF8dk/2YZJIxm0Eau4S+K3JJyb32O0b1zTFjGL1f8CfctvPklFZRwq8Y6rSBy1jV3uc
 F8BgQ5nQSSwrAY9WcXeUKWuFDomZw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Netlink interface for metering was restricted to global CAP_NET_ADMIN
by using GENL_ADMIN_PERM. To allow metring in a non-inital user namespace,
e.g., a container, this is changed to GENL_UNS_ADMIN_PERM.

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 net/openvswitch/meter.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 04a060ac7fdf..7a56efd3406b 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -343,7 +343,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 			return ERR_PTR(-EINVAL);
 
 	/* Allocate and set up the meter before locking anything. */
-	meter = kzalloc(struct_size(meter, bands, n_bands), GFP_KERNEL);
+	meter = kzalloc(struct_size(meter, bands, n_bands), GFP_KERNEL_ACCOUNT);
 	if (!meter)
 		return ERR_PTR(-ENOMEM);
 
@@ -687,9 +687,9 @@ static const struct genl_small_ops dp_meter_genl_ops[] = {
 	},
 	{ .cmd = OVS_METER_CMD_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
-					   *  privilege.
-					   */
+		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
+					       *  privilege.
+					       */
 		.doit = ovs_meter_cmd_set,
 	},
 	{ .cmd = OVS_METER_CMD_GET,
@@ -699,9 +699,9 @@ static const struct genl_small_ops dp_meter_genl_ops[] = {
 	},
 	{ .cmd = OVS_METER_CMD_DEL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
-					   *  privilege.
-					   */
+		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
+					       *  privilege.
+					       */
 		.doit = ovs_meter_cmd_del
 	},
 };
-- 
2.30.2

