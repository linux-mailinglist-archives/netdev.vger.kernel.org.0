Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40C46F476E
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbjEBPif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbjEBPie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:38:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2123.outbound.protection.outlook.com [40.107.93.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC0D1A6;
        Tue,  2 May 2023 08:38:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMcRYybqqOnKbHVyYoySYvCcHrGmlI89uNZM4hYCgYC/uGTBKBWv80SbZqFeNPOLQIHKrgpvetdYzCBTmfmavbeLKhYxz5qk1xhYOVQMRABOJbjpIhWNuOp1DTex6VAAcilD58ycAPJGJ9KoYlQOXiIvsVtfgGhx/Fqj/JGE9z2xaMZzKAm90yEO52AF6ZgoG7t05Z8IWD90PW6jvnoh0dffMAc/FeNm3zkb5u9r1QUmF8HtgZ92L7f1cs32ogj60FSJMP5vtY1c5IpYqEibYEr6Pg2WjHl9IGgYxUWaDRnAWgay+jZAdj7PUKkqQnfbP5JFgCFli9Ndg1RXDZCQbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcfgxxaEKPw05EfrHW4PemwrZ7zNA79ocKiFWHdlJ6s=;
 b=NWn4RTztPsP5jn5TxP1h8ZWCy58GPhsxGiW4jkx16pM1JSNmFQCKUkgnMFkjdgOPC+f82hem6FQH4aGmZibYl8MKhZscDuPsaG9aKQ6WjjaD4T1/bLrRuhktspcfAnLeItGo/mnipXsA+Rxg3DPQrWbK1P1SkbjUoSwTn6pyr+pJ5o3XaVptUgD5GvCJ0XkRZMtbyMF3FjZ/JC5x1QNfJJn304/h3FSiZd+tMk+4K97lSwdFOwS1y/j5ZOxt8QhCf0ZU3hPsJ4KaLPrlWOP8JeqNXrAertUP5jofXaYs8bPtBagKS06IQXy1ElFg4FSVi3Rv2DTSyBljZCVpZ9Y0Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcfgxxaEKPw05EfrHW4PemwrZ7zNA79ocKiFWHdlJ6s=;
 b=pmNnyAbMmxvFUiCXVAZysUAk58Pir67bXKTUQEvCs72q3WIezU1mGBHIJ/eYqz1kFFkhukZiX5sTfSz4bFzZfIyG2y+XKT7b1qYhcZ9P3j9MsCW9+kD5TtTGyp8FEx28HlF9uD66MSGRmzYR8WzBeqBIB9Gxxh2xp2bJ/DpXKzo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6026.namprd13.prod.outlook.com (2603:10b6:a03:3dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 15:38:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 15:38:26 +0000
Date:   Tue, 2 May 2023 17:38:19 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Message-ID: <ZFEuazEvNWHfEH93@corigine.com>
References: <20230426150414.2768070-1-Ilia.Gavrilov@infotecs.ru>
 <ZEwdd7Xj4fQtCXoe@corigine.com>
 <d0a92686-acc4-4fd8-0505-60a8394d05d8@infotecs.ru>
 <ZFEYpNsp/hBEJAGU@corigine.com>
 <f9d9ac80-704a-91d7-b120-449b921e8bb0@infotecs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9d9ac80-704a-91d7-b120-449b921e8bb0@infotecs.ru>
X-ClientProxiedBy: AM0PR03CA0055.eurprd03.prod.outlook.com (2603:10a6:208::32)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6026:EE_
X-MS-Office365-Filtering-Correlation-Id: b1d6de8d-6e4e-4bb1-6589-08db4b234599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YqTOxyUcxCpU4km2FWS/2Vt8rFsWUVF7bHpR0rj+tyZNtwlBHuTCsIpUaml2w9BogEbtUfsk5KDNJqlOazTgTt9lADG2sH1IpcB6qdxQ8h9FJPILTM+wcQILP2Ybr6cfNHElRQcufe5vL9en11BCVJ0yuoR1fm0Al9CzHaHCA2JLjKcrUKrR69Nfu7iy9lhIa2netK8ygAfkq+0u7gujUplbMebb3G5oomulv/Gn5a2yjVkyqUk24pIlTmtru9EsJB2Zkt37uW6OWbZkeQ6017ZhuJM9ZzXEXUp3ZAlrMBke2z2ic0II5V3uxM5lOm/uKp3Dv2rYZYqR+3gJOBadRalokZkE8Cnh36k+GxmC720B9GTIVqCiXGFiXGPAMpn+GkjWJ6oiuh6W4W0l4lA0E37Ql8MBEKLYM3OPcJd0ptVm5eoKEUKVZ8+Jei3RMCe5jP+YgAuPHN+f/gSl0WH/LfrsjT+dUkimn5bb/BQdehOu8nk/zRrbR0wKjftZbhtNKfIOPn+q4dXkJsUS0R3vD8+5sKxV78pb6KT+ed8pq/lPLdnI/1GxLB3C+ymG5cwJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(39830400003)(366004)(451199021)(316002)(53546011)(6506007)(6512007)(41300700001)(83380400001)(66476007)(2616005)(186003)(66556008)(66946007)(4326008)(38100700002)(6486002)(6666004)(6916009)(54906003)(36756003)(2906002)(86362001)(7416002)(5660300002)(8936002)(44832011)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yB0N//JYt890UZHKYmsT+r82b2z+DqJRaHP8EH59OAQtCs6zRBaMUQWZAQIs?=
 =?us-ascii?Q?Fex+cfAMtoTftcUK1k1nVy8CDGBqJjA0xcEsGs1czUWNQnFIXKPcMv50L08n?=
 =?us-ascii?Q?10k1iOOalDHbNNdwGNSwdPu/NnNrXa468V1ps+A8X4zNSIfc+PWZvwDpwHxb?=
 =?us-ascii?Q?h6vcYXBbhJ0HS3L49rttftlXIIEd5mOxdePVSGY/wJID0/jczcSQV5ZU2SXz?=
 =?us-ascii?Q?3V3an5E5I8F/3avh+we/mr+cBENxk9pcldac9UbIgC6z9xvReIZ5ifuHNZs+?=
 =?us-ascii?Q?J2xIg2IOZTY84w0RbPS9RNEjBpS83KIGFAh4AOZyXFiQ+JpyEYpvf9PLrj5N?=
 =?us-ascii?Q?qW7iETmngm4AJCCchzMZKCkc2SE8LJ+yK3mEiC20Vp9OjGu+O9KnH4uU4GXa?=
 =?us-ascii?Q?OjMYRu28/vxPUMty+TQN1etsQe6eR8elc1hhchOinWVHXpXrmSJrhBmHeZnK?=
 =?us-ascii?Q?umFA6sJvW9Hv54a18zhuzJJM1zf5yd1/ZJyFx9Yb5U4q7fULP62BBVR8hd9Q?=
 =?us-ascii?Q?GsMJxl9dYUHFaonSnyWLU3Roudr0p/VU4VpBiA5h3seFAtlPcB+yq9J90Tzk?=
 =?us-ascii?Q?5In55GJ1+JhZ3nTdXEHl4gVqiuKyECSwBnt2ktPokkIg7ZWoD8sWgYQ/Oll1?=
 =?us-ascii?Q?g8j1RSREqpvRv39Ufhw5sozr3DPVtaYbBmm4S/4xDsBF/h1fl1IdFiN4J7Dm?=
 =?us-ascii?Q?7E6LnLNytHAsQ68QnzbzW4+wP1THIgkfF9JIp0ZOAe/c7+78T/9R1/bjgvXB?=
 =?us-ascii?Q?nZ7wD1Tm9lSYjbTx5VecISa74MdIFJxbPWqi3GQlXzo84xpRteW26OpfnueV?=
 =?us-ascii?Q?o8gIkQldKw2S+cZPlUpUP2NZA3o36PkV+xGBhmHHK3uU8q6CHbQyj3dB8ve/?=
 =?us-ascii?Q?SrqhUWMMv/Kkn6ForTfNoxUef4mpUIhZaY9R51ZYOmkUNeiVZCwmLceUOIg2?=
 =?us-ascii?Q?P2wfOVy2MwkPk2nhhK8yHscl59NjZudeONN2jitu1MTyUyVkZL9/CZn/l26m?=
 =?us-ascii?Q?MPn1E5Rju4FW9Fo/yCJWKO/7pmqMzz/lSUuhxoBLsEQ7AUMoJp6xviyeE459?=
 =?us-ascii?Q?MroadxYkqvEpsnTA3Nsmqno0frIoAQhFhDcxL1KF+888T3EVavV/ESzCIkLk?=
 =?us-ascii?Q?rOqqDL3AQTnwe8Riq6mqFSJFhcp7SXSn7GyU6irvBdKEFUja+5LgNozeM1Jr?=
 =?us-ascii?Q?lMxRJXR4MjB/RChf4x9FgfoZrt+W5zwPOE+V2LjdSBm7XP2mSE01PHTBmaJP?=
 =?us-ascii?Q?PhglRZ8Oh+SyKmGY9m1v5rVmC2ddeTqlskOhSLetSD8VTCxIclZNgfAOFhUf?=
 =?us-ascii?Q?DEW7ZInOiGVOhlkTlRViB1TNqL59fp540aB0Sk/4kqH2ik/Upd22BBHYpRdj?=
 =?us-ascii?Q?aaRPWcBefIyNyc94OHHdlWutEA5b+DpwLlvcMIb6IGXaIhQvEq5QZAsc0BKP?=
 =?us-ascii?Q?zSI1VdTfUb+WMlSrD1jdDfPigQfIElbFFu3duBsleB8ip0O7++x/f/F26B+K?=
 =?us-ascii?Q?KB4tK8TIJotpyrHAd0GHHG7ZZn1N91dwoQ7MpHq7vYVP6T2/DgsvKwZKYuP/?=
 =?us-ascii?Q?ZiWhyi8lm8MrnT8ytf/UGqw59u0+x2ZJsfIcnCW+O6QOx/mWpgj9IDfCmIY2?=
 =?us-ascii?Q?4jkdcOVSigEJLrzx1PgMx5zcF3q1RWhxxibfOJkAPcxFtAchAT8jmUE75g2x?=
 =?us-ascii?Q?g1nOww=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d6de8d-6e4e-4bb1-6589-08db4b234599
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 15:38:26.8382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7QrgtfTbgmVR1gj6vCBJKM6N9VDdq1dGUtFlcU0rv3+QzigtjOlcRoLHF8eu28ZP6NexF+YnrTOOvIhkgbiy6fwQ0XQ7Aavplia+3k7JlFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6026
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 02:16:09PM +0000, Gavrilov Ilia wrote:
> On 5/2/23 17:05, Simon Horman wrote:
> > On Tue, May 02, 2023 at 11:43:19AM +0000, Gavrilov Ilia wrote:
> >> On 4/28/23 22:24, Simon Horman wrote:
> >>> On Wed, Apr 26, 2023 at 03:04:31PM +0000, Gavrilov Ilia wrote:
> >>>> ct_sip_parse_numerical_param() returns only 0 or 1 now.
> >>>> But process_register_request() and process_register_response() imply
> >>>> checking for a negative value if parsing of a numerical header parameter
> >>>> failed. Let's fix it.
> >>>>
> >>>> Found by InfoTeCS on behalf of Linux Verification Center
> >>>> (linuxtesting.org) with SVACE.
> >>>>
> >>>> Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
> >>>> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> >>>
> >>> Hi Gavrilov,
> >>>
> >>
> >> Hi Simon, thank you for your answer.
> >>
> >>> although it is a slightly unusual convention for kernel code,
> >>> I believe the intention is that this function returns 0 when
> >>> it fails (to parse) and 1 on success. So I think that part is fine.
> >>>
> >>> What seems a bit broken is the way that callers use the return value.
> >>>
> >>> 1. The call in process_register_response() looks like this:
> >>>
> >>> 	ret = ct_sip_parse_numerical_param(...)
> >>> 	if (ret < 0) {
> >>> 		nf_ct_helper_log(skb, ct, "cannot parse expires");
> >>> 		return NF_DROP;
> >>> 	}
> >>>
> >>>       But ret can only be 0 or 1, so the error handling is never inoked,
> >>>       and a failure to parse is ignored. I guess failure doesn't occur in
> >>>       practice.
> >>>
> >>>       I suspect this should be:
> >>>
> >>> 	ret = ct_sip_parse_numerical_param(...)
> >>> 	if (!ret) {
> >>> 		nf_ct_helper_log(skb, ct, "cannot parse expires");
> >>> 		return NF_DROP;
> >>> 	}
> >>>
> >>
> >> ct_sip_parse_numerical_param() returns 0 in to cases 1) when the
> >> parameter 'expires=' isn't found in the header or 2) it's incorrectly set.
> >> In the first case, the return value should be ignored, since this is a
> >> normal situation
> >> In the second case, it's better to write to the log and return NF_DROP,
> >> or ignore it too, then checking the return value can be removed as
> >> unnecessary.
> > 
> > Sorry, I think I misunderstood the intention of your patch earlier.
> > 
> > Do I (now) understand correctly that you are proposing a tristate?
> > 
> > a) return 1 if value is found; *val is set
> > b) return 0 if value is not found; *val is unchanged
> > c) return -1 on error; *val is undefined
> 
> Yes, it seems to me that this was originally intended.

Thanks. With my new found understanding, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

