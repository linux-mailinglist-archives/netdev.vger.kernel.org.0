Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03E86E10A4
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjDMPJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjDMPJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:09:09 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2034.outbound.protection.outlook.com [40.92.53.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CD993CA;
        Thu, 13 Apr 2023 08:09:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4aIH6V99QyeiZMEzNb88qf0ZaU2bhclT4rtiV+vaqQP112zPMkDlfb1tiy4Oqj5G6Nig1gQbnbgmkjhB752eDg0phXvAze3G9Jv4pvnsJKsUgECL9DarSAUzlBI3brlg0yO/a2SBwLxIk9WwIsJM7j+2BA4X3N3LqCmmdh0uvdXCGTzc7aWjq6vmpJeEHE+fYRnM3D+LqyWwZBv5xn8h7hHUh1tPmkLwUxsjq/CcmSVd2orXx3/hZv41GuqeMsDFUq6ru3dn93ZkV5cUvwmcDBAy9i0BauxL+pebENQoXo872Ax0o8sDaqRWe4oSgIoFu/NJoNtLpYWRSX1OORvug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mm54x0ZpfEPUTyp717dSMXaBikmpwNkOoQc7/DEi4Rs=;
 b=fWo5xYV3iNlwN3Ll6iWIMig1J8VSiC/ZE5bHdM8ZdUqvRCte7BcrWNr9xXZlgZKjSPzGyFrI5X6/Hhet7XRtyTzSMbLbZM/ByGN8/M7zaTfiXEH88k3ot2+6KkWS6CVbzqryryqDO4qo6bjcG/oBipETOrPMtYi/pB2iigAnWuW6Qml+wUEU0ds30q09lOV+6AEewHqNluTMb7bRQsM/56+hrBERyLafp3j6N6mGIEi3ffTQfrwGIffTGG4A6IJro5NLpz/V0usrsYXI0gsCgiiLqNDkm1gW+BZlfUpWvQliqjcKoAkFZUSopmHdMXMktVpva7b+k6hNFQMYX/Vo0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mm54x0ZpfEPUTyp717dSMXaBikmpwNkOoQc7/DEi4Rs=;
 b=g3DwqYtvou3anKTin3Uoxk0wDXnMqCtiOO6Ajl33aCK+0e+5LdK9QaFNn3DCaKeYc9C19OmX7xSrtvYSJDhdgjlkbSbjrhv27lSRq3x/1l7n/GHOVOv13Os2oIxxH9pgzE10af99sUVI/glu6L5jBw9MdW0ZyUM9OebozUCqOBEY+BH+WL7SWqKRptZTJrt0tNrR52zAvz9xkeWSd03LO0AvTSEOIibuqcNWMIEQgjAtwvz4pWVOxS7Wj8znak0uzhlX0AFi7l7YI6VdiLmr5WqpWkYjnpJ9aGKoJNNpZQRCHoed7bsmP23LLqqxdoio9HEcdb7aYHOQqwrx5PhDkw==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by SEZPR01MB4087.apcprd01.prod.exchangelabs.com
 (2603:1096:101:4a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Thu, 13 Apr
 2023 15:09:02 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3%7]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 15:09:02 +0000
From:   Yan Wang <rk.code@outlook.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com
Cc:     Yan Wang <rk.code@outlook.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        netdev@vger.kernel.org (open list:STMMAC ETHERNET DRIVER),
        linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32
        ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/STM32
        ARCHITECTURE), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v4] net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports
Date:   Thu, 13 Apr 2023 23:06:41 +0800
Message-ID: <KL1PR01MB5448C7BF5A7AAC1CBCD5C36AE6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN:  [VHhC3a7aJWKoe03Q7vxcoqXXRSI+VjgI]
X-ClientProxiedBy: SG2PR03CA0088.apcprd03.prod.outlook.com
 (2603:1096:4:7c::16) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230413150642.17871-1-rk.code@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|SEZPR01MB4087:EE_
