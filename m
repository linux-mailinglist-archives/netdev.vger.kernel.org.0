Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3756E067E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 07:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDMFmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 01:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMFmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 01:42:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CFB2688;
        Wed, 12 Apr 2023 22:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681364570; x=1712900570;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sEBec7tVO/DeVGUjgRHPZfGeL9aCidWnsg/gsDP1aoA=;
  b=BwmQxqkID2lvvGEQnfbKHmVyN8408w2i6QCTmkU4Hmh1y24HRNoGgvDp
   UJNLiaGjWToaUSWP2d/LkBC5lqgWHxMyyjSyUyoFAUii/ryM7D3pF1G0l
   VjA+jatKyn9j0I5Yx8A5POEi11UDzviIOTa/QgK8blz9Lsv6uLCKQYYRU
   s4GHvdSOODm2tix5ZzMXYw0w0i68ieyefyO9Ws0OT7cPtRheJGwZFzx5V
   aDZogrvlFTi9r+6BE1civFxzGanlT7bCJ6akwMIGYwxzIWK5J89U482ob
   BRmX+nYfreiopXp/Tj+ekc3YHQSlpzyruQ0GUHTUNPTjXg9mLCI7KXNq9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="332798956"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="332798956"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 22:42:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="1019017550"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="1019017550"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2023 22:42:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 22:42:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 22:42:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 22:42:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 22:42:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mjz2lwvGcvWE7k/FYOLw62AIILMP3g0LLOj8BOFv4/nX52uKlU+LKJci589FdizN2hNkZ14ZFpQ63+QElLRCUX6RSZCgkNHDbIUHdRmYgqBvJuO0IW/HdTIDQ20vIMta41AIDCC8n8FiXg0c870gOf1tzUOR6ypp+2Xgk/2kUFncLl0+Goy/JsN0uCMmY1upGmTUJfHNHAT/YzlwC5Nju4HYVzvwJ2A1Pg+Ybe+XXVKKMi7jYeuWNQkQh2Xso4drTmSgzXifWrSh4tnFKxa7bPQapK4Nw0qtdNeihbLmd1pDRVdClVOky8pqgq9U1frfPkew77ihXohjkyNc3r+Shw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juBB+A3qnzzRUMSbE1JTh77QTVjqbQMGSggUSwzZS/Y=;
 b=ish4rzjhjrgE5ifE/y1BjqyUCWSJ4AA0qU+M66pB8LZ7ZVuYtWlNJDH3+1Uq0MWCFZ8ybtUX5jzCzVIGdwBEe2MEcfDI9fVVTep7G5q3kz0wj//Gosubn4cHAHKyLTOmGNlj5MqmHdY+snHqQ1ay/o0ri7Ss+Exk9VTUNzDG73RbBYd+VLtic44BQdaQhmjdKeBuG8i+P2/w6pFNd40aNjAvozPGWR2TH2RnKfKlRvq1GhWwGsOtUUNJ24wmAjUCGf0Xs+mfMfY1L8y0OfDPb5r3shhQbMffoAZAeW6vhu3IQsbxShexgxxy2xzOpzrVZu05D4Ll8RcNDc6ZEOrzTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by SA0PR11MB4525.namprd11.prod.outlook.com (2603:10b6:806:9d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 05:42:45 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::22b5:6c17:995:6793]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::22b5:6c17:995:6793%3]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 05:42:45 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "Staikov, Andrii" <andrii.staikov@intel.com>,
        "Maziarz, Kamil" <kamil.maziarz@intel.com>
Subject: RE: [PATCH net 1/1] i40e: Fix crash when rebuild fails in
 i40e_xdp_setup
Thread-Topic: [PATCH net 1/1] i40e: Fix crash when rebuild fails in
 i40e_xdp_setup
Thread-Index: AQHZaZWUkxosyfJ7PkqNOVueR6w1n68mURqAgADiizA=
Date:   Thu, 13 Apr 2023 05:42:45 +0000
Message-ID: <PH0PR11MB5144ADE5243E9A9E1F7830C2E2989@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20230407210918.3046293-1-anthony.l.nguyen@intel.com>
 <ZDWJ0QklJ+bwmY0/@boxer>
