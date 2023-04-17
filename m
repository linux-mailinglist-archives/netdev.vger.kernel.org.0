Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD76E4B0B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjDQOMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjDQOMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:12:51 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2078.outbound.protection.outlook.com [40.92.53.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595928692;
        Mon, 17 Apr 2023 07:12:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWl54IYlwjAkrO3pn8piWK0dhNCrG6wllMFx9HddbyfVwwunZTi5NhU0Ilaye6Oe3rEp0bAKJdxH13q+yfEpee4BWidv47Dl2Sa1sCNcgsmeud0x65cPhNM9D17XSiA/QhtV0ARTxZfZZUvEMq+Ajq9WA2kX5pAP0GXN2f1446LDApEKQuPO99K+yoJCYREdm1KsZQ/a4Xoen0ZqenqVPgP4yUnLgZXrBpMcQDYtTbxB+54Ntur+6UMSv56YO/jsnnfkB5ZsfPAPltmoYhMvlMC1ow9fbdI3LK84iDLnBtgIBQvT+h00rip6dJj4OAGCHZhCELUjgDn0GzRT2jSRBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0xeytHljvOXf5NHTqal52zH9rp4DhzDEWxt/9rXN4I=;
 b=YNL44mzefnYAzOufGVvPd0NCibla2i8F2CuUVLhxLd+JqBVZkUZZCr6qkqH5kEzPwtCgrSAj+G6Yk6REB2GMjTmyPo8z6Qvl0RIESWGpPyjUJLCcTaL69+LDSIB4fqfgHdKcZ4ToJ2OX1Hej2h0Yn8RnqY8676asvKiTqjAaUOsWZ5nTSdH+i5dzvmAd5iFdQii5W10Db9Oy39EwrU7jO5lP4lvuz1fK+4NUddsUZrF8OsCHwrrdCfhwJZ1OMnkjfowF2dqBr9vWqf1WOE5He/mA5pLkl+rxpblJ0Tot4MoT9jLtMVI1MAonYBQEXDgNSBxDkv/1I00VO/rwLsyIQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0xeytHljvOXf5NHTqal52zH9rp4DhzDEWxt/9rXN4I=;
 b=AWZhu9hSVn1DS8JF4h2fVaj315iT/Y9KnnN5B/Skm1x/kqEsOsufu7dNPvmsASaOa0cFPp4rC3ASUvsLenuOQZyR1znFkrwkxP4tFMxAvU9HvD0j2RZ9qGIg1jWC8c09JhF1sHKWJ35YqDSlmCyxFWnufjrEyxsLwYcH5A7KtbreiebXQUG4lFlrYGZOAaGywDDW5oSU6XYMrbvuGY1RfsgJEdYbxjlL825c8U5I0uqFeKqoQU2Z8gzjXkCsDRHQcHYttovM1caFxe/ve7l8qOaZxFWO8nEZ/w+JtmmEURmwoZ0chCfLRly5YHCoVF2zanPPA8Bgm4suSu6SKRvEJA==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by SEZPR01MB4399.apcprd01.prod.exchangelabs.com
 (2603:1096:101:4f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.19; Mon, 17 Apr
 2023 14:12:40 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3%7]) with mapi id 15.20.6319.019; Mon, 17 Apr 2023
 14:12:40 +0000
From:   Yan Wang <rk.code@outlook.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com
Cc:     Yan Wang <rk.code@outlook.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        netdev@vger.kernel.org (open list:STMMAC ETHERNET DRIVER),
        linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32
        ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/STM32
        ARCHITECTURE), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v5] net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports
