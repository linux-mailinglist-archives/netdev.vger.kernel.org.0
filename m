Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748C859A763
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352048AbiHSU7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 16:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351994AbiHSU7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 16:59:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9492C2FA1
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 13:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660942773; x=1692478773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UNxK+TVNrJITNGhmCD8jvY1RswPfQhSoCACffiKgnlQ=;
  b=ceo09oR2odzFmSCddtkdniVx/sqjuaCBlNCUSm4M4a/7fAzEseUQUxmR
   lkaHX91XZv3s493n5FTC3iOaYmfeGRugBrgwCFI+NTjJ05P+r/DA/6E8f
   bOkoWLHNSTzh4xSCLBBAID3IiaYHMXRmEBLRJqTu3EA53y2rCGnT0Bs/T
   tExjmA6S+PKgfmjkLQ/amW1UHmn4U7p3PU3gV0RBvHg6B5KlC6rIKXPPO
   vT/Y5lk/NO8ZxxEx+WXBM2K5pP+CUFnyvqX/NnEjdrJOUnaObK1lKk4e9
   ammzy1MM9B5s4Zx+k3YNd2V7WMtyux8Y9KXGtksqMlXDJYePx73CT116x
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="291850838"
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="291850838"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 13:59:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="750650377"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 19 Aug 2022 13:59:32 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 13:59:32 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 13:59:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 19 Aug 2022 13:59:31 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 19 Aug 2022 13:59:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ibz0ktgoQr6+kG/BjfTfqH3DlF76xNJUfyPD8RLbBVljawNeTg9ZURUnvi+afNEzJh2yQ7nD6zoJTsFiDkQFvPqtII+9uGW75Kfv7TJRKXUTa+jDWgavNyxAzSMagHsCfO1+5VK91mFrfhBQ/EmjKLLdAal8mlOGBYQ+wd6/lEoK5zaI2HTfWsJgNZw4ekbKRAP3DyGS9FJg7B9Q05fv5zR47VnhldV0FQYvO1DoNgfCc4C3RQdSuvxWqDSIXjIR/1aQSrrMHQv06nbzb41ILojJdwIYdzM4YjObYuZxhZqodp/k0FaFF4R9lIaR1XbFqkR2+Pe9NM2G8dC6I3N3Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNxK+TVNrJITNGhmCD8jvY1RswPfQhSoCACffiKgnlQ=;
 b=cTA0sjUShaVtivm52GESxCOJrAXJY8CqfHERsN1fvv77IseEsDVzxFKaPeUf1D5ae8iQFAwDK2vYEWQdVtaIkuRBrVBFIE5CIh7wOJMZMqJUsPzYnciVOnFrY056wwfiFMhW5t2X4Xh+IM7ibEZAU+qRoNsu/ODmYd9tn2OF19/E6tKUoLJ88/n/Mi53T7FDRHfHQwng8ipTJnNSIrdSFc87LHgri7L7ZWMDHVxeGtY9C4WdeowCE2Wlw2nMgQ5Cc4iN6ZKp4cpyvmWJ/k3l48EzyykKxg7QhZkPvjs+SqKSbqMRKC9oN9Q4PObM2PYAcgMk4dphfBBbTqAeVfaGdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN6PR11MB3181.namprd11.prod.outlook.com (2603:10b6:805:c3::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Fri, 19 Aug
 2022 20:59:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.018; Fri, 19 Aug 2022
 20:59:28 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: RE: [patch net-next 4/4] net: devlink: expose default flash update
 target
Thread-Topic: [patch net-next 4/4] net: devlink: expose default flash update
 target
Thread-Index: AQHYswKc72t683aiKEGZcmtd4DX0Tq21h5GAgAEvM/A=
Date:   Fri, 19 Aug 2022 20:59:28 +0000
Message-ID: <CO1PR11MB50890139A9EEBD1AEBA54249D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818130042.535762-1-jiri@resnulli.us>
        <20220818130042.535762-5-jiri@resnulli.us>
 <20220818195301.27e76539@kernel.org>
In-Reply-To: <20220818195301.27e76539@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05521068-97a4-4524-c0dd-08da8225b4ed
x-ms-traffictypediagnostic: SN6PR11MB3181:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kXrH0DxCmI+NQ9iHuf1P6rvFuuhODeuQMHCtnO2HCyFdacHBaxxg/aRg7ocxgCNXftX5tqDjKV47Yp93s8gOHOShdlgwG56SpxAQoc7f+s3msp21ym5JJCB7kAqcs8Z7DwSRlZygEKDSOp3tTcwA6+BId55cCka+1aMYs3msP9vYclhlHKhZx0/EubrxwQIoka8sobXpN0oTWuR3b5387EJTJ2lDx9L2biYDkjpoyAulMDlCJ40NVABsyZTfW+5C1Q8v9e+b2NC3425f3rjR/ryPUOkZGFvZVZ5BIusnrPOtim5mKtBELL3z0c3XfP9dfTm4reRTUH0JvPhutnx5dn51hO75KwFSAeoDeeJ6xy0Nfhy/a+Kh2fsU07onjKMrbpKIhu0G7bdc0/cW6dmfJzOm9IMOSYMPfbi8HLv8V6qk/IglHImFr+oN6OcpSLuXSZjhKeC78zFXSR1NcbxFTEQ6A9JiXvwJCTQnKgTqdDzO0/70XG0KikR/fRju2Y1mzHqFaLo0mpqhkX1ne0rVnRlru9Wg9sOR0RTSAcVJqqtwAGoUzQDHu+z8E9M8wE2GerNas6IB3Ka6HTYyI89FZAiO6C3Q8smXqduk4A3Nd9KJSXeFblGjotQlb2ua12KUQ4MrHG6T+BP/KE2XHbNUcFrOOw5zHhA0/wb/TysISWQg0M3Coj99OI7WJoAx6Nn4ZDj6r5RERPlXXUSO2ot4mYAPI2tCiyXuCASSh5ayF94JfhFgKsaZW5uvFy6842CizFY8stdfvqZn/Bb7dNmXug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39860400002)(366004)(376002)(396003)(186003)(53546011)(33656002)(82960400001)(7696005)(86362001)(38070700005)(6506007)(9686003)(122000001)(38100700002)(26005)(83380400001)(7416002)(8676002)(71200400001)(5660300002)(478600001)(55016003)(4326008)(2906002)(76116006)(66556008)(8936002)(52536014)(15650500001)(66446008)(66946007)(64756008)(54906003)(316002)(110136005)(41300700001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4aG2/Q3YYbl6F1bsVasvJPj5SQzqZchN5v09W/rLXfTL4noqC8lqWFxxXMSz?=
 =?us-ascii?Q?B+rwtGBNfF78Fu2scFFTdtZZxGPjkYfVGv+s80AvamtijAZsu26TmGtoi0b+?=
 =?us-ascii?Q?E7igmqZQuSW80NhOxiEC9FnNMr9PaSFxalLEtIvg6jUq902B9F6q4O4Usvo4?=
 =?us-ascii?Q?KFnQEFg0bFP3z5oCTSGebCxNUxjJgVle3qLMe702Nbo47+o2JRPZqt8yBd/H?=
 =?us-ascii?Q?e9hMhn9C3EKADEHRBUD8mXAJ3n7Y2hCGI94vd4ueRdx2/guVwnrAZtMhT5H1?=
 =?us-ascii?Q?7rvl3Bf5tSoyEmW4iltutZH5R47PnXoCC0cpUflI2K/p8qg/TNOPup4bboYn?=
 =?us-ascii?Q?RbqhlEHaTGtEg95do/Gbt9/885YcI2xU624R7VQLec5Kmm0pWoZ0NfhZrpJy?=
 =?us-ascii?Q?zB17bzTL8iYjx5xNaNBGIAEG0jg2LPzdExaqjC8ZqpZhISCgFMdw/ja4PxUn?=
 =?us-ascii?Q?D8qxF8GAhwWT76YuUL0M7tyRNaKcsI3yrOgUPuhXpvszpoSD0H4j61Jb7VDh?=
 =?us-ascii?Q?f8StV4eXwFAydqrcR0CIRv0cWvUIBJcDrpfjt5YXAJlEu3Fm8mRAVH54qYbk?=
 =?us-ascii?Q?MaCJYudwKVjqP1L8LjnV9qNLVumkzVAAMdk1efsWzHGrDIvfhPJFY2Vz0H01?=
 =?us-ascii?Q?uK9RqX+7326KsoQO2cWzBR0b4b0ibIJN4SLvxC10W98bE11C7dY7B9UjONaU?=
 =?us-ascii?Q?ZpZLPB722iTxA26zTXIEM9JYtg8OrRfLIjlGegOZqvlnpacCWiihNeatxJS5?=
 =?us-ascii?Q?G2kgfg0BU9aE6uDHJSbzrDrw+bO6+m550032JUMnzJFFt2gKr2xfEAE4Nelk?=
 =?us-ascii?Q?CNCabi03pd92gNiE9HlihVEYTN7gGHbg+w6J+CZ8jlx13qRX5+0CITi6q6mg?=
 =?us-ascii?Q?D7XgyP1zylyRdmfw+mNuUYdUsaGOL1vOIIvQVHlytaH7fO3y4BDkB9gcdwZK?=
 =?us-ascii?Q?vDFJiGuMZDnrbgG79G7oHyVFqBpAT5w85igBjaURjb5Lus+XgKt33xE78Hq4?=
 =?us-ascii?Q?BF6hUROlV32NCs82+vcpH6/QBdrxw1kVKrNqQ84SmlwyDu4yUlQ7Q+W8qrbX?=
 =?us-ascii?Q?4iNMVZt8IOg0kKcyEt4+X2Sx6bfImKPqympotpeh3mzkrmPjJmucKRTL+fB7?=
 =?us-ascii?Q?IOfhqhcwfUp/uSvCcafgsFFvrLdBHJpmFWxan0gFbKu/TYOFhC3Rn9aMw0tn?=
 =?us-ascii?Q?epwQEsh/ZX8wldKXF7l+vEmjHW6Bi1XfbNxrcqH+nnqL7TQSCCtVLG6bRBVX?=
 =?us-ascii?Q?PzjifVa+WY3m2HcWRa9HFsFyIfTzYr30qjwCl8wimlwIpvJdxJLLKzQy+PFq?=
 =?us-ascii?Q?PmuRepKImgTtueYEMCzZ/QfM5cLbbvapa5ti/IYtQ/oqk0CyibiCaAn8AS5U?=
 =?us-ascii?Q?6vjNWEF4voP1eTC7JIBjTF3o5tyrRiilJ3Vx2P194AYi5FfCqTkdE1wvILqJ?=
 =?us-ascii?Q?Jpq1Pv2yk0QRL/FuI/oTgTN4Yk0AxwVSwmlq3OhKZQFIwXkLsL1ssKjobS1T?=
 =?us-ascii?Q?5ln+czJWUpbiw5/JK0pR4zgkO4O3jG5igt1jeU2T4bu9xLqBtHsIvRupzWuu?=
 =?us-ascii?Q?kcqy7txOj+qqBN9eTuAAxdk0lX4R8SG+aocWS02m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05521068-97a4-4524-c0dd-08da8225b4ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 20:59:28.7071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9KRHM3ZAaE8+/57q0VH62QiBvLdIxg5Uv03k7a/HblqCTogVSC/wEYhvZazJ6iHV2bakRkP9aNlGtv+Tq5ha6vqMxg5stfuwP/U4225zuOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 18, 2022 7:53 PM
> To: Jiri Pirko <jiri@resnulli.us>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; idosch@nvidia.com;
> pabeni@redhat.com; edumazet@google.com; saeedm@nvidia.com; Keller, Jacob
> E <jacob.e.keller@intel.com>; vikas.gupta@broadcom.com;
> gospo@broadcom.com
> Subject: Re: [patch net-next 4/4] net: devlink: expose default flash upda=
te target
>=20
> On Thu, 18 Aug 2022 15:00:42 +0200 Jiri Pirko wrote:
> > Allow driver to mark certain version obtained by info_get() op as
> > "flash update default". Expose this information to user which allows hi=
m
> > to understand what version is going to be affected if he does flash
> > update without specifying the component. Implement this in netdevsim.
>=20
> My intuition would be that if you specify no component you're flashing
> the entire device. Is that insufficient? Can you explain the use case?
>=20
> Also Documentation/ needs to be updated.

Some of the components in ice include the DDP which has an info version, bu=
t which is not part of the flash but is loaded by the driver during initial=
ization.

Thanks,
Jake
