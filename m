Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4808D38766B
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 12:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348462AbhERK1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 06:27:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45918 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241529AbhERK1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 06:27:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IAPu4b008339;
        Tue, 18 May 2021 03:26:01 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-0016f401.pphosted.com with ESMTP id 38m199sxfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 03:26:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cH3xPvOw3/kFNBAwlPkSgjL4FZTysCDtfvf5z0ZdlTyU0SzvBRbFv2SBhwdCbqONc6TlWcY7NrgFz6P2Pci1abb38GTDT+x8ujHidndbeyN3OxxAH1ZGw+4IgURd2BPCtEfbf0u/R40bPse8GEOSu6zKffQNZg9UDmUzwhyUE437IUKOIi5VL9CoGZ8LaldiZ459IYvp1uhAI34gRbfrO2e+aU5G/xA4pMvz+Lz2xH6y6kpvnp8p4bBI//VNszd+UF8X3uSCT/qoZTjHrFodKptFcNVgC8HQyIQPvXmWlTv0nvrmUuvC2uRUD0RgW4PvsZq3z+qTu/QIwKPiGZ7cqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUTDX1uRr3kmJImrd+ueA7omZYBoqmwDeSp++XdL9TM=;
 b=Igux2PlYERa0VF4AFlkNyx0N8CyN47PFXHZrTLGJRu6rjLurkXIyB3Y4HxcBb/FJZAzSq9B/EvowH+5jIwK03uUgax4Zexh6uYp+HgW36AVk07u5rvLql7Maet9ziQey+wdo+lhL8sKA4hRMKJg3Hb3eDyzmqGIaxd21lBAR2M0pcJn0au6LNBTMIzjx4jlxX5pWZHWoB3PdOEIVnalJ4idX1Cr5kP6itwdXzZiUeMYN8ZFF4vQmkN0RSXfVgrtOa8IsaAChWX2ru/zmZ3KDGax73kh7mCRYD4Yq254MEU+9emyiDknnmALA2v9TgoxliWdwzJN2sbXxJ+CSiQa8vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUTDX1uRr3kmJImrd+ueA7omZYBoqmwDeSp++XdL9TM=;
 b=cexqUeDTLhEyZYLr/WYxaZagQXaRZ5kQR6VwZkgkAO8XsfzlZIkxFuz2GhLGw9jFSrZ2all9qyAvfn0Ge0blkfK2U32CD+6gg0TzWseQ2W8PipQqRSvVdtTCQAat9bgaIXJ6/aoGZ5n4r5eDLH5Vc4ajNbv3zIGaKF41bM3oZ5k=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3811.namprd18.prod.outlook.com (2603:10b6:5:353::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 18 May
 2021 10:25:59 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e%7]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 10:25:59 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Marcin Wojtas <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] mvpp2: incorrect max mtu?
Thread-Topic: [EXT] mvpp2: incorrect max mtu?
Thread-Index: AQHXSMEeOB8utqlMw0S+5lVqOciSAKrow/5QgAA+egCAAAh9sA==
Date:   Tue, 18 May 2021 10:25:58 +0000
Message-ID: <CO6PR18MB3873FB0E037EEE6104FAFD80B02C9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <20210514130018.GC12395@shell.armlinux.org.uk>
 <CO6PR18MB3873503C45634C7EBAE49AA4B02C9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210518094134.GQ12395@shell.armlinux.org.uk>
