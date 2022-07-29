Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DCE58519E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiG2Ocr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237116AbiG2Ocp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:32:45 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D2E691FB
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659105164; x=1690641164;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SSH8KKVDhMvCfdvdRjE4Ykot+V5qSAgaUPSTmESgkiQ=;
  b=BLCj5XfI1J4OhCq8zgLu+ukM9771MPwJ1hYz0vDQsTX603l9SVjeD3Az
   EU3i1UbTUGUwSW34HCZfSlAmlkQjtKDndIvJR+fsy8TQare9ur/mfteA9
   C+sJYosF4nw7VX+7HhVxtE61rERxfHmcl1zPN8LMuhAMQ73ysk6E/FOum
   6rZrOUbLYpaUYszF800eglkv7kAAA88+g12ocfYXwKT2/lvqaUhhf/l8j
   sVzYqHY67HZOoJ0YWzNLR8bgXGR8XAKNQNLyvc/qENVpnE9kN6gEY3Bdk
   Ohus4evcG/hIT0OISaIZRCkYCyHIHxdN03j0iPqcJiFiWE8uqXldVWpbA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="352775488"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="352775488"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 07:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="669287507"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2022 07:32:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 07:32:39 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 07:32:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 29 Jul 2022 07:32:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 29 Jul 2022 07:32:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4Zg7EPe/IWyD7No+7GXftGy4s6eCtl9DaHku+Lbr6Q681hLdcO0fWS+9aL6uvb0EG35Xlq37NyKdy4dWpZ+C4LozhbIm0vZ+5ZoAvjgD6uv2E2xIZEpLKy2goEpihZAgaB4zS9POwTOc9j+tBHiEj0znFuxj6UVtUKSEKFxXtKna9DtM5nEntr5GeJ39V7neKAIGtH8MgY4rqY8lu0wugbkuUqHzzB970OXiExoyKiOU2S0A1AKN9gcGrTV60hCwMDesROhiBVWmYyD6g2cQMC4YQK5JcbeoSljX3GcUKKItYoGnQp9exYrkmEHw8LCHYnSkUWcGFmzYLJsfyPkjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSH8KKVDhMvCfdvdRjE4Ykot+V5qSAgaUPSTmESgkiQ=;
 b=Rje9GRFv8tD6RTlzgmPxf0uWJ233k97zm9LGOk8HgAdYWl6ETB/Rx1s6p6hwX8qo1Lr+kXLRd/0CkKeJrHvjY+HJ8bOmu0ilY0HGe1thJ0d9KEAG/s4M6QB+beOY4EFKEo2quy1OB3A1ddvsrI+kTW0khgiGY/JRLtnQlAqAgO9Mv5uK1yzPGfMjCKYevDFfDidcV2YP9+xVgf6Kp2IaTpFerLLObv9q7lPifsDXwqHpu8OUN+6t3Ex/LcFjjtSsVD8+OOB5Zm7rxNnzFBJ7aViQRjtpFICSXx7IlUAEN2RLvFJZgOs/lRie3lrljJOI1Ijmsi4YrxCxu8Ti8bnyyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by MWHPR11MB2045.namprd11.prod.outlook.com (2603:10b6:300:29::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 14:32:37 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::d9cc:2f38:4be:9e8f]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::d9cc:2f38:4be:9e8f%4]) with mapi id 15.20.5458.022; Fri, 29 Jul 2022
 14:32:37 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Guillaume Nault <gnault@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE: [PATCH iproute-next v4 1/3] lib: refactor ll_proto functions
Thread-Topic: [PATCH iproute-next v4 1/3] lib: refactor ll_proto functions
Thread-Index: AQHYo043R8VAhOPmn0W7OuR9WKVEAq2VaTVg
Date:   Fri, 29 Jul 2022 14:32:36 +0000
Message-ID: <MW4PR11MB5776E25C99B1DC3505BB4A54FD999@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-2-wojciech.drewek@intel.com>
 <20220729132200.GA10877@pc-4.home>
