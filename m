Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB00F68DECE
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 18:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBGRWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 12:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBGRWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 12:22:08 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2101.outbound.protection.outlook.com [40.107.220.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1607C5BB5;
        Tue,  7 Feb 2023 09:22:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9MNazeflmOLYeKEItPVyxjblhF9Ioa+uh2/bBCCvdktTIrcCvmu3hKHsg0ncEBnYt8kD8Tvtr99jWo3cZm4/wMVnDrmYDTkApG7EmT1pmYBLvGnRscuiqpPYlTVR9SnroJRvhvIqctFGk/Lusf/I27AXWHqJ1ImG/sTkAKKwIHHo6OzEpO7czEI/VIzmimk8cxiajXs/p3l61SgRn0h7fwzBfBTogmLNC3mP++u+4hreb2jnLtHXnn+76dxalnnF8mG6pkNLAWtUArxMbWHIuWYLgDzXatVnnkzzcZiZIabK+UgJPd2pCpiJ7UihbINl5YaMFqzduqKptLrZBz2ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNh/JZL/k9oQko1wB7UXdYbutLpYbP0rEiKMSWtMPAo=;
 b=lXQ6JQ1mA8ZdzC90gtjxPlDdYY1Iw71ilCWSMQi5wQeg1ysQ3iT3K3q2QlYU5FtAqeUZZ38jINrorudZKgLIGq1YBWQ80PLArg2+qhpl0/ZaCmMpeVG6SnU31i2FdGSSr5RhAykUH1EQ20Sk86EHyciXUY0meHWc7jaF9kWxWMNhmQrObjJk8XuOCtxsIvaaszFOMdlJNowObxDzS+Ge9C2gjz9WbRkFWkbiYv8zfwRcQy4xI0u5mQeOJ4CyuIFsq4UPwItNVLWR6hKm53YadwFXxD9i+nI4+K8dDI/Dfh26T95eMZMsEFIVGTtbszUmfayOTCpFMEb+3bqtGPMg4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNh/JZL/k9oQko1wB7UXdYbutLpYbP0rEiKMSWtMPAo=;
 b=p7QM7ms8m79maMzTvIHCK07ILiMMU17CN6/sulKRyPwWkCw2CC7i8BS9MSapo2OUjcN4aq0FmI4wozhSOF9Yx8RpZyfSeHi5VETO0ozroFdo41LDPMSibAU8EREK8oPusAEqwZd1Aba1x26jUbX17afhg8kFbYhmQxblnamWnj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3893.namprd13.prod.outlook.com (2603:10b6:610:98::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 17:22:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 17:22:03 +0000
Date:   Tue, 7 Feb 2023 18:21:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: openvswitch: remove unnecessary
 vlan init in key_extract
Message-ID: <Y+KIr5Pwlpoy/sn3@corigine.com>
References: <OS3P286MB229551D6705894E6578778DCF5DB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB229551D6705894E6578778DCF5DB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-ClientProxiedBy: AS4P251CA0024.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3893:EE_
X-MS-Office365-Filtering-Correlation-Id: 4388faf6-806f-4235-502b-08db092fd43a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRqaZN5dpMTSddnNCIi1ueW14hzB7OF9a8NhIydqtPx2HJjzzOqWA27AtRFJQcUF6tUYFuGiwqADk2IVmqscUvwGxqFSmdk5avcXhST27Tz8ZbLQnxf5YMvRtxifYXv5vDsjdaj1pslMvMnxt/HZ+I6hkITuWXslLpgIWfeqCPl5a9RJfRpxIjjGowjlNN1+sSZXydK1NENDKiFaKUD9KpOB0pRtngcFlEzkx6kBD0ELFDoqAahMIDCyDygz0P5p4zpocVWV7F1MDAjQDogC/TJH/Fi+eAUyi6QUvwOwO35IVJj7mafFwp9ykIF1Fre2+1dw/22c31+1QPXOHTBqu7fM3tXVhtCmiVoQnYs1NN5uKsJjFDlTMDm4L5FYnitzVUikAY0WGFyRxipyAkknG6tv7QitXYvXhjKEcXjpjK0l9gnbs/qMBsnBx+96E0dSTktPmhQPQX1HPdQYZKgIRiWa4ecp4l74lDHoHSm6tQHGeYmMLZJR9tkEIQfQZMP+6pMx4FxW1PSSoV7Mg5EIMqqdPZUEP3TYu8L2G1tyFP1a9zwq3omo4p+4ssZSm7OdLpW/DrLCvQbTEER0mFHumvzQLstTjWOHv1whCcvWCv9/x6nQrHUT+pSVWSHqpK54gm8qXqpBN1BrgrJ6hmjisL2F97fuqWMPtl2Zfyrg9qWYiAiIz5qfWo1GhHxnMfeO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(136003)(396003)(366004)(376002)(451199018)(5660300002)(8936002)(41300700001)(83380400001)(86362001)(38100700002)(36756003)(44832011)(2906002)(54906003)(186003)(6512007)(26005)(45080400002)(6506007)(478600001)(6486002)(66556008)(66946007)(2616005)(66476007)(8676002)(4326008)(6916009)(316002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v3kHy/H9Al90RNt1sXFjkCITgE+PMkaXdrEdFRRiq2QfKf+g54IaO4Whb7bt?=
 =?us-ascii?Q?R5n2WWtcR1vj+Jlm/vAHm8v3R77GYvnLXOQhBK+fTQbmSF6zgsoQcDhfHCo0?=
 =?us-ascii?Q?p5QAXnoPhztLfF71qaPDVBb99pSn2P14S+hS7mqZ/dhTonNq7+SURv1b4p11?=
 =?us-ascii?Q?VZpNUIbDiZPmPQEh2WytTBX1afLgMUftqimsbQSmermQjRIaKI8Xe7zIr6uj?=
 =?us-ascii?Q?72MaRVT+QQKBLBalm9HBerpmoNDFDTpEc1KifAAJLl/aRTzLAFFg3tHr9Jd9?=
 =?us-ascii?Q?PvQ2O/x6T+8+ZMMkPOzb4BNuJ7xJvC+9xSl6/rk58tSCgU6kvtIamBKuBnSE?=
 =?us-ascii?Q?IuVnL7HmV8wRuH9Ri58QALth1KQfe3tMC8FhBPRmUbouoQIQb3uUPJHjwiSr?=
 =?us-ascii?Q?wobhYbkoyymMNRYo0KUAufMN8YQe9fr7Ybx7niZqyL3nY5y8djaGJvD3bzw/?=
 =?us-ascii?Q?kZluI+DHUv2jSFhk/Jp0drGt1Ok3TwNxXnOLwCL75/Re4wDGLtGMapzTY/Dh?=
 =?us-ascii?Q?ra0Jk3GpXtRRXpQHWrkMl20bCGdmkb7XAuEV6yDzguoWJUyuAp4Kx5WSqTcs?=
 =?us-ascii?Q?aPczAt3jEmDFkCldT4waJFF9OnLFd48EV8QLRnb2oAbtO99MfbGL+ZMr6Jkn?=
 =?us-ascii?Q?E3WmKID7c9/iBBAPoyTRgk4ueNLry0Autq2i3DsEKsWTA5cvxRdqP+RgKLnY?=
 =?us-ascii?Q?UXgRtoimhTQf9kmtb/Yky5ODcvOf5fXrfsi2hSukzV8SYxRJfnoXtZwWElzs?=
 =?us-ascii?Q?ps82fAvJcvKQZyp7eFTy5gcDK/qi2XjduY6xPwalaslPl7OL7giJD/vKwq7d?=
 =?us-ascii?Q?Fw2A5gADBX9BT+ogKpjJPC7FRCGlPIFuZ6ARTtZyynhLzJur5Qx9MpQMqsXh?=
 =?us-ascii?Q?bKQ42MmcE50WwAw4MuDfkAp6eosyjcqg5kZA470CMkmm/2Be81WHOfHZ0ZSO?=
 =?us-ascii?Q?HZunKz7fEhSSIz/mosV4PXEtESfLVboCEgBkIIZEBaAPTSAGLVLTfTXKKkWl?=
 =?us-ascii?Q?nnR8/xaGot+H1XgJuwMKvUc1YtcQDqTHGAeHQX0dxb9gWRuJ6MgJRpy/fPGk?=
 =?us-ascii?Q?Qp0cFhLfmU+eppGPAGQsgPU0gWT/arNfhUVM77BcDNRSDS8GVAyak+VTFjsv?=
 =?us-ascii?Q?UjuAu9dSu8avaB3cmkHuIpedpzm7ftOLDPHX9dif2MnYCT12R/VxXCiS5Vw0?=
 =?us-ascii?Q?xBoxYJF9/PCNhRr9lFx+jSJtGYYUmCy1V3Z7Tl1KULKWHs3aHF+rfLQoxyUJ?=
 =?us-ascii?Q?s4CUa+HyrxLlucO87WGqfiPPYMA3WTM3CNYm50tjeL+DzclqrDJAADcTntHF?=
 =?us-ascii?Q?QOcsSmgalJFykl4Bu6l6yvLhqRk/56sPvDgC2Bc0nefmqqRaqTzmqdJmrVw3?=
 =?us-ascii?Q?m+xrUO+WqLrcKGwgUHbHYyam7a9gVdeZwDzG8RP5N5jroaxBwwCgjG3TCi7p?=
 =?us-ascii?Q?mHDOTK4vpEludIoAcGMvAZ9NGjNzbe6vnvSw/uj3GMor3mgALz+3HyE0CZT+?=
 =?us-ascii?Q?gVT/oIfPpgISRV1lFhG0JGytU+v2f0VCFQuRb3rt3kcQAM1sO+IYkyFo1NwW?=
 =?us-ascii?Q?xF3AFGumZ/Ep4AP/0FqkmQve3afJTKL0pGzFuxnVD1Yp0NC0QK4jtsBqmJk6?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4388faf6-806f-4235-502b-08db092fd43a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 17:22:03.5490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ikK6LNSbYZQen/P6VYcEWsm9F2cjILNwfhO/73FnvJ2Ou6ko/cdztX+gUro+4/hV5dV2mERE+azlQgE/2DjfYHq6Hmes/8k6GW3wlVjIjWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3893
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 12:31:33PM +0800, Eddy Tao wrote:
> Redefine clear_vlan to initialize one struct vlan_head
> Define   clear_vlans to initialize key.eth.vlan and key.eth.cvlan
> Calls the revised functions accurately
> 
> Reasoning:
> 
> For vlan packet, current code calls clear_vlan unnecessarily,
> since parse_vlan sets key->eth.vlan and key->eth.cvlan correctly.
> Only special case where return value <=0 needs inialization
> certail key.eth.vlan or key.eth.cvlan specifically.
> 
> For none-vlan case, parse_vlan returns on the first parse_vlan_tag
> which returns 0, in this case, calls clear_vlan
> 
> For MAC_PROTO_NONE, logic is intact after this revision
> 
> Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>

This seems like a complex, and perhaps error-prone, way to avoid
writing a few bytes. I do tend to think the extra code complexity
is not worth it without some performance justification.

OTOH, I think that perhaps a better question might be: do the bytes need to
be cleared under any circumstances? I suspect key is discarded when an
error occurs.

> ---
>  net/openvswitch/flow.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index e20d1a973417..30a90597cab6 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -480,12 +480,16 @@ static int parse_vlan_tag(struct sk_buff *skb, struct vlan_head *key_vh,
>  	return 1;
>  }
>  
> -static void clear_vlan(struct sw_flow_key *key)
> +static inline void clear_vlan(struct vlan_head *vlan)
>  {
> -	key->eth.vlan.tci = 0;
> -	key->eth.vlan.tpid = 0;
> -	key->eth.cvlan.tci = 0;
> -	key->eth.cvlan.tpid = 0;
> +	vlan->tci = 0;
> +	vlan->tpid = 0;
> +}
> +
> +static inline void clear_vlans(struct sw_flow_key *key)
> +{
> +	clear_vlan(&key->eth.vlan);
> +	clear_vlan(&key->eth.cvlan);
>  }

This is a nice cleanup, IMHO :)
>  
>  static int parse_vlan(struct sk_buff *skb, struct sw_flow_key *key)
> @@ -498,14 +502,18 @@ static int parse_vlan(struct sk_buff *skb, struct sw_flow_key *key)
>  	} else {
>  		/* Parse outer vlan tag in the non-accelerated case. */
>  		res = parse_vlan_tag(skb, &key->eth.vlan, true);
> -		if (res <= 0)
> +		if (res <= 0) {
> +			clear_vlans(key);

I think this makes more sense in the caller.

>  			return res;
> +		}
>  	}
>  
>  	/* Parse inner vlan tag. */
>  	res = parse_vlan_tag(skb, &key->eth.cvlan, false);
> -	if (res <= 0)
> +	if (res <= 0) {
> +		clear_vlan(&key->eth.cvlan);
>  		return res;
> +	}
>  
>  	return 0;
>  }
> @@ -918,8 +926,8 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
>  	skb_reset_mac_header(skb);
>  
>  	/* Link layer. */
> -	clear_vlan(key);
>  	if (ovs_key_mac_proto(key) == MAC_PROTO_NONE) {
> +		clear_vlans(key);
>  		if (unlikely(eth_type_vlan(skb->protocol)))
>  			return -EINVAL;

I think you missed the following case further down:

		if (unlikely(key->eth.type == htons(0)))
			return -ENOMEM;
