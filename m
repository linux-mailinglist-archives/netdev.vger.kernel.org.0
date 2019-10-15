Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E31DD70D2
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 10:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfJOIP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 04:15:29 -0400
Received: from mail-eopbgr50053.outbound.protection.outlook.com ([40.107.5.53]:29198
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728560AbfJOIP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 04:15:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEJEqO5xBnTeCWGCwZ1fvH341A2re38dCFZr8RrzsHk5HmxC4SBDn3m/bDioyov+jZI4UsaOC1BfZbV6K9qPk7q0sUXyqK3JrbNKpRcwjuCwC+cD++qmvpZlRcOxwgOvd2zZJhOGCe2NaMFM5HeKTGekULPLjxTz8S8Gl54w66zUYnzyfbk8SZG2bOZWK0B8INVQ4O2HM6FAIAXgEvAS4UGb8KQjhK+hdoA6r/xJSTbv18Mp27nmYE0WMW9rW+L6LH8TL3bGCWnilOFb+5SNU/ML1z+gBOBD9nZhQI5iyBkcbODQ0JSSmSRLWVGwzKrpU6xK1kgknEDaoGFH4B6A6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UpJPMqiRHJY3NSzZ10zJ3GHzvuZPPvjeoWqFkYvVU4=;
 b=YRRWfjvkSs8w8W7NpJzY2yNAohN9dgCoZkGSLvaHdUq36qvLgU4TL9ztNugMD6SCmx8+s5DWVDiI0udWSQ1rhhA9nxgaP/tLYbhh7RhuWkTgRqYiAvg7gMxeajQJEr2tPxfDyf4YU1I34gGQ3qVap9O7AMPEzYLq0Q/ViC1t6Md1u8FQvjwxPHy4hDpCU8PSCw6A4ayZE6HNbOlfk7yzxg7dsdvcQw5zTMQ1//tGB2zId1WVZajU1toD70rcdTXdwImRpqJBx/osx9vT8kNfkiWaUi0AiDvqcUrmNu+WBcp6NFm/d8VMqU3EYhSA12v9VIfFB2meoxjulFTP8Vhk9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UpJPMqiRHJY3NSzZ10zJ3GHzvuZPPvjeoWqFkYvVU4=;
 b=qxfsDRgac+kf+QwlyJW1dll/uhbZPOkJkjezeM/VrVB3u4oC5kF87Ozf9rjWE2eHERNn83c7QZzhhNpofdZrgmVwPJQpN9TAWghchoeJ8eCJaTXcyN0hecuRbsUz08bK31tAtsy3O2ZZrFqCOpo2nQPi5pDjk1qdcp3V/CARwIo=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3377.eurprd05.prod.outlook.com (10.171.190.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 08:15:25 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::dde1:60df:efba:b3df]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::dde1:60df:efba:b3df%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 08:15:25 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 0/3] Optimize SGL registration
Thread-Topic: [PATCH rdma-next v2 0/3] Optimize SGL registration
Thread-Index: AQHVfRd2xu2EQ+EHjUSoTDpnyENqmadbZzOA
Date:   Tue, 15 Oct 2019 08:15:25 +0000
Message-ID: <20191015081523.GD6957@unreal>
References: <20191007135933.12483-1-leon@kernel.org>
In-Reply-To: <20191007135933.12483-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::27) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b65f356-4149-40a8-57f9-08d75147d4de
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM4PR05MB3377:|AM4PR05MB3377:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3377A6FFC5DFC701811C1943B0930@AM4PR05MB3377.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(376002)(136003)(366004)(346002)(39860400002)(396003)(54534003)(199004)(189003)(486006)(8676002)(9686003)(6512007)(186003)(7736002)(6436002)(52116002)(66476007)(66556008)(76176011)(64756008)(6506007)(386003)(66446008)(66946007)(66066001)(6486002)(99286004)(6306002)(446003)(476003)(11346002)(81166006)(6246003)(81156014)(8936002)(86362001)(229853002)(966005)(478600001)(25786009)(71190400001)(33656002)(4326008)(3846002)(6116002)(71200400001)(256004)(33716001)(316002)(14454004)(102836004)(305945005)(26005)(54906003)(110136005)(5660300002)(2906002)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3377;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qyt4WX/XUHoIrWgE8AiT4BZ/0pKrVyaW2/UHoyr+SE9+HEm4SqEYuTghSHT4dXf2stz2IX+qcRLjFNFuzUFn16jjetzo3/o+IacRVUcdnSUoI5i8U9Eyc435qh2ax7Jl/tKKC3+RsaLpphTHKPwEe+FRVYoYz8nzGGB103aj+X661Ecp98bZilOJec7kZ/7pOsk57ZV4Axm3qxBG0IoLDp8Ef+xLQZe6Lwt0zIuAysjy0n3zK0V99wlZZRcJtjEbSS60kGSJ3IZgKpgG49KYgU4BY5nX0aRUpl1d17kwp8M7g7Y0u1lKLBhivF38Sv6u/369sV0to7gFcpxEoHqzVx0Z+DJSbO3CfyKKphBIAsrkvDnoIbXA4vr2js80yHz7CSRcOJepYtpX9VCzxOi99Pd1GMljZ7ngryZwILG5f3HSnLgt78Yc77eO1miLybTy3Qg/ZbZ1xi6JUQApN6i0/w==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8C73AC86256C384087D07DE2F38752DA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b65f356-4149-40a8-57f9-08d75147d4de
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 08:15:25.3532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +erjus/iG9OMnVwyu1xH8VEWS5zZu5Kj9sZ5aW8JBUPB1v640EAAAvJ2f2YeTrBWum5HTt0ugw+EPVYF+vVMng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3377
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 04:59:30PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog
> v1->v2: https://lore.kernel.org/linux-rdma/20191007115819.9211-1-leon@ker=
nel.org
>  * Used Christoph's comment
>  * Change patch code flow to have one DMA_FROM_DEVICE check
> v0->v1: https://lore.kernel.org/linux-rdma/20191006155955.31445-1-leon@ke=
rnel.org
>  * Reorganized patches to have IB/core changes separated from mlx5
>  * Moved SGL check before rdma_rw_force_mr
>  * Added and rephrased original comment.
>
> -------------------------------------------------------------------------=
----
> Hi,
>
> This series from Yamin implements long standing "TODO" existed in rw.c.
>
> Thanks

Jason, Doug

Do you expect anything from me in regards to this series?

Thanks

>
> Yamin Friedman (3):
>   net/mlx5: Expose optimal performance scatter entries capability
>   RDMA/rw: Support threshold for registration vs scattering to local
>     pages
>   RDMA/mlx5: Add capability for max sge to get optimized performance
>
>  drivers/infiniband/core/rw.c      | 25 +++++++++++++++----------
>  drivers/infiniband/hw/mlx5/main.c |  2 ++
>  include/linux/mlx5/mlx5_ifc.h     |  2 +-
>  include/rdma/ib_verbs.h           |  2 ++
>  4 files changed, 20 insertions(+), 11 deletions(-)
>
> --
> 2.20.1
>
