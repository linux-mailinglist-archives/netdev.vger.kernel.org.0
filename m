Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11F8572CA1
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 06:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbiGMEcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 00:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiGMEcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 00:32:50 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021020.outbound.protection.outlook.com [52.101.62.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726412A9;
        Tue, 12 Jul 2022 21:32:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENiNipzqqg2HFrr3LVWt2+WfhhsmpW1Y4/G9bSexXSGrjfemWBpH1esfZjyRZx74l9jZz+AL1JwGAHnKvL24gk7Zm2TXDfDlSp4+iBsHiVerq34Y6xPvCZcAkuLsK7yklgvexAdwBJ2Eh419GcAM6M0DyxkpMdY15oVN+lsT4XMQhN/h7eZOPvM5AzmGwJQ4hMX+ibSASL3SFtXyVn+jdjubuezooOIUsRYGF530V2fK0MmvZiQLXzhMrrVYzMfNvyKTkJfWo69bBqfv4A8hd+JBgXO+FbSHt8Vxau8HEz2CjSyMb9Bz44oG5olbHEL2mi8+TWERQpxR6mExviXYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnvrqGolIKhkyFU/+1429pYZ3Ll6bZOZl/ay4Abj/8k=;
 b=AFp1KR/KFmW6ZgWlTlURmBwQmfkHhXUYoSZPwb5JmDPWe9kg8SS6R4hdIYQ/zLiu7w8vvicZ2Oet95vU3euVHRxLPLUXzs41hLVG8o2NWmDMxJ5L8p7PzUqiqOAJsxGT2woi4I6IjqIxF2Zd55deRY9tFhE8Bhuz73HXvRgdO4aiF5oyZOhJPJCfj6UE8ad52xWzfd9Y6pxdOLk5DTsDWf2KKJhci/H4jm06YqE/sV/KjtX2cGfvKC4vqLO79fccAZ3TPWESyjfhwgfJitqeRW4EdAdHGrVLEBgjXL/RR9CgQjHgS3SxUeuBwTYQ7IDvsIelFgmUf/vvsg9vLTi2yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnvrqGolIKhkyFU/+1429pYZ3Ll6bZOZl/ay4Abj/8k=;
 b=KPT6AnSHSOOV0JjUc4uaoduyNIVYBX+dKYgqlkr93Dui2QNvhrGeFFiwz/XbP6TPWLzelL4G8EQzjx9q4/14PeDO7ybYydCgKKDDMhpP3YBOM+IE2y8BQwDAL88AxIWSKNUlYzmodI9S21ksFLU7bJdvJess3t5wCZ3t+rLTQdE=
Received: from BL1PR21MB3283.namprd21.prod.outlook.com (2603:10b6:208:39b::8)
 by SJ1PR21MB3696.namprd21.prod.outlook.com (2603:10b6:a03:454::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.3; Wed, 13 Jul
 2022 04:32:46 +0000
Received: from BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::b1e4:5093:ad3b:fdcb]) by BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::b1e4:5093:ad3b:fdcb%5]) with mapi id 15.20.5458.005; Wed, 13 Jul 2022
 04:32:46 +0000
