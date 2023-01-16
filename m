Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AD666C2AD
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 15:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjAPOvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 09:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjAPOvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 09:51:22 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5FC2BEC6;
        Mon, 16 Jan 2023 06:35:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncS7o659XwAx43dBv37o7q5LvfbhU9B/IZkyEWxxlNBdnRe7arpsTbZCuNjhaGKBbq7jR/p+0uJpScLjg3D2az0ZElKHaPUZtMzCGGAP7rbVdBdA7peHeOEfyU4pCsOS/JDYmSorVKyRXXD0ZuT+f3HrqyeZnsf8DG/MRiHDxNZmLa8SozI/fziDZCoi77ViPSfkN5xfDl//voe7qPnKZMJRvVWhTn57yPSaKhTIYmVnJCtGZlq+/MPLnQSJ15t83yBsckKBuOtyUhjoUS28Z7oMsAJZnNfWxZw+HPMwZUNlua0yBdh09VzONUzYYxwvxnswi0yyXqHpIY6k2pYjKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f291mXhzFupDfcGc40rRiIMiRsIQoK88mZJHpLRt+78=;
 b=khP/+pdKPQ4IHfMWlbx8sEgFq11jSQLIsZVsIMLi2BwGPYyjfTGvbNkER6flZ487ri/OKd0cexROlpdP8xHCWjXVzKzGBWrkvoRsraGG1qXKIK8a3TgVDXnRwimUkYJe4yHEyGG3qVDXanGmJuN0qALaVs86Edll7OufaP+xVMHfC3d3HMGpnEEwXutliDt1vRDrzEbUTy2Iq7WhIEqAHnUclXRXstNkOYMQDQV++s6hss0le+E9jrYZLDu/VPKSTeAr6BdzqpoEBqYE8f4PAQhZ8hEXBnDfBateAzktO1x377JJLCi7V2fdHt9yBhGv77+kLh4pHlRWMDbu5cTKcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f291mXhzFupDfcGc40rRiIMiRsIQoK88mZJHpLRt+78=;
 b=QfONv9A1gG8px4lDUVasHBvHovx2/4mM8Lw43l1sOSt9oWbrGm3UK82Q2XN4Jd4nBPZpaxXMmfbCuzjOHWxQFBa5u8Ufbz5r9iQIrwz2ggWltm8Z2t5dQYD9NqOSWE89dWwVC12JOqPXqTg/ow57HluO6PIyreK9sWpFwajS2/vGq0P1Xdh/p/VJEIcNZtufQYVpxjY8uneIswzmI34/3Y6GHxlIejb6+3TZTHnOFQyrp4ga1DKY5rBM7CCubU/Dux1orewOegV0fA+jl6jysmYNypPazhDzJ9keYTj0S4zTX+0kI9SMROjCOA1aEbfH833TPmMc0ydKf+snwUXjXg==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by DBBPR08MB5900.eurprd08.prod.outlook.com (2603:10a6:10:200::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 14:35:48 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 14:35:48 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     kernel test robot <lkp@intel.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Topic: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Index: AQHZKPvgQPO0npisDkSvgN3jEdgJF66guzCAgABh8uI=
Date:   Mon, 16 Jan 2023 14:35:48 +0000
Message-ID: <AM6PR08MB43765B0D11E428F3D4BFF1DAFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <202301161653.hbqd7e0q-lkp@intel.com>
In-Reply-To: <202301161653.hbqd7e0q-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|DBBPR08MB5900:EE_
x-ms-office365-filtering-correlation-id: fbd1df4c-8049-44db-a041-08daf7cef5e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DVeTxJH2rW3QqviJ7F4WlWDL0lKOOzXCHYWrMKKWT2L29pAUIWJwJBH6SmodqR6EpEVzOIV4i7yAwbFIHXNMRiHXqYcKBLt4sn4Tf/iWHpsOtCIgCl0YS9o7CWQsZ/K5pjbljBRTM3DB3n6H7CB0wWiUKRT0CkNaOfaeJgpL+KUyYHGa9AUARQoEgfMLT0FCUQ0Zx3+0LOsWFR87BRVt5PD+ZlCLaQ4yjFynyUWuDN/fSd3Se4i7X42CIxFfbjWvsi1DyTZKUNpuNBL1oTIGiJ+MolLCCNEtKESljWhZGFW78jTcYOCyHWXRWqZqigb78FZmFW1OdGrQTApz/bUs8iSvRo6rpSFDt16nndGoa0ZjvPcTUX18XpMw4R252Sa9igNnGA+M4spb9xIfwYCuJT54rQqxyHZG+7lSvX8EhQnuibrB38+ZJEUh/8D8EvFM0waj1HY73oTZWBeX3m0FzNf01CwTmrk2zjJKUP3pWlQqJ/dDi4SinYlBZ/d935Us7Ad7GKBlMCisU4i2o7tjfwSveSHJtLW5bj/OYyHFNI2QHUQdWTj4qnh8Y15Ho7Cn2JYRiQ2mIYNamrygfO1ih91g+mMd2l+03tvNhktQB5NLUAeo0O3/RX8N9Vc3ji+XvZuswTl8vv4jeduadeT+IBnpjsF1FuZapdHG7P0jYWdOYdb+yLOm7O9UqcSOVQv9k+J7gRi8sM2iNqUbE+k5TSt3gTFu8EUfm1qWVvzH2UT2egNpIwWn0yiF0Ea2EM9q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39850400004)(136003)(396003)(346002)(376002)(451199015)(8936002)(26005)(91956017)(76116006)(41300700001)(66556008)(66946007)(8676002)(64756008)(66476007)(66446008)(52536014)(38070700005)(4326008)(6506007)(2906002)(53546011)(316002)(33656002)(5660300002)(7416002)(921005)(54906003)(86362001)(478600001)(966005)(71200400001)(55016003)(186003)(83380400001)(9686003)(110136005)(7696005)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?TJRdb/sGGuI4kgv67SmYhM/4miOCzVYnRjiltJTRvKUGZu2ppR7yMp4WdS?=
 =?iso-8859-1?Q?zbqZbMvtjzTTGvtf6xrGlmGpHL/4EtJGa67ClwLWodPbiekMo6d8to42iV?=
 =?iso-8859-1?Q?lVfIbrcv8ma9BbxmZy+jUCiY80hWNOsp4UMyVqpyhG2s5/l75JJrhwvnb4?=
 =?iso-8859-1?Q?ExbKFhJIbZmGRKDE9GhIgQM6CukQh5aseyQnt/PoB9Kk6lw6fq1cd6b+ml?=
 =?iso-8859-1?Q?xhB8hNeIeZeg29cDjDy2EdJSd6DuoQeqs7uyH3FDYgdxSNIGyzHoIJrlK0?=
 =?iso-8859-1?Q?un0pvLhtgJXg6jKIYiMZxqlWioQKIb8J5zfsUSneIku+4zQqq+PLzKwAmJ?=
 =?iso-8859-1?Q?l9DbzqPfuHVZAVsvabJgURxRMIzLfQMfkDW7E9efTMzD6fo2BIgfcuHvt2?=
 =?iso-8859-1?Q?H7jXaIo4uUrDdM9lj+qX7ysO+eK4LiBTISlVuT+1cGxpZpMHBZflCpstpu?=
 =?iso-8859-1?Q?37y0SjwYc4BDFHAxFkjZR9u+bUecxDLdRcfOb6CvC6+EWLIekDg/Y+aPQ4?=
 =?iso-8859-1?Q?E5bM+ixPN0A04ZXLByCPrXxyewp8q2avw9cyVd8WB6HAhZnbQgbycsliz6?=
 =?iso-8859-1?Q?2dIK09oSlsOgpJKzE4cGoeRbdL+8Jlq2dVZ/pTaYK+VXO152xRznK5ElRb?=
 =?iso-8859-1?Q?WH9iAJCx1opDTufIDUw9kAiIHIzhpVMGIsDGasc4mAfQocTMIZSdpHCxkL?=
 =?iso-8859-1?Q?maH3RBF//K9Ub0wwP0uSGLh9TFdQGa4d+KytWFu/C0qxMSPgQdEfrI1b7U?=
 =?iso-8859-1?Q?QeNF6Uk8cqIgL/uosBQI1EwCT20ramsP8ANpdaAa+L+yD2Tz+EeUsBoFWd?=
 =?iso-8859-1?Q?+yGxbutNt3y+rp64fgej81o942pXo7ihzSMmdfvr/ik6gmd5RC3+ogj/1F?=
 =?iso-8859-1?Q?eoKGqDROwK9VDRr7w0t0ncZcktwo+I024rrfG4Qfx0IPz9VeMG3TGfb+CC?=
 =?iso-8859-1?Q?igKQXNasQa5FDsMSuZDs/Z9bT1u66XLwIPEkI5pzG7Xqwhjnfw7N38eqZS?=
 =?iso-8859-1?Q?OPMm/js4EeTt0GVUNDx7ZDWRoMCdc4S8TPTxPgj/Tt/Q9BOVQ3QZPLQoRg?=
 =?iso-8859-1?Q?AMldyXBPb89sJ9bj1S7lEuA9g3NJyf7HEmOoXsFMu3hZ370HY7ZPbOc9pq?=
 =?iso-8859-1?Q?b18Z7ywV502baIRMN2g5ka7mGLoQYXFXS5hgpoElBXcdaz3+eKd/KmoVtV?=
 =?iso-8859-1?Q?tEyCnEcElZbjIp27r1OTWbA2b7bR2FW6q10/nyv8DjcQ9uWm9XaVtUn8kT?=
 =?iso-8859-1?Q?lVTQGVbuZVP8gyNDbqC7s8DH2C9EAM3PMrO6fIOifhUEhnqpYxXu0RrR1u?=
 =?iso-8859-1?Q?OX+MClS5vfSdNj1xqKKvi7uG8Ef6ZLXpO3fs6irpBxVILaJAUiTbL2OoLA?=
 =?iso-8859-1?Q?5npG6kl/GBcrBTqB3N3zfQvnZcRJmpUiQot7Iy/TsrrhYeBaqb16jdOdpQ?=
 =?iso-8859-1?Q?nMOksxCaIglHkYXH9Tr/g1CmMohBGCbjym7yGe1sopJcX6YwTtl86zQntz?=
 =?iso-8859-1?Q?Yr4fkktutT5WdhtGfgGAwNSDPBUuMgTcoyhQF5y2YdZuxGT6xkn3aqQPDj?=
 =?iso-8859-1?Q?zjOLnkgv/Tfrx8iiXxSSaUvngF3vvAKYk8PxGEhB/G7tA+vQDEemYm2eHf?=
 =?iso-8859-1?Q?xtuToyNqw5EPSErZern3Ud8AUqBlCLlBLe?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd1df4c-8049-44db-a041-08daf7cef5e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 14:35:48.6562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: stx+xfp/me4GBHGW8sdJP7+9Wt1/qotY/yG9mDLM/0hDuOYwXnLF4Plp5V0wgl9kw7kKuilfNOAdIMmfXCMjc2+EGxluoyEy0xIjeC7uKMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 9:44 AM kernel test robot <lkp@intel.com> wrote:=0A=
