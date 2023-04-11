Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ACE6DD992
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjDKLkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjDKLkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:40:24 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39613A87
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:40:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzM0IXr1r8iZm7Oof5fmuwzMyN/kvyR+0sAa4QrD+OkM6MbEwMMubW/3LLHaoIhd1q4COo3LyHeNlGgD4D8K3h8ZafBbQwyilyzS+rvW9KkUeUMMBxkFjIJQKx3tJx5ejI9tESH4QAfBnZKEPlSoljHkYrtijYIrZj0UChHJW0fp4Uklnto3lLkREHWeIhj12jtpbhaB/R/Vxb2dQvUYrQULExwjDvtcUWqvxhSRgQQPCKVlQZS5V4ygzeGRhFBteIt048OkhzUcRCz7z37kzHG2tk+MqJw+g37wmEZ67qsBaJZ0gjpss6A6NKLT731wshLTy0/QeFNE8L8A8OwaXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3XBpaVCfeoQV0YPgV6aLk5VyJ0G+YL4YUuy6XHgl9B4=;
 b=P2dSUtPpla/mvgq3zSZUhTUu5MlEj2y2AdbKGW8rTOCutfrPdPRwlW01q2m3leGx8qmeW166sfgjQM47M+9847+se8fRPsM7QjDZu8hOMSkUAxOaZyo0wN1puuJgaq4m3iEiX5Gd0BPlxkN7xzXxtNhfo2mZ2WRitqMWcBhF2cg2+H/Bw5cfU5l7pzjYCOQhF4CfBTjdMoJXiZ17ZHJcSVpdvBx2TTBH1X6B5Fu0BbnGFuV1eQhGIgSF5N6L9pW6ztqWh0RTHURvCvuT6ktmgsdEThKFVWuysblWxldzDJPk48HDfhcgAM2Qsq14bXfojULMYwGxMGJrKbk9OUvDRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XBpaVCfeoQV0YPgV6aLk5VyJ0G+YL4YUuy6XHgl9B4=;
 b=JKFBg82/W/LFG2lsNQmqj0oH92Uh+4vPyAxB3ONMOXHhi33pNf86EZW6GiKyhOFgO7FGd+qaw/ENKo5G/JrM5WbBD/1ort56oJe/I8Np3jkTKhtQJrIMfYggptfSYPxSg/Phuf0dpmmSMdtiPSLpyge7WiHOQkNY5+02TDfe2ig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBBPR04MB7786.eurprd04.prod.outlook.com (2603:10a6:10:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 11:40:21 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Tue, 11 Apr 2023
 11:40:21 +0000
Date:   Tue, 11 Apr 2023 14:40:18 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de,
        Russell King <rmk+kernel@armlinux.org.uk>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: dts: imx6qdl: Add missing phy-mode and fixed
 links
Message-ID: <20230411114018.456qmdub3rylylvv@skbuf>
References: <20230408152801.2336041-1-andrew@lunn.ch>
 <20230408152801.2336041-3-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408152801.2336041-3-andrew@lunn.ch>
X-ClientProxiedBy: FR0P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBBPR04MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d48d2ee-56ab-4481-4451-08db3a818822
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tGjV3fot/bbV0tHHw9RytIdULYyE0uxQNhl55bVo/WKq9tBOgtR4j5xjo6BGBFZHsPkDmMaTjrVmI8mOwGCr13/5sJ+ZgIwSmIRSgnogYhDljyiDjR3Fr+hmWdIrOq9bw7Kgknqzz4pV8yCDNM4Zp1zDt4jlyp8FxGtyW9V+OpOnxhNfFgdrzRPW94GKMEl5qwOLXwem5J5B6DBlI8MEiH1kAaUrHA2ki5B85hRftCAqkmy+2nWTgXs8ozRtwm5B+XO+MQxyBZvZzc2F6oFDp6+aNQ0Ka4v+SXG0s09EfAmIGrPqg0VRo7IIiAayf9oNu1lQdk0bZOmxXj07SL45wHKGT3ko9Ints2CQJH26JGsHdbifXmCVRZpC6H/RQjcYbnn+7+8qAg6L/qLk0LtpgypZK2+UhwnaHDfP+LtXlhvTfi/iBCXtB5nKmfzsGVI2NjpmdMhZUGMOIbRTQn9gHsIy8UiKosNTDDgdN5yFICx6jAzTnxvWrlqvQR8TBkVOJDAiAEBqUx9AJ8pUSjWK8Yv6Pawt3eH1exeia2kbhY9ViFo5Hsl0FTCKjPPKEW0ol6Udx52RG1hb0HSIc8rqEU7rToaIUWtTJRJRtF3l5io=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199021)(86362001)(316002)(41300700001)(66946007)(6916009)(4326008)(66476007)(54906003)(66556008)(478600001)(6486002)(8676002)(33716001)(8936002)(2906002)(44832011)(4744005)(5660300002)(38100700002)(186003)(6512007)(6666004)(6506007)(9686003)(1076003)(26005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mMPcQ3u4amU2uOYDwrHR4Skev9ulL467W8Iv+UJYYoKNdACjpi8EkJ8r/m8S?=
 =?us-ascii?Q?Cl2h0fKMYtfKZTu5I04T+3Xp3K5o9vPKRH87jgJbqr4ZRQfR8X3wqdZlqeyS?=
 =?us-ascii?Q?S+dQrE67Nl86LCY965ivm2Vpi7MywPEzfSXtyBH4jKAuwVdhFEaHVFjQsgU5?=
 =?us-ascii?Q?ZvlFfNHwj7bKRpN01/aQpw8Y6PbZDhTond083kjteB3KNbXP43jmE/3XIsKS?=
 =?us-ascii?Q?n6NSVv4CCmIvwnT3/OHMJ+fJjsrGd2Ym2bKXt+ByzMsZGnTCu9+3JHVPaBlW?=
 =?us-ascii?Q?vL9Ckv41Dh3PyqRoG0dy7qe9FFOIiD+ztsVMTiyk07GjGknilC8kLAd7METx?=
 =?us-ascii?Q?KwgR4ApG64IMcagkKlSzvM4jXEjvYW/bGGd0Ztz7eRK/CBcv+6Hghfn8vL7M?=
 =?us-ascii?Q?A4AeEk6dvq56theTN54hjjAP6RI9YykullNqokT0LUwaSUlXN0PvAWSHz20n?=
 =?us-ascii?Q?z5+V9RBW5JQtKhEOR4mHoHTj8DaooFkh9IfP7gQuoQFKP2sarhXj58salrDK?=
 =?us-ascii?Q?YlzC2V0TBFaFtoNvsXNhVcxBqN1/3Ic2zXOcaT6MMtyP5am1xG9s2WsIJDnM?=
 =?us-ascii?Q?LrmWkSKAw75tFa8jSRFxnyijpEnhkN/ePTAT0BlQ6OrIpR9Kl6XSln6qVqAC?=
 =?us-ascii?Q?pFcqVBM6bkWEaLK7pwxxt2fvA1WYPDnsRcFw9V5RIfxN3KAmRpbBEjgmpRQQ?=
 =?us-ascii?Q?Os3kx+v8d8H5iyX3uThFPnltnb7/7+zbN5sz3ZkeukbIaVVI2Vlm41J4HbYK?=
 =?us-ascii?Q?rLJVR6+IkRvEQMitq06tC/H55uUPVmQKZxEgo9Q8JCc/9Nmws2j7pg9OyE26?=
 =?us-ascii?Q?35mDJ3mI6j7T0L5SswW8y3XoMRy1ul3npPlBhdQx88prPniefDiAUIgnk/Y8?=
 =?us-ascii?Q?+WrDV/KdamNVuPRl4gxllkGySxLtSAgr861sOJO82FvktfuH8k9uZU1OCPE5?=
 =?us-ascii?Q?/aMQA1qurcHSP69/8VIZsrpI2pA5Pde2AepjVMLpkC9j4XnXgow+vgw3jgUy?=
 =?us-ascii?Q?7lkNqoo+xpA8JLSbtws8QFFpyPqiyY3HkdVrdXvHgGHriBNuKppw+/wznGqb?=
 =?us-ascii?Q?MTD9dUqDIVj05piNguxl5ZYe9TuLx+FPT6GAEwe+V8ndCPH5Aw4JCRTIpGsU?=
 =?us-ascii?Q?a4Z3s6JKBq8VwsT3YRY1bdQ73wQHrekzslMOE6XF6oQ6EKQs2QZZxDRXd0HR?=
 =?us-ascii?Q?sseCZadb8L7cXRHYFtfK0sO2accVg8Zq/AZbgWemTn+Sf37k+BZyEx5F510n?=
 =?us-ascii?Q?mLNKNKxAKlFUCEMzSMz07lAC03TU1jnk+vFzGy9DEm2cuHmw2ZOOx4AkUpAu?=
 =?us-ascii?Q?1Dvc9e9WGd+9KtCKLmI37htj2SMVuauEy+d5YLqEFPmUj2Dx1kEa7T56kqMX?=
 =?us-ascii?Q?tvWWs40ETlfPS6MEVmfsKWun5WplyezUtyEiKUoyGxXnp6YgT49uGMc5cGaZ?=
 =?us-ascii?Q?OSMGMWz0oTLqIzRIQMInzqsM0dlwbw0gl6WhfOZhr097B/ie/wiwDBU78xpi?=
 =?us-ascii?Q?2RMlA2MWh5sinX/VSIv4QMTcwo+80grpn7cOQkhXQbHm4veKHppXLg3Uboph?=
 =?us-ascii?Q?twVspkVKVvCC9JXOMtl9+BoYSnxjJcxECEk0OjR8s46NuriAWZqOWIGWRwvV?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d48d2ee-56ab-4481-4451-08db3a818822
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 11:40:21.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxCk1SqB0xFkkI121B/Ica2P2DTFcxB6sgbeup1c1++8B0jGCzME7G0ejjofpG4h8E6mp/4vs38cXw4tYCzLQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7786
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 05:28:00PM +0200, Andrew Lunn wrote:
> The DSA framework has got more picky about always having a phy-mode
> for the CPU port. Add a phy-mode based on what the SoC ethernet is
> using. For RGMII mode, have the switch add the delays.
> 
> Additionally, the cpu label has never actually been used in the
> binding, so remove it.
> 
> Lastly add a fixed-link node indicating the expected speed/duplex of
> the link to the SoC.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v2: Use rev-rmii for the side 'playing PHY'
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
