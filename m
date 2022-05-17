Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDE652AC39
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244598AbiEQTtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiEQTtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:49:17 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020015.outbound.protection.outlook.com [52.101.61.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7F4381A2;
        Tue, 17 May 2022 12:49:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0rKyCwBXNF+ozKP9xAtL1YgT9OSqmhgXRLKziFU2Am5bDh8bYcVa9wRCtFVpjVd3u4a0ioqQfL+16S3Uo9z1y6SyJzBtn6wLvk1+xMt6TEN56zObMV56eI4TayxshdbrzPJcgREexSFmHWF71tnSV/ZDQTx3f4FVOSKWCtbgE0/1qMuYMtQp9gSjO9jkyLDt5vP9JFJsV/HdPIds4TfqG1sCgEd+fNfOLs2J687vyzWfSM0XyDeg16vNWFoVMfMHhwR/YpC5b/OCAD/s9ccKLJmNJFMdPVLBkFMPWjOCW2lRUbrTJ3CSe3+uHCByhdWMq6LErc69T7rUxS+C5m82A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBhSI2alPmNDXkgJ9AMiTTEYSntE0QE8YAt1B9BUfMk=;
 b=RsZcsfMRitzZGrFlEcFvb3tbCVq43mvC6Cpkqf5JzcFUJ0ycr+PQKJOcAxId+c7ig9Kpl714wE7ztDrsb5ZvZwYRW/wYYyq/EUCKmBGEobFLMc9CPGhqPSYfCjDWPL16H4ZVf5K5UGj4rFFTQnB43HS5A2wYCIaTDol04XYQU/yQk1jgsik5Ys4+S5hG9lrrvfCPA5dvKAC8JC8r4zjAghuReT2Kmgy4vAYoH86RHoKA6WjuYlp93NbAUTeMioY7EZTwLyAjdm1zhwNP76qaBP0z7chhXsg+GVMroZkqupqQwwRyyLeTDq9vfswcLVuCJnlCf2g1E0viaPKqp1DqrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBhSI2alPmNDXkgJ9AMiTTEYSntE0QE8YAt1B9BUfMk=;
 b=X/N0m+VTY0rgTXa5JmL7il/bMPeSH24aOJAKO4MK8YyDXz0j06IBtIlQq8RkjuJoUAEwziQ82b7StnCsX0AriHKZPIRzUsR+EBZ7w9PIa571WSKytUlgAdSXUnbavG0pBcj8sKX/hQFULk96oPtdkqroCq4+SDxupRHQVUTVdws=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by MN2PR21MB1213.namprd21.prod.outlook.com (2603:10b6:208:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.3; Tue, 17 May
 2022 19:34:21 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%5]) with mapi id 15.20.5293.001; Tue, 17 May 2022
 19:34:21 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 09/12] net: mana: Move header files to a common location
Thread-Topic: [PATCH 09/12] net: mana: Move header files to a common location
Thread-Index: AQHYac0tYvgSyCBQfkiV4OLM/1jNT60jKvqAgABLVCA=
Date:   Tue, 17 May 2022 19:34:21 +0000
Message-ID: <PH7PR21MB3263114D9D57A3F385FCA6EBCECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-10-git-send-email-longli@linuxonhyperv.com>
 <20220517150339.GI63055@ziepe.ca>