> Hi Pierluigi,=0A=
>=0A=
> Thank you for the patch! Yet something to improve:=0A=
>=0A=
> [auto build test ERROR on net-next/master]=0A=
> [also build test ERROR on net/master linus/master v6.2-rc4 next-20230116]=
=0A=
> [If your patch is applied to the wrong git tree, kindly drop us a note.=
=0A=
> And when submitting patch, we suggest to use '--base' as documented in=0A=
> https://git-scm.com/docs/git-format-patch#_base_tree_information]=0A=
>=0A=
> url: =A0 =A0https://github.com/intel-lab-lkp/linux/commits/Pierluigi-Pass=
aro/net-mdio-force-deassert-MDIO-reset-signal/20230116-001044=0A=
> patch link: =A0 =A0https://lore.kernel.org/r/20230115161006.16431-1-pierl=
uigi.p%40variscite.com=0A=
> patch subject: [PATCH] net: mdio: force deassert MDIO reset signal=0A=
> config: nios2-defconfig=0A=
> compiler: nios2-linux-gcc (GCC) 12.1.0=0A=
> reproduce (this is a W=3D1 build):=0A=
> =A0 =A0 =A0 =A0 wget https://raw.githubusercontent.com/intel/lkp-tests/ma=
ster/sbin/make.cross -O ~/bin/make.cross=0A=
> =A0 =A0 =A0 =A0 chmod +x ~/bin/make.cross=0A=
> =A0 =A0 =A0 =A0 # https://github.com/intel-lab-lkp/linux/commit/3f08f04af=
6947d4fce17b11443001c4e386ca66e=0A=
> =A0 =A0 =A0 =A0 git remote add linux-review https://github.com/intel-lab-=
lkp/linux=0A=
> =A0 =A0 =A0 =A0 git fetch --no-tags linux-review Pierluigi-Passaro/net-md=
io-force-deassert-MDIO-reset-signal/20230116-001044=0A=
> =A0 =A0 =A0 =A0 git checkout 3f08f04af6947d4fce17b11443001c4e386ca66e=0A=
> =A0 =A0 =A0 =A0 # save the config file=0A=
> =A0 =A0 =A0 =A0 mkdir build_dir && cp config build_dir/.config=0A=
> =A0 =A0 =A0 =A0 COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 =
make.cross W=3D1 O=3Dbuild_dir ARCH=3Dnios2 olddefconfig=0A=
> =A0 =A0 =A0 =A0 COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 =
make.cross W=3D1 O=3Dbuild_dir ARCH=3Dnios2 SHELL=3D/bin/bash=0A=
>=0A=
> If you fix the issue, kindly add following tag where applicable=0A=
> | Reported-by: kernel test robot <lkp@intel.com>=0A=
>=0A=
patch available here=0A=
https://lore.kernel.org/all/20230116140811.27201-1-pierluigi.p@variscite.co=
m/=0A=
>=0A=
> All errors (new ones prefixed by >>):=0A=
>=0A=
> =A0 =A0nios2-linux-ld: drivers/net/mdio/fwnode_mdio.o: in function `fwnod=
e_mdiobus_register_phy':=0A=
> >> drivers/net/mdio/fwnode_mdio.c:164: undefined reference to `gpiochip_f=
ree_own_desc'=0A=
> =A0 =A0drivers/net/mdio/fwnode_mdio.c:164:(.text+0x230): relocation trunc=
ated to fit: R_NIOS2_CALL26 against `gpiochip_free_own_desc'=0A=
>=0A=
>=0A=
> vim +164 drivers/net/mdio/fwnode_mdio.c=0A=
>=0A=
> =A0 =A0113=0A=
> =A0 =A0114 =A0int fwnode_mdiobus_register_phy(struct mii_bus *bus,=0A=
> =A0 =A0115 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0struct fwnode_handle *child, u32 addr)=0A=
> =A0 =A0116 =A0{=0A=
> =A0 =A0117 =A0 =A0 =A0 =A0 =A0struct mii_timestamper *mii_ts =3D NULL;=0A=
> =A0 =A0118 =A0 =A0 =A0 =A0 =A0struct pse_control *psec =3D NULL;=0A=
> =A0 =A0119 =A0 =A0 =A0 =A0 =A0struct phy_device *phy;=0A=
> =A0 =A0120 =A0 =A0 =A0 =A0 =A0bool is_c45 =3D false;=0A=
> =A0 =A0121 =A0 =A0 =A0 =A0 =A0u32 phy_id;=0A=
> =A0 =A0122 =A0 =A0 =A0 =A0 =A0int rc;=0A=
> =A0 =A0123 =A0 =A0 =A0 =A0 =A0int reset_deassert_delay =3D 0;=0A=
> =A0 =A0124 =A0 =A0 =A0 =A0 =A0struct gpio_desc *reset_gpio;=0A=
> =A0 =A0125=0A=
> =A0 =A0126 =A0 =A0 =A0 =A0 =A0psec =3D fwnode_find_pse_control(child);=0A=
> =A0 =A0127 =A0 =A0 =A0 =A0 =A0if (IS_ERR(psec))=0A=
> =A0 =A0128 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return PTR_ERR(psec);=0A=
> =A0 =A0129=0A=
> =A0 =A0130 =A0 =A0 =A0 =A0 =A0mii_ts =3D fwnode_find_mii_timestamper(chil=
d);=0A=
> =A0 =A0131 =A0 =A0 =A0 =A0 =A0if (IS_ERR(mii_ts)) {=0A=
> =A0 =A0132 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(mii_ts);=0A=
> =A0 =A0133 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto clean_pse;=0A=
> =A0 =A0134 =A0 =A0 =A0 =A0 =A0}=0A=
> =A0 =A0135=0A=
> =A0 =A0136 =A0 =A0 =A0 =A0 =A0rc =3D fwnode_property_match_string(child, =
"compatible",=0A=
> =A0 =A0137 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0"ethernet-phy-ieee802.3-c45");=0A=
> =A0 =A0138 =A0 =A0 =A0 =A0 =A0if (rc >=3D 0)=0A=
> =A0 =A0139 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_c45 =3D true;=0A=
> =A0 =A0140=0A=
> =A0 =A0141 =A0 =A0 =A0 =A0 =A0reset_gpio =3D fwnode_gpiod_get_index(child=
, "reset", 0, GPIOD_OUT_LOW, "PHY reset");=0A=
> =A0 =A0142 =A0 =A0 =A0 =A0 =A0if (reset_gpio =3D=3D ERR_PTR(-EPROBE_DEFER=
)) {=0A=
> =A0 =A0143 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_dbg(&bus->dev, "reset s=
ignal for PHY@%u not ready\n", addr);=0A=
> =A0 =A0144 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EPROBE_DEFER;=0A=
> =A0 =A0145 =A0 =A0 =A0 =A0 =A0} else if (IS_ERR(reset_gpio)) {=0A=
> =A0 =A0146 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (reset_gpio =3D=3D ERR_P=
TR(-ENOENT))=0A=
> =A0 =A0147 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_dbg(&bu=
s->dev, "reset signal for PHY@%u not defined\n", addr);=0A=
> =A0 =A0148 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else=0A=
> =A0 =A0149 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_dbg(&bu=
s->dev, "failed to request reset for PHY@%u, error %ld\n", addr, PTR_ERR(re=
set_gpio));=0A=
> =A0 =A0150 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reset_gpio =3D NULL;=0A=
> =A0 =A0151 =A0 =A0 =A0 =A0 =A0} else {=0A=
> =A0 =A0152 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_dbg(&bus->dev, "deasser=
t reset signal for PHY@%u\n", addr);=0A=
> =A0 =A0153 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fwnode_property_read_u32(ch=
ild, "reset-deassert-us",=0A=
> =A0 =A0154 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 &reset_deassert_delay);=0A=
> =A0 =A0155 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (reset_deassert_delay)=
=0A=
> =A0 =A0156 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fsleep(rese=
t_deassert_delay);=0A=
> =A0 =A0157 =A0 =A0 =A0 =A0 =A0}=0A=
> =A0 =A0158=0A=
> =A0 =A0159 =A0 =A0 =A0 =A0 =A0if (is_c45 || fwnode_get_phy_id(child, &phy=
_id))=0A=
> =A0 =A0160 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy =3D get_phy_device(bus,=
 addr, is_c45);=0A=
> =A0 =A0161 =A0 =A0 =A0 =A0 =A0else=0A=
> =A0 =A0162 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy =3D phy_device_create(b=
us, addr, phy_id, 0, NULL);=0A=
> =A0 =A0163=0A=
> =A0> 164 =A0 =A0 =A0 =A0 =A0gpiochip_free_own_desc(reset_gpio);=0A=
>=0A=
> --=0A=
> 0-DAY CI Kernel Test Service=0A=
> https://github.com/intel/lkp-tests=
