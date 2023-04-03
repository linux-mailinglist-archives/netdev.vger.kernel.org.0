Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5A96D4B22
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 16:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbjDCOzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 10:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbjDCOzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 10:55:01 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2112.outbound.protection.outlook.com [40.107.96.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD1280D0
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 07:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqA2Mp6qdJSIqgjCWHhYsMUH/xldORBsnXftD+7q5VV4z1PpTk+dLpcVV/E3is8Lz+F3epvqxJw7PTrRqkZNiqGJvMKtSbbTRLGRAZwvB+PJGYHC+0D7uzo4zxACAmy0bP6sFIwIGqAH0Cg9RNDvE4Kc+znZDoj+OW33BGxPbS/3/ANEMWh8tQWf+cmH+obaLCm4MqAjSdEQjwGXGDVd6+txJKbftDPg1ncqdITYZS0GksJ0fkAxDposLRz8B5nOFwGd2m8DomohEClRN0i6/WjG4YrcTv48b7a+Kxvq1FDoGJIBBqHSP8jFky8aLEajrBhG/GjkKtVgZVWIDBnT9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pp350/nPtvFF2FBdvrsHKeQDYrEclz0CQEEimr4/mvs=;
 b=SRhTTJkTF0eZNL/X+r5RTZwFs17babocQYCwgr0lMe81Bn0X84MVVg/I9hUxOWYQCXUi4VfK6niin8Z5vxfnqHLw5TUf+5+aITjBn3LYuT4nc3cCIVpxqbdBzfzSiZdrV8kjF+7hLr1sqglQLh/D3Z2YCNgHVpe8g+kgSAAsVa02Iic17EtZhqdW3jx+JejONG829tb41rS34OCipJ4rV9PKaEm7co8Ki9gQNEVb72uVOg3gGOVwlYipKmsQNc3NSBocbddSHQzQPjIql7SIh8vmxmk+8xTQTvUkaoNhyCneN+BhX7xbVn74UJkoxP46C3QE9snal9Bg0atsXb5tvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pp350/nPtvFF2FBdvrsHKeQDYrEclz0CQEEimr4/mvs=;
 b=h836iiFV9cSo1IE1sAliLWn7aEpmDvuR3HoTWIq3+1+jCYsUKTbPPdcYjGGdmpsJT62jliCBkWOC4dBhd7gsD8oT/EX8ady1Wa45vB5ChDA6OjwVzfxXkLSgMo2PESt7bjv9NJ5v+9iqOs1WO+fclrgCt/AJ8EPqk6JsHUnR6GY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5124.namprd13.prod.outlook.com (2603:10b6:208:353::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 14:54:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 14:54:32 +0000
Date:   Mon, 3 Apr 2023 16:54:12 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v2 1/2] net: flower: add support for matching
 cfm fields
Message-ID: <ZCrolLu2cLbB0Xim@corigine.com>
References: <20230402151031.531534-1-zahari.doychev@linux.com>
 <20230402151031.531534-2-zahari.doychev@linux.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230402151031.531534-2-zahari.doychev@linux.com>
X-ClientProxiedBy: AM3PR07CA0102.eurprd07.prod.outlook.com
 (2603:10a6:207:7::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c541be9-954b-4a15-27b3-08db34535555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T+RSNxWZAqMi0WvasGA8hTrtdtvWxnjE0HMh1WRyg26Ogj/FccUnOMEhU07qPIMMsVdHKIEWv8uaFWtERs9FjnIBiZspQhfT2jVR5Hh9mNbenbKblFDdivkAD8b2wTyq298zH1GIbkjPKH4R4smzgVvdKd9Gun7cjgg2I7pWmeki2kTz7l29OTFasQJmFfEZTWGtSIaBYzy4PEvhWnOR0wXRf8xLcImxSp2CKtlrZLM0efWcSjxUnEnvX5eOlP1o+EY7iUlGwpDFfPG2161QpawvzyFZAcl8v6rFVNbs0h8h70UwZWbMH3BM35sY0NPMtKH/TLgPkn0z9I3qucwr0Nja9H9aK0nPELYFgUiuUoQQZ1WYSniCFJ9k3jnhy1AaedRY0awZE+Z4Xlz4hWNTxW5BX5iUVOFafFFnK1BcVSJtoR6x3bd8on3+rGnM2ODoXeLGP3aVOjK0Fs69JZnSDbhppurH8YkQRaOwywHK/hmpAN++WAeo6+fCqk8YgOWjUM/kTWwwT9YH6/Yz7xcYR6Y3BiDghVoaO0+rFLgR2/Wd4tsfSkvHIlo0cvX6YySF1R8/WJKZzraX+ozLhv47i62qYBUcXPd/Rxa11an0K2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(39840400004)(136003)(376002)(451199021)(66476007)(6916009)(4326008)(66556008)(66946007)(478600001)(316002)(8936002)(44832011)(5660300002)(7416002)(41300700001)(38100700002)(8676002)(186003)(83380400001)(2616005)(6666004)(6486002)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cvcb245QUQX3iwgTpEKcy3Y9HS52fNfYidzWLMxfEH197hT0Mgy067C/lcmJ?=
 =?us-ascii?Q?udihCmEPSFfO8vRawqcIpgfH6T+KnOYurseXgZnLJhPJ9QsZn4as6BC9OrFa?=
 =?us-ascii?Q?Rpm15LtSz7XfKFvXQUtY8RUjxpF77Z7IZZPIjzm3FNvLw3JRxCroGkEBYnmB?=
 =?us-ascii?Q?KBsOysPq74VcHBri+yJ27+Vfjjinaz4b08QS6ukFqn+CVxXJYHSVMF5jSZl1?=
 =?us-ascii?Q?qT4VbMWMmlyDq2SURpnnIPY3rpzw4fwoGVsQWg+9skbCumt6Fj1ZNAkhVXgV?=
 =?us-ascii?Q?J7lgECfrSL8zkcqTZLTmssUaOVWdKYuethyf06LXtpjYDKtQxygAIMh6FNqm?=
 =?us-ascii?Q?78WWbfhO6fUCDd42KANt76I8su4S7cnnAh30YcLngb3w9GC5foeugIC/qDea?=
 =?us-ascii?Q?V88hzLy/nA63XuJNeC7jLUHE16YD3CgRZzqRbm8VWIckHCWjFQSWjMqldcZo?=
 =?us-ascii?Q?g7ZTJAab+ERZkGMNi31Bl67KyoOFTTuaJFUMJ8TU2lORwzA/lXgZ2g4xUTMz?=
 =?us-ascii?Q?dQgQYip6nqA52rSADoUqpGAUC9Dbb72WHBCJF6UkNeq/aI7JS7kv3DwKJOTq?=
 =?us-ascii?Q?RUokySfobUX8cILvez4O3UCl1CtxbJ25oS1krRdpSVA+EVVCt4x1EY0zD7If?=
 =?us-ascii?Q?zU4ravGBPmMtpVWp1vMJM/QtizdvkkTs/yar5Dd6icXCGKjRKiPacODsUPW+?=
 =?us-ascii?Q?6swcjh9iKVWQqPZE185QDowVkfvdh1WXNkVj+F6isZcfBNdHXUkm0r627HgA?=
 =?us-ascii?Q?7u7bxFP/n4ApgZEeVWGeAC7zaqfiY9pfONyL2dEhF7xdzLYHlT4VL2SgzhQZ?=
 =?us-ascii?Q?3fEChbGls8yHTtL9sk1bxyNq0GbIV+P8oKQdozULhgXv0JJIGeb4Wg5FHBiN?=
 =?us-ascii?Q?HfyESxMtjsCYJJZSBG38ZQL18FCKQI67pAQf29ZLyMzbYdn2aPn9ibDXQTba?=
 =?us-ascii?Q?H7WANqlK7BVC7tdVxxPsLcs2h2Gh34gVs3K2R1xJR8/OW9P4aKySI2eFyIBx?=
 =?us-ascii?Q?ZXqL+pISpqb24LaodN4NBMx7OZL0xusmJc37bqVrhpK6ASZzDSEhYua0+d3g?=
 =?us-ascii?Q?Aguj+tRNNCIEILgwkVI6SiX/xEQqafnTlDBpAWrXG7r4z6TbRoe4We67o0it?=
 =?us-ascii?Q?TxOiJvFsRQk+j2djVnEWtyZMnt7LdFlbq1s+hoAvLuNwDSVORwZ8yfiZZEdz?=
 =?us-ascii?Q?/I+qwJC2xLWE46M852yMfrbN3cURPX2Ee12r4r+Se+txVkZwbTtuiMUxGBQl?=
 =?us-ascii?Q?ou2yovM0svSi8tyrKx0YNF9dIgCNmW21AtZf5dUEkyknTrar60kOLUqW8bZo?=
 =?us-ascii?Q?XZiqqdiDiqEYo4wHM2bubaCvgxAlAwCN3xPUnARmXIwmPfM0nEIHVVBPOQs6?=
 =?us-ascii?Q?W0MWZ9HzjT1jAlW47twgo5rT+Nq40GmE3L6NGluZn1RkMiDVapHYfBxnSHkf?=
 =?us-ascii?Q?bSOaSh9Fv1f62KJHSmfvfSc6jE6GcQA4kMEPiQN/WWDBZgYSNNmvBgfB/5Wm?=
 =?us-ascii?Q?TjG+8mTw+ftWK9pEMJ8HF+XqhazMMKIvWwufAauKMmqfJtv/dVAbHoEwjSaL?=
 =?us-ascii?Q?LeT4FDrEBuxd/s4UicQEU/kq7W8pll2mlTk5YmVvUuxK/PcGoJxB7kX/QSW3?=
 =?us-ascii?Q?yWHOKGmTpVvFwH2NHSaC6UF2j2ZtGT2oJ1JqzXulJMCANLqJyE5ak9pCR+V4?=
 =?us-ascii?Q?ffYAQQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c541be9-954b-4a15-27b3-08db34535555
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 14:54:32.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xk9IdT3/d0tlHHJsY9bkDjUJZFzUKkIDUl708Pjgwv6h1st2/y2VC01MUzPL8SSpjp4RixSgRIOKzyxDeZ+yhqvLRgIkZ7aOpPFmTEkBO/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5124
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:10:30PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support to the tc flower classifier to match based on fields in CFM
> information elements like level and opcode.
> 
> tc filter add dev ens6 ingress protocol 802.1q \
> 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> 	action drop
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>

Hi Zahari,

thanks for your patch.
Some initial feedback from my side follows.

> ---
>  include/net/flow_dissector.h |  21 +++++++
>  include/uapi/linux/pkt_cls.h |   9 +++
>  net/core/flow_dissector.c    |  29 ++++++++++
>  net/sched/cls_flower.c       | 108 ++++++++++++++++++++++++++++++++++-
>  4 files changed, 166 insertions(+), 1 deletion(-)

FWIIW I would have split the flow dissector and cls flower
changes into separate patches.

> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 5ccf52ef8809..e1e7e51db88f 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -297,6 +297,26 @@ struct flow_dissector_key_l2tpv3 {
>  	__be32 session_id;
>  };
>  
> +/**
> + * struct flow_dissector_key_cfm
> + * @mdl_ver: maintenance domain level(mdl) and cfm protocol version
> + * @opcode: code specifying a type of cfm protocol packet
> + *
> + * See 802.1ag, ITU-T G.8013/Y.1731
> + *         1               2
> + * |7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|
> + * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + * | mdl | version |     opcode    |
> + * +-----+---------+-+-+-+-+-+-+-+-+
> + */
> +struct flow_dissector_key_cfm {
> +	u8	mdl_ver;
> +	u8	opcode;
> +};
> +
> +#define FLOW_DIS_CFM_MDL_MASK	 7
> +#define FLOW_DIS_CFM_MDL_SHIFT	 5

I think that if you used GENMASK to create the mask,
and then FIELD_PREP/FIELD_GET to use the mask you
could avoid _SHIFT entirely. Which might be cleaner.

...

> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 25fb0bbc310f..7c694e7b9917 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -547,6 +547,29 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
>  	return FLOW_DISSECT_RET_OUT_GOOD;
>  }
>  
> +static enum flow_dissect_ret
> +__skb_flow_dissect_cfm(const struct sk_buff *skb,
> +		       struct flow_dissector *flow_dissector,
> +		       void *target_container, const void *data,
> +		       int nhoff, int hlen)
> +{
> +	struct flow_dissector_key_cfm *key, *hdr, _hdr;
> +
> +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CFM))
> +		return FLOW_DISSECT_RET_OUT_GOOD;
> +
> +	hdr = __skb_header_pointer(skb, nhoff, sizeof(*key), data, hlen, &_hdr);
> +	if (!hdr)
> +		return FLOW_DISSECT_RET_OUT_BAD;
> +
> +	key = skb_flow_dissector_target(flow_dissector, FLOW_DISSECTOR_KEY_CFM,
> +					target_container);
> +
> +	*key = *hdr;

It is unusual to just copy the header directly to the key.
But as both are two u8 values I guess it is fine.

> +
> +	return  FLOW_DISSECT_RET_OUT_GOOD;
> +}
> +
>  static enum flow_dissect_ret
>  __skb_flow_dissect_gre(const struct sk_buff *skb,
>  		       struct flow_dissector_key_control *key_control,
> @@ -1390,6 +1413,12 @@ bool __skb_flow_dissect(const struct net *net,
>  		break;
>  	}
>  
> +	case htons(ETH_P_CFM): {
> +		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
> +					       target_container, data,
> +					       nhoff, hlen);

I do like that you moved the handling into it's own function.
But I do also note that this style differs from adjacent code in this
file.

> +		break;
> +	}
>  	default:
>  		fdret = FLOW_DISSECT_RET_OUT_BAD;
>  		break;

...
