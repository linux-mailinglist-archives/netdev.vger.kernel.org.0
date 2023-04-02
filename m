Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12D26D37FA
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjDBMxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBMxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:53:36 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2052.outbound.protection.outlook.com [40.107.7.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D47BB96
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:53:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8Oz3XBENbSAzMJz5ZOXT8L1puvqulM4gjNadmrF4X0vWSKstjO7i7GUtBHMf5CUwa725DpEU9IB4bllcS6agulY/egza6OUThEEbggKaT4XDMHUycIK9oM1auTLclWG1EopFQW/TWFapoqLs0lcgKjqjumNzRTqKzJTUJWPgYVUPSf3Gwe0G93yDJvTUG9Vh2eovH0PaAiq0tpzNjuJXFLojsiFMh6CNVH7PpFdtjrpiSODQavWTAQcJHS19HSZdHVKfaxE2VXbJybhgGAFmAPmGd4Tepa9KRvN1uZMksbdsqsJifVgQBJG0DeBdWFhOKbCPbSyLozVNMkaISdYfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00DNJQBatrMZWuTEp1mJRA/aC1QGXEhj4wvca/ahlBI=;
 b=AHGaifeZbHB7g/zpzMpWxJJXXxxyXEx6AhCQj2O3DcRUoGJjnJ++/HEnATvaaqYfC8FimfaZD97cHA+Evt1RxkvMBHvENLkGcbKRB4JqIU22D1pkQdPVCXaTXySBv9w3x78ss6doWZcn+MnPNtM2VFp7QXT6EPs+n2kk6k/pq6nI0ZILQC8aBLHz0W5YWrx22Rf3VqWqNyr4CDEHNMcnjERD+LZ7C2We0uUcxaJf7saV5/E9CLsc6lco+FTyC04teTq1I5P87GE3Nm0YLsDL+OmqbVJqnsTsMVGak6ZZY/XNaDHdZsi5ygxDIX7bxb340u77USi+v2QFdTfJbY2UoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00DNJQBatrMZWuTEp1mJRA/aC1QGXEhj4wvca/ahlBI=;
 b=XrRBbqlAcmzsRtJ9hLvzK3KLCufCS4FeRCjanMVuIcqIqHEKku1xvDZago00Y1hgJaq56EMqd3UQvZzeYzByl4KabYXgn8Cm4/el0jPy4pxO557DzewwYfCVayYpxCbjfjQlWsCAXyVMnBJW41AxihLFNawKDzSyRZY5za/vnVE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8962.eurprd04.prod.outlook.com (2603:10a6:20b:42d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 12:53:32 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:53:32 +0000
Date:   Sun, 2 Apr 2023 15:53:28 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next 3/7] net: promote SIOCSHWTSTAMP and
 SIOCGHWTSTAMP ioctls to dedicated handlers
Message-ID: <20230402125328.wf5tkov3hhdvqjkm@skbuf>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
 <20230402123755.2592507-4-vladimir.oltean@nxp.com>
 <915c64ca-bbea-bfe9-3898-cd65791c3e5d@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <915c64ca-bbea-bfe9-3898-cd65791c3e5d@gmail.com>
X-ClientProxiedBy: VI1PR07CA0200.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::24) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8962:EE_
X-MS-Office365-Filtering-Correlation-Id: ec7e7639-bdfd-481f-663f-08db33794394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zsjVe7KV3zDnh90LLGy5V2I7J5/r8WkpKOm8aMGNjKQvQybdk4vhMyFfcQM/gaZ5OqV0rmFLIYAK72KJem7AEJoy758D4rwMZAlomN+Af5f6TkxjrGzdAGtZpJBOveqZA4JQI9Bneqx00dv07XUQXkZ7vupG5EADDXRvIJmpN5gOwTRoNRJvNrFrbTZhVzPTuOjKVRQu8Rs82zBnIjWEI99w0EthakjZma6o5E4NZZmzeaP5PoiGpkTK4E9xDIOkP2/hCRgfotUAXG6Rh43KAMD5bFq2ASSR+yYkokPi/KMnyJZjuGaG03wIddG7sVm2ciIG0/wi3LP9zyX17snciSn3xdWHfsTiO6fzzgOpwuv5FTT2vTfzO+P8YfZdAJysqfYyXXyTibeof7ymt0fzhmn2PltqsaeIYdoHobAAGOnk42FmF8yg0gzUM3yJT371ZhWk+wlzyEWFqJ+H8+lEahbj53dYIhaFkCF0YkAv5MeRri8V01o1Bs19DJn+iI8jCplNGR/Srld5zzLhOXdqrHEN9TpeBXd9mPJVv2YFH6f73WHzh8xEnChcYp04+Sn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199021)(6916009)(4326008)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(54906003)(8936002)(44832011)(5660300002)(7416002)(41300700001)(38100700002)(186003)(6486002)(6666004)(9686003)(6512007)(6506007)(1076003)(26005)(86362001)(33716001)(558084003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IBQeoVpKjVY8Hwi2k8vNstdDyuKgE0jVuP13GDkZBKN4ybjKmUsMJUElQFMN?=
 =?us-ascii?Q?CjJY/qx/hVTYDjOOGMaH0gMPIc20HPA042FHkikPxzgwL8Xqa3o/FgucWvm/?=
 =?us-ascii?Q?3+H8eshk3qBihSCWHMX/TMn4PWRfLcJNLXoiO+BTmwwZ+VQaQN5cAYidk7/F?=
 =?us-ascii?Q?Wso+gsapfMskhkzgK1IaCiNmdAsbtm34qLiIfmb5SPZOIXyUeQmIoRVXtsKo?=
 =?us-ascii?Q?fi8ldaln/L032b5DWWWtFLRkWUoP3ROS+o2BNzfVX4o2DnrGbtjxdPDPzmNA?=
 =?us-ascii?Q?MlIRUlYjZ+cjs0S3tyZFSgNiTOVw1NWh95hEVussSNhNKGIUtAfBCJGAizkv?=
 =?us-ascii?Q?UTEw3moWo51bIdCOqHhkvCiLKsXLIAD8b6OlnK3+d69v2cg6A8W8vIcPGslg?=
 =?us-ascii?Q?0cv7pmJ62t4jr8tsU/i9F39bcv5QW/8xupay1EXmplmn+8oEONgxqPpKo9yp?=
 =?us-ascii?Q?fxwiZpvjxbFQYQPqng7ore0GAuEMI6YDf+PBTvOluBr0/xg0py3OAJaNUaLu?=
 =?us-ascii?Q?mc1xGyvn50PsdJDYqfk87aTAWLstLFkJFrXkN4w1DYpwqmUbWOOZv+vdL2uL?=
 =?us-ascii?Q?EYJD/BhyOk1Hn2njIw+UMwoFjb7KpkdVdXt6sorAF+5LAvRK5HkgX2C8M1BW?=
 =?us-ascii?Q?CVvN9S8Wfb7nZntGohhz1S2bi/ZtUozb79y/iHmkJif4ops45LMXbPh0ejCQ?=
 =?us-ascii?Q?T5s2nnFHnXVzpGO8wf49m5bJIcdzHkbRChLKWDLZGljPNBiosAInmKHcCCt1?=
 =?us-ascii?Q?YsD7XVqfwlfwsvtVEJ1QxHuKqod2gLAo9kfdIswDZRf3kwUPrpisfYFn614o?=
 =?us-ascii?Q?I/+7JKUyNF6SIsREMp/eduQoO2UhYfCymt9S1sHwisALvVCMs11uU5XC3wOx?=
 =?us-ascii?Q?55mwnLgfmsP+PGMj5tnmOW5qA+5OIkI6ouMfj7WgJFzP7g2uYC/oaCOhxTTk?=
 =?us-ascii?Q?ejXROpNGARzClRf9WdNr/fq+5UaKNq5cMCwxyGCB/MX3MEEP/sjyOQgyQtjm?=
 =?us-ascii?Q?I7EZV5xlyTO06b5f/oy3CpOnhWYnHLXly+WcssGMzS13Xcg1yxzgKLPQoAoE?=
 =?us-ascii?Q?SxBPoDuW8rZ76yK/syJcMnfF/qwtFc+U7qOmXZ8+fCzZsI0OPJpcwcvceuWp?=
 =?us-ascii?Q?dIaA43JwaNtmnw8P/RB5aQytF04gvAolJV/dn3lfHOVespRYvRigPPDqWEUm?=
 =?us-ascii?Q?nEuW2C8alrJuH+W2D3qq4CfVNbjmvfh60//Rl5mlYPNo7OCUmF2NUUiJl8Vn?=
 =?us-ascii?Q?kMohHff7oC//m3MAy29VWZeMmDnwcm7+Cz/9dCMHT6cuG0avqS4GkBMVhnqt?=
 =?us-ascii?Q?oTP0dAuV3EyF+F3N2OnheleNV1GOn7Q0YAaMqT7Pbdy+uv20cgmgDoFMK9d0?=
 =?us-ascii?Q?70TBnMkS7sKIIhl/olc29aXwOhEKeTJ5mSb5WiEdc6pi3yZRtLmikOH5wXro?=
 =?us-ascii?Q?fRdOzG4c9uoRtlIqs1uASkV+OM+Ja8p0JU9bjoKa9ZLYM+bfy58AkclHJIgT?=
 =?us-ascii?Q?EsqSHdo2WdiJeu5U3x/dVDrOxcf/pGmzPDBmdgVrD7OUvS6HORlZrlW8RZaK?=
 =?us-ascii?Q?oPODDl+ohA8gZLce0P1UDeZ9CuRRnD2+IzpHL5Dhr1NeaLQyMSYRVd01teN9?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec7e7639-bdfd-481f-663f-08db33794394
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:53:32.3173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NJpr3BUJVkt4WiVwT4jz0BR8hK9lOvia6828g3dUYnqxmL/yQk2oL7heZvseAfwHruZ4RT1TZu4PwmRcoCtkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8962
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:52:29AM -0700, Florian Fainelli wrote:
> PS: there could be some interesting use cases with SIO(S|G)MII(REG|PHY) to
> be explored, but not for now.

You mean with DSA intercepting them on the master? Details?
