Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CE76D00C0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjC3KL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjC3KL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:11:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E737EC4;
        Thu, 30 Mar 2023 03:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680171114; x=1711707114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nx9n7y4bBP5h0xyNQqkwgCTZVbPp3Z/8l2LhnUc7T1g=;
  b=U5l5RR/drZ3mvzPCW7s+FLFR3L5s1yoSvmoWIlSgxUoT6psNqAZ34UaB
   AibGR6v4AJEa6j/MSvcC8STG3eZRaw+eJVSIi4BwLOReUieBBpHbGr2+D
   95PidH9hxdxQ9xPVcdSV9w/24GcvEnMP5IH/9erKtYIkCNBzRuCax5dnN
   d3Yglmo4An/6n1w7QHwMppcmngqJcmaTIh+qkJ9cwYLvQeQRcoJTpRHvX
   Ig1ypFQw6tXOpUeN5IRmFizTH31V69b9cdFcJ2nZHhltlTFVrdD1aunPQ
   igcnIqrcf4SdjQq9CgNcH00sLTjontFUZ/asexGuaFgjObnr45bRVx/YU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="427404081"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="427404081"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 03:11:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="634828067"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="634828067"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2023 03:11:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 03:11:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 03:11:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 03:11:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 03:11:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAxLIfq4es+PX3h9L3Dg+wwRRGTGK5pH8+gNF1v771hk04Y607uhXQaZmz2qULmRZE3Xwx2i+BI4tNHQyoDlIcn5BYk8UT+jR9S3rRanVwFGkpMhuaM/rM4IDSFCtxOCarzRvZNSCukX/KTuERiev3a05n3UMqCPNWAgSVN1dcEiis2MxNP6C1xbd4BWI1cnRuLi0YeOJdmj2W2d36RIxShGRyrC4O94D2wPtkAeGGWMJlerTYr70TMauKAFd6TNSaOpJmJY69RIY/2P2c399HC48ZpDG1BLtg5I3tSjzTfGyatyAeeiUL5BKymJuDN4AZMWnZYF2j5kLzjBNx9XmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u25OuIxZAJ6B54mLtEkRPN7jLUqdzvXg7Yv4cDgxyn0=;
 b=KKtsWIW4kyY9sfD1PxrI8XMTPbvuAc7po9BnkpnG7mnDQkKZJLL+neGfjY/yPp5aKhHwlPZ1+iePfqCZWzuwWI9Fza1qvCE9rKRJnZAyWcMqLoEVsnxPTcAtDqZJ5Xotb1YcFA7R1wbDKty4KS2t9mi6Y29vg9WKub8EK4csBAAx98NjwjZgHJw1WZf8UBrnQO26AzFArBxKXoer+YRoWD2I+YLTdQhySL9PgIB+xaDiwqeyii97LlV0eiSLXpvXsnaF+rLHDWNAVts6c7IOXBG4bNVKk8bcdYhBHLvaCDYCRBPq+RNxyYV9E6vxcnpROYHk4maVA+M59I+dma+p/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11)
 by SA0PR11MB4557.namprd11.prod.outlook.com (2603:10b6:806:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 10:11:50 +0000
Received: from PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::3912:3caf:a32c:7791]) by PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::3912:3caf:a32c:7791%4]) with mapi id 15.20.6222.028; Thu, 30 Mar 2023
 10:11:50 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Andrea Righi <andrea.righi@canonical.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] l2tp: generate correct module alias strings
