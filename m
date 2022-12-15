Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983C864DF93
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiLORVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLORVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:21:12 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DDDB88
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671124871; x=1702660871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ANkIYolrtZ0jVmVSjqTQl4S5/Gq9KN67nEKAbdF6TyI=;
  b=iWiiOcNVl/WmyWV/MyOJih/Yle1s6oWh7z44p/vrEZ26UHlksQQE3Fcm
   Qzvnq6g/QQqGLMPiANnCVDt2AIJIYFjlFv4CKdQcCzvbyhCV6c81Vex87
   03LItZAm7flbeqaol7jZeFiAuRRCadwWC+5XjtIxsYiCwJUwgREnd2tnW
   RbRtx48JA5hPAJtohUW7X8e+Ot+bU8yryUHN7VZUWpilhlJf5sFWoaUJ2
   YNuDzMe3oHA47tHKQcDWQQ0Y/ZBPuP535aYNySCR6aFTaqagw17NU6FvD
   uF6IJ7qd1/JhWSSVDFB25K7mfSMHdwmXtjIx+emhlDnF+WFrQEv7vrzBH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="318791070"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="318791070"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 09:21:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="791736029"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="791736029"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 15 Dec 2022 09:21:11 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 09:21:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 09:21:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 09:21:10 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 09:21:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJSOfW4hCMMngPrcdvZUf0JC73T0j8kWPO8E0mzBUUxIe6VBZ/C5hyv23Sju0jIAa1S/jZOwPNxK0ky6gppY/aHZoropfFHbUH2Kn1ZZScbXJyGZHt0JWJsC4Wf0LFdurL1SPwJ+f8KHB/mVwCFibJ0cD9O7gnmvb5AnWP1OCWas+UjNDkx1xOOMAGntbR0yqXLih/GQ6HJF9FpEiiHKdxQbsz1lfO8JI9eULePU9S7vfwysBPHqWj6ZokFYbS3aYssL3qGu+T2dk0lUllr82UQPsWaSxqZ0BO2Lm4CoEhxpJ24kumVNnpEGd2/bMDH2knzXH7P1RRBZvqhHFdxyLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANkIYolrtZ0jVmVSjqTQl4S5/Gq9KN67nEKAbdF6TyI=;
 b=g2GTtvR8J0Wixy70Nuaijqx2hwDi0SU0Pcoko5BbI0/u/JWFJgE2DzQgZrW0eI2i1Hwx5FUw4XEL3sr8evx29P4yaxT8dm9O5ZGKdBOLdtRFzmqAM8SVepur9Cknsd7bmlE426MmWAXYCztDH1lD6k0oyJvBDvHtsaM2A2wCmlymVFSHzy1G34s/bgGSccIYQJpsRFp1tlnGDDY2TZsY3o0dH63J5VHrt5autfwTgqooy++IWgwNhhGwBdoh6any1k1oZM15rgbundx18gHCK8g6bvKbyPQ48rCOAM7g6VrUh5Dpx79kzjeHdJu8X0hHNVtPz63QwBOezYB4PHOcYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by SJ0PR11MB5680.namprd11.prod.outlook.com (2603:10b6:a03:305::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 17:21:08 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::cfab:5e4e:581:39cf]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::cfab:5e4e:581:39cf%9]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 17:21:07 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Missing patch in iproute2 6.1 release
Thread-Topic: Missing patch in iproute2 6.1 release
Thread-Index: AdkQb9xUC5vmlm8hSd6HD7llrKjh9gALmKOAAABdHZAAAlIhgAAAH+MA
Date:   Thu, 15 Dec 2022 17:21:07 +0000
Message-ID: <MW4PR11MB57768E322C358C476467AA9AFDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <MW4PR11MB5776DC6756FF5CB106F3ED26FDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
        <20221215075943.3f51def8@hermes.local>
        <MW4PR11MB57760310424E2B73F53F933CFDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
 <20221215091635.15cde90c@hermes.local>
