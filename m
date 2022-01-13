Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C233248D1C5
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 06:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiAME73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 23:59:29 -0500
Received: from mail-bn7nam10on2092.outbound.protection.outlook.com ([40.107.92.92]:50368
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229655AbiAME71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 23:59:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6r87gQeVD8aJZnrWTnUjsV+xB5wTZTAAIKi7sck0/jw1CNh/FQ+h7DrGLOZGA6em05MuZpvBp/kZ0i6T0M/NL8STRjWYE82Lc2kBDZxwNZ4gExOOlcYpvkgdSEmX+s+RcjZQNXX+HF+OZLQW4HtJ3CRMVTXN19SGh9pnJKrlmwOh/VcVHP8oKo0PPXN7KqeFxt+dpcBonn73909YHIzjXJkR8loWoW4q1jYKUpH8wsa+WEX5qKmypyDugGYFaDvfJm2R0UC/7k/n9JtF1bNKFIi4pW/H48x11vPf6bTqJpp5YoIYdzZlr3Mz7xW60pUFMF3oiJMwN2StSVbNMQAKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9O3TX65zq0ff7a8WwLfGCVR7r46/dTR1VxLd6zX+pqQ=;
 b=atogvPORnShAZh1kfwi2CIv4lF+RpnF5m+bONMR8fXEnEsdYDaxoU9cP79AGCqmYGr/zCMrN0ZzKJEwupfg80IE9m0gDr4wNDv/xNpH/pyzyKUEz9UENNzJESgwKcd/fordl8E5autIVL2Q7itKJBmCDde47pPjrTgu9faeG7OM++wJ1BBCTGg7uSh3Rk+/OPckqWiVljm7xp1t2P+DP/2NiTeqy2NWi1XYlb7ne0kyXa61ZT5K30ov4ja5dLeP8JqnKnQTPSMBF4SbJvqzCC9tNDxR+wsPb9KZ9cKQkhJEMekWBMHG09HnnNFTJBAtB0P1M3A0xx1D2nnPjGpgA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9O3TX65zq0ff7a8WwLfGCVR7r46/dTR1VxLd6zX+pqQ=;
 b=LoioSVAQ4qAYQLPQDbVpCer2OTNJn4BRgzYbR9fQGWgcbiZHJMIMn6smZUv+JH0HApJdZ+BnyBmCYnfITjchIE/j/wYROQ9tz5TqJeljErF4yp3ZN64Rts18hggI0w8lSjUEsKfsYdeCNmpP4qhJvtXPZlOHSw9XxqreMlt+f0w=
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by MWHPR2201MB1168.namprd22.prod.outlook.com
 (2603:10b6:301:31::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 04:59:24 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::a42e:ece:ffbf:4b3e]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::a42e:ece:ffbf:4b3e%7]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 04:59:23 +0000
From:   "Liu, Congyu" <liu3101@purdue.edu>
To:     "xemul@openvz.org" <xemul@openvz.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: BUG: minor net namespace information leakage of packet socket via
 /proc/net/ptype
Thread-Topic: BUG: minor net namespace information leakage of packet socket
 via /proc/net/ptype
