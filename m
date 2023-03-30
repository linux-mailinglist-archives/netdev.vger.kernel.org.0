Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C511F6CF8CA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 03:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjC3Bkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 21:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3Bkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 21:40:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D764EEB
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:40:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcqj4pcqPvedoFiBFkrQAWexmQvMGR5QN3VhtYwBwLIGIfYJumB+XcwJNgmsAZgVhTCAVq94Az3h3iiYg50CjyDcSfo5EBM7A+D9X7AX9BkEEN5KFdOdtsyEUcvkxFt64/+72ji7Q7ZppDz4bRyHfqPLG7mF1812ZeQUUKaJq/fn/qMBH0hq1wtLKAAl/HKw8gSRFR9PeAkEkKviY16e9nQ0n2Ly3AoBQcN3izRkDIjSGene40FfH4CDRzbRacuX/WLbXsj+7awhOZysUqgE+M5fD9hIVlnLF9aN3w0iEPFZh7E8XNaFTTaPnjwOuEpQS+ncnfG5ZwXIL/fDZ4L6ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oig2LfSqzTRRF77hSic7b/Qh8Z0qpJWEBi8HcIX9URs=;
 b=Qefuusi5EGtlBdtI2qnzkDG79whYy/GbaoCK7VOyPAj8KV58rNEYyftHhqK1nqZGLervYCtrJ6hr+RfU4cYh9lBWEouMNbdrOwPlPZspETl0gsGF2wZXgHCEyri2a6BG6TylydQ59trJ71bLFWW5fcBLr1l3wgb3QnhwzUdiwDqf/MkPGJljDarG/Q+O4UnyXkLjmEaFkgFPPgL2NKlcJjela67Fo5wl7wx/R9Uz5efnZLu3bTXoqtwSg3JFCnIbWz9E5bTL9OREMIF8j6c64zoaTJ+Xz/tS3YqhSsITdM51ldyLywE+/ZyJZXjK4BSa5WC2IOj1X5MmDOh50wtnPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oig2LfSqzTRRF77hSic7b/Qh8Z0qpJWEBi8HcIX9URs=;
 b=d9/CwQ0H6cVErAYxY77rFdTij/UZXYU8Dwu0TeXMetcHaPJBsVX6XPlwBXJ3SsiktKi4cb5WE+q1FgeSVOkhPxAbrqYx65CiCpgMoR+DHI+0QFDHEMe+7ugMJIqikO+E93v0eDXa5++RnGZFgzJUQufMgiVnWXCxsbLo5j4mRhc=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH7PR13MB5865.namprd13.prod.outlook.com (2603:10b6:510:157::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 01:40:30 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 01:40:30 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Thread-Topic: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Thread-Index: AQHZYk04vPXGemGWL06stjs7wjJi768SIv2AgABoL/A=
Date:   Thu, 30 Mar 2023 01:40:30 +0000
Message-ID: <DM6PR13MB3705D6F71A159185171319E3FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-2-louis.peens@corigine.com>
 <20230329122227.1d662169@kernel.org>
In-Reply-To: <20230329122227.1d662169@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|PH7PR13MB5865:EE_
x-ms-office365-filtering-correlation-id: ad825a3a-451d-49db-cfb4-08db30bfbf16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RP2FhXaBnw2VyGAaCRvztuhwboXmqjA+ji+q5fDwdAA6LqGEk3jyshxc11eYVE1Bj8FLKQYMMt0kk8KEyZooHGLkavN++zn+fugB/StVB7D5i23q41QqCJ01M06amTUXDLgripIweZodqCsKs1cLX6H9Ivdr7diEETUD5DVO3rsgANt5AvmGsGacJNPQboIcD79FXdOZESfUnfX5ncrQVq6aDT3VwQ0yaJhsrqeWF0hi6FQ3H8jVQe0zzffwya/EYI5bo6eK6Teg1uycBgAqfXd8BWqQm6TyfqbRtym7Dg94MGLRJ8FZDdGouQ9W4qljqe5rQ9Ovt53DqTppHr7WhTYGAeYpb1p80ieQKWrSmNKWJAj9UIr7sIx/Srmq7Q4/bDP1+R7xQG0aKGcOY6EAcytXkV3gJLN5yZFNBSkhUIpatfmjKX7StSUv2CGCTkJ380PBdvHRHozUwOW+LLSLpyB1xx2HH0v+XWKtJ5UwWGJ10JPfWX8sCi5oAxY+CEtXFKG+iPBFTx7jpxFLj1VhHPvThSONIMpFuaXycORbTbLCLm9jpxqhMLz+mccMRjOtxZ6/8SULY47X7FosHPscVSduhjLEJ6xVdhdPxjp2YAx0F2OPA3oL0ocM5n9UmjM7Bk7Iqx+5A7yLVPf/8QlEjZU6aN7aiWnL1QVVrHyoEN0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(39840400004)(136003)(366004)(451199021)(478600001)(38070700005)(44832011)(2906002)(71200400001)(38100700002)(33656002)(55016003)(7696005)(4744005)(8936002)(5660300002)(52536014)(110136005)(6636002)(107886003)(316002)(6506007)(86362001)(122000001)(186003)(26005)(9686003)(54906003)(64756008)(41300700001)(66946007)(76116006)(8676002)(4326008)(66446008)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NLmbNkyRijt+SZnruO/iWKu+A9lT7ttXo6fW7aVACLobZ7PwwKOblP9aFymm?=
 =?us-ascii?Q?aGEML/62X5kBmkSCh0gCvO/xaINxPCjKET7hyevWnHpYcC+11BJ0+QgyGfn9?=
 =?us-ascii?Q?zVrpQeFC4I+tFN8hEfVFPNfDKUjbnrZPnXwDaktXbR9SNsx2cil4VQsWD28p?=
 =?us-ascii?Q?UWG0KJ8yJa0zajRX7xQfyoJn+zQqutG+P4KxJ6pA+2O3lKzG7XsYUUVpH/QY?=
 =?us-ascii?Q?wa5szzM0V8JQTCtwUXWvfQE9qlygrByMtyUIHUD/dP/t0pd9cyUVuKwKPqIt?=
 =?us-ascii?Q?sMS8z6ysfWjgwzMHV4gf+/WVO39KkJAkCHR/s+FoeqAdGzA9wMXJahX3sBf7?=
 =?us-ascii?Q?49jxb7WGEW2IZE56wjRDJqTHTObRAW4W6QL8tTRtBybXEC4m63KhLn0IdOs2?=
 =?us-ascii?Q?hj63JXFmkPWdjIeKN2sIzVWWYBGreY7Qb4gw+8B2L39CP2yT927yn7DwA8RR?=
 =?us-ascii?Q?6lByBWgIm+/zmdeu1y47fmamCq20UaWj2RrWJRO9COJ44Z9IcoRIptsuQ039?=
 =?us-ascii?Q?Rg/hbf29uZ59dKR6REk5HurNW9pEHho/4+8QzEXo5ar22QQ3nUzpxVN01qtf?=
 =?us-ascii?Q?ZGIP7o9g57pRX3kyifkq/EdJjpGF3Yt7zS4yV+MwopMAIucD90wMMK5GUDFR?=
 =?us-ascii?Q?cssKn5ZAVIgQ7p8FVb1KabBg9n0bI16ZmuAlXHXTRtNaabV1JfTVUuo4K7aT?=
 =?us-ascii?Q?haaY6RuOTsaF3FS0Z2NmKNK2DLwus8OMUcz1nIIX1mkLrwjcIsNkGaNeic6z?=
 =?us-ascii?Q?WmEehcNZ8kRlQVY0COr1C2/R3GkqqqDnwNRevwZ7Koo+9lZogEgLlUDo36Lv?=
 =?us-ascii?Q?ed0jmY4fWRfrFyyJZI+XWHhpucQlMGJjXFflGzWNsPNVhI1FwE7Qic+HzXuD?=
 =?us-ascii?Q?BLubZNkF8e3cL0+x2tZ298JZFoOzqTxYnvmGnjxN4Zqa0zyTdUmaua34DH9Z?=
 =?us-ascii?Q?5nUdoZwmL4X0fKZgT71zVTfcUVAi83ucMqQU/Ad/FqIrHuRe/VbNITjtPwbB?=
 =?us-ascii?Q?taJKZr+l8pCjLg/6fliCC2IfQz/LY9IwlDySHCXpfO6VfL6DkSO5Qs7GNCsL?=
 =?us-ascii?Q?Mdl6+2IHHb1O4LrrGKjS1ZMSCF3vyn7lAU7l8J3sI19c5z33P5WYiSS2e7aZ?=
 =?us-ascii?Q?KAVa7wPQTYVnvPEiiMBC9rd1k1h4aTnGDiKxkXtn8ONZ2WMhRvPstEfIptX8?=
 =?us-ascii?Q?spL63ADpWOep8qpkzbpajIyrD/ToXEd3GJX30rWUWR40C4EU0vGIG53Cxrmz?=
 =?us-ascii?Q?QRfgihQbRRXMp6Fuf+Vyj5LFH833kYCsEbwBF3N7c7kTMau5NRLrUpZMUDcl?=
 =?us-ascii?Q?0YAUwZPJ4116nDzfSu+qSBoyusbE1NP9VCC5IyLwJauQ3k8CvBrTWn++QcjZ?=
 =?us-ascii?Q?DMzJteeEvl0dcXevF13T3cEvwl3yNx62HoYwAvJcDGOfpEdkqR4i1yTbz1K4?=
 =?us-ascii?Q?P4r1To6ubMqW/1pN33yTUcmPue4TYD8Of198gOuogahSmEJXHSCi57151eC4?=
 =?us-ascii?Q?Ptg7PbVQnemuX/E/TcoZ4D3dY9OvQB2R3YfBKtp5FOU0r/hQuQcCDPvDdmrm?=
 =?us-ascii?Q?LBoQK1dNR47itCCYYM3p9Aqqb19yYDCQljUFDpDM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad825a3a-451d-49db-cfb4-08db30bfbf16
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 01:40:30.5776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3rd3q1P6pAn23jh0J21RVWQp9ExLs1GOEHwgaF+IVQEcgO/Xh/I7pkUp23YTRQs45KkMFrifW8KMT0Xwbb9C9oE6oD3GtKUpvY3+DGoAdgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5865
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 12:22:27 -0700, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 16:45:47 +0200 Louis Peens wrote:
> > In some customized scenario, `dev_port` is used to rename netdev
> > instead of `phys_port_name`, which requires to initialize it
> > correctly to get expected netdev name.
>=20
> What do you mean by "which requires to initialize it correctly to get
> expected netdev name." ?

I mean it cannot be renamed by udev rules as expected if `dev_port`
is not correctly initialized, because the second port doesn't match
'ATTR{dev_port}=3D=3D"1"'.
