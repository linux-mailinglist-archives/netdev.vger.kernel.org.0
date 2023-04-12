Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CD46DF6D7
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjDLNUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDLNUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:20:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1a::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498187DAF
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvA6A6TU+bQJI1Qdv4cVih2uHgfg1PGsw+2KuiWMNPC9ccfORSKC3RlQhk/pRQ3RPoPayXE1VV4Ybv2CDLhZhNlwVckT0X7kOQGm8T66pxnXTcZhpWLe7qyuF1GE+J37Ng6lrgAUgnWfoAbIJUTfsnVfP+YXVDbyozm7sOP1GuZRVPagVIfPx8IcC7KCpRgDq4T92ZczORn6VlHWCtdmHgMocirwhya5IY1or0VcNNFbYddYoF78oHEs6/2YLPZUxofYDEvTVHWxznPfoOgqTD2obLh1012ql2BZaamQXDCvKWFNdeHcL3RPxuPMm3TI0BVuTvHs+M21zdrgc0updw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0lxr50CoAvojxO2hX38xzCS7o9HN2qWWz7OupScN6Oc=;
 b=FwbHNPqOMmrTIHggxzRKYUex0AvfPjf9gAFgBXv/SyrFROYndMRoLhgiCo1VxTiunnfCuU3hFgOY1q7qF4pCwLzy+yhygm7VGS9shrYE2D6ejahstwZKL5lRijBKz4vacB+vPiJFO+Y8ToOw2/Htu+PT2Y9UiBz+Mc991RRB+BgmQuCakSTNcgrihiy75EPU8c0mPvGejqUUdztPThAV/UDq4rqlILy4XpeYI0sSYvWQ0KBA6fKtCWsa3XcbiWauI9oG+1mgoFD/elylLCFUnUVBwiZTSWq7DYpOtJqg1hNtj3pmv2N/ry8oa9sMnpSfLDNGb7NzID2c/1+d8495nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0lxr50CoAvojxO2hX38xzCS7o9HN2qWWz7OupScN6Oc=;
 b=USeg9kDVqbbatqyOIxHGBjGcM4KPhYKfabwoJybMe92dQGeTQz6XF/QZ4fKksEBnqP/LyTEHe6KwxM1FAEalAVx6VM17YsUJyBdB+hzn9ZVJV9G/+Ja1AfsQbmJuctsk4kIU/jU9Anrgcq03/g4yrN24wnM9A7GpYXiOXyo2aWc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DUZPR04MB9899.eurprd04.prod.outlook.com (2603:10a6:10:4de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Wed, 12 Apr
 2023 13:14:25 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 13:14:25 +0000
Date:   Wed, 12 Apr 2023 16:14:21 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add timestamp
 preferred choice property
Message-ID: <20230412131421.3xeeahzp6dj46jit@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-4-kory.maincent@bootlin.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230406173308.401924-4-kory.maincent@bootlin.com>
X-ClientProxiedBy: VI1PR07CA0183.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::31) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DUZPR04MB9899:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ce36307-adde-48e4-af32-08db3b57d674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I2B//PEi7mMoXnLw1JH3f5pE0p844xGmeduPmtcXdrQGtoj6Nhzpc5WMX8KHUvBSO+FjDZ57TYxCuVpNv9WWzAsN7Q/aiCPFuIfzkxJkVfOzOBnP6ALoRdVvI8TiMSXlAHwPq4NIzxg8D/A43i2CqjF9X8p4Ty+Id6vEluPETVX+oeMa3BfczkrM70KnrCKuwjPTsxJfGaJAjjQSH8Ic8dOYPVMEF0lD68UN04VClQBxhvRmWMfYvU28YaeCxPJ0Y1bAAe0hdjoSWATVyn9zpt+ujPfo4iATTJFTaU/DR7+lo/3Nvl0g1gY1cEFhISwT09XhSLG3l3UeNkkO7MHsKxV3pNR2Pvdnlj5I1SvpNlxlPD7U/cPLF4VYqAlXcfY7y2FFwSaiNXUSTRCoM2o9iWPX+7j/eDYjSEVIZ6KHD1tcJyZ9vIYEvCnWFR4kZFcC1gL1LFBXpmdL1tUdcQ3qEleu4NlyCQYBQh0AR/NR/BC2TnrwZuUggVJ7d+ZZPbd6Un224KasGG+ERU6FJ29I0U9mCVASEDsGXOw6v8jBBBqo8x3w9kbz8sD8pqy54VTC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199021)(66476007)(316002)(6506007)(66946007)(4326008)(41300700001)(6916009)(66556008)(186003)(6512007)(6486002)(6666004)(9686003)(66574015)(1076003)(26005)(33716001)(44832011)(478600001)(86362001)(7416002)(8936002)(83380400001)(38100700002)(2906002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?WBvkSReHyi+7MZGldqADhJb7OUnGqEZEjnC3G+5iuU8NFHAR623GUYJbrp?=
 =?iso-8859-1?Q?upP5G9rT80+t+hBypgol1Z+IhagUMolx9Mg3wTFpaeeeGeSSfmOuDV3jw0?=
 =?iso-8859-1?Q?5u6p9iUrUD0SNE54rMxCCkExm0k3Y9daXcgVnUHgIRUpVVWFLiH/k6qtQn?=
 =?iso-8859-1?Q?lvviHEXTr9kByeUfSIV6mUW+tznpNEOzElg4elOCBgperRWYXA41jUmkHg?=
 =?iso-8859-1?Q?7JlPA8NCiIppy3qqPQvcS00GZ418/ac4pQ2REfhXl9KAzQDSNsjMG8B1Tu?=
 =?iso-8859-1?Q?E+137VuLSERvR2Cg7Sj5wbOvtfelM6vaDE9iemSqbSf02DG7uC8g83pndE?=
 =?iso-8859-1?Q?asY73cAslkniPADjl9uEVlN/1JsvaZJlldfsQV+xFIvPwUHPKl50mgPKh9?=
 =?iso-8859-1?Q?xIP6jF/cuRqB1lFdj+Q7+vQ+qrqWiN4/0K1Uy6GVDM7wNZzj5SRyhBcHPM?=
 =?iso-8859-1?Q?p5LpFsp9O1q7bmv48igaihK7FqGmKHFMzNZcMAPNFnjPhS3l/ZrYVS88XM?=
 =?iso-8859-1?Q?BKVvo9dLqTgWxf0kv+e5wmParXouAC1SLlp7G1nw9+mR99XlZw5fXcSbkE?=
 =?iso-8859-1?Q?PrM3xBegyVtoZHvG3fY2TgBSoaFQ5VjEOY5ucs/ztZiKhVqtJlzeyATYJC?=
 =?iso-8859-1?Q?nIjY1ic1QDaAzP94wa+s0VVUksctooyFnUS56smUha+SbXQMLgDZ2RfWiW?=
 =?iso-8859-1?Q?mx7N3AbAc4ErUu0tYFMtTJmkrkAqGlgPoHGAk2k/aoVMs9TpDvyNzlXFAx?=
 =?iso-8859-1?Q?Q4EoRxg9pMthNIjCqLRAUI6vBRZgV+v4mAqus6mBEpfla5yOrQ8262JUKT?=
 =?iso-8859-1?Q?7UCV0Xqy0DlAjP1sEx0EBDSFSf2VaPaIpKg0gPXg1bq0S+qk9lRQvSv0qE?=
 =?iso-8859-1?Q?SH6b4sWeScIZDMs1ckeu5Uk6feYqoXFq7BMtuwJS/HF/E5n8WSHY3pPzoX?=
 =?iso-8859-1?Q?wAh+E5LTDmkHx98f+yLHGbxaoLrXGlccSI5R6sWw/PRP2qSAlHQoo6M7tz?=
 =?iso-8859-1?Q?yTjrD14plULU9YsrGeaQRlX1FKE02eq1ukQVv9Lg4fdI5GGUQNymXEGbEy?=
 =?iso-8859-1?Q?l8nzZXcTsAM/q3kS8Br9OWDFHCWw8TM2Dz7Op2oxCva3ltJO013J5RJb5U?=
 =?iso-8859-1?Q?6DmjhDHSVEM1lz3a+mcQB9hbdYIjr73digXc6SIafwA8dTD98P9SHKgaeU?=
 =?iso-8859-1?Q?Rx71Lg1p0hmhw0xlpuKmp4ujA/j3ObPnl6dHLe8akDg5ijIsEyesLrQIBr?=
 =?iso-8859-1?Q?iau0TrPRn+LIlxiyF5VERK9+K+2Pqt62rtNOh5rz8aJ8HsqchU7jD/G9nK?=
 =?iso-8859-1?Q?FmDiWy95mSUNcm5ms+ZBlZvRKl3CAsNLTgTP2UdynrsSYhul0yfwbV0Rd4?=
 =?iso-8859-1?Q?iJZhPsy1zqNEe3ejhTWQR9ngataP/DDGp/03z3gzmKEl+SoYf4QC31Ukse?=
 =?iso-8859-1?Q?k0PWk1LdWfHqSEUnuVh88WyuvA+zaPHlaDm4x4LPhhg4rId7QgRWeQ1hkx?=
 =?iso-8859-1?Q?9ijz8f8siqFmvQNHC6NgFEKQOWJePDZEK/qk/nZXMrZGguf1MWPANguJxe?=
 =?iso-8859-1?Q?DBZMPuSYu/f15VgCT2xPh+DImd5ZhrWgOgDHGn9Gfif6ze/QTjYXq0h89W?=
 =?iso-8859-1?Q?zcZ5wXB3fLO7DZ18NvjJzTDnwtlEbmyzlqKzXmeFiZPXSwemjiUNqqNA?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce36307-adde-48e4-af32-08db3b57d674
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 13:14:25.0882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cWDV4GGIXWy2Twn3KwEfU4rTCUv0rg3TN++ugb0A6JJPyHjNNYDPe2jKsP/KkGcqBbSLpwstWjJekp5pnRPvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9899
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 07:33:06PM +0200, Köry Maincent wrote:
> From: Kory Maincent <kory.maincent@bootlin.com>
> 
> Add property to select the preferred hardware timestamp layer.
> The choice of using devicetree binding has been made as the PTP precision
> and quality depends of external things, like adjustable clock, or the lack
> of a temperature compensated crystal or specific features. Even if the
> preferred timestamp is a configuration it is hardly related to the design
> of the board.
> 
> Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index ac04f8efa35c..32d7ef7520e6 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -144,6 +144,13 @@ properties:
>        Mark the corresponding energy efficient ethernet mode as
>        broken and request the ethernet to stop advertising it.
>  
> +  preferred-timestamp:
> +    enum:
> +      - phy
> +      - mac
> +    description:
> +      Specifies the preferred hardware timestamp layer.
> +
>    pses:
>      $ref: /schemas/types.yaml#/definitions/phandle-array
>      maxItems: 1
> -- 
> 2.25.1
>

Do we need this device tree functionality?
