Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B87346755
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhCWSN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:13:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21070 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231206AbhCWSNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:13:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NI9SPh028783;
        Tue, 23 Mar 2021 11:13:33 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrj5qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:13:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwKskHasoe4F3tp9ffPZTyB/vYqVpdYAZ14folf0Bw/DUyUs5aV09bw4ElZN7TVwlfWIMNgL3ZtJgz+9Nt1FxY7XtJQv9ziwOW81ugh5g8rterMDVx9Kgx3i7Fd6PXMDWOaJM5mZV3HdeVclvQz2WqZt81Z2f+w92BHmyVhsNAplmPQtk0oCpx7vRxp58oUvFCfAdgKxcVtqK7swJW2tybKH9Jg+ZcOR8Cip59CK12buqPdKeIUDhy/GFPD9AOfgQf/HMFwlWXehG+gFbfAbXCvUVWhm2m/uzM12GjIzoLjA9kUzibTcph3ynQJrPzOqKTcr9YpL3RJa6XVhbDnb2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9reRt58oAj1o7aVoLmO7ss4gNfDEjzTAwssthu7kLw=;
 b=eH2buKMHSSZhdE5Obt2/grTXlZXAvI4nwqbGNFHjXWnybwesGEtZqW3booK32/MoXhe+FXv/om4MpuQMhBcK1JbyPFyUBWlTFizVaYRFOuiYZ2V3D1YZJ/x2IplVHqhYP7kiJabLtEQcvbXOCtoU6diVLlICSq+GCyBodCEWvtuIv3h+6/direb3F58uJOF0TLPhdmE9Uye5UADH+8a2EQxil+R+Q9ZqiuGQ+3gn+lMGWEgQeDhacy4FdN+DQkoFLEAT9065JyMxB1ZMXNz6wXvxQrGj8gLLN7iELC4qKGFntnL2zylP2yTBYuIn9pay5ejfIfy0IZi2XK63IdKgLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9reRt58oAj1o7aVoLmO7ss4gNfDEjzTAwssthu7kLw=;
 b=YfBG27SzqPkoow0VTVWiCy+uM3mrSWP0lPiz1QNqchtJm8THNkks7rAqsXrrk00U6vLEe4o7N3hDF8oAKJ61iOSGBH9zqC2cMuWa+4N77DpkKWWq+60f6LIVwIttfVnPSN2TtutPiRGRi9JitoDpQ787IWNPXymWawx2RO4EKUU=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MWHPR18MB1343.namprd18.prod.outlook.com (2603:10b6:300:ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 18:13:29 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::c00:81ae:5662:e601]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::c00:81ae:5662:e601%8]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 18:13:28 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers &
 phy
Thread-Topic: [net-next PATCH 0/8] configuration support for switch headers &
 phy