In-Reply-To: <20220517150339.GI63055@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=21546c42-6ca9-4871-afcf-101c6a311164;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-17T19:33:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d66ed57-bb25-43df-077d-08da383c3ddc
x-ms-traffictypediagnostic: MN2PR21MB1213:EE_
x-microsoft-antispam-prvs: <MN2PR21MB12136628F673410FF5EC0463CECE9@MN2PR21MB1213.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3bDf6YsucCOMrxGu3ObhjGmjIBi2o+DHCRarzbfJcpMq/a3DCnVODzw3hnbmB8JoHUIOf3/iyRtRCI6yfk/b0sWt2hN7tUPGZdjjI006SHAmB8vCiQjKVb/PE/KjAGhOVzqERGdqqkMvjckkMT41GtXc0dWykrSOHgwQKzqE2fZA//g2VwJURBVFLU2z1tlWCt8Y36ddMdQQtH/G/GyuK+1ezvmeov90Rzrf/l9mDlbOsapnrO1k5Yfvj05EVyR41rK/T81PPXk5s4PlRvTVhUCAXs/jw3jjxmf2JajR6EwwiV91bcglboBq6manQkmJDJUjqUdo6eVf/TcYFNHWyjn5cF7jm7x+kigkNCzrtByDxIrSEQwpU7cMrfrxEgqPRalBU8m01JsBSPvZPE+PzbvAM/ORfuzLPOcQkNJ5iCO7WZg8ycyw/rzOl9EjOj22j7/uEgVhil7AVRUCFWpKSQlSRRelfky1U4dXoxJaIthipHFpLUD44n1jDjSuL+E22CRrNsQq27G0pQpDKb34t6B3/CGjcjE/pugH2JcdRWmyxBEwEj3XBfLrs/Sj+HEEWZRLQ823Sa3c2M9LjfQgjgmUGosBXZDDpMQ3UeztMdjmmf1RlSe6KFiD7udcScHNPNp5eiQRO5YZYszL14UQIRW7nfLJFA8tzNaC5OuLeYa6OZpv+J2agdPgJSe3zWx+AoVVag7FrWccGqhfKLv+iXa9gVajgT+xTDHecZfiFKdNN4p4BiUmdX1x78poPtE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(66476007)(9686003)(5660300002)(6506007)(10290500003)(8990500004)(66946007)(66556008)(64756008)(7416002)(66446008)(4326008)(8676002)(76116006)(8936002)(33656002)(186003)(7696005)(83380400001)(2906002)(86362001)(55016003)(508600001)(71200400001)(52536014)(38070700005)(38100700002)(54906003)(6916009)(82950400001)(82960400001)(122000001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SFQH4vs5Owmg35XreeLASvC3jrP/bPIbW0raChsA8L7aXK3+MQE1JsKMVuYn?=
 =?us-ascii?Q?x29pzYeps/JPTl5LkgNMYiHM0RX6Krl3ez6j1ewT6yqAT+zypIO2bgvMp70I?=
 =?us-ascii?Q?JONZJ5aDOpW9FErs76zVXGQ8WKj1d9cCxK8DU5Jnelkq1VLvvccCvbb+jUcd?=
 =?us-ascii?Q?XQiKsm35obv3AJTOdUPEoTWSUV1jMBu0aPbpBLA5U7F0xA0fPLZ4IyXFR1nS?=
 =?us-ascii?Q?GLfrX3V6uv+I3Bd30nnxWfIv9NVYJLisatCIH/aOVxo136RqI+I/9DGgcEER?=
 =?us-ascii?Q?AXVyGkjUpotJGUKrl7kiilkcKI1orOFnJbKEzz+P94fRcehl3hu650wDkfl4?=
 =?us-ascii?Q?n9a8dJEkwVXfSw+EackeVk1bOGkkitSAc6k+C1g7+l27Ho+OUi3EjsAIbSMQ?=
 =?us-ascii?Q?WOZyQ7Uyd4F9a7vn59c6sttKa1utSXVOU59KGjNCC1m2p/KmvRTOebhS5N/J?=
 =?us-ascii?Q?uywi8GCO8qa4mvktxBpaYNBVok8Q0WuamqYxRWRptIwAr+t4KdwqzSCgsvjo?=
 =?us-ascii?Q?JANnH53Nfz02IaBrQKlQcud7CEO3dZSDi9eIVTy+PDBn3XQRTGZFd5T6nRo1?=
 =?us-ascii?Q?JTA+N2Gy32Wp2xCFgYKQQWga7JqVPko2MCoOcEa1+GOaf6TUaWaoqqwqmOmn?=
 =?us-ascii?Q?XrcYGe2jhTe4wwpsXmgyX/yKC9BqwqWacweTNnyC3HUVvTzPc/voKWJqbp4I?=
 =?us-ascii?Q?9xcZh4UA0S2x+QL1qpFiBYlSKbJBhyinwT1/J/LURxcSmCggaG9lPFYjgwu8?=
 =?us-ascii?Q?clKcNXO2YV4ZN9PJPGTzIeTgzwfT9PLMkG6m6XcNW+eszq+pLzuRWjHIyg4F?=
 =?us-ascii?Q?Q+8o04KFsbRDRkiexuVPhZ+SlOaz200kCA3Ba/YgNFkUO+EOQ6S7I1sjXwlY?=
 =?us-ascii?Q?UTUtLnUio+RQhj2P6tU61X/zRBW99m3GjXzOgrsok9YmP6mxGtXF5aQkbsoo?=
 =?us-ascii?Q?gus0wO/uLENsekLovGS8bY9h511Zgh+aJdUlPzOy7ZiEttHQWTF/03XdYb5z?=
 =?us-ascii?Q?XMV2MZ9k6RWNR1N8TwvTPXuqH9jz4gULAkLBrDnAkgiQhF6fur2EE60kTwhg?=
 =?us-ascii?Q?RXcKLl/xSjakZStXWuWfC4Wn5gw8H3PLvibv9ua0peC9OcVSl7JMXTkcabOX?=
 =?us-ascii?Q?1Vnp00VEVApCGiu52aT+tPjVjEv+ojYI3ekuO+7P3nLhAZBnZEfQKK/viurG?=
 =?us-ascii?Q?kY4X6bFnvHe3D8BSXXI1LxY/oKsnjN0vUp+pjXB3MkW7bjgmRpV9Z0vd2uBn?=
 =?us-ascii?Q?x8E14L3y26yWtRE3LGU+9RwXzZaUzRzHLB6xxmbD+Vn5Dc3TiqJrpvOgj5Qt?=
 =?us-ascii?Q?L7vQYNFlvVig1riL4qTThwVU7nKAgKSE+J70dEKnzg7kyrmjTfOwRH7J/Qc+?=
 =?us-ascii?Q?icOL/BTT9QVRu5T5oKfR30jCrAxgQ/JKaOuzaYDMirLr/61ZWSK7nNZzmfF7?=
 =?us-ascii?Q?86h8FfcDixchQeROQRSRUs/QEDQakuBc/bAixMa5EguN5jeCANE56rmXdevY?=
 =?us-ascii?Q?EUFWohLkc/VA1qjWFq/LuXSZFUd/cNT5+6Tx0dwOZh9O5ybXtzPBbNCfrw56?=
 =?us-ascii?Q?d1ALi+1f3V9hYtEwntqSxXPyyCF9Jos8KChXOTNGQxQp7KfM3N6aD2f9A/tK?=
 =?us-ascii?Q?FLbPr9SADF85WdUAGipvzLy5s3oA47Ts9mxkWj/tZ6u5PqqiEITLo0VETed+?=
 =?us-ascii?Q?rEE4F9sqsLXSNpRvStjEks8ClBTcGqmEFmSeRsg4CvcSQkFITC0NyNhLfn6u?=
 =?us-ascii?Q?U/cuMzrs9A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d66ed57-bb25-43df-077d-08da383c3ddc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 19:34:21.2620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jvzjh0VF3QLQAA4qvrLrk9fC3IZ8XIic9Kv+00k3xcKZgnA62WpgyK67899yppNXsFYc3yK5oxiuJmZxGjkaMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1213
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 09/12] net: mana: Move header files to a common locat=
ion
>=20
> On Tue, May 17, 2022 at 02:04:33AM -0700, longli@linuxonhyperv.com wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > In preparation to add MANA RDMA driver, move all the required header
> > files to a common location for use by both Ethernet and RDMA drivers.
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
> > ---
> >  MAINTAINERS                                                   | 1 +
> >  drivers/net/ethernet/microsoft/mana/gdma_main.c               | 2 +-
> >  drivers/net/ethernet/microsoft/mana/hw_channel.c              | 4 ++--
> >  drivers/net/ethernet/microsoft/mana/mana_bpf.c                | 2 +-
> >  drivers/net/ethernet/microsoft/mana/mana_en.c                 | 2 +-
> >  drivers/net/ethernet/microsoft/mana/mana_ethtool.c            | 2 +-
> >  drivers/net/ethernet/microsoft/mana/shm_channel.c             | 2 +-
> >  {drivers/net/ethernet/microsoft =3D> include/linux}/mana/gdma.h | 0
> >  .../ethernet/microsoft =3D> include/linux}/mana/hw_channel.h    | 0
> >  {drivers/net/ethernet/microsoft =3D> include/linux}/mana/mana.h | 0
> >  .../ethernet/microsoft =3D> include/linux}/mana/shm_channel.h   | 0
> >  11 files changed, 8 insertions(+), 7 deletions(-)  rename
> > {drivers/net/ethernet/microsoft =3D> include/linux}/mana/gdma.h (100%)
> > rename {drivers/net/ethernet/microsoft =3D>
> > include/linux}/mana/hw_channel.h (100%)  rename
> > {drivers/net/ethernet/microsoft =3D> include/linux}/mana/mana.h (100%)
> > rename {drivers/net/ethernet/microsoft =3D>
> > include/linux}/mana/shm_channel.h (100%)
>=20
> I know mlx5 did it like this, but I wonder if include/net is more appropr=
iate?
>=20
> Or maybe include/aux/?

I can move the header files to include/net/mana, if that sounds okay and no=
 objection to doing that.

Long

>=20
> Jason
