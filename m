Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B43E560476
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiF2PZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbiF2PZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:25:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3672AE3A;
        Wed, 29 Jun 2022 08:25:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlh6cofNIytnThGFgL48cSv4iBj2nw1Gur74v28KPM3l8O4jpg+QAddWwssgb8Wiy5FvTD3GcKbxRl1dl0EIOWZ99bSNcFUMhRuoyeciFG05iCjd8TQ8Ijmuz73NuEnW/0wxB86eTaXR04LtDEGKmMz/hhOF+M3CSh78DfN6Z1Pq0Zjhm41AzU9iov4hup41aNmUbAAgiijd8L5yOgl/1B6sv99PfHzdSFZJE+7cl2UuDou41blaFCCy0GOPQsvYaiW/WQ6hiQGcQ5WZlvJX4BaMRyqK8qH9Ey63OYqTmergj1SNk8A0zuilrrxTlHVGvj4O2T20NfjkWG6TulJulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4J1bblEEVNR8xNWs0Bd32EdtIZ9fgj6LKJqU9CEWd7E=;
 b=kP6jORzd7KrQVHQwTfYVj+b568EflT5605w7Xu3fOA50RnucZz6Jr0S5maUUlni5MW7USz2CQA3TEQT68db/IlqaZ+bKWkLyrK7FtGClBYEb0wxCjQHVt/VOtvq1i93XOxsVPQ/0KHv2NjmdEnvtBzz0cGTsmdGpww4OtTRx7lK1PG17D57YrXByyjyrC/eNLQQhYsXjEgED0y0Btjh4ND3TqfSVSycebvTxaHmr5SklRU0H4bSD+ZvMfbaAC70jZ79Ev7OHcuzreeXi/McLTIezO7bi1qcdBjGfxU0tH2pdMS5SNoW6pFWFGqVL+W7vcYW1bCKldhTXLDCUPRFYDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4J1bblEEVNR8xNWs0Bd32EdtIZ9fgj6LKJqU9CEWd7E=;
 b=zB27ZxIe2TXXqIGyGLrBGemF+80QzUnfDrP5LNBUSx/HoVJSZ591aau14M6U6/XJOWs8v5RsZGQtKRz4uaAzMyJ0fefYHHKgbb8MMK5mREOkgkCT1ly/KXn1FaG817M68FmowwH9aQdsZAvvXVi9sWhJFaDGg1I+Go1bJjt8vB4=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by DM6PR12MB2857.namprd12.prod.outlook.com (2603:10b6:5:184::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 15:24:56 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::f462:ef4:aa7:9a94]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::f462:ef4:aa7:9a94%8]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 15:24:55 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>
Subject: RE: [PATCH net-next] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Thread-Topic: [PATCH net-next] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Thread-Index: AQHYixosiAZkkNvB0EuYIDQYxYOPY61l1moAgACrUYA=
Date:   Wed, 29 Jun 2022 15:24:55 +0000
Message-ID: <MN0PR12MB5953872B976C38C430166DECB7BB9@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1656439734-632-1-git-send-email-radhey.shyam.pandey@amd.com>
 <20220628220846.25025a22@kernel.org>