Thread-Index: AdcgBS5mePTUKLvvS4qB/A4kXkvtIQ==
Date:   Tue, 23 Mar 2021 18:13:28 +0000
Message-ID: <MWHPR18MB14217B983EFC521DAA2EEAD2DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [106.217.192.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc5ec07f-6838-4181-e121-08d8ee275c23
x-ms-traffictypediagnostic: MWHPR18MB1343:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1343117991B28C430F1662D2DE649@MWHPR18MB1343.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y/7AwXFCptD9nZJ8gjCSVdSuwQk11WgqX3NXIEtnavA9zoCD/2K/HLyR+/YODazhXfZ22Mg1tpTJY7gTFiWZ4JqKNyR/hawEdao4atiSAFaTzXGWo4QZMWX0ggOzzSu42BeuGjBBFIjyb2nMfAAWU2uw4f/MRRCNJsYemOHnFTdMVwbK4TkIm5zwJjiXvM0yKlCbGOTk7FkkO2zV6pVTiytRU+dkHWU1i2v2FNQnhThLfRhQmOmBvbYIrrFCXQvAJDe27Gb+Z2HD7IaMHwzh26V6ew3x0vH8WpA5grdy4ovmc58+yGjDHYBgubRl7uEbNbgLZKBfGSGufFDjXPdPl5JyNiXnzH47HQwGdLTsD52cA8dsIv2+g0/I8LCgUIHeHxUOu3rr9Zd9r7DQnImbBgOqdf4lYQL3N597+cPQ4/59SKEMTSyUUMQNooXvP4TcuGi8qKiCVluORQf8l5YLsCqJzpw2L+FstN56Bazswo5lMwTCNgNBkvrGMIhFxauwpilfdJehwi9DF3CI6ZUEAwWGw72oQJ4qYTcgF06iAbvzpcF2T3KHAHUcwqTYGwv0qGfE3nI7uvHev7X+fs1Nr0mi94NwxafelL0ptEaPBQWlexZ6IWlkkYKEFZWLoQp4H0NxlQQNOotWXui2s/HqE5uol5lv4xTNYvgvTgNdPJM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(366004)(346002)(9686003)(66446008)(64756008)(66556008)(2906002)(55016002)(66946007)(76116006)(54906003)(33656002)(66476007)(83380400001)(86362001)(8936002)(316002)(38100700001)(8676002)(53546011)(6506007)(7696005)(26005)(186003)(6916009)(478600001)(4326008)(71200400001)(107886003)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Fs3bJHWguoz9pn+ykGoTgbi1p2s1e2QnC2tUs0jprt/7iBoj1myy9v+MyoN+?=
 =?us-ascii?Q?xAl95pd1BQHDx8CBrPRotlBn0MqoUsvlNaXkYZunpCNu0NliNL0dtdOi6BlL?=
 =?us-ascii?Q?FshGfgZc8JpSbogJQDjy92gmm9wXKmQPlnWQVhL6h49rnD3Uo44DAlJdqAZC?=
 =?us-ascii?Q?s/fCziljzIgoYZI2Lb29qrCI4zfy+1h63a8Fl36JU8aj+3AVOXGCslC73n3Q?=
 =?us-ascii?Q?hitLaGxTKlSAF7VyVZ0wDj1+Ypk/BcuEHbMud6LnPD6y1IjJZQ7/V6GVEMBJ?=
 =?us-ascii?Q?c3AYnPaWZuH78KaFacuAaojtYjKzU5/ggqGNaZAoh+NsypIe8W7YgbgzWa/y?=
 =?us-ascii?Q?Jw3oYuyiydqy4SQaNc8/UOgPxs7/ivBk+x9UNQ3+D/b0CjtJRUT4GBjxQ7TZ?=
 =?us-ascii?Q?smDAcw/35LOmdOtV7H4gPwnoaKZbdr7+1EkdFOm6Nw5HXu76ILoXP8gGkqa0?=
 =?us-ascii?Q?iw0pBb/MnqaiFDE918fybrYFBxWoBCc/E4bPOYAM59aP4xoOPUNdJnSzEvPx?=
 =?us-ascii?Q?TkrOmbGM6oDLu8t5JJuIuXj/UyNizkSIZjmVsCbM7AuCyIkbr/HFyeamfgp/?=
 =?us-ascii?Q?HPd/DQzXfuuj8d6iBAu3Q6dhrEUvXVcC4IPLPBJCGCGsUQgBDOSoaY9myLTm?=
 =?us-ascii?Q?50PsSKklkKD2mpmn3jfV5kekCSAqktt0LnOxO9Ui+fH1mrP2AGl6rNYyqyD3?=
 =?us-ascii?Q?qp2wHFaghYhQDbc6nUuSBmnJPl18GO85DMzNiqlBWIvhaH+laSNVZSdAO33H?=
 =?us-ascii?Q?vnb1F1oj4J+eJ+KkTh1FaIdFFx17zvsL3n1yPqc2VYzAho4zcZdPgKEn90Ry?=
 =?us-ascii?Q?rVreJ0w3zMDsUhuxYXEHwrl2XHK150VaxeN8gnwtcgpuazZPM6aW71AtOGcg?=
 =?us-ascii?Q?8x9cVxVUxeEv5WMwdjGlfF4Aq3TABlQyDhAjJLKIqd7yD1B1jcgRXLIIVpEq?=
 =?us-ascii?Q?UPacrNWSvwHdjghYXmG4s0sir378Tj3006oqXuG4imyeV6mM8J8Gu/c9b7PF?=
 =?us-ascii?Q?Wxp7Bu1Wg6S7dMJ99A0GUJyUQ4WTnZQfgrbcOF/J/ArdhVkQ8Rp0b41kHoVG?=
 =?us-ascii?Q?rXUD5ckYt+I3WNCPsSp2zYPWaTduZv7T0q9D/GrB/DcNetWiZIZY3dMgB5PC?=
 =?us-ascii?Q?fYjr1wlon++H3NcOGMiiTpSTiPqmx5su89J9nGsgFldk/PUIeC/VjNRHT5Li?=
 =?us-ascii?Q?Qq8I91iCdsmQfdddjNwlCwkLUjJXgflbkqnuTtQi1uXKun0WhQqEQuVM9rU4?=
 =?us-ascii?Q?dAZh1/iYuI6S4BdXz+nSHBgPJ7pOOukF2nl0ODFB/kBA//2vzoR4ZgJZ7nRd?=
 =?us-ascii?Q?XYz5d0NAKTsK6NASpOfjsOGP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5ec07f-6838-4181-e121-08d8ee275c23
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 18:13:28.8526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RGPaBynbkrSwSkdEEgKQf58PjKVBEaIqnfcEQGiEvGbW0h4LgD6uapJ8NoKpNTnhFAIB13fqluM8lTYg1k4ahQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1343
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_09:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Andrew ,

Please see inline,


> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, March 21, 2021 7:45 PM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kuba@kernel.org=
;
> davem@davemloft.net; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: [EXT] Re: [net-next PATCH 0/8] configuration support for switch
> headers & phy
>=20
> On Sun, Mar 21, 2021 at 05:39:50PM +0530, Hariprasad Kelam wrote:
> > This series of patches add support for parsing switch headers and
> > configuration support for phy modulation type(NRZ or PAM4).
> >
> > PHYs that support changing modulation type ,user can configure it
> > through private flags pam4.
> >
> > Marvell switches support DSA(distributed switch architecture) with
> > different switch headers like FDSA and EDSA. This patch series adds
> > private flags to enable user to configure interface in fdsa/edsa mode
> > such that flow steering (forwading packets to pf/vf depending on
> > switch header fields) and packet parsing can be acheived.
>=20
> Hi Hariprasad
>=20
> Private flags sound very wrong here. I would expect to see some integrati=
on
> between the switchdev/DSA driver and the MAC driver.
> Please show how this works in combination with drivers/net/dsa/mv88e6xxx
> or drivers/net/ethernet/marvell/prestera.
>=20
	Octeontx2 silicon supports NPC (network parser and cam) unit , through whi=
ch packet parsing and packet classification is achieved.
              Packet parsing extracting different fields from each layer.
				  DMAC + SMAC  --> LA
		                               VLAN ID --> LB
		                               SIP + DIP --> LC
                                                            TCP SPORT + DPO=
RT --> LD
    And packet classification is achieved through  flow identification in k=
ey extraction and mcam search key . User can install mcam rules
    With action as =20
		forward packet to PF and to receive  queue 0
		forward packet to VF and  with as RSS ( Receive side scaling)
		drop the packet=20
		etc..

   Now with switch header ( EDSA /FDSA) and HIGIG2 appended to regular pack=
et , NPC can not parse these
   Ingress packets as these headers does not have fixed headers. To achieve=
 this Special PKIND( port kind) is allocated in hardware
   which will help NPC to parse the packets.

 For example incase of EDSA 8 byte header which is placed right after SMAC =
, special PKIND reserved for EDSA helps NPC to=20
 Identify the  input packet is EDSA . Such that NPC can extract fields in t=
his header and forward to=20
 Parse rest of the headers.

 Same is the case with higig2 header where 16 bytes header is placed at sta=
rt of the packet.

In this case private flags helps user to configure interface in EDSA/FDSA o=
r HIGIG2. Such that special
PKIND reserved for that header are assigned to the interface.  The scope of=
 the patch series is how
User can configure interface mode as switch header(HIGIG2/EDSA etc) .In our=
 case no DSA logical
Ports are created as these headers can be stripped by NPC.

Thanks,
Hariprasad k
=20


> 	  Andrew
