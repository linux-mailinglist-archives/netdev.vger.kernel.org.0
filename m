Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C46D00C5
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjC3KMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjC3KMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:12:30 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20C87EC4;
        Thu, 30 Mar 2023 03:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680171143; x=1711707143;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jqh1jYVVrJ2yeSgy0gX8/KeUhG8micP68B8QpOPUeH4=;
  b=m+HrhlYqNAm+0/4goN6/gFN2DLNge3Egdv1CB7HXnObbbKeunBge2yNv
   SZ/Ek3+EDMTjvfss/y81OVsNzf1MxtEkQuAYtRSnTOUUJ+JGiHMQWNIjF
   Eui9yrrwq/h6AzAIwByCXeN4DW0OE2IS+wKvKla8EsDggLihiKMUsMwqA
   aSUUUp9HCNz2cC1lyruV2NJdHVrQQpi26muJu7wF/B71FU4cDM5WPXheS
   aleXOedry2X1YvxDwD6BKimluAspAHjYrSvS/MaDqN/19NchDxMTkBSdd
   21M/vukOWFaFF9dIsi7HjREYABVbGjDrdmy3yLe35XVI/VOKSZimxZ9m/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="321511645"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="321511645"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 03:12:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="1014382066"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="1014382066"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 30 Mar 2023 03:12:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 03:12:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 03:12:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 03:12:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 03:12:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPHWHTIVKg3wxw9XonG6j6xURhb6C/WB26CumfxUiKdZg0q9Kzy1pa4fKOs+7YaatpLQ8SNXYhlOuezR3nAXt7t6Kzg6ob6T5KelObqIf1gCEwH+DKOuZgKHlfQqF4AixNAy/F74vkAmHOP2qhDkajbDsHVP6+xsi/L826Zu97ta4gEIcsXgwBTdGA6s+YvtCIsH3ErFV3V8g4nYxP/vOWP9NZLX9AvFMqKLLxZQIm4mCX4Wg6LJCqhbuVOFI4rPHNKwQKMjE9vKBvDtw+lVZUbKNmcg8ythUQJbGiVatxJH+k9+nN5qvNOf2hJDYbQ3O43xKYxVU9q9w0OQlhm2/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqh1jYVVrJ2yeSgy0gX8/KeUhG8micP68B8QpOPUeH4=;
 b=nPjoQ31jid2hW79uI6KVyhe0LXGLZUT/kn57+jP+gGls7wpb2gq72z+4fjem0okarfIeTL66iiEfF8gN2R48RVY61XwyveiaP4LIM3LXVNdBk61J5UPRymWg1Dk6RzFMMZTl/AdeuklPXnRbfZ3AoTC8Q7yJYW0NiFH0g57/LG44uXqSaPw7AHYjv9Vh/hX0I1qapO4gXOdfUrcuT8YeQveCFA+6bYpfHEoZcHL1h9AAPngYzjGdaNG7tbfV0pwnX1dW+GsTyPKr55hjB7+CRiN7BYcZFET29yCKg1pCUMKiQPXpcVp8zXhyAQXN7z5scK2PRMYW359zIN4l6v0QpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11)
 by SA0PR11MB4557.namprd11.prod.outlook.com (2603:10b6:806:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 10:12:21 +0000
Received: from PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::3912:3caf:a32c:7791]) by PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::3912:3caf:a32c:7791%4]) with mapi id 15.20.6222.028; Thu, 30 Mar 2023
 10:12:21 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Andrea Righi <andrea.righi@canonical.com>
CC:     Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: selftests: net: l2tp.sh regression starting with 6.1-rc1
Thread-Topic: selftests: net: l2tp.sh regression starting with 6.1-rc1
Thread-Index: AQHZYjl1GRPOFSRp8EO/z00nY9tXgq8RxqfwgAAajwCAAAHa8IAAFiQAgADot4CAACws0IAACTkAgAAEZGA=
Date:   Thu, 30 Mar 2023 10:12:20 +0000
Message-ID: <PH0PR11MB57823A4A408304220DECA0E7FD8E9@PH0PR11MB5782.namprd11.prod.outlook.com>
References: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
 <MW4PR11MB57763144FE1BE9756FD3176BFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRYpDehyDxsrnfi@debian>
 <MW4PR11MB5776F1B04976CB59D9FE41BFFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRsxERSZiGf5H5e@debian> <ZCUv+8tbH3H5tZKe@righiandr-XPS-13-7390>
 <PH0PR11MB57829AF31406D3EA4B1D9112FD8E9@PH0PR11MB5782.namprd11.prod.outlook.com>
 <ZCVcxkCkgBmwjnIX@righiandr-XPS-13-7390>