In-Reply-To: <20220628220846.25025a22@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 904880c8-35ff-45f7-85c3-08da59e38587
x-ms-traffictypediagnostic: DM6PR12MB2857:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FchKODYCfUhJXGvylxgeLJ97zzT1WGQuckB88KijJs1xIe7qKfrvfcv5AFcrmQ+jtGw2DfNWssgAZ2J/eHKM+fkoRTH84DXrhziP6G6j5YjbTmtr4qaWfy/wuknZQRfHv3oAmgTAdVevbR2Bo5TYqRw04iIb+KmWTu2g4VUs4g5HedBaQaUxWAJPXyw8GtFB4d43pa8C7UR/vooRjOqcCBbH3RIgIBG1NGhcD1+EO7+Cbier+ECOh51N6sE5T+9gvzNb0Usu4YF6Dyg3aMXPFsj25kIxL68v0hc5OzLieOJfXbvRrhAayy9gcN/Dy7zrgBicEXVK7hCmBB8twHJkI9I/JhShgEZtzCLdaWkeNOpGlfdeoFwKq+8NyDjbhkofj2gQV04QWFjmN1ledmlMBJ5+Ma+yipl8WOX6XFL1cpvcqB14xaoGGLoKp4128lLm6lVjO7YIkTFh3VzGgdvLW8nNA7lfQghGTZBNepER8T12VYTwmFEVSuMQaXoplW3/vKOb87JGZv7intMuK1+AvMsKsB5r7UjbWf0lJQYFA2KKVMa1++qllo3+fYSd6AN9tDqwMRtWmRLx1DeXGLNmSqHsFcKD1XDILUwRPKtp/i7daaPiNRfOXqbhRDHZ2zTN395fl5VzaZcIIcsZe0h7tkOF0+texHl7Qj8qIjq5RKEKwzOyiUqgOFrJQqNYPJNcUOOzltdsetzeoWm4lh0kxfg4cTHXRJvfOwaJ1bGZDjivtPXOsOpppXoLc/YA1NKccCbebtuq1KV3kKIcHlxGiPy6/rwnT1YN/xAufcSQUJc3kXmnUY8o1xlNQprxppbbJSEJSYb9lYmsqjcEe6N1Sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(55016003)(186003)(122000001)(54906003)(26005)(71200400001)(5660300002)(76116006)(8936002)(2906002)(52536014)(66946007)(66476007)(64756008)(33656002)(38100700002)(38070700005)(83380400001)(966005)(8676002)(6916009)(9686003)(66446008)(6506007)(66556008)(41300700001)(4326008)(86362001)(478600001)(7696005)(316002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QVa3XNZvGKgFWFJjjENbQb2qeLMc61QLbFonAveTOTftfHu0z7+E7lavfF0E?=
 =?us-ascii?Q?2qKw/etr7v71FD1ZHnLgjUwPp46rAABJBJa54gPn39cRC9NnnmybC4/S93Lu?=
 =?us-ascii?Q?jtGpGLH210z+W3seAl4sR7symtYhWU8U4KMPHU+IxAzLtYEJngiHxfmwhZc/?=
 =?us-ascii?Q?d5VcbDhZ8SDhYWPe2kAyqbnnLfAmCERYDUYnfKAya9rluf5y4UqjLwvXSR1l?=
 =?us-ascii?Q?JfzDMyoUMN6uWsTsV04j6FWwo/6OgVvnMZpHASrY2qmoR59YtC757D8KePyM?=
 =?us-ascii?Q?pJX/h9agJR9pwoDDz0VHe/NehSc+1dgPj9HAw5UVasjWhWgIH55Y8tmS5cRJ?=
 =?us-ascii?Q?WNcGmWGTlIpBdkx17XGzsQrhfuBI2cHjIBgP3BibFDRVrljMHbqUSIR8rUb5?=
 =?us-ascii?Q?SrPcs0tmeHlmu/ErukuulRFx7QWhook7x6vnnmX42/5p9k644SmaqPg4dGRQ?=
 =?us-ascii?Q?D5QwAJQXGO1SwdYih3HpOisYQbwnmRZLw7TB2QWhDAza4xLeuwHw2DZ0aDRz?=
 =?us-ascii?Q?7QXUC+qnbYYDOB1P1d0yWuKr8c9PLlAzjMOCClV497b0F+eP7CwRXzBtmBiZ?=
 =?us-ascii?Q?ovdcVbbxUu3j3RngyLdxzuEpVCjiPhlDyAcCbEdUMWbRj0gWcZUHe8ZVxvwW?=
 =?us-ascii?Q?rz7NA52EOVGb+VWKjWcCeFgL1KddkIXKFA7NkvuLAHhsrXRY5tQccfx5meJp?=
 =?us-ascii?Q?T/U1WfehEBXtU81zkSwrTrZFmvKIahSxN/yJGASp9U6ymmImscTSU6O4lg6L?=
 =?us-ascii?Q?2E6tiel/kJU8ZW+MO2dTV6fJ4aSmrsn5uWKru+LjpBIOSY3Am8ljmD9kBRnT?=
 =?us-ascii?Q?7vJp/tzmF936EjQ2vqKLHdzCrXX+NysvHRakX+oktIT898KNpa6dnwTkzt8G?=
 =?us-ascii?Q?hne3YRB0cbZ8Ul9Ls2KIOPD9Qwi2/Bt1GKD1cWUlv572OicUneF1MVW+3ZwB?=
 =?us-ascii?Q?QDkxsu67Wrzxl29rVFoK2FVbyqyW7gOyiuO782ycBhb1TQl8U3CzUOxYvYg2?=
 =?us-ascii?Q?Zbte3d+bDgywOWk9LouF58TjcJBpbmDYqTxKw0y4AMfDjgq5RJrPZ5i5mpP9?=
 =?us-ascii?Q?VokfRU4ZUFXkjMBTv0k8WMKefEMI4AREjn6P3vpn1vUW18z0r8hqpDJAlxL5?=
 =?us-ascii?Q?RGcznZoRe/zvRNPUiLAtrKF5BHxNWd515wrZDm2QjhhsjSOjsSxaeRWwwWzy?=
 =?us-ascii?Q?X/Oxd5CCCSvwdFjwONdb8euzWq0wWwnwBNcjrOaF0pQbkCgcv/YLRk2AUWwa?=
 =?us-ascii?Q?sBBuBrzs0qJQF4LQk815FuAGhw+phSIpGwFNboHXi8uh9UiA7v6uR/UQqe39?=
 =?us-ascii?Q?Pg+QzZXBj1eknUZ8u/7lRLxBgjMi5fqTt3OuaRRAXcX6hQ5r8S3agFMoa4Ye?=
 =?us-ascii?Q?400ljwEGGeD1a4CF8Y4WFKzw0U/vTqoFqpDeCDvulgglmPGAyGSfX46mrlPN?=
 =?us-ascii?Q?ewQNxdtbqLwLRv9PioIA7Uq9FVzM+pD6NfzA4shw7xHCLvF5OWpf5rBkEmWn?=
 =?us-ascii?Q?diMfYW7k5XjIYzPV9vdcSmhWvdGYNzuEIKfsN6LyDhFz0jV7pbMmXvJg3IRI?=
 =?us-ascii?Q?tzKrCXFNOtLJPGLqlcI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 904880c8-35ff-45f7-85c3-08da59e38587
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 15:24:55.8889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DOw/7LaYggrYCKnohFjlPjeCA3VeIYWsfWVKtdAosCKxBtzZrloktvLtblNK+Ivy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, June 29, 2022 10:39 AM
> To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Cc: nicolas.ferre@microchip.com; claudiu.beznea@microchip.com;
> davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; git (AMD-Xilinx)
> <git@amd.com>; Katakam, Harini <harini.katakam@amd.com>
> Subject: Re: [PATCH net-next] net: macb: In shared MDIO usecase make MDIO
> producer ethernet node to probe first
>=20
> On Tue, 28 Jun 2022 23:38:54 +0530 Radhey Shyam Pandey wrote:
> > In shared MDIO suspend/resume usecase for ex. with MDIO producer
> > (0xff0c0000) eth1 and MDIO consumer(0xff0b0000) eth0 there is a
> > constraint that ethernet interface(ff0c0000) MDIO bus producer has to
> > be resumed before the consumer ethernet interface(ff0b0000).
>=20
> ERROR: modpost: "device_is_bound" [drivers/net/ethernet/cadence/macb.ko]
> undefined!
> make[2]: *** [../scripts/Makefile.modpost:128: modules-only.symvers] Erro=
r 1
> make[1]: *** [/home/nipa/net-next/Makefile:1757: modules] Error 2
> make: *** [Makefile:219: __sub-make] Error 2

Oh, I could also see this error when making it a module compilation.
I will fix it in v2. As an alternative to device_is_bound() i think we=20
can check the presence of drvdata. Similar approach i see it in ongoing
onboard_usb_hub driver series[1]. Does it look ok?/any other suggestions?

-       if (mdio_pdev && !device_is_bound(&mdio_pdev->dev))=20
+       if (mdio_pdev && !dev_get_drvdata(&mdio_pdev->dev))=20

[1]: https://lore.kernel.org/all/20220622144857.v23.2.I7c9a1f1d6ced41dd8310=
e8a03da666a32364e790@changeid/
Listed in v21 changes.

Please let me know if there is any other feedback on the
shared MDIO dependency implementation.

Thanks,
Radhey
