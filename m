Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0AB6EF322
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 13:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbjDZLKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 07:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjDZLKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 07:10:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC842694;
        Wed, 26 Apr 2023 04:10:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jn9yVUtJbGF2W5BNZ9vxo3yPDNC9fzVdhJRK1GG5oQvzr+/rzckNYGUh//ht5M1wmTVRtNs114qAI/vj4KaEtZS6yB1NxRPt7M9C0XC1vir5XHaicY1F8e4LoO1tEeDRq6UgFJGyH7SlteHzxZadB0NjnGpK7Kxn68URJZG8VSLRQOleyT3KYoDtu3XBfZRn7rAD6aC41PuUYCsrhJ1VfNAed9+d/eZ2HMqTpgOu8F8bTf4OR7/+Qr9mLqbguoZjDQ2+klJ8SDWZHrLtQnINTsqvbE8pfSzibNet0j+zLP4AE+6JVVBcbnf8xNCeN/yy5TzAKoa7/xDBVwPnGKs9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETe4p/IwD/RF9Li6kSqjXHfovXgWPKecL44fK/464to=;
 b=c+gyEw8XXDDRzkQ9uyBoylqE3m7Os8tlk+/sMTKDoxDrC1esAskLTwLRA5FNaWihqz+lB9MuLNWE3Nm1394q4nXgAoqDw0hUvFua7w11BdxlNgcg32cQQjuSqppGXPA70h3kC23ZCaCXDbeH1TJJwO71vpMS7lG/qcj+s458sucLSFOz9w2VQW0PvfNAXi9ReKcylAY11L+oydpgRCk+D1P4qUIw+7j8BAzbK9MuRwh38D1RIkUvKcahOc9IJAGj+z63JfbEs3g0Q+U6huTTp4Lr7VXm1yY5fSeZEKq8MxLvoWC+nAenYMIIRou9uiTLeitGkkBzd/5wYmURnMsOww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETe4p/IwD/RF9Li6kSqjXHfovXgWPKecL44fK/464to=;
 b=LuqLqLF9aU2cvHLcIXCb1OMGJ0eMHFNEdnAgtW3i81PhJNDOEsINVZC0kONthWBR6GOKhvDBozzU4egWkY0k5quE1naJYSFl0ykaSRinHfOB5RCohbu0cxclnw7SWH2bp+AUvmmbCgcqyJriiunBfhCcPD83gUBf8riBHxr8YQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6854.eurprd04.prod.outlook.com (2603:10a6:20b:10c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 11:10:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 11:10:08 +0000
Date:   Wed, 26 Apr 2023 14:10:04 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        wsa+renesas@sang-engineering.com,
        krzysztof.kozlowski+dt@linaro.org, simon.horman@corigine.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        michal.simek@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: mscc: Add RGMII RX and TX
 delay tuning
Message-ID: <20230426111004.56tq4rzbnndxrsnf@skbuf>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-3-harini.katakam@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426104313.28950-3-harini.katakam@amd.com>
X-ClientProxiedBy: FR0P281CA0213.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: 786e9085-c43a-4e75-e89f-08db4646cba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0M37cH/DkwpLroJq390+tVuelu/uSvbN42c+HYNcCwPg1xuCq7IaiUokPaB8iaNjTsFRA4dm8ZnL8h9+rF16e4VPw+BXZ1Goc2NNXceFSeV0UCpwZujCflwcdcpFtNOeewaJo7P8XXxO7Rr2/r/UspfoqKFFvD/cEvefNyVf0lCgOwkYDXHXDOhBVrm+sKRL6Vjgy7z3x7wXA2OU/3y6W072n4xciAhOiVFRpD89AfqGUApunTd2ze++Rg4kMnvU7V8c0IwRUawqhPT9YpUUN4uJEvtdkpppBXKT+w4NttlL2kjdjzierLDki8qWUXzWBxp4OYiAiYpMnBteO3oyBfGWqWy1xS/+FGhjkcPfCTaMmNLLqZN3/0SHD7dH0MtJUCmlCTR6fkC3Gr8RNDXDo996HePxl31qxaNZxDw+aVWsVQ3u5z5wYYKxAK9D/nDeuUU6wrw7ZK++02c6Z5tL+bnPDwt7HegGIzjt1wA9Ypf5NHe2Evv6AXXu3dXz0+3gZVDJAX/9ALk5jNZPHbta+ecn05gYzutM3tdnk1txTrbY9PAlqLRccnCy/mU9T5x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(83380400001)(6512007)(478600001)(6506007)(33716001)(6486002)(1076003)(26005)(6666004)(316002)(4326008)(66946007)(66556008)(6916009)(41300700001)(66476007)(9686003)(186003)(38100700002)(5660300002)(44832011)(2906002)(7416002)(86362001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sgAZd+E4BdWy4cLvSDg44OBx91P36kUvaFBUKKcbOwPnKaptCH39T53W0FbM?=
 =?us-ascii?Q?kBd+UTQMD9pcFQp/+XsUQYzXdwamS3gg+snsy2elUkI50/uJfbHCrAPSRqwq?=
 =?us-ascii?Q?R3o8HUVpzodHFZm1TxtrGdtj5bBw38A84+RDCSRsKqMnGu9vS5MsQGKqMMnS?=
 =?us-ascii?Q?2fpmAka2ARuWCmlVo2pdmpZpWoXjhu56irOolkXCbu2rIRK0tU4CEkKP51Rg?=
 =?us-ascii?Q?X6UHkirrxXpATVZAU5bjZbioOh+bEzfTe8IpnllOmvUlLDImbS+Ub21btBD9?=
 =?us-ascii?Q?2hHJg5fG+UsCcBPG5W8Nob4AzDgtqSf12u1FcOI15wN4YCstE9OpCQCyp6AS?=
 =?us-ascii?Q?A8OTRy+YF7te06Wyu7yzAg2ccU6jnKDyQ3uAgLyicWjdws6wTEIsjPwusRUF?=
 =?us-ascii?Q?Rfm7ow5XIfljkTc49tMqoKTr1Zg1L/qO7ag1+vFfhh8OX3+2gjHH5oG0Y+gI?=
 =?us-ascii?Q?aRiM/u649JZDK8qMlcZIEwTq4Vxlhr5qxVhQIIX+sWKsc098Ulnf9FIMbWNx?=
 =?us-ascii?Q?ItuGBHzErNDl5GD6Fmu6QXZEcraotTwLCbKs1xCQgxc73+ls0XOzUbX9rUHB?=
 =?us-ascii?Q?Mi1FccT96Rcush7ea4cCAZTdakWdmdc+Y02AiSCF4pbA2Q4n3erZn/ak3P//?=
 =?us-ascii?Q?8eqDS58nbgiIT2yXK0aj2Gr3nvXGk8yIr3O9N+sCvr+KJ+HmEjbQhFB5xYeK?=
 =?us-ascii?Q?583pZrRrBJRKmoKtbJaUQ/iLoiCCZapIg8v2mxL+0396Cft6pCtnH5hJ3pUz?=
 =?us-ascii?Q?9C6jcCWg2N3MXh3rsttxOxxme/gr023vWMyeiD/7xh8lY6hczbWNGlnutybN?=
 =?us-ascii?Q?Fyye2SO66mtDnIbSkxsoO9KTvIvoLmnevecEh30g1CqIi9wpsDPnlav5xwkM?=
 =?us-ascii?Q?+e6Teks3ke/ailg/iy20xmnm1X3t21FDKH/jCWHLB6p3rnNg8Pz68JANWzb+?=
 =?us-ascii?Q?G/CgF0gxrZjM+uxm67METMrKwyNU0N9aeCjek/nyhfTN7SxvW51QKs1CasNu?=
 =?us-ascii?Q?0VlIbvA4J23KV3p4bKbsdGhQEvb8P8qkUjp3WOQjGrg8wlmeY/WzgRQ1MQJb?=
 =?us-ascii?Q?Nm5jKaYnJeer7B6QqulmX+2y1h5TY07PL5G5aDjo4VZNUr9aKyHBG6lgOhvY?=
 =?us-ascii?Q?nyDSCeIxdJks3JHRhCfQxD+1QhcaUG3bIlbU3xL7f8HaiBT/eos7ewANnyz6?=
 =?us-ascii?Q?vKJKOPAAKjO5Q27vWTCaATWFTmF/x26n9knOGpRbPGXTIKP1MlTfAP6WSurd?=
 =?us-ascii?Q?M2YyPKiiQmlTElEWDpsvjdmTOkWYgwRIdbNba9tC/ZW6CwGa2Y0VJWhkZq8T?=
 =?us-ascii?Q?VW3Ee96y02L1Y5Ls5HPF4H9UM9d/EltHJZOhZZeZEEdvwjRvdOiCa+JHCuMD?=
 =?us-ascii?Q?4u+SUscYjmg4gY4vP4Q5lbOIPb9cBBElL29sICxC+afkL+dwzCpLnuyDpqMr?=
 =?us-ascii?Q?0vALPvVAEf8mHVDRh0R43abwmLoAJBnsDaJq9IzaPgvLoBHF8ui3KqbKT+rx?=
 =?us-ascii?Q?8xMo9k2R/po4OWWOWCVT2wxhMTVojDq02Eo50aFF5HYml/K4CZvTuFUujFdI?=
 =?us-ascii?Q?D4l23neY/xEVWKYyqMgCkduCQ2gdOGRGf/D//CsNwgBeVFrxTw0XzIUB8SVW?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 786e9085-c43a-4e75-e89f-08db4646cba5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 11:10:08.2836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXF3NNHJEi335y4OCfxXTJSLvo9lfp9NcLt5d4WDEQoCBbmeXtHzgnGCDfl8OfftuyhZLeQ63jn4oppF6R4DUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6854
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 04:13:12PM +0530, Harini Katakam wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Add optional properties to tune RGMII RX and TX delay. The current
> default value in the Linux driver, when the phy-mode is rgmii-id,
> is 2ns for both. These properties take priority if specified.
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> v2:
> - Updated DT binding description and commit for optional delay tuning
> to be clearer on the precedence
> - Updated dt property name to include vendor instead of phy device name
> 
>  Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> index 0a3647fe331b..2b779bc3096b 100644
> --- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> +++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> @@ -33,6 +33,8 @@ Optional properties:
>  			  VSC8531_DUPLEX_COLLISION (8).
>  - load-save-gpios	: GPIO used for the load/save operation of the PTP
>  			  hardware clock (PHC).
> +- mscc,rx-delay		: RGMII RX delay. Allowed values are 0.2 - 3.4 ns.
> +- mscc,tx-delay		: RGMII TX delay. Allowed values are 0.2 - 3.4 ns.

We have rx-internal-delay-ps and tx-internal-delay-ps in the common
ethernet-phy.yaml, there is no need for a custom property.
