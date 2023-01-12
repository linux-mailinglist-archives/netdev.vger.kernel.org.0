Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA87C667116
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjALLjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbjALLii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:38:38 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FB6183B7;
        Thu, 12 Jan 2023 03:29:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIoo5CnWG/CsrV2Xdp7Xso+mrEHi9yFzAJMhIUNXHhUBFLDkrWB+TfzWiBs/AzfPUes1C5b2kwJ/plCPCs8faRqw+fG+cdpW9hl1I1cTXBK+Qd/Bhl2q2Ae1pdFw6pFrhPIa999Srv6XbA2VIkrS/VtvhJSQdRmOb/wGlnny4D2uHxCpa1LcptLMTCGaDiQbWYiLkiOFUmyPHq+uj5u+/JBL/Yv10DJiUVT2TwnApGdkykjK6Oe7ZsjvIWRukILraUy8Bj4Y0f1t20vVEAAO4vCAg3tWbwwa3Y+P//+O32RfxECcGLDcMvvszD6Hl2HRh1w1519bBEDn+5ssJXhJMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcrahsnI1jNzxfUdfsCjjTpdO3BRr7NE6EToWuu1nrA=;
 b=KfOY1pQI8XyJ1v711Kp8JJAaqEnp6GpBxbH00pWrRtBkn+XdfgW7dH1TWKIgKJXFqeLi48g8K6FLk0TNeUIulXJLS03Az3NH24790UaINOcdxFHQiu8xJJX+66XLDJ+rrFHGWGhgMI5GtMEJ8KK+MPkFHGW5VsenbujF6yW+YK4tGBvrfwsHRQ6j5mqPtUP+VK1qvguZAxh9ZOJFqQc6HqXr4Q9bR49vi1kL6Eq4pGN6wzxpo5MtM28ZhMj1xbSlSFzbLCKB6rp+CC5L9UM6Rj802OphSRpTbK4I3BZz+xWjZtQxfTcVVlI7Z6jXCiIwXQTnNOKsadM2Lu4Px7IBPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcrahsnI1jNzxfUdfsCjjTpdO3BRr7NE6EToWuu1nrA=;
 b=pHU/ZSs053ICDNsF5C/iKg9tc4V2fz079RKDWVPaPVDzfidO+jHMombZlYHDWvYmyYO4vGPEbU+Q3RmB+LHJwj5HY/x0WJUQeJXLsgO2eNoSg0gAwgGoy4d1ODFhojGMC53rIV2LNPj3/zkFhKLI/0tW23pZcn2dQlAZD//kPhU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8829.eurprd04.prod.outlook.com (2603:10a6:102:20c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 11:29:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 11:29:27 +0000
Date:   Thu, 12 Jan 2023 13:29:22 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 00/12] ethtool support for IEEE 802.3 MAC
 Merge layer
