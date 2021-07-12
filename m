Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150E13C5DE4
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhGLODq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:03:46 -0400
Received: from mail-eopbgr1410118.outbound.protection.outlook.com ([40.107.141.118]:45049
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230292AbhGLODo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 10:03:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8+1N0FP7Km+lSEL8vC81H0Wy7gDG+YYnjwho6ecSCyL773Dbfw7tywA8dPgbowrixM9MsbDvRMo05x1UWV5exwIWLw2f3TKKDEuHSleOcmG+6UFc4PlaYwNIN4BWxnM6qcRZC/WES+1YTp9yG+PGC9yXhYsslIM3ugto9sQw7vyouC5XdjbNANdrwAWjLqHUgUP0bk+eh9IpM0teFVzxKUXZB4MCJZu/bdaLKCbtIW1JtaDGgyh/8oNMeJDw8+o9kEBShHgyuzuyHNgZCsZSp1aA8qROmXR7f/6f+qRV6oiCCYzaNYnrQxPE281kchu9Umq5KQjnlZmgHDOhsMm1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h92UmChI1kDmrvgCJVDYRslPzcsqzg7yjsUARi9hbxs=;
 b=bltvm0Ah6OwgBVqoZXKil1rMBqJFpS7i2D6eTJ1uY3ubyoRrwqj9VVN8T9+uYuG5ToO1gjDF/NMaDA7hgabbuLMliyNqFvQTfXI5Sap96YnsfznYaRhuCZ+ptknEfvdVUkmgSKptmkjRtAwqwfPmeIqSlmSmL7EwY7/HOSOdxOCcYRWX0zGscVOrkWOlwxk06HTt8RWjSA6ygwYtBZGFGNP0fsmFd777BdaEddKfra40aOhm5idoztJWbSV+1bGa4mNSXdSMusowcP22tuCDv8u73hkXTshrDUEqMNoxl8b0QgCEcS64cCoAbZRRrshm3bNTBF5O8FdipVXDuwv/fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h92UmChI1kDmrvgCJVDYRslPzcsqzg7yjsUARi9hbxs=;
 b=hMtzmPho9fF/Fsr2j7lQb9BoBQr1sEByKFe8umFO22lsDfnsN4vtPjDm9fwYhN/ZcAd+axP0Kn0nFphDmGFfI3rHyPQXC/0r3zhYEZ+5XonC6NNNb95d6BxLbR0rZuMWulJTNLlmQ4sVn/JGTEzlua45C14RfNIT0VzDJnkzNHw=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSBPR01MB4135.jpnprd01.prod.outlook.com (2603:1096:604:4d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 14:00:53 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::f5df:78a0:b64b:c765]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::f5df:78a0:b64b:c765%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 14:00:53 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Thread-Topic: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Thread-Index: AQHXaD6QH3kS+d8DxUyFpooG2wAFo6sihNkAgAC1sPCAAB6rgIABcPxggAAhdoCAGpBG8A==
Date:   Mon, 12 Jul 2021 14:00:53 +0000
Message-ID: <OS3PR01MB65932031854C73A1B3E6FC3BBA159@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <20210624034026.GA6853@hoboy.vegasvil.org>
 <OS3PR01MB6593D3DCF7CE756E260548B3BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
 <20210624162029.GE15473@hoboy.vegasvil.org>
 <OS3PR01MB6593FC9D6C4C6FE67205DC69BA069@OS3PR01MB6593.jpnprd01.prod.outlook.com>
 <20210625162053.GA2017@hoboy.vegasvil.org>
In-Reply-To: <20210625162053.GA2017@hoboy.vegasvil.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1429173-1fc2-4491-59e8-08d9453d7661
x-ms-traffictypediagnostic: OSBPR01MB4135:
x-microsoft-antispam-prvs: <OSBPR01MB41352B21CA5C24375724C93BBA159@OSBPR01MB4135.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h9L9zU9NFm88p3AcoDzDvn7eogvC8OW641fSGMS4qVY8RMoOsn4GpmFYJKpSEhxrpSZFXXKnzymmGJ7Wf6J8YTbAv4/i2Auu0T8iakj7hPY+vliJGkqrqxH3l8pjNVPW3UMO07fLywKtPazzPyzVHcQ5yxS0zAMJZ3ruOLMSTL0L3aunpMW25q8EUgTK0uVU+/uOSM7Ip/7VTzXLBlfuX+I9AQOOP69Ps+C5vO745+mvMncGs7n/A3/wjm7zmRC8HGtklLjAvJRxSMl925ZaD5nfMO8GqPtjDQBw5MUUMYOAzz5FXgRf6Y6sxAY6B2DixXPejBDlPDmbmdvmFntLgXM2kbwqoJN2DBc6WHVyofMDPBaXsy86Q1+nFgk8PMaAhau3cH5kE5Gjs/+wvt6QM2oEv1biMAWv9Xn5k6+gEWerHMEuk7Mn/7mefsVlAvsB8H5V7G9xCu6miGCcSvNivxXIrszzfDeaPrl0zzIjdBGTg5ZhGlH8ehgx/1AHJ1GxxP75y4uhtBeY8o1h/5NGoGJZ5ujoqkjIegSBuRQG6OJkHPRFdjcjphwg1lK8GGE149gI6DHg6N3Kvl0/iUrrRkoCzBMvvA8DzhiTdSqIhhRKw1Bo0RrNs9JhTbbQx+9vbQj2Ct+GqSaTIOU72gGbrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(316002)(54906003)(6506007)(53546011)(52536014)(4326008)(86362001)(55016002)(8936002)(83380400001)(33656002)(8676002)(7696005)(186003)(64756008)(71200400001)(76116006)(122000001)(6916009)(26005)(5660300002)(478600001)(66476007)(66946007)(66446008)(66556008)(9686003)(4744005)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z+1zVpDV5XNtQkpVDw+1nOMcFY5png4735y1ZjIWYHtIOILtfJvKq6QRCBfH?=
 =?us-ascii?Q?NiOQIK9QYU1eFU3sYwTlcsx/7/wkjyxQRZL7SxFSbtf+6glvdsEA7GQmsHOp?=
 =?us-ascii?Q?0OuczmhJFogPgISZkhT9lEM0F05p+N2o0bqMp3f3wBu6G9A+F+sY/knypYMt?=
 =?us-ascii?Q?c3d8kMuYL0DhUkax5BGdNlbcUse0j0KpnM4IE/W8XeDfVg/3Zq3oFjC7j94M?=
 =?us-ascii?Q?GZR1De84EjN5yQJJereXEjWqam6TXtNRuF3/yP0RxEui+gOsyr+RFyLr08Jv?=
 =?us-ascii?Q?BehG3C47Sd+8HCvHOfSuMLnzKUlXLiebLS/JnfZorZ9KRX5ATdHoR/siiu7l?=
 =?us-ascii?Q?zeiQMZtKZ0LHC3ryVR5sEz7oqJGFqB2yGeVkWdyC3UcYAwz7boc09HXeQXmA?=
 =?us-ascii?Q?fn4mszvX828w+YsxX68lUinw1TyE8jBQBzZsXZ0FpUupDDjDTIGUCzcUqiUt?=
 =?us-ascii?Q?qGP22qFHHuIsql+SATbkZ/mcm/qqAAiESOMyIREiHClCLTWZzkmm3HsP5wop?=
 =?us-ascii?Q?D9w/Xas0jV4oHoYrKQyA4B2IpqE9WLVAnM0KkiPd1ZrwhsWxu345g36xHXpR?=
 =?us-ascii?Q?lALP026gSev7hY/oxE/PHa2qNtiERbedRLUzaneZt0DMwPC6qN7Yv5/tPJia?=
 =?us-ascii?Q?Fw80q3z4B8MzyMdvfxlQqFap+eHfJhBoZ/tJlxXiJST+e2J8sMBmVE/tT4e7?=
 =?us-ascii?Q?5vxvr5VTUyS0b9iZy4Ma27FtayKTcUJY8jwQa5KFeXfw/huUezpQWa3/LP1H?=
 =?us-ascii?Q?PFnh+Fs5/sAR+sGUi00QoKH+1I66fuhJN6RBqtJCUdDvX2Ze8+6V8/wM99En?=
 =?us-ascii?Q?TQqFPCSS/FetOfopsNojFmrd2nMe9YxQ9d+Yl+NtGpEHofYn4hWGU5RZB3i/?=
 =?us-ascii?Q?ZJt5S8B0KOxZW3JUM0Ys+x8oD4CKAUngrCS/lVxf728pJ9oODkwbpO0/w9Zr?=
 =?us-ascii?Q?5QML0zhXgULa+IThGc4hdTWNlsBC4sPk4s5smwtgfts/TfD2WzNGQh1pA4Fl?=
 =?us-ascii?Q?z8vTLogeubYTbOmwsrr5GTlionc801PHEd57RiCrZD7pAcIZlCBv3gXRvZHU?=
 =?us-ascii?Q?eAzLfLX7U1QBMd8sySScuhkaLw7u6JC7+OuiD0+SU2SO36PB1exefxn2KI5E?=
 =?us-ascii?Q?opK1wdUfOd2P+l51HIVfiITMpyaDCTMne6Ei/WR+v+MFcgAk34CEp7u8G25G?=
 =?us-ascii?Q?CdhhabHeNNftmRnXcULNhaSqLuyZk59I9LkuS9eVmC/XJxmj0gVUMKpmgfWq?=
 =?us-ascii?Q?6iJtCzzrwsamajXDKz3BqmRXP2WruijboV86E3YAfhV0ykCSj5Myt0o6SXaO?=
 =?us-ascii?Q?daa6x7ysvgKpgt/fhPVoalp7?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1429173-1fc2-4491-59e8-08d9453d7661
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2021 14:00:53.0361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ibqRGwwlwjcHGjgRivZYk4fF5QJ6DHFz9Rfe75gz+Jn5QfwZjd0DLqOC7bVC7mntXQVbh87W2FsXGVfNpILNOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard

I submitted v2 patch to for this change to adopt your suggestion of module =
parameter. Please take a look.

Thanks

Min

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: June 25, 2021 12:21 PM
> To: Min Li <min.li.xe@renesas.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
>=20
> On Fri, Jun 25, 2021 at 02:24:24PM +0000, Min Li wrote:
> > How would you suggest to implement the change that make the new
> driver behavior optional?
>=20
> I would say, module parameter or debugfs knob.
>=20
> Thanks,
> Richard
