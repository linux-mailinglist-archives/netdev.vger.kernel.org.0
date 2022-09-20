Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D115BEC68
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiITRyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiITRyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:54:23 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021025.outbound.protection.outlook.com [52.101.62.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7181EC73;
        Tue, 20 Sep 2022 10:54:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTv8FNVTa1CUx6pv7FPlh8gu7SlaIANO+zkmJ5IJa14YMmq9PX/Pqg530q1YHuq0wemOKKksOfTUjVMH2u1UjC25k6xW7XA/iMFUnDIb1oOsozbcgXhcncbG6OJ6dcpeAIaHTE9t1efDVcNWWMlKC4fFl0TH6FEyEXR+e1jNTIU5HSlJDw2JUDWKBaEPhiiiuQAnu+fdB4L/2+Ds+G/EUPfyzUUOdn9fqz4C98wbNllIgPzMRLIFZBjxhLqASc2mWicoOOBSdzGydufTHMufHh93WjgBJDyoiMY4lJqNey2LDbPRbTluPlBxWR2UXZSylnp12IqNx/co37gLaEAOUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zolGSOKEiKECZpkjH79KOkJgLllFwKpvcXij6JYK6AA=;
 b=S5JhS+qDtpW0qLRoGrOxdlLOPKAVcnpCOkUF1uxlMPF89vmz5XKdJ01twp7vBx8EMF9IOuy7d8zjScUSIspFEKY8nTSxuQfvE65YGAlIND2rOIgxXBR8c7W3iWRMJbPatkHLil+Z9n1jv0golfGY42ckRaHmfoVb1yxHfxh7wwMarx1efCnuhiM33CiGW+GVSTi3h4TKI38MMeDUGn3MYQ06cOw0nZde/5QweuZYZJcYYgJqM2rzMiyrQx8kBlcgr5G7soYQu8Do85Rl72QCinIGJfPlYUtT5CfWaXUQFtEYPppoD9TseDp/3XPXNV7cXWnaWnzpEyVpy3gfiXThkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zolGSOKEiKECZpkjH79KOkJgLllFwKpvcXij6JYK6AA=;
 b=cya50CaapvUtflwcyfy7FvEeUaIA1rIFgi0d1W5CcKmshw2EfTBoJM6DDSBjt76Y841wGfLTzJ5ySxvTAEZ7wUazgsnDD5h0qMKUbk9xbPeefZkGIh3QeqqBvqS8t4g3bc5nZsSQeds8UaBgrzYOHGpPX8CGU+mgSr1Js9R4u10=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by CY8PR21MB3801.namprd21.prod.outlook.com (2603:10b6:930:51::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.6; Tue, 20 Sep
 2022 17:54:19 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::b113:4857:420a:80e]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::b113:4857:420a:80e%4]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 17:54:19 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYvNF94FSrydPGS0egxnRZc1KiT63otVSw
