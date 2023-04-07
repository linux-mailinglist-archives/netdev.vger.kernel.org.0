Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7781A6DAFD1
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDGPmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbjDGPmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:42:06 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2086.outbound.protection.outlook.com [40.107.21.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9537976D
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:42:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5j8jyJdK7gUN+tQokKb6uBbaQcjlDga04mEoUMqC+dZPSqzf0lIrADNeC9N/pCJz5d5f5do+h4HGcpy+Df/mZb+teWdvwcSrEfJzUrjqwBfwfLVYL0V3+kaWM10x/wQtlMhCKWYdGwdkjzDOisZAHJh5Ke6zZD0elKLdIEMH2/FZKH73WxBYE812sX2m/rvU04vrHnjFp8ZpMdkk+DfUY/sQymrTJJwcrutCRSDEaZfoBcttEg128F0zhfNif+ooKnMyI+CxgATNujVRbfIxWepyWaKs6bMTZnp0UZXGTk5Q6Ev7unHBIn6lfzW13Qw2oQWkTv2T/cpj9DpPaAmrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XRmPlWcaQmYRL9B7UIBIMEcrrlLLiAjn6O0tpsz84A=;
 b=f4b0kZQJdkHUFulUZznxLZGOGX0XIQAQpCeqs4dVxO/fWGsfGVRwBhj7FBivtuxUb50g9xvu4gcyeOVvwZI9t3sFzPPDqJWVlOjSPUdTM4YPxhn1kFAFg0J1amc3gk5DG0I41npGXz5G+xcYft8Ozlp/NUaQoKyGxKe+EInXJ/q7TLWI7Kv8xXZzebSaErVBcHQZ9ksaD4rypWlLVu37eDkkSAwhXEA4MaAHH+IHqzBAUKMzUDrOnROhC1qTmzKaPvhR/OVz18jFrxnpQM4P2isOPPgJZGvaISaYSd8pRJbJyNJ6Cbm5yV7Sp5aU+RzxG58N4r5cSSPG8Bf0c+D0Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XRmPlWcaQmYRL9B7UIBIMEcrrlLLiAjn6O0tpsz84A=;
 b=rnzHpCT6A2XplZN8Z+PssycoFrjHnhL6HbSNtQgJq6xzX5GZgiTzBxLwtK+xK1CGTIbMAGG07mTyBWqcJ70/2PytKWBJYwufY5Vu4JD+KWa8e4uXFJDBYLMNqF1st6dRkUyz2oSkPzPTwz1uzHzx1bqIb94tDB8qCY37uThklfU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8459.eurprd04.prod.outlook.com (2603:10a6:102:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Fri, 7 Apr
 2023 15:42:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Fri, 7 Apr 2023
 15:42:03 +0000
Date:   Fri, 7 Apr 2023 18:41:59 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de,
        Russell King <rmk+kernel@armlinux.org.uk>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <20230407154159.upribliycphlol5u@skbuf>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407152503.2320741-2-andrew@lunn.ch>
X-ClientProxiedBy: AM0PR02CA0157.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::24) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8459:EE_
X-MS-Office365-Filtering-Correlation-Id: 80a7604e-4995-44f8-1a93-08db377ea231
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 67JZLobst/thWL6QrstRloDzhNpD2uDBOTIfjLJZ0DSgfTFc+qACvMN9GjHr8CAp9tNv28ffh32SgaX6Czkdu+qIJOFV1WwtDNe053R8SpwMODELFcSz64djG2Yy+2P8ax+Ys0udB3jXpdyHbKKdlZoYpCpN7iVVKJWuA8W9kRJbwiKvOzrtUVv9wa0R/P9yBCC8a9hfp8ok4u6hukjiZIn2zyzw5QIg1Qb09vrrsFXlPFHfExqxHOM6WNPoIX560F5g0GEClqoHpjRx9DNONt5XhVTalGO2NvRJVpBYfjH7HxryKsyW5urm9806RTnq7zqQhrgi4P9ZxuWyN8PffLeQSrNLn2q7UEpRosKDn3ZMnRyfEfqqnkmFy0EopISevjtCt/P7+rTJYQKRIueyQSF6Qt/V86q6UC7qdYiZUSTlbioTTn4ZzRVtSEC6rwHUqW8eyej5CyAUvOuHCsEi2RJN4Ex3SraaVhiLKXGS6GiUBIvXHIDb2rXtFf9yPBsNtjMrpYP0LmiNHeDcjS7mY+o51/hHNVKQQBBWvyVRZPhPtQgPsY8TgVzY7+LFAv5r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199021)(478600001)(6486002)(6666004)(186003)(6512007)(26005)(54906003)(316002)(33716001)(9686003)(6506007)(1076003)(2906002)(5660300002)(4744005)(4326008)(44832011)(38100700002)(66556008)(6916009)(41300700001)(66946007)(66476007)(8676002)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UhQ3lfc5rC7/MhKq04gglwn9qUKTPAtpIs4O601bZ4NmdfKvv7ufKIh5ZcvV?=
 =?us-ascii?Q?ESLzB/dgrnvBSLv3DwCjGvJOBFkrwcOnwPQWjjn5sqvMEHuZ6YCQJ1FnmtzD?=
 =?us-ascii?Q?oZi2DvASVn/qtRA9YND5szBwCII/5lKVNzk/u4CVkn3L6FVFdrLILSlJPLsA?=
 =?us-ascii?Q?o010vDAmJQJ28ba4fdcTgYuIlGKf+L9sej9Sg+igYMuWHN5cXSt9wL5CtR7/?=
 =?us-ascii?Q?fgi4crBzPD4iQfBB+5TZW0gcr+CpgsmRgt/ZVVc4eYKlypeSd/drsZQoFfU3?=
 =?us-ascii?Q?ghmKlwJPOlOgEXGWUuwulunk8SmxV5/4i5I9NUXxvabTSinXnzkLcY5OPwNW?=
 =?us-ascii?Q?N0s4fIzZRSN5WOqdui/bEdZYZQ1x6a9icUZeqUuRGV4/spUA/ktTcEIUUgcj?=
 =?us-ascii?Q?hAJXVBzUcy6h6phPD4XSP12k2eroKkDRj1fG5RhzQD9PLG1TbLEs5y4LmYbp?=
 =?us-ascii?Q?OnPDjsi9ye9UZUzKVoAU5avRsZsCQmR8TlkKFSq6S4rAOhjqeO6Z4mTtz7ax?=
 =?us-ascii?Q?9MYivK7Bz43JpxtgZfB0JMQvzzprwZNZ2uGzzH1YCcTF8UhtxxWpbPFKVdYZ?=
 =?us-ascii?Q?KQLmsVRMeOhxkOHW3LQwkOd5JcPu4FbL9leSNeA6QMRh74JL9HMkPvweeT5p?=
 =?us-ascii?Q?u85PTh8gp+FOpLiTPcCXRljuk0BhkWjuJuM8wLA/YRZGEh5MpTcRhxtY5laL?=
 =?us-ascii?Q?XJQhsTLFbLf9QtJX5RjtORaWgrekqpUlmXNnAeJfLm18aKJKxFovL/+ldcWh?=
 =?us-ascii?Q?wRHVlEuG0JC6yjSLfa6bROYJO22MNEPGWZJCB3dfADK1WsgJxSFNdg2wcdcd?=
 =?us-ascii?Q?q0LTt47wOJfLJp4xNCns5ZGfBKFaFbOlJdSnI49G+wVw4pbVAaal/1Xs7vvB?=
 =?us-ascii?Q?Lb3VVF3gF/JtHSNkT/kH9w72EetoMYjMW1rZHBYvrIZEN1Rpmbp+WXuQX/oQ?=
 =?us-ascii?Q?1yeOMYAN0+jHyPofN2JD8MyWX4M+3rKW7zEQleF4R8WnTD0UgYF2PB0xNiRv?=
 =?us-ascii?Q?QgeCf8OsllQ9FS339a9KNVL+xB45PcBPXAOJH49B+eRwSS6XKz/1doG/bog/?=
 =?us-ascii?Q?WcMdylRz/rK4C4vBoB83AtXCegC/e+RJgFkrj7Dmt8md8lzTmCHyTzpTyBfd?=
 =?us-ascii?Q?/ZXl7lCWuggkyQhPkuzsxwsRStuWssORXlvPSiKiLhXvEWPFEPOedS7xvNUU?=
 =?us-ascii?Q?lMZI7m05amBqtbjsavTyMT7bkwCaqNlyp5ASR6KhdtXfivqMLxKbw/N2aT97?=
 =?us-ascii?Q?GKKwqxqq5CWiqhDBV43Jkl1T2wW3sO3YKjLDcEz1Uk36f9b5aJzbbTCCsJUE?=
 =?us-ascii?Q?rL24WmV7mmRN1fI2T7S7LUEET8jh3cn0shlVG5B4CxbuUCwJfmNb7PjpSSsp?=
 =?us-ascii?Q?1+1fhm4YuvKk1J0V4iFl8BP5dPOcoKKiKCq6FCX7+I8H/VdSq5F1ybTlrbBh?=
 =?us-ascii?Q?cH1hjDntEmojwEWy26BpxDBHYGXe87/s8e+aT1SPWK9QJw5yoPa4IV6uAqrO?=
 =?us-ascii?Q?Nk3Vp5Ga+hIZ6yimh1kuKp+WixsfSCAewVLHj5n/wYpjCVhyg4kiTVBbp1Hr?=
 =?us-ascii?Q?O5OKBCcyUfj+Qzrn87XVPdrg4QcKU+cfL0GBxScJdiQiPg6gorpaj+63p4Al?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a7604e-4995-44f8-1a93-08db377ea231
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 15:42:03.0988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfQmu/pKSQtR/GDO1d6W2XhVv5jRCfPNYZNKSRWja71zKv8zBcyNuWndpzTWQw8t0kCLs/CJ7HBhFnIwJ9jnpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8459
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:25:01PM +0200, Andrew Lunn wrote:
> The DSA framework has got more picky about always having a phy-mode
> for the CPU port. The imx51 Ethernet supports MII, and RMII. Set the
> switch phy-mode based on how the SoC Ethernet port has been
> configured.
> 
> Additionally, the cpu label has never actually been used in the
> binding, so remove it.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

In theory, an MII MAC-to-MAC connection should have phy-mode = "mii" on
one end and phy-mode = "rev-mii" on the other, right?
