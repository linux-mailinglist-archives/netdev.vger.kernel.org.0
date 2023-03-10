Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20C06B3E74
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjCJLyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjCJLyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:54:11 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2122.outbound.protection.outlook.com [40.107.92.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1774CDB4BF;
        Fri, 10 Mar 2023 03:54:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luWBdQvFxQoTnMrc5fdqMqVRS8jjVXJfTtWBae+JEDfxzjHGkZDMiyw+pqX640VpR+J6/pSfMaJ0bS0rWhtBU9pdDKCkFpyGjMYoP3qYpLadyVAz3lJl6ZC5O3fCJsuJV3FOJQKJxCFt7NK8HQwCdjkp7moRr8dMQIJzQDS7mqKTCNWyqIf6/WrDkmpyW+uZWArPNIaBrwtvNcL+HRH4aXZFbTIbz3Nr5ziukTpUTPcKDGVyZOuw4GtYwmSfxDxEzaOSTkZrJAw767r8z1VToIomb9hice8iLF5MI7Td3qSL7LPaf/i04ODlkOBQRQ/hsE5XS6pjCntgMBQKs+TfSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ulYZymyTD7DT+N3d+Q7IJzjzJFqmBth3wat8dDpi0k=;
 b=jWDFPhUM1/61yMUPLBnuzfeoibXR7YG0FYhlC3vvF4QQH+gVpdhRC/uvmDOPR+72BW1ewlfpCqmsAHWc9U1/gSx/M+Ly8GkxWswYvaVXUZKdj6tNvptnQ1+XSk3cCMm7qsXLAL8GLe1GE2GXWcsZZGkxZgLrjTPEtPS+9A+5QAwhEXUqjRj67fuIxM5wIMsmdgUmHTcecrEGhv6rlt15GbjV/mazNMFSSprvDNfpe7YO3uQq4Hhd0bT2hRf+emecMExG90kHp3GxeaqDdFVYn/g/7F6+MAluElAIvZvIwniRPJ2BcCjRaVYbSD5aqcTXBEi6xJmV8wW+eprRMQHtjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ulYZymyTD7DT+N3d+Q7IJzjzJFqmBth3wat8dDpi0k=;
 b=UEz6KcqovBaMFEh+6dM1SG4TYKt+S3ALNCn3WzGXbZdEKhsJsVgDB++n6KxpAivgaVZq9ogVsv8XeuLVq4KY5Z7xBpAi6Fx8uUvYA3mj419XaYecICzEg/e20+bIoTw8k33KVIKSRox0eb7WUrMfj7XiWqqLuI02FQ7FKaVkmQQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4606.namprd13.prod.outlook.com (2603:10b6:5:3a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 11:54:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 11:53:59 +0000
Date:   Fri, 10 Mar 2023 12:53:46 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Gavin Li <gavinl@nvidia.com>, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v6 4/5] ip_tunnel: Preserve pointer const in
 ip_tunnel_info_opts
Message-ID: <ZAsaSnbnR8aDdEBc@corigine.com>
References: <20230309134718.306570-1-gavinl@nvidia.com>
 <20230309134718.306570-5-gavinl@nvidia.com>
 <CANn89i+k3fcSw58owpr70eM_uSM5QUqEb_4y5wpXOKEz30+vvg@mail.gmail.com>
 <CANn89iKcDNZBerR_2nEp_ryM3BVXuvr64s6tnAvizCwr=SuACg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iKcDNZBerR_2nEp_ryM3BVXuvr64s6tnAvizCwr=SuACg@mail.gmail.com>
X-ClientProxiedBy: AM3PR05CA0138.eurprd05.prod.outlook.com
 (2603:10a6:207:3::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4606:EE_
X-MS-Office365-Filtering-Correlation-Id: d3066794-e768-46ed-263a-08db215e2264
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwoKsR+oFnRkakSg7Lz05DG/w+blvTc3rvgh2TFaWPjMI94NAT7man7UgsCBljGFk6PZ4MCPugIX20iBLZNf5XkIhEk1ccRBKkkMSadcZuYDwlrrF86arkjkbnik6jOmy1S069DJ45sjhy9LgprGGoF2eAzSniBNp3fHUjNWhoIaNUdTTB2vn2P+UvOdjBXWW0qkIKsVEK1TvjF/nRNKNrVgydfnS051fHW7VEFc4911lG0U+vjY4BdBsvgCfWc1u6XgBYvujL04ZIl6OD4K5V+accI1fRBO0XBE6Jct5NT9yP5nIuKVtTXgeOqIIiekT0KfuL7Z9ValxgtfL5jhi7oR9MNyMOUqAYv18tSlNNiA5cPZ2lYCOwUfa1ESCi6X8GvM0WVSWUGdSBMhdP09kh4q1n3uPYBmG6HtIV822Kg/LUAI8BZRCUvPujLyrv8flqcy9LmimXPZTTQ4WESKRYTf6VMSbNW3OycVBgIAu0l+Z5lQg+UKFuqiwmS/IFSl1kIiSvTejP4fDIbDq+bMPYLQTHuNbY5q9Rx2YT86AIm37w0CE+ouEX7vZITvq9NsnyM7TjuGFAO5oAMoxSG8gBuAGqKX1gkZeIYHQgNDZwvy/9XFnVsOT6UFCsnv04Oy7Pbk3PMAKaAztXL/SPIvVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(136003)(376002)(396003)(366004)(451199018)(36756003)(86362001)(38100700002)(6512007)(6506007)(53546011)(83380400001)(186003)(6666004)(2616005)(316002)(5660300002)(478600001)(44832011)(7416002)(6486002)(6916009)(4326008)(66476007)(8936002)(2906002)(66556008)(8676002)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzU0bnJFcTRGc2UzZEFFN29NRG03MlRlRjAwNGdhRDB5ZmRVbUFZTk96TFFa?=
 =?utf-8?B?a0dUSE81UXFxUjV4MDJmYnVNdy9PV3oxL1pHT0ZXc2V3bDNLcmQvazBjd3l3?=
 =?utf-8?B?V1I2eENWcHIySloxRXFYUnZKWUFJYnhYOGR6N0ZDT2ZkUGhzYm1YWE5LOVBN?=
 =?utf-8?B?N2hmZnpLUWNYN2lQUXQ3c0UvUDJNNnVySTlxb1BKMmJ6eFFOak1icUp6dFEx?=
 =?utf-8?B?cVYxMWUwdkY2MUdpSy9VaDRsVjY3Zk1uNVl2SDZlZXpxVjdRUVBsdVBNWDEy?=
 =?utf-8?B?ODNjVENtWmg4UFdOZTNMSks4S2pRdGxqN3h0aytPRUhWUGxJUlZSZU93UExn?=
 =?utf-8?B?Y0crcy9MajJCb0xZR3pqa2ZMVUgweWdkZXlNeGFxaFBNVlR5NDZIc04rRGdo?=
 =?utf-8?B?UW5XSUphRFg2aC9TQzNBUlNqZ28xbjc1TklFbDhjRHlqZTFFcEJxWGRPQkxx?=
 =?utf-8?B?SU5vZ0xuZjVlUE1BSmRna2NSNXdxUVZYUndlMngyZ0Foa2dLM1RaQkk0RzRh?=
 =?utf-8?B?Zm1GQzhyUmV5enZOSVQ1QjNpVzQyWjh5TUJ5YnhqQVhtdDNaVHRLbUVKSWdO?=
 =?utf-8?B?U3h5bGxxVEg2ZCt6TlZqSVNqcUtCeUEzUWxyOTdWcWlQdk1GYXQxb0k4eW1h?=
 =?utf-8?B?Wlp4QUl0WmszS1hiZFN1Ym4rZ1RYanVIMmp2MmZHdVhndGt1ODRmbFAxdUJw?=
 =?utf-8?B?Tzc4L0Z3cGRzVVc3RU14bGdHcjUwTGlIdUZPU3EreU5CN09mT0MzV2tZam5q?=
 =?utf-8?B?bEdoV3E0ckVDR3dmY1JEZFE4L0M2Wk8zcFJBVTA3bVFkR0o2cVdPSUFtY2Rt?=
 =?utf-8?B?b1pTNjN2MFNSV3A2VmRaZndsM1ZtVlJjZGlmaHZXZXRkeXprR2xTR0lEMW1K?=
 =?utf-8?B?Sk0vOEJmL2pkaG96eFd2bFplMGdHdTVPWVNJV083VXk5dXF2b0RsbVJndHZX?=
 =?utf-8?B?MUMycGNuNTlJWitOY1FGL1dNbnc5aStNbHY0d2doNUJlTTVLb2NTd3QzOStX?=
 =?utf-8?B?eldwaVJBaXRleFpLZzRqdDFrVVhHQ0FScDl4b3dOMHZ3NmNZZnlwU0k0cXdn?=
 =?utf-8?B?bFc3QmJaU1VSNGdrTUZqL1JCNXAyMG9Qc09IYzJ3U0FwVENJWkh6MkJrT1Zy?=
 =?utf-8?B?L1F6Z1F2TU1Cb0xRY2VjSkd1eFNFYys4RFl5UFZSSlA2bW9aWVRYZTVIQkZp?=
 =?utf-8?B?VGFZMjduMm81cHdGaDNZcVhDTUhSZitEQUdOZUwwbysrcDhKbGkrQm9oeWtD?=
 =?utf-8?B?ZGIrQ3FlRHp1akdzN1JCSFkvRzJiQ1FNNXJqdll1Qno5cmM1eVR6N042NEJs?=
 =?utf-8?B?c0drdm1qV0l3NHdRdGJPSGJZeHlhTzRVdVVWMGZEQUFsc2FxY0hYUldVUlBt?=
 =?utf-8?B?MEFSeFhNVS9keU9oajRCSXlDR1ZuWi9yZE5zM2JZMSs0SEYwOURGcXM1azBt?=
 =?utf-8?B?SEZYRUFBQmNyVmNicEI2S1ZxSmpQQVFFdlpIa3JTUEZPK2xmalZ1bkFscTZm?=
 =?utf-8?B?K2s4QVhFMUsrUVZxNGNQTlhpb3kwWEszVUZwS0hHcWUrWGVFVTJrOC92OUxq?=
 =?utf-8?B?S2NtZkJqYkpKU1d4RVIyMEhFUUc4ZlgwNkF1RXgxWGhqQmZNWmVKbUdRSWoy?=
 =?utf-8?B?TTZaMFJFMzVWTG5aUGlqbW9ybWFrWDd2V1Jxczh4VVpBVjVqVGViaDdWMW50?=
 =?utf-8?B?dXNNVG5XZmxkV1ZUWUdCOVhuOUYySEZ5MVVZckptNmRHSzNmdUc2TWZqbXA3?=
 =?utf-8?B?RnVnTWZjamxZZHpaRlFNd0RVdHZrVktEa3A5cis0VU9kY2Y0eldKajVxUEk4?=
 =?utf-8?B?WTdIK3Q0QlZycElTeGJJb21FSHkwb3pvOUVJZDhuK2E2L1dIbjFMM2pCT2Ji?=
 =?utf-8?B?TXM0aVVoOUlkQ1l0d0JydzNjM1psRXNZZGN4d093QndFMnV1QWxUTEpvYUhD?=
 =?utf-8?B?RlJBZnovUy9xSGdkM05INHo1Q005aEp2V1lXSkpoNFBuVFkwV2RaTnlSK0xo?=
 =?utf-8?B?TXMrY1NaSUV2WXdlcDVPbTZkSjZPaDZMTzUwaFB1cXhDWWFMU2lpRUkzQlh5?=
 =?utf-8?B?V1BMeVRielVmOWFZS1FRVjV6NDc0K3lRZ1hXczc0RHBTUGpkejNBL0MrT2t0?=
 =?utf-8?B?R3lFS0pqWkJxV2c2M3JrMGNDWklhWHU3WlZpc0JrNzhrQXp2RW9LbjRpR1l2?=
 =?utf-8?B?Q0FvbkZNYXcyZEd2M01EcytLdU1oVENzSjdvSGQ4RXh3Szk4anUzVjh1TmlS?=
 =?utf-8?B?aWxJdUtkQnBkdmF3QzJZUE16N2NBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3066794-e768-46ed-263a-08db215e2264
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:53:59.3812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVK9t8pSKyimO7cYuuG7MFnoX5o38TwkOnEL0XiYQN/lEWBaFImGXFl1VdS5uGYHrUErEjzVg2ml9qYSIPZW9ZqjK8DNp3KCDSxnDeo7MTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4606
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 04:05:13PM +0100, Eric Dumazet wrote:
> On Thu, Mar 9, 2023 at 3:59 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Mar 9, 2023 at 2:48 PM Gavin Li <gavinl@nvidia.com> wrote:
> > >
> > > Change ip_tunnel_info_opts( ) from static function to macro to cast return
> > > value and preserve the const-ness of the pointer.
> > >
> > > Signed-off-by: Gavin Li <gavinl@nvidia.com>
> > > ---
> > >  include/net/ip_tunnels.h | 11 ++++++-----
> > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> > > index fca357679816..3e5c102b841f 100644
> > > --- a/include/net/ip_tunnels.h
> > > +++ b/include/net/ip_tunnels.h
> > > @@ -67,6 +67,12 @@ struct ip_tunnel_key {
> > >         GENMASK((sizeof_field(struct ip_tunnel_info,            \
> > >                               options_len) * BITS_PER_BYTE) - 1, 0)
> > >
> > > +#define ip_tunnel_info_opts(info)                              \
> > > +       _Generic(info,                                          \
> > > +               const typeof(*(info)) * : ((const void *)((info) + 1)),\
> > > +               default : ((void *)((info) + 1))                \
> > > +       )
> > > +
> >
> > Hmm...
> >
> > This looks quite dangerous, we lost type safety with the 'default'
> > case, with all these casts.

Thanks Eric,

FWIIW, the feedback I gave earlier, which partly brought about this change,
was based around avoiding casts...

> >
> > What about using something cleaner instead ?
> >
> > (Not sure why we do not have an available generic helper for this kind
> > of repetitive things)
> >
> 
> Or more exactly :

... So, yes, this looks better to me.

> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index fca3576798166416982ee6a9100b003810c49830..17fc6c8f7e0b9e5303c1fb9e5dad77c5310e01a9
> 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -485,10 +485,11 @@ static inline void iptunnel_xmit_stats(struct
> net_device *dev, int pkt_len)
>         }
>  }
> 
> -static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
> -{
> -       return info + 1;
> -}
> +#define ip_tunnel_info_opts(info)                                      \
> +       (_Generic(info,                                                 \
> +                const struct ip_tunnel_info * : (const void *)((info)
> + 1),    \
> +                struct ip_tunnel_info * : (void *)((info) + 1))        \
> +       )
> 
>  static inline void ip_tunnel_info_opts_get(void *to,
>                                            const struct ip_tunnel_info *info)
> 
