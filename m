Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5737757228E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiGLS0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiGLS0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:26:18 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BF3B79E5;
        Tue, 12 Jul 2022 11:26:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FH+NXESWvfkLz0Vbl5P8wY3b9Zbg/MN1/cEzA/++URF2N6L3LvKbAvauK4bwyHAwJaH6ILyEOItj7PkDozBo9AiF+GfmOC323+12UFjUeZaiVy0CkePgWgrJEGusqgThsepWM0KwuaBK3p+C5XwGKVnw49BabTsuhkUBGQxuv8bOrFyx5zmL1JEZX4uhAohZUEhx4BrGuVBSHEEAF7u+LJx7Mb4vKoZwpAixLGlAS8Ag19wa/zBzZ8kKildbGimlo/Hp87CFtGUsX9G5es2JfiKnuWtHigb87e3zIi9ujXxsocs6GhFbiRvEHU317J0HnUf3+ebnMke6uyO3JOrRpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aEsB3t+K7V4L/rgJyOwAYmAMNjrAXA2jGjEbV8l4u7Q=;
 b=CCRevDcGFtGwpUT/++8ykQiRJy/t4TL7uf2wRfmnfTV6UcoRREPybLNTMubblL+iAIyQk1zLvDIN2Su/uJp/t/jytPon6pyKD5XDt/OjIiwaEG3CfxpXb4LcKELwmQrXtRo1Snfbpq6erGIK5qsTsDXJu6MKrOUZ0IyRkr5twuQ6H81RUKt38ob1eSefzoee6mBhDKulGQ84pSFf8p6hmSBogt15fBowEE0yFqTgEDO1qL5nxxSupU5avMwwt3IuAxNGwSpDsNDNqjM6/FXx+BRrUmnEBmh/TvNXYsnbAV8XNrDCU6dmgBsRPvZU14WRcUBL2Zq5/D6BqR9+N7wCQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEsB3t+K7V4L/rgJyOwAYmAMNjrAXA2jGjEbV8l4u7Q=;
 b=Aarr8Kg3wMbpFJ+pg+9TuNvc1vIhg4JvBYMviIiIChgNW4igT2WkGRX6dCd135UyE0HP7z9f7xQqM926IaLiJx4KFJLSJ+yEK5LaWUSAM1q/F8XuEqNtMjB/a1af96JeL3lzl5wx5D/dG5vt8l997bjT3n8AUpzZXx5bTtGK6+8=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by IA1PR21MB3475.namprd21.prod.outlook.com (2603:10b6:208:3e0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Tue, 12 Jul
 2022 18:26:15 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9%6]) with mapi id 15.20.5458.004; Tue, 12 Jul 2022
 18:26:15 +0000
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
Subject: RE: [Patch v4 01/12] net: mana: Add support for auxiliary device
Thread-Topic: [Patch v4 01/12] net: mana: Add support for auxiliary device
Thread-Index: AQHYgSXXu075rVECPEm2AeIJs4qrE614gzOAgAK0J1A=
Date:   Tue, 12 Jul 2022 18:26:15 +0000
Message-ID: <PH7PR21MB32634D06AB33BE9059FCCAE9CE869@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-2-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB1327CE60943946FBF1FB7A3BBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
In-Reply-To: <SN6PR2101MB1327CE60943946FBF1FB7A3BBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a2c465af-e807-457b-abd9-6fcc1df7f37e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T22:11:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4340c3e2-f6c6-48ab-9006-08da643401b9
x-ms-traffictypediagnostic: IA1PR21MB3475:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SP1x7bMwHE73DwyFvD5yFQWDq3pF/Ur29BUTC3ftv/62kOVGKKuXc596J1KZLkF+FJk7n7MrRy8vB1RBYVIt8AIDhtxoL3JeuwuBCTK49mbyZOvXX5e7sIogKC6YZuqg7R5bYy5+AxfiiFhB7G7jg2G69PNS2j1lqGogEUqGznvvFvZJRl0YYJIcC85+DhDwDIshMqA6O7Od5fE2e6tGvoSVOzLijg+SJ48MFKImt5h/JouNOAKilKkopF5PEn1NsKZJyZwkjXjNKxk45TWAi6tTAL+38BKnyimjRcM7ZtXpcgteZ3fLkAK3Zcolr15h0XG4Z8/Er/i4ju9hP7ZqyXcqSYIZ+IKcLMV2K1BcBItx9v9ER0sQKlYOqiG56p58Xx6QWwM2yFOXpBJkAr0UyV2xxGVv/4+qjke2PTunVnj3NfNRaF+ONRWz6cKJYoqno1hOyUaxeq2km3KsPQT3dnWGkCZpLL7KqRy2lr0dJc2yWejMlYiJJRomBevYDc4ij4sH8sM/BYdkNNOkGPB7gjlghjrAEF37qy0Dz2wvXehyz1BJU6eYd+E6JboNOCTr7yLPRAWpXFQXms1sb6t7Oz9xatla7084dotFRG9R5jbkJpUABYP9FQiiUfMyKMWsrJlbhIVw5VjGO/sMMeckyxCYr4bFaREJSCywlmGNmXHSa5n3XWfLxbvYQ+Bls9mGVjg0QieB9zT8M0zZICFIrzBS10tWK/PyWL59RKnq3y48+dKid1w6hwm/0nemHRkX/oxvEcMqyFqD27hHQmIVpLMTKoDgM7WXPcRZJ9hM0ZclN+SNj2MLguWyPJPYCeUA+eThPCLOzzO6GtUl3JS9viGxthG4fJ18hbCrNkCXLvm9J63cs2Gi2y1fGE83BU8H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199009)(478600001)(122000001)(4744005)(83380400001)(8990500004)(6506007)(55016003)(38070700005)(33656002)(2906002)(82960400001)(82950400001)(921005)(186003)(7416002)(66476007)(66556008)(66446008)(41300700001)(316002)(5660300002)(6636002)(54906003)(52536014)(86362001)(71200400001)(4326008)(64756008)(8676002)(9686003)(110136005)(10290500003)(26005)(7696005)(66946007)(38100700002)(76116006)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VQmqhT6MoenZeT4qs5gra/93lraCg7BebxA0EoEGRNTdSTLqa0ptsuHc7pXV?=
 =?us-ascii?Q?9h8Tneug+jqUdPBO9lMLrPL1rWtd/xSfTikYbEbW0Z6SXmdxg8znjgPOuL+d?=
 =?us-ascii?Q?S/8KnTDuIzB6YcZuUs7ngDp5p3RUVq/4SaVnhVTlmc2zhPwHCEz0V68+SInT?=
 =?us-ascii?Q?i/zMv9duBq/wEKwaSMN9KI14ngH7d7M9IPeRNEnzhbM3UNu+1jRe5kAw6WPa?=
 =?us-ascii?Q?ixwQsLymA+opclWWyEJ3OdOAKmUycOqJTI1o0ucB2MzYt/tgYsUiLfS4sgbU?=
 =?us-ascii?Q?cqIruJtt6AakBNp/qhmqDf3H+hhrnxLmk33mx5WAwcpPCCSejpb2djzCWPxx?=
 =?us-ascii?Q?wl2Y3JdSLi8UiqvMym3loXh1kNN1kHjW84//kEVc7kXtU2q68CDbl40q7xTy?=
 =?us-ascii?Q?o0ajYi/VuVbp27K2l2GP/aGx0duMHh/VvM4P3jlceA3txWYMZcrj6hzAUkS8?=
 =?us-ascii?Q?aMx+1v5SfyiLHN0LbhDPgClNhMOUMvA+x5mKcF/jiSRUXzXlMiLpsTEZFjzw?=
 =?us-ascii?Q?0/aBMwhIGob/zBHF/T/+MYiFBgDc/p7JXshhTxNYwvWZjC8guqgy7R77U4iJ?=
 =?us-ascii?Q?MHD+UXagEYo+jw1fAvLVZ7Oe7HPID3xXwF+K29GJqoJ1ahMHrDMlVOfKcuhz?=
 =?us-ascii?Q?o3Y3V+psfBTTYoRwJUXbIW9QgVaozkASXbU7EdViM9L738DsQS4eEnr4CyIA?=
 =?us-ascii?Q?aYHVyh0js2Int94lqM/dO05lmbwjvc/dT5Aj/nLOSiL2z8Q4zOWH808aS2Jk?=
 =?us-ascii?Q?PBrEccn8VwoJNbolbe7mZp/RScITAvTK8viWxTh4gm2mYxkcUGlt3JbCqK/H?=
 =?us-ascii?Q?u/G2SJhzms9ZQCCQFq1fCD6zt6EuL4Tr4jDzmFqf/8riQgPwyOL1WFqtt+Kf?=
 =?us-ascii?Q?j6gezDkm/1R5mTUyLebf7YRR2ySwkp3KxbqT/eKe44KpE1/T18f8EHqzRHvd?=
 =?us-ascii?Q?TkFzd+2lGVEl4NTn0LZvEUsSuZS1qaJeSmuL6UsOpjra9IACgDLkEjQYVkBG?=
 =?us-ascii?Q?qoU9yx7O5fz+C8yQErNn68XiyyhkN4DV6jslHjVXzkjyEeBuFTxa4tZMb+JI?=
 =?us-ascii?Q?nvpHGzRPjm3BPOmmAY8tH9DuWEPSnXGPeyeltFk2FCw9kUfWFDotyw6tEFjK?=
 =?us-ascii?Q?qVHwzo1z5A49ICWre1J0vZ1rCkfT20U9UQ3jvBrNIWgkcn+0X8t0C2I/Be/B?=
 =?us-ascii?Q?jQslb7EbcXkt9NpkemGbLC/sFChzXM34sXPfcZ8TP75yx8QdVL4UcqP34MgI?=
 =?us-ascii?Q?iUYe5FF10hvSYj5+xsXwAeCoDwfDGCeeTst8w6h6ZpLCdtI85NVFenaBlBhh?=
 =?us-ascii?Q?mqAdZ9pHx6XWD5XjKOlM+q2skX3jXZt+5k5cv/UsDF1FabDKV54zWZKX8GLO?=
 =?us-ascii?Q?BWVqNbvC/CLzatICylHPmoa45PnE7qA985TELoJt5quoe/5W0Gn/AraEYB5G?=
 =?us-ascii?Q?FG7Dx8zDmJ8Luq2Zvig6IjmonWaFfZS3kgr07NSWrj21VMbWxrpij7JeuIOp?=
 =?us-ascii?Q?pR3zfEMA2zkfFz5XTR5yKzqlGGyLxoMnt74VdQ0oyrP0kA2WmCJH3pH5Qnl1?=
 =?us-ascii?Q?EwrIu6xsP9xmcdd0BGpjKiVHhJ8Z8eBIz2pBoQ6R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4340c3e2-f6c6-48ab-9006-08da643401b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 18:26:15.6205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7jh0RNtHpW0VuIuFb2dFc8xrbegNpuxl2jzCeplaU8zED/1g7UkcDenIEEe8bRhU0KoN7nmI2DSpjbjigMV60w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3475
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [Patch v4 01/12] net: mana: Add support for auxiliary device
>=20
> > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > Sent: Wednesday, June 15, 2022 7:07 PM
> ...
> > +static int add_adev(struct gdma_dev *gd) {
> > +	int ret =3D 0;
> No need to initialize it to 0.
>=20
> > +	struct mana_adev *madev;
> > +	struct auxiliary_device *adev;
>=20
> davem would require the reverse xmas tree order :-)

Thank you, will send v5 to fix this.

>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
