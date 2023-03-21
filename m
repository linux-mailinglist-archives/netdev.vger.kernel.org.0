Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C906C2CA7
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjCUIj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCUIjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:39:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E650D11E;
        Tue, 21 Mar 2023 01:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679387954; x=1710923954;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pu9I2hxM4zwfZyBD4VrkZzXUKZh20furTpTv/iPXkZo=;
  b=cI5U96jvOJSZ3ee5Z69j92Tsje0MQJ1cYl+9QrKKDmNisTzR53JWJ6hj
   K/fLhvjCeo8OMMXAd7o63GpARyjGNnSEjG5IjAcItr/UpH4GO0uciyBIR
   b8vByGwRvPpygOv4tCaytGzxkmyAH4g4hng1tP8WKnSsEa41/rOZMj8C+
   GWE9ywUGKKU/aXtLDZtX5jzXSK2Jz339Kx8T/+DneDa/zTZA2LPjqUhQz
   SPfpegshO0O8+EsuIVS1oCY6Tk2Lfa7z2mIJtYwAmzFZb5FfSC0n9J1Tn
   cSPCsTfBqx9PJn14byLo72HqI9mBwoMFbyR3efA9zIXntf+/ob17WwSo+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="425157489"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="425157489"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 01:37:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="927325631"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="927325631"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 21 Mar 2023 01:37:52 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 01:37:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 01:37:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 01:37:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 01:37:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBdEWRmQtAvprUIYcEmHTpDtQQkWuObtE4klzKxypl2mmDKoQg2FvkrlWZiV2wLxoIZIMxEP8KUskosaDG02B+vfWf7HFJJIurq4afq5wkaoWLe8LzhgcwnAooeuzp8m98MIv4WU0SgLdaF0ScXFRzWBZM0yUp4g9WtqcnBEBzU0WH53ZNlXab2wKDbF3cC+MIH0xllJnyqGTMs5unSYRStB8zpapLYY7rdLLWojs995k3DQiSYVKhuG6iRODHb9hL6x1wo0LsmFVLt37Rqkvzbointvitw9UYSp2MCdwyDArecN4/+RK8wlF4+yiOCu4gNWxzJpEqjolHXxLRjfbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pu9I2hxM4zwfZyBD4VrkZzXUKZh20furTpTv/iPXkZo=;
 b=QD6AdrrvB+6CoHaLjoXYAWhGU4dTu709IBLAtFH/2R4nxMyS5BN1fATzDHin7WBnlurhq4eR2GA9wLT96i00f3HasKOMMP+V3A0ZHhqzClcF0CJEN7OUOp1Bl5qtAUA8HZO5blMJ/jPP0HsrxZ/aiTiZD2eKtdu/5kbGB7fGz/YbANv2tANXsVJE1q4msTKWqsbFjy6ZzoP0QD1dr1g8fpcYIx3c/Wi3+w+syrRAo048pYonZ75/Da1clTbgJMyDBMx+999xFlLF8lZf9lfAB2q1RrEbeiHdbPyc7KANlwxKfqDMT7dCPbqdExRugWSlfUO/hmvpGprm0YFMIywp9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17)
 by PH8PR11MB8259.namprd11.prod.outlook.com (2603:10b6:510:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 08:37:48 +0000
Received: from PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c]) by PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 08:37:48 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
Subject: RE: [PATCH net v2 0/2] Fix PHY handle no longer parsing
Thread-Topic: [PATCH net v2 0/2] Fix PHY handle no longer parsing
Thread-Index: AQHZWRLA2V96Ih97PE6qB0DBs6Mm5K8E7ezQ
Date:   Tue, 21 Mar 2023 08:37:48 +0000
Message-ID: <PH0PR11MB75877BF4D0E96399CAA343549D819@PH0PR11MB7587.namprd11.prod.outlook.com>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <ZBTTg78Zc+Vdyxi4@shell.armlinux.org.uk>
In-Reply-To: <ZBTTg78Zc+Vdyxi4@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7587:EE_|PH8PR11MB8259:EE_
x-ms-office365-filtering-correlation-id: 544196d1-ec1a-4313-d989-08db29e78d19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VQV+SA67rLNsGbc1FOMWiSx4bnnPK8U77NJt1c0u9V2XD+/kOqDF+87kUJ7lqPVegymiNFuPaTrowoH/HkZEmNBkiuMlZ9L/LqUC5vD3qd6/2Ch4mFD9L2sOM6ntJ6Mxmf6EG7HykIA1S+uAl1oUOGyepMzR9uM0hU24U+3k2joaaaqDUhC4n78P7h8RshMWn5TSTwdhjd2WjJ363QyviOmhfhdbovOcupIgatjl2EEffXoYU1DQbPEu2PiBSBF/1rmYfckK1jjwncBRKQhP7Fguauzt5+VAZOpEoogDfzlXfF6dOX1tyDNq7GZD+sqMbvmKLL3HxDHzR0dE6nugOS9uSnoTCjHcF2zp7hqUPE7lsCV0GpUnMYv9v+ctcVqtGnuj6fMQ/fDDV55hptBt7bmS+kpyFSrbr0C1N6q6rrNIjlav/x0k2Dii5NLxvC1SKenz0ems+vp3tXt2k5MfiMN7DBWuKkre4zSM7Cx4B7rcGE0OY7tvSJyFyj9am8YyRCbizkTsqGuNUIoGDOYFZkckvL3uIHL8T2nd0yQzaDtIZIc9iSxqawy694fI7PqOxdzMAzMqUgAJSer6UhN3JorNJjc9mdpG1OOuM2SLiudFg+IL4G4RkP8Gt216nujGx1lO9iTDQql/1CbwSuRfAsQnyGnQxoh6Av1yh7Xsw0MWZ404TC0BtCCx4bbjM+vI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(396003)(136003)(39860400002)(346002)(451199018)(8936002)(41300700001)(2906002)(8676002)(66556008)(66476007)(66446008)(4326008)(76116006)(6916009)(64756008)(66946007)(7416002)(52536014)(5660300002)(316002)(54906003)(86362001)(478600001)(55016003)(71200400001)(7696005)(966005)(6506007)(107886003)(33656002)(186003)(26005)(53546011)(38100700002)(83380400001)(9686003)(82960400001)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ISgBti4fV9dyyIODalQ1x3NpC9xk3tNTmqmvUUcyBAjWXujY2dgzeLp+X5RN?=
 =?us-ascii?Q?9XwHEw2DwMbjRA3rBb17KDJkkkBHh+IlE/MwT63TW3hY35PIwDAXfw1VSerM?=
 =?us-ascii?Q?cv9kNpRqXzoBVBlhOy8PlblphRAHaA2+KM12adefmSZAW76fdJHXdVPoPvmC?=
 =?us-ascii?Q?tj2ndsUXULPtZr/0I2WkRgwc0xlqbQol+1rQMzk3FlZZVX2/hy3M4ruyxjBj?=
 =?us-ascii?Q?JyMVU3AFSvbCGzaa+ezwzlohAbC/m0ztsdkst3S3KOBsZOutyQ5l7Xx64wyz?=
 =?us-ascii?Q?DnOSz+U51jIvJvdHX/8nSXIiOo3GQq/A+UH75J6YqQDTI+fpYHfPuQfGhFEe?=
 =?us-ascii?Q?r/YQWWrp+tmiuH4ajyQ5KtfBcBDFzHHNGEWx7HhfeiyyRUcLzx324rLOuFA+?=
 =?us-ascii?Q?S+XcaPhbwuuFeKp5Tc1CSvkK6bzXRNDD804v8MaOnJ6w/MCBBJ+S9IwTNr/s?=
 =?us-ascii?Q?RYycM0dMZsX1rYAJQV9mjFbLgNjNW5Edwco+7SMZNAlHTFBKhDcrA+hHCaMg?=
 =?us-ascii?Q?Ay/tnOgmXi9TKWYELgWlleIiLlWr+iJS1IpwDd1r38TdC7shJjKes6VSwZzV?=
 =?us-ascii?Q?BEfI/vM2l84npWv/XF4zGzudyvomPGRtTd5ZEHmZfY2bgH8YnS8vm3PSCFbM?=
 =?us-ascii?Q?jy014F0Pef6SZKSLv4MyxK7AOTTeXG1qsDf6Uufh+vgca14ogz64skBeCY1N?=
 =?us-ascii?Q?t1t2M4Ze52JtIHG/+XJfqxZ0prHUb6g9pIlN1SLGXDVkkDg+Guy6u/sjiVqg?=
 =?us-ascii?Q?4lfhLJ1opMt9WcC3v9/RkcWKshUq29eLtB/hAJ5yVG+8S6cVQFcFa3Qt+VZe?=
 =?us-ascii?Q?0WMLntuXlXMb2fvOuy7asXSs+zDN4yQFI0pkdydVcN4Hiwo54ixE9UwJDH0b?=
 =?us-ascii?Q?dOwrr/gveqDzF4So6G5K5GG6S/+OkC4SDN6gUahY7+mTfxlfYn9fy4SLmg6p?=
 =?us-ascii?Q?qkSZaszxvIZ+ofDAzsTzmSSOyxeweXaYq75VD4jqbQ6sRx9NPEhH8yF9V2+u?=
 =?us-ascii?Q?vqv1WsYE+cR84J3Ua5BdPqiAPZip9DrMCrNIIpDAQlAwHUkOCsgACdjyLp9t?=
 =?us-ascii?Q?2clXmnGthY8B3yFNqoTfvB2QWLa68N44zEDKuMpbK0Q+9SLeQAqEWXl5b/a2?=
 =?us-ascii?Q?4akgrLp/eOU13ZGRemakBOVWmgfOSZ1gm3HaZBnT96PgehjmalrUL1HfVk7I?=
 =?us-ascii?Q?TW7+mK+bD+yUHJyUsiOt11gw8a99e33sGk43eGUP9ZGY5dqB083OghnbsxQj?=
 =?us-ascii?Q?wsupYDex8aKVjlLre0wJwshG1khZN/eJKJcnKqCCYOIYtenqGOHD3qete03j?=
 =?us-ascii?Q?/L233BKVY889bYV7hc4VyPpvLOoYeiiVas/1WuP7/3z5ozwE+PYtUpIRiqdB?=
 =?us-ascii?Q?7o0hKCGbm7bx2phfMYCTFG70yV0b/8TqqnbcofxDqlnRQMpcGRT5s9NtBgmV?=
 =?us-ascii?Q?TzfIJBYfFE+k20x8Hg9QEIFFwtDMswSh1jgVycLB7dzd6Pk1++P9jJdwW7Ug?=
 =?us-ascii?Q?RSs5UphSiYXZYR7NM4g6GBZcDW7aFSH5qyTwVF2ISeNYC3MpQzNSCNtyTLs4?=
 =?us-ascii?Q?Ryx4pAuW8/I9bibIYyityXGRT/JVmhBd4FnN6dmc/UiH9khtDc+jYwhtmWbD?=
 =?us-ascii?Q?Tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 544196d1-ec1a-4313-d989-08db29e78d19
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 08:37:48.4210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eSmwEDcdPALdwU2ZuOULIDvX1WtbvBvdGV89M33BYjek0oiS5yY7SjDReXoEDBSYFjqk4dlMs9m2XIoNxdiALroqJROkQTChbgQQe663dOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8259
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Saturday, March 18, 2023 4:54 AM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre
> Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller
> <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Maxime Coquelin
> <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; netdev@vger.kernel.org; linux-
> stm32@st-md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> <peter.jun.ann.lai@intel.com>
> Subject: Re: [PATCH net v2 0/2] Fix PHY handle no longer parsing
>=20
> On Tue, Mar 14, 2023 at 03:02:06PM +0800, Michael Sit Wei Hong
> wrote:
> > After the fixed link support was introduced, it is observed that
> PHY
> > no longer attach to the MAC properly.
>=20
> You are aware, I hope, that fixed-link and having a PHY are
> mutually exclusive?
>=20
> In other words, you can't use fixed-link to specify parameters for
> a PHY.
>=20
Yes but when the fixed-link support code was added, all our non
fixed-link devices are not attaching the PHYs to the MACs, hence
the reason for this patch series, to ensure both fixed-link and
non fixed-link scenarios work properly.
> --
> RMK's Patch system:
> https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at
> last!
