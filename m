Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2653022C5
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 09:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbhAYI00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 03:26:26 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41060 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727129AbhAYHQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:16:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10P7FVRj026880;
        Sun, 24 Jan 2021 23:15:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=imU59Xir7j9JLkMKzcx5W1ussN0EwklEaV5fkVKYwsQ=;
 b=LTYnlpKEQNjWjJxYgEIIvFa96QvmhaoIeVvFj86oDs6EocIPLU80DFi8pJfrsBNX/Lct
 HoLEDnkfjiiSb4k0QABO2xCdZTmH75TxeGrH1q/NeK1nujMHtQL865owxlkfgGr0iGfS
 bw8Uia2/hpBvtBy9F44xhsCAs5sFx+TAqwiUYx2UKFVu0u1MopUPnjpX84aYZSyf07sB
 8+R90O6+ClQg1iDqFiL8j/Gwhf8K4NaMTgKTwjJeAOiNNzZraYGIK38pEoIkuv7LNfRZ
 9KJBtAng8bDTvf5d4Ic8i7hqdem2HVrMlQR0kFYLaBMayw2pyLik+nml6d1i4Mm+8onh tw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u3qbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 23:15:44 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 23:15:42 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 23:15:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 24 Jan 2021 23:15:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgmnacdvmUApIdiSd4dXv7X/FV82hSRePb7MTjbKYIPPk75Nl9d0hRgAtqNbq8HrFLffoHEtliXbvokyoup4XeYYFv0bZJNa1h6POsMJc3un491XUTGSXso85uYKMGewEptzEZAO1sAuinD9QS7IzbLi05qdspPB+YluYZOhr7FHOQUrzU9aeXCHfkDsb+AOngy/B4wIgddsPidOEe84Z3OGAqrSqewu+7GqB5QDSzuTqD15xBq4J1l1klMWSdHAg6T9IlyQS1j0WWE0n80jPyvnGsnpfC5UsWD6pJJuz7eekRNXmNL/aMcOyB6vsHPmS6p19H93a5X3a5pfImaLvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imU59Xir7j9JLkMKzcx5W1ussN0EwklEaV5fkVKYwsQ=;
 b=aCLUnoHjTziUwq0QPKRs6cAhLn5WIouLQkbsVuOtAv0EfT4sv2WkqljbAE0yk0x/1BwC6V1TM7C0D6MZbS+LVO3+W7vyujtOTz3sBSOgUROCs2XTM228ximThyC/Jut6nT1rG/f6Sk2Eb5GT9cTklY9uYcvk2/XccrLb/gEwzWAm8oYHL6OX8CaaqU3iRpTHWFC2of6qGjd/fbPclRXTxyKrLDh27aNyOk1pBA7g+jQ0wIesnyPyGcQwlWnBuqTxXGfVTCVlbBJ/SsChLmV76wFm6u2VA8csMHVq5hsE83pYibnwBSFHFzfLQX67QFCjxoQ+zCx6Ib1Dw9f2KFNrEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imU59Xir7j9JLkMKzcx5W1ussN0EwklEaV5fkVKYwsQ=;
 b=ELdbjVaF5r8jCxJBHQUk97+G6kDyve6k49VgzS++hwiscR7CciVgfpPba/QWj4hH6T+aBD2DSuEXmomowhKC+KxBjEPTfIk0m39GAJ/PlNkcfv/JXBXeu1JVG7VYAE5/4KyF/PVLN5f/6ZDdP56cgrjM4wfArVvSfSBPj6IX1QQ=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1568.namprd18.prod.outlook.com (2603:10b6:300:ce::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Mon, 25 Jan
 2021 07:15:41 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 07:15:41 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 RFC net-next 08/18] net: mvpp2: add FCA
 periodic timer configurations
Thread-Topic: [EXT] Re: [PATCH v2 RFC net-next 08/18] net: mvpp2: add FCA
 periodic timer configurations
Thread-Index: AQHW8kZjKx4oGFLdHkqof+xVkN95zqo2sHGAgAAngvCAAEz8gIAAyXGA
Date:   Mon, 25 Jan 2021 07:15:40 +0000
Message-ID: <CO6PR18MB3873E9B317C7833D963C6AC2B0BD9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-9-git-send-email-stefanc@marvell.com>
 <20210124121443.GU1551@shell.armlinux.org.uk>
 <CO6PR18MB3873F47DE5BD28951CC3D2E9B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YA3GazNlINcNUBXZ@lunn.ch>
