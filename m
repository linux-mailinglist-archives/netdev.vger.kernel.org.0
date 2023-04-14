Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96BC6E1A9C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 05:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDNDHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 23:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDNDHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 23:07:37 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2098.outbound.protection.outlook.com [40.92.107.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0C640E1;
        Thu, 13 Apr 2023 20:07:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmvO20Oiz1Gz0JZdmroz38L5LzPE7DPHtvR/8YxK+cjcBoNtSsMcQu7dcylI9nNOARCSJMUJMJVdL65X4SSlvmSfGJSV98IfQAAq/7bO4+tiVOa4z+x0eJkpUOYKEVdR6ZRc++U5scHm7QROzDQY4luVS9Pm5UccYSp4iXc7rOn6zxIPyHmJor2/MsDC+tAAAofM53FhN8gxUfa/j6VmucFLJMYohi9WZPo9+vyu1DT0GwCHw+P87KbBZXtGx3RwU/iOmNE50ZANuG525k5CAb4ymK27RcWbn4r4IJS3gJUc0bYBs1otb7hms7WMZIEgP0/XFBTlOlBdifNkZr7ZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jIK4SC7p8yB2yk84IM/RO1i+FnGMUmeG0uYccvF4+4=;
 b=faUQYGq+1XBoiZ6lqskUP2F2D3lwuK+yHWIxuFF/HWMRyftBFhm2AKfI+aqaSoVNN3tQvgnTLytucdaN0TRrmmduuZjmUHu6n9hpxddP0uMdxWJCR3d5MHszTPa7Rh/mi04oHkwBnJzAQpB/U6gq4RZMWVtHoXAxhfbCEiuqnEcH94155gcQrxlBZxUxFWlBi8zn5/XyjLt0+gent3Hb8T/Bqb0DjgpoppNpv2qPklI8TxD4Gma8YWhGnrQThvwHT2vT/rM6YRveEyP7oH33lSElBzu740vNHhz059VmGKHvzlYTrA3bZ+jeGLGUNg0qzFQ/mbjyN5HQumHMWLoWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jIK4SC7p8yB2yk84IM/RO1i+FnGMUmeG0uYccvF4+4=;
 b=D8dhzldTz5O3gZfOlYVEGek/5gFyFMfhQz18KCzhsGA6g5zgBbbLEpS1yY629ZJ8blXrbVNnTWEIvplkuwXAbtOyGs2QNmgeEaPYAsarrhzYINo5HktvvY0IRTuBNBqiKyMC2FIMAu+2+yos/VJFiji+op/iTcfNLLDEoWsQTEXd2eDOgQeDsJwLCAUy2vI2P138GUsGJkdygkCCjzCSoub6csiDgon+Aob1v49coI2VlxXjSK5g9V6vt2YH/MMFqCKLujewm91SUN4sVcY1FoI8Jvu/b6vf3C//Z9jKIlyJJni0svN33RdKcxOf9Jrl240Om/5g0HXt+yLoHM7zQg==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by SEZPR01MB4677.apcprd01.prod.exchangelabs.com
 (2603:1096:101:9b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Fri, 14 Apr
 2023 03:07:30 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::5bff:fd7e:ec7c:e9d3%7]) with mapi id 15.20.6319.007; Fri, 14 Apr 2023
 03:07:30 +0000
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
Subject: [PATCH net-next v3] net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports
Date:   Fri, 14 Apr 2023 11:07:10 +0800
Message-ID: <KL1PR01MB544872920F00149E3BDDC7ECE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN:  [cSbmDS+JFJOHtjoN62WoB98rJ1WDKxMJl2m4C8k0Ze0=]
X-ClientProxiedBy: SG2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:3:17::19) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230414030710.23068-1-rk.code@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|SEZPR01MB4677:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cab73f8-928e-40dc-8357-08db3c9562a1
X-MS-Exchange-SLBlob-MailProps: EgT5Wr3QDKx/5wRYKwbtF7hqq2E99L186u1AuTHSMLVr8Sz6hezcPG+NQIGT+Yp7R6M0NIbr/oOT80gOckGVrekeyDe6+rdwOnZqY7LSOhJz+i0dExKRTcBrB42WiSG4UP1Pd1cA4B70r3icydSmhaDtiIEY0D7/wOdeZn3HjSvbsJnNWtwm7tK0E5f3SqcwhagygVvF12bU+5TXFEWhMwPhICt4y5N1aHoYeVFNcnqhK3kBKdM2JRghXzBVDN3lVb6sfGtTr0GaDSQem0i7C5PUDepJ2s3oN7F3/qXKLRosODa9x6Q7R67nV53YLykorNm/NVM67R9o6FIolMFCgAlqxUDCgVdvL+xK3hT8squ9hLH69A8ngPY6nj/8WUcfG9RsENCfZ8K1pkZfsYPYflzoo8l8zu9w0a7FQbgaeVZ9iHRQq6TAypKnJ/EUasc9fL4JZ5AtRTrJy95M4C4QCnKiFNhpV53GQal2I2cq3DZrmAWVx3KTkZVPKUvrw+tn5ZD38rPebgY+j/I+o5GFL5T2Ev3FRD0WioAtxahS2cJynRnhtmIGsv4Nxf4A1F2MehVK3Y/bmclr4i1EIaAmc34CEnc/A00Q4P3nVn1+GMh5+ig/gtFLjdBxlQEeq3Q+/pG6wVMoO4IWP21asAvavOujLZIrLrrqpm7CNxvz8s1v2JVYeLgLlkhAynYHZnHd+2sSWHDZ1RAXT0xTjm/ZBAdacFzVxLTn793kswhX1ag=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KCq8Rw/pszmuIizy4iR0EsQhS5s0ffTAhn/te6XvNKZo/5I2OwzPU42Zza6fq1BxiVcz6Ke1d4PJAIG6yqTn2IzSpbXDlSvzujsUslrQG8PZGrnxyhgKOmzu5NXROmiIK+nEqv9ERMBqppgbIukSYymu7ehn7GQpT5dFQsbilSqoeCiexXkwRqxYRWuBARcU5PqGhp8a2IbkXHugIQ9NxinvAySY3W7D+TPSdMCyny/vpPhH10YMoV2eNJor4+WAXgnklbSUHUxwhDlruC2/CykyUZmy4l9Y6lAEEqRGjPVc2WK6haOqR1sqLR7gNUjtvFMwSXuF5wcCx0wmSL71WXXKcOg9wAmHzmJQ+tWrB8AXLGn6guYFyMDFIK9pKjaroOmZ6MDq1Oo0dcXxBra6xCJ6XVd9agRMh5tcID3jLc7vnurGauGmfBIl3MH94RYGo8RHr01QTBSfZZKeZ/LM3T/BM9lEQD/WP6XUuivKFZ4bL6Wg+jn4svkjsHY8g2sQCyHp/uvLJe+XHJXpu8RYy2NZd//N3JfMp9fnm6s6znoVqzVlwQQJLlXBWV8PMPPXFsb+zh/s/N8VzLgfZKUqM/vOWjJY0dNFyg54mGPuAOlkTSxCuio7/Z5z6y1G5pwb
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EIfsHeIk0IeBVj9jYlOkmjcSUDgi8HxIdLlR1uMMSbMJ9R4ZM4cpWmY0s/dj?=
 =?us-ascii?Q?mJuMNCIENAVBLhMa8Rf0OeU/coZ4OwSb+5Ok5+1NlcKOU0u6hIwFtwR+cBVQ?=
 =?us-ascii?Q?6bFIhDeqWhtd+rkkDqYqywfxM8ONn53lD8WODj/BwHS3k0JJ9nip7wkf9uql?=
 =?us-ascii?Q?apJjkKd05LHS1bOQXgD5L5zv9B5BgkdKmkxulk/o+7Jn35oXoq9Yh7UekbLk?=
 =?us-ascii?Q?U0iSZhNGAA7x4RONyXyz29SEDLmDQNeztTRKhyDA+1e+ftIN9xx6VQv6th22?=
 =?us-ascii?Q?r2ZsTqXZ6qNM2+hm89PCsBsM9PmJ4FqC9/3kLjEgr0yrQp6YvEnKfAkRKyG4?=
 =?us-ascii?Q?8tEyFS5FgDgJGzvnyS+aP7VFmZG1OxLqvNZ9Jao56jvBOnn6fyeZGBNsx/uU?=
 =?us-ascii?Q?ySU/m2sUEkLLUk2dNwI3vE1dUkCHTSTXsvaRHlyIeiogJGKYg1pUzZu5tEAN?=
 =?us-ascii?Q?WTcc3/RtgXywAORz4mr5YcmWYLMWdx2GTr1ZVlLDEzK5Zhg6Uvy3HohRcXvO?=
 =?us-ascii?Q?B8iumzqYbxyYaWQA5j4MYCZQ3DC1bgTVSYPp4Gp/5rgYSKr7/Ai0xHXL80ct?=
 =?us-ascii?Q?jYsBZR6NV3896P+EgjogwUX5QZOlcIQA0ZQgWlJtCoo9WGE9UGulU/6CFomQ?=
 =?us-ascii?Q?fyiD7rcOTuRdJsjpSCSYy13w2x2guWinhN/3a/yKjGpz3WQ6uUxJWBn9Hu5t?=
 =?us-ascii?Q?v1j0XiBs9F0ur5bXUEseYY3c5p4ahPdWiu4/OIPl3CLJJi5S9ktuVdXznJZf?=
 =?us-ascii?Q?l/98I+t8wlwsV2tzG6Qq4/KyEH6ApLfrBXF7p6+Urb90sdG45NtPvj33kYd4?=
 =?us-ascii?Q?/zIiTqU8AKkWmBn81e1nU972k+y+yGtr5invEfYnqEuQ2VtxTS5WC22/yWwZ?=
 =?us-ascii?Q?Q+/LeWh7mk3MQ8Q7l/LvEC1CL6JptzTvEF9Z/XJc4JX79lzmiaHdZboxELVP?=
 =?us-ascii?Q?7WFCckqy4+8CV0Cavfif0Ci+cxPQ2o9EyJERgm5MX3o+SWYmn4FcmkHzje1U?=
 =?us-ascii?Q?d0Gb/TwDEQ8Uk7eWveiFzDux2aF0n9fxDCcXcnHfZAWb9frTJnZA4KXkHROV?=
 =?us-ascii?Q?J1DbuHy/nJqRYOqR2FWXx13OivDj+7NSN3xp84rv9HEiR2T/HZBrvks7hefj?=
 =?us-ascii?Q?kjGKfiNE3RMGwQTRu+O4uFK5U0IZyF3r/UkMjEfb0P7SOVzWr2aEi19ju/Dj?=
 =?us-ascii?Q?xMoXnxNyO/7MvurXQ3GBcXt2OQljO3wcrYlvpw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cab73f8-928e-40dc-8357-08db3c9562a1
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 03:07:30.7859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB4677
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

Fixes: b3dcb3127786 ("net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()")
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

