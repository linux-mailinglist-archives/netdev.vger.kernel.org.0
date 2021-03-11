Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C714A336D89
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 09:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCKIN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 03:13:27 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21176 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229830AbhCKINI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 03:13:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12B89Zth011252;
        Thu, 11 Mar 2021 00:12:56 -0800
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-0016f401.pphosted.com with ESMTP id 3747yv75pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 00:12:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYa1Fb4GGGqGcKmsamQmisU+LcwL6kNYjU6jpH2KriUNbrDy73e1xMn/VqK92L/llQW9NLRjuEWGsaIHzjBgxPoDfi6vclcXlLi1nCwAHb1XBSEerJWpkGwHTjW3gf23Od93JsHY338FLBmRDqMB/88QHu7dodmUSAN1Jf6t3MUGNbCRbo5hmDnc6+zcxQeYBz5wVUWQiOGkTxgFjJlyE05ISnkY8y/a7YKVen3KICNzNdFPzldAuBfgacqk27cZVy62xUsownftSgiTK5JOos8RQ4tfxPqJaYUXQk0oSG7SlxOrRNExoJLiTyDZ7gmfa/3DRWil/gxoNWcPBRy0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbY+BSNXsmA77Jy3nYZ4WvLMJOTZIWiQar6U+p3QdPA=;
 b=iwmUiS9GxETm1aeAStzAl5DUN9N7CQOX245L+K4MOuxgMueT/7jeVYeUFec/WkiQ4QasCONFFysYdxm66gv2SnDX/kTuCcBnPrRNI0PoOxFT17VUoK1PGXRBxYo2wD5dP7J/R1G6nnII1ntgckY27t72lbOfem0+3aLY/z+H3F0oRp8HX+IvMQgdEKCaIHJr1z/yU5amn3c9uAaum/VmVR/wUFSK77HH7sJ1IRvkj0aSA5dKzzm88iiM+8gLSJ7RTLjEM99iaULWRd+A8/VP4/9ts17Qkz4Em+6ibR1Pj7qzmBc7YtuS2fDUAyjTu/a2uGjK0dlIM4O60mdK/IvLOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbY+BSNXsmA77Jy3nYZ4WvLMJOTZIWiQar6U+p3QdPA=;
 b=V8M2dWBUHFkCnIsGUXL+tv8wwX4kBUUwhfquZcllJ7SLvkQmMhKG/kUyuUaooqIIzUMQ9YTdzt4V+t1qHjpp6IbOH6v/aGSfQ13z6XLLQ6VNP1lY4q8lCTEjbmKFLkUkpBd6llIDBJavLn6bKMbx9Z9o8lUndfez1VhC0IH2d8o=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2123.namprd18.prod.outlook.com (2603:10b6:907:8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Thu, 11 Mar
 2021 08:12:53 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3912.031; Thu, 11 Mar 2021
 08:12:53 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: RE: [EXT] Re: [net-next] net: mvpp2: Add reserved port private flag
 configuration
Thread-Topic: [EXT] Re: [net-next] net: mvpp2: Add reserved port private flag
 configuration
Thread-Index: AQHXFZGs7YE0C+mbQkm8VJDJz1s2Cap9lBUAgADY6YA=
Date:   Thu, 11 Mar 2021 08:12:53 +0000
Message-ID: <CO6PR18MB387348835224340046050A19B0909@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1615369329-9389-1-git-send-email-stefanc@marvell.com>
 <20210310190018.GH1463@shell.armlinux.org.uk>
In-Reply-To: <20210310190018.GH1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [77.124.210.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32db565f-ebea-48e3-e2c3-08d8e46578a0
x-ms-traffictypediagnostic: MW2PR18MB2123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB21234F647D5AFF508FF885D5B0909@MW2PR18MB2123.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5fQZZ4t1wqpB/9tWp03StxSnY8fSPJBGEDtXd424V8XVHnFVIWvWI70rfPEYJ2BB24w5UgDL1zmjHYhbkk5F9D0Dj+CTktv5LVcmQKZd+stYlvXqliWfWsDOoH7OwjMbY5zUVLwP7v5bigC3NND6/ZFkJJf82c/c0f3QxmapXyE/b1pOeMFtOXqXChROmUwWx3jMtDf9+6wFqT7v5raonZXBXHOFi93P2xtcQWX6gvwOfGuyLKWePReAExREjZH11pCrbvCtK72jW0RsWEVOFgDcBz6TjlWxSihgRww2714+gdWMAZs0Ue6vF9H0Ur+W9GZBOUANPUa1zl7TvZ6XHt6tE73q7YSXS06oveewTSWB46TQOvanTk5+kZhs767yzzKw3TriyySGlvU2SYvHYqRjVhY/ChZN87vHha3UJuPOnWmb2yVidnLX/vRn2zd4VgvJ+Sbuozl8p7mpgFYL3lZTqE8X6MZvY69l+Ye2CX+HMzZgdobnAfsgVfoJ2c7euMwLSXDzw4J8wAjOpKz3AQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(8676002)(86362001)(54906003)(76116006)(4326008)(6506007)(8936002)(26005)(316002)(5660300002)(55016002)(52536014)(186003)(9686003)(66556008)(83380400001)(64756008)(66946007)(6916009)(2906002)(7696005)(7416002)(71200400001)(478600001)(66446008)(33656002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2+YxNYEUDfMwXK54K0MHHAX0WVv+yYuHiUwUplIceCFUQCyDdTsFXEoRuoiy?=
 =?us-ascii?Q?egHttPq7BhpLlaD2JpCmL8dta/xgEKJ4ieRzZHPnuPRbuBM8TtniJ0WqmEFz?=
 =?us-ascii?Q?Njm2xB9owMa+pivE7F4kYdxdCj25vtFsnTXdfBDU+KtLLpR//ykzK/Lo22JU?=
 =?us-ascii?Q?drlJQwubl6ecXhGx6cCQ6V3H9RX/RrdaztU9yd+ox3RWOHZ/Uic9lKKINXL1?=
 =?us-ascii?Q?ST3FUOXlM5HlxP2DhS7nKePXVuNGNW/nUmg6pgA+4NNgWVzO3Dwx87RssK7m?=
 =?us-ascii?Q?5SXIvynRQXc3ak92OCnmc1S/a/0HWNCovKgH4wsNflWUENoJRiVmrwTaQsix?=
 =?us-ascii?Q?Gz9rJz/cZCHp9WcnIPuHUa5AWyYlOJkxQMOfjbC3xtXzyG71hGYY0LtUVYwb?=
 =?us-ascii?Q?CNHyd8wS3xrvvDsg0NqBoTILVAjRZnxTpybF4eK/wwdPHIBPNVxI3vV65aFd?=
 =?us-ascii?Q?db1qadzJ1Dt4pTkipCOSMlW7WcYXHb+7fBvph7+xOXQous3inlIPm3IOO37a?=
 =?us-ascii?Q?ahtQ/lbGWtX1AXCVhJ2/qY3uwAi91xbnxS/XF6I4L/EtV6eyDzD+fiQnEKe+?=
 =?us-ascii?Q?k5xQODqGG3FOMe4rEOIGkO5b6m2lpfkC1o6c+st4xx6XLtg697aFTG1evDyn?=
 =?us-ascii?Q?6QMQZbAhEJg9Mzs2CpQb6pezaxk2XBHQmAXykRren53RRYiUKvfHpCoT4IpY?=
 =?us-ascii?Q?DIR/IjJNft0PCeM6d+WhMX/udvf+81wzCB7qnxGBsRYS2yTBTLhueNlX2NU6?=
 =?us-ascii?Q?5J6rzXiZbHjW0BXlhTH40YxgBAcU8MACDCoMRJX2isqdcqMVcw6wBOomiZoO?=
 =?us-ascii?Q?TTYIW0xGabeVs+CX4aBM9kWIuKLm2ENxp2L8QymIScawz8mtcHWSzoqedPq4?=
 =?us-ascii?Q?zbc57Sb1EX9hhcC6cWDVCNYrCTrjM7NBGnSvuP1O1ZG8ONqP5zwGCe2JpwS7?=
 =?us-ascii?Q?Em6pPW+qdGQi2gJKAcAgzzdqq2EmQLcphA1KrdbNCd6VMTExdySupvae8jsD?=
 =?us-ascii?Q?Nc0U2me0IhuHu4vmaUyuDdz5VcW7eKgRGY0eHkb3yfsl28SNyLRvBFMGdKXe?=
 =?us-ascii?Q?PEp/dKKd+zAPkXADHs9sYbVsi5mAO+FUGLYruHwQvgY/UKMgCmIqk+2sRs1+?=
 =?us-ascii?Q?/g8iU97q2yFo3wVidYhJkjUn4ETEkjjZlhIYoHkhqjNdFt0E+39HctLf6gGe?=
 =?us-ascii?Q?rRmv8BbzU+zJhdj/EP3/E4VcFHJeapkdQJX97yR6AYfFBemfMypkzC8CDhD6?=
 =?us-ascii?Q?Y+cEbE6Dl1HrU9K7G3Ugy12xPZo42UvS/0B5w9pvOn1bwlfOv7czJy39C4IA?=
 =?us-ascii?Q?vhoYHYDq6tF286coPw+zncFa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32db565f-ebea-48e3-e2c3-08d8e46578a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 08:12:53.8519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vhi9iwt3ZLkado59xSq6Gk9DNxK6xaPi59JAEFTEJctBG4K5yZGtFM6/TiNL18tiFLM2Y+agm2sI18ApznS9tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2123
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_02:2021-03-10,2021-03-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > According to Armada SoC architecture and design, all the PPv2 ports
> > which are populated on the same communication processor silicon die
> > (CP11x) share the same Classifier and Parser engines.
> >
> > Armada is an embedded platform and therefore there is a need to
> > reserve some of the PPv2 ports for different use cases.
> >
> > For example, a port can be reserved for a CM3 CPU running FreeRTOS for
> > management purposes or by user-space data plane application.
> >
> > During port reservation all common configurations are preserved and
> > only RXQ, TXQ, and interrupt vectors are disabled.
>=20
> If a port is reserved for use by the CM3, what are the implications for L=
inux
> running on the AP? Should Linux have knowledge of the port?
> What configurations of the port should be permitted?

In reserved mode all port TXQ's closed(Linux won't transmit any packet from=
 this ports) and
RX interrupts disabled(Linux won't receive any packet). We still can change=
 port MAC address, do port UP/DOWN from Linux running on the AP.
Only permitted configurations Is MTU change.
Driver .ndo_change_mtu callback has logic that switch between percpu_pools =
and shared pools buffer mode, we should avoid this since buffer management =
not done by Kernel.

> I think describing how a port reserved for use by the CM3 CPU should appe=
ar
> to Linux is particularly important for the commit commentry to cover.

Ok, I would add more info to commit message.

Thanks,
Stefan.

