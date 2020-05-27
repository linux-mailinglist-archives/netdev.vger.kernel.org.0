Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9371E411F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 14:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgE0MCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 08:02:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37282 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbgE0MCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 08:02:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04RC0SHr030785;
        Wed, 27 May 2020 05:01:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Ej/NVBom/0BSxKNPpexW6JvgdRRkJdd3C+Zx2wEzE1Q=;
 b=GVzRzI2OFk83kuB7pEte4EkLmZmlNn/b7ClOoJPifEMpVlW8jTnJZS2qrRGpd0tX52OP
 nyEhqmuYGKsFSySYN9dXcjhHQzeC+IrW0x3IyeO719MWw93Vy70TG7HTw5E9FiF8Fji8
 UvU4opKOKlmN2FvC9esUCl/cvzxLdmPocCeutlS4Alk6kKNGkQ69BxfXbRGEb8eDlILc
 xzWeN+deX3L5KP6/2gqsulFpKFB/cVPlK/dPBsbHdX9hDpbnb27Q9pKcXkYc8Kqm8KXR
 EjZ9Blg5fjfA8/OkEnYtfiC6j7kw9CXPAgPpjdnbl3bt+Ns0eGJ9Pvq92X1PvFpqwfrg Uw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3173bnw10w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 05:01:43 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 May
 2020 05:01:41 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 May
 2020 05:01:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 27 May 2020 05:01:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEs5ZSnPuo7IVkUrlhAwFueBGRoaZoQfnZ/KsztBcHPbr2v6eKMqmc77G8VxlPfic0/c6EY6zO7d4oFa8QOWbmq9k9MDa/DTl1uvU5hP307UyFpjn6BxQiW5DqNAK/aPXT004UihV3FWrBtH8TaVcLFaHre1zQGuBpC8QbTp7v830eRz86h9K1XjAvtIc5kCv8rBlN19ZxABmjfqe27+3GPYmKivs/61rTBQadrGWcCgaipszSJYtwCTL/9+5ylBJWx/rEo96BauP8aWuvSIRBNF5vhEcLhRd4PC67bEkWrwkQ6WgNL9wBMvAAsmywnM0Zz9NoQxRZpT3+TBXKNcLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej/NVBom/0BSxKNPpexW6JvgdRRkJdd3C+Zx2wEzE1Q=;
 b=Fozmip+lJ71Ol/OpiI0Q2gCD7JDLCdh1jkeEqjbQjMXMND8wRI9GElA6UrHmca/TgWpJbNJ8YxX0/13kbGFJHE/NjyZ3R5n1wjSX06ljPwBGXE5Od2gbCQrUANDSjbFvl8/EniQsY24E39E8GENc8NQwTa4CG/G6w/0gT6UKCexqC3B7sugWpNgGprk3Edr2SzPVdH01YpJDiPk0n7pa96le2VNVddMVy0yPndX9lWQiW8t2lsQZWWY8wBJ7G7irV3C9BTibreuwsUSzVFsX3HscFshPA/VCoJEgEp1bQc1FgVRFWoeXnoiDbNwIAiA56+wjFWXrMC8nt70nEZmyiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej/NVBom/0BSxKNPpexW6JvgdRRkJdd3C+Zx2wEzE1Q=;
 b=XkrEWRmY1OGynbtVcarErSWBDQ57f0N+E1dTxonsCn0W/T+QNfT7AYEfSSfLpUFLU/zhRHAd422eSkz24XhHbJwJNg9cH7t1FGcP2+Rh+KpZiGLDahwWHATu68GmicIu50NvV5PIHPsM85KkFdzV11LzfnfUw4yXvHAVyBpy0Zo=
