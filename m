Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFC857244C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbiGLTBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbiGLTAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:00:36 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020015.outbound.protection.outlook.com [52.101.61.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0431F6312;
        Tue, 12 Jul 2022 11:48:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3zrCINZf99S3fWIyD8jt/LGrndsDIIuNsTtisQWODsfPNfORa89bPK3m+3Oo8pH2j7Uee9QSPpsf1M3IDMqu6n3Kn2xSAwkPsuN9nODN07Xa6kjMm5YxjN6GXEbLkafG6rKnbyIjwhR82NjrASS1muogizmbEz9s1Q18x60B7EcBpPpmzYxWZ2PUNZQihZNwA8WRkFV4g0j8vDcNg5JFKSeVmFmrrvE2OM7jPuXv8aDh0ipV0uHabBZVhhiBAtUckvq6ufg/SOPZcjBsCYgROe2DPNVCPwi+SSAP11+Q1Y3YE5IVCL+ZgvV2B5haj8wUS9hIdyKw9asSDjdeHs6iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNYFU9/cPOf4Pg71+WkJBgZEGABG98SwwnPH5eZH1Zo=;
 b=HxYZxCovba1UevIHJpTmN9W2k6cFKW48+TUi5E2XMidZAqCsoQEXXEgl5RDvvVwmcL+I/c7hcGAL94bsZoVUoZK0CsowqfHn8As5egEZ8yaso1yd2FYafT/DUDCex5QC5UZeJ1gbaizS/Ha6lAewyTMUBq5ur5gVTSuG0WlZsf0GXHV9vJipoDj76ASgkCo8hslmYQUihp7RlqmhMyZRGj+zQcrq+SjpqkmyhenkU9yHCMfAie2ZZ4ENHNO4OLkGKmhzmO1SVmYciitVtmzSyOZ0wD7oeQoltTGUaj/kY+XPcCL6aBbSHacLtTVEe4BcbnR95G0WrBGKjoTo6h+C9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNYFU9/cPOf4Pg71+WkJBgZEGABG98SwwnPH5eZH1Zo=;
 b=b3C6QsFNRlUYXRekHht6S/PIkOwBIp0TILNXJGw5MGlUQ6QkQgCG0q20zd+V5h+KxJ7ofW2EA0wgsHfbrwh8ZbBfWuqNl3JmfyPgcWuWAc+1FetImUGNk82SJEDunRtcekIDbm4CZCLMyeWJYyAP5z/59jtafp2Rq2Reybbha5I=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH7PR21MB3260.namprd21.prod.outlook.com (2603:10b6:510:1d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Tue, 12 Jul
 2022 18:48:36 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9%6]) with mapi id 15.20.5458.004; Tue, 12 Jul 2022
 18:48:36 +0000
From:   Long Li <longli@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 04/12] net: mana: Add functions for allocating doorbell
 page from GDMA
Thread-Topic: [Patch v4 04/12] net: mana: Add functions for allocating
 doorbell page from GDMA
