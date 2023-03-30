Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D0B6CF98E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjC3D2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3D2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:28:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2119.outbound.protection.outlook.com [40.107.93.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5476F2D52
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:27:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yuz0z4JQbBu609VnonFnTuT/Sb1lHpeO9z0exMFqLpShYhPdDJIv5zPydmeMJBLY9YCBXvphkx6wznsVIHK9LM1F7h6eRTo65+lZjD0rj+R0k9Rn5qljgiGWmdrV3l7aKTKjmqL6jYW1X+LM+mOFk0hFoLLNoApNAqINfZWF2kPtVUDMItVQaDExRtndRmZTIgI2XWrrnkuXdBGHQPGMsbrdlK4axqP1mlATAfdHXHWCpQ2elCLusMfi4o1aC22AVNEyG3fIMIW2eljoW1z5+dn6bkJqgumWYIUcKNDs8akIGKnTZb+RF40pFgPEbTLkmLu9I64H6e5JLnai5bbLAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWrs6/8li/UyNGMXW09JwGfV9Ry+lhYwlk1VPBGqlNA=;
 b=LYtckJK/Iy61ofbEliM57Ui04SQfa30ecMBT2WBdcFSSquPRKb9zRhTCcfEEq9wyzHqb7Tw35Xwm198SrTpcSVPQKhtZKB07hpa3cN6AhFkisY2QSMpE6BHX6JXRo4ca04ZKJ5IU4NvzBa7hHjhz3kpPYHOUftwmGwRwARM3hq6hN8rc6unUhl4SKrP6eKsbCSkF/+pqO2CbtNe5M7quWg4T8Y4N2XiJpSU8zLBEiBaYnQO6HW9b4W9EC+4Y/0yhoDO1B4EOO7KozFphoEA8dVpHSTV3P2ePAAsk/QASTXeqaa01T61PHPIWbyxwP3npFNDrtBL3ztkhR2rLG+bxkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWrs6/8li/UyNGMXW09JwGfV9Ry+lhYwlk1VPBGqlNA=;
 b=tNYt4mYemu2BK/PPHfplLq+bRJj0M7cm89YLjeCTmQw4O0LoK9ZYvWzckUN13LKih22C1Vn1bYBAnVcNcrNxV73FimWXPbdnM+BVPjZ7f6aLQPNdQMMCLzeEnoOoFg7t69VioGSR+YQJveMCuhW5pMnmA10ZsODiH2LNPvKrqJI=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by DS0PR13MB6305.namprd13.prod.outlook.com (2603:10b6:8:127::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Thu, 30 Mar
 2023 03:27:56 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 03:27:56 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Thread-Topic: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Thread-Index: AQHZYk04vPXGemGWL06stjs7wjJi768SIv2AgABoL/CAABGngIAAAw9wgAAF4ICAAAM/wA==
Date:   Thu, 30 Mar 2023 03:27:56 +0000
Message-ID: <DM6PR13MB37050D1FEE2A6C13A68C9325FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-2-louis.peens@corigine.com>
        <20230329122227.1d662169@kernel.org>
        <DM6PR13MB3705D6F71A159185171319E3FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329193831.2eb48e3c@kernel.org>
        <DM6PR13MB3705DBC0A077D7BC80929AA8FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20230329201029.0fff8d9d@kernel.org>
In-Reply-To: <20230329201029.0fff8d9d@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|DS0PR13MB6305:EE_
x-ms-office365-filtering-correlation-id: 6ff3aaa0-137b-4a72-3ea0-08db30cec127
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zWXys1NMC93Y7owkh59A6J8g6fjQvLgx/E3oUTNXOLi3o/ybwCUHbOV07vt/2GbZ56bZrelcTVIN21FJCM/5eo8u387SReVdKVItwNjl+U0gSLaIpldewcTi49cawHNo3zjpzh7ZVSZus++Z5F776moWM+3Pc7v7tBL4VNq0QQizJxmmzy+IDULZAxiXYChBqSAXAEXvDx+YQO12C3CuL7cHZAKyEq3jSpQLhtzE9rfEHw0IS1wAiqhpZBDwL8oz3BZMgheNl2luJRtRWNU1ZX8BVrBumOKXs/dT5XQOBOu91wSeiuWYKHp6N9DJ7CKen5OcKyBT4UaDj79OV7LjYFERsBL7LagkH2K1k/uoBRH4LHnnn9QiAJTMfV1+vL/OuY9vbQZylDt5NH3B6NiezVaBKUQbNfGbunlJy7lgUZlWX3lLnCvSxiawRfpXQjXNxTMg0gI+R51xtsQFv4SqZAW1/a+JCdKtH1Vqfw4x5jG+uMlSnsbF8Is9V4Q9EFLKDlQB8Dyfc1uLNtSrykO75NtA6H8vWEEKGDMtKDR2mlayICys2Y6hxO+nOUPl98aQQrPb1USnez1VwGR7HsUzlWrQzSaiycF0DS4TyARU6FtYxHvDTLZiieYnu5TU8QZaSxHgPl9v78LfiR9sveBIdlBYgUMv50eYdr7fbNhxG+0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(136003)(39840400004)(346002)(451199021)(316002)(478600001)(54906003)(52536014)(86362001)(5660300002)(122000001)(8936002)(38070700005)(4744005)(66556008)(4326008)(66446008)(44832011)(76116006)(38100700002)(66476007)(8676002)(2906002)(33656002)(6916009)(66946007)(64756008)(6506007)(41300700001)(186003)(107886003)(55016003)(9686003)(26005)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pm81Y9RLmF1tpQVwcUT633yH7Ey8CMvq6QirU/fRJh4OxD/qppIMMyJKvtSK?=
 =?us-ascii?Q?0w6iQVNG3QTd9ssh30sWrTOqgBUsx7Jes4rVArryy539UGfzN6ER0dE76q+R?=
 =?us-ascii?Q?9EiBQ5cT5h0FUdEVBSye5pu5DwZKLhO1xQI22iMkILgUVOwU6KsBig7JqI25?=
 =?us-ascii?Q?VoB4NLh+IHqPXViAVEXh9IIWLH8S4LheFUFk4QfM92Le1kEB55p9EXFlHWIG?=
 =?us-ascii?Q?/ZGZYwUM+85sjfsQpleMiRotqbbuY49RL98tRIZlcFtna3vDhWik8D9/OLc0?=
 =?us-ascii?Q?livIeN1LpEdT31Tjxbh8hLtngoSqELv/nfegJ0MUvndFVhaI0AaDmX/366RN?=
 =?us-ascii?Q?0VzBJ0ggVD5razgnj8Y7PfpSDYnVbOO310oVGTqkCOl2ZGSbNzepUxX7+EFS?=
 =?us-ascii?Q?kLp10yo2p4pROXBLVPp/2V4cOctIP4xNdTrhIRag4W00Gi9mlkfjC2Fm6MAS?=
 =?us-ascii?Q?l2CfQBItntgcCkAE0pK41QVXWIuxcJAIOPPtVLqIsW9vmLV6wBtH9p9GUe6U?=
 =?us-ascii?Q?6qchdTOijOHaYHG0nbo+slHoARITQcX14htB6Usc0zFS5Ky1k1qKR+gaVOn6?=
 =?us-ascii?Q?gjtGDaNyRN70N3TPemCJZUw3hAIsoNSPqmbRjpyVO1WW4pDUI0W7eFDyqits?=
 =?us-ascii?Q?JTJUzwwNzKnNGtH5v3sbVHBYua1VVZi8J2jVicGn8P02q325a6gYW33dJB8/?=
 =?us-ascii?Q?gqLDlfFPsQNoN1YffweAb17UwSbDYDLbTlHQquJxKulSi3jz7liHK52DJBq3?=
 =?us-ascii?Q?AZ1nFkhVwaMF+y9qRGRKX6vPBDljFub8KVdip2rJtticBL5Hnz1+szVXZfg8?=
 =?us-ascii?Q?aMn347VtPZYHqZwYl2W2E4F5WvmexFdqxQTPQhXT04OjKs/v+//r5YcDuF76?=
 =?us-ascii?Q?as6JOrTHrOEHoWPCVPGwGEhoNsfvZp/v0DFT6u7UOgyGUpmQqDVgVNW4UY2W?=
 =?us-ascii?Q?ACqe11IyQyUwfBPT6RW0XHE+tgr5Gpz7QYrJRgKRG+tQO1Tqvtuoo1KoQ9vz?=
 =?us-ascii?Q?96HrF9OG65sAGtnk8tiRgrluaTnaZtvm17NYGxsYukgzopYHeGn8XiEALM6x?=
 =?us-ascii?Q?9Q6IPNuvgVIfePRTQ9l3uwY9dbatzR1s7rtacN3OltrsKckVlWjjbPRxejKb?=
 =?us-ascii?Q?aFUt+41gKuJAhspSEQIHrOuhTDg9wlm/qs0onKNXNKJgOcCIUidek2m7RUrT?=
 =?us-ascii?Q?HioYPo2ZTi9gEDGFh9IclxXxThvCoOf+3umVARBeHrKMcI8tzaphhMjARgju?=
 =?us-ascii?Q?l5KPY/nruBVZpuhhuSA0MV0iW/A9Jso+L2KVQFvCbaRjGvgOIoW9x1miFSXx?=
 =?us-ascii?Q?ILSI4ECPQwwLYjSV+ZMJgxHulO/8xTRYvUVCd+QZQm5q+IgNn4gnC8jiQchW?=
 =?us-ascii?Q?kpYUhMuMZO6XEZ7m2znz5tSs+xeIR7GdlvY0DTgQOvwcLzoP4DvFnSFPeymx?=
 =?us-ascii?Q?9TZJYmI75oR3tch33eO/odHWOreeXnKEGUCUS0OTfDom7XHKPJrmZIRrlxFt?=
 =?us-ascii?Q?GgQDuduOepeIiaLH4pQenpbSfHDFQw1sil7KD+wJPtNaH3WUJBYdz+NMa3/S?=
 =?us-ascii?Q?OarsIRRLToZwq9cMD8y70SWmohwGWOHMHehd6S4t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff3aaa0-137b-4a72-3ea0-08db30cec127
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 03:27:56.4699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: za70yc6+3gFIXkcZCdUAmNCQTK/pfNBrq+mD6RZ2Vhlksf6YEJkq/Ev7KyD+zjbrP1XCwTCjuOXQwUYRo/6CSKubriPWqanq/PAKmUuhDNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6305
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 20:10:29 -0700, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 02:52:22 +0000 Yinjun Zhang wrote:
> > > Yes, but phys_port_name is still there, and can be used, right?
> > > So why add another attr?
> >
> > Yes, phys_port_name is still there. But some users prefer to use dev_po=
rt.
> > I don't add this new attr, it's already existed since
> > 3f85944fe207 ("net: Add sysfs file for port number").
> > I just make the attr's value correct.
>=20
> You're using a different ID than phys_port_name, as far as I can tell :(
> When the port is not split will id =3D=3D label, always?

You got the point. We create netdevs according to the port sequence in
eth_table from management firmware. I think M-FW will make sure
the sequence matches the port label id.