Received: from BY5PR18MB3091.namprd18.prod.outlook.com (2603:10b6:a03:1a4::12)
 by BYASPR01MB0021.namprd18.prod.outlook.com (2603:10b6:a03:72::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Wed, 27 May
 2020 12:01:39 +0000
Received: from BY5PR18MB3091.namprd18.prod.outlook.com
 ([fe80::fd32:1151:641e:e5f4]) by BY5PR18MB3091.namprd18.prod.outlook.com
 ([fe80::fd32:1151:641e:e5f4%3]) with mapi id 15.20.3045.018; Wed, 27 May 2020
 12:01:39 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "Serhiy Boiko" <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        "Jiri Pirko" <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: RE: [RFC next-next v2 2/5] net: marvell: prestera: Add PCI interface
 support
Thread-Topic: [RFC next-next v2 2/5] net: marvell: prestera: Add PCI interface
 support
Thread-Index: AQHWM3p8SIDAJD76cUGUndhagPDLXqi7bzmAgAAzF4CAACw1UA==
Date:   Wed, 27 May 2020 12:01:39 +0000
Message-ID: <BY5PR18MB3091C6B195F58EC597BE5925BAB10@BY5PR18MB3091.namprd18.prod.outlook.com>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-3-vadym.kochan@plvision.eu>
 <20200511112346.GG2245@nanopsycho> <20200526162644.GA32356@plvision.eu>
 <20200527055305.GF14161@nanopsycho> <20200527085538.GA18716@plvision.eu>
In-Reply-To: <20200527085538.GA18716@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [212.199.69.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 087b2397-3fe5-4968-0337-08d80235b6ba
x-ms-traffictypediagnostic: BYASPR01MB0021:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYASPR01MB0021196D214BB43E487AA936BAB10@BYASPR01MB0021.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QiWxJjC5SXOFatGngFN493EjzZ3YaNpexRmgUAxrOfFhW3hsQJvGPYz6xRDs5Ame6deR43mGmsipGMYdtdc2/1v0ek/LD0KTQrAN7J3eqPJenTk0fJ+GZwtRQaaSNAVWUhXsINf2HK47hT8pVyWtSgVQTaXqU5S/aiXajH+gHsqhbRz4+aeTRcnJYIL6ZJo9irHTPwKDi6iYHxmn+uR+u04oLU/txEt48o43UauhGJelistSsnPpHmm5AzjgSKTO+32OpVtN5MIkxpxM0waSMaKBoNH4bgPDXDJRX5qzcjtSK/yPqmFOm1Xv+UkqR+oz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3091.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(7416002)(4326008)(54906003)(6506007)(110136005)(26005)(186003)(7696005)(33656002)(316002)(478600001)(71200400001)(9686003)(2906002)(55016002)(86362001)(8936002)(66446008)(66476007)(64756008)(5660300002)(66556008)(52536014)(8676002)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Bmw161v2syaDqOOSeU9qUhuX1mkbVTrbpVKz7X/dxEXZaH8knbFGv7pJfDq96l+1iyYd0XlnWB8YF3fziTsOLQu//0AR53INqOi2zw+VJR/cKGyzomCor9zOWuCK8DP6ofeJBOcDQwAr6OEPTEa749TbInUXQcV6azAjKkqjNu2x2VGOpsn05yuO6wRI93+a/HEIfkxr9khcupGUc+T7K9Da06v+F3DOYSEWoJkGDOaVVaRmnU6q9wgTBXUG2r7cXACFuex4YAvhFMvWsoieHRua7KEAH43QJYeXxFRxuXZNe3s+PuLTWSr1lq5Io1mx83rbt2zKMRXbg4SfP39q0+J0x2KgLKgRbe5P+RG04WEjfDCGgJYKDqjCpdL/KoBZqVyyNIByacEoN14ywaPDhotD9M2TvzSDH0M2UxqaEbhxEReCqTfLJ9r86p0BLMD+lNdB4xpctiruPbnSJh2Xev5H1n+USo9Dh+XFRb8nUFU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 087b2397-3fe5-4968-0337-08d80235b6ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 12:01:39.3821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmZMRXsqOHv+9ZM68bfGD0+P7Ev4Ej7Apwu7vyoGCJf9e7WZhAp89MlaUcmaspHDmAWfhruvtWdrxu/NTLEVxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYASPR01MB0021
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadym, Jiri,

>=20
> Hi Jiri,
>=20
> On Wed, May 27, 2020 at 07:53:05AM +0200, Jiri Pirko wrote:
> > Tue, May 26, 2020 at 06:26:44PM CEST, vadym.kochan@plvision.eu wrote:
> > >On Mon, May 11, 2020 at 01:23:46PM +0200, Jiri Pirko wrote:
> > >> Fri, May 01, 2020 at 01:20:49AM CEST, vadym.kochan@plvision.eu wrote=
:
> > >> >Add PCI interface driver for Prestera Switch ASICs family devices,=
=20
> > >> >which
> > >> >provides:
> > >
> > >[...]
> > >>=20
> > >> This looks very specific. Is is related to 0xC804?
> > >>=20
> > >Sorry, I missed this question. But I am not sure I got it.
> >=20
> > Is 0xC804 pci id of "Prestera AC3x 98DX326x"? If so and in future you=20
> > add support for another chip/revision to this driver, the name=20
> > "Prestera AC3x 98DX326x" would be incorrect. I suggest to use some=20
> > more generic name, like "Prestera".
>=20
> We are planning to support addition devices within the same family of 'Pr=
estera AC3x' and therefore "Prestera AC3x 98DX32xx" is mentioned.
> Additional families also up-coming: "Prestera ALD2 98DX84xx"
>=20

Vadym, Please attention we changed 98DX326x --> 98DX32xx

Jiri, the 'Prestera" family includes several sub device families.=20
we think we need to be more accurate with the actual devices that are suppo=
rted.
=20
> >=20
> >=20
> >=20
> > >
> > >>=20
> > >> >+	.id_table =3D prestera_pci_devices,
> > >> >+	.probe    =3D prestera_pci_probe,
> > >> >+	.remove   =3D prestera_pci_remove,
> > >> >+};
> > >> >+
> > >> >+static int __init prestera_pci_init(void) {
> > >> >+	return pci_register_driver(&prestera_pci_driver);
> > >> >+}
> > >> >+
> > >> >+static void __exit prestera_pci_exit(void) {
> > >> >+	pci_unregister_driver(&prestera_pci_driver);
> > >> >+}
> > >> >+
> > >> >+module_init(prestera_pci_init);
> > >> >+module_exit(prestera_pci_exit);
> > >> >+
> > >> >+MODULE_AUTHOR("Marvell Semi.");
> > >>=20
> > >> Author is you, not a company.
> > >>=20
> > >>=20
> > >> >+MODULE_LICENSE("Dual BSD/GPL");
> > >> >+MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
> > >> >--
> > >> >2.17.1
> > >> >
>
