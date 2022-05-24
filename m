Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB09532A72
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiEXMe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiEXMe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:34:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2125.outbound.protection.outlook.com [40.107.243.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B044395A3D
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 05:34:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGiYemAZuAMxDBzMMvwEwcrfguAOFdoACCchaNTqkEgWbO1T+htj5IwiFQEt1Kqi1g6T95o/uuNsPF32Lw04AyqEavpRjmwzBfwDL4yeqnH0pxrp5ZACuNJPw8fv5eO5yKdWKzwOVuYqzAQSkILwPT45jVsrZSF+O0PGtXmkZxgJucCSVUVm8Zkihs+5A7c5pC6Gtc7MyD1oInq7lZzfIiSiUBrV4swHXr9gANaKELblKnc6Q1SqGvUlGpJYrDMvVtOk9y5H/snjmgRmbKSMAeCFR28Nnu38LDE8aFY6j0xhWrKxVluGqJILtcf60SWYUrMekPDJWKuAjX5ydI2Y/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cW3Go/Wu5xEaRFJmW/tAebp/c4l1SRnHB2DL6yJWpNg=;
 b=EAB21aQ0daFcV9QyFAheTzccgjwa7ZXkNXQEFVaaHoJMMEK+b5AHBJYryRFaDaopQlh68RXDvJfRA35CMAItzcqhsbfR5BC+SteYkcmtCA57Z/VXAdSApxeYj+Ool45ExQAptzw4C6hHoJ8Mo8qna5HKcGkHFZ6T32XQp+uLCFoxDZvnAYEJOWkw5Soi80KXHDaDAaepnVk4bHhAm5eh4GNzwZvCCY/H3/bjyui8k2+B//raM4mqiZdi+AdJcZWQJI/UAeLbCgBkgegvKWS6HCCc1VIOiO9CYTjePKu1Cu1Fshqlj3B5Z39o0lXITDi9cK/crQL9PWAonj1yD538eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW3Go/Wu5xEaRFJmW/tAebp/c4l1SRnHB2DL6yJWpNg=;
 b=WDMKXQto2mNhvHgYHmexoJTucXuxFhpa2f+cUYIoXiv2O/skiV+EgFHiM9SKl6W08xByNRHCepeHF4emUG7npMlZYb1XyIh8hs6I+vygKoFRytUZ4k71wemOwqepKBnadWAhXDRics2I0QLKYAsY78mfzi6WtVhDzdN/IaKrAyo=
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by SN6PR08MB5455.namprd08.prod.outlook.com (2603:10b6:805:a0::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 24 May
 2022 12:34:39 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::a405:a624:766d:ac03]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::a405:a624:766d:ac03%9]) with mapi id 15.20.5273.022; Tue, 24 May 2022
 12:34:38 +0000
From:   "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>
To:     "Shyam-sundar.S-k@amd.com" <Shyam-sundar.S-k@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC:     "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>
Subject: Re: PROBLEM: XGBE unable to autoneg when advertising only 1GbE KX
 mode
Thread-Topic: Re: PROBLEM: XGBE unable to autoneg when advertising only 1GbE
 KX mode
