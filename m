Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1992B68EC7C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBHKPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBHKPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:15:34 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2103.outbound.protection.outlook.com [40.107.92.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78E223662
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:15:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqWtKF6H2DX/zoeCN74Afkh1q5ajikpfsPqPtcmVaUr7cfE6EGR1foijYufDa+V7P65bxoexN+C+SLwZ7Ovi11YfFoJkJZUQwSFHJtpdJ322gX+3B7DqZgrgmYsnq87e00uhzw9wpmrkq9FiTveMBEb0XgDqX5KIY4O4xszmLeR05rTJUsiHYYHurGqG1QqX05AyT3M3Qh9TxDUwc4DvUm9u/EZiLTEgrJKoGZYPyYvTaNGmksHPXUeUwEEm9g3skGS1ZD758mgNJAG8Ksz5d/ernnWsMfeBPBafgFQQhSq+5GkBKXe4QOXQIkerPb08wMRb4cQGVoPBdbfyd8cHWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZ37wKkntkGY9I687evoPoR1wl7kODZmFaCNhGzPuEI=;
 b=KdL6FV/U5EY9ty7K8mwep/inh0CMtRWRxrDKtXcP/ePVNItk+hprghaERTThxCOSGmwrDoFVtYmwxbiS9o55KEf5jM16npmRb0KH6p0bq4/QP4XupHueiYXdSvlu35HWGdb0WzVix66/xcqoWuhT2/oBJvfypRFL7etkUFFLR02lCU5s9F0dZmrxyt9Mo5L6SjhI4s4/gAVUUFszTlli0uAouy7xa5HdgiBiG/62fUJrTDqIUd0kWlXDw22z9BzNQUbOjfafHePF2rpRVi8mEvP90fw1069gP8K2FP19HTqfd+sFrPrAwMl/08fcxgTEtMSiNzYBQHIc0fabEzp70A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZ37wKkntkGY9I687evoPoR1wl7kODZmFaCNhGzPuEI=;
 b=JWfDeuq9p0pe66S6C++1YT00UxF9WQHLqUnLuLUM5OoIW/5MBFUscvrvldX+Bkf5TQEnsYb+arGJkvb51B6SmvAFW8/jzIumCdJNM8y9QCbusyEwqU8LGU4yh58BsEUishS3cPTD5bZBZsw0DoUVsLpxDMrYD1TQoK5tOdXAjq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5148.namprd13.prod.outlook.com (2603:10b6:208:33b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 10:15:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:15:28 +0000
Date:   Wed, 8 Feb 2023 11:15:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 1/5] net: create nf_conntrack_ovs for ovs and
 tc use
Message-ID: <Y+N2OQdDK0ABGrgl@corigine.com>
References: <cover.1675810210.git.lucien.xin@gmail.com>
 <40147ea76fbcedaa477a68e4ef12399dd36782bc.1675810210.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40147ea76fbcedaa477a68e4ef12399dd36782bc.1675810210.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AS4P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: 57f74518-f04d-4455-ce50-08db09bd66e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sx9fq5gbgIwCJp+CQm8aSTRGZj+cKSJBaAFnJ5fwbXm96hzIE6afY0OeDcbUrR9b58MQKj/4PR/D798Dqdp8vnoK9sCFNe2wTZ7+jRHSqIBNGg0qlJVW4LGilg/D3XbHIgwEfkPUO5MBQsxHnaqhL0axvi7zj8CXgbHnPCvaP71Hb/rxuEJkrHpCayUv1/ledDhq8UK+6VQd1AduxU6JE29JQ/Q/H3UhnuvaxE96aUZYl8A7H+wzIEM9mIIP2F8l4JHM2PC4/x2GgmRf9Rg1/FSW+Hm6AHGWpwA9+beH6SrtgX/3o1WofSypVs0L0QnwKi572aNX172Lqs7fmqw8xdlaSG6SMxEub7ZwCZTFkc/h3SG1Khd4enhMdp2yTaRPhTwHAedesuXwdoVRFAJ4n3qFPYoniCvhut5JeMlywWPR9R5vIY1RhCSv0jnvIpzjMgA6nnily8vJDI+kSmCi+UlaP/u83k6qjf0hhgzUJ6EhRNXbtnbIFx+EXmgt6Sb8fnu79TnQpcEk7Pmm6j8h68UF6XNEbQL12jNc+ZbB4iHD5GMDkP+lnVfPJZjbyLRhJ8hsOYsW/zCf0KG5MF9+SJxmUSplFf+mL44rtyZXlRp5QdImKOMfgWMPYh1NnhHV4mEzp29VvKik4uF2kRdFCncysauDP8iO2vriu95UfA0yA+EafX/v1cspnw41WQrB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199018)(66556008)(66476007)(6916009)(6486002)(66946007)(41300700001)(316002)(478600001)(54906003)(38100700002)(4744005)(44832011)(8676002)(186003)(2906002)(6512007)(86362001)(2616005)(8936002)(6666004)(5660300002)(6506007)(7416002)(36756003)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VGtNMX1/R+CauyQmOZGlXhwQOtbAmICS9iy8lFqFKDM0ORRzZAKTCZWqgsJD?=
 =?us-ascii?Q?omIY1W4TguZoXz3R+ZCUd1oQJJlRFU0DsUWFOs4MM92Ok6YSt938fzGAIdrK?=
 =?us-ascii?Q?AxmfNoZkeDCqyR3xrX44qxalonX/nbNaUH4kT1UO8HldJVBhUhqQmoB3amrh?=
 =?us-ascii?Q?6uPOHx+wJIaKNTKCERDAqQN1u0e0sVURIUmWEQonkAg3HMpmk/qwE9i820PQ?=
 =?us-ascii?Q?6gt7gsz6urDHf/Q4i+unkVc8oUPpStP+l8LRRAt/5D/2plF2SuDP4/9JYxef?=
 =?us-ascii?Q?peKgE5ey3nHGFXjz3/pTY71uyWxKpfb+qQ0jTiMlsX57dcVQYUypcDAzWcRM?=
 =?us-ascii?Q?/2YxioHaGJrCwd09paEkHig/E115ltU5PpImfnMweQFJC6LQKdWvG5U9vwL1?=
 =?us-ascii?Q?5b/KkPYij6s770BAjLsL8s8186TBXzKnMdAIHqYHkpTNWLfs6Rno+VT7p19E?=
 =?us-ascii?Q?dcq5vtUlBnIyIYOFoU2ECiRDp7xL1+tWY2Hy3JJlzOKh8m3tgEXmIopd3CzV?=
 =?us-ascii?Q?QiXRwFrKgXmdLrD1XPCXeNAZFFPIyKaLBg9sTy+sxNOnxm+6UNWyt+EV0Xz5?=
 =?us-ascii?Q?4QYwhhElIfvZFL1xDFwgFU4uZQ9Gn8GftRPthGgkp93zVgRopuX8WvKEMzJL?=
 =?us-ascii?Q?ZzXgj1SzI6pWHVQaUyBJ/QoagezABM+xPtqwolWgntP3LG676Y3T12wE4z7R?=
 =?us-ascii?Q?G3L28F2Qj6O5LBvJRPR+ImArohoN3AmMYmgi+Zd2R1++MKTFJIksrNNvxC5P?=
 =?us-ascii?Q?TWXqM03jTdCYNeASfL0j0kpsRK0vkjGtDfVXc3wCB1+31NY+AyuyQ+H+0Hv0?=
 =?us-ascii?Q?i/K25b4eXIqa6VDLTsDg3gkl24jkdad3K3iJF/xB8Y9i+fOtQMOhLIFDC++C?=
 =?us-ascii?Q?00XcYv4dge/3Aw9eQO+Nm04EMQ8o7XnlxoXg2TFhh+GbL2s69YtiljZ654oN?=
 =?us-ascii?Q?n310M/4Em3YpTcjcW5IpQTwSm3FGHyr0aLo+faw52l7+/IM7ATUU57J2kcPy?=
 =?us-ascii?Q?Se77Aay29SNmBgzBlE7/o+1pYUDwjdGWSaZOnt4vJNwiKpfm3GApaUzC4AF+?=
 =?us-ascii?Q?LRk8kYWg9bcnOBZE30S6+vpcETfU/drsePkoOrXHJe4bjqby0HIltbkDUwuQ?=
 =?us-ascii?Q?yy5JYjUoaQyNDmutzPwmP7KR+IxdYokGYBbl9N9aAo3AUcopK2vtdZLrOw6B?=
 =?us-ascii?Q?8GukFLCLTMXRYEVC11bKaeu6GrLZaGAX6YeSpBXOeeHaoW0TH8LJ0XYqDG3G?=
 =?us-ascii?Q?9fbfdJLExjRPNxyH2YE7dxQM0DhjTWUO38sZW8bOuQIz/av+kKyvVQNi/Eny?=
 =?us-ascii?Q?B5ozR3vDBLULcQ7PHR/4jtFFjg5FHj+OP+rZfVL4nyAv4X78G+3yymCco4aT?=
 =?us-ascii?Q?eC7d8kLmDadC0+sk0qaK12l5vHQ8EkNsEcUP1Zrnn5cGyhXEa4FgyDGshZd5?=
 =?us-ascii?Q?ZkfCG47Yp2SKnPDPCLAx2PS5+HgQ0jquLRht7Htohntzc3bsC2JJTggHwXYu?=
 =?us-ascii?Q?m5LhzLj4XrRPRwb1XSb858MriNi+IUgIqsh+ds2GGNcx9J0QiMoM+xArGPdJ?=
 =?us-ascii?Q?48DwEZXww0m2nD5FlAK9BcpJpQovHXDk3OO4eTQwGMqBJBDPTnMFXCiCyyE+?=
 =?us-ascii?Q?XMS9PWH+xBZfAkRpUysKghYV521nq55upxNKBdHnL5Bx91WwYOMq4nfEtnP3?=
 =?us-ascii?Q?TJ7eEg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f74518-f04d-4455-ce50-08db09bd66e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:15:28.5780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u03C6g68gNqO1Db6ZoH7XAGOj4ngAbJx75yjUmEAEoljQ1BYO2dbICnJeA011j4AgwQ+p3b+nyM8ZwiGSGGgA1vehhl798kdeJYW24DTp5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5148
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 05:52:06PM -0500, Xin Long wrote:
> Similar to nf_nat_ovs created by Commit ebddb1404900 ("net: move the
> nat function to nf_nat_ovs for ovs and tc"), this patch is to create
> nf_conntrack_ovs to get these functions shared by OVS and TC only.
> 
> There are nf_ct_helper() and nf_ct_add_helper() from nf_conntrak_helper
> in this patch, and will be more in the following patches.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

