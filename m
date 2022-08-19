Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D88959A827
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiHSWII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHSWIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:08:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A303105F09
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660946886; x=1692482886;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ONVFsoeL3Nw+ebx2C053yUZsBBbHjW0bOhEUf+cB6ls=;
  b=FyNNbVxGktZmf4Y5KKLzOOpwzPb89yjGVQnGPopFiIYOtMsYB7OEjq9Q
   cKe94D6CC8LL/Dop9rrqCslVsi1ZKHkXiiGs2tGhVCd7dL8klEoGO7FCn
   vu8WYGGWgldEJXwHNYS0Rrq5SypUWpzg/N0UhUCFWHME6hPI+JahEJ3BI
   n/QGwpKxuBhFnr1Q1maC5UUTVNsxulrebdVrD8mWX7kRYwMHBIVzAxvQI
   Q0AqVkGVrZSwD5mysnHunzPGjTdpM4k3EZiyUTP3ncOrodKmQfO9/GM8R
   ac8NwmE4wCh66nqKh976gSdSBjhQr+pbE+/nobVzcgmFzSxthJnpfWlsw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="294381247"
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="294381247"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 15:07:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="750666615"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 19 Aug 2022 15:07:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 15:07:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 15:07:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 19 Aug 2022 15:07:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 19 Aug 2022 15:07:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Di9vsiyrbwV4Ad4977ysvogW0wHDnD1cVH4c/2temCql0M0Zh2mn87gDiNrezGJkVyLlZLqJVjlcW8hoCOausi6bSr90T1c41II6e+/tUPFCep9OzgOPvcU+fUTVUlq7U0FQSGTWdK3hyn03T5YXVdFh0mjhZLpgujKJheMM1rKssRdGK8/aWeYyzxTDNuFJVzqn9FqXSfkzdJ/ilCVOfDT+2tUIPAiq8fOZ+5QcSdve75UCtrtD76CLQJBm6vndfXpLC/T9a1VWwQ6upl5h06hqDo7dGMKORu6Aco3Wa7g6myz8XhXYEUa9rypQhBK9G0hyKyh9km3AYVJSlJuVvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONVFsoeL3Nw+ebx2C053yUZsBBbHjW0bOhEUf+cB6ls=;
 b=ifWhTL5f9Xu2GPXzMO9zOocShFU4TEKk/UziZkFnuLVnrF2xQQjo2kUaPwF7yhGT8IKqwC5b5f94Q4DUfUaGBFQy0TEyR0I2bDgV+rdaz2PDZhvmTt2AAlWrzv7F39lxARYGaqo87acKhdDhelqaFwT5ygFVMXkGxs+J9awME2uzOC2sZx4sMo/2HBQghGFp9O7i3HpeOwigCY6Mjxr0PkIJOD1pFEAJbsJxA8sqrXccW/cvTZD3EmfWHEd8hFkhjzIaI51dSEhFyGIDpXwUxLFO7q/Zf2KhYnTR8oHK2+yIMI11HG2NhXkzIJZGIeJhfrSsjQxmxLUi26smTCFaUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5496.namprd11.prod.outlook.com (2603:10b6:208:314::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 22:07:41 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.018; Fri, 19 Aug 2022
 22:07:41 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Thread-Index: AQHYswKc72t683aiKEGZcmtd4DX0Tq21h5GAgAEvM/CAAA1JgIAABYYw
Date:   Fri, 19 Aug 2022 22:07:41 +0000
Message-ID: <CO1PR11MB5089655E5281C29FA1AC19BAD66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818130042.535762-1-jiri@resnulli.us>
        <20220818130042.535762-5-jiri@resnulli.us>
        <20220818195301.27e76539@kernel.org>
        <CO1PR11MB50890139A9EEBD1AEBA54249D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220819144545.1efd6a04@kernel.org>
In-Reply-To: <20220819144545.1efd6a04@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1acb7a12-d8da-4edf-113f-08da822f3c56
x-ms-traffictypediagnostic: BL1PR11MB5496:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6149l85J+US55HyqNJPJleVpR64n0XRZCDlwvsSt5fo5GjyBlm/Z1vmzie0GqzNEGyU9kPmHbUej4ns+gaYOaKcGfhRFLnR67Iapj6/LcCZjxYw4p/Hew8iJxEAgC6cD7keknilWCBOmNwUfKZ7pwcM48VC6OZb6FuNJENEiXb3CQy8YPsn/rpFFqCRcFLhD7qAKz8e3txvPttfz+mNWjZpFmoS/k7mhCM4H1ShaARqxvXQoJ/wJuot6vQ1zybSMmT8DMncGuEMFFzeQrn/TMJdeOXUV1lXjhw5ArN1ncyRt3bP01mTqEKIESBUlFs7FqHRz/Ci30h5F1VD6OBeXi4cwuuo5R0KVDjSDU9wgVAjztQYmTzW2gGnHgG+h0qItqDmNIGnzd7wyQaTqr7KxkgBbzyqmI2CznlI7UCvL+WJ54xkz2Jnw4HzESYOCbZKRoYNTMf3OOMiKKzZh5zAxOg794vWcTacPaH+/k07s6oS7GmgykcH4AGhT2ftM8pfR4Yk8/+Dl/OFEsqyyBszp2yUMEqA7c2saYGUi7gTeOx0GL4183bYQTKqE8JQ44x/hR7BW2LuYEnffR7I20JtyfaVU2X+WZAHcnKAE6T07rTpQ3zOXpYYvuuRuQnRxdxMLUKEN7BCpw986bpWw/w91J+9INXWuq3KfGBFDRJsetRUSDZh9Fmsrl+4/IXINpEMsIylBj1gi/jRTnfcKzxNn9FwEQQi9C84Q5ruBryUYQogcrB+Tv2Gmhy9f4KY4n0ESom4CVnQozKnrhhn6V69Dpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(346002)(136003)(39860400002)(7416002)(52536014)(5660300002)(8936002)(122000001)(15650500001)(316002)(76116006)(41300700001)(8676002)(71200400001)(66446008)(66946007)(478600001)(4326008)(66476007)(66556008)(64756008)(38100700002)(6916009)(54906003)(33656002)(53546011)(7696005)(186003)(6506007)(2906002)(9686003)(26005)(83380400001)(55016003)(38070700005)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2+CkD5ekIE2yKSKN4irmnin4rgc8mUe3kdTrttaNYs8IbtiwOhYaujjowz8t?=
 =?us-ascii?Q?pTVvhS8b7/ORuzgWEucyre9E9pcrStbnhJmp/5eHyPSZbbCSW/fKuuewvOWo?=
 =?us-ascii?Q?ZgVXM341Q7RcxnGhKrNCjRYI1kxBL1VJKo6R2IY6gmq3gZCIq+9RTFv1mcPP?=
 =?us-ascii?Q?oUjmDd/9OGAt8HPrTTpRThpnAsliZz/aj8DllgvH+AUBLOIwW9RpFeZPM0Ue?=
 =?us-ascii?Q?QwDctag09N03Ry/LvpUi3+7gCBltyEAgF10E044PrrYtvJXXzEQboS0nPFT3?=
 =?us-ascii?Q?PjNpIr7vXMFWtQ68LaLaWz+I3oLWF+tlXdX6oVq58Kmy43wXZ242D91beyr+?=
 =?us-ascii?Q?tWV1aJD/MbaOED7CDsaolSMnXOVQO20vGJtraVEUpOo1HgHIKjIfZc2IOXS1?=
 =?us-ascii?Q?zGgmHcWgOxjHhwMfQcR7vnaBquvfIhGI0YYrmsPkkzZ//b/E6uLFoiCk2eRP?=
 =?us-ascii?Q?uofJfm5AUysJIk01b7T084tRnPCnUOtp0Zv/zs/4QpE0zRSb+CvO7s9JXWpT?=
 =?us-ascii?Q?vQgiAwduPmhtq2c26iXJN7UnptNn0E3qhpLNoHyLQriM6dKssUA21sCls3EJ?=
 =?us-ascii?Q?IAzieyEmUGGp+aeite9G5CpYJEBy20rJBW/kdCTOpPETQlPMUo8geA+xraqv?=
 =?us-ascii?Q?XLCD6bqG7C4dCFJqvzNAJ44vohxvOqxFknjQQP+sD5VEEXyllMQBs6tf/b13?=
 =?us-ascii?Q?KHnxzQTG0UvnanzqR83oXyd2wxtS0w3Dxy4A6MVFBs5jkUYULt2Vrv+cBm3N?=
 =?us-ascii?Q?0G7Dy+H4c4kLkJAPUGWNFI4W76EHTu47gCLhCE3XbcNWOHnm79pASB/S7bV5?=
 =?us-ascii?Q?Kj6iCJ761Anao0pcxlAjoON0aeglyDneLUoaqExdlVcmDIR5y3s471kPkXS/?=
 =?us-ascii?Q?TCjdOhX6DffoRN1HxZwxeRMNf5v3BrbN8jsXJriUpGpEdspdxoBcUlMJT5aA?=
 =?us-ascii?Q?STbYVA9ojXDjCmmSZ8iWDGwwqkJi/Cnp/V9MmnPIZHT4w+rh47pW8YWtXZw1?=
 =?us-ascii?Q?cyJyZgnSLHzdeUsNOM3M7Do5jb08QaFnHcgerGmyTUDeMBKcLyLabkvZFZai?=
 =?us-ascii?Q?tgCqMmDQ8C+ha9XR5Wk948Fxw28m59AZSrJHJHpTRfkgSJR7bSVdSc0d+yLZ?=
 =?us-ascii?Q?1xKG/+U7oV7CHMs/Ly81kphPzHD426qD018uJnMd7QIoYnxBigsY8pMlqk3U?=
 =?us-ascii?Q?Y1JsMOdhL72QAvwqBjjfSFWOqugsck0Uf7asrhOUZiqVy3/eZShpvSU/YBQY?=
 =?us-ascii?Q?DHd/LOsWxwTf1SUQASRfqBLcDA6FnibsnDTO4w28BW/JNfEST2nKH2xFeZ6c?=
 =?us-ascii?Q?sbYjzQ6udb5KTt8LeOu3/n5xpIc1X05BpMKNOjhcTiWUKsbrDhZmTiJQKn3I?=
 =?us-ascii?Q?sUExIco8HGBfIS0XAOnMueHcMamtYRMHDK4HGMBruKHTX/+WkBVGQH9KRPG3?=
 =?us-ascii?Q?8Pd8M2MPMIcQUj+FhXc8aXCDveZeM7lH6UOvEtzAoSizsUC19MfKE3NK+LwM?=
 =?us-ascii?Q?hWtvY9wQkhE6CNY2v0M9qmmfWjfqJQ7m3bkSKGN5tsTtHMhYmNS9r+GJhx+x?=
 =?us-ascii?Q?OgNMRhHb23S5fErlNgK6NuxPkpSaoKHMFuiS69SL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1acb7a12-d8da-4edf-113f-08da822f3c56
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 22:07:41.3225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxRXQHSlVszTjGrITJ4Y2Z74mbhnU6ZFZeJaynDtLc6enmHhStN3vorXK19eJpyMPIjUhklK3GDOucpvgXpuqO2JNvYUJUZ2pnx6BzslSCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5496
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
> Sent: Friday, August 19, 2022 2:46 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org; davem@davemlof=
t.net;
> idosch@nvidia.com; pabeni@redhat.com; edumazet@google.com;
> saeedm@nvidia.com; vikas.gupta@broadcom.com; gospo@broadcom.com
> Subject: Re: [patch net-next 4/4] net: devlink: expose default flash upda=
te target
>=20
> On Fri, 19 Aug 2022 20:59:28 +0000 Keller, Jacob E wrote:
> > > My intuition would be that if you specify no component you're flashin=
g
> > > the entire device. Is that insufficient? Can you explain the use case=
?
> > >
> > > Also Documentation/ needs to be updated.
> >
> > Some of the components in ice include the DDP which has an info
> > version, but which is not part of the flash but is loaded by the
> > driver during initialization.
>=20
> Right "entire device" as in "everything in 'stored'". Runtime loaded
> stuff should not be listed in "stored" and therefore not be considered
> "flashable". Correct?

Yes I believe we don't list those as stored.

We do have some extra version information that is reported through multiple=
 info lines, i.e. we report:

fw.mgmt
fw.mgmt.api
fw.mgmt.build

where the .api and .build are sub-version fields of the fw.mgmt and can pot=
entially give further information but are just a part of the fw.mgmt compon=
ent. They can't be flashed separately.

Thanks,
Jake