Thread-Index: AQHYCDOCk0gGzfFjYkCrmjvRNSAWOQ==
Date:   Thu, 13 Jan 2022 04:59:23 +0000
Message-ID: <MWHPR2201MB10726FB1BD0E3B8735AD8DB1D0539@MWHPR2201MB1072.namprd22.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: d112654d-3adc-1837-3a1d-91c28d1347a1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purdue.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9e008dd-d856-4361-5ab8-08d9d65177c0
x-ms-traffictypediagnostic: MWHPR2201MB1168:EE_
x-microsoft-antispam-prvs: <MWHPR2201MB116811A91E382E9B2B06372AD0539@MWHPR2201MB1168.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: khYWeFi2KK1jFqHUMiTtLPRtpjrA5edWtpNnMXItzZzmjOPdvpR+7Fk8tP/jBseZQA8WdObOBWjNgaMpVsStBNDX16KwFvOZuckWbmg7SKRkOjlmdUBVhTjvZDyV+1v4QnXRBjvw2NqGMzhx4xjCar1pnqBu6bivAb5XyzwB8PETQUqzIqnmRmLD23ykWqcdCBTpj8dFMQIJaRtth77ZXUKLNqldz+54XALFez22E5T7k0fLrEXIllx3bj3CvapYNFmoRTko6HEwV7qTc1mJzW0ibF1okZ7Hs/1KypDxyUVJYGrRoWW/64w4R1QJXYOVVxkcY6dbqJGnkaFwB1mcm7pXm+WG9EXasd44une/YyVurXKIXGPAux5zRUCMTHB8cLv2xXC/niDlwC/gsbaKhxvES9w3lHVhiq0ETTBJNqJrkVbaGKL3xrxuCe4miCi6BVWqG5dgCLlTiXVO/QhyspEZxLBLySarnyoBWNQdPSDP3+9dnQcse2iD3d8TPJmF5MLAv4gRLDPmMTSHxzSEufzltN+l20q0Mf5IWB9O4fzNFt/0UA68pZ2bFRw9l3BlYXeMaF5uRKBkLx3t/bPOLpI+r5xgpNzVjhKGC0GLQDJhtlm2OCs0snhAHwRbzM6OwonwblCn60CxyS2Qt+9LWBYIVevjs6Vb3QTt3kVBDzNodavWTRim3GVcCiVJSu4BEMSpuz6ZniVRv71zRypxvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(786003)(316002)(71200400001)(9686003)(38100700002)(52536014)(186003)(122000001)(33656002)(38070700005)(110136005)(4744005)(8936002)(55016003)(7696005)(83380400001)(508600001)(8676002)(86362001)(76116006)(75432002)(66446008)(64756008)(4326008)(66556008)(6506007)(5660300002)(91956017)(66476007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?nw1aFpU7RQT3SIXyyijmUCZ6ZhAd2q00ArtaxPtPj0GWjHZAOVfyPtrgPo?=
 =?iso-8859-1?Q?RHJGTBg0hbDQEowHyG4C0GeZ2NEboRyy2efzvuDn/jagNlQZ+xHepzThnw?=
 =?iso-8859-1?Q?FQpRa3VKBXGsAIpF32r9mo0ezTxXik2HXHVkDL8VAuOqbWTn3uoUGRoNcM?=
 =?iso-8859-1?Q?adS/HrdgLE07piOPj9ecHWwM4i7+2v5QszfvwkImrAu3a6lUthEdsi+cGh?=
 =?iso-8859-1?Q?vZYTWtxjZYf8MWIhZywRzl+hX9sU3V3cBnakGgYFvZSONO5/97MWFVMNDb?=
 =?iso-8859-1?Q?GdBOzuD/vskOXkWpqpIajL+vihIrSwrhijx5Pftfu33sVvqJMo9LeSuAEP?=
 =?iso-8859-1?Q?h5lHjDqY+r1KALCUcazao5ob26W4E7XxWnUiMZQU8FuJ4T5fp2rU3YrRC+?=
 =?iso-8859-1?Q?lu5oavswzrr3Y/ifCWxHyeXDXLSP04L65Ww6IHT8bpi7b54zp7HB8FbG6I?=
 =?iso-8859-1?Q?vKWpc6ilEOsdU2njlEtwduuSmQwM/XSzBwvhMpDqwR4Zg5fSk8qGh8zb1y?=
 =?iso-8859-1?Q?TX4pODpFWNsfH+FzMtCZon7oQ7RqwEBYdZIik3G88VpFAWaHum0dKFC80O?=
 =?iso-8859-1?Q?TNObpjKz/gO56Hl3Y6VkJfs2cJqOUptIjN6mbbwUD5op3wYBw+yEf7u+oD?=
 =?iso-8859-1?Q?vuCnvQFgorn8ssLPr62zBYzwaCKU9rPFZk3U2f0NEt7Vhx5ucIwh6/9Uyc?=
 =?iso-8859-1?Q?EUxOMNrvPNZqwgJ+5oeSwCSAvbK3PelcS0UcR/tCrFYQfc0cYSSS5Xn8+v?=
 =?iso-8859-1?Q?K+3b0LKi560qW+MNggElEX0RaO48FUMcc2a84gyE8Vx0zTqyWXoBNj1mEB?=
 =?iso-8859-1?Q?l3Arbj0VxYAfGv4m7dHEVqdYH889AJ714oW111p4X936om+vfdzVL+PdC/?=
 =?iso-8859-1?Q?qNbzu+VkbmxFBYxs4KTRecDomG7cHX/V77uoWDUGCNyxdA3tH557BwKTOB?=
 =?iso-8859-1?Q?qMlOj8Rx56RrINzeOYicJYCyykOF3xB1XNM0lV1vexmJIMy4dOWITuevTU?=
 =?iso-8859-1?Q?K2NlTdZPDz5pD4b7edgKQcKO7Ht3PxPAAUIfTNCa37ZwA3MdTNMe8VuY4R?=
 =?iso-8859-1?Q?weFhPQw1zyWr5cKHGSFKUaUH3eYAuppYAkms90VoJL8JSPOF6CfTfNO8rJ?=
 =?iso-8859-1?Q?kRiYCmEH674vCnQI3e/tWrJnQyigK7qS33XlRxUZBj7J2sNiq/SiA2aOst?=
 =?iso-8859-1?Q?DRXQKo5DVxUxf9ZFBFc8x129HTqQ7qNo4YALozrNmZV2CVQAA05cWK8U+u?=
 =?iso-8859-1?Q?V3Rs3hqkTCBz04R80tRtxV1YpUi8C7t/kBNslcxwTrS5PcmFlMVHNRdOLo?=
 =?iso-8859-1?Q?9Ql+Ch63soTs/nf12VHMsGPtcxWAxYXq+YUU+9gVVVzCDeLRolzL0D6/oo?=
 =?iso-8859-1?Q?EVgXW/mtFhcMSdkG0BoNHf+pqgNJU1b24GlJEWxf7Mwui6zUhhlMdycYVW?=
 =?iso-8859-1?Q?y3xu3xUlEOnUyZew2HDhPyTIVFWpFtO9cKt5yEMV4mqO4Tmng2BsGUwrhF?=
 =?iso-8859-1?Q?2ubAOvuOzjjSXTVGICECPNsmyaAkmy7NWD/EBSdLgCIxJ+UT4lYhIvHABQ?=
 =?iso-8859-1?Q?IRoGFjcn+B9G6kv9chFcDsW5guUGRg5psQkDM/07LTzwQykT2RcOIpAgiv?=
 =?iso-8859-1?Q?d9rFxQtny3GyhhahLm+vBnLtyGN/h++rL/Y7eZTbPfhoOFCDCSFw2g4WLt?=
 =?iso-8859-1?Q?b14pb+a7/2MBjZlaIGITse0XAA6iB/6p1i/XHSUmgkQYCxO41V5bKUmdkW?=
 =?iso-8859-1?Q?WYng=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e008dd-d856-4361-5ab8-08d9d65177c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 04:59:23.5675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2+51TbwPrHraRPzeRpvYP3SsUJK479HH9ZMciWEk1o3s9xjsR3Oz0qpvRln3pvc2KyKeITc+apNb+AwGOO2w3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1168
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,=0A=
=0A=
In one net namespace, after creating a packet socket without=A0binding it t=
o a device, users in other net namespaces can observe the new `packet_type`=
 added by this packet socket by reading `/proc/net/ptype` file. I believe t=
his is related to net namespace information leakage because packet socket i=
s net namespace aware and its `packet_type` information should not be leake=
d.=0A=
=0A=
The root cause is that function `net/core/net-procfs.c:ptype_seq_show` only=
 checks the net namespace of `pt->dev`. It allows the `packet_type` to be s=
hown when `pt->dev` is NULL, but does not check the net namespace of corres=
ponding packet socket.=0A=
=0A=
I am very willing to work on a patch if this is confirmed as a bug, though =
I haven't figured out a clean way to retrieve the net namespace of correspo=
nding packet socket via `packet_type` structure. It would be great if you c=
ould provide some feedback. Thank you!=0A=
=0A=
Thanks,=0A=
Congyu=