Thread-Index: AdhvamGVLXe5jsJoTE2g0nDZj/315g==
Date:   Tue, 24 May 2022 12:34:38 +0000
Message-ID: <BN0PR08MB69518870AA35A6A82088736383D79@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fc4d483-0786-410b-8a13-08da3d81c4bf
x-ms-traffictypediagnostic: SN6PR08MB5455:EE_
x-microsoft-antispam-prvs: <SN6PR08MB54550AC1E24F6174E2E0A40283D79@SN6PR08MB5455.namprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mydlhDkbPbRttsUUytwN/TfmcKTInAzq65qWjWANZiDznWFIr7tOIu6zXioIZQMfEehzrhb4RJxpIGtndSb7tWcN1ZnPBPMHGTUUcvR3i4W/in6dkiMqCu+8vkriFyBiF3T4nf/5duICnOkwO9mH04IJamxnLwyflWrLsZ6pwn+82YTPG5kjSk0qXdhaMqRqVHHcJqCHDbbX2Nhxq+LW7lggqKkmpGz3eXSh9ZCLkWoY+0+aC73qb92fI8KosKJbQEUL1QIKLqtMGBSW0jnlFo/LRJCiW5aW3ptz61RRhwVGABYX5s37OzriXs/jCsQdn4FtZlN1OZJ4y6e5YHeCiXb4oDzEe1kbQzC2T3fto10cDpWMOxoYrpJ5aLWSGhFUaqmnfOuHO4rVOlkDveDAjT++EmSmUOIW4+69aHg6/N+DUMKJTehaiLbtJNIFaUepM8YPBQnIY/HXz/Qqpi2UHucEaFeugf/dO81JkbAZCISJpcyGTIdEUSskNlkQbJFHlOwhrJI9HJxQ/IR4oyzKgTiFCd0vPy2u3TkK+dR8z/QXp5+MfDQOyI+ZWfROXkVheDwjTPsHRYkXLOn/nPszOilQIqnMaFtV37FCHQ6e1Jaj4R9+qPTRASkJZHxd70JeVuU7X9D054SzO5VXtqDi1u/mwWASFIk5Yn+Yx1wiXKwvnpaslY7Wycldh3gvJmdrOaSNfFYVa7+dUc6Rrvpz2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6506007)(71200400001)(26005)(110136005)(7696005)(107886003)(508600001)(9686003)(186003)(82960400001)(52536014)(8936002)(33656002)(76116006)(38070700005)(66446008)(66476007)(64756008)(66556008)(55016003)(2906002)(316002)(86362001)(4326008)(8676002)(66946007)(5660300002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l10hFKxD5A+IpEM6e9Bynzr2X2y92NfBWVIUxAfPEtEZQhtd8GyTOxvGJJ+9?=
 =?us-ascii?Q?78t/Z/9PRXWT0rjQkQUy10qyHunRFIjRs0AWjyXjrH+3IdTwPMThZS3R3dTb?=
 =?us-ascii?Q?0imNRE00CeCbGLLvlSvbYnhNDjR16Xme0lIU4bYPRLJqb3lOC37NUGHtir/+?=
 =?us-ascii?Q?u+o6PYP/zrFoygXCvtyUza2sRk7W9Bf7vLmacoTx82X7+pFF2wxdDdzqw0+J?=
 =?us-ascii?Q?qyGm4NuGlzDQ9hDdmf2G187dIk0HmNt3621q110a8ZIhbZKsVDlRZUN5IZyu?=
 =?us-ascii?Q?WOzOGObNb3TZ4XFoRKrPIKz6kHTbW/UrP9lXly2uBL1J+HoPJZtBg/869dfa?=
 =?us-ascii?Q?+lq37wrwa554kfDmoRn181nC+hCh7gn2WU2bWXbMaXPKq3uDQpSaUsEpCQpa?=
 =?us-ascii?Q?gDnN+TWxjQpMxhBV/PlZJgiH7jrGbxbSjN+qTb9ac3Jh5chEqmouBoXE7kT8?=
 =?us-ascii?Q?WrZv3Rf8fI+m6SbAcZJggD1RVOGot3Nu97lVer1WE/mJtd3LKjB4GCTAkK6H?=
 =?us-ascii?Q?yFinvnMv3ojpjS04dOY73ru+oCzOL4uumILvm5W0PlhOWcMLUVTjk87s4TIW?=
 =?us-ascii?Q?sTbNP08k3p5df9PnZe5lFC+8r1aePeDkunBLFXYvZ9L+fWoW2/3cWA0jkS0A?=
 =?us-ascii?Q?GFqQu5niaFJsRw1mN5ojnnyvpMFhKOy2bzg2rjgphcR+PSSjYFRoKH9P94JY?=
 =?us-ascii?Q?TAzjCFhASONlzpZJ8A35eq5PtzKowAEgomHfV0Ynav9k5OdahPeJtB7Q4Wq+?=
 =?us-ascii?Q?adX937IN2nISOX4/cVKIuC7PLYqMWmF0VSeF+ttdtwihnb291gbdsfwD7BS7?=
 =?us-ascii?Q?oOiiL/qyIDfmwtAT25pdWXmA7QsoVEJ8GIGYoclH7B4YPRoX5yWlzsbBeXto?=
 =?us-ascii?Q?p/3dMtUbVFgZXrJJ4WtH7WWik5KGnuskpsaFkCAvJQdeXY+wF0YoiO10Q6OV?=
 =?us-ascii?Q?0QGft/xFNYL6oLfR+sDR1tKSXreEeRG8bKumWdIpXjEknA9kVgQEnuz5DxiE?=
 =?us-ascii?Q?tI+oCfc4odKPz5z+Zk7eTrg4rtTzq9WT60M+d17CaZ57bLLz2YvPfAu4gL9m?=
 =?us-ascii?Q?EPpILG8W47I9pEr+F+R+qOd2JELNqSKiw96Qy0pbVAbZqVVXsaBB3eZCELwi?=
 =?us-ascii?Q?pGOf0Q1RdYty9wGUxMoLzLT15qY7DlXrLNIN1ugnjSR4+URLSzHX4kWcWukI?=
 =?us-ascii?Q?45M9+0/iNh51nawZSnOzjOE7YJhhB8di4OQhPn/qFAEI7sK9ID2R4rdHvJJ4?=
 =?us-ascii?Q?01Wzdq2bpkq1lm35EZF8BvksxcJV4A0qXeRG8WWLGYJTKvuJE0sBV5tK2701?=
 =?us-ascii?Q?TbPlt4E1ucVkrRZhacSq9INl3d2fGOTnVkpyic7MnZSo0PCYSx3tL1pTWldu?=
 =?us-ascii?Q?1u0SSeJZ30RBqhPj+wvOgZx5lV1IzRBt+OLEhz3vZQbVkuHGGgY/eAkY0ZD7?=
 =?us-ascii?Q?rufPfYqhWgLgQWxmqrtQq7ysiFQqf4FF9hNxTTqYRH+IU4xZ0Q2ysTeDEPG6?=
 =?us-ascii?Q?cyOWcdIxWJ8nkRSwD7FCKdlgiDK/OZ3ZgL+icFWt05XAvsbP8VddjMz0H0uv?=
 =?us-ascii?Q?Mw49KnowsSPTfAy8NM5Qf/kre3QC+xBGTISYtJytjWPJpWj0y5M3RxTSz6Uq?=
 =?us-ascii?Q?D6uLcgyi9C7L8iuL9rb13DJM9cA8UvtnbpCfJJ3F0kKSKwI5Fr4pbmqYVdYh?=
 =?us-ascii?Q?3QkTyEPqTvEtLdVhDOCQfKXAR3N1wJoC8oY9WZRRqmh+dLlTw9iBwPJAPjQr?=
 =?us-ascii?Q?Q0jYL+NiVYb+bfh59mzSlJCad1OQyZU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR08MB6951.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc4d483-0786-410b-8a13-08da3d81c4bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 12:34:38.6684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TA/Bx3+oIVs5FcnCDmLQU8aOEgy5dZqmNQ5J2ahlXWt69q3+8KSbGROyJoLBVwHSArZ1lnt5FNHb9WgUiY4a2owDalovw3NNzYmklGN1d6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR08MB5455
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[    6.554938] xgbe_pci_probe:261: amd-xgbe 0000:0d:00.7: xgmac_regs =3D 00=
00000094e72ff0
[    6.554941] xgbe_pci_probe:262: amd-xgbe 0000:0d:00.7: xprop_regs =3D 00=
00000052e3fd4b
[    6.554942] xgbe_pci_probe:263: amd-xgbe 0000:0d:00.7: xi2c_regs  =3D 00=
0000001de70eb6
[    6.554943] xgbe_pci_probe:273: amd-xgbe 0000:0d:00.7: xpcs_regs  =3D 00=
0000008a626609
[    6.554947] xgbe_pci_probe:295: amd-xgbe 0000:0d:00.7: xpcs window def  =
=3D 0x00009060
[    6.554948] xgbe_pci_probe:297: amd-xgbe 0000:0d:00.7: xpcs window sel  =
=3D 0x00009064
[    6.554949] xgbe_pci_probe:299: amd-xgbe 0000:0d:00.7: xpcs window      =
=3D 0x0000b000
[    6.554951] xgbe_pci_probe:301: amd-xgbe 0000:0d:00.7: xpcs window size =
=3D 0x00001000
[    6.554952] xgbe_pci_probe:303: amd-xgbe 0000:0d:00.7: xpcs window mask =
=3D 0x00000fff
[    6.554958] xgbe_pci_probe:345: amd-xgbe 0000:0d:00.7: port property 0 =
=3D 0x45000103
[    6.554959] xgbe_pci_probe:346: amd-xgbe 0000:0d:00.7: port property 1 =
=3D 0x02020202
[    6.554960] xgbe_pci_probe:347: amd-xgbe 0000:0d:00.7: port property 2 =
=3D 0x00040004
[    6.554962] xgbe_pci_probe:348: amd-xgbe 0000:0d:00.7: port property 3 =
=3D 0x0000a100
[    6.554963] xgbe_pci_probe:349: amd-xgbe 0000:0d:00.7: port property 4 =
=3D 0x00000000
[    6.554964] xgbe_pci_probe:362: amd-xgbe 0000:0d:00.7: max tx/rx channel=
 count =3D 2/2
[    6.554965] xgbe_pci_probe:365: amd-xgbe 0000:0d:00.7: max tx/rx hw queu=
e count =3D 2/2
[    6.554969] xgbe_get_all_hw_features:831: amd-xgbe 0000:0d:00.7: Hardwar=
e features:
[    6.554971] xgbe_get_all_hw_features:834: amd-xgbe 0000:0d:00.7:   1GbE =
support              : yes
[    6.554972] xgbe_get_all_hw_features:836: amd-xgbe 0000:0d:00.7:   VLAN =
hash filter          : yes
[    6.554973] xgbe_get_all_hw_features:838: amd-xgbe 0000:0d:00.7:   MDIO =
interface            : yes
[    6.554974] xgbe_get_all_hw_features:840: amd-xgbe 0000:0d:00.7:   Wake-=
up packet support    : no
[    6.554975] xgbe_get_all_hw_features:842: amd-xgbe 0000:0d:00.7:   Magic=
 packet support      : no
[    6.554977] xgbe_get_all_hw_features:844: amd-xgbe 0000:0d:00.7:   Manag=
ement counters       : yes
[    6.554978] xgbe_get_all_hw_features:846: amd-xgbe 0000:0d:00.7:   ARP o=
ffload               : yes
[    6.554979] xgbe_get_all_hw_features:848: amd-xgbe 0000:0d:00.7:   IEEE =
1588-2008 Timestamp  : yes
[    6.554980] xgbe_get_all_hw_features:850: amd-xgbe 0000:0d:00.7:   Energ=
y Efficient Ethernet : yes
[    6.554981] xgbe_get_all_hw_features:852: amd-xgbe 0000:0d:00.7:   TX ch=
ecksum offload       : yes
[    6.554983] xgbe_get_all_hw_features:854: amd-xgbe 0000:0d:00.7:   RX ch=
ecksum offload       : yes
[    6.554984] xgbe_get_all_hw_features:856: amd-xgbe 0000:0d:00.7:   Addit=
ional MAC addresses  : 31
[    6.554985] xgbe_get_all_hw_features:858: amd-xgbe 0000:0d:00.7:   Times=
tamp source          : internal/external
[    6.554986] xgbe_get_all_hw_features:862: amd-xgbe 0000:0d:00.7:   SA/VL=
AN insertion         : yes
[    6.554988] xgbe_get_all_hw_features:864: amd-xgbe 0000:0d:00.7:   VXLAN=
/NVGRE support       : yes
[    6.554989] xgbe_get_all_hw_features:868: amd-xgbe 0000:0d:00.7:   RX fi=
fo size              : 65536
[    6.554990] xgbe_get_all_hw_features:870: amd-xgbe 0000:0d:00.7:   TX fi=
fo size              : 65536
[    6.554991] xgbe_get_all_hw_features:872: amd-xgbe 0000:0d:00.7:   IEEE =
1588 high word       : yes
[    6.554993] xgbe_get_all_hw_features:874: amd-xgbe 0000:0d:00.7:   DMA w=
idth                 : 48
[    6.554994] xgbe_get_all_hw_features:876: amd-xgbe 0000:0d:00.7:   Data =
Center Bridging      : yes
[    6.554995] xgbe_get_all_hw_features:878: amd-xgbe 0000:0d:00.7:   Split=
 header              : yes
[    6.554996] xgbe_get_all_hw_features:880: amd-xgbe 0000:0d:00.7:   TCP S=
egmentation Offload  : yes
[    6.554997] xgbe_get_all_hw_features:882: amd-xgbe 0000:0d:00.7:   Debug=
 memory interface    : yes
[    6.554999] xgbe_get_all_hw_features:884: amd-xgbe 0000:0d:00.7:   Recei=
ve Side Scaling      : yes
[    6.555000] xgbe_get_all_hw_features:886: amd-xgbe 0000:0d:00.7:   Traff=
ic Class count       : 2
[    6.555002] xgbe_get_all_hw_features:888: amd-xgbe 0000:0d:00.7:   Hash =
table size           : 256
[    6.555003] xgbe_get_all_hw_features:890: amd-xgbe 0000:0d:00.7:   L3/L4=
 Filters             : 8
[    6.555004] xgbe_get_all_hw_features:894: amd-xgbe 0000:0d:00.7:   RX qu=
eue count            : 2
[    6.555005] xgbe_get_all_hw_features:896: amd-xgbe 0000:0d:00.7:   TX qu=
eue count            : 2
[    6.555007] xgbe_get_all_hw_features:898: amd-xgbe 0000:0d:00.7:   RX DM=
A channel count      : 2
[    6.555008] xgbe_get_all_hw_features:900: amd-xgbe 0000:0d:00.7:   TX DM=
A channel count      : 2
[    6.555009] xgbe_get_all_hw_features:902: amd-xgbe 0000:0d:00.7:   PPS o=
utputs               : 0
[    6.555010] xgbe_get_all_hw_features:904: amd-xgbe 0000:0d:00.7:   Auxil=
iary snapshot inputs : 0
[    6.555011] xgbe_set_counts:255: amd-xgbe 0000:0d:00.7: TX/RX DMA channe=
l count =3D 2/2
[    6.555013] xgbe_set_counts:257: amd-xgbe 0000:0d:00.7: TX/RX hardware q=
ueue count =3D 2/2
[    6.555014] xgbe_pci_probe:384: amd-xgbe 0000:0d:00.7: max tx/rx max fif=
o size =3D 65536/65536
[    6.555115] xgbe_config_multi_msi:158: amd-xgbe 0000:0d:00.7: multi MSI-=
X interrupts enabled
[    6.555118] xgbe_config_irqs:196: amd-xgbe 0000:0d:00.7:  dev irq=3D108
[    6.555119] xgbe_config_irqs:197: amd-xgbe 0000:0d:00.7:  ecc irq=3D109
[    6.555121] xgbe_config_irqs:198: amd-xgbe 0000:0d:00.7:  i2c irq=3D110
[    6.555122] xgbe_config_irqs:199: amd-xgbe 0000:0d:00.7:   an irq=3D111
[    6.555124] xgbe_config_irqs:201: amd-xgbe 0000:0d:00.7:  dma0 irq=3D112
[    6.555125] xgbe_config_irqs:201: amd-xgbe 0000:0d:00.7:  dma1 irq=3D113
[    6.555167] xgbe_config_netdev:319: amd-xgbe 0000:0d:00.7: adjusted TX/R=
X DMA channel count =3D 2/2
[    6.555175] xgbe_i2c_get_features:359: amd-xgbe 0000:0d:00.7: I2C featur=
es: MAX_SPEED_MODE=3D2, RX_BUFFER_DEPTH=3D15, TX_BUFFER_DEPTH=3D15
[    6.555181] xgbe_phy_init:3183: amd-xgbe 0000:0d:00.7: port mode=3D1
[    6.555183] xgbe_phy_init:3184: amd-xgbe 0000:0d:00.7: port id=3D3
[    6.555185] xgbe_phy_init:3185: amd-xgbe 0000:0d:00.7: port speeds=3D0xa
[    6.555188] xgbe_phy_init:3186: amd-xgbe 0000:0d:00.7: conn type=3D4
[    6.555189] xgbe_phy_init:3187: amd-xgbe 0000:0d:00.7: mdio addr=3D0
[    6.555191] xgbe_phy_init:3381: amd-xgbe 0000:0d:00.7: phy supported=3D0=
x0000000,00000000,001b6040
[    6.555402] xgbe_dump_phy_registers:1511: amd-xgbe 0000:0d:00.7:
[    6.555407] xgbe_dump_phy_registers:1513: amd-xgbe 0000:0d:00.7: PCS Con=
trol Reg (0x0000) =3D 0x0440
[    6.555412] xgbe_dump_phy_registers:1515: amd-xgbe 0000:0d:00.7: PCS Sta=
tus Reg (0x0001) =3D 0x00c2
[    6.555416] xgbe_dump_phy_registers:1517: amd-xgbe 0000:0d:00.7: Phy Id =
(PHYS ID 1 0x0002)=3D 0x6000
[    6.555421] xgbe_dump_phy_registers:1519: amd-xgbe 0000:0d:00.7: Phy Id =
(PHYS ID 2 0x0003)=3D 0x02f0
[    6.555425] xgbe_dump_phy_registers:1521: amd-xgbe 0000:0d:00.7: Devices=
 in Package (0x0005)=3D 0x008a
[    6.555429] xgbe_dump_phy_registers:1523: amd-xgbe 0000:0d:00.7: Devices=
 in Package (0x0006)=3D 0xc000
[    6.555433] xgbe_dump_phy_registers:1526: amd-xgbe 0000:0d:00.7: Auto-Ne=
g Control Reg (0x0000) =3D 0x3000
[    6.555438] xgbe_dump_phy_registers:1528: amd-xgbe 0000:0d:00.7: Auto-Ne=
g Status Reg (0x0001) =3D 0x0008
[    6.555442] xgbe_dump_phy_registers:1530: amd-xgbe 0000:0d:00.7: Auto-Ne=
g Ad Reg 1 (0x0010) =3D 0x0001
[    6.555446] xgbe_dump_phy_registers:1533: amd-xgbe 0000:0d:00.7: Auto-Ne=
g Ad Reg 2 (0x0011) =3D 0x00a0
[    6.555451] xgbe_dump_phy_registers:1536: amd-xgbe 0000:0d:00.7: Auto-Ne=
g Ad Reg 3 (0x0012) =3D 0x0000
[    6.555456] xgbe_dump_phy_registers:1539: amd-xgbe 0000:0d:00.7: Auto-Ne=
g Completion Reg (0x0030) =3D 0x0001
[    6.555458] xgbe_dump_phy_registers:1543: amd-xgbe 0000:0d:00.7:
[    6.556126] xgbe_config_netdev:407: amd-xgbe 0000:0d:00.7 eth3: 2 Tx sof=
tware queues
[    6.556130] xgbe_config_netdev:409: amd-xgbe 0000:0d:00.7 eth3: 2 Rx sof=
tware queues
[    6.556132] amd-xgbe 0000:0d:00.7 eth3: net device enabled
[    8.483462] amd-xgbe 0000:0d:00.7 bp3: renamed from eth3