In-Reply-To: <20210518094134.GQ12395@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [87.68.36.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06c60fda-3308-4eca-89d5-08d919e75439
x-ms-traffictypediagnostic: CO6PR18MB3811:
x-microsoft-antispam-prvs: <CO6PR18MB38112BE6120E4CE0669D33EFB02C9@CO6PR18MB3811.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bKQkMbB0JYW7FPu+Yq4a235SrA1UcOugekVMlAVSWq2VGtsCF1YPCD/JLP1z+zfhr8gerat1O6cvcCliWnjMvLx45/dqKpU87PSp+MGM81fo4XN/XTf8OYQZa8dN+2Hku8W1j3XJLfNL4Zo5HW4rvXH58yofhD+7e5XlC+iJ6K3kiHNkirqye3BAD7yfu0JAzo6ogQqWfJYWu8HA/AN/72XeKeCROmueeTYe4/1q0bmcAHyhqTjLYynywHjjCffqVouQ7CtGCEe93MrBOJxQua/hx9e+aLJ2zm6DtDkAV7otouU4PzJz0F8oj0TGMaql4GgG4Jhdk154nbX4aL4SCKMf+ydpUGqA8FSLdbUTxL+hw+hDVep4AYCbb9FbyTSLSJ/KXXrTZxsBfNu/OCoG8uUX+2KW+CAPYrXIs+ex1cbQhqbLWaFdWqYC3F7CAWN54rWjnUeIYizXgQGdudYexSWZ9FPSp4dv98lKTJ6ymonhc0oymybjb4SGCtx5p1l/AouajHxjelg4H9st2eEnqnoNR7cne7ZEckB1e2FlwAcgbjCJ8AONpR2C6YZak1mtNK/3+/GTQ7MF/dVdMOq8N2egPVNyrVwApazoTSHWInU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(346002)(366004)(396003)(83380400001)(38100700002)(122000001)(2906002)(26005)(66476007)(55016002)(33656002)(5660300002)(478600001)(52536014)(7696005)(54906003)(6506007)(53546011)(4326008)(76116006)(8936002)(6916009)(66446008)(66556008)(66946007)(9686003)(316002)(186003)(86362001)(64756008)(71200400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?CRz/ijZ3FnCWeMdM0cMeqNX4Z7FKtepDe2CdXeuLa8rCGXjiGqcJVI8hjh?=
 =?iso-8859-1?Q?REVuTeACzML4gNvaI6gpa2+XpAUVOH3U9J5mDzBB/Umrv0nD9NHiUYfQRo?=
 =?iso-8859-1?Q?mO4dShJmdSIHZkGh0YNkjneuBuEwYzH3D0A1riuX9hSZgscIAaVbbLeAVk?=
 =?iso-8859-1?Q?a3ylr9/fIgcTFKmxWMdkhP00uS876bqQTUWQV2rfRK/q/LxyzVkgtJZqht?=
 =?iso-8859-1?Q?8+NTLR6ovd+IVtNzuO6RW2K6D/UyFGP+tE6kimLiNwr3w4Ia1toKN1Rk4M?=
 =?iso-8859-1?Q?K7pNS5VBHRITVEAqXoqbGox0YnhHm8Nu4U1NgN4e1utkHSqfnT0MsTMs+r?=
 =?iso-8859-1?Q?mbti0VHtbzCjz+TWJifJGpgkKUZXbZP6+ycZF9sw+WsF1nVmxM1ehbt8O9?=
 =?iso-8859-1?Q?jxTD8LiCcJW8IbE9bx1sqi4iF6ffoUqqIPnlWSUPiPnsnv203fVIAV+b+6?=
 =?iso-8859-1?Q?/SwEgVSdYBSlMQA4mpml1W2YXC69yEBnY9v7YKfiGqdTAHUhUNj3SENFh/?=
 =?iso-8859-1?Q?0PlBg8t249sJFeUGJ35Nqr/PrFoFwYY1A2WvOK7MmDXj2DeSe2q6RcK6oB?=
 =?iso-8859-1?Q?PDHRp+wRch6m4coTWX+HMUpjlH/uz6mm3dPXA1r52GOQGiQmHch/hFFkqT?=
 =?iso-8859-1?Q?x0K8nOKvvvGSeRQYO0iXXI1c7cLW9XHq85i/r+ZrR5fSPTN4k6XIyhFFHH?=
 =?iso-8859-1?Q?xAgeENd+rjk9EVhPncd+sRjBifiqnrv/iUPguWpvlRViLnVvS9gUCGRz2E?=
 =?iso-8859-1?Q?G1sCJVN75d+1W0Zqe5yucbkOuaQBFzoS42i6OD/RwlYRv5KiTFCGG+RIjy?=
 =?iso-8859-1?Q?nQP7sFs2+Q4ggib/49BIxm9J39hmfSLZWt04tAnyVt0FXZWd9oYvCCrXVq?=
 =?iso-8859-1?Q?ymvLCsveBaJjpkdSOFlES6kBHvFTG1//5iC6JbinuIyVUAlnEHfW7+BCyF?=
 =?iso-8859-1?Q?2ksgAZkwE3/IFkLaEFPSFjCJxexoxGjgM6IHWSt1pEecR2b1QIvu5jvxqM?=
 =?iso-8859-1?Q?g6/Z4hfXoUY3HY4XgD2HTvXjZaqRuh8xoybEkINP+XvPUTVNYbG7Rlhs03?=
 =?iso-8859-1?Q?Nkqs9PWqJOLw634YG3B13+ptnDr5BO7fXiwAafXzGDfz3Np0tzOvFOFfTF?=
 =?iso-8859-1?Q?u3Y/NlR+tM43EFLRF37ILiEceAPtKydAc9QGx3Zxpiv2z1QFKR3noXoWnr?=
 =?iso-8859-1?Q?a+8Or2de3rmaKwkvH2FgKqlveCqlIflS9yeY8Cv8xLf4PK9ciOk6mEs9Xs?=
 =?iso-8859-1?Q?Pewsj4zcCdxOLB/SpZYi4czT50u0eJ70f93C+q6CJjQtZMpq4S+cTOVbjb?=
 =?iso-8859-1?Q?uRgRDeOONf+LldaMOUu1Jq1QbnmTnCFdUzv7P0ltkVw0D9g=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c60fda-3308-4eca-89d5-08d919e75439
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2021 10:25:58.9568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Le/TTxKPh2ZzEdsRXlWEhjcnnfOSh34PjzH79atxN8AVvV1CnftsjNlQUrVpzNP55iytOsSeHRUmMCUbr8PL+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3811
X-Proofpoint-GUID: h0URxoTRO86YMHEM2MbN2yP-iVUSMXqt
X-Proofpoint-ORIG-GUID: h0URxoTRO86YMHEM2MbN2yP-iVUSMXqt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_04:2021-05-18,2021-05-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Tuesday, May 18, 2021 12:42 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: Marcin Wojtas <mw@semihalf.com>; netdev@vger.kernel.org
> Subject: Re: [EXT] mvpp2: incorrect max mtu?
>=20
> On Tue, May 18, 2021 at 06:09:12AM +0000, Stefan Chulski wrote:
> > Look like PPv2 tried scatter frame since it was larger than Jumbo buffe=
r size
> and it drained buffer pool(Buffers never released).
> > Received packet should be less than value set in
> MVPP2_POOL_BUF_SIZE_REG for long pool.
>=20
> So this must mean that setting dev->max_mtu is incorrect.
>=20
> From what I can see, the value programmed into that register would be
> MVPP2_BM_JUMBO_PKT_SIZE which I believe is 9888. This is currently the
> same value that dev->max_mtu is set to, but max_mtu is the data payload
> size in the ethernet frame, which doesn't include the hardware ethernet
> header.
>=20
> So, should max_mtu be set to 14 bytes less? Or should it be set to 9856? =
Less
> 14 bytes? Or what?

Yes, look like dev->max_mtuis incorrect. It should be 9856, MVPP2_POOL_BUF_=
SIZE_REG,  Pool Buffer Size is in 32 units.
But before changing it I prefer to test different sizes. Currently, I don't=
 have a connected board.=20
I will connect board and perform some tests. JUMBO_FRAME_SIZE is the size o=
f the buffer, but packet offset should be taken into account.

> It is really confusing that we have these definitions that state e.g.
> that JUMBO_FRAME_SIZE is 10432 but the frame size comment says 9856.
> It's not clear why it's different like that - why the additional 576 octe=
ts.
>=20
> All of this could do with some explanation in the driver - would it be po=
ssible
> to add some kind of documentation, or at least make the definitions aroun=
d
> packet and frame size more understandable please?
>=20
> Thanks.

Yes, definition or comments should be improved.=A0

Regards,
Stefan.=A0



