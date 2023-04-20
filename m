Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BA26E9A3A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjDTRED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDTREB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:04:01 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2045.outbound.protection.outlook.com [40.107.247.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C896270E;
        Thu, 20 Apr 2023 10:04:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b28UT3lx/f/s47YiK+TTwPFRZCQj6ydPbVbUBovL9NzsXw68i6MduSO7NlhZoBifCX6n1DGJtk6CJxuehw88a+ZaNpNunBrMRcoy+A7Xs5HiqLUwid87FjZFQLqXid0F/P+Y/nlmK824zT2V9KHmFNF5rez/zPwLBuHc8bApncmnyNNVsxxZJrXaEPXMUE+osiVk74tigQXGN0eJneAM1BdmWd1jFlvLRYnqhhHOceSdOs1R4PvGcVkIwMvcuyA4jAdHDHF050PbjeaRz7OqGDV4NXABYi6dX5Dqjc7m3rOzbTFExTD9lsDTs1UhUtdSwEQrrr6tL/5NK3m+ihftgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFbDJiN36V4gH+PWYAktibClADQGQebAxjmyMAd7WNs=;
 b=lAWvvRT+SFu2Q9f+lFlXvX9xVq6jJBegGW0ebcmFd59aQlTyyNj3CVP+07qXCpK2BGGgn+iCav9x/UrfoMDMN5cuBpKW45LIqYyyjjlUmY+gYDg6Rh2n+HI/HDdjEkcSClRtcVmF4tQKMXZZ0OFYT1x45yt73607fA3rtA/14YaV3tHjyC0kBMHEZ6TKkgYskJRZI2Ahx9e57fYTRqKfDIEL/83Qyo+fUn4uBH6CHxmhSU6/6a/e/Q1T9YMqYEIF5oi1186R799VaKM8iS+M4zrrhopp+bAEkE8MtVv7sxVwGux9bK8LIn8jzJYS225J6/pIbLMcGaSot579aidxeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFbDJiN36V4gH+PWYAktibClADQGQebAxjmyMAd7WNs=;
 b=lVMED1gKvhPQCPEfE9jp+xUUIk1Wt5xplbu/ua7jkymey35utihpAGJRedUH7xF9ECWhwxO9j1zdIKv4YxDGIpWp1foEiadpAWf9ySXvNhi9psfIVzvqRX8Jx/h55ci6TXpmnBmkndT7PEdG0NZ2izKl4dZfZPguuJ3qKWLxPtw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8557.eurprd04.prod.outlook.com (2603:10a6:102:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 17:03:58 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 17:03:58 +0000
Date:   Thu, 20 Apr 2023 20:03:54 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/9] net: enetc: fix MAC Merge layer
 remaining enabled until a link down event
Message-ID: <20230420170354.n76b53ws6bitcoj2@skbuf>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-2-vladimir.oltean@nxp.com>
 <ZEFKjPR/VL6llxDm@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEFKjPR/VL6llxDm@corigine.com>
X-ClientProxiedBy: AS4PR09CA0020.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: f17fcae5-91a7-4aa0-1da5-08db41c13b2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTZeytGSVc0Ue/QrJdurABff66ZvO1819tJmK/Rh6HN3LfbW+Fl0qqM+Tg5Ig6+83FKRKo0HohD5EceP5a92qFlJg6dR1DC76qUSpBn6uw1LsIbfzJLI3Z270fec20dCzXXDstIKXveLde4QaYPQNH78SsDZBAnnaxwMymlxW/kRmJ+P/ecXFpbyZQTf6aOIuEqonWNIrmpE8QIVHHbWPCyxeLaHEqeI/5fd6u5H7ifGfRl1yS4kFdng6pTRk1QS2HV/Aw4mEylXHut5ySU7TfHSoR8w1ZBmapmAlCcs9t2Cy1ghYiZFkRr3iyhyGc6ip8TKGAukBSqCcDba6YKAfB67QTs4cZALAJcsc4RSddGFWmCo19xXx0S3ADsZZirYdrjBBjxGW/WSSnMdeNEsktsJyzzf1VYj5P5ZiWRw6bTHg1+hUbA6JqhJGbqtJD6iqi7eWHmWvkDBYYjhYyz2WAzdKvFlSpSc8trOXnHDQjxc0s/rlkdec3kS7/llIWfsrCHY7UOuQM96G+oYHWIjKqWC2PraHPGFM8mK9OD0QE4Pktkz1Dp00nfpOKxVqfAa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199021)(2906002)(8936002)(4744005)(38100700002)(8676002)(7416002)(44832011)(5660300002)(33716001)(86362001)(9686003)(6506007)(6486002)(6666004)(26005)(1076003)(6512007)(54906003)(478600001)(186003)(316002)(4326008)(66556008)(6916009)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gEVGuW7+/YDYAjgDaCz0DyHqo56umaSLgfqrIWqg8k9LeK1TLpwcQ2PFEcxr?=
 =?us-ascii?Q?ngmHhsrNsxN1VP1MJoGSW5xSOhqDlwgFarWaaGsEEm87xVp3AXyzFjEK9KGe?=
 =?us-ascii?Q?EeD9LxKvDnzujVlbRSj4UwZvYcFb9Ak7iIoCxQdQDyas7WZf9pf+iKUI+Ddt?=
 =?us-ascii?Q?WLqFykHFwynwnotEkO+DL0Pj3vdOwxOaXiGG0vRmQCOA/+WGLfe4h1aj69v/?=
 =?us-ascii?Q?EeKQfOKUy2q9qunrv8/d1w3OIWw0ivLiXLoqtqR7zf+Qg/S6+hvkBG4Ruz2v?=
 =?us-ascii?Q?8ztibRff4P5zYPJ2YI8wxaLq6E2BY3B3XKZO+f3b1Pvi4StA5tB7sXSPVUus?=
 =?us-ascii?Q?GS4QN3jH4g6zVLvZwi+UVBk68U36vi1jNEAGXD9ccJeKUlbadDwq0pFSC/xF?=
 =?us-ascii?Q?XZAmA7IHAJDu5yGtIivR2FVqb4n+2PbA3VoGZNgXsTlW7R33H2RhlUHMCw0J?=
 =?us-ascii?Q?hRjFImWWWX4AYdCXjtw6bT/CO6mTVb8N/pgt9rdinf0tuBhipp8J+fZkX7J1?=
 =?us-ascii?Q?3KeEoP1mumKh+wQahnCOaR3lKNz20FFbdopmUzxL5+g6DgepiTsuTnpdpEKM?=
 =?us-ascii?Q?n9brlU39hvvqhENFuGLjYy62F4StHso9EpD1o8Dj2xLz8RYOuIS6lTHbsdqo?=
 =?us-ascii?Q?U1Qg5sz1x1glaIzf+0P6R5IyEpx2Kw8A3BNPumlThcptjDA0Rz4HRd4oSoqN?=
 =?us-ascii?Q?6jtkSwI9S8lAGPNRGyVlcvn0HYRFKOGvrAZOTwlqvO2LQQSto8SvF8dAJ+Hz?=
 =?us-ascii?Q?5K0QHzsQgVTHDiFetTDyksCGqnxH93ESTmJGqWQV/7IylINs5Mawb+I0FXh1?=
 =?us-ascii?Q?VPaCgsrr81cKQfKun3+CV1xrGYY3QNNNf2HsOSRjXq51SU1Rr2PCSjdfhF/G?=
 =?us-ascii?Q?SX3Y+FkN22pOZR8860a5ZAun3chEYIvIGcJkWQeFJkUYTnvQ1Ond7mh2v5jd?=
 =?us-ascii?Q?5JclZrF6NH+KkQ7uqh3umoggnAwfZdDv7nHVVsJBdYePwOF+Y3Cxr/C9D8mp?=
 =?us-ascii?Q?L4uL69YxcHa9IkKK/Kz7JZdcwDdhsvEU4goBlddqgPOgD1Pwm9oL7vn7+7MB?=
 =?us-ascii?Q?SdkRGMk7asBjfh9I6l7UbDW2epnA0P/u0Q6APcLT0W6wFoyAKaS0tcmlOLDH?=
 =?us-ascii?Q?uzaIqM/didumAp4DNQFkjKgV3uCvu9Tr81EZjx/vSMy30Mheb3fE1GmNeD1P?=
 =?us-ascii?Q?L+IxwTVvGmn0DxvO7UQTdbHPYwTxDgKXXzpszwMlTwRAUGV4mD5X328ehvqc?=
 =?us-ascii?Q?Hi7VjBqudiTpc73r1+S9KhhGsl3EcvImKNWLVf9Q4WlqokogkyPrcnjooo32?=
 =?us-ascii?Q?6EfQg2HvRNpj9YUshZrCmiIVHNsntNl7l/iH8zY1GO2V1axnLgQTAqFVsJpv?=
 =?us-ascii?Q?8/UaR/fMtfdfh+Zt8i4T8hUwOys3IFnmanlUYsbzcZDkDBur7XPsenLwrCTE?=
 =?us-ascii?Q?ApjYvFbp1X+h5ad8Uc2TKssds0ByZS3omTFfRH3zDSmeARixt5CfnaO6g2FB?=
 =?us-ascii?Q?CkCQ2HrOpodQWiXBLLDguntIjZgSYsQ67NEqRSwR7DKfZIk5+ByvNMIiaQxc?=
 =?us-ascii?Q?A9b07bvhtQH0QT0cmAWNG+fCNFfoE1AcftAq0MjIpWhsjcvA+YjcaM3c8ZjM?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17fcae5-91a7-4aa0-1da5-08db41c13b2e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 17:03:58.1858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVAA/sqaBzzxmu7qYnsCskFjIE4DoCAdxxc7Ft8snQ24WOcBA04qecnDJcumHlSyhEJxVhTMcF0mSSPXGNRrDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 04:22:04PM +0200, Simon Horman wrote:
> > -	/* If link is up, enable MAC Merge right away */
> > -	if (!!(priv->active_offloads & ENETC_F_QBU) &&
> > -	    !(val & ENETC_MMCSR_LINK_FAIL))
> > -		val |= ENETC_MMCSR_ME;
> > +	/* If link is up, enable/disable MAC Merge right away */
> > +	if (!(val & ENETC_MMCSR_LINK_FAIL)) {
> > +		if (!!(priv->active_offloads & ENETC_F_QBU))
> 
> nit: The !!() seems unnecessary,
>      I wonder if it can be written in a simpler way as:
> 
> 		if (priv->active_offloads & ENETC_F_QBU)

I agree. Normally I omit the double negation in simple statements like this.
Here I didn't, because the expression was split into 2 "if" conditions,
and I kept the individual terms as-is for some reason.

Since the generated object code is absolutely the same either way, I would not
resend just for minor style comments such as this one, if you don't mind.
However, I do appreciate the review and I'll pay more attention to this
detail in the future.
