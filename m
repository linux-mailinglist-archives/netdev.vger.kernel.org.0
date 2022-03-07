Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93624D0B17
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343741AbiCGWc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiCGWcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:32:25 -0500
Received: from v-zimmta03.u-bordeaux.fr (v-zimmta03.u-bordeaux.fr [147.210.215.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7A22DD68;
        Mon,  7 Mar 2022 14:31:28 -0800 (PST)
Received: from v-zimmta03.u-bordeaux.fr (localhost [127.0.0.1])
        by v-zimmta03.u-bordeaux.fr (Postfix) with ESMTP id EBCB818014AC;
        Mon,  7 Mar 2022 23:31:26 +0100 (CET)
Received: from begin.home (lfbn-bor-1-255-114.w90-50.abo.wanadoo.fr [90.50.98.114])
        by v-zimmta03.u-bordeaux.fr (Postfix) with ESMTPSA id B0F3918014A5;
        Mon,  7 Mar 2022 23:31:26 +0100 (CET)
Received: from samy by begin.home with local (Exim 4.95)
        (envelope-from <samuel.thibault@labri.fr>)
        id 1nRLt0-00C9Ci-8c;
        Mon, 07 Mar 2022 23:31:26 +0100
Date:   Mon, 7 Mar 2022 23:31:26 +0100
From:   Samuel Thibault <samuel.thibault@labri.fr>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: [PATCHv2] SO_ZEROCOPY should return -EOPNOTSUPP rather than -ENOTSUPP
Message-ID: <20220307223126.djzvg44v2o2jkjsx@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@labri.fr>,
        davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170609 (1.8.3)
X-AV-Checked: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENOTSUPP is documented as "should never be seen by user programs",
and thus not exposed in <errno.h>, and thus applications cannot safely
check against it (they get "Unknown error 524" as strerror). We should
rather return the well-known -EOPNOTSUPP.

This is similar to 2230a7ef5198 ("drop_monitor: Use correct error
code") and 4a5cdc604b9c ("net/tls: Fix return values to avoid
ENOTSUPP"), which did not seem to cause problems.

Signed-off-by: Samuel Thibault <samuel.thibault@labri.fr>

---
Difference with v1: use -EOPNOTSUPP instead of -ENOPROTOOPT.

diff --git a/net/core/sock.c b/net/core/sock.c
index 4ff806d71921..839eb076afee 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1377,9 +1377,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			if (!(sk_is_tcp(sk) ||
 			      (sk->sk_type == SOCK_DGRAM &&
 			       sk->sk_protocol == IPPROTO_UDP)))
-				ret = -ENOTSUPP;
+				ret = -EOPNOTSUPP;
 		} else if (sk->sk_family != PF_RDS) {
-			ret = -ENOTSUPP;
+			ret = -EOPNOTSUPP;
 		}
 		if (!ret) {
 			if (val < 0 || val > 1)
