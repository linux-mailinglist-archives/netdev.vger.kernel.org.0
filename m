Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D7454A3E6
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 03:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350095AbiFNBzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 21:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242358AbiFNBzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 21:55:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5137133A1F;
        Mon, 13 Jun 2022 18:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655171702; x=1686707702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4ZnxduaCLXiomZd8Y4JkfemCPzBl4DpRSoTH8ZmB2Ow=;
  b=L5awY5D6iR0GjoKFMXuB85Np7lYKrCe4F2hpWym9Ws6bIaIIf1TQcASW
   3mpPYAioA1OUxPbapDWBOX2IyIU083Fp7FJGGSSo/n28f1I+NcMETTcFe
   MvyR8CQAlI94vy001AqLHrxGxjNUA3hzRLsK8ZCyKoc2zw6p/4/UI5dXE
   0k/wK3fS2j7yp1egClhMVH6jieGJfhrk9WS8qI1Xq5yJ3TqJfAgWDZyB9
   t+I9Ctm0DHnUJ0IhdUvUWNn+hQwcrtZO4AeOi/+pl5A51t2VtpBHFO2NO
   ePvLwiEKz5ZmETZBFm5wK2loLAUOgtVjza03mbmFdIbmpyTcZyeDdVca9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="276003835"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="276003835"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 18:55:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="588143891"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2022 18:55:01 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 18:55:01 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 18:55:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 18:55:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 18:55:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2ftrzoUrEMaDietpBE0pDCpS8ZcgAz3pACVcVhKKBntsTjZc6E6rdgkq7sRpcFp0EG0/+nMRPuu8kFBbhcnljKSySsbG/ivHuMD5OTsSFsxGZdlr+fDAt0hDOlHA/zORZTnyj6B3/VdkHKvDi2v8+jY3oHJ7TSWeyeMw72XB0bOzJNtD0BK394wMBlkuS+QvXcaP5PF93cUIqRmC8u7ZuTV8hdhF61YnjZfNXfCm5lYSjxOaqpq0nTjIVg77+3dWtGt8xljakY2+UkUnGR3l4/DL4RnH0BY2qKABarVu7jchFKTMzDKFM4EDO65nErymG0etYNZd2wVCr+F9G36Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fthO05W/uFXbZqLxuRXf0X9McCXs0am8Gjcr2bh4aWI=;
 b=n/e+2Z1yLd8EgfwV2nqq+j/pBy6sF1T20D3auAggCDV2IGujkEChjJzX7s8Rw4uE6AeigrmgDuFheqPNKv82lY/MZ5pxSqJFBUU6CewPyIVrtsdpGms4/hPw4abpqDTXqOIBN1k2E3zrsbjYVdmGT2eS+kVm9049FsokZ1ToreHt6RSqDDngs5aB22uOJH6VuhHJoCV8v9FeGKY1icnKTbPeE/pRH0N90IfCxjLlo1rQFFCceXl/O9Go1Sx/PfAkjT4f+imZbRFcR2y6+SBdpK3v0c4VXVt7KXRlHB3+OtcbLytaXgw931lNfjLlrjsAozwdl4MKNTR/ZJHIsseVFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6095.namprd11.prod.outlook.com (2603:10b6:8:aa::14) by
 BL0PR11MB3025.namprd11.prod.outlook.com (2603:10b6:208:79::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.15; Tue, 14 Jun 2022 01:54:59 +0000
Received: from DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::40e5:e77a:f307:cbb3]) by DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::40e5:e77a:f307:cbb3%4]) with mapi id 15.20.5314.019; Tue, 14 Jun 2022
 01:54:59 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Riva, Emilio" <emilio.riva@ericsson.com>
Subject: RE: [PATCH net-next v2 4/6] net: phylink: unset ovr_an_inband if
 fixed-link is selected
Thread-Topic: [PATCH net-next v2 4/6] net: phylink: unset ovr_an_inband if
 fixed-link is selected
Thread-Index: AQHYfHsNhgn9gM3W/EyGBireR1rHYa1IPyYAgAXrJFA=
Date:   Tue, 14 Jun 2022 01:54:59 +0000
Message-ID: <DM4PR11MB6095669DB87FF30288EE2B9DCAAA9@DM4PR11MB6095.namprd11.prod.outlook.com>
References: <20220610032941.113690-1-boon.leong.ong@intel.com>
 <20220610032941.113690-5-boon.leong.ong@intel.com>
 <YqLzPrEfcwqeKNX0@shell.armlinux.org.uk>