Message-ID: <20230112112922.z2h4swask3pdzxlj@skbuf>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: BE1P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8829:EE_
X-MS-Office365-Filtering-Correlation-Id: 648e1bd5-c7c6-4ca9-c1f0-08daf49042b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUOEUJ1f6FEUPm9hgO4C4DhSZCqDDWydKXcvo99QKSqU/Ho2U4gTzXlRhRPH9ygCbrqmfzUGBJhYb/7PboQdq9XRMUv9eb+XSIjGbtj+itLdHcFcnCQ2xUvaWx+9412BpLxfZudUOEoowCF8Ckua4xN5Rk/vIUmYWwmFKpmpPKY6i0yjRVf8E0XMZSE+3Ovzls7motoD+/bPLOGIefoshRkUMegHP67tpG4SYeMECggPhfrCNPYWNVt80ZSsBCY0C0PlBTiycRQLrApBoDHm2sTyZdl2Osdgb0ViKJOv0n8C9mfCj0UNezb0ImVsP9RXe/vppdEnAkH1lhmAgE8+f9OWAbzb+j6UN4YGW2nXMbTlY1scyrlnwXQ/3B24xg2/m/7jDFb8/i6Vcvoze8znOK+JwIZs1yEDYkHxMKbruvYF0Yn8hGSpzpdu8WSJ8CWjCRgciIBwV6EkbJkWwXO8OxhgaSCpnhIBZ5z0vMw7OxmZFAl1+FOg2NpiBCrwmpYy7aaeHUs7uo1AMgh09c0Ctmj9uFWjsyd3y5v9R+/qgjihcCVyNpPrip2VYuOoMCYLKMjDlEG9GiZ2dt4UjFDDXoRLS8hPgppPoz3J+xkCEUo4pr7fu+EWjL7Qgry7FmSA2X55B7vI4Y9GfMFpfGon97xIG54M89ONhmJCQZVSbKA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(6506007)(38100700002)(6666004)(478600001)(33716001)(6486002)(966005)(66946007)(66556008)(66476007)(8676002)(6916009)(8936002)(86362001)(41300700001)(4326008)(4744005)(7416002)(44832011)(54906003)(5660300002)(316002)(83380400001)(1076003)(2906002)(186003)(9686003)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ctZ1YK1Z0JvU5eKf4E3bKsyRoJ+E1e402uHByFJ3mdeyX6UdegQf4tLn/HrT?=
 =?us-ascii?Q?pQpIc4I0DlQ4fi2tgQF8V++iixC0404D2Pp8GZ1EMAeyuAF+E0Sj33ldCe6J?=
 =?us-ascii?Q?ZyIpoNGg55fA8kjSVc6xFkSP10/XG3q4OdpvCgQ/SM6O7RHszikDpSYE5Yco?=
 =?us-ascii?Q?mNC7Wq+4qvC9pTX9/tzqbfUIKxNlYWWe/zQFu7IlXEG7nfvngr7ustW8FBcc?=
 =?us-ascii?Q?gclFdTi9ZMoGLgOgNBSmjyByHdqtjGlR9tXAxkRlhfa8N4FFIpFQo/0LqVOP?=
 =?us-ascii?Q?1AdJp4rDzK3MwsdVlFotwZpDAZ4u/kjoFoF0nCV6JUxjjPpN4kpm0EwaonIC?=
 =?us-ascii?Q?w1XfbKI9zwdJsfEXiAd9qNNidf+aexoTQAqOVyk19yuxbsyRXfsi3C+Q0eeb?=
 =?us-ascii?Q?rT9idJcE/WsGazDe8FQAMkUv5vUvsTRdI0yIVhkLkqGJcckbT6ad4Qn8vtlj?=
 =?us-ascii?Q?ppUfBrEgjs2eX+I28E6pCPBrKzM1a6xcI3veQro2xLGTRBwWC7Rac1naNBAy?=
 =?us-ascii?Q?2Z3AxyWFyEIPL/dkpvrgqSBPAK4wDqiVp/eiB/H8xbs7Yl9lgPsTroQQhS9U?=
 =?us-ascii?Q?TZEOy89puKYykvS+jauNC1LNeJ6k/ykDRjNjqnWalSzvN4gJQnRFxAeKK+3g?=
 =?us-ascii?Q?+1p2LMMrmrsSLOiKDHqO2YzDRw48r+PrBNtl7SdoBMFBpV1M5fCeCWXGADmx?=
 =?us-ascii?Q?jxghQJFpQNU38ny/hK2yzZZZX0ZPZl1X1vKuGam/QQBTOtbiYPAVFms6zXUx?=
 =?us-ascii?Q?FZuFJLM+dOZ1SHLfSiqMRJ+zZfzo8K4Vd9zq2MPp9kGsXenrDHcKWBBXRnaV?=
 =?us-ascii?Q?v8WtORb5Zo4MYUa9zuSyNP2U1qOLvZvrkyp3JK2S/zNJx3fEfn+Guwq787OG?=
 =?us-ascii?Q?TYQLZELhWSrLttiwOW7C2IXKPfPhIEi05UVyb3EvzoP0bJbQXrLAeuuTK0oJ?=
 =?us-ascii?Q?4OGhGiRtf57uxUb0GHWehxY/aQs3KnOWAXP1u/YX7dX+DkU9JiGXLzI3Yi9l?=
 =?us-ascii?Q?ceCbMKeYcGNncQ5TcTTopyuGx8CXH1sMRQ0FpuGc+ZXmX6TR6Ip2EnzIYBcT?=
 =?us-ascii?Q?W2oJLN5Dwp5NCmUeUQdkYYrGZa8Mm+akCPlXZc8q+RJVYiwr3rJAmcZn1xOT?=
 =?us-ascii?Q?fsKRLX7SM+ZeN17TtAPQwJS3Ky0roByVpAWNVlQEe0x1jzELZvLlJ1+eP9yw?=
 =?us-ascii?Q?Ps0be02+NIVIEFVVaMl0oMQk6oul8ur8S04trBxzl+OtgAi1CqKV5XdKYuf8?=
 =?us-ascii?Q?H30Dm1IffTGT6dfpmLipliISdZ+4pCUnFkCEumL6SImGjhLzz6oXP4pI9DU3?=
 =?us-ascii?Q?vntS29TiGFajOpGWvan1OgHEon2TXzxFnlDyTenwlbmAS2DnqFRABKF5M8PK?=
 =?us-ascii?Q?KUSJFBJjfMtHUbII9MflngpR6SjUlpR+oAHg2nyJR53bjOoaGcYmR2ABWAxy?=
 =?us-ascii?Q?tILQrZLOEjeyTr9T1xThvkefIcQlHDwqijSZNVkmOOtTo+4nT7s2FOrS6QOy?=
 =?us-ascii?Q?S1T9cUQEF7rUb4R3Kwlbq2GWqZ/2BvXOLqLyTNslWeSgxFoAF6UGdF5QEfpW?=
 =?us-ascii?Q?FBodLvsSS0HUS+fcX7r+LuniJldgsuxnX3nsENN4Z0tH2MFc3HTV9wXyCQS+?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 648e1bd5-c7c6-4ca9-c1f0-08daf49042b8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 11:29:26.9468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8XiK991QEf3nKFK129KSsCF0wBWySITNLPirpePJgYLaZwDmxPVmIchPt1hFt2SFi29KtR+xZylv7ZS0oAhpQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8829
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 06:16:54PM +0200, Vladimir Oltean wrote:
> This is a continuation of my work started here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/
> 
> I've decided to focus just on the MAC Merge layer for now, which is why
> I am able to submit this patch set as non-RFC.

As it happens, this patch set seems to conflict with the recently merged
8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS").
It is still possible to apply and test on a set of kernel UAPI headers
prior to that commit, so I will leave reviewers/testers more time to
comment, and will not resend kernel + user space patches just for this
fact.
