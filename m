Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D206EA6FC
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjDUJbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbjDUJbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:31:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2094.outbound.protection.outlook.com [40.107.100.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A522F1BCE
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:31:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kArhP5OYcSp7IJucKyRdPna5n6+gAYkMsQGtLZQpX+4pQLIdEKcN8RQT1LbN/A4SImIjAkMpiIkU18//Z5PAITozB86+89zFdHuVI9bAKCxfuFPB5rq4CzyRt1yRYatyA1XZQHfpwW1hGAuW27XywJe0P7Hgu68xTxIsfq7A07mCfbIAUXTzJqIoyL0HpE0ZUK4LLmlIzEq1A3K/7OPVoO0nJ2VxHK+Iz3Y/U1hLlI8VyS7nmAYOTbU7OeWqMcsV6Za5c8Lkm9OY8yXqiDPQq4fFxuKQdxCDQ/ledQ0tS/9KNjzYfAU6LOIMtxpkBXtT3z1CJKprYdj0NGjDeQ439Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwpem5+HT5xa9TGxWiW5JL+8ZOcqStR7ooaMYc0gKLw=;
 b=THRzjP2C3SQ936PWTkiKl2CM4B2dgi0VjybIIWEmzo5UHJwqswV+U5BlrSsEIZSqnmeFVTscJEKf71yZ1/cKq0aEiekoH7aj0yanSqH1rkx0l0GINe7pcJAYQ/hIXAj7cZU6jXy32/ggoxwnSC/e8fBcNnaUK52W5ehiAgsxpyNv5OpTplaNr2fRv+El7v/30h2X0J2w8hBYy3a3w28lauCaF0A6fOoojZSUThAVTLHtaku6Bzp5uSN7MnVZHSIlwoHJUZmjJvk5byNeJMc4if246cBaoPuuWMSh0iq5+qbMbJkeZ+7YWZjQJK4VOndcF2j+ZrAIxqEIJ0qE8w/SGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwpem5+HT5xa9TGxWiW5JL+8ZOcqStR7ooaMYc0gKLw=;
 b=jLMhgHUB5TPDvvSB2hfivqT3QysBtWg6rU+uwui9TtN2gRhuvh6Aft/h2svTyazvNxjm9HOnLk9N5kjyHOCjyaQE45vWJ3YRjTlASOni64EfDDAgJGznWS/1cClOuOL/HvUey+oW6R073xW09q+uiqRzEkWIStKgfy2bOj/7J6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6040.namprd13.prod.outlook.com (2603:10b6:a03:3e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 09:30:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 09:30:59 +0000
Date:   Fri, 21 Apr 2023 11:30:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v3 5/5] net/sched: sch_qfq: BITify two bound
 definitions
Message-ID: <ZEJXzN5FtXMUioFF@corigine.com>
References: <20230420164928.237235-1-pctammela@mojatatu.com>
 <20230420164928.237235-6-pctammela@mojatatu.com>
 <CANn89iJsn1Xj8Y4tL69FA5a0y21R4-qBjMddH5rGOBD_iQ0qmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iJsn1Xj8Y4tL69FA5a0y21R4-qBjMddH5rGOBD_iQ0qmw@mail.gmail.com>
X-ClientProxiedBy: AS4P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: 092580ef-f918-43f9-d38b-08db424b1d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sniRQXr5gc+YDBuvBZmT8C+Q4fBxrLBys2Qzj6LegBkrjGVvLJnz5iG/E8v2wbJS/ugpTroO1HCojFT20GuZEtuiLXP5xwRM8M+kBFjCrwqnVrKfQYYaDuLNynY8r+ey64JwhUvHv0H6S8XOJV+2AW4J/7Xdiauc3UzVOtDjZgYoGe58p4m7SgTcuiZ0kUslKAJ5jEJJAz7UXxcyZbezGRJQXm47uOyuGDcq/d9i1w28xT45Rq/ZP1i5FPXZdCI0YKWDVD73D7J2VQdJjeYHOByxzZ5/Cu1C5EJEiZgFzzc+2JZ4ClDTGM5//1U2vWzpPkonIdX7EgIkqZNjyD8qRLBK313IWm8iQdbK5d7+fCF8GbeR3SalMVexeqNcsBYgyRfXT9XwpCmXFVEsqy0o1Hw2iZmnE2V0MTrKQrm2y8NHLTtSwkzz9e8mkDAD98Zaejd5I9RKjAvQqZU54t6U7S44yNZo6C/l2usYspJJTdcHEtzvGmLqs6Ii/eGwSTOESkk5bPhYvDAAlFjyb6kFzHVl+iUZJMSJOnEQ4Tz2SH0jppXj90uMPPHVJ1b9rjHR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(136003)(39840400004)(346002)(451199021)(2616005)(316002)(66946007)(6916009)(4326008)(66476007)(66556008)(83380400001)(6486002)(478600001)(41300700001)(8936002)(8676002)(38100700002)(6666004)(2906002)(44832011)(5660300002)(53546011)(6512007)(6506007)(186003)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3NoN0k0NXZ5WFlRRU5EaS9iUVZNZFNjMkMwV0ZScisxQmlXMWs1bmh6SkVh?=
 =?utf-8?B?S3QxRFNhNERQWndqaXFSejNiRFV0N25iNkw4dWR3RkV1UFI2eG9OVjdrTysv?=
 =?utf-8?B?Tjc3RHhHcXJJd1BpNTZkR3JRaFdPSUt2ZE5KbW00cWlWTldyc252eUxxaTFv?=
 =?utf-8?B?R3BaT2krSTVjQW90dkVRYU9yUGVvOWZBQkRJTjh0Nk1QOTc0VEFsQTRUMzAz?=
 =?utf-8?B?cGljVkw0dXdkY1lYS3EwM3dqTER4NVFWNmRqWkVvZ3hyOURRa3RwaCtLZTZ3?=
 =?utf-8?B?QzBabmdYd041d2ltSjNBem8wVFVGWVgzdG83Qm43MENGSWVXYUZxUkRSUDBj?=
 =?utf-8?B?MTY2bDNFajBiVnlsc1VxY0VncDRHL3owZEs1dk4wbHRsclhuM2FCZDU2eUh3?=
 =?utf-8?B?TWdLOFpSVitPdlRrb0VGNkdCemIvVlc3cE1nS2F0NjMrMnpqUmg2U1hoVGs3?=
 =?utf-8?B?ZHdmSkJheWw3NU5uSDNnZ3RrV2k4V0lPZ2FXY1ZTai9WNzRYTEI4dVZSaVNq?=
 =?utf-8?B?OXgxakJqWEx6bGZpcG9OYTdtN2N1MWd3TUx0KzdFNFgxaHdQWS9jUElXamRy?=
 =?utf-8?B?ZjI2dTllb3JkLys3RE5BZU5vZVpkRXBrWEJNeTA2Y3dMQW5jZmJkcENPTlNM?=
 =?utf-8?B?d2lDVHhqdjNUVzkvTGM0WFZWYWZZR1M1NUpxK1BOVzd2VVJMK2xmb1V3YlN5?=
 =?utf-8?B?QTBDd1NrNnkvcUMxY2Q5RXNiYkQ2Sk5FcW5FZ3hSR09SYmF1d3pTNjhseWxQ?=
 =?utf-8?B?bk5DNExOR2QvQml2dytsVEpyS0hITFE5a3pJVXhwLzJhbTdPN1dVTUVSTWdN?=
 =?utf-8?B?RW93dEJVdVp0NDVMcWo0Ui9Sa01xSWM5bGhmMXkydHRBL3RkN3J4UXc2cnNC?=
 =?utf-8?B?Qnlxa3RIdVNlenhQcVFhZnRISzNyMWIxcEJXRGMzQ2lUeDhESVBQZ1l2TGcz?=
 =?utf-8?B?V1NObU54SHU3WDgyQzdrWU05MjA3UDIyMXVvREgyTkpBWStTbGJyNWxYdFpv?=
 =?utf-8?B?UllqbWlRYlBMOEVpdmZ1Vlk5MSt5YWtNSHJiUVd5ZDBIMmYvZ21kUGNCSHNW?=
 =?utf-8?B?Y2pITTV1NlZVb2I3VEtmcVF5NDVUcFNTZHJmVW5ONzArSTFNYU9SNEpwVStq?=
 =?utf-8?B?VEI0THRmVjBjVzV0K3BQV3ZUV2VONTNKN0hFOGFFVVR1VFhuT2pYWmljaWhU?=
 =?utf-8?B?akN5U09WY3ptSndad2RzcTM1ait3Y0VwQ0VJUUFsR294YjgvQjliNEZEU2tt?=
 =?utf-8?B?SzJHdldiSE14RGE3UHAvUWx2SVpzZUJuM3Z6WXdMMjFXUU5KY29zVHJCbmh4?=
 =?utf-8?B?bW1ZdVpoN0RobDVISG52OXUzOW4vYlVXV3pZU3VlemlmUmx2M0d5bkY5VG1l?=
 =?utf-8?B?UEphYmZMWDd3WXVIK1NFRm5oT3YxUlBEclY1ejJpMGVsN2xWd05vUkd1OFdU?=
 =?utf-8?B?aDRpMURFUlJLVDRXN3ZpTTdSY05mVGNWVUZtUUxUQ0l3SDJoN3BPKzRaU0dR?=
 =?utf-8?B?czZ3SWZKRTFIM0FQK3RMUkppWTJVcEhSZGJYN2luaHZxMzZFSVFlenVYUUVn?=
 =?utf-8?B?YytUWENtRTRVeWZNVk5udVdLMm5XWkJ3NkpRQklZdE82cDc4VzFZOVZONGJz?=
 =?utf-8?B?d1dlUkpOMzU1Z3h1V0RycU1oZWlKWE9KK2JCNjZRbVBNMlhIc3M1RUcxNUVs?=
 =?utf-8?B?Z2RGN09CM1I0TjRBSWhxS1ZNRnB1SkNnYzdsL3RDVWJ2UXp5Vm5kWmxHb3lF?=
 =?utf-8?B?dVk5d25rOFhTL2l3NVczaThpTGJaZytuNEZ2dlZlYjRhRVl6Z21IVUNKSW1J?=
 =?utf-8?B?eXN5WTlqOUhqak5tMlZHOWh5NWc5V1J1L2F3ZkhUam91d3dsd3l4ckxzNFB5?=
 =?utf-8?B?L1FDeVVUanlRMXh2TWM2b1Q1UDFrMjR0TVNqbHNxMEJvYnFQWWV5U1FoNlI1?=
 =?utf-8?B?dktKdkRUb0MrSFBMME5zMmozcVdKRkwrM2NQWDZWY3dyU0FiQkIzeUtmN3pJ?=
 =?utf-8?B?VEMxSFQ1K3VFYkR3a05IYTQ2SUZmb1dhMld4d29iellwUXZuM1JpbmhYS1pV?=
 =?utf-8?B?Mi9TZDFuamtTVFNPSXZNOUxNcDREd3UraHpQNEZSMWNtLzlUOGZCTmQ1ckc3?=
 =?utf-8?B?ZlpoNFRHeHp5M3k3ME5LK0NGQ0tJMjVXajV3Wm0rbkY2Wllyb2xaL0t3TWN4?=
 =?utf-8?B?d0ZRN2xsdGtwRFBHZ0E3bmhOTFg3QkpvcnE1QlJSQm1VZTdKMFowV3dydGND?=
 =?utf-8?B?YlkwaTBheFBNMlhaUWlnbW5xcjdnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 092580ef-f918-43f9-d38b-08db424b1d8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:30:59.0798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXRhBS7jrLcDaM+zQyqhjvct2Z+UMx9XM/HF6Fu5oni6669+f5QGjed/inLNFTpKsTkUhYD246egxBYHt+/xXn0cQ8urag9e61K2gcR5kUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6040
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 11:17:23AM +0200, Eric Dumazet wrote:
> On Thu, Apr 20, 2023 at 6:50 PM Pedro Tammela <pctammela@mojatatu.com> wrote:
> >
> > For the sake of readability, change these two definitions to BIT()
> > macros.
> >
> > Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > ---
> >  net/sched/sch_qfq.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
> > index dfd9a99e6257..4b9cc8a46e2a 100644
> > --- a/net/sched/sch_qfq.c
> > +++ b/net/sched/sch_qfq.c
> > @@ -105,7 +105,7 @@
> >  #define QFQ_MAX_INDEX          24
> >  #define QFQ_MAX_WSHIFT         10
> >
> > -#define        QFQ_MAX_WEIGHT          (1<<QFQ_MAX_WSHIFT) /* see qfq_slot_insert */
> > +#define        QFQ_MAX_WEIGHT          BIT(QFQ_MAX_WSHIFT) /* see qfq_slot_insert */
> 
> I am not sure I find BIT(X) more readable in this context.
> 
> Say MAX_WEIGHT was 0xF000, should we then use
> 
> #define MAX_WEIGHT (BIT(15) | BIT(14) |BIT(13) | BIT(12))

Thanks Eric,

I think this is my mistake for suggesting this change.
I agree BIT() is not so good here after all.
