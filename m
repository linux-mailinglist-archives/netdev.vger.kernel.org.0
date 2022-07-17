Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BB05776B0
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiGQOmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 10:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQOmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 10:42:15 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10055.outbound.protection.outlook.com [40.107.1.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9F7FEC
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 07:42:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfeQ0jGJtG57FpFVKwhBR0zsl0UOKcamOH0PHFaq/7obzWacbOYqO2cTwpwfF75dAqRl2xeWk/NwoP7ROhN98qbj/0Oo/JOEltsc6R5OLhegSvcRJG1CbTT+s/JQTToy35Csa1zQ+l3Cdd5Ah9ZkpsWXOpUyWloXZ3rsc65+nRUB1BkUyIb3x6JU01UjPU+TIZQMqNgueE6Lkn/mhPX/Zqg3D2WDGr89lxjkSLdDNl/bRxma3qww9Z4CQPdR4LcBav9y534/AB1M3w9LWKneR2X6WI4Kk4QG1IiDhMVe0/T3slSP/YeuuNqiDrRC46GzBj1qlm+UozXApmlevebMXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mYOr1qZs02wzSa+l+/efNQuvcUBAeForixL+Uwu1UVs=;
 b=bNBtMajK7oYchwLssU7++hD908oHfvCndlPQ0QaywhliKzAskh3ALZBvSJ3SE1ZKutmq9jTQrICYJB07ovCWceeSu5Y5QEy07iPObXdGyFnqUMq4vqhqHKvRPLbLG5Zn7+Ymhj1ZjXsLCBLe5nQ1Wt/DPfYGuEEvY8tmTCvPL/wBSG5NuGpbQbGproGK+tAqU4VWLtKnqKeQJE+wFLEsYrwg3bfqjgPJgTPP/HPfp0wBRVFBjgRFvvGLx244y7IQM1i0Nowh8VLgL+w4XfvEJoW8IoiCMP9yhDLBc61zwNrrkdW4efaJnoEbfCdW00T6ZbXEJJtf8LJNi1oCzCa8iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYOr1qZs02wzSa+l+/efNQuvcUBAeForixL+Uwu1UVs=;
 b=Bo5nxrtW+fle0PaKstJgtWcISW9JIadoXlJBwhcMOJRJaA/lw7lMB5niG0Hqh5TlLY0I8cDHbHMDTi1sKOIUde4iSfoKNrhEzPiv+uxO22q6JqTdTkukYcZ7bWH2ay7wbBEJgPrqT+deHqRfncOuR8IVtnLhEDWZjF4yeNS1C/c=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by AM0PR07MB6420.eurprd07.prod.outlook.com (2603:10a6:20b:156::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.15; Sun, 17 Jul
 2022 14:42:09 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a%5]) with mapi id 15.20.5458.015; Sun, 17 Jul 2022
 14:42:09 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfA==