In-Reply-To: <ZCVcxkCkgBmwjnIX@righiandr-XPS-13-7390>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5782:EE_|SA0PR11MB4557:EE_
x-ms-office365-filtering-correlation-id: c8c9cf2f-9c11-43ba-4012-08db31073feb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zyA7krk9hCnGXffH2s84YeY80oTI848SSDezBA7H5ozKSi7sEq3Gw6vHKm1tFnizruuurFZid7Ne7P7K0MFlRg9hUa5JcYhFEIjobbG6nRIRHKp7TD0rZAA9mQLcHVG5UfGxOglzM9lkJqA2LC9pcVsA2d9+Atc4sNThsfbeoRItXi7yq3NZOPYJWwwgBu5VdYaVsGrO6U+X/hOSfPSWGc90SbdvTGuLKIGyjN64oz/qqnAKw2d7sPTZ7NOqZXwZXFsZjGKcFGsMk8xc7Qfob+aRwS2KWfp6soltVNJXECqyei1zVPed1TscvOkj0IVgtoYDZyJm3duMhOKKKCQjI55TXKFsvFsZcDD3J27QMmOWcX1QjT7q3TbBm8THln+MGfWMnaDptHpAKw1Q7/MkGCJH3gjm2lJ4b75T+AFP/4EtACP5RAYi+Hxgl1Uegu9gpWIIvXpvsfvzFOxXQWsnL/X5b4BW6og4TvpfyefN5iJB1WQfw6EqORvSdcyKwQqywcZuovhjmeln+Zcl0MZNfmboM6jjMLrqnSz7dofBgdWbeFyCieAeKTIwruRfwUWCH/Yy+LKyCk55SDFUaD7bUsLWku5TGIZ9ZzEmNZxOkwChU9jtCW+n1Xl3BDlLPSBY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5782.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199021)(83380400001)(7416002)(6506007)(122000001)(82960400001)(53546011)(26005)(54906003)(316002)(52536014)(76116006)(38070700005)(71200400001)(478600001)(7696005)(8676002)(66556008)(6916009)(66946007)(4326008)(66446008)(64756008)(55016003)(66476007)(41300700001)(86362001)(9686003)(38100700002)(2906002)(5660300002)(33656002)(8936002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qWHj8ncQ2Y5aMMke9tXmN2jMI4Yf4v0x1v699TGxwUXcB4MbFBsVlk8DwHc3?=
 =?us-ascii?Q?QY3rcsKzJmhwvuCIFTy2d4LAxbX1i/+39nWnhigIARBlCpv7WRs7X1d0uQlE?=
 =?us-ascii?Q?LO9DF1LaSg5rx8uuHVW0WQjh7n4wySDdThYPdOZC8TVE4ajwYKlKOG///rvJ?=
 =?us-ascii?Q?1Hm6c2CQaLJLEp5SR71Kbe9XQA4XedP1gF7OFa/9liY0oC6hdpZvLIwfQQEz?=
 =?us-ascii?Q?yL2Lse1bzUtUdQH72k64fF0HJL7g46E41UnSrWbVJ22AXqWHfJ7v5giES7nE?=
 =?us-ascii?Q?b21cXfPD9XyAk5mtuEftllln2+SEMwo9BjUOjP8urhxdy8xsT7ML8+eh1KKC?=
 =?us-ascii?Q?sdALR3BkKwo2kOKBJVLsjjihQOzp0B0NH8fKi4yex31QgX/Wf5442XNbe/LI?=
 =?us-ascii?Q?VJvJbfzDLSOEWMtx5hyHSVqSTkKLGCmm2EJHQrV3JujEY1uiFxBY2t+XtlqI?=
 =?us-ascii?Q?shX8HbocyrfPOOF5ieNUVA/hV5ON9qVhZGBDvuZRnIJqN0dgad6JxrahXyO3?=
 =?us-ascii?Q?A6r0yoqGFhUHLdzaQgKY56wMrV5PC9jB0peAa8uoHKgc5Ru+SDuzpb8zldjd?=
 =?us-ascii?Q?TdYRY3BzNQ0f+Pmp02ovkkrGrJB1k+pBbIf9OAxm9i4mUu52Ns5vVo3X4bUJ?=
 =?us-ascii?Q?cNcCYdYZaSXXJ5By6lAZr9viN6EuA6KcByMoo73tX29B48wS9gQExmkSDy8n?=
 =?us-ascii?Q?EGeTwoo/Dx1GNdfJ53ZDfdtctE7gogroZ6zAQ5bGARuDmVWBQtk2rPy69JFN?=
 =?us-ascii?Q?d29gvxirtoRkO6dTDeGAniolDL3jxtwEmzxBJvw4EOhlC56vgcOHQeo2O8JH?=
 =?us-ascii?Q?KREpm/4yBO2WCVOvKhQaNDU8xpxkqoXK/XjPOOKJgP3HFXZ/Z38X+7EoDVKW?=
 =?us-ascii?Q?6G9QobURstadmLhAqLKB+baVPaToudgd9o00SvCmenNfRbx84HOc4yy3O6CK?=
 =?us-ascii?Q?YSo1NcXbUIazcg5mIfbIonUnoPPgkCKLShPeYgKlG8fMztsmRedKYfaiY6Zn?=
 =?us-ascii?Q?RfD6FYwm9DR4FB+jmrvvXwFzYEyOuf323uwuUHyq/JQtS9VZIA/xll8t/4+U?=
 =?us-ascii?Q?hrvb73p6QJJqObE3x6dJ4rJkVi0j0xvEU6vP/Pbv2BxQuDszzBv/z/ypDho6?=
 =?us-ascii?Q?5vzlnXsePXPAq7qY2LiiXvm0Hz+OSzOU21OnFMaTyGTeND4UuTN9UdYGr4bR?=
 =?us-ascii?Q?8rV0Cy9pYN/DZ3dcXx616ZyZko9cFdMOpemdtT3zZ4oKdPpTXi+gnKr8tZPS?=
 =?us-ascii?Q?4w9iO1AIWujYASUZwMiD+CE9km59P+rPzDaFaUsHziyu7C2wB4bGiDIIIDBf?=
 =?us-ascii?Q?47ceEO2jCkreApzvl3CwrmX99MeUJwnoKSMm2ZeMpL2N2gIzmuNNfK2y1949?=
 =?us-ascii?Q?YMhxKevgwDFufbJZXAzjn/wMk5MhbMBpDpBWApXc35Rfpv2It9sLtJMWybJk?=
 =?us-ascii?Q?FkpQJVSwztSJ0lF6x7wTKBrkO7h6hj/AUxAXmq4IZ7TN3XarJr/Mi22gfQ6y?=
 =?us-ascii?Q?xhw+A3wVYpy4griDvJ/5BpijYY5MMhfPJP4prQ8Txhe22ev+BUU0P7dLKqjZ?=
 =?us-ascii?Q?E2vjvmGsOYGMh6o70X/OnT/oiqcN2IFpKg1zz5dj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5782.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c9cf2f-9c11-43ba-4012-08db31073feb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 10:12:20.9607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E98V6lxRCinY5EGGRFUlm1DI+ChZV89PUmV3jGGwxv0KBar3hS9fYGDvmJm4IAM/7XY0Kz/AF8/YPlXHw6BYGlqg9tG0WFQcociIopQRRso=
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
> Sent: czwartek, 30 marca 2023 11:56
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: Guillaume Nault <gnault@redhat.com>; David S. Miller <davem@davemloft=
.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Shuah Khan <=
shuah@kernel.org>; netdev@vger.kernel.org; linux-
> kselftest@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: selftests: net: l2tp.sh regression starting with 6.1-rc1
>=20
> On Thu, Mar 30, 2023 at 09:26:06AM +0000, Drewek, Wojciech wrote:
> >
> >
> > > -----Original Message-----
> > > From: Andrea Righi <andrea.righi@canonical.com>
> > > Sent: czwartek, 30 marca 2023 08:45
> > > To: Guillaume Nault <gnault@redhat.com>
> > > Cc: Drewek, Wojciech <wojciech.drewek@intel.com>; David S. Miller <da=
vem@davemloft.net>; Eric Dumazet
> > > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni =
<pabeni@redhat.com>; Shuah Khan
> <shuah@kernel.org>;
> > > netdev@vger.kernel.org; linux-kselftest@vger.kernel.org; linux-kernel=
@vger.kernel.org
> > > Subject: Re: selftests: net: l2tp.sh regression starting with 6.1-rc1
> > >
> > > On Wed, Mar 29, 2023 at 06:52:20PM +0200, Guillaume Nault wrote:
> > > > On Wed, Mar 29, 2023 at 03:39:13PM +0000, Drewek, Wojciech wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
> > > > > > -MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
> > > > > > +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, 115 /* IPPROTO_L2T=
P */);
> > > > > > +MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115 /* IPPROTO_L2TP */);
> > > > >
> > > > > Btw, am I blind or the alias with type was wrong the whole time?
> > > > > pf goes first, then proto and type at the end according to the de=
finition of MODULE_ALIAS_NET_PF_PROTO_TYPE
> > > > > and here type (2) is 2nd and proto (115) is 3rd
> > > >
> > > > You're not blind :). The MODULE_ALIAS_NET_PF_PROTO_TYPE(...) is ind=
eed
> > > > wrong. Auto-loading the l2tp_ip and l2tp_ip6 modules only worked
> > > > because of the extra MODULE_ALIAS_NET_PF_PROTO() declaration (as
> > > > inet_create() and inet6_create() fallback to "net-pf-%d-proto-%d" i=
f
> > > > "net-pf-%d-proto-%d-type-%d" fails).
> > >
> > > At this point I think using 115 directly is probably the best solutio=
n,
> > > that is also what we do already with SOCK_DGRAM, but I would just upd=
ate
> > > the comment up above, instead of adding the inline comments.
> >
> > Agree,
> >
> > I verified the fix on my machine,
> > Do you want me to send the patch or you'll just send below one?
>=20
> Sent already. :)
>=20
> -Andrea

Thank you!