In-Reply-To: <YA3GazNlINcNUBXZ@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92c03a77-22d9-4b4d-df8f-08d8c10105e3
x-ms-traffictypediagnostic: MWHPR18MB1568:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB156892B20FDDF1EAE826CD78B0BD9@MWHPR18MB1568.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WrkrIy+AQIN5uhrPXIfj7rCy2H4oQsLgBOIQPl9bmzKaT3lc7pYkgEUazAN1niLRqPLtmdy7L9CARxNMYZN5efKeoCIwZ5v8prsJ78ZLbLWsJn6OO5PbrBnvLj0HWDZrgKSEF9PMBtnWAm43tBlhqb0On3HNMFqablIOrMt69Te2K3B/PMds/w7CyRHLwqkUiLzA3v/yNF9cwoFLfeBx1y2lT5tJM4uUcI4NOzZ1eV5bdGf8i/aOF0pIAc0b5EXZED3Y/HcatUNcL6k8lNsxZW7y9FI58cYJQNN+USPUtgJZ7Y0z6+MQH0hRF4SzIShGsV+2BLH7IsC2CbLfdgHWOPhMVn94jeYkCDNod/7X4uJ7NisqEHK4yA6KBlyDjjXP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(5660300002)(2906002)(8676002)(33656002)(6506007)(52536014)(83380400001)(4744005)(186003)(71200400001)(478600001)(9686003)(55016002)(6916009)(7696005)(66446008)(64756008)(4326008)(66476007)(54906003)(66556008)(316002)(76116006)(86362001)(66946007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GGm/il4N6Fzdh/NuJarzMEbGiSPK+2xCz3tjQ8e1I5g/d2MH1vLtPsA7bhBt?=
 =?us-ascii?Q?NNdvL1POlRgFb53e7ps40cgmpkvMSTsiKIlMnJAoYq9sVvWWA93gtjFC7NmD?=
 =?us-ascii?Q?uqRdacCYBfWkl64KpMBfqjWpTEwbZZyHeG+5PRLoRoiPvdIiJyMa9ZFPN1wn?=
 =?us-ascii?Q?8yY17idLBTZUaxTHKt2dXVK+XxyNcKSJGqTBzm/0TKahbEo7CiLawExfZS0n?=
 =?us-ascii?Q?hey9hOXa5zspgiR+xQdYkGZOfYi/ODoa03olPF6eTF/kOEskzQm5LfH4UfUh?=
 =?us-ascii?Q?4olGZAzNq9qs2jreDWd4x/TwCDCSfTsgk0AciIzqdeHlf2CAWXp83Y3jlsvX?=
 =?us-ascii?Q?dX5ltc4uhnzp+7qKDN7edl1/4z/Lvu8oDaO4UWyHQqVtqZvaFE8BgxHXYzjg?=
 =?us-ascii?Q?1ygxdTBxEyZmB5bgenlH9DTdXDOlyqPNfRxIOb7ILdDTzDsA414fR9lGtLAJ?=
 =?us-ascii?Q?+ZPUyWnYaq69tn4JHcf0Kn9Vl9fbAesclN8LsGq+Cad67UJ+6PXuGvZeuFjY?=
 =?us-ascii?Q?mA6WaDG+llGaRxT4jWtVx6Z+/05SWYcu9oD8m1WR8YgxbdoyGQ4ufzEpVFaX?=
 =?us-ascii?Q?Guc4OUR2OzFkIu98dKOcbGnWSrsPopM+TGjPMsgj7zvEo7TC9fKJJO4pCXUq?=
 =?us-ascii?Q?CzuUvGeunyfpxYjpZIjh2+VZX8b0fJF5miCMMAgf58oCAfK0m293i/qePVlx?=
 =?us-ascii?Q?hn/Io6GKsBymQnbUB4pkS8Ef67FGL1rmpeEQLrjaiTBh+tQ8ZWz/ADtJrBkd?=
 =?us-ascii?Q?9ktHDcUMS5D3EhTcnvmOa5RRhNisIpMissnIlk5geLoomgqN98fPFzwxcF6s?=
 =?us-ascii?Q?slqJVpWU1/YduW9Y6/dUAOscZPmmIu64brgsUyONjM/ua9eYLHk6RXtmbyXE?=
 =?us-ascii?Q?p2l+CDE0br2PCHeRkbg+G2wQ4OHpzq49auemUntjsKFka4IfrLVnt/tOgX0/?=
 =?us-ascii?Q?JxVzHYsDSu5bD7+GmoVxb6Uwe9ES7F3HnDpO4dKaUOd4VXlJdETRo+izTawy?=
 =?us-ascii?Q?UeJR57P5QCJXpdMQrOlZkecxO0gCjZgeKlNuA/PDSJVXULAhgww+kDRz2+1v?=
 =?us-ascii?Q?ZDyB7/zk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c03a77-22d9-4b4d-df8f-08d8c10105e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 07:15:40.9887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVxAA4DuT5/RNF00EQRu6C8v+ZjAITmbtEANqwPFzCWA+SjY/S0IaFXzao1es1qh8dYJc2Sewu6Ni1UjSFqucQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1568
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_01:2021-01-22,2021-01-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >
> > > --------------------------------------------------------------------
> > > -- On Sun, Jan 24, 2021 at 01:43:57PM +0200, stefanc@marvell.com
> > > wrote:
> > > > +/* Set Flow Control timer x140 faster than pause quanta to ensure
> > > > +that link
> > > > + * partner won't send taffic if port in XOFF mode.
> > >
> > > Can you explain more why 140 times faster is desirable here? Why 140
> > > times and not, say, 10 times faster? Where does this figure come
> > > from, and what is the reasoning? Is there a switch that requires it?
> >
> > I tested with 140.
> > Actually regarding to spec each quanta should be equal to 512 bit times=
.
> > In 10G bit time is 0.1ns.
>=20
> And if the link has been negotiated to 10Mbps? Or is the clock already sc=
aled
> to the link speed?
>=20
>        Andrew

Currently its static, probably I can add function that reconfigure timer du=
ring runtime(based on link speed).
Should it be part of this series or add it afterwards?

Regards,
Stefan.
