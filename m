Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1750A686673
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbjBANNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjBANNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:13:37 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2126.outbound.protection.outlook.com [40.107.220.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F23934302
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:13:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhyIUZuugLaH/pe6qI2fv56fbT12fEAQJlH49ZuidYFjrTIe0LuPEUR546aXClDs4fWTTDXvem9SrUlN8HB7N5w90eKqD2Mc9f8T8KBzafgfQpg2urTadzVDlA7NzXZN/Bg96CUWiv3n3rMJtpL42ypf3eR/OWRnZ/yZK8YDm9+7cwkMEdekJIq8poXJIzuryrPlvD0oIn4fZMKUTofbD+gS2FfsJCdb7mGC//fEw88tXpZuiCcNlsQMIL+mTY7tN7+Y+Ge6O3scXVwq2g77jKfh5wi7ng+M1OWEWeywB0SqX/HmwBJ5PSdHPcps0p3p2gE9iY97wJT6oqT0EsiDRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnxQbeYK0NkrLU1rWH23K4QVI7AhRwMXYMxlFu6YGpU=;
 b=PoiHLgOruIn5iDfA+LVpKNgK0OmuXlj9awbq9SABlFL3D3nCk/0AzBB/C4lTOvVXxcSYwzutsb74O3Gr4iK05cLnM/CpcR3J/ByBSnRVh6pBPPQ8q9lHeCZJqR5WbKxrlf+GXOeHSMOHVNOdwtHRZh4Fa52Hdlr7nFdNNho2njUDqQIZX97qmzO42RUWiuMt6vvfwfJr+OvXvdAeqNKXsHepfCyQdoZooFmsER3lC4KUFuwqe7jU1QTmMLUEDknkyuLxUyBclkBckbo3/sfr2wmrO29b87O4K36ruRvOfNct5zwkiNLQEPFujSWvonF+2hJ/ndRLO/HwAoXWn2TYfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnxQbeYK0NkrLU1rWH23K4QVI7AhRwMXYMxlFu6YGpU=;
 b=HHNI3x4T9/G9kqZ8tlKvm6RzPMFkQX9V9fobet6RI0eaQBzvTu0G2Z09ttDo9O1V62ANE6cU9it6uM50B9z7ZydMHOnzwg1DtBR/wvfiMJUhyUQVzDnlaMqAL5HbqoPUtyAOCeZmj2C+VSBeRPf9Ggb3IDBDotIbYhG85IRt5uM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5448.namprd13.prod.outlook.com (2603:10b6:510:12b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 13:13:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 13:13:12 +0000
Date:   Wed, 1 Feb 2023 14:12:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v5 1/2] net/sched: transition act_pedit to rcu
 and percpu stats
Message-ID: <Y9plT+gHmdwbuRJO@corigine.com>
References: <20230131145149.3776656-1-pctammela@mojatatu.com>
 <20230131145149.3776656-2-pctammela@mojatatu.com>
 <Y9k8seDdoS1LHB7L@corigine.com>
 <f044ce61-37a5-a159-02fb-6ff14f5e911a@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f044ce61-37a5-a159-02fb-6ff14f5e911a@mojatatu.com>
X-ClientProxiedBy: AM0PR10CA0116.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5448:EE_
X-MS-Office365-Filtering-Correlation-Id: cd017c99-958e-4135-9281-08db04561243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4GcylOvXs77gFD+6ZdlfpRVVOwcHKyxw1yboE1cmuNWQyvoYn5dyfRXhe6RGKKlvdeuzLMugurdc7NmfvXAvATCCtkh59J9YPrHe4L4AxlF9Y7jkiELmpJUwU3loWZgO0LEz7PnEza5gb+y27dqe/iogRv3Z2rtTMb5147OM+yZhfiVDpIcik/IHuz2Rr9IQHWbXqDJqKS88jFwarW4pn1+q7Nzwl2Wp+PaKgRFQ3Nf8asigrriKkfSHK2pJVZ8IzyEVHYd/vOw4w7oMEYx3U8vnFB9EsGgpSoqLoQ714iuk+WnodfompeATZp0Sh7H4URPdZTCRK09O7cpE0lAq5P1hsVRnJQjRCILJgPDvoX2Di58LgvULNXwlcVQAVdWw3MzY4pO41lN1IQozv00KG7uaR3ydoo7rcEW3ZAVng/C/GhHCrtms44XEaWgx/Q746hVzkXtdCSvcl/LakIy59vYGvXeyTVX5DrB0t4rBegrrStaRdZszLQLSvcBh27UOWEZoYh5F2tmj+7Zb24LbYlcFYalZAtHjEOIrAlvJ9dxYDeG2/70TmXZ+uaB0tQ8nStYNJmGt0G18SzT5VptZpTZd3mCdXvGVh0LAXmObHW+YUTsc7D4/Cw6lXEpQGxgmFK3eB7oMmnrn7dVimiRqOUOLfCyf+9H4GJvQ/liyiR+gqv379yOqz7OL85dKyySLjE7S/gNNF0BrrzGoKjp3FY0y0r7bUJFALf+x5gV2WvPapTafaoz/XRNaBd75koy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(366004)(346002)(376002)(136003)(451199018)(4326008)(8676002)(6916009)(66556008)(66476007)(8936002)(316002)(66946007)(41300700001)(2906002)(44832011)(5660300002)(38100700002)(6506007)(53546011)(6666004)(83380400001)(36756003)(6512007)(2616005)(186003)(478600001)(6486002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UkhCHDAdsZ8R9/oh4lzA4fihryEMnJS5Sez/aWLXuMXYi3iJRNa6b3twf1yH?=
 =?us-ascii?Q?Uy7v/zyjDPrEnLDtcVn1Pd4/SCcwu/oHmCT3pmCCgguLhVryPt7xuyeRCsaZ?=
 =?us-ascii?Q?LEQ3GX2LTDgy6KyRUPtR7aSHENFZJlmZwEjN4a32o9uQbYh4nDjIK3C/jlDO?=
 =?us-ascii?Q?4bwdeMM2p2T86pRPJfb1S//BAhYSNZAMkdksdUy2tENh/01M5cbpoxS8MqTw?=
 =?us-ascii?Q?XySQ03f9RbHOXYFHeWI7HBev/ypK2gHFt5HdcyC7bKc8tATK/67KzVN0/GQS?=
 =?us-ascii?Q?wuQ0tLFWYY+Fgu/pyOsKEWCMvNYjau+vXTTFmZ8FiX4FITNte33eEMwT3qZf?=
 =?us-ascii?Q?OLvtk4bmR+TdqMl8J5SIQxcTUq9U1cFq4jn6cHsgVswB0wFnozdWr6YnwZOL?=
 =?us-ascii?Q?0wiMG72UKRA+c6uVzu8IwBcoKVyQir+eZbGt4OQgLUeR5MzGbWZtIjzH6Au5?=
 =?us-ascii?Q?2BklRkNzgwp8sxuGEM6zM73rJP4ORtJTvhmTSc6WKz2d4Bx7U7b8dMMAUXrb?=
 =?us-ascii?Q?xtrqGrPC/LxwwX3HzpcHCqUYBM5LHykYyxbGVxGIB0jL5UqX0+Hd97bRSBJe?=
 =?us-ascii?Q?xwInMFd60lBClDYYdL2rRu7n3o++1pAvXjtlXdH+xqUHAHGTF16w/S2TqYD5?=
 =?us-ascii?Q?6MOwRkcfFRTwLS/0lJM4qyUTiyLeWZm18ud8qVojsKJo+k9QqImJUZcei1gT?=
 =?us-ascii?Q?T6459McLHoWyCiuE78+rBClwRZOa2fk38dIkVgpmW6TqG5u55UnqRSOFUhZE?=
 =?us-ascii?Q?AwvvL98wBTLN9HrI4XMW+oGqZKAi8wDQdKSz0HUWJbharwqon7r0r1rSicex?=
 =?us-ascii?Q?mgNKlqauJahLSCdSASRY8ucpVmydppxH9hXqn1Xx2EM4Ga+uUmBRZemTkwxS?=
 =?us-ascii?Q?Kiqih/YTgA/K7QGLTQQq2Dczj1GeBHJAqNqTHMLA+t/bcgT1UtbaAl0KBxo0?=
 =?us-ascii?Q?6nlGmk9g6CjWRyQOUfF47U/t0KnUNKyOmfy14h0s0cvchgSPwX/ECuHBRc10?=
 =?us-ascii?Q?LyuFMUB578lUuUtHa4taL13ajBT7M3BSBFfK3fw+kl5zbaC8ph8994JMPZy0?=
 =?us-ascii?Q?zjqNAej9Ll6xyB+1H87Tm0NKPwpdNIe9jIZ4ODHWtUL+2DeZo1pTEnpIXDzs?=
 =?us-ascii?Q?DbilG4tLSuYK16cR8ysL1y0Eio/4rXoIdiadSAh/r+AsBUo4HjrnrVHSXFWM?=
 =?us-ascii?Q?QOLBI9SCqKJroOfmRGEyKY0FWZLhjqY74XeqYSVpbrW5s0cjSZ/QLB7rZ7ZI?=
 =?us-ascii?Q?0m5YyyIJeldAYB/WsEKP+rEZ1bNp0s6swHnTr3gEoMXWknM5ywZ0Gb2wmjPR?=
 =?us-ascii?Q?B60TsHz5ONO0cguAA2BNE/ClGIvFM3Z8uQtAnpfKcSVbEsOTKHJwypFC1JdV?=
 =?us-ascii?Q?fU9cMV2TCp+1owXdl2bWivt+RQeMquJAwgVrOg7+YUdHoRsc3P786Bbi3tdo?=
 =?us-ascii?Q?Z4P2K02jeMhcNe4mO8Mi6LxulkO/4GDv1njr7jKYb0GnAYb7QMuf/hNNib3y?=
 =?us-ascii?Q?lkJg5LE4OpJRn1v7+Ya9DZJSzQzfUiGxcYZZiZfEgOATu4ucqfnY+P1X1SrY?=
 =?us-ascii?Q?fxUrVxsmoAj2/JG4am8h3rrli947C7RbCJBjeNUqAoo4CCJkYTDNA1DqftQK?=
 =?us-ascii?Q?0+LubmGwX3bv29Xl0N5xW2QSpAjKfC9OJDCFL1AdZ/QN0yIXYnNt+trI9iwJ?=
 =?us-ascii?Q?m3iV5w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd017c99-958e-4135-9281-08db04561243
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 13:13:12.5673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMxvnMjNTlHOfJozWbe6YEINaac51QBfKx0p2qqsNBwuaNvs67siezJpAF6zJJucvKtkvIvh0GinHUcf8LNuPmpj7YsWiqkE751JSCTnlio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5448
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 04:05:48PM -0300, Pedro Tammela wrote:
> On 31/01/2023 13:07, Simon Horman wrote:
> > On Tue, Jan 31, 2023 at 11:51:48AM -0300, Pedro Tammela wrote:
> > > The software pedit action didn't get the same love as some of the
> > > other actions and it's still using spinlocks and shared stats in the
> > > datapath.
> > > Transition the action to rcu and percpu stats as this improves the
> > > action's performance dramatically on multiple cpu deployments.
> > > 
> > > Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > 
> > ...
> > 
> > > diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> > > index a0378e9f0121..674b534be46e 100644
> > > --- a/net/sched/act_pedit.c
> > > +++ b/net/sched/act_pedit.c
> > 
> > ...
> > 
> > > @@ -143,8 +154,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
> > >   	bool bind = flags & TCA_ACT_FLAGS_BIND;
> > >   	struct nlattr *tb[TCA_PEDIT_MAX + 1];
> > >   	struct tcf_chain *goto_ch = NULL;
> > > -	struct tc_pedit_key *keys = NULL;
> > > -	struct tcf_pedit_key_ex *keys_ex;
> > > +	struct tcf_pedit_parms *oparms, *nparms;
> > 
> > nit: reverse xmas tree
> > 
> > >   	struct tc_pedit *parm;
> > >   	struct nlattr *pattr;
> > >   	struct tcf_pedit *p;
> > 
> > ...
> > 
> > > @@ -212,48 +228,51 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
> > >   		ret = err;
> > >   		goto out_release;
> > >   	}
> > > -	p = to_pedit(*a);
> > > -	spin_lock_bh(&p->tcf_lock);
> > > -	if (ret == ACT_P_CREATED ||
> > > -	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
> > > -		keys = kmalloc(ksize, GFP_ATOMIC);
> > > -		if (!keys) {
> > > -			spin_unlock_bh(&p->tcf_lock);
> > > -			ret = -ENOMEM;
> > > -			goto put_chain;
> > > -		}
> > > -		kfree(p->tcfp_keys);
> > > -		p->tcfp_keys = keys;
> > > -		p->tcfp_nkeys = parm->nkeys;
> > > +	nparms->tcfp_off_max_hint = 0;
> > > +	nparms->tcfp_flags = parm->flags;
> > > +	nparms->tcfp_nkeys = parm->nkeys;
> > > +
> > > +	nparms->tcfp_keys = kmalloc(ksize, GFP_KERNEL);
> > 
> > Can ksize be zero?
> > 
> > ...
> 
> Hi Simon,
> 
> Thanks for your thorough review.
> From the parsing code on lines 183-188:
>           parm = nla_data(pattr);
>           if (!parm->nkeys) {
>                   NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be
> passed");
>                   return -EINVAL;
>           }
>           ksize = parm->nkeys * sizeof(struct tc_pedit_key);
> 
> So it seems ksize can't be zero.

Yes, that is pretty obvious.
Sorry for missing it.

> Let me know if you think there are other edge cases, perhaps we can add more
> tests to tdc.