In-Reply-To: <ZDWJ0QklJ+bwmY0/@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5144:EE_|SA0PR11MB4525:EE_
x-ms-office365-filtering-correlation-id: f58375a5-4186-4d3c-890b-08db3be1e849
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wF69Z52Yz7SeSdVJl7oO2h6NpzkCuMEPx/VrEBOug7PumyGveevua/Yi40Bb4yqaOgqvy8oDrBZ+szjTtU5er95b3Avt783jZ7RuyXQzsTkk3oEu7Nx0JtMbgAwCbeNeW5VhJOZ+3kdeYc2JdrXiQpxVyXj7C/ncG5pWlWoBV7BsUhchxd9aVng3PSy19YD8PFrFoK/qbw14mGyw3Yb35HfrsLBKmsN8b8Jb7TzoXQdOKdyyp0//Vcm2MhfkYA9SMrbvfq4SbA2c/1ld7dNpm76hKGLlkN9rmmZQEqM1gjpfeFlT9Lh3g4/PUlD3IKGlhXj+l/RNqOYyggO2et3m42CY2g3WWJOf+LwvU5KxF3iBKxVQraPYxisenJ0RC4H4lARpX6dX3BAfc7YXYRTXGhY4br+BdjUWmUF/p8AMlHTF0JDQqvivvffvdNGY2vULoLfYGZDArXxAaG/3wgt7M/WlXc1WHipSY9bDUclGqdzQsEX9kma+1hi1cmBfwpzfq1VhlVY7SRIVIydYjifefHnydhVE7uNtYPXsfb5jXO/ylv4E0jYhbGG/EiEOdYSlCCbrz6sfuAcHrtCWTVZmAq9dhn1hkBZ/RpQbF2JMpqnrHT10rYp9aCsTXQDXvcsxAhMIHx4ycVe5XIjKkewM0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199021)(71200400001)(76116006)(6506007)(54906003)(6636002)(83380400001)(186003)(478600001)(26005)(107886003)(110136005)(7696005)(53546011)(9686003)(316002)(7416002)(52536014)(30864003)(5660300002)(2906002)(38100700002)(122000001)(66556008)(4326008)(66476007)(41300700001)(66446008)(66946007)(82960400001)(64756008)(8676002)(55016003)(38070700005)(8936002)(33656002)(86362001)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hOitVsPFaFfDTYnglkODfEfBf1OTrqguJ/hqxlBGa9OGEXySf7RNd91j+byH?=
 =?us-ascii?Q?chNBvPe/jq3pwAqkSS4CxmNsr6Xl4u9w5c3mXNUG+dIqs3Sv+MMFBiob2Nlv?=
 =?us-ascii?Q?l52FZYIDMBknsCMcWEdGtraQqgYRT/0AsPr6Ggm0jxhnMHAz2b/PszcgO6+q?=
 =?us-ascii?Q?m0R83C+lUVaFfyGXoQgyn4HdsfOrQ+xk8s2plRnyWTjdI/5XJ8qVJk1cZ0N1?=
 =?us-ascii?Q?Zrpatgdoi+iwhNDTvBaIopDeUwWhDFIHjLroOHcS9BxLAiXGBBsl9G7F5Kr9?=
 =?us-ascii?Q?tjeBO8O9BH1sYrZk1R9YiOoGnfLJUOlxE2MRle+sKDKkl/oYklvk3rNmNlwI?=
 =?us-ascii?Q?ZSPlTVy5aq6VdkFbuhNZSkRPzyl94zifnofHrHxKq7ELtJs4AKthM3xNwL05?=
 =?us-ascii?Q?RwuQFzYG7T8TYsLJcO7h8cAZq3HoePcDGS9xXIuYWQA6uLfqVFea+WznnJcK?=
 =?us-ascii?Q?MJoxzgBUxtmwHcmIo3ltESAz8HzU2ypiA3NcV28NNIJrx1XRRL0P9koTSY8p?=
 =?us-ascii?Q?sqN+6Ym59ARXRPv9+BiUXz5EMtmVNkwMn33C7RTes/QWZpSS/ijfa38mRn+Z?=
 =?us-ascii?Q?cZxO/+53xWczX0RJFoca0qrPe3i5CMKcu5368AkQ9gX+ci0vzNt3q31IyGgM?=
 =?us-ascii?Q?+wWR8Y6fAHAsDGleEyCPOB6HfBEGpX/XTOlZw9Q+UYK6S2nDkqiT5ccVekNP?=
 =?us-ascii?Q?uuMHKQ+QH3OenRp4m78pJw0rzc6TswaD/smqnrcZIkOWhdKeM2JzkmccsALk?=
 =?us-ascii?Q?VzPuYv1AxlDHv5/bN1RBRrspo7a6zN+m9yD03t10oKDwkW34VhYtZXsveGYv?=
 =?us-ascii?Q?mte+DgkDxhlUjaVRu6S9cMd+1x7eZ/9/xAIbPDCeIKSR0Aa4730h0+ADlp/Q?=
 =?us-ascii?Q?hywji8+qVu516K/b2yQzMgJbaFkcilCfcVQp/6kuRRqsvJISIk3LfMAN2ELP?=
 =?us-ascii?Q?4cEoI7hlamv0IkoG6JC5DcT16YnEnPdGfeuazD0v0uGSvSTmVYoBQXoIixUJ?=
 =?us-ascii?Q?Om5xQ30D64MGaH4L9wPo2PC/7lVlrGei9/yAInVU+ZgvyA0m4JjAMN9H/gsW?=
 =?us-ascii?Q?rXAvUa8wZu7o1p7UDrH+IhM+0PDrXYtYTvFY6bquE5Xit5uSa9NmepyuNJU1?=
 =?us-ascii?Q?YLpXVAVhcOMEHLldu/28LOOc+lEcKCb7JfnbhzRjSTki2yNkMn7bks1g6f2I?=
 =?us-ascii?Q?k3anWKyUIwoAvAe/tLxPTqcVPbBNAZXfi1sj2jCvASoQi0WjmyRRPXKnHOSX?=
 =?us-ascii?Q?AtVRqE65AE64WTnD+tijyEQNNGcqJEt+ShPAewKvGYzM03a8yp/DdZI/YXBx?=
 =?us-ascii?Q?2KNTukk3wpCNamCzPmJr6KjXw5spExovOk0aRD2oiis7ukr90Gp8Z/32Hnj4?=
 =?us-ascii?Q?CXK+aQvkpYhcszdclDaUuWZfu2ZVdAAaMYtHIohuAOmb1/AfiAT197tqSxJb?=
 =?us-ascii?Q?uEQeBlFOuqQBEvbcHacaA7bne4WqtsHyo3doVhmt4jWJUN51PjzyizJi0hdx?=
 =?us-ascii?Q?I/y+pdVL5SWShUmRhAnxC9yy7FKYhDTCi7by05STpSVTHEC2uWdNDDTY9Tax?=
 =?us-ascii?Q?DH3RTiZcMneC+wtobJOT9T2JR1Q2OZe7vlLrVidF13OF7KWzTJNhOrmYIgUm?=
 =?us-ascii?Q?RA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58375a5-4186-4d3c-890b-08db3be1e849
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 05:42:45.3355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rzEkU+1d+tEMCl1C1LOura5FmnSAN/cux/9nBuIuONZLiZjM5r5ZC1aQf6O3UaOaF8Do2mYuDC1sDC0fNaXTu24QkSvknUZR0U/E7khuEEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4525
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