Date:   Mon, 17 Apr 2023 22:11:58 +0800
Message-ID: <KL1PR01MB544863D839654F0EC9485894E69C9@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <KL1PR01MB544872920F00149E3BDDC7ECE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
References: <KL1PR01MB544872920F00149E3BDDC7ECE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain
X-TMN:  [Izq4ixWFoT5xMFEXGpXnBBZFvSalMboKPzgY83wZyyI=]
X-ClientProxiedBy: SG3P274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::28)
 To KL1PR01MB5448.apcprd01.prod.exchangelabs.com (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230417141158.29749-1-rk.code@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|SEZPR01MB4399:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a188c4f-ddfc-4560-9445-08db3f4dce04
X-MS-Exchange-SLBlob-MailProps: YfhX3sd/0TVMxuI8J5UzJ6wcIdkd2x4ktEaID4hDgJNjb+GaNGG+vZlHu3LoU5M6TN/MDJP2IprhMk63hsQGQm6XYPDXbqzoA+TZJYxtNuk9PwFIbLAjEPufhN9+Yr+2FcEGHBWTmWRMjLtniK+1Sp4IRwxLWRGbxybNyi0FEUQc3ZQLf8ddW0q6g4oGnjIq1bYVmrfggMk54xEkVrtP6DVDwNUUmmma8zcQUjw2UWq5a4JFXLetUfLijlubN8jBo07yIn9aCRxyVNGU2o1lDeJ6/yXAnX2W3YMeWoRZM6B/bRDqPvFTExbhK8Udt+C9D+dr5pTMc1YcE6bUHNy31nwJvxdcgsWDKXfe6JxhXgNWLgj381Wau19SDz+rUf204DluP1L+BBYWgfIvmHZkxrQ6/q9NwDNRKr0oX52Z0Eg2KWhGf0k0WQrY6QvZXVHt5hEWStARidCAy+Ykn1oawyYWMPbe9BmL+p6S+xD4YmetB/pTFrhpht2zEiRHXwxkgsAUN5Id3AT5rKz0ek9rrWp4DdijfZtNtSIPNbjhAtOBFBaYhNduUubWA5PjvS+Il4ejc+WvQPbz+A2R/sh6ciAojwIg8/RN/Tm6ZmaF/ZQvHg1uBWBYecmTPPnBifHhsFmVRCcgBxNXd7lR7q0/tgYXaNL9ca0kbAlzWqd8SVUyR2XByezKsIpydoGgOEDs9ldbCHVpCT+4WTLrvMLTRQwx0iJBzJkkCKWC19X23kuu3BtXCiAhbbOXvNDh1/Ow44nkv+CD4xPKc85mPcwP9YqDK0kDEgP2vLZB0eLf7gI=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BIJUfa0iC+AUprwA4jZa9J9OokfHx94bmsXrGnrrIoSWCQkqxetx9Oa23YWgCv5CDQG78LPVvoO41ndlQaa9Wkmv/mbIkkBRWOLOIcgo56XFULqKFHOWJVcQdKH6Us4x4C0DA7fP9JlCvXIMebXn8KhrYgOCdw90CSlLkBwMdf5caFaAZhK5r2Oj8bX2BzcWJhxy8+FoPSrD+AKjzZSJ/hfA5wSNNuFYyw/ini7Jq6cfbOW9ygptLXZECMeEiUnY212Wxbr7bPxV+xFolI8s9iUrfsQVTvdIr1h1N+GD+1Q61dV8QOkQCrFjxCcaHD7rccMhL53A1b6Jse7u0pxPP4AKgR2o2VDhwoM7N3zfg8nWu1uxOoSL134SQAVQjqNUjOVPAyS68sLxHUz/wKolZ9+IipGRMHwF2jIHUwt/q84J0bi/7EknPnUrZQ/KtCTGqGaHPHQIsWmdBOQvTsk0b5Xf7j0Ts4egqsUoX8xIVeSf3VcF995bnBhQjZ9Dv5VknkU7DD1UmCjjlfPrZwzkvUWzp7tdbqOYhC80Q7wHnufPDGZfe0PSAr8YxPJZuouO4bh5CprNJRcA3nLRU2MAZdPGhuYkUqn2TaFpnNqAWLAPI/bVRZt5b23cWHherD5BiC00MKWaWhgSBVaaqkn+Ng==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pb5skgQJB+ynN4VVd9y4OUxOhbyB8Ns0x8vLAwCtAgatv7HDoT+a69xkY+d6?=
 =?us-ascii?Q?MAD/OP2BJjKqfeZ5j28WY1QhQdt1k3GhbGK3xHOIhnmgFuyXL5ta4m4XREBo?=
 =?us-ascii?Q?RcEO73hoc0beuFgjNQx7bdBGalnvs2SYp2AAW1DmW+7LQJFEVUmt7XYyRxvc?=
 =?us-ascii?Q?IgZKwF8+wr3eivNMUf4gVBfVw9UM0l8w1Pn3E5juO8Gwf56KBv8Ng0r1ohSz?=
 =?us-ascii?Q?dPkSmXrBxNxRilyKfjhc3Gz98rsorGEErOxUkzymGjoQT4MK84gYr7fLnzmI?=
 =?us-ascii?Q?3sZ2cafnaWvakI3u3UeuRQ0mDssNZZzcvSYc3y29JjpQHxLzolisBDV7cG9Z?=
 =?us-ascii?Q?ByjjEriZ5WEb+MvB/HvMGGDkkfVOJZMtZ6dLKiQAn3JeSAElQR9Dq5ETmlzM?=
 =?us-ascii?Q?CKvKlD7ioySXDLPIqLpcXbP5sumIpYMQeYw9P5E5NZTnLstGBuuZv8AyRpzY?=
 =?us-ascii?Q?rjEi57adcDEuafkOWskevZpzguulFNzjYaqYCnv7mvOUAKIJ+Y7GlgcQl6Nt?=
 =?us-ascii?Q?BWaF9X/nfX4dx9KMT1RR9gIr4RLrfd41I3G9EyDSH6gXlx1pPEGXK31GVjma?=
 =?us-ascii?Q?rfUqvv5kYIwlMhYYp7XJNrHJ+yU0veSgBYoFhy3DDwguDN+ni1CjUmJay4Bw?=
 =?us-ascii?Q?/ZEQ83s1zSt+WjZiI+shMz+3luCDOuASqGYc0ueEJI0GyxlWY2xCSk4ntOMv?=
 =?us-ascii?Q?SJb4q8dkvsV11GGhGF2l4YPj8CtLXIV6NchjWSMsW9oJ5zQaV8ifLgmdQC3F?=
 =?us-ascii?Q?JdWpeVPqC6VFTbVzK6uW2AkmUL0tbhMm+unSzmbbwO81S3voHxhc5gXHrkpV?=
 =?us-ascii?Q?wWAGNc9DGeRydupLccjrfDhopoNycsJVq0g2uZ0BI5W0fPSSxzWbS4DP4/57?=
 =?us-ascii?Q?FbZonG4ydU6/cParM4qioIFJACCKs2Ggl8Agpxfrx5dW517/8eh+VEVJW4BS?=
 =?us-ascii?Q?6HyY2LOJHqqJClzxbwIaP3OHhWOOvcFyXU98183V+fPsvmI2r0aARhzhdgPy?=
 =?us-ascii?Q?KVGh5lWYem5noERq1Pw2TIxZyDAClUfU1p3DDJBSRT3cyihzn9bPxatg0mbZ?=
 =?us-ascii?Q?n41AOj4S9YYJDHwfMuvBtpsEtZbIqo1KFTpR5cQCZ2JF223xV2ZgABxgLRbN?=
 =?us-ascii?Q?oqLs7rTpIeM0k07dtR0eBstXG+EJcQOf2NCBZGE+PYobeATZCUBGSd88Oj1W?=
 =?us-ascii?Q?0TC11kHscOwnHwM6y52w/cKYhLOOVumYw9FQYQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a188c4f-ddfc-4560-9445-08db3f4dce04
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 14:12:40.8040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB4399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The system hang because of dsa_tag_8021q_port_setup()->
				stmmac_vlan_rx_add_vid().

I found in stmmac_drv_probe() that cailing pm_runtime_put()
disabled the clock.

First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
resume/suspend is active.

Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
registers after stmmac's clock is closed.

I would suggest adding the pm_runtime_resume_and_get() to the
stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
while in use.

Fixes: b3dcb3127786 ("net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()")
Signed-off-by: Yan Wang <rk.code@outlook.com>
---
v5:
  - Add version tags.
v4: https://lore.kernel.org/netdev/KL1PR01MB5448C7BF5A7AAC1CBCD5C36AE6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Fixed email address,but The Version number is wrong.
v3: https://lore.kernel.org/netdev/KL1PR01MB544872920F00149E3BDDC7ECE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Fixed the Fixes tag,but Missing version change log.
v2: https://lore.kernel.org/netdev/KL1PR01MB54482D50B5C8713A2CA697DFE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Add a error fixed tag.
v1: https://lore.kernel.org/netdev/KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - the Subject is set incorrectly
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d7fcab057032..f9cd063f1fe3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6350,6 +6350,10 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 	bool is_double = false;
 	int ret;
 
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
+		return ret;
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -6357,16 +6361,18 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 	ret = stmmac_vlan_update(priv, is_double);
 	if (ret) {
 		clear_bit(vid, priv->active_vlans);
-		return ret;
+		goto err_pm_put;
 	}
 
 	if (priv->hw->num_vlan) {
 		ret = stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret)
-			return ret;
+			goto err_pm_put;
 	}
+err_pm_put:
+	pm_runtime_put(priv->device);
 
-	return 0;
+	return ret;
 }
 
 static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
-- 
2.17.1

