Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E246ACFE8
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCFVLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCFVLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:11:43 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9650B6512D;
        Mon,  6 Mar 2023 13:11:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut3FpQJSz34nXxmiCm250anjcuY3OcivuyP+XqG70LaixkOHPb3tWrs8eEkyripJMCa6j1/qELvFA4LZ3rY7ANeucukfh6e/SRybcg9wit+UDY5vp7h1h0ivu+oeuFJjgtbHkpnNdAarVI5VNyYRboc5Igr39L2FpL4ZSv4Xzou7JG0lK+/rHNAv7jTm7+DOub8xN/Tq4mDGI8OzU5oN7Lhjt4Omyf0mpDgYqhRF1MJ/SrASUEBFlYgxA9r8Cjp/ZwSH7HdN8cOnLg2lMCaDf0Q7irEdEOq3MuozjTiZI5Aqbl79/cZivjhYrLHs0Cgk43ym1GDzJmlhQgAokBg5GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvfRFe+H77AuMT1oM8rNSOLcETbeBf99umqEOgpxb/A=;
 b=EZohO6Otl6KD02sKxEmzrCN4uaqMcX00RthbAKvkql94HCxF3KTMFM74Vw5c+8z2GI2kgH9cUrZ6v4Rf46YR8NyuvA2WL2FqTcnmmZ4ySKNDXN++m2bRt31u5MZaKajFNgBhvq1V5t0RboW1JlKY3gKJu2fVAYzZefDFwlcDsAD4NnUyMiD2OQg2PuQzsXc0pl1z0qwfAZBMJa1ASNSOZ/CLnprrzwkjtCYP8bUnbvrpTETS2nlk+1pcbb+5XbRDmt6sAt3VNGax2RhLV2fyFOWaZZ8fVi45SjEVchkGzRJHW6WJPRP9J8WT2nrUKPeYN3CdzgXCQ9W5MQdgJGn/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvfRFe+H77AuMT1oM8rNSOLcETbeBf99umqEOgpxb/A=;
 b=on6IuyvYw3d5RWHKcLwuQjPDgrq9gJhwG1LPc5oAPtpuPog3+JuT+iznYbkFTZbEkB3z1UNtkRk0f4wtFgxQiIQU65ULqfhgjVXyAJ0Yd/lb0bppJ/+39Qfd2ii6amtk2oqyYEk577c5MuI42N05nLiQt4Bhk3BQoEy7CuiOFkY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5790.namprd13.prod.outlook.com (2603:10b6:806:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 21:11:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 21:11:32 +0000
Date:   Mon, 6 Mar 2023 22:11:25 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jaewan Kim <jaewan@google.com>, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 3/5] mac80211_hwsim: add PMSR request support via
 virtio
Message-ID: <ZAZW/VAIESfTgByW@corigine.com>
References: <20230302160310.923349-1-jaewan@google.com>
 <20230302160310.923349-4-jaewan@google.com>
 <ZAYe4oATHMdqi/H9@corigine.com>
 <582bea54cc5833137a2f8b7a375484b1656ed761.camel@sipsolutions.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <582bea54cc5833137a2f8b7a375484b1656ed761.camel@sipsolutions.net>
