Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4FF6B988F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjCNPJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjCNPJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:09:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2127.outbound.protection.outlook.com [40.107.93.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A37F2330C;
        Tue, 14 Mar 2023 08:09:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRbJddFkQGVAFBtxvFzTAoJjlyw/lCKNM/DtH5lQQ7+1nm4dAL6GCWJqTJttldVNIOv3JbpFfnSTmefoIHKVKWG0rigIgf6zLHCqXTb8pBKGgAtEiOoZMdIa4cY8eWPRc9mV8MFTWLXJ5ZGllpDV1OI/QxEdxS2k4TMdAyFXaDNuqwr8+b8pow/CEyqGBS/iITD/JOFHiFACEaa8bdqPi0JAPM4F+2lL7xrflfn4Y3bqph8r+zdO0ZX+oNeZ0Jyuf7gPZ0uE8T09D4wmFWnGbm5HrZ2wlR5iR8Pmk2vPE6J66BVvqqBJwYP9GVTHd1n5kjKayuV3WNFOCKNMW234uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7HWzBB3V/sH8dAfxQ+MJ3TPhZp93kERLBu9Ck8DBW4=;
 b=dhYgg7VX+z030WMhDEegc0YnmOiJxlPkFyoiyaaUILO+W4Vox+ELUigAgMKUrtfYYd8rIQ7ie5cG0ATjtn5s+TSBqJ7NKHqFNuyrUtzLPoKoHzekSshF3kCvGQ4xVl988RWuaix+FaAjXrxyJQoLVasdutyxz0SAN4GXyJUl82DDUIQYDUtqhiSFx+MVOSQZQIA9H3/FCoEJuXEwk3niaY0Er/4fT/zJwcIEE/AXfvAkn/uvoln/7e2DKXwjlKNfS/uRC1NC/VgXgx3gia3Aq20zVJ2MKBI1JJkRRsDYCOa6u1TQTGZkgIJN/og5L2tBXldNKL6uXVFeKpYtXny9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7HWzBB3V/sH8dAfxQ+MJ3TPhZp93kERLBu9Ck8DBW4=;
 b=oA6gorebeIxbEHO+AESyi5rW2Ev2w/2YPaP8ltuwHQdgJYMVCf/XSLapZI4fMwcQsheiYiktVE5lTpJsMscy3MlefK9PiDP4WtPHZyhbal/JLXqLjgLY/RH0+XpQ3SHzshhoNp/yA4xI351R+Fp0MrvI45m+LDC03fJQoxuqk7U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3723.namprd13.prod.outlook.com (2603:10b6:5:246::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 15:09:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:09:05 +0000
Date:   Tue, 14 Mar 2023 16:08:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>
Subject: Re: [PATCH net-next] net: geneve: accept every ethertype
Message-ID: <ZBCOCtzNKenD4dqq@corigine.com>
References: <ZA9T14Ks66HOlwH+@corigine.com>
 <20230312163726.55257-1-josef@miegl.cz>
 <57238dfc519a27b1b8d604879caa7b1b@miegl.cz>
 <ZA9s2Ti9PlUzsq/m@corigine.com>
 <CAHsH6GsUAzye2puFES_5iemTtQZyoiR590NRPC8ZXrTg4B+OMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHsH6GsUAzye2puFES_5iemTtQZyoiR590NRPC8ZXrTg4B+OMA@mail.gmail.com>
X-ClientProxiedBy: AS4P189CA0013.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3723:EE_
X-MS-Office365-Filtering-Correlation-Id: e7cb7d33-6637-4d7a-817e-08db249e0d5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fgz476l8TzynA8NKKcR0x4cs/FWmmeCgk0sL1nCGNcx3jz8XX88vd7spJOrdZ9q/Xw6AzyHEFDOKI3zL94VdJO/h0MW99xTLOzI3L0kguzHw+2Sw0C41s3Yd5EoM/qSm67crhUKoKM0Wi6yy6hrRa7OBzNIFgxbXxpzftMiyvugIdYlKl/xPt0D06FfMDICnNqrAvXJeFkXtfzoE+EGUobgDGxXLyRyUqAzxn/tAgFQI5oA9Hiq2+YRkAbrtm2TbNRmyNkOniWIdxWoFRfoePbp1wPa8eAR+4FLVO+ZdOGOfts9BJ4j7aVvnRuLmcKzUfEAoJZI4tnoEHXKnLDGE+tcBby6Gx5zepNE6v/Xe+3JVmw6zkuL3EoeZ7mNxlyvKchKYF8VVYBCGBneQHPTgA/1LpeYWpkpM4m3HJXe3j4ey3Yh/bDmBIG+7D1D68Zh+0Qs411ag+mn/u5vle8Q8RNFcnru2/Hyk/46ZAFVBsp6/01EwduAZmHx3jpscXTVM48d+6qyI+U5cdUrgcU5CUYMy++f7Pj5KRbsIhCpmUzEJ7axZa5X9fVAiaUzIpD8ChiRQJ04lH4ZjPgyu4/UqtAlVVAUwDcl0AkMjquO1C082+t+ShBBdlqhbXQHdwXZH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(39840400004)(136003)(396003)(451199018)(5660300002)(8936002)(44832011)(2906002)(38100700002)(36756003)(86362001)(41300700001)(478600001)(6916009)(66556008)(8676002)(66946007)(66476007)(6486002)(966005)(6666004)(4326008)(83380400001)(54906003)(316002)(6506007)(186003)(6512007)(2616005)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkxjZWN2N2lvZjMxZmF3LzYvRHZ1L3lCNDJ1SEgzQUx6ZXZmZC9WSjdIdTVF?=
 =?utf-8?B?RDMvTnBYZUhUMm9BNkFXL0YvNzlIc3h0MXZyejBnMTU4bW9JVXo1ZmRqblpS?=
 =?utf-8?B?K1d6RDB0VDQ2UUJKeG90SmFDZk9lTHVOaHIzQWhndWkzNjVhejg2N2NaZXJx?=
 =?utf-8?B?M2dBanVPVCt0dHlBaXowVWpLek0zT1FRQjV6UXlEQmxEZVZLTnMxekxCQ1ls?=
 =?utf-8?B?N29SOHFCY3ZZdVVwOStNay81NUJhcHZGQUl4Qk9sN3J0NWIxNHhxOW8wazE2?=
 =?utf-8?B?SnBjK0RCUVdnaTFlcjhrSVhjdG5CUUVSWjEvdytZYllVQ0RDcDBldkgrZTVN?=
 =?utf-8?B?UnB6eVk5Qk45eWErMzUxRTd2TnFXT1hxVXBabkVqN1pYL0h4ckFkUzhLWnlO?=
 =?utf-8?B?RGMzZ3gxYmMxVnErUC90MGczRXRFeXhmbFZSS1MyNFk3SXdpdXI0UmtpOFE0?=
 =?utf-8?B?S1NCaDRSUnBiK3NUaThIRkxDcDNkVHZyT2g0b2wyOVA4UkRGUTlPN2crU0hD?=
 =?utf-8?B?SHhXTVJWVG44VzR0SmZRMU5JdzI3NzN2ZEtBdXYyYWF3TGxpV0JncEhGdTlz?=
 =?utf-8?B?aTU5eGdkWWNqV3M1eWdyRWE4R2prSWtGTDEyR1lKYnhHMDg3OFc0Z0s4TTlt?=
 =?utf-8?B?SVRzbEhmcjZoTUF5eFdhWHZDSFYzS3REcUJzc3FEV2szQVdVbjFCRkxYWjJq?=
 =?utf-8?B?OVNVWnpCUEpMdU5WcmFacDNkb1VOTHZTS0VBTFZSZGtFQnlBTFp5clNEVGMx?=
 =?utf-8?B?WjR3RloxUFNvT2tEN3R1cCtFQ1I4c0Q0bk1xS2NQVGN1T01LdklBUkErcmd2?=
 =?utf-8?B?Ym4yS3Y4QXBMN2hPalZjcGIwcm1EL0YxSVYvNk4rZWFGWFlRcEhwcUpSM044?=
 =?utf-8?B?QlVjTllOSDRvU3ZEQ2ZweGs0dkc0WGovMi81dHV5aFJQcXVnYVdQWUFvTi9E?=
 =?utf-8?B?bVZqalVHdFo1V1V3UlAySGNzUWVicmtxS3ZyTEZGeU50YzI3SHFyUGo0YnpG?=
 =?utf-8?B?bVZXcmtyRzRuQmtXRS9JaUNWbCtMZUc3MXdFOTR4MVVCbTRjKy9xTHNwZzI5?=
 =?utf-8?B?UkxwVmloWUY0bXJETXlMUkFtTlpaRnQvcFhjOWgvdWtXNitFNHplS3kweGx3?=
 =?utf-8?B?UDF4M3RyZnJyaWdHd3gyOXAzZnlZOUtLcEtvcFRwMDFPRVMzM0Y4bVdCQ1NJ?=
 =?utf-8?B?SVMrWTZXSFNCS3Vka2hpVzZ0RzN4S1RBbDlnc2d2TE9EWFR5dkJFTXcydXFp?=
 =?utf-8?B?WWtrWGJGRkVLR1J5azh0U2xkbk1RYmhFYzFoQTd4T1FlWmhCajhXcjhkNDF6?=
 =?utf-8?B?NlNacmtUS0pBTjUrOFJ2VWV4Nmx2Ui9UNlBmU0VINHdyNVZ4aEJlNUZ5WGgr?=
 =?utf-8?B?T2lCT0hXc2s1TjlmQUJrOExCNlRTbW1GUjA3Z2pqZ1Y5MlNCR1lEdGkrWlF4?=
 =?utf-8?B?bTFTanRDQktGUW9wV2l4Ty9vcGlSQlhpOWdBM2dSUlNaYzZ6VDJ3aks4UjZu?=
 =?utf-8?B?QWlYYThIbDh3ekhHbzh2SHl5Sko2TkN2VXBUWnRzWnJWV3ptOWU3YkxSbmRk?=
 =?utf-8?B?Q1gzM3VlZWk2Z3RJOTMzTUFuSXc1QTNGRWFtYkxGMGNaQXBtNkFFQ3BUSWNr?=
 =?utf-8?B?YUp2VFljLzV5VGM2WldCb0lMRWxvdlZHbmYzQ2cxRVh4Vm52RlByMXhiSWgr?=
 =?utf-8?B?ZUZaNmFBdDJ3ZEkyVFZablJ1Z0NmRHRhcDk5d3E1T20rd3h1Szlnem1qTUE3?=
 =?utf-8?B?ZVJSNTNZWXJOLzZYSHI0MnIwc0FmSlZnWFFPTHJsQ2NHcVlEQkhzNDRCbmVR?=
 =?utf-8?B?eU9ZeUU1OEZpWXh1bHBoZnIycmJCMGREYWxHNVU4b1dNYUpaOUJHSmx1azdi?=
 =?utf-8?B?ZjVnZGV5akc0T3pELzJVeVJndmRBRllyaTZZVUtRUE9QUmV5SUdCekd0UHY5?=
 =?utf-8?B?dVZneWwwVHluUXZudStlTlJoTEQzVmZZcVpiV1ZvOGhEOUQ3NFgrVGtwTlIx?=
 =?utf-8?B?VUxpZ2VqU3c2Y1dFc2NkclJmK21CeTRpTzhJeThrblF1YkZzQWZIanoxNVJq?=
 =?utf-8?B?Si9GbUpNY2JDYVJlUWZTaTRhT3RuMW5idlkrTE9MRjhNdnllS1FrMjJsNVZq?=
 =?utf-8?B?U3FkUndGa0dTcmhQZ1YvdDU4ZGdiU2F6OXNLK0syU1RRWk9XeGFHcVNJYWI2?=
 =?utf-8?B?ZnZqdzExOUxtTnpFVCtxQTNSdkxKVUV3VzBPbUQzNDAvSHdHTHJMc21GSTJM?=
 =?utf-8?B?aXdHd3o4amtBTFhUek8wUGR5YkR3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7cb7d33-6637-4d7a-817e-08db249e0d5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:09:05.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PoCs+q5vB9fHcNxaqt87GLRKbqhSqGdYn7Nr9dB08VdZXYdbnUkWQXK3og+YV3asBGOACYTyiJXe/1rZ23ULhyb+0l9+jMdVYgypgzhk34I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3723
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:55:07AM +0200, Eyal Birger wrote:
> Hi,
> 
> On Mon, Mar 13, 2023 at 8:35 PM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Mon, Mar 13, 2023 at 05:14:58PM +0000, Josef Miegl wrote:
> > > March 13, 2023 5:48 PM, "Simon Horman" <simon.horman@corigine.com> wrote:
> > >
> > > > +Pravin
> > > >
> > > > On Sun, Mar 12, 2023 at 05:37:26PM +0100, Josef Miegl wrote:
> > > >
> > > >> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
> > > >> field, which states the Ethertype of the payload appearing after the
> > > >> Geneve header.
> > > >>
> > > >> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> > > >> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
> > > >> use of other Ethertypes than Ethernet. However, it imposed a restriction
> > > >> that prohibits receiving payloads other than IPv4, IPv6 and Ethernet.
> > > >>
> > > >> This patch removes this restriction, making it possible to receive any
> > > >> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
> > > >> set.
> > > >>
> > > >> This is especially useful if one wants to encapsulate MPLS, because with
> > > >> this patch the control-plane traffic (IP, IS-IS) and the data-plane
> > > >> traffic (MPLS) can be encapsulated without an Ethernet frame, making
> > > >> lightweight overlay networks a possibility.
> > > >
> > > > Hi Josef,
> > > >
> > > > I could be mistaken. But I believe that the thinking at the time,
> > > > was based on the idea that it was better to only allow protocols that
> > > > were known to work. And allow more as time goes on.
> > >
> > > Thanks for the reply Simon!
> > >
> > > What does "known to work" mean? Protocols that the net stack handles will
> > > work, protocols that Linux doesn't handle will not.
> >
> > Yes, a good question. But perhaps it was more "known to have been tested".
> >
> > > > Perhaps we have moved away from that thinking (I have no strong feeling
> > > > either way). Or perhaps this is safe because of some other guard. But if
> > > > not perhaps it is better to add the MPLS ethertype(s) to the if clause
> > > > rather than remove it.
> > >
> > > The thing is it is not just adding one ethertype. For my own use-case,
> > > I would need to whitelist MPLS UC and 0x00fe for IS-IS. But I am sure
> > > other people will want to use GENEVE` for xx other protocols.
> >
> > Right, so the list could be expanded for known cases.
> > But I also understand your point,
> > which I might describe as this adding friction.
> >
> > > The protocol handling seems to work, what I am not sure about is if
> > > allowing all Ethertypes has any security implications. However, if these
> > > implications exist, safeguarding should be done somewhere down the stock.
> >
> > Yes, I believe that the idea was to limit the scope of such risks.
> > (Really, it was a long time ago, so I very likely don't recall everything.)
> 
> Digging a little into the history of this code I found this discussion [1]
> where this specific point was raised:
> 
> <quote>
> >> +       if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
> >
> > Why? I thought the point of geneve carrying protocol field was to
> > allow protocols other than Ethernet... is this temporary maybe?
> 
> Yes, it is temporary. Currently OVS only handles Ethernet packets but
> this restriction can be lifted once we have a consumer that is capable
> of handling other protocols.
> </quote>
> 
> This seems to have been ported as is when moving to a generic net device.
> 
> So now that the consumer is capable of other protocols, the question is
> whether the restrictions should be lifted for any protocol or moderately.
> 
> I went with the moderate approach when adding IP support, but I do see the
> merits in allowing any protocol without having to fiddle with this code.
> 
> https://www.spinics.net/lists/netdev/msg290579.html

Thanks.

I think I would be comfortable with this patch if the patch description
was updated to include some of the information above. I.e. why
this was not done before, and why it is felt that it is appropriate now.
