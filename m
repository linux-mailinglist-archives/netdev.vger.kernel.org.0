Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 957FB1085C
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfEANmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:42:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47651 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfEANmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:42:08 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hLpUp-000820-OF; Wed, 01 May 2019 13:42:03 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        dev@openvswitch.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] openvswitch: check for null pointer return from nla_nest_start_noflag
Date:   Wed,  1 May 2019 14:41:58 +0100
Message-Id: <20190501134158.15307-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The call to nla_nest_start_noflag can return null in the unlikely
event that nla_put returns -EMSGSIZE.  Check for this condition to
avoid a null pointer dereference on pointer nla_reply.

Addresses-Coverity: ("Dereference null return value")
Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/openvswitch/conntrack.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c4128082f88b..333ec5f298fe 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2175,6 +2175,10 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(reply);
 
 	nla_reply = nla_nest_start_noflag(reply, OVS_CT_LIMIT_ATTR_ZONE_LIMIT);
+	if (!nla_reply) {
+		err = -EMSGSIZE;
+		goto exit_err;
+	}
 
 	if (a[OVS_CT_LIMIT_ATTR_ZONE_LIMIT]) {
 		err = ovs_ct_limit_get_zone_limit(
-- 
2.20.1