In-Reply-To: <20221215091635.15cde90c@hermes.local>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|SJ0PR11MB5680:EE_
x-ms-office365-filtering-correlation-id: 8eb3f222-ba92-4e67-5245-08dadec0c0d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IRBJZ7H0/eClkQNkNdsL3778oceGrogRWWdbNm7Kfwi8ClPh7zBvMtzB3GpDoxtlxR81G/DPg//xY5fuAwnty6OS+jANyt+NETPMTmazaBy9P0UkpB2WS+y9h5ZxV0867l2JC03PllW44SZ7yf3h6BxRCrV1RtjlJi9M6CILZLaLfBPYTjApjGz8Dx0QFlLX6Wh9i28KyXkMw0Xz9IrgsQ2l23sHrlBDUTIoAOqQohcRJGAvU+XeIoo+5hRlUEb42y8toSk7u+RYJ9naNImd0QSY3sKxG3fnitPg32RdLyrYcomsOBYjLIPTtMImlP884lxqd9nI6EZZptK/V5Dq2/bKnbCDWQ+8fgGU7HVetlKsE+DFLIhEkAHZT48/X0+xcfi2c+0qGR1huCzhQwdzlSPHgK4tXwNhG1DDhv4pXEayHB97V71q8kULWxcYpqOs9qOVB6ACFVSAswlxXzKzxieAVxX5nIeazZO3mqUmXFhL/MN7Az0Hqs4f1dPOE/M12TIqUWtKXrye60jhAOc4s2TQ/NmWaJgOHGfsDCS8zRvV9tjFlNa1xnl+9UNmfxjXuWn6XKt9KmrhvjuuFF3j4UyBWe14Rvnm/mqwSaFgFe/cEgOj53W3eMEAI2rCrgDDofbef+BbCFRRRKTO8nnnD0ypih9fkCx8Cxca9zKCV78afbwHwlvSGotTw3QTnaG5roBEZNBIjYTVwYXU/lN3z1Z9ZGONe+Y+vH6rfJovAq6tn3rAygbWCASUHBQC+3BfnlZy++s2AzUvL3NBJxKZWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199015)(53546011)(478600001)(6506007)(7696005)(966005)(41300700001)(316002)(66556008)(82960400001)(9686003)(76116006)(26005)(186003)(66446008)(4326008)(64756008)(66946007)(66476007)(71200400001)(38100700002)(83380400001)(86362001)(8676002)(8936002)(5660300002)(55016003)(38070700005)(52536014)(84970400001)(33656002)(122000001)(6916009)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XXKJzauIsbTyPaAr/FrfrC4J94cMY0Zc/oeRcx1fcKZqnrhuGdi9dn4TmuIU?=
 =?us-ascii?Q?1W2kBKv5ZSAskNKOeTSidx523+3s3MR26Clb6xPvSbTd00ywiIRHcRIxKRPW?=
 =?us-ascii?Q?gyLjOEO/Ddae031ZCqZRqDIkidcgePJiMuqx6enW+xZuJWTQXo/yWaxdzYux?=
 =?us-ascii?Q?SdBxkkNRD/1M35abiIENS4gcedIJ8kZ4haY08Hg/grRJOq4/KSby5h2mR1Zf?=
 =?us-ascii?Q?Z5Om1GzB/TIGI6JGSXr/UdYXmZGhHtftIKkjM9LkJbWZzO8ROwzXLVJ5Lz+L?=
 =?us-ascii?Q?uVfuCVXk3GaWr//EpwHXJO+nKURdOZXU4GB7WUfF5PEvIrRKscCua/T/7IHC?=
 =?us-ascii?Q?X6yroD41EECNZgB9717AYp0AfUzNnLoBdzJgRmQKHS20HQEjh8hbSwmDu2JE?=
 =?us-ascii?Q?uAD/GYyHlFEZnDFftnGiE9Bd3fuKKICzMiHO4UQxWpV8PdeHgT0YbpKPTYAJ?=
 =?us-ascii?Q?cP5PPxbPQPfwMXEsiIrG00biK58n45Y3juXybMd1eOm5lw0ARppF2xP1Lq8p?=
 =?us-ascii?Q?x52VJWmNY6KlGRzRE//gXo4A8boW5I+gHDi+S1sYj/8Z32Pc/eCR3YGsYUoa?=
 =?us-ascii?Q?leXuXIwbc565jd7xecrHqZQn/AO1PnJEgYgPKbmSaNE0GWfstE3mlek3tYst?=
 =?us-ascii?Q?QUe0AUKcV+pyw1nEvpUweogA6v06l8dZvFx5u4RGpg0mIdqC4I10NXlpsPTQ?=
 =?us-ascii?Q?tk0OcteNZrDwlHHp5ZERqz5hWnfU9v5AlVAqhWPQMCd+77Z7SCECZGgxDIcS?=
 =?us-ascii?Q?Au69PvbrjShW/wmI0b7HdkrxHKhBUqcP33hj709IrCbFgHroTSwgN9GTMXON?=
 =?us-ascii?Q?crYA0En7q9r2vG+BPZN2VKhZxVd2uqtHpEw+ZpE6LIy7Xzv70uSg1FYYR9Fd?=
 =?us-ascii?Q?7/jSffKcksR21bc1eaoSdk/cJ+Vd3N74DdCq3VaPtu6TsilhQ1dj/vMzhQHP?=
 =?us-ascii?Q?dy56QZBNtzToS9bLfxHDIn453ehQlP1pNqWf5lwzsPxJ9NcVvorVlrSodRge?=
 =?us-ascii?Q?dlWA1pArI5trZLkUXmg2rNsTdDZsucJOV9kBILe528G0TFa/+5VLvA4opc6O?=
 =?us-ascii?Q?X0qMyPGGK1wQFecNx9gUMykNRJy3cwvdgzN2qXhsG2W3TS27BU1uPYYc3QEv?=
 =?us-ascii?Q?i9ZWvJbsdH76nTlP61R1QKAT1ikwfyS5fBiPC75K0R6h6NnEwmLr/pjO3xtF?=
 =?us-ascii?Q?g1SQ/cuxC0bYM+Ji8SKr//5Km4diER4oIKD4T4GcYJmy4RbnBVWRWaXtBT00?=
 =?us-ascii?Q?NWYY3hAT+aG12oJPCsGOD1oGJvMmW6elxBeLMXyJBhR2paLsbLN0n1oLKAKI?=
 =?us-ascii?Q?mm0tNWavaib1Ua2KxtgBJslaRnrC33eEZDeyNzNYbsH8/jh/mPThmUPIRaJ6?=
 =?us-ascii?Q?+NJLi1CsDTZi3/wHxv2x8ocpwF5JAuChi3fksBrYvv45Cv9SuDks8VgtZJ/A?=
 =?us-ascii?Q?tiJH+8PTXLXuGyeod+SziQ5LHQctmliLe7pVlJb1pydZRbdgoDGpWIgH1wIo?=
 =?us-ascii?Q?lxBs/qsPEDEOnvU/Zc+Jr+HeI2rUCPC1aXkgC1PwyPMgwTKo6KIiGciWW30n?=
 =?us-ascii?Q?U2lWkChzPNyBbjs+6lGr1Fjlyu8jVWuLp3ZcrePs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb3f222-ba92-4e67-5245-08dadec0c0d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 17:21:07.6457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PUKwyb6L/hcGt9Ohg2nBzqSO1S9ZZ8mzz2pre4T4Oy5gb6R/LJHB0NQ+L7s4Pi1ziehUkGMT2g8jH78s6BRxHUsgzKS04bsEM5PODmmCgMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5680
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: czwartek, 15 grudnia 2022 18:17
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: Missing patch in iproute2 6.1 release
>=20
> On Thu, 15 Dec 2022 16:13:07 +0000
> "Drewek, Wojciech" <wojciech.drewek@intel.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Stephen Hemminger <stephen@networkplumber.org>
> > > Sent: czwartek, 15 grudnia 2022 17:00
> > > To: Drewek, Wojciech <wojciech.drewek@intel.com>
> > > Cc: netdev@vger.kernel.org
> > > Subject: Re: Missing patch in iproute2 6.1 release
> > >
> > > On Thu, 15 Dec 2022 10:28:16 +0000
> > > "Drewek, Wojciech" <wojciech.drewek@intel.com> wrote:
> > >
> > > > Hi Stephen,
> > > >
> > > > I've seen iproute2 6.1 being released recently[1] and I'm wondering=
 why my patch[2] was included.
> > > > Is there anything wrong with the patch?
> > > >
> > > > Regards,
> > > > Wojtek
> > > >
> > > > [1] https://lore.kernel.org/netdev/20221214082705.5d2c2e7f@hermes.l=
ocal/
> > > > [2] https://git.kernel.org/pub/scm/network/iproute2/iproute2-
> next.git/commit/?id=3D9313ba541f793dd1600ea4bb7c4f739accac3e84
> > >
> > > Iproute2 next tree holds the patches for the next release.
> > > That patch went into the next tree after 6.1 was started.
> > > It will get picked up when next is merged to main.
> >
> > Merge windows for iproute2 are sync to kernel windows?
> > I should sent this patch before merge window for 6.1 was closed (I sent=
 it after it was closed)?
>=20
> I do merge of release from next to main during the kernel merge window.

Ok, so it's my fault, thx for explanation.