X-ClientProxiedBy: AS4P195CA0007.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 6294fc46-525b-4043-cc75-08db1e875c2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbAShkCFAW5A6TX7VSf9CZRqlOpNxboX/0TvjQjTTwXtmRpVNmD2+QdSDFx+CyDwE7H75h3kDPTOoSu1Ngjhocazrgk9+tOs6e72p+qH64HpJ1GBZikt3zLxP4tyj/Fyw2fEBRvuexZVNKQEVddSkqxCmjITkbx6ZRwC9SQMMV4Chdyo0fACUGGkzYU9WeEbGfEOW64ij7xvBaf/eIOO9juVKwj1WIvTqDuTAMMGlkN4udpNxHC8VC7Uhlb5xinJQL1k7iGNxZ+kvE/IfoY3SaqdFvKEyPEMojEdIbJdG/NTrM35GwtqGZkKcJvASIWMctAE/gCuvJekIBsG3Pb7TxHP1Dv2rEX+V+I9WSKrpRKqCILT7/3jzCLbT+1jhCgMyW9k1aUKxg0J0lKUk3iLy6+OZMw3/XeDnKsd+iqxcwbC8dLFn4wtDgklqRMBPLuEjHlwYtvcT39p9WFyMF2tOb9gbri/cQBP0BNgHvV0Kt3GwlSN3/7Wk8Ho/+aRClC6VNeGcnK3ZspJ19CzwwKXFj8JsRInv+W2cWme0x3GLKWagFyluFrOb0dmD5k1lddEOKP8oUpEk3KjXRAhpK2/PL4yvBv10KlKVudIIxC0nbp4BHQnURtqZOJpKhIA1IonOYe4CLVEqO6BM7O+jWJYtdFNcQSmAB7f8xG8HAw9JYIpNYFeV9bbyGJhWx2KCpuU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39840400004)(376002)(366004)(451199018)(8936002)(5660300002)(41300700001)(4326008)(6916009)(8676002)(66946007)(66476007)(66556008)(4744005)(44832011)(2906002)(316002)(83380400001)(6506007)(478600001)(6512007)(6486002)(186003)(6666004)(86362001)(2616005)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mM+jr9RrOWJp5qde9pzeew+l/eF2L1aic4qBpA4akBFuhW3nUwEfGOzs3fAp?=
 =?us-ascii?Q?VkzQ5ZqyTej1xM8j1Z8SWag8DarkxhWQ62u8DUGdexXL4Lm6E+LI+IIl+y8R?=
 =?us-ascii?Q?s48n2gyEvW9uqrP2Y22xF2Ideipu7YrpfDIf7iUzaR5IaSO3JOuSeW7AbBm4?=
 =?us-ascii?Q?ZTs3JcpSZbSBmremUssX3lzPL9bXsVsDDcXCQTGjLr5Yjpkyt/zAi05qy0fg?=
 =?us-ascii?Q?Yj9Z6Ga1zdoLFgd4bBiarsop3S6QIK1PSUzBoUJVF1wNIyZBpzIrdGs6IFgV?=
 =?us-ascii?Q?8puNUAW7b5zPLcbt2nKwSFaCNfNsPqstYnEIapzaRsnnfaAHPy5eMu2tU6pY?=
 =?us-ascii?Q?dCeFKk+FT8HtBZioawJYfBcREyXhd0qHb+44DLGzfgE5t+qnTr34XbW2v053?=
 =?us-ascii?Q?KEcavFD4ie6HZOJSzKvcaYZJumeP2Boj9evZxOBmZJ1TQEXdL8UxdunsiO5R?=
 =?us-ascii?Q?ul1DSKGGMiE+rmMQ9YwCp1VEICFzmfzDux6mEBRxJtd00KciY+i65gRtWmsw?=
 =?us-ascii?Q?2KxNk7MB1F12tC5a9jiig34cczOS111m+9zSV/5+MStMnn663SGUj2TcJius?=
 =?us-ascii?Q?Dmuo+pskf1cKhiGBwfr2cfYXhNC691UnmI9VwjZ2rCn+lOuCBTKHCPPs00Y6?=
 =?us-ascii?Q?rJAZd4plR/mDZAxeJEVcpHNBPcSxIyQ98pk1jXDlI7mywMwfCtdfdhZfmBVo?=
 =?us-ascii?Q?X1BnyY+al9mnHm98xcH84IlJnjooUxM2PUopyaYHZIP5xwZuPZgjKBzJrGA9?=
 =?us-ascii?Q?HomQEZoWVDYPrOJCpfvlXmhk6t29NdeinOHc0a/zxCRpY7E7yIiPDLt2hww8?=
 =?us-ascii?Q?bsN/10YudGmS4FXMgjyKmhngAO3bZAdOJpjmYTB3tX4JG52ZOclMwCBZaajH?=
 =?us-ascii?Q?WRBZzUlILyiyc0khJGtL86KAY2+Z/v66vqB6rQHdCSNvztAU8vxBjG9Zkg3z?=
 =?us-ascii?Q?xCZImg45co02/VclbkP0wPNR7lhaXDbFQtrKD0lV5Mquv3G5lCw3p3rNnwRe?=
 =?us-ascii?Q?xABqt7pFMaw66JBmFZ65rnHcWxrfBqJMxiiOruqFbtKkPz9HnLg7TjtH15U2?=
 =?us-ascii?Q?PXNs4pKq3C3oeS7djTWpVsWN2giRAvKWvIOxLwqSW93MddclUPbPU7Z1Jvo3?=
 =?us-ascii?Q?YLppLIuVICYiseSkCuKPGA5qEKTSfTMRIpBhVem4YiLbFhzjQ4e+1ApoW2Ac?=
 =?us-ascii?Q?9oWFHyWLh0BkSBOM3bN5h+oB771j4Cq7IAIYK9RyuKbD2TfWbzHtT1S4g+3Q?=
 =?us-ascii?Q?7sMXPxnlk2vM751oMWgsZ1TEmjpMFQsZJV8vgZQfrdLpMd+y19x6wqZ7ZV69?=
 =?us-ascii?Q?jQZ88mbL2l2cOQ+5Yfompr9t9gp0utYvTKdx7C12nThM+MP5gC3vTYeRqq/H?=
 =?us-ascii?Q?z9zjHqfSItA7yqL2YMGkMWya/P0BFz+i+Cj0wlfZYsQEDAS7dyfAG450aCDb?=
 =?us-ascii?Q?A+ZYzlx9wvSUR2Bz86gRnNrJsu/YFcqMuV55PBWKRAWobSdiZVcV/vVI0/22?=
 =?us-ascii?Q?zAJzp45yJGBuB9zDbdgV31HZ76vXYWoPe97DwPLRKkPAMm1/zFJLjUNVC1s6?=
 =?us-ascii?Q?53R/WCbXGaRNoMu4KhvzjJnwdQ883dUHHOYvYzLY7X1HOeTcetQwolYjyG8O?=
 =?us-ascii?Q?R44ORd9JkOLjUQAq+BBXWycPrLK1DMTaYPb/Ko8Lwz0OJ+lvHz9jMu7BeVe8?=
 =?us-ascii?Q?eza1Ug=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6294fc46-525b-4043-cc75-08db1e875c2e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 21:11:32.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NjZxvDbdBBO3zSrpXkoLg96pWyYz5DrUoXSMKM6IgXchK57oRMfPkixip83ZLvkkaX+dMMZETUQAl0WajRnPaks1rVGkgSiF3VsNdXGxRYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5790
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 09:45:16PM +0100, Johannes Berg wrote:
> On Mon, 2023-03-06 at 18:12 +0100, Simon Horman wrote:
> > 
> > >  
> > > +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg,
> > > +						     struct cfg80211_pmsr_ftm_request_peer *request)
> > > +{
> > > +	struct nlattr *ftm;
> > > +
> > > +	if (!request->requested)
> > > +		return -EINVAL;
> > > +
> > > +	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> > > +	if (!ftm)
> > > +		return -ENOBUFS;
> > > +
> > > +	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request->preamble))
> > 
> > nit: I suspect that you need to invoke nla_nest_cancel() in
> >      error paths to unwind nla_nest_start() calls.
> 
> The entire message is discarded if that happens, I think? Doesn't seem
> all that necessary in that case.

Thanks. I was wondering about that, but forgot to add it to my review message.