Thread-Index: AQHYgSXXtWoAVrEI/EmII18mqS7h4614hKkAgAK48TA=
Date:   Tue, 12 Jul 2022 18:48:36 +0000
Message-ID: <PH7PR21MB3263448E0411BCACB3C846A8CE869@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-5-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13270BC0DF7A9FA17582822FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
In-Reply-To: <SN6PR2101MB13270BC0DF7A9FA17582822FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cf1a848e-4358-483b-adef-870caa689754;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T23:21:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eca33d1e-6485-4120-ff6e-08da643720d7
x-ms-traffictypediagnostic: PH7PR21MB3260:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k2whS2pQRvddeZpRhe0nnWKpxGE5AUXIMorx0/VN8hPHm4KLIoqghpAvTpq2IYGhqEkja+OpnGkTirICzGI7gYrH6KXcMTvfANDvqoSSEfDn+gfVBG4/BR5EF8faGYbBDd8NhCwrjGppx998jt5G/E9RYz28NiDJpa2lzzepWrCtXHzAdWW1S7tkiOAK6BappbGTnvG33oMZWJP8Z56oBZwYoqKwUp/sTjLTyJ/kXKdsmb9DCPuNUAVvwHA4xqg+dqciN0Jc2ANv6LIqwqFwYoG4Mto+GMNmZrk5rP9bGH/GuZR10BlUZ7mZXG7pdLItpAUGN3IkpEn6nHZPFId/KPdyNicwdOgkwTILjQbj606GGe+8Bq8Tp3S6GVjE4qExJdNMkPM+BW6vVrIz5Upwwblw9n1rKyCvvuY1rsLRPP05lfqOWODmVLXn0UoYC5e9F/lG/6sFapjAo71D5YZ3HlnIo5IhuZCbH05kOZDi6fJ6Vq8czp0ZXR8UBRNzuVI9QChsomn0NiAfF55nI1VEf1Ze+Mw3OqXqvkwHpgW5SdkWWOVcuf6tN761xraBqTtiLk9ZL8x5I8jKT9GjhMQRmrie7WDmtXmNXCv0fd2si4+Xs1qssyxauf4Q4ubqP34y7ZjonR92hp/esqcjiXgt+5XMNK2DOUGnjYyB+xIaVuYIlMIo8P+E8Mspk5ReEIqS3AxF2SyXy8PgJPkTYgVJGScZmF4NYNy6SVpVeLZ3NXlZy4lylRTeF4DQRx0Pvl8mTithpLIK8P5PE+g0KPgvtaHQzRxWu0BCJZDMKDKv4aKM43y1bFeAIaZwOJoolc8AnduzzVvt9BySFF7ktwHcgQNCzc8v5urFAlX29t8r7icU+s/Ne7LX2lHN2tm3sh4h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199009)(38100700002)(64756008)(66556008)(186003)(6636002)(33656002)(82950400001)(82960400001)(66446008)(110136005)(54906003)(122000001)(66946007)(10290500003)(71200400001)(4326008)(8676002)(921005)(86362001)(7696005)(26005)(41300700001)(478600001)(55016003)(8990500004)(52536014)(9686003)(6506007)(2906002)(38070700005)(76116006)(7416002)(5660300002)(66476007)(4744005)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pqV1jZs959hqJ4MohqDZmbRW2/75cov9RQb7nHlpZFVWpaI2LHhcN9APZfEe?=
 =?us-ascii?Q?PSzij0fiE9pF+KbwGeJ8cettU0XgTQxNn4SJ79jbG02aspDDsuIoc8M630Xn?=
 =?us-ascii?Q?upo2mkVR/2DKALlFvTJR1YBLPR6EylZzWJq72tfJDP8iNNS+CTBAdkFQqhn7?=
 =?us-ascii?Q?xjI61VgZXUbymemyfCB0IA2ZbMkKU2RZnJRZoo8i3FaPnlPvTcbSh9Kv3r58?=
 =?us-ascii?Q?wPrdGTrVYwoJ2NGzMMFdVIrGHz85NroKaB7M2lGBH/UnHK/HTNrsHWaXBTls?=
 =?us-ascii?Q?xLts+Zop7jhUhPWu7wRyazkOZb+45mxtJ2/uA7GgVPqb6+cryMRDC70aIWE8?=
 =?us-ascii?Q?hQUNg609Q00Q2/mHPKdrGL4jAyVDlvwCWzapHQa9AqP4Jhf43ApUWhXJqFlw?=
 =?us-ascii?Q?jncyy2d1CF8upiMhqJsu9zaMGCflgUSg1RpjCLb3V+kmNJThN7DtHb5vA01n?=
 =?us-ascii?Q?doqoZVJV6o0EA0kJJ2iTKIP3//2FjpkleXFqgHdJxAlJa9gyeMLHVFuaB/Xi?=
 =?us-ascii?Q?cfjrMhoCaygYroVBnJns+4/O3yzUHcdL9I5j3bqy4ZX3C8DOAl9ShRlPGbPd?=
 =?us-ascii?Q?u6eR31xefxbgr936aSdyIBO+roJOvxLQmMwKuIF4ED8q7E1jvfLeFGRWiVSe?=
 =?us-ascii?Q?ykA0N5EUi6PCB52aSfR1o+d6uO3nBdToi4WeqFAgqgsw/y8lFHhTkoAx5Cv6?=
 =?us-ascii?Q?6KKO9aEk42e0nxQ5pazrdi9l3gysy+74bykwh/ID4OKDLHEmOpL4RYgKSFz4?=
 =?us-ascii?Q?ancVg1N3vE/VJtg9IquhGU8D99JhZmffX4CeAKqTBN3m24GQh78gLKIMvqnY?=
 =?us-ascii?Q?PXx3pQd9+2AtJ3tPht3NrY3H2+OG9/i22esQz5oISxz4toxEaoG9khheva58?=
 =?us-ascii?Q?wsyJDByMxUv2sLezM+Cu1TdFuwQdEuuZZFni25MgJ9Xz5LusPgLW0ZWo9fvf?=
 =?us-ascii?Q?t955mhKT+FSDvzogmnPXNXh8nTmlx5npbtzySKa218ZJOdZTp1BP9J8xOYZF?=
 =?us-ascii?Q?5/bIBbykeif7Cc2LBQv2c+z/8mGxYm+QQrRlkVmypsX7GI6VEurvyfesidga?=
 =?us-ascii?Q?HydSD4C92K5DvJXRJpnZoNDzxJE0+E2qhUJjLLb9h5/6yZL1Xn0mKFIXR8bU?=
 =?us-ascii?Q?yM8MqrviJwFUy3sZm783mR6mu6MmqIo8WVcV0NVghOcZTPuINbW7GvKk3aXK?=
 =?us-ascii?Q?WQT8WVf8jHvrPkpAIphI5GwFIbJj036dEBdtoc/jX+QSsVhOSqeg44hK4mE0?=
 =?us-ascii?Q?dsjjS7gBr4LDP15tFUqxctxrV2HWq3Vl9GZI/EGETT+ommq5cKIkIs3+b+qn?=
 =?us-ascii?Q?K4mmigme0zZJ/MVlRhxW4JjjVcU0j3wvWLELEdcuUDLv+qsyS0FQuL0h1D2l?=
 =?us-ascii?Q?m2Q1RpzOf27FUqJ4C0aDk0xcVoVKbEbGx247aAs1g3TVLuFj+Prkjusae8OL?=
 =?us-ascii?Q?Uq5wo0CB0SWU6me5Wx3PQ7zjIWYB0DjiWe19JqVROTl1sL7PZzEuEfgzQS0R?=
 =?us-ascii?Q?Rq7bssjFQVVa+QKf1p6GnlA0nMTSsnNdSP/rEQb6BFFff2I+llGx2LgM/GnZ?=
 =?us-ascii?Q?oyY05T+6aanEnmDH4DlXo1Fz+emNj/kAi2sU9Nfi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eca33d1e-6485-4120-ff6e-08da643720d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 18:48:36.3196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v0vtglUq7UTbN22YKEQ2aa4ni4FLVKAUSdwIeYsUnUuv3Vln3MKeHgIkTSXXhrGsS43wYcxxTAa36v0NqlZ5EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3260
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [Patch v4 04/12] net: mana: Add functions for allocating doo=
rbell
> page from GDMA
>=20
> > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > Sent: Wednesday, June 15, 2022 7:07 PM ...
> > +EXPORT_SYMBOL(mana_gd_destroy_doorbell_page);
> Can this be EXPORT_SYMBOL_GPL?
>=20
> > +EXPORT_SYMBOL(mana_gd_allocate_doorbell_page);
> EXPORT_SYMBOL_GPL?

Will fix in v5.

>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