From:   Ajay Sharma <sharmaajay@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Subject: RE: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYlMeDfat4gFEZJUeMQjfeJ2W3ea17uHjg
Date:   Wed, 13 Jul 2022 04:32:46 +0000
Message-ID: <BL1PR21MB328334421DE2FB3B33176646D6899@BL1PR21MB3283.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB1327827B0EA68876717F0699BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
In-Reply-To: <SN6PR2101MB1327827B0EA68876717F0699BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=37fbf502-6d30-442e-a817-37730b6e8ac6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-11T01:33:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afd89a92-eae6-4500-40ab-08da6488bc69
x-ms-traffictypediagnostic: SJ1PR21MB3696:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5gAX6L7QEbpHff5XG8tOgyzMXabkzor6ULCNP6gsOA54r2JGYCtkU9F5GZmHtg/BJypljR7yLOmLMzR4RITtV+j7wESVDS9NiQTsPvykygUXq/Meen64Xbop3GIQtq8Hnlqae1/PJ+0VJgzvtMhEeOhWSGxiL+jzrdG/tyOHohhseLm7qHrC6YPlS3r+iDds6EHH5uQp5+QIWhnISfDAOjglxm6qiV8JOMjQeULEaabIMO3UYpIX7YAXUXLop3RUE8ibXE+wiks1u0TjEuTMegJkOqU2XmYy9Hnx+Zmobj2U9kugAHg5NNizJKBFEQ3YiO4brewM8ZcE/LGlh26DLhsz6/pHa47cM1n74AJ+zgN9IVnqEmmCUuZfw/7uLUGKZ6ZKPSNNEi/xxZNEMMcDee3CZ93AWNT+so6Tl54M3NFNLpqYctidBbcjAlyZOgNp9WE68I+JrbD0zCPrMfo+W+dC4OMTSnBudGBti1JYuX+vGt3GMto3QwRQuvV/LpAyn5giNJ7G/i5GCvqGqRcbWUWvEEyEfRO1cg1/Ad7LeRaA+qw97ISozS1yq2ptFL0vq20ZjN6cBPipDNvhII+g6b+PScx7gkOAIGgFloaJ/+9+6wwfSiDU8CYg7GuFRk0afkRTPGpP3Qv5BLZ1VLU5l4MdOKgwzGFdyq0ALxvuu0LF27Bwr5Jb9eOOMIXex30yZ6CF4imR5ZiUO9OH05zeWqj06BJmU3WlLMX5qFvBtUMvktM1Etu7rWk+hOj/17AwaaxnN7FeiwfhanhkTA5zFcUM+/6mIBePsawCo/1VzF1PtQ+jArRTun44OXWBaWY1qmpAspKBHCiwChN3U94EJFuMTduWf+c6qMQArDWvFMJa/o5XhfshKHUiaN/0M4/X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3283.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(47530400004)(451199009)(55016003)(38070700005)(8676002)(66946007)(316002)(110136005)(64756008)(7696005)(82950400001)(76116006)(9686003)(4326008)(107886003)(8936002)(6506007)(54906003)(86362001)(38100700002)(66556008)(71200400001)(82960400001)(66476007)(41300700001)(10290500003)(186003)(66446008)(53546011)(5660300002)(921005)(122000001)(33656002)(2906002)(83380400001)(52536014)(8990500004)(7416002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZkgXlnD3G+zv8SvqGHBLaDnJo3GL8byKlpvAg5l29UxhPF40QpkHV3gEmK4+?=
 =?us-ascii?Q?vEplHLEvpkUHoN4NsKT1PHa8vIdfVHv/M4p1oebxszvOgOqlUdtFNRHLjqL8?=
 =?us-ascii?Q?4hc/e8HNCJb/0sIt7pxzkMHS4XaNVkhOsgeDYYoS32gjcIcQarmxn1/xYGzV?=
 =?us-ascii?Q?8b1lEbUf+UdKW4nZlROWWAjdbJISeyNvbi9Xhi2M7OaB4+scpzAjWH87laee?=
 =?us-ascii?Q?b6LLYqu8smQLwZhKzDc8YEV9Lumixnxdi1QXRO1PRXzI2ofBl5913HvXrZuZ?=
 =?us-ascii?Q?2P1OGAhY9gV76lr486JNE5swkzpJZIWVwGo7NSqVZof9x/Ksebbez6RTp780?=
 =?us-ascii?Q?O0uVDc7CPts9ZI+gKv1irgd6jr6PG/AgUn6bI5DR1bgWa7dOIwZwnL1F3qFW?=
 =?us-ascii?Q?QUQ7EkIKGCcFS0QnjLOTHO3NChNl0fEwLqDIl3D0Dl5dhejo7BEFAg5XpG8E?=
 =?us-ascii?Q?ovFgAYivoOkQj4pFh9wnFclVt6SmwJtGx1k9Sea4mpFbx7tGmDvQRkTHA72T?=
 =?us-ascii?Q?NDZb/xbga9d/aIoQW6X1RbMG5+knM5WqbouWhFOCqR2yiO2+LVNBsuNZfd6o?=
 =?us-ascii?Q?cjeHBNalPNVXnO2E4MlqJB8+UvdGLqO645pG4YjOJrLjsI8nxmRpktVstyc3?=
 =?us-ascii?Q?90MfZrx0gaCW+XNdsc6bJcNKZZFiuiXYM4D/vNpUEI5Hbn3QcOK2cxLyTXtM?=
 =?us-ascii?Q?x1JUibnJEabvUF/FonBE55lHzkeB/52kiqPKTgS8tqpWkUv0xsARpqZhDv53?=
 =?us-ascii?Q?usdgWDfC/4pFufyl7K3hoBJSo+eKDPl5xSGLWtBN6tJu/M7Z1oKKnv+Zxq0H?=
 =?us-ascii?Q?/HE4rTZ29ZZuTsLtxASIi7IcaCpZJYvvtMcxCdLOkdjnz2KN3VO9iCGFgwjf?=
 =?us-ascii?Q?rC7HEbLP6DonZCVghR6DDJvJ2tbSGHFgbsvfi8A60TWCN7hXg2Sfmte2P8Tt?=
 =?us-ascii?Q?6qolJHpIXlL14bDKAHzOTq/AxnZ80rV8lmJptr/4MVIr55jj/u7p2GccaDeZ?=
 =?us-ascii?Q?jZHNAHmwahcgUnCQDsHJs9SHNJbfWonqwS0BF6ostAkdpXhad4jingVNMuu+?=
 =?us-ascii?Q?Dnnm+l2juayP7XrRzUjP1rBFmQoZhJ4ELpCZ5tRw0xFQVqijIi9JkBrJmvp3?=
 =?us-ascii?Q?FhQaLla4HMULncrTR5LT8oxdyUuS1NDax7vmyec/xDkKM1FnYyDhFfyNkg7M?=
 =?us-ascii?Q?T7/G71wYCrR9MUofZNBQZh2ULX+OBLMSQUyIAhrE2L2rSKePr1Q9ElT1BWI+?=
 =?us-ascii?Q?hpAr6ddVx9jHQzwxmR897Aj97PlaBx3HXBt93xWXA30ueYc+9XnHYcYuUC1M?=
 =?us-ascii?Q?oJUlSEIB76XT9RNT/AS8fJif/BWwBPD00kEndIPfkHbQR+5I+1wHuj5xtGHM?=
 =?us-ascii?Q?EZ4ERl7C+eWqMwS7r39xuqBYE1q2r/7mpnoz1ZwsFp8u24J+HVmFSxC8PYsX?=
 =?us-ascii?Q?jZYjqHw3chPbN1ontJhbGc9a3914q5/NZfD2G3X1efcgTmLskYudBgkg1ydU?=
 =?us-ascii?Q?f8qR29IgVhYXqd0w+YEyPkHjguuyS+gkUaPMgutg/dMykt4zf3OI5FULoG07?=
 =?us-ascii?Q?bN2SMVMRFWHJcDFPtteihOrmNnfA5on9vNg+w9Bv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3283.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd89a92-eae6-4500-40ab-08da6488bc69
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 04:32:46.5065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2myIm9T5Izx1oeCmxBbFsa/3SiKpZe2bS2JuZt/Ck1GCJBrRtot69cvanLA3OE3+Ze7iNf9CpzGFw839QFwLb/JN7dQqPK9DjobeWmBSUBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3696
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see comments inline=20

-----Original Message-----
From: Dexuan Cui <decui@microsoft.com>=20
Sent: Sunday, July 10, 2022 8:43 PM
To: Long Li <longli@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Haiy=
ang Zhang <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.c=
om>; Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; J=
akub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason Gun=
thorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>; edumazet@google.c=
om; shiraz.saleem@intel.com; Ajay Sharma <sharmaajay@microsoft.com>
Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger=
.kernel.org; linux-rdma@vger.kernel.org
Subject: RE: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azur=
e Network Adapter

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM ...
> +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> ib_umem *umem,
> +				 mana_handle_t *gdma_region, u64 page_sz) {  ...
> +	err =3D mana_gd_send_request(gc, create_req_msg_size, create_req,
> +				   sizeof(create_resp), &create_resp);
> +	kfree(create_req);
> +
> +	if (err || create_resp.hdr.status) {
> +		ibdev_err(&dev->ib_dev,
> +			  "Failed to create DMA region: %d, 0x%x\n", err,
> +			  create_resp.hdr.status);

    if (!err)
        err =3D -EPROTO;

> +		goto error;
> +	}
> + ...
> +			err =3D mana_gd_send_request(gc, add_req_msg_size,
> +						   add_req, sizeof(add_resp),
> +						   &add_resp);
> +			if (!err || add_resp.hdr.status !=3D expected_status) {
> +				ibdev_err(&dev->ib_dev,
> +					  "Failed put DMA pages %u: %d,0x%x\n",
> +					  i, err, add_resp.hdr.status);
> +				err =3D -EPROTO;

Should we try to undo what has been done by calling GDMA_DESTROY_DMA_REGION=
?
Yes, I updated the patch.

> +				goto free_req;
> +			}
> +
> +			num_pages_cur +=3D num_pages_to_handle;
> +			num_pages_to_handle =3D
> +				min_t(size_t, num_pages_total - num_pages_cur,
> +				      max_pgs_add_cmd);
> +			add_req_msg_size =3D sizeof(*add_req) +
> +					   num_pages_to_handle * sizeof(u64);
> +		}
> +free_req:
> +		kfree(add_req);
> +	}
> +
> +error:
> +	return err;
> +}
> + ...
> +int mana_ib_gd_create_mr(struct mana_ib_dev *dev, struct mana_ib_mr
> *mr,
> +			 struct gdma_create_mr_params *mr_params) {
> +	struct gdma_create_mr_response resp =3D {};
> +	struct gdma_create_mr_request req =3D {};
> +	struct gdma_dev *mdev =3D dev->gdma_dev;
> +	struct gdma_context *gc;
> +	int err;
> +
> +	gc =3D mdev->gdma_context;
> +
> +	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_MR, sizeof(req),
> +			     sizeof(resp));
> +	req.pd_handle =3D mr_params->pd_handle;
> +
> +	switch (mr_params->mr_type) {
> +	case GDMA_MR_TYPE_GVA:
> +		req.mr_type =3D GDMA_MR_TYPE_GVA;
> +		req.gva.dma_region_handle =3D mr_params->gva.dma_region_handle;
> +		req.gva.virtual_address =3D mr_params->gva.virtual_address;
> +		req.gva.access_flags =3D mr_params->gva.access_flags;
> +		break;
> +
> +	case GDMA_MR_TYPE_GPA:
> +		req.mr_type =3D GDMA_MR_TYPE_GPA;
> +		req.gpa.access_flags =3D mr_params->gpa.access_flags;
> +		break;
> +
> +	case GDMA_MR_TYPE_FMR:
> +		req.mr_type =3D GDMA_MR_TYPE_FMR;
> +		req.fmr.page_size =3D mr_params->fmr.page_size;
> +		req.fmr.reserved_pte_count =3D mr_params->fmr.reserved_pte_count;
> +		break;
> +
> +	default:
> +		ibdev_dbg(&dev->ib_dev,
> +			  "invalid param (GDMA_MR_TYPE) passed, type %d\n",
> +			  req.mr_type);

Here req.mr_type is always 0.
We should remove the 3 above lines of "req.mr_type =3D ...", and add a line=
 "req.mr_type =3D mr_params->mr_type;" before the "switch" line..

No, That's incorrect. The mr_type is being explicitly set here to control w=
hat regions get exposed to the user and kernel. GPA and FMR are never expos=
ed to user. So we cannot assign req.mr_type =3D mr_params->mr_type.

> +		err =3D -EINVAL;
> +		goto error;
> +	}
> +
> +	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp),=20
> +&resp);
> +
> +	if (err || resp.hdr.status) {
> +		ibdev_err(&dev->ib_dev, "Failed to create mr %d, %u", err,
> +			  resp.hdr.status);

    if (!err)
        err =3D -EPROTO;

> +		goto error;
> +	}
> +
> +	mr->ibmr.lkey =3D resp.lkey;
> +	mr->ibmr.rkey =3D resp.rkey;
> +	mr->mr_handle =3D resp.mr_handle;
> +
> +	return 0;
> +error:
> +	return err;
> +}
> + ...
> +static int mana_ib_probe(struct auxiliary_device *adev,
> +			 const struct auxiliary_device_id *id) {
> +	struct mana_adev *madev =3D container_of(adev, struct mana_adev, adev);
> +	struct gdma_dev *mdev =3D madev->mdev;
> +	struct mana_context *mc;
> +	struct mana_ib_dev *dev;
> +	int ret =3D 0;
No need to initialize 'ret' to 0.
Agreed. Updated the patch.

> +int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata) {
> +	struct mana_ib_mr *mr =3D container_of(ibmr, struct mana_ib_mr, ibmr);
> +	struct ib_device *ibdev =3D ibmr->device;
> +	struct mana_ib_dev *dev;
> +	int err;
> +
> +	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> +
> +	err =3D mana_ib_gd_destroy_mr(dev, mr->mr_handle);
> +	if (err)

Should we return here without calling ib_umem_release() and kfree(mr)?
Yes, if the device fails to deallocate the resources and we release them ba=
ck to kernel it will lead to unexpected results.

> +		return err;

> +
> +	if (mr->umem)
> +		ib_umem_release(mr->umem);
> +
> +	kfree(mr);
> +
> +	return 0;
> +}