We ran regression tests around basic functionality. And for stability we ra=
n multiple iterations of loading and unloading XDP from the interface. I am=
 not sure we covered multiple iterations of reset via ethtool -L=20

The crash observed in v4 of the patch was not seen.

Thanks,=20
George=20

> -----Original Message-----
> From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Sent: Tuesday, April 11, 2023 9:55 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; netdev@vger.kernel.org; Sylwester Dziedziuch
> <sylwesterx.dziedziuch@intel.com>; Karlsson, Magnus
> <magnus.karlsson@intel.com>; ast@kernel.org; daniel@iogearbox.net;
> hawk@kernel.org; john.fastabend@gmail.com; bpf@vger.kernel.org; Raczynski=
,
> Piotr <piotr.raczynski@intel.com>; Staikov, Andrii <andrii.staikov@intel.=
com>;
> Maziarz, Kamil <kamil.maziarz@intel.com>; Kuruvinakunnel, George
> <george.kuruvinakunnel@intel.com>
> Subject: Re: [PATCH net 1/1] i40e: Fix crash when rebuild fails in i40e_x=
dp_setup
>=20
> On Fri, Apr 07, 2023 at 02:09:18PM -0700, Tony Nguyen wrote:
> > From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> >
> > When attaching XDP program on i40e driver there was a reset and
> > rebuild of the interface to reconfigure the queues for XDP operation.
> > If one of the steps of rebuild failed then the interface was left in
> > incorrect state that could lead to a crash. If rebuild failed while
> > getting capabilities from HW such crash occurs:
> >
> > capability discovery failed, err I40E_ERR_ADMIN_QUEUE_TIMEOUT aq_err
> > OK
> > BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000000 Call Trace:
> > ? i40e_reconfig_rss_queues+0x120/0x120 [i40e]
> >   dev_xdp_install+0x70/0x100
> >   dev_xdp_attach+0x1d7/0x530
> >   dev_change_xdp_fd+0x1f4/0x230
> >   do_setlink+0x45f/0xf30
> >   ? irq_work_interrupt+0xa/0x20
> >   ? __nla_validate_parse+0x12d/0x1a0
> >   rtnl_setlink+0xb5/0x120
> >   rtnetlink_rcv_msg+0x2b1/0x360
> >   ? sock_has_perm+0x80/0xa0
> >   ? rtnl_calcit.isra.42+0x120/0x120
> >   netlink_rcv_skb+0x4c/0x120
> >   netlink_unicast+0x196/0x230
> >   netlink_sendmsg+0x204/0x3d0
> >   sock_sendmsg+0x4c/0x50
> >   __sys_sendto+0xee/0x160
> >   ? handle_mm_fault+0xc1/0x1e0
> >   ? syscall_trace_enter+0x1fb/0x2c0
> >   ? __sys_setsockopt+0xd6/0x1d0
> >   __x64_sys_sendto+0x24/0x30
> >   do_syscall_64+0x5b/0x1a0
> >   entry_SYSCALL_64_after_hwframe+0x65/0xca
> >   RIP: 0033:0x7f3535d99781
> >
> > Fix this by removing reset and rebuild from i40e_xdp_setup and replace
> > it by interface down, reconfigure queues and interface up. This way if
> > any step fails the interface will remain in a correct state.
> >
> > Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop
> > actions")
>=20
> While I do agree with the overall concept of removing reset logic from XD=
P control
> path here I feel that change is, as Jesse also wrote, rather too big for =
a -net
> candidate. It also feels like real issue was not resolved and removing re=
set path
> from XDP has a positive side effect of XDP not being exposed to real issu=
e.
>=20
> What if I would do the rebuild via ethtool -L? There is a non-zero chance=
 that I