In-Reply-To: <20220729132200.GA10877@pc-4.home>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e241976-c402-4b4c-deae-08da716f2ef5
x-ms-traffictypediagnostic: MWHPR11MB2045:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hOABbfUu3NjwbSXondmwvYMVVv5+AfAoS0hm0lv3Wg8Js/JJbEAPNIIhOAd3zSarFCPq0KHK5xgX/ljhfXrUZra0+k/QYj8/AEl2p5WVdSO8tFsY00E1Mtt9unRNNc45mmaqETPehbp9MlMP9G2CB9jcHWYydBKuslexaCgQSh3GHeH8VD1/NdRAD4xnP71i9Tmr9x9BbIg7xO5feB7G7cU3+B2K1Q12bVeGOr79IFwNxMI6v6DIetfxdFZH1MMWLbh7OVfVxjAPR9ZazpA4INx9x1MxIYLnjA8d8LvIdVVvd0kYQXR48G5ElTbqr09oFmfjosj130QDP7yDh/OOZIG3qiAT9Zvz+OkQa+CRupT3eI+l8dJ5BZO7ceWQcZ8o/MX1Sq9B5sgOFyu3GGRcipw5xSZpYLPlpZlGanJczzUZToV1L5lRCj/1X0DQqfIi9E/nrXS+ijdoiZN7yP75foUhCP3yuyCC/6McnIYlfi2SHl963qCYHRj/RrWdyNSIyAOh6RyA/pP4xKob3/MUtibhD/S7JC3T+n8koAT1ji9cBtDtuKn0RZspFoD2ECuhihAiKLVxzUweD9ibyDoeDM46xs4QaSFLgC+yN7eYC7788MmJA7JiR15+/+NNQVea4kygTkYwT1/+969p06rqOrbp8SX7DTo8m56G6Sg+908X31qAZWcztyGiY8EOqTKsN/Onltf8kFZmR6tjvubBSh9FLX9cnXTGv6gKnchcvIa5uhE/vR6O4IRGYb0CrhSo1bjJuSX4nqaBk98bDKfpcbaW/d5x/r5flS0qOhnEuGs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(136003)(346002)(376002)(186003)(83380400001)(54906003)(6916009)(9686003)(6506007)(7696005)(26005)(53546011)(33656002)(2906002)(4744005)(41300700001)(122000001)(38100700002)(82960400001)(38070700005)(86362001)(55016003)(8936002)(66476007)(71200400001)(5660300002)(8676002)(4326008)(66446008)(64756008)(66556008)(316002)(478600001)(52536014)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?5FrAfWguj4cZTgBRiXGc2kDf4j9TpmYnxCJXpW5zDMGXb4bJCHXdhGx4MM?=
 =?iso-8859-2?Q?6+NRzMCtHhFAbGbMbXhUDnbDz8eYTys/G22hT6/A3tbLPXeAwA8peSGFuJ?=
 =?iso-8859-2?Q?wD/B0GLXUVo62cKlrd3K1Rzsy0QRWX2g5TMOvnXXHuwLSqq7MrE6oUm79a?=
 =?iso-8859-2?Q?/sulYTcLg/o5Yw+XzbV96jDChRuzsMflgU79kjLXkxtNsEW2L5lbdsYb2s?=
 =?iso-8859-2?Q?an2fkC5RyEJgCtQJI/eoJigdK62wgWdQ0AbOCWAThH3IwSrcBFhmEUioV6?=
 =?iso-8859-2?Q?ppsOqsOG7fbT9qonmjzjxQIwarcyriEsPFUD3SBHpliHP9rbmOsGpdlePs?=
 =?iso-8859-2?Q?/XjI8069pi8aCcxS4BlguAfybECWVTWxmXdRCQIm7ooKso7DceSxCGvdkT?=
 =?iso-8859-2?Q?uUNRuK2cV/NSZdLLR02re6iUKEAXNqFmwqV+VAb7u0NaWUsaNBtH0YS1pY?=
 =?iso-8859-2?Q?nhXxCNjC620sxcpXtk6pNCpiEGgb26Gv8asR27U0Cs6ECq9AgR6AUBNtAt?=
 =?iso-8859-2?Q?4Lf42D9Kq+WMVatCJEPZexoU8Ai7dzPyM/+yx+NG5V6FGE25oUi2xLgPpd?=
 =?iso-8859-2?Q?KPT9sYXQBw5ssez6SOJI+k3KzUJApZnfpPk9IZW4ur4GxKo/kp+UTpzt6S?=
 =?iso-8859-2?Q?wTty0b+g7ouAQ36TkLu09cveCijiAaXIn8dbCWO4/0u41JxVwteo1UWY8p?=
 =?iso-8859-2?Q?oJXobJubYBDm5vfxMiVTGrzKgc+0yMT20uzc0L5MPutU5Il4IFbIPFki9P?=
 =?iso-8859-2?Q?zMpS1FgcEfWkUHBtXBtdpb76MGOaTtyPhTBSyHZxH3WUc1keVMt5TXepjK?=
 =?iso-8859-2?Q?tWG3Khwg3VAiOmHeYh3kmMl8L+p6Bgw0MS3uu7Q6+anlrMsjjOUe+QqEN4?=
 =?iso-8859-2?Q?Hb5PS4NaGd7E3xTbVJflbBpm1IIWILeD2AJJ8X09KjeCmJwkKYvCNrE8GZ?=
 =?iso-8859-2?Q?Mb3GJiecoiKaiox+uteeioWHfAlzxvs0brYcyS178l85HeBobsuz1Wk08W?=
 =?iso-8859-2?Q?V8XwSA6XYFRJJxaIkPfxqRr0HTtftQOwMGMbVRqSiLIS7RJBetlyFsz62d?=
 =?iso-8859-2?Q?FHgbHAk1FTx+5AfBrvrG877xLJbJhbXVDHpbNfZv7qychpO2wAq5Tr0uLx?=
 =?iso-8859-2?Q?7qIrH8VKI0MUAkjHNsRcvQNqCkYYZ7JMKmjieagK44r90h9uPDarJbXrm9?=
 =?iso-8859-2?Q?j+IGc3rqPkKhJVmxF64s+dcnCNl4JAxz9ayZQ5wJoyPxw8Yz2KHBsUdnwB?=
 =?iso-8859-2?Q?z9wf79dkPN3rvLFCq3f3b1P3wfjXxSkLvk8WtFJ5z6baaKYtC4qpaHirEx?=
 =?iso-8859-2?Q?kcJzlQgZl3dJP6nPF18qx9O9ujSMRIAyYgMWKHk/KJ6YAfdLSY2Z+j9SmJ?=
 =?iso-8859-2?Q?kuVYg9IaTE8JbE0WK4uFnTJmMe3qTQwCTKoIn8xqOEidDpZXD7uJq5yKGA?=
 =?iso-8859-2?Q?ObcBHIIyvWJBOMh4vl8iuzEfsyqCu49LB4giG1YSkkUujF8cogkxTMHlAe?=
 =?iso-8859-2?Q?j0lWPEyNtoUuql169wgtG26S4qgoFphlZFeS7s9yQkSUtAvyjAfclHZz4a?=
 =?iso-8859-2?Q?pz8pUdr0wwpnBPEZolj7FGNkstNM4aLhEoZxERtNNPOry5xwhNiJqFriXD?=
 =?iso-8859-2?Q?3au4s+r0KlZ3j9z+ws4CKMc9jE6RCK/2B3?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e241976-c402-4b4c-deae-08da716f2ef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 14:32:36.8895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HL+a9UXcm9QNz7a6m3VNz7zO7TwXANYs0OcfOGg9NXQ87ImjGoEMuxKDZtMGN3Y2Q91wJyX5omS6YwBWsdFDh2Fvpea2nipDe50kba9HQHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2045
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Guillaume Nault <gnault@redhat.com>
> Sent: pi=B1tek, 29 lipca 2022 15:22
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org; dsahern@gmail.com; stephen@networkplumber.org
> Subject: Re: [PATCH iproute-next v4 1/3] lib: refactor ll_proto functions
>=20
> On Fri, Jul 29, 2022 at 10:50:33AM +0200, Wojciech Drewek wrote:
> > Move core logic of ll_proto_n2a and ll_proto_a2n
> > to utils.c and make it more generic by allowing to
> > pass table of protocols as argument (proto_tb).
> > Introduce struct proto with protocol ID and name to
> > allow this. This wil allow to use those functions by
> > other use cases.
>=20
> Acked-by: Guillaume Nault <gnault@redhat.com>

Sorry, I forgot to add your Acked-by, if next version will be needed I'll a=
dd it.