Date:   Tue, 20 Sep 2022 17:54:19 +0000
Message-ID: <SA1PR21MB133500C46963854E242EC976BF4C9@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-13-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-13-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=82c64755-33ed-44a9-9f45-3e5b05469094;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T17:36:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|CY8PR21MB3801:EE_
x-ms-office365-filtering-correlation-id: db5c6e45-9870-467b-c473-08da9b312443
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bfviAuW5O+V2y2oBS9yIPwK/yxlduCbh4Ly5Hdgu19iN6gA9qvwnWEgJ+5UnCOt3rUJv/2ME8bHauFKikjepNqqQ1EQjnw0XNaCtF0BSGyn/K2D3nl9+Hy7ngs8DsaDkZGbi1nL8DcV4j+fSxp2o+wOs5hWLvM7NVhQOtFi7QPCgRRucrLE1yXlXGkInPW8Q8y1x/ceFaBoSlmCpmE1Ba6JgAyQ5qnYQtPMBtxbg/+pCJTwuJiy+DbfngxovrXWKCLudeeiRskhHJdXB77WmV7k4VugSb+tMMT0r9pLTXfl/usYbC+jQKwofk6eX5CpfWgKBM9Z7R1rzfoCk2DPJRaskM9UHAZSlRLZsqo4BXnQw2ppp6lPnXwVECBpCW2BMGxH33HO2xx5Bf0Hj6Ee2TnkrHYfoAGnGgDIGKmr5HkZdjefylF0w4iwYc2qAqLIE8MBOX/5/CVLVkbAb94/TqYCMCudcfGVE6ARGcrHsGDLTn8BTKGt+7U80LBb9gD4fPK/oU6fkGXI3WrfISRtmATXhLP338hbD2FdKF2A7wZOignosk2Z34rLRwEfTLs2GSvGgclCncMcKmUA1wj2CYw1XL8oBrOUAUUGtphDtzz3wNIMep1bNLB+Z/brGEHiZyCLmqCV37rhExyRd5LHUmpU0t04QE1ZY2OcDoDFqmHg5wvC9LVZp75A0iClusqiPJ07oyXzfw1u6ID0OCTYrw4dxRoTpt6vTOF0HjufLAxpd/SyWW5Xkf5yxTOarYFTGh4+vk27zh7BLZ8lDzxNYyrWAvyP9hXQbBqBZhcX/iMF/rsLe3NrbWrlrXRCo4etYHN7DMnFcL+Cef5x4FVrHIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(47530400004)(451199015)(6506007)(7696005)(53546011)(86362001)(41300700001)(52536014)(921005)(8936002)(26005)(66476007)(38070700005)(4326008)(66556008)(478600001)(66446008)(10290500003)(8676002)(33656002)(71200400001)(64756008)(110136005)(66946007)(76116006)(6636002)(54906003)(186003)(316002)(2906002)(8990500004)(122000001)(7416002)(9686003)(82950400001)(82960400001)(38100700002)(55016003)(5660300002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R+MigPyNbNzXXlM9MJ+V4RTkCJ9YcZeUHGyg9zG3HTyC6WwlUrlHZDqzCgNr?=
 =?us-ascii?Q?OVcOAoNZGy85rTNuT6ODLAgIqDJAavx8yQ1JpCsrstt7cQsmlY1h0lTu+x3H?=
 =?us-ascii?Q?/rGrwYkCoE+VaFqPk0VEcq+Wm09Pn3LnsoqFdJ8u9K0WIexOT7f74l7t5x2I?=
 =?us-ascii?Q?13HFfc5dDQ6ALPaq8zjU7YN/A09AC2wSCtmJd80qIOPBst5pZhLbg9Y8PUn/?=
 =?us-ascii?Q?uCEKwElFi+1tJ9F9ILuunC1n0iVPPHl+TrjHRE4by1/5nkBH/7RvyD5eTA9V?=
 =?us-ascii?Q?tHMZJfd30Q7T7aCFdfLvENuoVI0/z4UilxDewjx+x3zN+VaYtnLyIWyGa2Xm?=
 =?us-ascii?Q?TR37/nVoIzhJSP7zSoh6Kbkip5x+d8qgeqovg0xHSPxPKQtLgfHi0riFVBcT?=
 =?us-ascii?Q?o7onamueu5o91vD31Et8MDv56GtLsafx3pcWw0Ntsq3TaBUkLiomMixcNxDa?=
 =?us-ascii?Q?mksYQxHibUyLMyMsYnxcxaMDAhCFS0oe5X6qxDEf0ZdpBZd3H13Kr3JKYTfN?=
 =?us-ascii?Q?4SsfORDJbZuWja2fXJVzuB218RclrUXHdz5LoSFbcK3msdaPHdXWemEoKAeY?=
 =?us-ascii?Q?xCQoR2I/woQ2ZiJr7QDrD4AcZMyQiZ/Pt6vnGDsobJij8zTVk6vNXF7c4ftj?=
 =?us-ascii?Q?RbiEbg49EtTJ/EoTQjiFH59l1yLPQkLNGk9Vnt3KgfMWNj46+vDxoepydSB5?=
 =?us-ascii?Q?C8IBc3bqp6jplLCLZhXai6v7pWU0UCHDk691TtEQl6/lxIwRJZ3lUz6d0+kU?=
 =?us-ascii?Q?SSHgBJ0X0vi0HNtkXCJaLfU5v3SdZJw429VK92FuBN/oZXVo8DNhK4VsGgkB?=
 =?us-ascii?Q?tP0xjmTFue32RS3nnWNlCuX0ThMHkAqrIlLGxNDVTMCha0SMNYZpCbhVHYjf?=
 =?us-ascii?Q?HF681L7O6xXfcyGDSPYqdVPfpMO82bkkbgHQjOJX70nGT6iTi32razONRj9a?=
 =?us-ascii?Q?FuFSxW3kHvZQHMk5wt16jldkFaAoHGmm2I24y15PgPLO/xUSzIz09EpGAL7m?=
 =?us-ascii?Q?XOaNv3nYRLJ7i/1YpDAidMjNjQbsy64IqJJzcP34J2xZi1IILDvrnRxjc1y9?=
 =?us-ascii?Q?D69K1tykxzt62DSaFy0qHl8mBgIYSAABeTJS2P2/yGIv6EE6SRHjLNg0ddxr?=
 =?us-ascii?Q?pg7EllAFg2MOwtNWwUdUFpLSsClfPP9mXYqZfS1k1RSF1z9HrjNZVKHfbjxv?=
 =?us-ascii?Q?eRHMpVUWa8HLNk0W/xPsVVB/fJj65/FICitbTXdMoIijgIOewXsfVAk718zA?=
 =?us-ascii?Q?QVqyf5Eb92gRUD1yUmoxyCU8jJHXTWp7zo13lRRHyfuKTHVBBSfJ5sB7Qpz2?=
 =?us-ascii?Q?DHpL7nkIOp2eyqDq+GkXjR5/agUpzPJzLlb2t+Zmiwsek1lpe4UJWkBLDlgT?=
 =?us-ascii?Q?d1Alb1aeFw0tN2rxzycV6iL0pfLyU6qv7RqiELri1yD80SgqgsNlxBz2c9xD?=
 =?us-ascii?Q?hopNsxvO0Txsh3zhWWl9fv8+XHk7h6tGVkbX7gLHNwfM6XyboqRiZKr4nPG4?=
 =?us-ascii?Q?8JA5J5rHBZlaZLmUA6L4WHnCB+/q2YIe18bO4TLrXgTmB81aKnAAZZX8sJVf?=
 =?us-ascii?Q?xVIAQrVpD19Tudqf8kMXlP98RefLObTYYxf26O80?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db5c6e45-9870-467b-c473-08da9b312443
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 17:54:19.0157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3G1Vh+wyMjSejYrdp3LNG0Lis+s8WihNTVAHT/GWJI0jUzGKSCZ+sdsg1Z60EkJuJjip5AqWZWskl3XGi0j6Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR21MB3801
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 5:35 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> ...
> From: Long Li <longli@microsoft.com>
>=20
> Add a RDMA VF driver for Microsoft Azure Network Adapter (MANA).
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> ...

Reviewed-by: Dexuan Cui <decui@microsoft.com>

The patch looks good to me. Just a few small nitpicks (see the below).

> +static int mana_ib_probe(struct auxiliary_device *adev,
> +			 const struct auxiliary_device_id *id)
> +{
> +	struct mana_adev *madev =3D container_of(adev, struct mana_adev, adev);
> +	struct gdma_dev *mdev =3D madev->mdev;
> +	struct mana_context *mc;
> +	struct mana_ib_dev *dev;
> +	int ret =3D 0;

Small nitpick: the 'ret' doesn't have to be initialized to 0.

> +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> ib_umem *umem,
> +				 mana_handle_t *gdma_region, u64 page_sz)
> +{
> ...
> +
> +if (!err)
> +	return 0;

Please add a Tab character to the above 2 lines.