> would get the splat above again.
>=20
> So I'd rather get this patch via -next and try harder to isolate the NULL=
 ptr deref
> and address that.
>=20
> Note that I'm only sharing my thoughts here, other people can disagree an=
d
> proceed with this as is.
>=20
> > Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> > Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> > Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
> > Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
> > Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
>=20
> George, can you tell us how was this tested?
>=20
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> > Note: This will conflict when merging with net-next.
> >
> > Resolution:
> > static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
> >                           struct netlink_ext_ack *extack)
> >   {
> >  -      int frame_size =3D vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN +
> VLAN_HLEN;
> >  +      int frame_size =3D i40e_max_vsi_frame_size(vsi, prog);
> >
> >  drivers/net/ethernet/intel/i40e/i40e_main.c | 159
> > +++++++++++++++-----
> >  1 file changed, 118 insertions(+), 41 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c
> > b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > index 228cd502bb48..5c424f6af834 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > @@ -50,6 +50,8 @@ static int i40e_veb_get_bw_info(struct i40e_veb
> > *veb);  static int i40e_get_capabilities(struct i40e_pf *pf,
> >  				 enum i40e_admin_queue_opc list_type);  static
> bool
> > i40e_is_total_port_shutdown_enabled(struct i40e_pf *pf);
> > +static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi,
> > +					      bool is_xdp);
> >
> >  /* i40e_pci_tbl - PCI Device ID Table
> >   *
> > @@ -3563,11 +3565,16 @@ static int i40e_configure_rx_ring(struct i40e_r=
ing
> *ring)
> >  	/* clear the context structure first */
> >  	memset(&rx_ctx, 0, sizeof(rx_ctx));
> >
> > -	if (ring->vsi->type =3D=3D I40E_VSI_MAIN)
> > -		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
> > +	if (ring->vsi->type =3D=3D I40E_VSI_MAIN &&
> > +	    !xdp_rxq_info_is_reg(&ring->xdp_rxq))
> > +		xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
> > +				 ring->queue_index,
> > +				 ring->q_vector->napi.napi_id);
> >
> >  	ring->xsk_pool =3D i40e_xsk_pool(ring);
> >  	if (ring->xsk_pool) {
> > +		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
> > +
> >  		ring->rx_buf_len =3D
> >  		  xsk_pool_get_rx_frame_size(ring->xsk_pool);
> >  		/* For AF_XDP ZC, we disallow packets to span on @@ -13307,6
> > +13314,39 @@ static netdev_features_t i40e_features_check(struct sk_buf=
f
> *skb,
> >  	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);  }
> >
> > +/**
> > + * i40e_vsi_assign_bpf_prog - set or clear bpf prog pointer on VSI
> > + * @vsi: VSI to changed
> > + * @prog: XDP program
> > + **/
> > +static void i40e_vsi_assign_bpf_prog(struct i40e_vsi *vsi,
> > +				     struct bpf_prog *prog)
> > +{
> > +	struct bpf_prog *old_prog;
> > +	int i;
> > +
> > +	old_prog =3D xchg(&vsi->xdp_prog, prog);
> > +	if (old_prog)
> > +		bpf_prog_put(old_prog);
> > +
> > +	for (i =3D 0; i < vsi->num_queue_pairs; i++)
> > +		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog); }
> > +
> > +/**
> > + * i40e_vsi_rx_napi_schedule - Schedule napi on RX queues from VSI
> > + * @vsi: VSI to schedule napi on
> > + */
> > +static void i40e_vsi_rx_napi_schedule(struct i40e_vsi *vsi) {
> > +	int i;
> > +
> > +	for (i =3D 0; i < vsi->num_queue_pairs; i++)
> > +		if (vsi->xdp_rings[i]->xsk_pool)
> > +			(void)i40e_xsk_wakeup(vsi->netdev, i,
> > +					      XDP_WAKEUP_RX);
> > +}
> > +
> >  /**
> >   * i40e_xdp_setup - add/remove an XDP program
> >   * @vsi: VSI to changed
> > @@ -13317,10 +13357,12 @@ static int i40e_xdp_setup(struct i40e_vsi *vs=
i,
> struct bpf_prog *prog,
> >  			  struct netlink_ext_ack *extack)
> >  {
> >  	int frame_size =3D vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN +
> > VLAN_HLEN;
> > +	bool is_xdp_enabled =3D i40e_enabled_xdp_vsi(vsi);
> > +	bool if_running =3D netif_running(vsi->netdev);
> > +	bool need_reinit =3D is_xdp_enabled !=3D !!prog;
> >  	struct i40e_pf *pf =3D vsi->back;
> >  	struct bpf_prog *old_prog;
> > -	bool need_reset;
> > -	int i;
> > +	int ret =3D 0;
> >
> >  	/* Don't allow frames that span over multiple buffers */
> >  	if (frame_size > i40e_calculate_vsi_rx_buf_len(vsi)) { @@ -13328,53
> > +13370,84 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf=
_prog
> *prog,
> >  		return -EINVAL;
> >  	}
> >
> > -	/* When turning XDP on->off/off->on we reset and rebuild the rings. *=
/
> > -	need_reset =3D (i40e_enabled_xdp_vsi(vsi) !=3D !!prog);
> > -
> > -	if (need_reset)
> > -		i40e_prep_for_reset(pf);
> > -
> >  	/* VSI shall be deleted in a moment, just return EINVAL */
> >  	if (test_bit(__I40E_IN_REMOVE, pf->state))
> >  		return -EINVAL;
> >
> > -	old_prog =3D xchg(&vsi->xdp_prog, prog);
> > +	if (!need_reinit)
> > +		goto assign_prog;
> >
> > -	if (need_reset) {
> > -		if (!prog) {
> > -			xdp_features_clear_redirect_target(vsi->netdev);
> > -			/* Wait until ndo_xsk_wakeup completes. */
> > -			synchronize_rcu();
> > -		}
> > -		i40e_reset_and_rebuild(pf, true, true);
> > +	if (if_running && !test_and_set_bit(__I40E_VSI_DOWN, vsi->state))
> > +		i40e_down(vsi);
> > +
> > +	i40e_vsi_assign_bpf_prog(vsi, prog);
> > +
> > +	vsi =3D i40e_vsi_reinit_setup(vsi, true);
> > +
> > +	if (!vsi) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Failed to reinitialize VSI during
> XDP setup");
> > +		ret =3D -EIO;
> > +		goto err_vsi_setup;
> >  	}
> >
> > -	if (!i40e_enabled_xdp_vsi(vsi) && prog) {
> > -		if (i40e_realloc_rx_bi_zc(vsi, true))
> > -			return -ENOMEM;
> > -	} else if (i40e_enabled_xdp_vsi(vsi) && !prog) {
> > -		if (i40e_realloc_rx_bi_zc(vsi, false))
> > -			return -ENOMEM;
> > +	/* allocate descriptors */
> > +	ret =3D i40e_vsi_setup_tx_resources(vsi);
> > +	if (ret) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Failed to configure TX
> resources during XDP setup");
> > +		goto err_vsi_setup;
> > +	}
> > +	ret =3D i40e_vsi_setup_rx_resources(vsi);
> > +	if (ret) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Failed to configure RX
> resources during XDP setup");
> > +		goto err_setup_tx;
> >  	}
> >
> > -	for (i =3D 0; i < vsi->num_queue_pairs; i++)
> > -		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
> > +	if (!is_xdp_enabled && prog)
> > +		ret =3D i40e_realloc_rx_bi_zc(vsi, true);
> > +	else if (is_xdp_enabled && !prog)
> > +		ret =3D i40e_realloc_rx_bi_zc(vsi, false);
> >
> > -	if (old_prog)
> > -		bpf_prog_put(old_prog);
> > +	if (ret) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Failed to reallocate RX
> resources during XDP setup");
> > +		goto err_setup_rx;
> > +	}
> > +
> > +	if (if_running) {
> > +		ret =3D i40e_up(vsi);
> > +
> > +		if (ret) {
> > +			NL_SET_ERR_MSG_MOD(extack, "Failed to open VSI
> during XDP setup");
> > +			goto err_setup_rx;
> > +		}
> > +	}
> > +	return 0;
> > +
> > +assign_prog:
> > +	i40e_vsi_assign_bpf_prog(vsi, prog);
> > +
> > +	if (need_reinit && !prog)
> > +		xdp_features_clear_redirect_target(vsi->netdev);
> >
> >  	/* Kick start the NAPI context if there is an AF_XDP socket open
> >  	 * on that queue id. This so that receiving will start.
> >  	 */
> > -	if (need_reset && prog) {
> > -		for (i =3D 0; i < vsi->num_queue_pairs; i++)
> > -			if (vsi->xdp_rings[i]->xsk_pool)
> > -				(void)i40e_xsk_wakeup(vsi->netdev, i,
> > -						      XDP_WAKEUP_RX);
> > +	if (need_reinit && prog) {
> > +		i40e_vsi_rx_napi_schedule(vsi);
> >  		xdp_features_set_redirect_target(vsi->netdev, true);
> >  	}
> >
> >  	return 0;
> > +
> > +err_setup_rx:
> > +	i40e_vsi_free_rx_resources(vsi);
> > +err_setup_tx:
> > +	i40e_vsi_free_tx_resources(vsi);
> > +err_vsi_setup:
> > +	i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
> > +	old_prog =3D xchg(&vsi->xdp_prog, prog);
> > +	i40e_vsi_assign_bpf_prog(vsi, old_prog);
>=20
> wouldn't this be simpler to
> 	i40e_vsi_assign_bpf_prog(vsi, NULL);
>=20
> and avoid xchg above? then old_prog can be removed altogether from this f=
unc.
>=20
> > +
> > +	return ret;
> >  }
> >
> >  /**
> > @@ -14320,13 +14393,14 @@ static int i40e_vsi_setup_vectors(struct
> > i40e_vsi *vsi)
> >  /**
> >   * i40e_vsi_reinit_setup - return and reallocate resources for a VSI
> >   * @vsi: pointer to the vsi.
> > + * @is_xdp: flag indicating if this is reinit during XDP setup
> >   *
> >   * This re-allocates a vsi's queue resources.
> >   *
> >   * Returns pointer to the successfully allocated and configured VSI sw=
 struct
> >   * on success, otherwise returns NULL on failure.
> >   **/
> > -static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi)
> > +static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi,
> > +bool is_xdp)
> >  {
> >  	u16 alloc_queue_pairs;
> >  	struct i40e_pf *pf;
> > @@ -14362,12 +14436,14 @@ static struct i40e_vsi *i40e_vsi_reinit_setup=
(struct
> i40e_vsi *vsi)
> >  	/* Update the FW view of the VSI. Force a reset of TC and queue
> >  	 * layout configurations.
> >  	 */
> > -	enabled_tc =3D pf->vsi[pf->lan_vsi]->tc_config.enabled_tc;
> > -	pf->vsi[pf->lan_vsi]->tc_config.enabled_tc =3D 0;
> > -	pf->vsi[pf->lan_vsi]->seid =3D pf->main_vsi_seid;
> > -	i40e_vsi_config_tc(pf->vsi[pf->lan_vsi], enabled_tc);
> > -	if (vsi->type =3D=3D I40E_VSI_MAIN)
> > -		i40e_rm_default_mac_filter(vsi, pf->hw.mac.perm_addr);
> > +	if (!is_xdp) {
> > +		enabled_tc =3D pf->vsi[pf->lan_vsi]->tc_config.enabled_tc;
> > +		pf->vsi[pf->lan_vsi]->tc_config.enabled_tc =3D 0;
> > +		pf->vsi[pf->lan_vsi]->seid =3D pf->main_vsi_seid;
> > +		i40e_vsi_config_tc(pf->vsi[pf->lan_vsi], enabled_tc);
> > +		if (vsi->type =3D=3D I40E_VSI_MAIN)
> > +			i40e_rm_default_mac_filter(vsi, pf->hw.mac.perm_addr);
> > +	}
> >
> >  	/* assign it some queues */
> >  	ret =3D i40e_alloc_rings(vsi);
> > @@ -15133,7 +15209,8 @@ static int i40e_setup_pf_switch(struct i40e_pf =
*pf,
> bool reinit, bool lock_acqui
> >  		if (pf->lan_vsi =3D=3D I40E_NO_VSI)
> >  			vsi =3D i40e_vsi_setup(pf, I40E_VSI_MAIN, uplink_seid, 0);
> >  		else if (reinit)
> > -			vsi =3D i40e_vsi_reinit_setup(pf->vsi[pf->lan_vsi]);
> > +			vsi =3D i40e_vsi_reinit_setup(pf->vsi[pf->lan_vsi],
> > +						    false);
> >  		if (!vsi) {
> >  			dev_info(&pf->pdev->dev, "setup of MAIN VSI failed\n");
> >  			i40e_cloud_filter_exit(pf);
> > --
> > 2.38.1
> >
