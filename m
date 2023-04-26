Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661AB6EF631
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbjDZOSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241300AbjDZOSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:18:41 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0980C7299;
        Wed, 26 Apr 2023 07:18:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhA2jTqN8fyy93NZtsVgxpsrwPl0LEXHZJZ1SRgf9Ok4Ey0kaNhjtMzfhFmAGBo3Cu28ljFHZiq//zo09IXA3nXnUaTwwLtXFe6EUAXRWtFVtwpaFXtvoeGDoPq1u0773qkyiUGmDcUfWcixSmUGWgfthDrCLF7DIBjCGsfqgDqyCRaVOkmVTGnIeUkQubLJoR/Hqk3uK+C/5lW0/lwhjJHvLbqcm8kKYNU5BSBtIYFErndzrT2E2KjYgEULxI8Gdd+IcqXxNv755j9o9R7PmnVQSFHgS636Kw8eo4WhCYqiU1FNWVVdb0xCADUlkBYtKQO7m+6bmzg9EAOSJiaiLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+ZFfrvkiKPd2w2CDCUp6E5IJyirq+CU+F9VyZx4Z7Y=;
 b=cUqy8AedY7ddqcIjE3xRNHWRrdVt/me6tP6LcEZeDrazSHm2NxIBAAzcf1nprDDSJL75sLzAmm0TxUkdR6/KCC4UT1BN5bygYfZN/8zghzjRwWOUtOFDdcMcQD3jVeL0FXquNQkGy3CKjrL+VpgmuozVEVL7SB6hy37ySWwXoUWvPt57b9dm1n8Cq55kKipPxseDQVuZmG5+T4EQ7gIHhcHy356MSWA7F8oTeieuMWtRfrlAxj8UqDX3dp/NlujdsuRKFDDGVujgnrqSealARBJ867lIvaneK8vSd86MP6FCOM9/H6qKTagDUV2a9jGlK7/qktUhlXpqTGJZ2toirg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+ZFfrvkiKPd2w2CDCUp6E5IJyirq+CU+F9VyZx4Z7Y=;
 b=YduvTvxZrrbw2ViqWXFkPrOqHfZG0YxBUWIdf5d0CsmCupz1Ua+mtvUYg4jwpeM3jmGRINZM3x3PInyTBntV7vTh1sgWqXufRGUHbpIxZ5jqDnKIQ/O0+GLLv9Xbr62h9RXWwzqtwiSrHCuJGA02NGUZ3y9yG5BVpDpKn+Qcc6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8284.eurprd04.prod.outlook.com (2603:10a6:10:25e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 14:18:35 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 14:18:35 +0000
Date:   Wed, 26 Apr 2023 17:18:31 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Katakam, Harini" <harini.katakam@amd.com>
Cc:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "wsa+renesas@sang-engineering.com" <wsa+renesas@sang-engineering.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Subject: Re: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02
 with RGMII tuning
Message-ID: <20230426141831.cxurksrsnj2c47vv@skbuf>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
 <20230426111809.s647kol4dmas46io@skbuf>
 <BYAPR12MB47738A21AE76E4CDEE28DFFF9E659@BYAPR12MB4773.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB47738A21AE76E4CDEE28DFFF9E659@BYAPR12MB4773.namprd12.prod.outlook.com>
X-ClientProxiedBy: FR3P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8284:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ec82099-40d5-40e6-dadc-08db46611f3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dYpUSVS1vS0iMHZSF/i+NmX1r/SDpm4DX9zPaevrN33owk3R/OxpykQ8Z3sNwqtCukdPdWN8ARAKWULP8+k3cIDmGEFOenTKS5LQ/UVwzTCyJRIiuz7OYvtttoD1JC+RpdvHPBdbPTEtzmq+mBiNG5WqkCs7EQ+YohPEB4EWoYFp6e15CQYDTuZ+3uvqhpRZOogvbAmvd6YELYtYwgOQ3hmw0vDCLZlYUQATdqWVZ26YNkw8WhZp/uBMpL80+U/tgjqdAj8UhfYtCNc70fQfJq+pIhv5hDvQDWVmA129Y12N3dstogJZziP+9c4gC0rbnhMIj0XBGxJD5e62uEksrkejpdwa3jkSGJBNGqh+kHiMdM0pAp4+a6jte43UARexOKGpP2lsrGxBI2nTK/q/amA64y6dE8YUimWsY26Jg4FYM/h8NNchRhwRk8P6rIJZZrljTOzoKKcYq6z+rT6RNvCHJ7ZOoYVfjmFyDsDUQgBe+YCd9tSTRJs/8GBRZtMbnuefCryyAFG/DPgjC2AQs/SgQfdn/cxVZArzlWdH1nquYRL3Y9OewL7aDf0KjKK0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(38100700002)(41300700001)(2906002)(44832011)(7416002)(8676002)(8936002)(5660300002)(86362001)(4326008)(6666004)(6486002)(478600001)(54906003)(66476007)(6916009)(66556008)(66946007)(316002)(33716001)(6506007)(9686003)(26005)(1076003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4HRi63lEM+0mWqi/KEV537PXPdjSGzg1r9O6uUrfehUoUmnTgu+vJuk31reb?=
 =?us-ascii?Q?D0f0lcdgL8jPh/et9cim8H6oLyWDLRlt950OEVFax2h2yZQFbJpL59TEpYbC?=
 =?us-ascii?Q?kSoPM3H+SH+NjzPyTe/BMiPWyo0xCkPueRbt9PqZcsME9NzYI7eDwCKcBqVg?=
 =?us-ascii?Q?aRYoVh/zBZHID5YcrajIFQDG9ubRQu+zob16NSV1+eQCIcZsoU6zNnFzD5bL?=
 =?us-ascii?Q?fgMHCgMouVaNIc8TzshaLuQMzeAku65ulpHoiWA3PXXxBLlYVmuF3cm6f4++?=
 =?us-ascii?Q?zUNEyUheQGJ4d0xhJFghnnd9Isno2n3wBaaQKNjXzH1zD6ZMtfD9mYCwjsU/?=
 =?us-ascii?Q?JmCA9iCaSifRCfWBj8bxiHJW4v4Y+2Dsx2uxhH4kVChInrN5mUT05GqZIleg?=
 =?us-ascii?Q?/VaPdqkERno1Y3qFZzL4t4NF/EanKEtb3FWwEdhKcKBQew+XIznatfyRJls6?=
 =?us-ascii?Q?zfqfoT9Sok/x79jBxzRqb7CHp57ByVf/4LExUsLUC3lUngvM09LBVc4zNt8T?=
 =?us-ascii?Q?RKG2zw3AUZANiR+5Fs8GuzeW84Oy0kXllbC3co0oM3TBub5CXBn8rkQ6KCe1?=
 =?us-ascii?Q?/MIpy/AV8k887Ndjbo93r0y0ixZxyxyDGfT3zUDEAVSpAe6tuH+7VCPJcb5M?=
 =?us-ascii?Q?MyyXG+YMIYchh0lfIYwl1x0+fa15LUaPesdvLBUCkIXSX6S0KQtYviYL5chO?=
 =?us-ascii?Q?gv6qu3c0mSO3LmGrI59IFvkvqrIcWQShGNToD2DYSxF9TwFEmX9HkgYaB4pv?=
 =?us-ascii?Q?vIiUX1qEcAx+Z07ey0M2sfdMuCiXtAgV63RsqeGPBN3Wh7RxUAUCD8fC4NgC?=
 =?us-ascii?Q?iJVYYKPlfmoLY783+iiG79MVpgxS37jWIliagdWrgOGIw6B184tZ/TmEYz3D?=
 =?us-ascii?Q?xPiuhpdb+WVb30jAhu17MY3MpbEqns+ELqLhXwAy3hQAnmQkPo0XTTL93iuC?=
 =?us-ascii?Q?Oa2XvK6KyRYwbvA7xjmm/skjxkJu9cMpquGHx8bWKXTPFaPKFCAR7SAJ/8Ii?=
 =?us-ascii?Q?TzFRGwx3tYOi6IMncm6eXp86+FEU6GF/d9bHOcu+Q3f1MCkhS3Tw54hn5/jT?=
 =?us-ascii?Q?pUeyJOsJvPKszpXg2vEric5JCcTRqlyreGRlNgyi54lOURPNJw999BnwSAaa?=
 =?us-ascii?Q?KozjICw6RIwznzJlOLtywHHQDHOjQonRl5+hjxmXRC/lc5xrBahE1DtLo2BM?=
 =?us-ascii?Q?8NcZIavK+DhuCbhzFf6kaX0UxwKrasVxrqEgivetsRNZKm5Qbo/a+mWtE5GW?=
 =?us-ascii?Q?xp4V50bHBwVAxwU35iEOtJq8y9Cym88rA4WfniPVjPCnKCzkO5CGr0Nj0+fb?=
 =?us-ascii?Q?IBpwQg26vGFpBtWwDlEXCO6YNG1H/kBFf1PMlGklihwtrmsnrdDMuf8ORIRj?=
 =?us-ascii?Q?rjjPc77MKyPs1130TaksoQWAaULkAcJfZ22Hk7Gkf9ItX45lnEygVV1WpAgH?=
 =?us-ascii?Q?3MCAIX9lfdeLOwF6iQHKZhKEw9l8I+VtPB0ncT8Zbxg2XYoRTerYbz3sbzdp?=
 =?us-ascii?Q?hlKhQ00tk/3J3/EKHoYp8gMAfilYItmiML0IkWWUT6VZtBVteG9cYPVqZeKv?=
 =?us-ascii?Q?jjt9UES/M0bTIlqhwohBXKvcFgpzlDVBFfyyNrPoSvT0hupBiPMatzhd5BNg?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec82099-40d5-40e6-dadc-08db46611f3b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 14:18:35.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZHIITP/3rflWMbJGyqf6BJS716UyWkfSLHmEXFj5dlq4aOmeYEyxx/R9Hc7S4MKEPEr3eD0jNh+FO0HIjoZvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8284
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 12:21:47PM +0000, Katakam, Harini wrote:
> Thanks for the review.
> The intention is to have the following precedence (I'll rephrase the commit if required)
> -> If phy-mode is rgmii, current behavior persists for all devices
> -> If phy-mode is rgmii-id/rgmii-rxid/rgmii-txid, current behavior persists for all devices
> (i.e. delay of RGMII_CLK_DELAY_2_0_NS)
> -> If phy-mode is rgmii-id/rgmii-rxid/rgmii-txid AND rx-internal-delay-ps/tx-internal-delay-ps
> is defined, then the value from DT is considered instead of 2ns. (NOT irrespective of phy-mode)
> 
> I'm checking the phy drivers that use phy_get_internal_delay and the description phy-mode
> in ethernet-controller.yaml and rx/tx-internal-delay-ps in ethernet-phy.yaml. It does look like
> the above is allowed. Please do let me know otherwise.

I understood what your intention was. What I meant was:

 phy-mode                       rgmii                          rgmii-rxid/rgmii-id
 --------------------------------------------------------------------------------------------
 rx-internal-delay-ps absent    0.2 ns                         2 ns
 rx-internal-delay-ps present   follow rx-internal-delay-ps    follow rx-internal-delay-ps

I agree with Andrew that probably there isn't consistency among PHY
drivers for this interpretation - see dp83822 vs intel-xway for example.
My interpretation was based on the wording from the dt-bindings document,
which seems to suggest that rx-internal-delay-ps takes precedence.