Thread-Topic: [PATCH] l2tp: generate correct module alias strings
Thread-Index: AQHZYu25p9X/3KO1vUSWWNGmY+PWZ68TGZ1A
Date:   Thu, 30 Mar 2023 10:11:50 +0000
Message-ID: <PH0PR11MB57821BCF8B905AD3B4B06B79FD8E9@PH0PR11MB5782.namprd11.prod.outlook.com>
References: <20230330095442.363201-1-andrea.righi@canonical.com>
In-Reply-To: <20230330095442.363201-1-andrea.righi@canonical.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5782:EE_|SA0PR11MB4557:EE_
x-ms-office365-filtering-correlation-id: 4e0a9d37-09a6-4301-6909-08db31072de1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gs2ds04mi7GZbfWgwMMBTG/Q+hkuZxWmSPYGlhUW/jGuJSkRByj/GTUpnP484/fU7AzHWGNMN5+Hl2iNdc006G32YYCTQYd/2WR1eU18GZn5HJQq4vWmDugJc8vKTbF9Ot1tyObszVKkCzapfOPgmIQLqT9rwlBJCoj/ICysyj2bUA97GduJxTzdXQmw961CAGJjwkmMg6HXzfBqoGJIYVGvmeSKYiOTCEjQLtav2deBxPIa9ZFVoFOGeED9acn5i6diGVG59CMA9hMAlqe9EDtjxZXDNBaYivmi4KxdLYpuUOK0PUU8TYVMSAXq0z3M52rtuO6lXTb7yzvLNLwe5fgUMEZoa2ZzPpdgQyRcipsI6m22sn5QlT3DoiHDBja6rSUP2cy+3w0wBDi36ybwnQZrsnqOeDnM4ZN7KQo4TTXPkiRMoq4Nhgpj1xij/6lIdaGPDcAQN262An/F6DjaEde6h+BwN1qBQKU5qNnTQ0mnylTpmdI9qqqP9HGPjqTXbRPNg8pK157xQ1/rcPDd8LZ1M8od+7NxW+nsIvJKRCNiNmRM++VaaaYHhAw4NpCMwtvnG2CWte91hqWsgr3tCEq0PXIRK6Rtd06DmEh+zLk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5782.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199021)(83380400001)(6506007)(122000001)(82960400001)(53546011)(26005)(110136005)(54906003)(316002)(52536014)(76116006)(38070700005)(71200400001)(478600001)(7696005)(8676002)(66556008)(66946007)(4326008)(66446008)(64756008)(55016003)(66476007)(41300700001)(86362001)(9686003)(38100700002)(966005)(2906002)(5660300002)(33656002)(8936002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2BJ+o6ey4zRHV3MiQdXgDFW5hzKmND7AsZIN5carHKvjSph5tjHo5rerG3pi?=
 =?us-ascii?Q?A01W0kdeMW1XFwrGVvj/l7VkJN8En9LM+AySQBekZNtK2UyeLdFxZyHrR9QO?=
 =?us-ascii?Q?sO+h6Hpm8RHQyNo3dRtMDRzh3QmC2vfJMkdVQwop8SIjNMDX9TDvUMjdNYYe?=
 =?us-ascii?Q?PixhxVIiNqDyfqJuU/imBUvXMnqBDfyUjR7coTyDMPxEnOqu8FSGXsqbOOu9?=
 =?us-ascii?Q?RG8lADJqroWdXzIxzM+3uwsk8Qy1pM0CQKVOOdLKyBvCGyWggXUwHxjUeskE?=
 =?us-ascii?Q?7MJZ6at+9M/xACOF+sG63ITStqOVkeaD5rXs/3y1aINZefL99Wn+nZvzypQ8?=
 =?us-ascii?Q?ileZL8XUnxBSZvK79fFwWNjlXUVshqqtvooMgHrxaVZGX7CTBfFKakLL2QaI?=
 =?us-ascii?Q?ZomaotPZN7OBjWaxGqs33BhEXKatWJVThgS5cqPAKPzFKHY1s0ltAhiDitg/?=
 =?us-ascii?Q?5Z1TIdUhFwzwGdmmENQ2+ERMnuJV4fybtdxDjDAQ3yjuBM2Nj1zJhbm8jrmt?=
 =?us-ascii?Q?DFHTidT1JY2nGU+m5uvTG9zsgORAMVOvW6RuKrZ3Kl0VbWu/DCFf7Wm5ZYQS?=
 =?us-ascii?Q?0InD7+Tsw5mWomb+ifXcjChqZYKnzVp4mrmRkBuBBM4NRFs/FVCpG4eSngf7?=
 =?us-ascii?Q?ylNmSXNIzhzVgO+l0s09pKFCTmXoaLhpKNspHlZDNL7Liw9fYI405jLRvin+?=
 =?us-ascii?Q?Z00YJ2uFk6G+RqWde+jRj2ZP5fMzMte93C9PpBrN1OCzw4/NyfGVUYZvFzDJ?=
 =?us-ascii?Q?94UVNGlxC5IzjQveoXL5WK+uwV4LTg1oW8i2wLFexT2Z8tOBmkZssmeS4bjv?=
 =?us-ascii?Q?ztSv2/5IjHoltnvCO8OrWTEeSgZzeI4BMPamebbD8D+ucWeuLDmc+MJS8VX9?=
 =?us-ascii?Q?6OjSgDQSWkLceDLO6DIo1M8PuAwD+NKnqO/m17Zna4D3fOYWwb0bmHjSeDL+?=
 =?us-ascii?Q?+P5fYvAJGtJi2HKtJHFVaLl4mnyRNZyhIRPhzCowCwdDZ7rdyflY9E4sFx7w?=
 =?us-ascii?Q?sDS1gQaQ+zkymAJb0WN0ABhOKgXqFqBie+a8Y0PSmCIx7Avkp7O29XW7vWn4?=
 =?us-ascii?Q?vFoAhKT20JKDd5owDN2/NBRzUfoGYWyPPFl417WKlCwloE8oQ7QKsGyYbQt7?=
 =?us-ascii?Q?45+Bih2JmrVVBEFZs895MbgHo8mN3u4wulW/hSzhxPgXiXD4YjlL2SB78yom?=
 =?us-ascii?Q?hfs/WemfsmoT8GJjByQBcSwwtJxjZJRNIjiF0c+/rq1dPd/vtyNU3gw5U/2a?=
 =?us-ascii?Q?o6klTZdFhIyNKPSXIQqN6/lFPeCDqSFDltmxeW3rFVmWFX3935ahnfzLN0CL?=
 =?us-ascii?Q?LwQM5qhZLXQ58cV2qrI+oBIp8DX6CfMnvYKJRqHxq7Nu9KmyoLE6Al53Ypen?=
 =?us-ascii?Q?vxJf+wFSRep7OA97gKz+RLFThr0cL4Yvxko7lDXu9kVjtUBRRXVdiwWAbY9I?=
 =?us-ascii?Q?n9cxcVsLTCqyk+bqj10/nG4olJ02kPxcexZowz4/umevOeR4TvpLxJHc0S7N?=
 =?us-ascii?Q?bYr+cuYtdTnPVHWE81oJ4iR20VvMmojmMdk7/knRzSpUYahhe0bvzRhTMThK?=
 =?us-ascii?Q?Icvs9yAQ/whipvshCD44gEOERjt0uLVb+5GmcAkX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5782.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0a9d37-09a6-4301-6909-08db31072de1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 10:11:50.7022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bFeFhXuVTcmzabGi+Gj6aKw/yiSY/ME1gVSTyze2L6jAU7+uY6AFvqy4U6gQ6z2BVfOAvakaCSJX9fnI9Phc8rpd+M+d0rdv+ciPsN0AyqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4557
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrea Righi <andrea.righi@canonical.com>
> Sent: czwartek, 30 marca 2023 11:55
> To: David Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com=
>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>; Drewek, Wojciech <wojciech.drewek@inte=
l.com>; netdev@vger.kernel.org; linux-
> kselftest@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] l2tp: generate correct module alias strings
>=20
> Commit 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h") moved the
> definition of IPPROTO_L2TP from a define to an enum, but since
> __stringify doesn't work properly with enums, we ended up breaking the
> modalias strings for the l2tp modules:
>=20
>  $ modinfo l2tp_ip l2tp_ip6 | grep alias
>  alias:          net-pf-2-proto-IPPROTO_L2TP
>  alias:          net-pf-2-proto-2-type-IPPROTO_L2TP
>  alias:          net-pf-10-proto-IPPROTO_L2TP
>  alias:          net-pf-10-proto-2-type-IPPROTO_L2TP
>=20
> Use the resolved number directly in MODULE_ALIAS_*() macros (as we
> already do with SOCK_DGRAM) to fix the alias strings:
>=20
> $ modinfo l2tp_ip l2tp_ip6 | grep alias
> alias:          net-pf-2-proto-115
> alias:          net-pf-2-proto-115-type-2
> alias:          net-pf-10-proto-115
> alias:          net-pf-10-proto-115-type-2
>=20
> Moreover, fix the ordering of the parameters passed to
> MODULE_ALIAS_NET_PF_PROTO_TYPE() by switching proto and type.
>=20
> Fixes: 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h")
> Link: https://lore.kernel.org/lkml/ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>

Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by:  Wojciech Drewek <wojciech.drewek@intel.com>

