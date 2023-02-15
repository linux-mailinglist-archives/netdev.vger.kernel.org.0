Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E01698611
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBOUr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBOUq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:46:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4D043478;
        Wed, 15 Feb 2023 12:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9C2761D95;
        Wed, 15 Feb 2023 20:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A4DC433A8;
        Wed, 15 Feb 2023 20:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493990;
        bh=se/Fx4rz2BZ2nlfkGZPZDiiRofWTYK5uf5Xbmg0VmRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzO1RNYPoKDUgCrdWGqO0tDBC8r7PDRuYBDNYxq4wLx8JbweNmBtrdWKn2nwBlb8f
         PdUOECknOx09d14+bBczhDC72uDiLSRbpiAqj0E9ooB0ojv8a4vlxa08HsBXJW71nC
         Qivirsw5x4pdrzzU7IWLEba/AzgeT/Fuzcz8NRJVWOKDApt6T928r79ilG63KMK5Sa
         W8BQHZdVEn3HyELXWGEXlvPirxdEesbeBzTq9J+5hogbMvt9h7Q9pmCmQ1FZzBb38H
         yeEbqsFIdbOrny5nz3CwFKvITTFJoiH+rVFG49dzg5B6pZf2fHhuAKvQ+gf+ZCs6So
         qG1M7Bko8j80g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 22/24] selftests: ocelot: tc_flower_chains: make test_vlan_ingress_modify() more comprehensive
Date:   Wed, 15 Feb 2023 15:45:45 -0500
Message-Id: <20230215204547.2760761-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit bbb253b206b9c417928a6c827d038e457f3012e9 ]

We have two IS1 filters of the OCELOT_VCAP_KEY_ANY key type (the one with
"action vlan pop" and the one with "action vlan modify") and one of the
OCELOT_VCAP_KEY_IPV4 key type (the one with "action skbedit priority").
But we have no IS1 filter with the OCELOT_VCAP_KEY_ETYPE key type, and
there was an uncaught breakage there.

To increase test coverage, convert one of the OCELOT_VCAP_KEY_ANY
filters to OCELOT_VCAP_KEY_ETYPE, by making the filter also match on the
MAC SA of the traffic sent by mausezahn, $h1_mac.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20230205192409.1796428-2-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index 9c79bbcce5a87..aff0a59f92d9a 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -246,7 +246,7 @@ test_vlan_ingress_modify()
 	bridge vlan add dev $swp2 vid 300
 
 	tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
-		protocol 802.1Q flower skip_sw vlan_id 200 \
+		protocol 802.1Q flower skip_sw vlan_id 200 src_mac $h1_mac \
 		action vlan modify id 300 \
 		action goto chain $(IS2 0 0)
 
-- 
2.39.0