In-Reply-To: <YqLzPrEfcwqeKNX0@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2b4a1f7-c515-4d9f-0a3d-08da4da8e383
x-ms-traffictypediagnostic: BL0PR11MB3025:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB3025DEC25ABF28A2857B418DCAAA9@BL0PR11MB3025.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yGUsh5Uzlq4WoHIc4iz1i8F0dkfNuIHqcOBMaqiLN5QjrUKXPVMos2tkGvwRzMVSkheuAWKggu9RY/VVPV1dZvd/MeArjOwFl+k+CeU4yT6omt4cuJMtI+uUHyfjWRlRRAN1ltc/pWW9hyFw9PhEUFLagEuFiRbW8PehpPfpFhxtcsdM4wLkpQTueFTYvQZJAfECiIES+78+QQew1kTPRLIs1LSepD3aiNMMqp5/JyPwZcOBSjEmOAzUWbSs4Y+RdIbg0zFJ4a5awRdo6XT/+zIdViCX4DjrUWpLytjoIZYDOt52opVEK33c3CCo88aolJ377yBWRSPyK+rmWUWopZsIq8uZtNFR3xMh2ZDY2R/efuqmEEcKUfXoDE/twymzF7WOGfJuOobldk3huccpN3pveNmEKf+TaK/Epw5xlkt4YIo/fqofYKegr8duCu9+ezT9jYBhzeF0IlSV398lr/K0HCPAYinlhJ5eonmLs1UJQel5TDj2f8bTl5hnX+oU6i0WBOWdr2F2TA2DS/DYycOdqPeRDLRdC58/N970bT2/HdK8+d7Zt/OYuv4NgbLYBioWx/F6RmSMRnxxVfNLNaWSo/eu4oEEyIA5rHcMPNxWhXdmP8CKF9eWRmOxA3DALuKAE8yN+K/NwjpS8yL+6x7mJgGsP8hYTVkGnhPJznluyV63ePtU9bK6uIXLkXoXl7aEUeR0yJSqX7GhHHfhgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(186003)(38100700002)(66556008)(316002)(7416002)(64756008)(122000001)(7696005)(26005)(9686003)(6916009)(54906003)(33656002)(83380400001)(66946007)(8936002)(6506007)(508600001)(86362001)(8676002)(38070700005)(66476007)(71200400001)(55016003)(52536014)(76116006)(66446008)(2906002)(4326008)(5660300002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fV2VglATmwWj3AqgCS5LEkOINSejgq7zyWTgw2oX9G9NXSG5fUsAtqXj+oYk?=
 =?us-ascii?Q?WmARXwHNzN6Szpb0zQOA3b04kZtOFWexQNFi8NJpkEr2idxwj3XZo2pdyVxM?=
 =?us-ascii?Q?Hjpobs0Jk0MHOR9THC2zNUPH5iqGyUBLhhXuWP14ARgMh4xo6hu1f9LVGRdw?=
 =?us-ascii?Q?ykrzfKRYQ1epzbk4nmhPEAK9wdJ2i6gHOZkSSzY1IcZ2AIIonOZ0+TSJ2Hf8?=
 =?us-ascii?Q?sXlt9J8PVInCqWjiWxKlTX+jfMiotSXCRAoZxpKtUoVbjr7ikYrIu+xXcL90?=
 =?us-ascii?Q?sROjUxLa+WykEp/Yk/A7YWKdrXLTtmqpdrh0z69SQv/01o4RfJQd8M7piZDt?=
 =?us-ascii?Q?uZxnpSW+kIwxRH1v7ni6RMit6tqIzZqflaFhBD00GCgoWrtfTuyiPy2tUHur?=
 =?us-ascii?Q?EKrJAUgXwDhxvDs0BCqvBnfl0cJlcKz3zVYIrEjqwhe67GqZ+C8RHVbFAovn?=
 =?us-ascii?Q?aNdlaDbAHog6AdiA1nrhWr2aOHgVspnHA+efIr7gBn/sLeQJzTFr2o9Dxazm?=
 =?us-ascii?Q?irkk63k5xFr+E/yW8X07zslURszZJX57+TPFbOSOQy2exFJjwICyRBaJVXBL?=
 =?us-ascii?Q?+yudweMxwMNg5jczE2uuiYNP0aoOQuAGTh/9Ytb+G91Ar56f+09lH7QM2Yq4?=
 =?us-ascii?Q?CC8L0BzBOnl2IizGVIp43TuUiI6APzmjXjXydXVzqCG/VacZJ5VgwmRBTlGb?=
 =?us-ascii?Q?REXOozM6Sv/gVzV3c4pIafHkUMTSYxRHDRJ2uZ1i8vR9iifcwzPgUE0naxzR?=
 =?us-ascii?Q?kaseGgtcUohHHDCkyijB+X2qhcTpTElP1e6/TEsGP4dlfP0Ts4OL0UYvNPYY?=
 =?us-ascii?Q?ZEaG4fskpySmQKzp115j30rJ9G3c9NQlUMgwj67flwsUOalCn6kJC2sc/9UE?=
 =?us-ascii?Q?gNM3rNDMmmL8ZQElEtJeK4y8+QxcgUDZSIkT7Hu6iec/ohI2s+/7/lHawfB+?=
 =?us-ascii?Q?1MXXOiDuaZaW3TvSs579RwFwBbInkhqwYz0EHTdBqwUDQvGvtAK0hl3B8KEm?=
 =?us-ascii?Q?ZBhRJY8WQdTr17hEjNjwsa1GlB4nEYkfXwnzrAaC0gwTFeW8AsizAnnsMOze?=
 =?us-ascii?Q?HQrvbrlrxjPROPF0CxXliWzKXpnT33arinfuQkGk/Wu+AhM7IpniwY/JI3CX?=
 =?us-ascii?Q?JJe0ha4EJltIopTIQgq0kwoguXdgdb+a1ANSIrtovAXSHaUrT4IJx7Tm9m6I?=
 =?us-ascii?Q?iMlVL+2+8192fPsVTmjCBrWB/f6JwbZxm8/lCMtvkTUkvcwCqbFWn2Cc2JDO?=
 =?us-ascii?Q?koKdmZUZdk7jhPKLNxyeOdTpa0nRUcqOT9hQkAVlYbJR0+o8aZjJeGw1Fsco?=
 =?us-ascii?Q?wwQ16nN/1V6cpTBqzz5wM6DVxkFWdSvDAfAZo+RKjKxOV1oDsUk7IZb/XqeW?=
 =?us-ascii?Q?Xf1trquKI/r93aml8J+TkFg6KWdpjKA1d085MZFrPkHY5cXzVs2gCOD5JKyl?=
 =?us-ascii?Q?j349Fx+ppmYSgQnuNTZb4rrguH2Z8qd7dnpMlZflLaxxXEACHzYq/KsP3/do?=
 =?us-ascii?Q?Cgq3OIi+Ar+/mUqsEB98JTBITYTn9gaxf1VK4NHhtT9JdvEn065jc+GIlmDg?=
 =?us-ascii?Q?VkXxYfZB9drgzW25ItnqCAYuafS28wYvLjmvLwVSyis4bfDnEijR7ClBgkVu?=
 =?us-ascii?Q?DIqlu14te16SZxwk6oGA6IDB4xb5gdI3/naQDZVAiAIh8WuLDyC6MWsUNqNi?=
 =?us-ascii?Q?IAbAfI5dtqVYfWxAxkIyvSI02F9naL7nNF5bYe9+iA71h92r6O3Cgh1gImpl?=
 =?us-ascii?Q?8GJ1DasbmXRsmWhXydzvhsx9vZkTrHo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b4a1f7-c515-4d9f-0a3d-08da4da8e383
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 01:54:59.3051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F9aYH1MLq0VTLcKju90X4/35yQX8s/N4e5Jiw4hmbzr36b6Vzsw9TchP6yIP6edw5TbrKTJVp62/ERXOtWdYOX4JjTxp63zfIlGW7Ix30y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3025
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Fri, Jun 10, 2022 at 11:29:39AM +0800, Ong Boon Leong wrote:
>> If "fixed-link" DT or ACPI _DSD subnode is selected, it should take
>> precedence over the value of ovr_an_inband passed by MAC driver.
>>
>> Fixes: ab39385021d1 ("net: phylink: make phylink_parse_mode() support
>non-DT platform")
>> Tested-by: Emilio Riva <emilio.riva@ericsson.com>
>> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
>> ---
>>  drivers/net/phy/phylink.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> index 066684b8091..566852815e0 100644
>> --- a/drivers/net/phy/phylink.c
>> +++ b/drivers/net/phy/phylink.c
>> @@ -609,8 +609,10 @@ static int phylink_parse_mode(struct phylink *pl,
>struct fwnode_handle *fwnode)
>>  	const char *managed;
>>
>>  	dn =3D fwnode_get_named_child_node(fwnode, "fixed-link");
>> -	if (dn || fwnode_property_present(fwnode, "fixed-link"))
>> +	if (dn || fwnode_property_present(fwnode, "fixed-link")) {
>>  		pl->cfg_link_an_mode =3D MLO_AN_FIXED;
>> +		pl->config->ovr_an_inband =3D false;
>> +	}
>
>ovr_an_inband was added to support "non-DT" platforms, and the only
>place it's set is stmmac. I don't see why you'd want a driver to always
>set this member, and then have phylink clear it - the driver should be
>setting it correctly itself, otherwise it becomes a "maybe override AN
>inband if certain conditions are met" flag inside phylink.
Good point. Will make the "ovr_an_inband" not set inside the dwmac-intel
if fixed-link is used.=20


