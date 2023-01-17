Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49512670BCA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjAQWmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjAQWmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 17:42:02 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2113.outbound.protection.outlook.com [40.107.94.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ECA3A588;
        Tue, 17 Jan 2023 14:29:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgXiTybtsnqxh8/vcDN1rQuSSi/r3SeDP5ELGZvmN/GlaApHjpdB6oZvLuu91+sUb3zrwJVBMLPBRL4zAUofz5ECdkj3Crb2yfaAp3A+IynKgpQ5fyJLUO7OXh+arnAehpt4nrDI1o9YbFL+2d30iO+iIpdCq4oqTlI3wr9ka6efGvBJnpnCd9Lm3bW3+kJGUeRXEPqGMfEI220U91QCXitV4mrfvN3ZUgDQP3ggeCtLSafPJlErQJZeJgiIYNdvh3eXNriGWiMzK6q/MxQXlY87qnBaakoY/DKQA+0EyrZ0M09OJeFxzyBTg6tXv+qG9jLZABO/YEOLUF2srF6pJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8suO+jaYdvyQIC2deS4jzeSVlmMLAw8cGX2C21REbU=;
 b=bLhpG8QTM/qudTrJMCROwrNDSzEM52OpeF0PIhMy43e40Z2RUQ9Zh9kZjAJzXV0rDAqO8RbPxRGqxBKEY9cHuYWgtOEkJwGY+P1/QSFYmktaFIRt6SaRVPJj2tAqMuqq16uzyz2RSiP0kmj8nKUWHS0g9V3CzeXobCf5Ldz+IRParVF3h+5KGqp6zsnG3vHFlDZXEVoF6mqj6n/jrJwX16mPSNjNHFeKmw7j3bXrsxUQdIt2mQ6/trgiyHvXW6ZyCeKwIz4jqfpZKDu4BCyhF4qvuM6n4739Cw1cBPsQuKreltCr3Jke0IVAvne06eNB8o8SLQFY8fs5xwEjZbWGRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8suO+jaYdvyQIC2deS4jzeSVlmMLAw8cGX2C21REbU=;
 b=wnBI21MpVql3EkOIPTJ/XiJ8hC9eJ/JqJ28yWirKKLLZmIanrdER7XxdWhkatQApH/BRcZ5HbFD/iqc+QYseaxs2fUWRta7Fq/2sPAvxg4UlilhiTt4Dxdu36HUTgvD5sX0aEzbecrYdioaNTINfw5aStbGFxM1xBsJklIZnZ4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from SJ0PR13MB6037.namprd13.prod.outlook.com (2603:10b6:a03:3e2::9)
 by CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 22:29:20 +0000
Received: from SJ0PR13MB6037.namprd13.prod.outlook.com
 ([fe80::a17f:495a:6870:18c0]) by SJ0PR13MB6037.namprd13.prod.outlook.com
 ([fe80::a17f:495a:6870:18c0%9]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 22:29:19 +0000
Date:   Tue, 17 Jan 2023 23:29:07 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        memxor@gmail.com, alardam@gmail.com, saeedm@nvidia.com,
        anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC v2 bpf-next 2/7] drivers: net: turn on XDP features
Message-ID: <Y8chM32w/ZWsOOT+@oden.dyn.berto.se>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
 <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se>
 <87y1q0bz6m.fsf@toke.dk>
 <Y8cboWSmvoOKxav2@oden.dyn.berto.se>
 <87sfg8byek.fsf@toke.dk>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sfg8byek.fsf@toke.dk>
X-ClientProxiedBy: MM0P280CA0087.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::33) To SJ0PR13MB6037.namprd13.prod.outlook.com
 (2603:10b6:a03:3e2::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR13MB6037:EE_|CH0PR13MB5084:EE_
X-MS-Office365-Filtering-Correlation-Id: c979ee4d-9acb-4c71-84bb-08daf8da4684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75Tw9e6DObOou5NeRHn0SAbyqo/64QFkUsGG41vyRZDdZE/NoA3RtacGPfu8wOJ0yGHXqeUhL/FTpdT9nxMJryhBIhhGfnaWhP2Pnivh8HX7H3dYIVSShRA6ewF7KRispl+y4+r0YWZq0dG1DujeTz9Zrmb1KhcNvpk50JPc/pXQ6tZp3YR+sZUcDkuOymnjduUibl0uZ8NQS8TItwlEO3v39eww7+Dp6EwAqy5hbrhjQN+xTlHL738Bes74FGt/JqgoqsuM62tqOQ4oIqVipggPMZD4qPZnCSggUxvo5bLy9EbRMsuoUxAyt83I++PlDV8H1/4RjbXqkKwMtMXNPSG5KOhPtfWeOWQ2Fb6lKiEEM9jsql1W1BupCZAcOq0K/WzaqGAIJT2cnYAFws8cw8zbmiRbpWQ9Anfoapxnlex9jlKXcAmGkbbK/v/0hSG1bNB4hV8aNZX8xzrTYNpPEeurztF1ZUwDtjmYBVdLw6jFV55GfutxaW/vwtgCASEffU8iF6t0/jb/miB3ol0NKcoMcYBbG9LUFSCEZ4RggkXWT2qFHxCPzmcAYKklZC5eh8vy5ZLJCwEC5RWH8O7p1kjOBJakPf//xb+k9c+7AQukC3/u8ZS+8vnB8mFoOKurWPBQsnj/5H6yrKNTkGz+fDOYyFq29Gs4AyBa5QsnvFw0Sa9D4Xa4bMtM3qSqimqv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR13MB6037.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39840400004)(396003)(346002)(376002)(366004)(451199015)(6666004)(6512007)(6486002)(26005)(186003)(478600001)(6506007)(52116002)(9686003)(53546011)(316002)(6916009)(4326008)(8676002)(66476007)(41300700001)(66946007)(66574015)(66556008)(5660300002)(7406005)(8936002)(7416002)(38350700002)(38100700002)(2906002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?PcHZNWH4e1wcMnSIupPGQDNV5qN8K5BQAj0WLAii+FoF+6WS1Ssmcmoh/z?=
 =?iso-8859-1?Q?zG1MYftznUc6gESPvVMXLynhJYD07QXg0XZw0CasK9ApkrKLRV+H4nV5Cx?=
 =?iso-8859-1?Q?Bo1gC+kDQryoP393GzIhZreA1EAARLf1Vym8cD3cFyOlq+5NOtDrmOUdVJ?=
 =?iso-8859-1?Q?Hj6ZxhwbNLHwpMa7krvhQwxk3Kw/4ewEj1WL0sZsY7XDtlq9XGPrYDHyIy?=
 =?iso-8859-1?Q?G/OexiDFwM9COPvzcdhr5nKHas43CpV+H2TMOEVQ0j8/W+VvgPt8REQPYf?=
 =?iso-8859-1?Q?Pj32U//11mRa/nL+Rtio4ovmBEAvf5BENJ4ju+NaJ93/9k1tFx3df93Pl2?=
 =?iso-8859-1?Q?4QniWeyoU09DVD5GndEkQ1i046q4/DSbte0lhH0i6oxPd2kKEaezx4qXUs?=
 =?iso-8859-1?Q?DYi3wGs1RVziaAxFou0P1n1LO4eB0jh8nj4baROFcM4r9OhWVZvLmsCLZT?=
 =?iso-8859-1?Q?c9t7jRbdOVj+RFapgEBOpfP6EGL4aKQBwLXkS8oYmPlwd74TmGwji7Pqws?=
 =?iso-8859-1?Q?afneihYnxQ6yfT/X1YvdxWv0LBS81D88/Et+WZeh3Gu270F3nH+7iU8j8j?=
 =?iso-8859-1?Q?+vW5ROM7KI2Ggt9AIH5Nt/Hn2PN7T8pFzGvDwH0oOdLNcVdQxDuuyu75on?=
 =?iso-8859-1?Q?buribHocMFnH0cD8fDfdaCaYI5r+mowFWPEFSQCN+KEZWPvSb8MdmGNtMQ?=
 =?iso-8859-1?Q?L/X5LKPTgm3rcvZfMAJpI3qaEWd/Kop6PHHWRDQMW4e1WkuWydGzBZBDQ9?=
 =?iso-8859-1?Q?+36usAkDEeg5CVvPsIVBzVeGQTTk2xTqueIgVJEUbhY7dtPPFJ0ONU+qhI?=
 =?iso-8859-1?Q?o8OWZCk5dN1pQ0r/zrJLLr2DAMB4hQRW2kjO/kdJ9ZVovS00uIjkC+/UDe?=
 =?iso-8859-1?Q?mto+ewoxnBQ5EaabSm4pecp7TWKCQg5VsnpmGWO+Dd5x7JTuBFi05d6AP+?=
 =?iso-8859-1?Q?V2szJWCnXr521i6S9YuDdeb3uWGpr0pspfhKTLVNU16WSDvdE8KtnJhI2R?=
 =?iso-8859-1?Q?1HAx5AItcM4N2qMDv/oSE5pdvVt5YOtkbv/DAEd7S28YINdMeU9JeFIBL7?=
 =?iso-8859-1?Q?obv8eHrEO/dRkun9j8yiVxNd/QPssjrKE4xKtcUPkP8wCWSvYm4UyWv0Hz?=
 =?iso-8859-1?Q?Fi6pdBUicCjuY/fzrvBOq/NBb2UfAQhxSOIBmHQoFxCULpTiy+GSPPJyxi?=
 =?iso-8859-1?Q?d8Oi5e6LFy5KT1VUnybYSpRBjPcMzvFLafV8pyAmZ21KRSmKvLEKIaCzMe?=
 =?iso-8859-1?Q?Sr4+mxqO0bv37zE5H3ewY/jbjff58xNnCvgjxlUI65tVZX7GrU9t6Vv3Sr?=
 =?iso-8859-1?Q?UTPRqnxytLvfpF7m+ZXl4N+jCVmprbzHGzj3t1Q4PLZ4uThnjXa0mMt3cT?=
 =?iso-8859-1?Q?yEFueTifbPqoGlgPkmRYwIBEQJsvQN2S0VNmEM3pV9Y84Iz9JUG07IjdYO?=
 =?iso-8859-1?Q?5SyHFiVD1oi7Kh0ZfRerpqciEulyE2+xUMh1+F5RwB0xFt01OPOBz2Jyfn?=
 =?iso-8859-1?Q?omQs0413+OQghzQMuV4WXYxVrdv1X1haaVQebXbXk+f8j3EwwK6/FfNqIO?=
 =?iso-8859-1?Q?1+ketWYrHlsVawi30zjKkqsYJYD4bJpycxCZWjPx1S4uD+lT7tL+GcWbUm?=
 =?iso-8859-1?Q?s9A3HjqXfujFhuSQJQm+FOsTXNS69HDsLD6u2Xk0it37YNjxXUY8piQg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c979ee4d-9acb-4c71-84bb-08daf8da4684
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR13MB6037.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 22:29:19.7869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJ9lmMpgg3eZ7aS2kzg1tmq0ykhyte7dkGkWzZQ6SKRJPyaCt+lWmuIfEpL5ZJ+CkHp1NRLLerH9q8F62slJbCanDKBoPzAhqRhwp+IKWV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5084
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-17 23:15:47 +0100, Toke Høiland-Jørgensen wrote:
> Niklas Söderlund <niklas.soderlund@corigine.com> writes:
> 
> > Hi Toke,
> >
> > On 2023-01-17 22:58:57 +0100, Toke Høiland-Jørgensen wrote:
> >> Niklas Söderlund <niklas.soderlund@corigine.com> writes:
> >> 
> >> > Hi Lorenzo and Marek,
> >> >
> >> > Thanks for your work.
> >> >
> >> > On 2023-01-14 16:54:32 +0100, Lorenzo Bianconi wrote:
> >> >
> >> > [...]
> >> >
> >> >> 
> >> >> Turn 'hw-offload' feature flag on for:
> >> >>  - netronome (nfp)
> >> >>  - netdevsim.
> >> >
> >> > Is there a definition of the 'hw-offload' written down somewhere? From 
> >> > reading this series I take it is the ability to offload a BPF program?  
> >> 
> >> Yeah, basically this means "allows loading and attaching programs in
> >> XDP_MODE_HW", I suppose :)
> >> 
> >> > It would also be interesting to read documentation for the other flags 
> >> > added in this series.
> >> 
> >> Yup, we should definitely document them :)
> >> 
> >> > [...]
> >> >
> >> >> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c 
> >> >> b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> >> >> index 18fc9971f1c8..5a8ddeaff74d 100644
> >> >> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> >> >> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> >> >> @@ -2529,10 +2529,14 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
> >> >>  	netdev->features &= ~NETIF_F_HW_VLAN_STAG_RX;
> >> >>  	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
> >> >>  
> >> >> +	nn->dp.netdev->xdp_features = NETDEV_XDP_ACT_BASIC |
> >> >> +				      NETDEV_XDP_ACT_HW_OFFLOAD;
> >> >
> >> > If my assumption about the 'hw-offload' flag above is correct I think 
> >> > NETDEV_XDP_ACT_HW_OFFLOAD should be conditioned on that the BPF firmware 
> >> > flavor is in use.
> >> >
> >> >     nn->dp.netdev->xdp_features = NETDEV_XDP_ACT_BASIC;
> >> >
> >> >     if (nn->app->type->id == NFP_APP_BPF_NIC)
> >> >         nn->dp.netdev->xdp_features |= NETDEV_XDP_ACT_HW_OFFLOAD;
> >> >
> >> >> +
> >> >>  	/* Finalise the netdev setup */
> >> >>  	switch (nn->dp.ops->version) {
> >> >>  	case NFP_NFD_VER_NFD3:
> >> >>  		netdev->netdev_ops = &nfp_nfd3_netdev_ops;
> >> >> +		nn->dp.netdev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
> >> >>  		break;
> >> >>  	case NFP_NFD_VER_NFDK:
> >> >>  		netdev->netdev_ops = &nfp_nfdk_netdev_ops;
> >> >
> >> > This is also a wrinkle I would like to understand. Currently NFP support 
> >> > zero-copy on NFD3, but not for offloaded BPF programs. But with the BPF 
> >> > firmware flavor running the device can still support zero-copy for 
> >> > non-offloaded programs.
> >> >
> >> > Is it a problem that the driver advertises support for both 
> >> > hardware-offload _and_ zero-copy at the same time, even if they can't be 
> >> > used together but separately?
> >> 
> >> Hmm, so the idea with this is to only expose feature flags that are
> >> supported "right now" (you'll note that some of the drivers turn the
> >> REDIRECT_TARGET flag on and off at runtime). Having features that are
> >> "supported but in a different configuration" is one of the points of
> >> user confusion we want to clear up with the explicit flags.
> >> 
> >> So I guess it depends a little bit what you mean by "can't be used
> >> together"? I believe it's possible to load two programs at the same
> >> time, one in HW mode and one in native (driver) mode, right? In this
> >> case, could the driver mode program use XSK zerocopy while the HW mode
> >> program is also loaded?
> >
> > Exactly, this is my concern. Two programs can be loaded at the same 
> > time, one in HW mode and one in native mode. The program in native mode 
> > can use zero-copy at the same time as another program runs in HW mode.
> >
> > But the program running in HW mode can never use zero-copy.
> 
> Hmm, but zero-copy is an AF_XDP feature, and AFAIK offloaded programs
> can't use AF_XDP at all? So the zero-copy "feature" is available on the
> hardware, it's just intrinsic to that feature that it doesn't work on
> offloaded programs?

That is true, so this is indeed not an issue then. Thanks for the 
clarification.

> 
> Which goes back to: yeah, we should document what the feature flags mean :)
> 
> -Toke
> 

-- 
Kind Regards,
Niklas Söderlund