> ---
>  net/l2tp/l2tp_ip.c  | 8 ++++----
>  net/l2tp/l2tp_ip6.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
> index 4db5a554bdbd..41a74fc84ca1 100644
> --- a/net/l2tp/l2tp_ip.c
> +++ b/net/l2tp/l2tp_ip.c
> @@ -677,8 +677,8 @@ MODULE_AUTHOR("James Chapman <jchapman@katalix.com>")=
;
>  MODULE_DESCRIPTION("L2TP over IP");
>  MODULE_VERSION("1.0");
>=20
> -/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn'=
t like
> - * enums
> +/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as pr=
otocol,
> + * because __stringify doesn't like enums
>   */
> -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
> -MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_L2TP);
> +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 115, 2);
> +MODULE_ALIAS_NET_PF_PROTO(PF_INET, 115);
> diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
> index 2478aa60145f..5137ea1861ce 100644
> --- a/net/l2tp/l2tp_ip6.c
> +++ b/net/l2tp/l2tp_ip6.c
> @@ -806,8 +806,8 @@ MODULE_AUTHOR("Chris Elston <celston@katalix.com>");
>  MODULE_DESCRIPTION("L2TP IP encapsulation for IPv6");
>  MODULE_VERSION("1.0");
>=20
> -/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn'=
t like
> - * enums
> +/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as pr=
otocol,
> + * because __stringify doesn't like enums
>   */
> -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
> -MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
> +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 115, 2);
> +MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115);
> --
> 2.39.2

