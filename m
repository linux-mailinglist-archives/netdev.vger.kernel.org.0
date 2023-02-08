Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16F068EF8C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjBHNMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjBHNMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:12:09 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2113.outbound.protection.outlook.com [40.107.244.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73424D51B
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:12:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGVbDgiUwnlvPtqA0dr7RsY18f0joWSLoSyF2SgFsPzRatTBlJ1rfNB3nIiRi2DYP05QlNVeo+ddEuzdp0hKV/RccCVJV/Pvo1gLMxMYf0fIuMm775gqnqWSWfn1UMHqoTTAqFjmkx7ccK1ZtJq6mLej1EQ65Lb4S1waH5s4J//uiOGcs8NftZMdi8sqQ/qlMobcL5qYfZIJlnbDKU/w45DYGXJ6twPOXFbwpCMhcgAOyrQwLjgu3GqUqmjE1K4huVuWiqmCKOlUIdbGl8U0yOVP9UFy5PQLG+4csmDricScxCLMJUGRcvk9NVdjDfW/aqdl1u8Y4KJSWVqhPl2MDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiofy5GrxG81+GgKDLyI7saci1wwbx4NGm27wwzHctI=;
 b=fS+3/5G6kjWtM9TaqVyIf62I4Rhu5UCu/NlKpux/MfT9k0KmXH3FHckskbbZ94eBaGX1HbClil9TmvyfSi/MYQiduBcznyYf67UMvcu74LQR9Gz0EDYbuUPlF/ZfldPk27SuU1iIvnvACeDLCwgsLPW9Atd6R4xYC60ZeW6zHkZE3/EGKF6bnpxn4DOed4Zf6rQEhI6fwX1ZUSHBztCtVBOzlkJKDB6k3RWnBOXAp9UuFpEI+JNTTXcrin5mky1J+eHvRLkDHPJRlnxIkTODO8ybKR/L6emA/0bEYUh5sSOKUabJbxEagvquL7dFVvkZHBbqPiWqdAnZ0X32ELRoJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiofy5GrxG81+GgKDLyI7saci1wwbx4NGm27wwzHctI=;
 b=kN7BrKo8A5WkC3M79WjqXCLTi7LhTHde5rrd+fpBVlG1nWtOQxvNtmdc00YU8atPV98zXlosU1u01uXFKbEcRohQndn9QH0V1ffLS1ootxBwaAEe3EWdl2OH1CLkQvS8aoY3rlb8WHgbE2Im5qzBc6Oo9M1dlLhd2ELLI2DBrWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5613.namprd13.prod.outlook.com (2603:10b6:510:142::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 13:11:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 13:11:59 +0000
Date:   Wed, 8 Feb 2023 14:11:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Guan Wentao <guanwentao@uniontech.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: get phydev->interface from mac for mdio phy
 init
Message-ID: <Y+OfmMeP3Eto3K7t@corigine.com>
References: <20230208124025.5828-1-guanwentao@uniontech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208124025.5828-1-guanwentao@uniontech.com>
X-ClientProxiedBy: AM0PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:208:136::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 34ba4d1d-a7ee-4e8b-be24-08db09d60f96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M0qUa4RnBFqENoLG4s4bidAwAd138DWV5HSjhCHq0Cb0NvCgeNWb3OKRMLPmCtQX6v2XF00lxT4Cve4Y7i+rAee2xZ20nLnWs1o1wwJspubxg118MnYQSVP364vlSl/LLokJXHxY0iS0LgyVTYHs3qbK86yhxdeXsLwgW2H5D0hIqpHir1YcdgskD6dc2Yzn3Kk+yVtYpzgavxdpitB6cFuK6ezYaU5SRenK/mQ0HjM+KzQWD65E1S/AXeV1jLdMacvAlPyA4glGS8PZvLA6McdRQp3D9gIfYoVQc5/5Gnchxh619DyzVajMQo1AGHH2Z1mNPIV069l8LpnK2eMtOIEAOyt4n+bKBzmK4U+G+R1/627MvifXYcA7j/zF7PreH9zoVYgY1dhQuA+3cjKus15Hfq6VEtnBih01gtHk/Qqk8pLruAYD6QaI10WNcZB6b74R82cCQeCQ9jkJGsw+SclO9h81eIxet8BB4MXuiIlhO0kjzlXw4l9eI+11OyMcHFCj58JLl580ZZwoIhRHJIpHxraChz2wTOs2wxCaqEYc2GmDHqzvqpGJV2pwORo4xy9hG+uvChbCZ4bx3OxMfkbsQUwho6iQgcfZVzcn3tOT4XNAWNpY/G/giLH1xik/VwJ6y0x/O/jeM3zZfik6gJbOzTL/0Kb1ARH54MzHgrYzQHaz4VkRYzNm1EGZ7SoZmE+ISQPQ1wd+USzspmVj1claG7koeeVuAt5NO+TDLAk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(39840400004)(136003)(346002)(451199018)(316002)(966005)(6486002)(478600001)(83380400001)(36756003)(2616005)(186003)(6512007)(44832011)(6506007)(5660300002)(86362001)(7416002)(66556008)(66476007)(6916009)(4326008)(66946007)(41300700001)(8676002)(38100700002)(2906002)(6666004)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f5Ip++H7/H41LeItz6LmJMvYxp0qOeneyX6VEXyOPMOFX7U+oWOFX6w+61+f?=
 =?us-ascii?Q?4fxOCfvHdmJXizUi8GGwSMZDcamyXd2FhofdZpwC/jv8BfFKLKWFHY6Ujbj9?=
 =?us-ascii?Q?D/Pdrnx1996TVlY3oW1/o9c7oLC0pkSFwmNlIB4e+3IFeeek+q6TFEoRovUq?=
 =?us-ascii?Q?rA2+TL61BOOSozMAhv4oJ1WDnkVgWw+68aRVJBTC9q6esVZAOqKp1iAmxAMY?=
 =?us-ascii?Q?NXcJDlQOZCmKo8dIxmQG/g0F+tAagchtHfQ6fpDpxN//v9oMIHXwK6KXgRLX?=
 =?us-ascii?Q?GUufz+86ibYgqZuGaWDm7J19StbJJLCoBOiIGgSBP+YiKrQSyTukpSgjXUyV?=
 =?us-ascii?Q?8TcfUFjHwRl9qg59vee1gX1cTWiM14TAgJES7NQewQKKUYmq64onIBcbcjAs?=
 =?us-ascii?Q?Zsqdvd2avULxXwOXn03obAQyGTmEG7iK+i3zaP31Hp5HgCeXQTtkxLXBvBs5?=
 =?us-ascii?Q?L6g7Qc0dqz3EzVVCBlFWLmZmf2u51B7UpMDjB86aU3tyKxFKgzN1mdHj5yuc?=
 =?us-ascii?Q?T6leL3S8Grfv1DqgwKZ/ShRlQQLM6i4cNp6eXL7ICNcW6ldZpwyuqq8bxYBA?=
 =?us-ascii?Q?w5LhQMlupKvCAU7n4aEmMDh3nPm9RFLA6D248iJSJuMy80PXcpUWN1AwUt9F?=
 =?us-ascii?Q?eHRPHs1C8ID+jWtihMq1uHUmVGm19JLOWEvrc7qRJtIOF2abCK8k0xZruJV2?=
 =?us-ascii?Q?iYscOcBZG1Dndu50yS+PoenCrdNdNlR/ZYfuPgYeoRNA+PJ+AJ8sCR5sovSd?=
 =?us-ascii?Q?AIW4+DHFQnflX+XHNwcOyWlptQ2GehLdHXX76Hch/tR67VknRUC/w+LVBYqo?=
 =?us-ascii?Q?gVWa5l5kcbsbr25VV06CRCY8qLLJGDnw0XM448XhpOsCLxBNzxwAiu3TgnHb?=
 =?us-ascii?Q?RVPqe+76tbsWU910CX4bsQOuICLbMtZcYYtWe0B1T7KzWS09EhLr1wMxde5r?=
 =?us-ascii?Q?SBkvJ1SBjnIaZ0sNhNJlpIgiVDizl6XDkMXooxgobdRYP5/wCfnxWFPjpbqG?=
 =?us-ascii?Q?GX7XifaoyX+8mc3zbBgZSpMuQcwNtp6iChpt5f7VikdiKL3GwgxUsXkn/HBr?=
 =?us-ascii?Q?+pboTw+/OfZsu0KVagP7OAOAcgBVa/4JPFHuEaM8+sTeN043Jcugpg6A5SJ0?=
 =?us-ascii?Q?f669Vt9CnVAjkn9EkcuofWCA0JxvWre6FCC5ofP19nxHaCSMcsDA4mVxm4wr?=
 =?us-ascii?Q?ulqt2KTrg3pbmoas00exPY3gcf/cV4QNm/Q7yYX6i2Kal+1UGaNIbIGOkFvB?=
 =?us-ascii?Q?h8nMkzy5bT0DG31IrFcwhX3bJrk/7YP5fe4lChIJp4CqNjVBEtEGivyIo9PN?=
 =?us-ascii?Q?OZqDnFQs/NaSnb8ODAxdIHdriKh9fPNZ9GIWmprp1XBq68DBoVaE2SVAlG9/?=
 =?us-ascii?Q?zbxsYDFbj1Egt4ttfuX1TrI+gLqOE6gRCg2fi3MvXSuIO34ixoqRvZXLvG8W?=
 =?us-ascii?Q?h7l9rhlbyWhVoeMP25E5/ykyxwyhMjx//Vs+RW2bDdTjbrIHvzUoi7BypZzS?=
 =?us-ascii?Q?/Let0ff+J00RnN2c5T/m4wYwmwXS8SNrmG585RWzWzj8Rk//bi0jEs5cZal4?=
 =?us-ascii?Q?KD/bTrIicXE0OQlEcoPtn1j/n/LUhX2xbKCchp8BEJfAMRsNeIgGGLs59d3p?=
 =?us-ascii?Q?f9etIvDhS6RXz7o6CSh0SAZs2weMpuQEh/+GdwbJnFH5t286nYNE67wjqtkN?=
 =?us-ascii?Q?25xs1w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34ba4d1d-a7ee-4e8b-be24-08db09d60f96
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 13:11:59.4120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSMrx6ipp8tSj6B02UoMpn8lKF/Ga74FkkX6rfMC/cVshFwEuivPuh8ZSpr7VEna7Y3lkMdZivvO+EHc6Cix5POE8ClGlHlEA1LgrrPtvVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5613
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 08:40:25PM +0800, Guan Wentao wrote:
> The phy->interface from mdiobus_get_phy is default from phy_device_create.
> In some phy devices like at803x, use phy->interface to init rgmii delay.
> Use plat->phy_interface to init if know from stmmac_probe_config_dt.
> 
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Signed-off-by: Guan Wentao <guanwentao@uniontech.com>
> ---

This is v2 of this patch, so let me make some comments about that.

* Firstly, unless asked to repost by a reviewer/maintainer,
  it's generally bad practice to post a patch(set) more than once within 24h.

* If it is a networking but fix, then it should be targeted at the 'net' tree.
  Otherwise, networking patches should be targeted at the 'net-next' tree.
  In either case this should be noted in the subject.

  Also, v2 (and so on), should be noted in the subject.

  Something like this:

  [PATCH v2 net-next] net: stmmac: get phydev->interface from mac for mdio phy

* When posting revised patches, it's important to note what has changed.
  typically that goes below the scissors ('---').

  Something like this;

  v2:
  * Fixed blah
  * Updated foo

* Please read the FAQ
  https://kernel.org/doc/html/latest/process/maintainer-netdev.html

>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 1a5b8dab5e9b..debfcb045c22 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1162,6 +1162,12 @@ static int stmmac_init_phy(struct net_device *dev)
>  			return -ENODEV;
>  		}
>  
> +		/* If we know the interface, it defines which PHY interface */
> +		if (priv->plat->phy_interface > 0) {
> +			phydev->interface = priv->plat->phy_interface;
> +			netdev_dbg(priv->dev, "Override default phy interface\n");
> +		}
> +
>  		ret = phylink_connect_phy(priv->phylink, phydev);
>  	}
>  
> -- 
> 2.20.1
> 
