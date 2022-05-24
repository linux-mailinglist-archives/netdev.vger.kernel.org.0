Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8B7533098
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbiEXSlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240398AbiEXSla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:41:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020019.outbound.protection.outlook.com [52.101.61.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4BD659B;
        Tue, 24 May 2022 11:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWg3AhoVEu5ZbBQz9lyLYA/Ks4HSA6DkXTv7L6YQp4qwxEOALh+3RjkSmwIDYbIHECT0wLbc0Mzl+RSYIFT81iAyZHXxit1VM7ZXMyKDXen64z+8O20GEMLpzOstMb5fC9kFtM5VtWpC+mJUbiMVC6kFqu009uG7PVQDwBAxCvcFjPsGhhocOgaLQixqsbf8k9kSsj9FSCd10sKl/d2N9NT9w9yAoZxQWElsw9OVc4Jc/P9xymwy0Arxp1jcUfNvP19sTDH35nZYiG+v1951JSLN+s00PtCbE16nFuwLDP+rELi2NX885mrFRS/M4grpkYKm33tjWWyJFjhx5FNxKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3qlcocSP8BUFlybByfjZ9ROwh9eluRA97ogmXDKZK8=;
 b=YCtIMRJrEnG0auH1w+74DsBRDxqSu534rf63MX7urAuo/AXGHGUDERQvWSMs2WbpY9zfHnoaiDFJIG2WE8tJ7YaKvGYZg88YRj3AYtvgZEnflROmLO5a+/nr7ky657//coJIXSl7BC/nxDfUi7/KtybdhhPO4IJg7coZC2Up8GSqv23EBeBFeFXjYZtNerwG9FHCCHpZwcN/IJ63qjEe8Ivj3M8iIYi8U9p3jNbrg5htmDPTT+xXbjXo9+VvXyv1So7BqP6hJUXCXYR+91Z1Du0uJIyovuRfWRCO/YbDWLmJ0Fb5U4okj9SGQAlhxhAu+34l7Er0kP08gIMENuVyjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3qlcocSP8BUFlybByfjZ9ROwh9eluRA97ogmXDKZK8=;
 b=FWgHRUeazRBf+MRxS4yIXGg5MJcws5PZ/MyG32UUIPbcQmWzfFV2CE8xK4AEHx2WEbTGYa0wJzsgmkVvyApT0Ufw8FrZtoWMkFUx5+6rh+jomRGQGCY8GjbpeNMTp/Zlg2X4LaH8GxbTgHgXJ9J6BbRT0HHDwMhL9rOW03gVcJg=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by BY5PR21MB1507.namprd21.prod.outlook.com (2603:10b6:a03:231::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.5; Tue, 24 May
 2022 18:41:26 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%7]) with mapi id 15.20.5293.007; Tue, 24 May 2022
 18:41:26 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v2 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v2 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYb0wvDWXrk3scZU2/WA8c5XDlf60uEYQAgABGBHA=
Date:   Tue, 24 May 2022 18:41:25 +0000
Message-ID: <PH7PR21MB3263ABDFC1425CD3DC39F05DCED79@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1653382572-14788-1-git-send-email-longli@linuxonhyperv.com>
 <1653382572-14788-13-git-send-email-longli@linuxonhyperv.com>
 <20220524141044.GA2666396@nvidia.com>