X-MS-Office365-Filtering-Correlation-Id: b7726d68-79cb-4179-fdc6-08db3c3103db
X-MS-Exchange-SLBlob-MailProps: ScCmN3RHayHCvCmR7Mrip+46pMXVmOzprsLuyh2I67kMzgUfXKxcaDCRsLbQS6h+U+rj6I5q0jhTA4VD36DsI00bh6ZfcmAQefRX2a4WK8Y/dTfZmICND861kMNDrjmItKScFMh/LT7hfE3fYo5lbY8MkHDYZroZrDHsNIbyxRJlJXR1xOOkcpUcqi1Zre3amAJy83AMSybCyFCbzQkhh7AUEXGLhS+HunNRey0U0EiuZaRNBZSHfQlG1MOehMIkNSmuWiPwgX3KSfYuEMQxsZOa4SHFXO9szYYnmrCyECGT0tWlzk0jAK5Ch/Gr8IxUDfRaLxX3yntkogqNI/SFXSZCCbC8kIijyBT+vJy2ibtxDtc/eWn19g4luPsy6igsXUkqCZzg71dvXR6G4lbIW6cy5j8mxCNtJTwNA0A674/cXkshqtD7ldakh6gfamvpDfDBStkddExXSTUOka6+r8VB/6TqBRsp0qaPiERu8YWsY4t+GPp7hp2un7UYZPJZ4Nzgiv1Ponu0UXy+DakxRv+HuJZq+kUy37kJ9KDmuT0GDXnm54t8gfGr6zPsEyinoN3igKPP+V+/kR0cK04zuG4I7XZ5SbzqW9s/F1XLjqUSLldSuasvhrp1P15nEMpMkKDfxg6+zVXUjDTNNDdcyK8gdL5g/+UkJEJ1vr1wX2Cl/tLsshHngr7jtyD7G8iC48igwBjmf4VYnFRu6sh9v0hfPF2fTeYOCBznneKQlNs=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DfN6BNR93eOvJOvto/0Vr2oipa/0k8IPlao9i7CSpPUiin2qdINA7DO0sYNau2wsrheZR9wJ4qEHYWBSgqrIJUBS8qXr35vJaKEfIc929h7yl0PO4B0DJwRTXVG32VHeLZdQkW/7a6sIhh02n5gm6SRTJ5Xsh6Ot72g7U7Hr28dj7ROlxfVPJHzsiZEgYIlHyQBG1amE6rZXRP7fbpAyF0k4JSJ6AEOQ0WlihJyJTqaFbkHHG9jJbaisnHOhCE4SHD+FmTdiML9uFIv2Bf5IVQ/NDkZ0U94z4v55m4w+7gW13nBj9wiE4G0TRp1Om8Vk7cDFwYBe3rjZhC9G2hIVOiwVdUNzI+DWV0EO5zvVfYTaDp7xdC3s5KfvfmYG9vKiRHfhf2wFBfPSqrhluposLEPSDn++F7HJf0MpGikiXTGEwHDAlPqyNNyhPIcFheWfyQ4+BRJ34qv31//9xwYYvdaXs4vc1JJ/Z6GkkdulfHScFLYSb+QNHDbSUCUghNKmvnfvFTvZjMlh1ZBshq4PGHxkvMu07XNuY99RKdsBIpk+PfcVzu6Cwki0TO4KWORAk3tRGGeDpHN6sI/TGd1r1O+wdW1LPMR7ZQ1ZUKWN10/gqNzdyA1j3iX8tFd2rR8l
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pcDNVwOG1GWMFRm8q0fiPfRUgE0FaTM+aqoRcCEDOwUjuQkmbhccFN83BRBI?=
 =?us-ascii?Q?kle0iAGlv2b8m/fuRZ8fYVA/uldXBHUPhDi0rtHUc+ILeN4T7YBSbSoySxuO?=
 =?us-ascii?Q?D2J244SWn+d16K2hy+TWC2blTRpQpJmB1ctyXcKO1qhzb/OE4zVz5ODtgSHe?=
 =?us-ascii?Q?bFxXtVO5vn+WKYi9zuWF4Uo8mil25DomKC2gk0B+3cYYUKrJZUsTID4Lx2P/?=
 =?us-ascii?Q?BnYbKwjjUPohcsw3iirRyDylTSLU7GWCYOf5N5ji1NCKAhlE3Aylsm05e5jU?=
 =?us-ascii?Q?ugmZOsiyjznvptyMjpzE6xsL42TYzEkKFWOXqkbXQIyfq0QVJN+SMpoSFxUW?=
 =?us-ascii?Q?LOelpLwBVZS3UtBa0dNEK0FcnW7j/rEzHpSHUwOjMtQDfkektJAWtzdUbJNk?=
 =?us-ascii?Q?XVrmBemwGjF6wgc26vQ2EBv09cOa7F0yGER2vA9LAS+ntt/+kfLsc4pkOEhT?=
 =?us-ascii?Q?+411jZG4Cmbk+WpaXVSF0EfT61XfpAIhYZUZJ0q4nCF41SYTHzS4z4cE2Y3i?=
 =?us-ascii?Q?rE47/M5ymwr+gvt5TfgHafJBhwCmWvdkwC574gPpnxtAtkmHrraZskWKmXtp?=
 =?us-ascii?Q?Itl8JwVSoUie2KjVsnWGdVYR5AO82I8Kqld7MxgQVWdW56RC0l+RzUZcLhli?=
 =?us-ascii?Q?/ENMX4BVWtD1twN5QRZzruLfI0FBpxvujiwA10Z/0qJhn0c0QeirXcNBidi2?=
 =?us-ascii?Q?mP6YTfQFdpJMDKxe4Or4DAxPk3xc+S3X3AqgoefiIXO+kRpOaSxvKlj7oz4m?=
 =?us-ascii?Q?/BWyIdkN4Ty8qR3XvCr+UrrDccUtOMGF9zemRMtS3aHXJ+kEbeZEB9LWyhgE?=
 =?us-ascii?Q?CUzWlwMp31rsA1wAoCqUc/HUZ+mz9Oqv+vNZNTBKhdc+dI/hmsDGM1VZP1Kx?=
 =?us-ascii?Q?dMX/9TEQ1PpZGdR9E6J7Vp4emIV5jsK06wWrbbbVESjxFc5MU4A7foqlZV5n?=
 =?us-ascii?Q?pDzjyNbASygWya/hhy8fBCk4BSFMq4i6GTHJkhx7xJ/d2d0AgJ18Jp07q7FY?=
 =?us-ascii?Q?WtYDu2Vi3T7Bnskwx7xt79QvpFH14bl3pp2ktH6MX4glw7CoT9CczkkxEDaQ?=
 =?us-ascii?Q?pBF7Tw/bbGm/x4KaM9TnVQMB3gVx+Ou4f3QnddCgN8OkkTpu+fLAeJP3uZAx?=
 =?us-ascii?Q?3IbElFUtzgVI9bjuyzi+AeU/X8boGsBwEBnEhi80K/HDsGcaQ+sUdag2sYe/?=
 =?us-ascii?Q?ZAQRtac6oXzIj+CzIZlmj6WxLzygkJx/xWSgOQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7726d68-79cb-4179-fdc6-08db3c3103db
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 15:09:02.0667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB4087
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Yan Wang <rk.code@outlook.com>
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