Date:   Sun, 17 Jul 2022 14:42:09 +0000
Message-ID: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 41259d71-ec76-0a22-68c9-76f553a932ab
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b09624ad-1c22-4db1-379f-08da68028747
x-ms-traffictypediagnostic: AM0PR07MB6420:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /IzcTfng905fSdJo3sbNIItH5+lLgJpK8IECJGiHdQW/2BR2xWQSKZdoK92oWVBye4+WeSj2WvLc/wlSEQLRlwLsXlcR1RtLcW4JMwu9Mf0XBQuNeyTcEssn0kRioVgcJ201GrJe6CbOUFRvdcwFwjb3FIfCJK/1neEld2i09RezlpBUo3hETW61PyiS+xCsdbcPRQW87gKfInf/koEUMxwwMLSPdswGax5xsndZqy/aUgw+G16+CelVM4UivFGg9M39Gi7nbp31XZRwQBXe+GXITveGlL0cUVG+16rvqUmvcYkntBncYqAAx2OSzk5sUuUfjgEFudSRwEuvu4tiAChuRbs5ZetFYZSjmopWcIVpr9WIFK78BAAE2mFk6dnU6wtLv3LHKKnFlnL+XcyAntO+nT64W9wfG6p0gq5JnLVBVvggcAY2zdS3dcJ4S4c6uvGTCZ9Wyjj3UB+nHBL5+uavYIy7MLyR0vcEg6a9SJmRW6AueqhxwwDckttTpmmQuGj2KWp9VqnIUAXOyT0DO9KbRJgmHDPW3vq5VvCxe/v1N036gmf5FZxWuxkYCqJMhp/1plaEXIeeOAa3N2hKfSDwMKFAdFttzookzQAj1ovEVAr2y8ehekNeKuDUacqyoWNNqmmk+roEgxQwbmAVyhy0/F6OUaN72oAeKaJHkAbaAh3ifYjFBanJsg1qUSps9JiwFxixeDUYGWRkdpeYXw55B7XgO4GSi918asVXrm5ICWl42XgY1Lmb4h4RKZ+TZmsU6JZTEu8DpwrlvEtz3GaoEtQaH1bdawTGxXwFpztGzY1arYV8x/rkwX1c2njtDxvlJjXyno5GORaye3Ztiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(54906003)(6916009)(316002)(38070700005)(71200400001)(478600001)(8936002)(52536014)(82960400001)(6506007)(7696005)(86362001)(33656002)(38100700002)(966005)(122000001)(5660300002)(4744005)(2906002)(41300700001)(186003)(9686003)(44832011)(76116006)(55016003)(4326008)(8676002)(64756008)(66476007)(66446008)(66556008)(66946007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?c4kWGI9sMpOpNkSklpHWSBm841MT3+B7Gftk8NOgV649CHM21o82eSKnlp?=
 =?iso-8859-2?Q?ZpIwVrZHoXZ/WENFdqn/3sx7M9PBEp78so5fk0/mDbWY/rdOXY8ZkShvje?=
 =?iso-8859-2?Q?GCNu1qlMUbpnKeCUA8e8ZyCOBuuKd7x7PBwMwnDsTQskJyrOvK/R3TVa4Q?=
 =?iso-8859-2?Q?RTxMhsHz0A2toj0rURFUvByrpiCVH8b4KoTCineyj0OwjliOrxS6ThcjXZ?=
 =?iso-8859-2?Q?246NH1ZsskYhsQo5gChTIUZF2aYy8Z3T0C3zLD06ltnwC9n2uOMMmrSucu?=
 =?iso-8859-2?Q?KYJNQzPxLa+i2pA8dl/yRnPwbtLpwkjXSzgtOb1phcFHHe2wXRv56gM6sa?=
 =?iso-8859-2?Q?Kq2oZZ5u86XQSN4paYJ/QwAqOrEjK4XJrAqKqYwYRpdeyavwlE3uqQgjL3?=
 =?iso-8859-2?Q?7OtoBFM5r5s285FXWg+CMhHo6zYNERN/DpSWYmgePYxoXmra0RqqF5IEi7?=
 =?iso-8859-2?Q?mqtnTLvsfxG+E45MJAnauZdKaguIpoE1OFxC7tsJb4f+y2W2syLiH4iv3w?=
 =?iso-8859-2?Q?R/gr6B/N0KhZXZW1AzPW/a157v4645KDpwAv45rIHwEuXvcP7uaEzZr/7I?=
 =?iso-8859-2?Q?qU2aji3eKhpGRR2CSJIYzVCJI9b4v8MX1ZxGbuJHPcDKp4S5eH1aBon19z?=
 =?iso-8859-2?Q?q98A4y7xh1HzLQ2k5Uf/p6Mv5rQY54/B1Zt9czP1dtrWG1gWCC4XBIg7Ck?=
 =?iso-8859-2?Q?lzdvIU6A9XzZhksT9zu4hctqsGLwjFIEn4pWXrBD1UU6HPtmgV3OcWCGbt?=
 =?iso-8859-2?Q?GDrM1oWCmsgMM1ig8tH+tI/w+2+otJFCo2msPPULNMCTltkZvQTu6mmWu2?=
 =?iso-8859-2?Q?MdrnUjBJ846ugq68Ti3zgoMgCms/8JOhGRUJfXsTF5R70F6OsJhukZHwPv?=
 =?iso-8859-2?Q?bvFc6IYgcng4uWvQTU/67BtAHvI3TGcZqKLsWz0V3gBN213Kg+Et6n3S+l?=
 =?iso-8859-2?Q?n6A5uo3UiN2PCMnx7wPHjL52BW+FhnOabvACSt7h6StHZ4bxvod8g+vHLL?=
 =?iso-8859-2?Q?YlbTAFqoci/Ao2Z0GLuN72pnpa47Pa+8rHyoqsCfZGoTGooBOcbod0G16z?=
 =?iso-8859-2?Q?oQhkuoTohi7S6pv6IFpTmycPNPXYLF3RllZd5Nk6q1b6u0MdcsjK+ZDPKX?=
 =?iso-8859-2?Q?nfKGoiX0bTtTaEOttQV6IbFcjOhmuZ2B8ZEE8GTyqDBGMJi3sCrZsv8S+y?=
 =?iso-8859-2?Q?CLsfuv9Uersmz5Gmbil5fleDPXPryIVmAivjQVWNm5uv83FEUr06mMGp4s?=
 =?iso-8859-2?Q?upmZzQqOKyOoMZEjGHiwW0of/+ySuUbecQ6BZ1cW98fPE67dnl5AIFgbZi?=
 =?iso-8859-2?Q?Ycr5aa+E/vsGJnFTW2GAFFAzBwv/l7OssHLJSRdPNh34Occo7m/85TFn15?=
 =?iso-8859-2?Q?CUhqshbRULyknIiK3dPsHBftPtakNhLcKaCYZ0PEwuy5OSUHe8ydJ/Bk4S?=
 =?iso-8859-2?Q?A8B1W3WAkkyHKhBPs9MddwU2/1VMx0QBXx/lgZzogxaqw7i8n4y7guayGC?=
 =?iso-8859-2?Q?aIjxsz06JW8b20lifqX0hHKJTQPJgjJquYEvoGA92P4n1bP1Dj7HzKbo7W?=
 =?iso-8859-2?Q?S9LaKU6IpmN6xwxnqiMFum/UNIeOWBnHRldlpJUjRAXFNWeXRgbHZKdwcR?=
 =?iso-8859-2?Q?8OJTO84zksHtIBh7rRfxN9ErvUjOgQQ8Han/1ifEYujK0SDtSHE4x5p9Cm?=
 =?iso-8859-2?Q?lxdL7aX28D+wdieSe9AUnC9Ow8H2Jdxed4y4MNtQukNA7BZTPcUPECaYPC?=
 =?iso-8859-2?Q?mzWA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b09624ad-1c22-4db1-379f-08da68028747
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2022 14:42:09.5005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mipg6+VuG7w7OJA7PKpEh78F3nCFhAUaYIIWbJiMraooMlAP8vKudRMdmXrqVbBJGpFuF1i3Gm8Ym72DN5CnTlqmwocQ/uSx/WY3zmT4kI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB6420
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!=0A=
=0A=
There is a short story how did I end up here: [0]. We did a few measueremen=
ts with isochron and noticed many  issing timestamps. Running the isochron =
on the same CPU core as the igc PTP worker, the situation gets much better,=
 yet we still have missing timestamp. Then as ladimir Oltean pointed out th=
e problem is actually documented, so at high TX packet rates the HW timesta=
mps migh be skipped. There is also a couter for that, so that something exp=
ected.=0A=
=0A=
=0A=
[0] https://github.com/vladimiroltean/isochron/issues/13=
