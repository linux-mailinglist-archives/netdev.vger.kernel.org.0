Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675A4426B6C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242087AbhJHNHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:07:12 -0400
Received: from mail-oln040093003002.outbound.protection.outlook.com ([40.93.3.2]:15247
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230243AbhJHNHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 09:07:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKDLZAYFKEIt8Pib+CaOoUYeawnFlsNyP9fvuBCCfsSsuLVMc2MDf+FeDKH8vYjfEJU10VPdsDAiLREGhcgGQesc28mJjM/FG+4ue+/uml7oaysn4mv9pc0pevVAz0zQH519vmh1xmczvo5g4ovoCEn1tQ0cWRHZkmefim+aIzfSMdB7Ldq6FrAPgw4rcVVZhe4czGHi4QEkl6rxg6VYqVPDGIF04QO2lfTvWlxlXttbHDp4/vkowf25vLIzuxzqfWeYo+r079gt6skkhrsctWUR6U70MoNikeqDHLacQV+S/qoADKNTgavQUpOGUeuTwUBmDrWJaLgQdKad8HEsLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuioxAJ6M4gekUGPAvB7FszSkCwD2LhzsTYePrPoWxA=;
 b=VqqaxhruGe6dwapHzK9yhAp6t3Gy5mHCdpTLiMHGRlyrYX55E8uDKN10JGwQ/Un9FEbe8LSSo9eKXQrPnzwP0WoZrmGuc78FioO3TKPfnsed7j+tMwIfna5PGtuvbZCKto1KbFZEaEZPaVatc7+73uEXwCbvVaBBU1ZfC4C4ErQXiGW5NhX29fqXH4flW8ooyaEGV9t4S4bGsbwQ3WYMI1ir9YDTDG7l83hOlXDiNmQlGQR+RFnhN099a8XwdITOctXM4/BlMDEi57rl3tmLHuJ8sb1TS1FI6WkfHB5v3mqm3OGzUcjGyw7T7JEUXnihsHI+wGIdhG9gqAvXUJIfvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuioxAJ6M4gekUGPAvB7FszSkCwD2LhzsTYePrPoWxA=;
 b=FuFdiL2t5d+hIXE9xIGidGVmN1BL3QZqZ2yO/3rR+cQQn9ojAT1OrE4+8HXJ+JWw/N2mlmkXFfPp+YBkVyP3ngakp9XdCZi4cbv+1PILbUFrsMOs5YrN4mij0rndrCEZFjiZXoqGTR1zA8K/4cC47LUSvz17PqXboyjcy06iV/Q=
Received: from BYAPR21MB1286.namprd21.prod.outlook.com (2603:10b6:a03:10a::23)
 by SJ0PR21MB2022.namprd21.prod.outlook.com (2603:10b6:a03:390::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.3; Fri, 8 Oct
 2021 13:05:12 +0000
Received: from BYAPR21MB1286.namprd21.prod.outlook.com
 ([fe80::d89e:383d:2e2c:d071]) by BYAPR21MB1286.namprd21.prod.outlook.com
 ([fe80::d89e:383d:2e2c:d071%5]) with mapi id 15.20.4608.005; Fri, 8 Oct 2021
 13:05:12 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: mana: Fix error handling in mana_create_rxq()
Thread-Topic: [PATCH net] net: mana: Fix error handling in mana_create_rxq()
Thread-Index: AQHXu80x9hhDQvwXq0i2i4Ykwt7sMKvIYIaAgACx91A=
Date:   Fri, 8 Oct 2021 13:05:12 +0000
Message-ID: <BYAPR21MB1286890E901CBCA8AADA0AD8CAB29@BYAPR21MB1286.namprd21.prod.outlook.com>
References: <1633646733-32720-1-git-send-email-haiyangz@microsoft.com>
 <20211007192739.59feaf52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211007192739.59feaf52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2433f5c0-3ead-49f4-9ee0-c86df83349ae;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-08T13:04:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 137cf9c5-bcb1-4879-bcd8-08d98a5c43b4
x-ms-traffictypediagnostic: SJ0PR21MB2022:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR21MB202249E48CBE0A37CA5853CCCAB29@SJ0PR21MB2022.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UMHbQf+Ry9gukNFmjBGW5gJXqPAWn5IQ7zQ6SjlZZZ53q3amwHZx2nSRd8SComgn+VDvhQGpZTgyRX0iP3zrvaOitcAmjJFnKO/HPfXZyVWP5oP4K2S1dAOMiqKnxJ+H+HFBSwsgGDMJWsUM34SxTtE5bh+6C6KXe003dsdV99W3xQJvNaLP7RxZ3Jeo638ejMkki7dIpVka2CbOVIPuBQSlHInL/RCE0aptRfEdqckoS2jnEPC5knnYpuJvHQX4hAlZ2KIwio+yKjxjHO11BIF8oTL9BpOEV+4EVcQmhUl9L1uyybyAP/JQ271Ir+Jo3N6r0anAkyC32YQKPmSdGJaGeJtqOiHPnZKIg7JQjAxwKJIKzYCCmv2FWTx5hpNW55mu9WFTKJ8/8tR27atFAUwKO57WPofrUgcj3XChyXLuQU2chm/Or57g9+bp8YyHqFKLH22VyWgi2WYwDch2Tcn1HeXQ5mH8QGghjVhyC+8aPwbe/UIfqAxxK8KawOKHzBgG4p3PRY3ly6s7Nh498NBk680SY1BXgMU4Yzv3EPaonzu2P7u26xEmAj0aoD6LqCWoT08Bm8r7rw9LuXYP2FtEs5SQcUSOPD0EKXVcXn+f+Zpdk8ddY5yJpQVGMy96Awr6GiP/46lkV/MP3J1zPwGvEiGhg9ZZPG8LPFzpj+hTMnp9Rqn225liyp/pIR/aovwl27R04ATql7FbDyoFhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1286.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(10290500003)(8990500004)(82950400001)(82960400001)(7696005)(76116006)(33656002)(8936002)(66446008)(122000001)(508600001)(9686003)(83380400001)(4744005)(38070700005)(38100700002)(54906003)(71200400001)(6506007)(53546011)(64756008)(2906002)(5660300002)(316002)(66556008)(52536014)(55016002)(26005)(4326008)(66946007)(8676002)(86362001)(6916009)(186003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TweRQUSt+ETxGk69aNFnZ8YUIPp8TPDyOlIqGCqWykESWK0QM8qKTejMgsOp?=
 =?us-ascii?Q?c7CIpgjLlo/D4Ywl9trNsVFTbNiaLoz0BdDPhcEFZmnAc7UM5tuBawUiwFqU?=
 =?us-ascii?Q?gimyEULepcA9gbYrYhemGfbOLZkV4zzQoJ7XQ/8+1qUuhQ69cS+XfIcuOEJx?=
 =?us-ascii?Q?Dtv6N86NLyTWx0Og7tG7jMeInHq+De3HZh7TxhcMVOi15IyJ3aSLCympnSfu?=
 =?us-ascii?Q?nhIu0tYFBHCR5HSWD64Qh1vj7hCQsOlJEdovShbvdsUxHLi9iiIgkaUF0Mki?=
 =?us-ascii?Q?MZM6CToyBoSXjs2+DXUm8Dy8RANcZ4PZlYp1L9jlqySmP3tIh0mda5wjN4Hx?=
 =?us-ascii?Q?yF1+cF2mdsvaIi5R6HeW8UF8crfXGnjMvjkCs8YbFndMfBbEUoWFtyJ/v+uy?=
 =?us-ascii?Q?aaX4O97iZPpfzHeAutfLhVGmuW1xsZHMDj228Cflo6wdV3DXWaVFLUJlt7ft?=
 =?us-ascii?Q?lQ+TDWxfwuOpV3HHy0E9eBlVpq5QfvghGmB9lB2THa0zHZ2CMxtmzjqjlVoB?=
 =?us-ascii?Q?zFHiRT8gAEpMV/isRYmtcgxQt4lCHdeoD30q3oQSEeuy1tX0teEULZgL7sgZ?=
 =?us-ascii?Q?NN8oV2e09yntmQU6T/vakNl9+RJvy4pXNs9dTN9UpqBA2j4Opu9ogD+pkeIv?=
 =?us-ascii?Q?l8DthGv4T1Ztj4v0mu7VPBu4k7t/CDK30LV7xbd4bIzxhJc+zilsHL1R4J1q?=
 =?us-ascii?Q?noVncQePRq5DLLhYtxOwlZx+ZtDFWL47a9Iyny1XmErQp9pZvzsNuhmN7noM?=
 =?us-ascii?Q?PB8QIvQGmDESAcAU5Y8B+aF45nwxkpKGl4a5HQOSETJC/0efrkw1WcDf29ee?=
 =?us-ascii?Q?7IRC2AjAPIPQfRbVVcd/qBuIpcY/l6xghk+QIZqT03+sY8e4+YreMVr5+DrG?=
 =?us-ascii?Q?MSS3HMnRSJ+BqtdIFDm81t/63CatDSU+lZhE9yJTf/xN1U65Hp2qFvb1eLZs?=
 =?us-ascii?Q?ojYMsvArolTSmL6SgZ1UqBE0aHzA4aHmOInac5rlFzpBXzDfCApnM5VtGFXm?=
 =?us-ascii?Q?2o0y+UVcojq6eDr8CaTtgPCtuwvzYIX/SiZE7+xPP5rrrsgxjbNKcfNwh03V?=
 =?us-ascii?Q?NKCOAC6p13bq2NtZ3IZEgh29+6REpA20iwFu8Y3KWuB8YW18U8zIWb/JdsDl?=
 =?us-ascii?Q?q9lN6GHD7J6MgyWGNUgKijtSfNG2mzfNmNY+LP+o+vKVYsetcN8VoPOXdoWl?=
 =?us-ascii?Q?9bZpenWdThh8Hygmxcmj30e257pXQSA5rbDsXAdEsjKzoVdlPn2O9IL5wCx0?=
 =?us-ascii?Q?GPeexHhQw1+qNxdI+ghKreyyotlmKMR8T0X6FFmNQErEdGVfyPXuq9gvY5Qm?=
 =?us-ascii?Q?gNU2g3B3NRJfzE3rJak1tdyA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1286.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 137cf9c5-bcb1-4879-bcd8-08d98a5c43b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 13:05:12.6518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p0JFjdubCteLJBjvCw+igqByr+tvJb2EBoioFCgUhJK22hIyewrG1+xRwDz7MuR//pf//sqU+z7ARu2oJye5XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB2022
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, October 7, 2021 10:28 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>; Paul
> Rosswurm <paulros@microsoft.com>; Shachar Raindel
> <shacharr@microsoft.com>; olaf@aepfle.de; vkuznets <vkuznets@redhat.com>;
> davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net] net: mana: Fix error handling in
> mana_create_rxq()
>=20
> On Thu,  7 Oct 2021 15:45:33 -0700 Haiyang Zhang wrote:
> > Fix error handling in mana_create_rxq() when
> > cq->gdma_id >=3D gc->max_num_cqs.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure
> Network Adapter (MANA)")

I will add "Fixes" line.

Thanks,
- Haiyang
