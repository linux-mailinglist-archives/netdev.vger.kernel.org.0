Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C37166BBC6
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjAPKcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjAPKco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:32:44 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2088.outbound.protection.outlook.com [40.107.7.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FEF1ABDD;
        Mon, 16 Jan 2023 02:32:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4tABJHo5efvNyiM0AzhAr3xv2Cz9yKRwMDGUf7Kfi7F+PZ2oN0wNJHCZLAEBqIMArrs/TcNqhZgLitGflAoF9AZcdbcHO936M0JOBEEnuPfHfh4pzuQvXz8sf0CYrjp901oWjYqf3ZHELqq9yS4gScxF8D9BtRJtE69/zVjbk370lnRco4JUv2nH/FaBAQ1W5zGYx/+QCJmk70ro0fWtb2G5pTyDclZt7BNCwJfbULPkILqwFzgmq8OFlGj0vxQQezQuyrZgSPJteaidXPKrxhZ/h2oNldC9rs9PSfZVwmvAlU2HwslDaZwft4fZWsxyAIQrzQMNusdburgUuMCWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8fWUca0PiWX0O9irULDaaMBo1ls1cgBL5VOTafgP34=;
 b=BdQBJnGrfm1Bck0pnSYtBRfXJmmNmwTKukWenPjSMtxEW7BlyqnBV7u2R+FlrXpHZW5dzocTIMrWoNW57/S/Zta6YG7LewDtWjI1X17etw+FQYtqW2JW7TWCYBmgp2GLlINOBH4NkOiJob8XshKQSmG0dEEyQYoHW2iSGAyOGTFnVDLw4Q17vwf5hKMSHPzilsq3za5LAbPek3K7dI9pWZVX9GY/3y7zUPbBEZ7uo3hNbq8hm524umt5qFYyUiEEpVEB05FGoxM6e0VJUTaj6Ou2gHg4swa9QQtXjx9nYb/17SqbKVBD5Cw3X9MF9qDNp2vFyqR9fnqeKlj2ZaSXQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8fWUca0PiWX0O9irULDaaMBo1ls1cgBL5VOTafgP34=;
 b=NsZ1Q08Bo482ZFky0fEkk6nQ4RZEpeh2QhCfiQ0DdjkJQz2MR1UNnNIrmsnGRnBEuOyPP0Iak5fIPBFyH6dOe8mXdWmjaO5WJbBzrjPvrdPFlfleJz8CY5Th3fyIYYdm6mgPTinp2pyYKGOsxMdJwsd43QeleWuLrE2KZELV5eAh8uQ3BdS9GRN+ndf46WrWwvf85U/n2lemqzy2h6Aq3+XlPdMRG5mGcREObtX3BTMmTpx1GxR0KUHN4LIvWQWy7wNaT8WaBMsRGn09kUnDGCpxGNslBZrhOjNfSp3BKpI/uWdWnEf9H05/vwC06qjfUpqk6I0lfy/93QGPVncTvg==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS2PR08MB9224.eurprd08.prod.outlook.com (2603:10a6:20b:59c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Mon, 16 Jan
 2023 10:32:38 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 10:32:38 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     kernel test robot <lkp@intel.com>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>,
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
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Topic: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Index: AQHZKPvgQPO0npisDkSvgN3jEdgJF66guzCAgAAeWnA=
Date:   Mon, 16 Jan 2023 10:32:38 +0000
Message-ID: <AM6PR08MB4376E687ED26A7DB0DD5C331FFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
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
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|AS2PR08MB9224:EE_
x-ms-office365-filtering-correlation-id: 1cbe6b12-c11a-4a6c-40b8-08daf7acfd36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mGr1O1J08ibu0idwzZf8ozdhZS83g8fb/LsJpH7/2VfVKdcuk9I2US7pNBJMXMgN8XE5b2FCmIffPa/dn7ElTqW3rZolAOFh7gGjmffeBZOb7ZinlLjbNnw7wQz+5qbVJUTTEpaef1IqJZXn46sVltNtAarkIyMS50yugETQpufLAbsZWMp0OaduZMFKb+eV1Qj/wBAMhFip3adXemfQ/scrEpiD6v1SdvvsncqlexWZqQjfewh/wvXHkng+gPFy01KYEB75wFHKmKhTChGHlKLsQaREXyg0Mwrx+XAnQdQrohdB8zsRp0SxOtOGGfy1PS5wbACnnBD/wopjkZoMFHEqyiYbYw5uJ8uabH4j9faol/FFmG0XucVN9SwZbSe/sduNNFqDdJm7ibdsXendfVuy2rWniTJ4ropYKiqb0sXUlJVl2SmvOif2ZIGfv/RuFSO5TN+gZcIifju7dLr9iS+EkWH6W9U51ykJwUgPtCoDx7gocEWt51WSsd/5MivlGkE7GIYkd2B1TVQpJJXDKsVpEpAu6ngAjsv08Aqkf1BczpZt59Q5WFm8ohdl4rpt0+oV6X76NY/KLOsEuHqQp6X2PbLyf8a8daTcv2SXoRSao2LN+gYM9PFev+I21SWkODBEr3ABVDAVCZjqGiNgaGmZJguT1XQ3dF3hd0nGm9oaTowlmhTHLB/wtSm1+JzShuqmb/U16QM7QNmGMvvrMCKdjC0f2+xjQL7ZeavxiUJ0m1mBGZ6FqlMS9ISFtvgo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39830400003)(366004)(396003)(346002)(451199015)(54906003)(110136005)(478600001)(107886003)(966005)(33656002)(316002)(71200400001)(55016003)(86362001)(122000001)(38100700002)(921005)(38070700005)(53546011)(186003)(26005)(9686003)(6506007)(83380400001)(5660300002)(7416002)(2906002)(7696005)(66556008)(41300700001)(66446008)(66476007)(91956017)(66946007)(64756008)(8676002)(4326008)(8936002)(52536014)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?9oY3iCMmeKKr5cQC4/9Tqq2OtMoMSCF9Iems9u2c4wX7LBg4380WyD41jZ?=
 =?iso-8859-1?Q?WMRnEtXiGv8TskUF88Xu2bDASVedHy4M6i0eu/R6unKwlnJ8PSxZbyaVjb?=
 =?iso-8859-1?Q?r+W36ZlLrMxsqLVIoVYKHSd3O8vDbfS/fUIa3EtExsMrCTxDP3wGFmKNFg?=
 =?iso-8859-1?Q?Rhfynyx1GBakr/kKT3VyU5pKLV3+qAh6Ek/FsIx+lAq6p/8kyScMOihSbC?=
 =?iso-8859-1?Q?dI8aLaUCmOoF112X4pliwwSV3Npcf2cz+TvyIuFUi/67U9xm1/oMaBObQ/?=
 =?iso-8859-1?Q?m8unCh7uLw7wyQWNFCF/TVjFHSICpJ1v1jVgntMBnWqaQgyeRlpW4LEHns?=
 =?iso-8859-1?Q?xs1HME/ZTU9bxFOlA9MqrGeema0mieJKlkExY0S8viAAl16rSXlWxtgeh5?=
 =?iso-8859-1?Q?cCZY5r8NY6uMiKzRR7eaShT+dCvnAV375AI2RHcCFd2gcZcv0eR1+BTHXw?=
 =?iso-8859-1?Q?EggmkcLQ7mvwURAhZdtWxxeYD11mmwrDow2ZumCc+DvMNXZnNWmUK5VcIY?=
 =?iso-8859-1?Q?6MnXJspqcRm9Kq//1jn40/R6xBtbvCQQ2b1J2Dl+cohEKulZd7pbXws01s?=
 =?iso-8859-1?Q?vIKw+WHcedC2UmUWQiy6XE4PBCUYzCJqwCDleBGTxdm/9QUWE6NgrLZ28b?=
 =?iso-8859-1?Q?E4fo17zG7bsEd938J80fBi1p3rZcQ7coJbb22b6TWsGWrP5zJDMrmAHcO8?=
 =?iso-8859-1?Q?NbgtncgOm3XN+CCvSU+MDrqFr+7ULa/cJpu77XvsVlUE+8bp1joMUrC0VC?=
 =?iso-8859-1?Q?dZ0M08+L9lGOXdZUzCs7uTG7J6ocEw++kFzbJHMtvjkVDzuQHXKDH2OiYe?=
 =?iso-8859-1?Q?rmvM4A2v3dPSK7xeEvX6BHPhb1qumumi8QWXW0bZZs+MTtWUKM7g8aO/zV?=
 =?iso-8859-1?Q?KLK183IexkjA72LCR/3IzS710crx4IhXHOvkBvrY3PDOe+nD5Lt2DJUAEP?=
 =?iso-8859-1?Q?OKl7nbBRgqaGyWIocQR1sXUf6k0Wphc76AW1t2r75YLBr3zQJ6w3W/LPQ4?=
 =?iso-8859-1?Q?yoW0YHboj7tLZx4Fr14lt5Rs4vWkHhQ/nNHihYY8Nvw/CMZMwrpMvWG7es?=
 =?iso-8859-1?Q?UezLs7/pxN1Q7jNI6btzKr/oIGew/I0lPAoZZ8GFZzsyCRHppYL1xj6uIl?=
 =?iso-8859-1?Q?R58a9P1tJV0xb05a65mAmjhC+W1L93JcEdWcjFWai5y2Tkb77MZj7zGgNm?=
 =?iso-8859-1?Q?k2y8SNJkUwwTYBD3aeH7S1bVKO6B6oJNdmxfc0GW53ECW6vqo9Z4849Rz6?=
 =?iso-8859-1?Q?31Y9JhxbgHuYXge6ZhaSxOSsRZxeVudiLy6O0994APaq1HpmG1nnasIYl8?=
 =?iso-8859-1?Q?ebkgQIRfxBRTmUrwsw2PZFHeh97xV75SCMMK1DrXJhYRZ+D3oMfxYhbmyo?=
 =?iso-8859-1?Q?ao22E6GFCcTMecCk23Ap0lY1qt+ZbMhDsrczuud89cnAvbxeeP98gKYaAs?=
 =?iso-8859-1?Q?gqQqDrGWAYoC8bi2M2G8p1uoQJSdABGt58EVwrBZeqmSsh2L8KkNvq2U20?=
 =?iso-8859-1?Q?qV4pffWpelB98BXRHoPz2wplizW5/Vvc1bhCZgWlrTJS97DflfVoKsvlya?=
 =?iso-8859-1?Q?sepHW3DN4790lPyIFG9R4lW+EZieoqnBUZGTHVxFj7PTFbOGWFnAfI/YI4?=
 =?iso-8859-1?Q?W1geVoTMY7vTwPFHTRPVq+mI2pTEK/ka4u?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbe6b12-c11a-4a6c-40b8-08daf7acfd36
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 10:32:38.0504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xWvPALMNF8r+lP6r6k6MKEnkG6Vxva8QDUYxI9wpxY96JIkd220ElaPG7vXIiV/nLacXRL58ZBOWqCAZ6xcjcQeufZpEtFhLhvz6BCpjndo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9224
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
> url:    https://github.com/intel-lab-lkp/linux/commits/Pierluigi-Passaro/=
net-mdio-force-deassert-MDIO-reset-signal/20230116-001044=0A=
> patch link:    https://lore.kernel.org/r/20230115161006.16431-1-pierluigi=
.p%40variscite.com=0A=
> patch subject: [PATCH] net: mdio: force deassert MDIO reset signal=0A=
> config: nios2-defconfig=0A=
> compiler: nios2-linux-gcc (GCC) 12.1.0=0A=
> reproduce (this is a W=3D1 build):=0A=
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross=0A=
>         chmod +x ~/bin/make.cross=0A=
>         # https://github.com/intel-lab-lkp/linux/commit/3f08f04af6947d4fc=
e17b11443001c4e386ca66e=0A=
>         git remote add linux-review https://github.com/intel-lab-lkp/linu=
x=0A=
>         git fetch --no-tags linux-review Pierluigi-Passaro/net-mdio-force=
-deassert-MDIO-reset-signal/20230116-001044=0A=
>         git checkout 3f08f04af6947d4fce17b11443001c4e386ca66e=0A=
>         # save the config file=0A=
>         mkdir build_dir && cp config build_dir/.config=0A=
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Dnios2 olddefconfig=0A=
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Dnios2 SHELL=3D/bin/bash=0A=
>=0A=
> If you fix the issue, kindly add following tag where applicable=0A=
> | Reported-by: kernel test robot <lkp@intel.com>=0A=
>=0A=
The config file used to build this kernel disables CONFIG_GPIOLIB.=0A=
Is this intentional ?=0A=
If yes, I suppose the patch should fix the code here=0A=
https://github.com/intel-lab-lkp/linux/blob/3f08f04af6947d4fce17b11443001c4=
e386ca66e/include/linux/gpio/driver.h#L761-L798=0A=
with something like=0A=
#ifdef CONFIG_GPIOLIB=0A=
...=0A=
struct gpio_desc *gpiochip_request_own_desc(struct gpio_chip *gc,=0A=
    unsigned int hwnum,=0A=
    const char *label,=0A=
    enum gpio_lookup_flags lflags,=0A=
    enum gpiod_flags dflags);=0A=
void gpiochip_free_own_desc(struct gpio_desc *desc);=0A=
#else=0A=
...=0A=
static inline struct gpio_desc *gpiochip_request_own_desc(struct gpio_chip =
*gc,=0A=
    unsigned int hwnum,=0A=
    const char *label,=0A=
    enum gpio_lookup_flags lflags,=0A=
    enum gpiod_flags dflags)=0A=
{=0A=
    /* GPIO can never have been requested */=0A=
    WARN_ON(1);=0A=
    return ERR_PTR(-ENODEV);=0A=
}=0A=
static inline void gpiochip_free_own_desc(struct gpio_desc *desc)=0A=
{=0A=
    WARN_ON(1);=0A=
}=0A=
#endif /* CONFIG_GPIOLIB */=0A=
Do you agree ?=0A=
>=0A=
> All errors (new ones prefixed by >>):=0A=
>=0A=
>    nios2-linux-ld: drivers/net/mdio/fwnode_mdio.o: in function `fwnode_md=
iobus_register_phy':=0A=
> >> drivers/net/mdio/fwnode_mdio.c:164: undefined reference to `gpiochip_f=
ree_own_desc'=0A=
>    drivers/net/mdio/fwnode_mdio.c:164:(.text+0x230): relocation truncated=
 to fit: R_NIOS2_CALL26 against `gpiochip_free_own_desc'=0A=
>=0A=
>=0A=
> vim +164 drivers/net/mdio/fwnode_mdio.c=0A=
>=0A=
>    113=0A=
>    114  int fwnode_mdiobus_register_phy(struct mii_bus *bus,=0A=
>    115                                  struct fwnode_handle *child, u32 =
addr)=0A=
>    116  {=0A=
>    117          struct mii_timestamper *mii_ts =3D NULL;=0A=
>    118          struct pse_control *psec =3D NULL;=0A=
>    119          struct phy_device *phy;=0A=
>    120          bool is_c45 =3D false;=0A=
>    121          u32 phy_id;=0A=
>    122          int rc;=0A=
>    123          int reset_deassert_delay =3D 0;=0A=
>    124          struct gpio_desc *reset_gpio;=0A=
>    125=0A=
>    126          psec =3D fwnode_find_pse_control(child);=0A=
>    127          if (IS_ERR(psec))=0A=
>    128                  return PTR_ERR(psec);=0A=
>    129=0A=
>    130          mii_ts =3D fwnode_find_mii_timestamper(child);=0A=
>    131          if (IS_ERR(mii_ts)) {=0A=
>    132                  rc =3D PTR_ERR(mii_ts);=0A=
>    133                  goto clean_pse;=0A=
>    134          }=0A=
>    135=0A=
>    136          rc =3D fwnode_property_match_string(child, "compatible",=
=0A=
>    137                                            "ethernet-phy-ieee802.3=
-c45");=0A=
>    138          if (rc >=3D 0)=0A=
>    139                  is_c45 =3D true;=0A=
>    140=0A=
>    141          reset_gpio =3D fwnode_gpiod_get_index(child, "reset", 0, =
GPIOD_OUT_LOW, "PHY reset");=0A=
>    142          if (reset_gpio =3D=3D ERR_PTR(-EPROBE_DEFER)) {=0A=
>    143                  dev_dbg(&bus->dev, "reset signal for PHY@%u not r=
eady\n", addr);=0A=
>    144                  return -EPROBE_DEFER;=0A=
>    145          } else if (IS_ERR(reset_gpio)) {=0A=
>    146                  if (reset_gpio =3D=3D ERR_PTR(-ENOENT))=0A=
>    147                          dev_dbg(&bus->dev, "reset signal for PHY@=
%u not defined\n", addr);=0A=
>    148                  else=0A=
>    149                          dev_dbg(&bus->dev, "failed to request res=
et for PHY@%u, error %ld\n", addr, PTR_ERR(reset_gpio));=0A=
>    150                  reset_gpio =3D NULL;=0A=
>    151          } else {=0A=
>    152                  dev_dbg(&bus->dev, "deassert reset signal for PHY=
@%u\n", addr);=0A=
>    153                  fwnode_property_read_u32(child, "reset-deassert-u=
s",=0A=
>    154                                           &reset_deassert_delay);=
=0A=
>    155                  if (reset_deassert_delay)=0A=
>    156                          fsleep(reset_deassert_delay);=0A=
>    157          }=0A=
>    158=0A=
>    159          if (is_c45 || fwnode_get_phy_id(child, &phy_id))=0A=
>    160                  phy =3D get_phy_device(bus, addr, is_c45);=0A=
>    161          else=0A=
>    162                  phy =3D phy_device_create(bus, addr, phy_id, 0, N=
ULL);=0A=
>    163=0A=
>  > 164          gpiochip_free_own_desc(reset_gpio);=0A=
>=0A=
> --=0A=
> 0-DAY CI Kernel Test Service=0A=
> https://github.com/intel/lkp-tests=
