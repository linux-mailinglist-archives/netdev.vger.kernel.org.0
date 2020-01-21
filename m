Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4144C143EE4
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgAUOFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:05:10 -0500
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:8174
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727817AbgAUOFK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 09:05:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghChAIvnTjU72aZ8uN7llJtLVkWPnUZ5PzMLsuKaj9QrPd+xMqlMzIlYF6VS1I29FMfJwOkq57Q/jhvmSfhg+cUctyesYtIL/lfyPFzGR/pMs3dPEMtWyd5878WNv9E1od1nVGtLRF5rbphnGnpj/zz+u1m+V5I1TEV2k5ztN8MAcFr6IG6rcjW3jLOv0ID537t4G8+xxhS4mbe1QAYTyBPkUOn9xhiJba+vpIkErNpSAxUIG2/73ELbMdE0mJUhjdKXvzhdpOwfA7/+cLz8koZx2OENb3L4QlRiBnFiHrYJh/uR2DEsJtsoACTJppGWuVRjHjg2XatBhlDw7HBLIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7OzItzkaEvJ7h4xt015A/r1HsxEaQKVQAX2j+LjPfU=;
 b=lmNHsCn5c+KQ3Bnxyp6jEF280T3dEuQXHYON+XRk/lEJY1Mqejm0ydEbE9V2T6lCdJqmWLpI/coRPihJD40dFz5y/JbdJ1idkMeL/wvuf5O6kYXXUZogIOIsvqgrqZeAQ2HF8FhOraxk587/64XlLLfHa5C3JgPAnVfKHYUvboml9e718nOHjBEuTbxsQlJAyiDTOuVFBDO58Xvdt73SvP089ZvhYLDAMlEME70uwMsi4QomkbMfAK8OpC1glruKm8Y6qTU0zFMtyJf/d1UrbeQl62F1dDWcyt3aNu4bRKrAa8tGaHbcgX0RvO+kSO1/IZYY6KhTQy54Rq9JjhGszQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7OzItzkaEvJ7h4xt015A/r1HsxEaQKVQAX2j+LjPfU=;
 b=ZrZdHQnkSB8ov3Jk69oyHdPxh4l5YCYOScqn9pV6XRJnrNQSNhqembCi1jWaeBqB/HZiEbjhRru3OORq0jxTBpRNLU/QOCK6gBv4o1FjGuI0eCvj4Kxf3g1Oiv7Xfl3U0PABv4EqtajjXtvDlO2ymLLuPOh2IRlJM2oQYitRM7o=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4512.eurprd05.prod.outlook.com (52.133.14.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.22; Tue, 21 Jan 2020 14:05:05 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 14:05:04 +0000
Received: from mlx.ziepe.ca (12.231.255.114) by DM6PR10CA0034.namprd10.prod.outlook.com (2603:10b6:5:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Tue, 21 Jan 2020 14:05:04 +0000
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)    (envelope-from <jgg@mellanox.com>)      id 1itu9I-0002XK-Ro; Tue, 21 Jan 2020 10:04:56 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqUgTlkW8H4N0+zRVK4Lh0XAKfuxkEAgAAbnwCAAAWygIACz0CAgAGL1YCAAJh1gIAAqtOAgAAds4CAACVEAIAABDeAgABhkgA=
Date:   Tue, 21 Jan 2020 14:05:04 +0000
Message-ID: <20200121140456.GA12330@mellanox.com>
References: <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <2a324cec-2863-58f4-c58a-2414ee32c930@redhat.com>
 <20200121004047-mutt-send-email-mst@kernel.org>
 <b9ad744e-c4cd-82f9-f56a-1ecc185e9cd7@redhat.com>
 <20200121031506-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200121031506-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR10CA0034.namprd10.prod.outlook.com
 (2603:10b6:5:60::47) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.231.255.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4323a93c-c1aa-4c8f-1914-08d79e7aea08
x-ms-traffictypediagnostic: VI1PR05MB4512:|VI1PR05MB4512:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB45126D88F41B435995CCE018CF0D0@VI1PR05MB4512.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(199004)(189003)(478600001)(86362001)(4744005)(6666004)(81156014)(8676002)(8936002)(81166006)(9746002)(36756003)(66946007)(64756008)(66556008)(66446008)(66476007)(7416002)(2906002)(316002)(6916009)(186003)(71200400001)(5660300002)(4326008)(26005)(52116002)(9786002)(1076003)(33656002)(2616005)(54906003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4512;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b9wr4voTQi8EHbsFmyOVRI36YJ68qjUXsX4HcoSJ3oEe2K9tVrGVhyXcHEJ4+06+yEHgJa4tB23PlStzuFKmarAQ/jIuQresbfBIO1U7b/GMJzsIDoEBeID2JvtwraBu3FrkpdI1VOG4DTD/rANAJAu7ZdmkLzlxaT6l2iZPnyWuBkDZI+L8etckAQHTrHddblxKbORReWt1mmnzDgwbYfkPlkE93Cxd9UBY5tiEiFdRIi8iMi7RBWZ75Ai3WI/3A9/2Iuy+d1Z+74PklxKehQgR7ZLeBke9rWYYGJSS4a8hk9FoZZRHKTLH9AsJ61yla0lpDeuW2zwf0xlRKPGukOVPiRUpvnnLbK3a79WSqTMriC07/HUaRO+ryBaum7uT0ZzPgZW5lxqfszl6RpTismBk9enQP2IY1GoKU8gxV/iukoV3otZXYnkEUIIKIsU7/5LhBQjz7I+vnUhtmguRX3Oj5Wsc75sezCRGp6kWvFGyhxsH0l2ZU68RW5O0p2JX
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D0177E206524614887B01CF5999DBC5C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4323a93c-c1aa-4c8f-1914-08d79e7aea08
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 14:05:04.8790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PhDPNjeuPgSdzALfaPBLpYKFMJMTNqSrvv0GOjfaJIgAvmGpOiGRw+S01V93Mak39dG/uhd41Zf3nHyQOENjSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 03:15:43AM -0500, Michael S. Tsirkin wrote:
> > This sounds more flexible e.g driver may choose to implement static map=
ping
> > one through commit. But a question here, it looks to me this still requ=
ires
> > the DMA to be synced with at least commit here. Otherwise device may ge=
t DMA
> > fault? Or device is expected to be paused DMA during begin?
> >=20
> > Thanks
>=20
> For example, commit might switch one set of tables for another,
> without need to pause DMA.

I'm not aware of any hardware that can do something like this
completely atomically..

Any mapping change API has to be based around add/remove regions
without any active DMA (ie active DMA is a guest error the guest can
be crashed if it does this)

Jason