In-Reply-To: <20220524141044.GA2666396@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=71dd7b9e-736d-4b5d-859b-26ed593c0621;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-24T18:21:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f276129e-d1ba-46c3-52a3-08da3db5021f
x-ms-traffictypediagnostic: BY5PR21MB1507:EE_
x-microsoft-antispam-prvs: <BY5PR21MB1507E601291BAAACA8F50B1FCED79@BY5PR21MB1507.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XbSKq2ZQnQ0Jeo9knZILjd2QViaz0P1QsKS44g/LcpPVwpB+YSSGCNAHIwQTPAknLJlWAk2YF2wCrLwyehlQpiceMnMW51sqUbrMXc+HvcZjUsoyuBi2cv/xBLQ9Yk48Zn+XvSqlEEWBaxsx2uZuao+7jsM3DvM2c1stWj7TZHTGgeX/Skqyuzf2yFjjJGUPnlmYnZfDqXTTaDy7lokDY1i8l+DvHxUMfdVfkuQPaysnMPoUjJQy50VsSOibq0NAALUCTQguWpIATU0odrwrECPbOpwQQRLdYt9XaTqlZL/nAdv3F8+QdvYz0bht9jHZxiOmviV1k2TVTxrxIRgDwM3ZOP9SSlqP8DvBcvCdiRXEDoXZiSm2gJUBsd4wkS6c+wy7jVlt8MJx7E6FFjdAs5HyRwCwNb8aXh42fKR5RndU7e8ANxx5nBxqsV+P0O/BNlCAQHSPfvuGz4DGcTA+fUkY0CmdKS2AWP3apTGhW/2+4BdEOCkmYW2nqba12ptvIZbvzqSCT/0uigPKM9w/Lfzt/u4q4mdwqQ//0pJG/Nr0Jlz4S2zgi77VsDi2k+zEmoxa5ErHqk2/IVCYafyHeCjgZ1Bt6Dhh3iW6qhjhZ+gTQ8QwomKK0cLxFRUTNnNbDioo7HxZI3pJRYCFmgoek2cYod+DfzMUc+cPGA3WFsCaJXTxcEP29KZj7iOUYhWfa7goUXkGAxiu8YvwpPFFbnnabop1cJf53ZRx/0fA6X7O/D2k3ahPtqUYQj7gB2uB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(47530400004)(451199009)(122000001)(508600001)(82950400001)(38070700005)(10290500003)(26005)(8990500004)(5660300002)(71200400001)(4326008)(55016003)(7696005)(33656002)(9686003)(6506007)(82960400001)(66946007)(86362001)(8676002)(52536014)(7416002)(316002)(4744005)(8936002)(76116006)(6916009)(54906003)(66446008)(64756008)(2906002)(38100700002)(66476007)(66556008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W+IWmT67/TgNLywgR47oeJO5O27xy04Z1ek/BTCn+ja/LbDYI/n6Lxg3bFp/?=
 =?us-ascii?Q?PfMaxABU9anwxZ0/oobJn4CneaDUr0y0BREWnVwM6/qQOiO8MGD524jek5VQ?=
 =?us-ascii?Q?xKYmMngL9+Vu8zxrhPHJ43CAD7rulqwWP+WOMWMT2DlzPYo2uQgITgYapEc2?=
 =?us-ascii?Q?X6KRtMbvTWiyvCT4K72b3q0MloVwqS0MJvDAdwjQm5NrdY/+0P4gLorEGzuY?=
 =?us-ascii?Q?G0juY2Bhz7DWxBQDe1SJS69CNQC6JDnHsN1nudBiSHJ8gpen5jod51d2bMbx?=
 =?us-ascii?Q?XeikG9RvHcLwXCyP+EBUn3J/92JFPb+Jw3gEQZpGLVf6OPEr65QKAsokQ0L8?=
 =?us-ascii?Q?tBJuzi1yRoS2ajuZw8YiiiecyjduqhweO73FntAAdjaye1KwIGgiSNGapmio?=
 =?us-ascii?Q?ZM9vCs8qzYWHzQ8hTgLI8tPK6gaOdd1Owv2LTA3pf/9LO8kKGWJZd1hkaal7?=
 =?us-ascii?Q?O4kStIYnRbrtIR8EGHQ9SaeCxjoPopG1BBUGXh5jCeFjouL2p5dEap+1Wb0h?=
 =?us-ascii?Q?QXgQpDl8Lr/pYL6wb9TpCnw2UmTatHzAKb35BJBhUwDQGgb3vWw2SjirYt4O?=
 =?us-ascii?Q?3+PsTIiX9E0lfP6C8lOmfBfz52Eo2/sdXinslSttJwiDbZI9jBK4ip3Dsu+G?=
 =?us-ascii?Q?6DY3DQCoysUODPAiK5G6iczw0obN7LJwh7pEkkukIxyG/bXIfhthyWndOOT9?=
 =?us-ascii?Q?9lqATGRTq5ZgiZ3Mc7Aeaz5Hv2kU8P6cY3la4C6xPzmgxU0Np03UexZXRH4H?=
 =?us-ascii?Q?B/eLKDDiCxdDrvu0ebTSdbr3xXFU7ggJXysVHfH7ayvd71nJNYrAKCOZoh/c?=
 =?us-ascii?Q?aWY1GIysVOa5FottRTnGnrKFLtqwY+qOV0EW+8eX5txe80tta1+sjVSGAY3j?=
 =?us-ascii?Q?65wox7GFCAogqeFIr5vyDavYpjjpF1BDNWcTCsSVQtAPJHqJBKaqOzOUnzBb?=
 =?us-ascii?Q?B15E1E5+WPkIY/4t/HmEsVONdpeyONseI2ZgVOKZiTRCZ1xQ0TEbPUwf0jfw?=
 =?us-ascii?Q?RMk2wx/1L9xa6ypLX26hlgr3oweR08Cx3szoVCa5P4OMLdCEUazvp8N6V2Rm?=
 =?us-ascii?Q?oYJ8D5vDodSJ6VXdV2118vg72ZF83nr49CajNQv8DPTab58wuuBsZAkYzvot?=
 =?us-ascii?Q?B7yl9CYEScKusE8P6GuBNjlnpLisvFZp3Ygj6drr5u7lIxCdlGSxcPsIk003?=
 =?us-ascii?Q?/JpdsgUxMPu9jxSovbif0rIyBvCnzAg8+iRsakTXU//3WdXc2soUN6Omvm2q?=
 =?us-ascii?Q?zbhfTRyTvLjskYkScd/1w6Be6Sg+KSCKAZLeGaE/UpMKOe+6sAMU/oXUK+qA?=
 =?us-ascii?Q?CN4HLQN7oRvPPSUd9MibxRZyT1YrRxKcPGkszN7WA8+XUnRbhkk0Zct7VhAi?=
 =?us-ascii?Q?SrpCAKvrqQndPTnElmH/IuzQEniXgpCIv/6H9TrX6H22fTAPLP2oWyVQ73n/?=
 =?us-ascii?Q?QfOKj1WEnjxMmPvoTQ1bbRvpvPq6n0JDPhOlXDgjB6HIhcQsWNr3qZRpSA1O?=
 =?us-ascii?Q?2UL3SN2PGmp4nI4mMUESbuN8MD5GC1Ve0JTcnuI7myKQFSEBnoNQxw/L+QpU?=
 =?us-ascii?Q?m5fS9BFGYixAQBY+XUDPX/nKoqMaog1pgxGwjnSZRmdbnitoQmdofQ2oBHRC?=
 =?us-ascii?Q?whcbYLgQeMb0x3upcUbiE9Zr9uDZH4SWVNyz2ph7mFw0Ol5gpQ+9zGtfodOu?=
 =?us-ascii?Q?LHh/QAe2zuvUjxmuvMvlZSlrW6pK/11FetpiKFRonDLpCuOSAkTrBbKeCzwd?=
 =?us-ascii?Q?jNszvnEgfA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f276129e-d1ba-46c3-52a3-08da3db5021f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 18:41:26.0079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 41FwmvkH+9D1iICZazFt9JW9UPQ+ogAWCIBd3Qtumn/yZapNak0NjJjJLsBlmYduzleV9nKiWOnx8s46vW8HEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1507
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v2 12/12] RDMA/mana_ib: Add a driver for Microsoft
> Azure Network Adapter
>=20
> On Tue, May 24, 2022 at 01:56:12AM -0700, longli@linuxonhyperv.com wrote:
> > +struct mana_ib_qp {
> > +	struct ib_qp ibqp;
> > +
> > +	// Send queue info
> > +	struct ib_umem *sq_umem;
> > +	int sqe;
> > +	u64 sq_gdma_region;
> > +	u64 sq_id;
>=20
> There are still lots of coding style violations. Can you get someone from
> Microsoft to help you make patches in the expected form?

I'm sorry, I will fix all the style issues. clang-format and checkpatch.pl =
didn't catch those.

Long

>=20
> Also, please don't repost until the next rc1.
>=20
> Thanks,
> Jason
