Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF545167F8
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 23:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354971AbiEAVMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 17:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiEAVMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 17:12:46 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2121.outbound.protection.outlook.com [40.107.92.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93E4FD12;
        Sun,  1 May 2022 14:09:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCyO4af6N9Qqv3s1tec/UbH0/YaOZryKRrFY4PtRINqUmCD0UxFsPLBOVw5PSefBJqxets0uvzJTIoa46/Ygmp0uCWw+K/402m3ClE1w8x5APnEBCGeDAdYFm0Lc1LGwXCsXp+gvgAPw4eP+MOrSFcCzeO30DMOwVOUm487Lv8e/gPlArUPCYc8BfZSRQ+Lud/gBdLCrEvYHPmvzGIvE2kUyvZ0fqxHTQ9l0ZxMFP0R1DcmHiPyW6mKEtT9t+ebJafHKwwJIL8MFIjHecAN2b99SgEV8MB8ldTYTP7quI8aZisCHL6Ma6M33+FQRZN5InobhuiJbC1l37oAd5cQL5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5iVv4hjrDty+cHwXi5PCANLFTJIxBo8Hl/PfCmNKhYM=;
 b=IIoQtMeCeUgiRSdsyFux2Z9mfaW/6/XNNoPMxYhBX0K05/yfXpFVJL63xPtQplmpXF1S5y0UbasWpWhYYhj8LLqw2wCLtNpeaEFvbbLzteoH8vGbOh8SIAr/hNAiW4Ok0VyiqFRO4qVCeOxPePHHr8bxR4gnXqBBANiVgnvWovj2xz7ZlKbAncPzxdSewhNaJ7EYuURyKQOCRakZfDrdkjU7Wi/EAybG0i4QFGRWbzYUAaJDoat0TrCiuaB4i6MMIvwyJgoVWIfBqvFyT3QSHY72+176rkYHsIRY3I5XCrv9mzKcO/uQAahUtVO/yyUWeTVBZYl3LXW/HJ2s3v5mow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iVv4hjrDty+cHwXi5PCANLFTJIxBo8Hl/PfCmNKhYM=;
 b=ynif+mBeZjPxLGDyDo+oI499OdgMRndOj8LlY2VEnJiHYgM15B17Eo/aYiIO0sTMS2O29GWVjHNbLZ2eXdbayNuVX2+6BmA5vsQwNEel+6m8sY2xOd3jtVXCgUS0WAFYrPhrhtAeJHhLJwabDDGNBdDMja+srxEBrw/9G67B4Iw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1280.namprd10.prod.outlook.com
 (2603:10b6:301:8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sun, 1 May
 2022 21:09:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sun, 1 May 2022
 21:09:16 +0000
Date:   Sun, 1 May 2022 14:09:10 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net 0/2] fix shared vcap_props reference
Message-ID: <20220501210910.GB590748@euler>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
 <20220501105208.ynlxqqt6g4oml5fz@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501105208.ynlxqqt6g4oml5fz@skbuf>
X-ClientProxiedBy: SJ0PR13CA0046.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11bdecb5-0ecc-4686-176a-08da2bb6d99e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1280:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB12803F02B1EBFFD25AD55960A4FE9@MWHPR10MB1280.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mocuYcjly7fzw9BrZFuXbMNmGcJia4fnwZIF+AsA82F/uN9PZE3TpNe3NRhD9Y83EIheAGo1wqyBD90UyE3k7jTd48j2WbItjwOSg1Nd5UDmcpim5Hbq27Q0zLhNehNT6uU/Iz0pfga9AAIQyLAdmffQXMCoHc+kDzOdJKiH3HO+RGRwAsoYV+1yFsDgBvDfXA/9HKSap8K57ys0Rm7QCz7WZCld9lrKBvrxOwieF07ZLNTGpvnHsrttGFnUTtaO6oWUdEYn8loHSj49S0fz282A5+HPLPy1bTfvKsTyN5fc1h6djelyqd8nmpaGwbHeFh4wuBH00dsMMuj2x75R15wl0D7H+38IKdq2nSLaP8vDf5fzhDnOWNH2qQwRLqLiw/JOJ4AfZ0OxR0VX+ojWsTXoNx35TsSEUCXQ46U5KVVf22K12utiXdGdT1GwW3QvnMs//qk9qbt45TN85QapTOmR9Ydu+wQ6EVVMTVZM90+5R2jwvyNzG/EgYCE/tpV0buyFiTzRCn9ZrnsU8bKdLLZnR6m+RudCZutKgNdc2xJ7eK3KVNoDMonPMe23i+LcP3R7CnXAaFE4i+WBP3Rx8qtBfodVOB4Fcs/hGDrUUsP6+k+UsqN/0783fmU2Z0qmJ7al7CXkd6J1DprfKw6ZAKpmFzPzCBliuMf9hwboX1w3wVyv//2PXmVqHkiKoXqe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(396003)(346002)(136003)(366004)(39830400003)(376002)(86362001)(6512007)(6486002)(508600001)(2906002)(316002)(6666004)(6506007)(26005)(1076003)(9686003)(52116002)(186003)(33656002)(66556008)(44832011)(33716001)(8676002)(4326008)(66476007)(38350700002)(38100700002)(66946007)(7416002)(54906003)(5660300002)(6916009)(4744005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3+WERDVKCeqGwZhoX0YAIjZqTdUPRsQ7351gCG25OleUEiuWH+94Ax4WDhUD?=
 =?us-ascii?Q?43Dk5uOTn55Js1HAs/GyxSm3nxFYtorEuteOvTvMg6NQ2iqAIUcTLbjCvjbo?=
 =?us-ascii?Q?9SBmLWI7JlCJR1YKB4Gscfdo+Xn4GyYLrFUUDYGlhPy0DPOdi96RUNmww8HW?=
 =?us-ascii?Q?7Ivi962z9Ix22byDgR4bHoY3Rjx2Tr9DPv2fiwF7fLMctl4QgQ0LO6+XhiSH?=
 =?us-ascii?Q?PloQl+jut3kRoFZvvezWtVlKd4q4ndwwN/ADEOmg4ewVG6IykmpAX/KLUeQi?=
 =?us-ascii?Q?vK0b4ac49a5R9YMSv4sYyK1nPKMfyR5B7X1cAOiRgLkgVgAr5Pv1DBMuG1fi?=
 =?us-ascii?Q?0DB/GVJD9S2A6C3/H2N84hNx/yvzea6YKsYAwkRSJk6VBdxrGK2MIPFXvDdx?=
 =?us-ascii?Q?gVPgPN1TL86E6QyVxvv51GFmzX1yoU+8wwV9TXzGv3Utojzs3gbbTCKwBSkv?=
 =?us-ascii?Q?hR/Gh5d7hP9CFlm0iUbpsQGyu/K94oiZOQ/4XSRsahFcD1FYB+W8lx8slRDJ?=
 =?us-ascii?Q?Ss0qrMyjaDM/e3SpO8s+UwWc+evcPIqgPVUijvCV7PFHNcb8cmd6az/0ADit?=
 =?us-ascii?Q?BK59SC7PqOcCVl/TY4JH22JVX0d5q4ueeeTAG6qwUe8g6kIYbCvAoVFVLfoq?=
 =?us-ascii?Q?CHdof6HaPFW6mPtlZVLL0vy2aoZG+Zi6ZW33hFsqO2l2fyI1usSaudRkWAlc?=
 =?us-ascii?Q?co7V77QKw4/+4EJKchakUvPkUk2pOc5XiVMfd2uHzd9NSjtqLiAxdEfNDzId?=
 =?us-ascii?Q?tLkDFlsS+y/CkuZ0oDvdV9Jp8X5j/a5xzXpWMEqbQSIHKU2OnCIxI8pm1hH9?=
 =?us-ascii?Q?PTNx2cSGBXLtm1wZBBH8lBxpHp4Hy0Qjbj1buKBowCk9yNENsH+7c9/YbWZB?=
 =?us-ascii?Q?sn0thzwX/+O//gMfzj5JsLxMHx5aExocBreVToicmXyfKqgiVWhbjZ+00+L3?=
 =?us-ascii?Q?yPPZ5Ckr8Gvm1g4qfJqYUueqWf7KEmXE3IRT6heV3voDthd3rMW8W66AgNlB?=
 =?us-ascii?Q?eeSTGpJKgXhcPpR71jkr6LvRPew6e89PdUPvRfm2nVahix68/UU1ukG/sgXD?=
 =?us-ascii?Q?l9ZgPYI6gYAtGk6r35bpQ0HOAoRcBM67k2CVN+87yd6RUCJmM1+lxiFb6v5s?=
 =?us-ascii?Q?HzOG6EYsZJUwaR2X8p8aoGjQgrq96wdikwXqxsr8uHke6CqwYARRse4s96jX?=
 =?us-ascii?Q?QqMmQszLG0fwyY/hySdROXBn+5t+8jGNgWqUx6ZjdqKFitSoSHjOMVRZCpCV?=
 =?us-ascii?Q?60tcyNJ6MJYZtb06rxgMYo9/mglJX7WXMDJaq0Rh74Mbwd91WIsGD66CTZdL?=
 =?us-ascii?Q?dEqiuSMblQm/6AKkROn0dA1HpTTkPFppixPq/Jvk5Xpf/5RGho50mvk/UkIX?=
 =?us-ascii?Q?hztea1OSnUMUYsW1VJY6ExFjVeudiimmAUiHVoVEpulz9HGNQ7MODxceTZrH?=
 =?us-ascii?Q?1iZJz42sf9C3uxAwRd3gwn7cvZ4sf6tDQ2wlpuix9euFGll2mtLgkkwoYNRa?=
 =?us-ascii?Q?KGIw2giXqxolYFP2FeMEmD0sM/6CiJNwywJyZi85u5UHPy1SVSfN2d8C9zvl?=
 =?us-ascii?Q?2zghkwiFsntSUgX0IULrJx1lFWaVA8MpYHIimb2GZNAK8MElaI0TSaNyL5xk?=
 =?us-ascii?Q?fw6yZP4gITHGM2tlVOUXmi95zFSYgOoyHhlSyodFEOCrqb7r6vzl2ufMr+j6?=
 =?us-ascii?Q?lxSGWPU2DSDfoN1q9ELin3aIBuMHD31tf3tEf/eSkDBkqBpzzFB2oPNI6Lk2?=
 =?us-ascii?Q?9UCX78C9P8I+Ig7pfLZz0S6YlK1EzwNLG64Z0QXmsbR+ov7uRbPg?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11bdecb5-0ecc-4686-176a-08da2bb6d99e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2022 21:09:16.4061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kapEIXQmonmpGyI2vUvxpsJb2U2OLEX7zyuIKTczkQfIFNm40sN3ayAhkc3hEDIyXXHVCXE8BaJPuknKzzKcuYq/u4C8ohWpZTZoI6iDwtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1280
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 01, 2022 at 10:52:09AM +0000, Vladimir Oltean wrote:
> On Fri, Apr 29, 2022 at 04:30:47PM -0700, Colin Foster wrote:
> > I don't have any hardware to confidently test the vcap portions of
> > Ocelot / Felix, so any testers would be appreciated.
> 
> You know about tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh,
> right?

I'll add this to the (long) list of things you've taught / shown me.
Thanks! And thanks for testing.
