Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7D152CBB1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 07:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbiESF5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 01:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiESF5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 01:57:05 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021015.outbound.protection.outlook.com [52.101.62.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0944968319;
        Wed, 18 May 2022 22:57:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AB9xg9vdmZTjaNTl2wyriTf41+WFOPKk3frtQY7l+6sogxwHz8ojbVsJ3k8OUk7pNcazL76m8Hs7kIxpB4rGNbsae+1ljUs0nNncDmKt1aIUDf3veDGq2vYHbo3gr5bBAItgEkSazPeX9/wkFo7Txsp6ald2DnpEMPNgkJWHBK02431rySsVpA0EXKts9hgcKyW+1lUXMzoSNVN3SqWI+q8aMLpVeAkpYK9hfANVGg+RjV8KD++bQE60NiY1pTGDKhYBbGYGfk6w12JptMfhuASd/WUDvWC/y2Zmb70XyRlw1RIxX1hlRNYaqnygiI4PhHorXK7zI0S7VqEUSxHf/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/18DvhsZI77yEgTC5b/J2JhAUdK9y45D0hkSP8StaQ=;
 b=KnPoxseTLAxqAvaLvV41uhqcd/+Yxcwso6hKSamAQiWiIgX5q8Glk9aQWz4C+QHkJbRwfqMMgzsI/4+POsxh4iQHcxkCRIkgBMLSk/5n29V07sE32ncXCLX/g87n8SmitvgAu0x0w8u+2QvfU+zAZQVE0A0B2u+a2oumYOwPQOqAxt14RKmBRWYruy0OUoafFhgVD6H0W2jlmpE1BVub1YCbmcoWwmketrfWRxeKPNgFamRbta+/xVToz7O/qOVDQ4ox+5oOQI2yWSP/llFiT985zJpNyPFFhbjf6r5qXy0ZgD0QPKMgSDBwMe98bk3DiBgTetcjntvKugZJJuEk5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/18DvhsZI77yEgTC5b/J2JhAUdK9y45D0hkSP8StaQ=;
 b=WsAHiF7DiG+MDLOX0PWtN9qPcyVb3JQBYU8512ZJO0+FLm16ezBvq1s5UDuO5cqUyKq5704d8u10UrBMnIW2iAmBR3dfjLW+ZYsuN212A3JjxQlRqSKH2SYnrEMFi2AcRdunfYbXySZdqkgoT7H3qRWxdHUSQSDaos06dar35/Q=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by CH2PR21MB1526.namprd21.prod.outlook.com (2603:10b6:610:84::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7; Thu, 19 May
 2022 05:57:01 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%7]) with mapi id 15.20.5293.007; Thu, 19 May 2022
 05:57:01 +0000
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
Subject: RE: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYac0wRAeXK+HCykeq53JGGiXdWK0jMLSAgAJ/saA=
Date:   Thu, 19 May 2022 05:57:01 +0000
Message-ID: <PH7PR21MB326393A3D6BF619C2A7B4A42CED09@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
 <20220517152409.GJ63055@ziepe.ca>
In-Reply-To: <20220517152409.GJ63055@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1b6aa0eb-98b9-4f82-a59b-964bc3dc4c30;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-19T05:33:42Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 684ceedc-d646-47d5-9548-08da395c6475
x-ms-traffictypediagnostic: CH2PR21MB1526:EE_
x-microsoft-antispam-prvs: <CH2PR21MB1526AFE3DEEC648529D258C4CED09@CH2PR21MB1526.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IoWUX+SLtIn0DerSuRwTa1aobEXCbdmy0cBpax3/j5cEeFFIDl+T0z5UxIMClamuyQ+xgHrS4Ln6jxPP1HIG36uxNv1CSU6ZKPCaQeHUXDrIzrAZEzxTnZLpDgwgmRl06+TUlzuNaLWLX0DP5499oCqnnbqdL6gG42GAj6XETkgkHCnjVw8g4W8e7dyLkJrx2QlmgGUx6Kb3oPYRpoWKsN61Mm8Rt45eerTk/xyxzUvOJLuMN8+HIUGElikY6Sv8gHb5FUH+YDzX05qmO4LUXY5VjjR8jV/woN18a2wAVeAmJOIlSHgqzO4BRKFdALbyXwsRUGImiWLGgrXk6CxMqgFP7mjlQDOElHmzwMabaxElEXPs+tP1PFRpU+fTth8xpH6CCtRCij+y/G6LjvJJVjX3b1tpvZsOnVGWigvbVA5hVb6dgQFnjEx9Rrx+c4Otkiw4jZ4d9zU+HaaJnr/eEwBf0epZZEbvRHjZtZmdPT4qCmZSotY9nEIEryXQHAnr5+tpdICJ3tiRJTxMkXzsvcYZNkuKmLPZg+IQ0IRUkAwARfqg+6pYzUYjs0aImruWgPb9m0gBfsjX0Sqg+eyQVeZuodmODUujHc24yJIofyQt41LWETUl69CMpw4N0aVPIUm4Nnk2RJb0Ee4vHW3fY3xenHw6RRRdwg8FqBVhPwSQ0bLw4nk+V85zHiwBURormPJaf3tCJsR15RM6df/5oB/08ZZHzhoWgIAHKimB+rNoDjy1vTfLkjs8hd6HTAq8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(47530400004)(451199009)(186003)(52536014)(38070700005)(38100700002)(8990500004)(6916009)(71200400001)(54906003)(86362001)(83380400001)(8676002)(4326008)(76116006)(66946007)(64756008)(66446008)(66476007)(66556008)(10290500003)(6506007)(33656002)(82950400001)(82960400001)(316002)(122000001)(508600001)(30864003)(55016003)(7696005)(9686003)(8936002)(5660300002)(7416002)(2906002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RnLKxfTo66LwMc4tgVBWvYMQ/MlR/0oe0XdboYvTpIFQx+/7tmSp4XoWt+Ow?=
 =?us-ascii?Q?f3L/ii6PX6lKzgaxfCFNSPl0WnfFOfxl0MD10UupubPhCnrx8EwCHYzN+b8i?=
 =?us-ascii?Q?sBAeSmsB+2H86sVAHptFXiXLGAY3h4paKIwzXfA1YFIdpSJPfPLUPv4UOYpT?=
 =?us-ascii?Q?kdkgz0ZrcUege2DIjbI0kFKdZ/UVvQ/4sSOZkPhg2xZGuvF7tE7ezHWdnAF8?=
 =?us-ascii?Q?9SIzIoJlGZAPjYQu+8NrwQHdngctyk85p0mkafwVWPnhdZfvLHrBqIbH2HIW?=
 =?us-ascii?Q?8lt4yrIOxbdCsKhs5UMKWu2t0TT2Fr/IG4vGwjheyx3iKugmJp8Mt0T9vNsl?=
 =?us-ascii?Q?olBmxjFWFJjbHSbFhHzpuZk16CfpJVUCiai1YLZwrQR+/BUBt1JsPcVQLQP1?=
 =?us-ascii?Q?Zzx1f14fiZ9hSdKa/cAE5YmhTJEgg0lQPvE6kYfPwsIwBze80Un21XVW+9w7?=
 =?us-ascii?Q?WAZVtAyv8krxfbpseXkcq0uj3AQuFebQx1naiH7ccL97lr4/hd2PIE+Nc3nl?=
 =?us-ascii?Q?xjVzLpB1L8gFH8bD8UNZe/009aFR6W1plI5aFn+HncHaVrg2Hocaw6tJxYUX?=
 =?us-ascii?Q?j0DyC58c7y8kThbuH/I5R/5pBlzEzDywn48PMTODv3tRpSxAdBYwJvBiN24a?=
 =?us-ascii?Q?4bfEABu406ct8uLMHwhi9IP98FFGPr2AcreGyttRdGGWEyWreS2vKP7QrKVm?=
 =?us-ascii?Q?lj5Jw27gAJ2SVHNAT9Mv013GJ3RitpFxBH3VdQmFDu/zmrl8KnOjV5ocksGO?=
 =?us-ascii?Q?s9bsAHPIOcjXwAr0VHKz/aBum7fOPccuyInI3zBrffawwFdG04zyI83LXopz?=
 =?us-ascii?Q?rnl6w/tQQ+SjqTLUCaymtYntG6nDlmRksSQOJGmTc45Q3IUKrMwyY9Iu3gyL?=
 =?us-ascii?Q?WOpIVwzMWrI34vQrG7Ulup+J5+7+EM7WRdaJ3xaypy3R1PIGHhIb3W2T9SCZ?=
 =?us-ascii?Q?idPXLIwPjmEbzGVeN7Uw61oCH1NJYSlBm8puog8YWRHpYNAhA7F5CcQoLIQB?=
 =?us-ascii?Q?Cr+QcZhkOXZuwUuwxxyj7zxzMDmHbGyIE5CogDBHXMoPcbBnXfSd3dHTK/4T?=
 =?us-ascii?Q?gsYcS0vuvR2BvOCu9OoIJ1AmAgW1HUgmKRZ1zSb+OA3+2+e1P0BICS4CmKMB?=
 =?us-ascii?Q?k1eXjBcS3e79Ku2ADN0eDMw6VutHRtxl0+p/6iiUYs4lO4uvTAXFwhmk8xFT?=
 =?us-ascii?Q?RqxQ/VHCeC27IZ9nN/i1E6yjNQANwKGV8ScciBAFwjSPOWv6tF9LJe/qvKSJ?=
 =?us-ascii?Q?j89CkPUo16cCUw228CoTiqDQ09F7at8DciGj0xNg0qRhg/woavKG5DBSWv6G?=
 =?us-ascii?Q?zNT8eMYhmjCqLFGA1tZrpP0dbQoVcHQZthinq5s8LAQ14GcnqzQYIzSIp4IL?=
 =?us-ascii?Q?WsEzGOeND/9AlK+NZX1AxLznxnreTbun6dqa+5YuHKPhuY/66UKSprt4ut21?=
 =?us-ascii?Q?+CCzHxD1Xl6SUgm+vS0l/T2Bj14g2p+i/03svIhutScHlmP97Lt7e23wlOQn?=
 =?us-ascii?Q?+84FlYemEa0rjbxI7RjA/BkyqZ3rMpIus+3ySrlV5WAMyV54KLW+vDu9Ek4p?=
 =?us-ascii?Q?Q5NtnJ7LgglFBkoGbayf4R3pJHz32VhHgxDK7scRJKXo+Rq1r1TLLygRPijA?=
 =?us-ascii?Q?autBhqv0LmUw1W9e9iMhTB0zJGv7T7Ki+8eYSBrRFMbnYk1NDmdghiMXow/3?=
 =?us-ascii?Q?1BgSV6xaFf1IcaFYaJyE4csmj/eKp9M13otxba85rMMH8gVzZXKRYVz0y4sj?=
 =?us-ascii?Q?tFvHZq1eiw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684ceedc-d646-47d5-9548-08da395c6475
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 05:57:01.0449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ymyUCs0ClIqoBg3Gu1VgkwR1LajZkqy2UbODAbg43LgxvE8tyGtW5G2jvPa2p2bE7aSSdRbLorgFONIXRsKdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1526
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
> Network Adapter
>=20
> On Tue, May 17, 2022 at 02:04:36AM -0700, longli@linuxonhyperv.com wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > Add a RDMA VF driver for Microsoft Azure Network Adapter (MANA).
>=20
> To set exepecation, we are currently rc7, so this will not make this merg=
e
> window. You will need to repost on the next rc1 in three weeks.
>=20
>=20
> > new file mode 100644
> > index 000000000000..0eac77c97658
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/mana/cq.c
> > @@ -0,0 +1,74 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> > +/*
> > + * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include "mana_ib.h"
> > +
> > +int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr=
 *attr,
> > +		struct ib_udata *udata)
> > +{
> > +	struct mana_ib_create_cq ucmd =3D {};
> > +	struct ib_device *ibdev =3D ibcq->device;
> > +	struct mana_ib_dev *mdev =3D
> > +		container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibcq)=
;
> > +	int err;
>=20
> We do try to follow the netdev formatting, christmas trees and all that.
>=20
> > +
> > +	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd),
> > +udata->inlen));
>=20
> Skeptical this min is correct, many other drivers get this wrong.

I think this is correct. This is to prevent user-mode passing more data tha=
t may overrun the kernel buffer.

>=20
> > +	if (err) {
> > +		pr_err("Failed to copy from udata for create cq, %d\n", err);
>=20
> Do not use pr_* - you should use one of the dev specific varients inside =
a device
> driver. In this case ibdev_dbg
>=20
> Also, do not ever print to the console on a user triggerable event such a=
s this.
> _dbg would be OK.
>=20
> Scrub the driver for all occurances.
>=20
> > +	pr_debug("ucmd buf_addr 0x%llx\n", ucmd.buf_addr);
>=20
> I'm not keen on left over debugging please, in fact there are way too man=
y
> prints..

I will clean up all the occurrence on pr_*.

>=20
> > +	cq->umem =3D ib_umem_get(ibdev, ucmd.buf_addr,
> > +			       cq->cqe * COMP_ENTRY_SIZE,
> > +			       IB_ACCESS_LOCAL_WRITE);
>=20
> Please touch the file with clang-format and take all the things that look=
 good to
> you
>=20
> > diff --git a/drivers/infiniband/hw/mana/main.c
> > b/drivers/infiniband/hw/mana/main.c
> > new file mode 100644
> > index 000000000000..e288495e3ede
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/mana/main.c
> > @@ -0,0 +1,679 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> > +/*
> > + * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include "mana_ib.h"
> > +
> > +MODULE_DESCRIPTION("Microsoft Azure Network Adapter IB driver");
> > +MODULE_LICENSE("Dual BSD/GPL");
> > +
> > +static const struct auxiliary_device_id mana_id_table[] =3D {
> > +	{ .name =3D "mana.rdma", },
> > +	{},
> > +};
>=20
> stylistically this stuff is usually at the bottom of the file, right befo=
re its first use

Will move it.

>=20
> > +static inline enum atb_page_size mana_ib_get_atb_page_size(u64
> > +page_sz) {
> > +	int pos =3D 0;
> > +
> > +	page_sz =3D (page_sz >> 12); //start with 4k
> > +
> > +	while (page_sz) {
> > +		pos++;
> > +		page_sz =3D (page_sz >> 1);
> > +	}
> > +	return (enum atb_page_size)(pos - 1); }
>=20
> Isn't this ffs, log, or something that isn't a while loop?

Will fix this.

>=20
> > +static int _mana_ib_gd_create_dma_region(struct mana_ib_dev *dev,
> > +					 const dma_addr_t *page_addr_array,
> > +					 size_t num_pages_total,
> > +					 u64 address, u64 length,
> > +					 mana_handle_t *gdma_region,
> > +					 u64 page_sz)
> > +{
> > +	struct gdma_dev *mdev =3D dev->gdma_dev;
> > +	struct gdma_context *gc =3D mdev->gdma_context;
> > +	struct hw_channel_context *hwc =3D gc->hwc.driver_data;
> > +	size_t num_pages_cur, num_pages_to_handle;
> > +	unsigned int create_req_msg_size;
> > +	unsigned int i;
> > +	struct gdma_dma_region_add_pages_req *add_req =3D NULL;
> > +	int err;
> > +
> > +	struct gdma_create_dma_region_req *create_req;
> > +	struct gdma_create_dma_region_resp create_resp =3D {};
> > +
> > +	size_t max_pgs_create_cmd =3D (hwc->max_req_msg_size -
> > +				     sizeof(*create_req)) / sizeof(u64);
>=20
> These extra blank lines are not kernel style, please check everything.
>=20
> > +	num_pages_to_handle =3D min_t(size_t, num_pages_total,
> > +				    max_pgs_create_cmd);
> > +	create_req_msg_size =3D struct_size(create_req, page_addr_list,
> > +					  num_pages_to_handle);
> > +
> > +	create_req =3D kzalloc(create_req_msg_size, GFP_KERNEL);
> > +	if (!create_req)
> > +		return -ENOMEM;
> > +
> > +	mana_gd_init_req_hdr(&create_req->hdr,
> GDMA_CREATE_DMA_REGION,
> > +			     create_req_msg_size, sizeof(create_resp));
> > +
> > +	create_req->length =3D length;
> > +	create_req->offset_in_page =3D address & (page_sz - 1);
> > +	create_req->gdma_page_type =3D mana_ib_get_atb_page_size(page_sz);
> > +	create_req->page_count =3D num_pages_total;
> > +	create_req->page_addr_list_len =3D num_pages_to_handle;
> > +
> > +	pr_debug("size_dma_region %llu num_pages_total %lu, "
> > +		 "page_sz 0x%llx offset_in_page %u\n",
> > +		length, num_pages_total, page_sz, create_req-
> >offset_in_page);
> > +
> > +	pr_debug("num_pages_to_handle %lu, gdma_page_type %u",
> > +		 num_pages_to_handle, create_req->gdma_page_type);
> > +
> > +	for (i =3D 0; i < num_pages_to_handle; ++i) {
> > +		dma_addr_t cur_addr =3D page_addr_array[i];
> > +
> > +		create_req->page_addr_list[i] =3D cur_addr;
> > +
> > +		pr_debug("page num %u cur_addr 0x%llx\n", i, cur_addr);
> > +	}
>=20
> Er, so we allocated memory and wrote the DMA addresses now you copy them
> to another memory?
>=20
> > +
> > +	err =3D mana_gd_send_request(gc, create_req_msg_size, create_req,
> > +				   sizeof(create_resp), &create_resp);
> > +	kfree(create_req);
> > +
> > +	if (err || create_resp.hdr.status) {
> > +		dev_err(gc->dev, "Failed to create DMA region: %d, 0x%x\n",
> > +			err, create_resp.hdr.status);
> > +		goto error;
> > +	}
> > +
> > +	*gdma_region =3D create_resp.dma_region_handle;
> > +	pr_debug("Created DMA region with handle 0x%llx\n", *gdma_region);
> > +
> > +	num_pages_cur =3D num_pages_to_handle;
> > +
> > +	if (num_pages_cur < num_pages_total) {
> > +
> > +		unsigned int add_req_msg_size;
> > +		size_t max_pgs_add_cmd =3D (hwc->max_req_msg_size -
> > +					  sizeof(*add_req)) / sizeof(u64);
> > +
> > +		num_pages_to_handle =3D min_t(size_t,
> > +					    num_pages_total - num_pages_cur,
> > +					    max_pgs_add_cmd);
> > +
> > +		// Calculate the max num of pages that will be handled
> > +		add_req_msg_size =3D struct_size(add_req, page_addr_list,
> > +					       num_pages_to_handle);
> > +
> > +		add_req =3D kmalloc(add_req_msg_size, GFP_KERNEL);
> > +		if (!add_req) {
> > +			err =3D -ENOMEM;
> > +			goto error;
> > +		}
> > +
> > +		while (num_pages_cur < num_pages_total) {
> > +			struct gdma_general_resp add_resp =3D {};
> > +			u32 expected_status;
> > +			int expected_ret;
> > +
> > +			if (num_pages_cur + num_pages_to_handle <
> > +					num_pages_total) {
> > +				// This value means that more pages are
> needed
> > +				expected_status =3D
> GDMA_STATUS_MORE_ENTRIES;
> > +				expected_ret =3D 0x0;
> > +			} else {
> > +				expected_status =3D 0x0;
> > +				expected_ret =3D 0x0;
> > +			}
> > +
> > +			memset(add_req, 0, add_req_msg_size);
> > +
> > +			mana_gd_init_req_hdr(&add_req->hdr,
> > +					     GDMA_DMA_REGION_ADD_PAGES,
> > +					     add_req_msg_size,
> > +					     sizeof(add_resp));
> > +			add_req->dma_region_handle =3D *gdma_region;
> > +			add_req->page_addr_list_len =3D num_pages_to_handle;
> > +
> > +			for (i =3D 0; i < num_pages_to_handle; ++i) {
> > +				dma_addr_t cur_addr =3D
> > +					page_addr_array[num_pages_cur + i];
>=20
> And then again?
>=20
> That isn't how this is supposed to work, you should iterate over the umem=
 in one
> pass and split up the output as you go. Allocating potentially giant temp=
orary
> arrays should be avoided.

Will address this in V2.

>=20
>=20
> > +				add_req->page_addr_list[i] =3D cur_addr;
> > +
> > +				pr_debug("page_addr_list %lu addr 0x%llx\n",
> > +					 num_pages_cur + i, cur_addr);
> > +			}
> > +
> > +			err =3D mana_gd_send_request(gc, add_req_msg_size,
> > +						   add_req, sizeof(add_resp),
> > +						   &add_resp);
> > +			if (err !=3D expected_ret ||
> > +			    add_resp.hdr.status !=3D expected_status) {
> > +				dev_err(gc->dev,
> > +					"Failed to put DMA
> pages %u: %d,0x%x\n",
> > +					i, err, add_resp.hdr.status);
> > +				err =3D -EPROTO;
> > +				goto free_req;
> > +			}
> > +
> > +			num_pages_cur +=3D num_pages_to_handle;
> > +			num_pages_to_handle =3D min_t(size_t,
> > +						    num_pages_total -
> > +							num_pages_cur,
> > +						    max_pgs_add_cmd);
> > +			add_req_msg_size =3D sizeof(*add_req) +
> > +				num_pages_to_handle * sizeof(u64);
> > +		}
> > +free_req:
> > +		kfree(add_req);
> > +	}
> > +
> > +error:
> > +	return err;
> > +}
> > +
> > +
> > +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> ib_umem *umem,
> > +				 mana_handle_t *dma_region_handle, u64
> page_sz)
>=20
> Since this takes in a umem it should also compute the page_sz for that um=
em.
>=20
> I see this driver seems to have various limitations, so the input argumen=
t here
> should be the pgsz bitmask that is compatible with the object being creat=
ed.
>=20
> > +{
> > +	size_t num_pages =3D ib_umem_num_dma_blocks(umem, page_sz);
> > +	struct ib_block_iter biter;
> > +	dma_addr_t *page_addr_array;
> > +	unsigned int i =3D 0;
> > +	int err;
> > +
> > +	pr_debug("num pages %lu umem->address 0x%lx\n",
> > +		 num_pages, umem->address);
> > +
> > +	page_addr_array =3D kmalloc_array(num_pages,
> > +					sizeof(*page_addr_array),
> GFP_KERNEL);
> > +	if (!page_addr_array)
> > +		return -ENOMEM;
>=20
> This will OOM easily, num_pages is user controlled.

I'm adding a check for length before calling into this.

>=20
> > +
> > +	rdma_umem_for_each_dma_block(umem, &biter, page_sz)
> > +		page_addr_array[i++] =3D rdma_block_iter_dma_address(&biter);
> > +
> > +	err =3D _mana_ib_gd_create_dma_region(dev, page_addr_array,
> num_pages,
> > +					    umem->address, umem->length,
> > +					    dma_region_handle, page_sz);
> > +
> > +	kfree(page_addr_array);
> > +
> > +	return err;
> > +}
> > +int mana_ib_gd_create_pd(struct mana_ib_dev *dev, u64 *pd_handle, u32
> *pd_id,
> > +			 enum gdma_pd_flags flags)
> > +{
> > +	struct gdma_dev *mdev =3D dev->gdma_dev;
> > +	struct gdma_context *gc =3D mdev->gdma_context;
> > +	int err;
> > +
> > +	struct gdma_create_pd_req req =3D {};
> > +	struct gdma_create_pd_resp resp =3D {};
> > +
> > +	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_PD,
> > +			     sizeof(req), sizeof(resp));
> > +
> > +	req.flags =3D flags;
> > +	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp),
> > +&resp);
> > +
> > +	if (!err && !resp.hdr.status) {
> > +		*pd_handle =3D resp.pd_handle;
> > +		*pd_id =3D resp.pd_id;
> > +		pr_debug("pd_handle 0x%llx pd_id %d\n", *pd_handle, *pd_id);
>=20
> Kernel style is 'success oriented flow':

Will fix this.

>=20
>  if (err) {
>     return err;
>  }
>  // success
>  return 0;
>=20
> Audit everything
>=20
> > +static int mana_ib_mmap(struct ib_ucontext *ibcontext, struct
> > +vm_area_struct *vma) {
> > +	struct mana_ib_ucontext *mana_ucontext =3D
> > +		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
> > +	struct ib_device *ibdev =3D ibcontext->device;
> > +	struct mana_ib_dev *mdev =3D
> > +		container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +	struct gdma_context *gc =3D mdev->gdma_dev->gdma_context;
> > +	pgprot_t prot;
> > +	phys_addr_t pfn;
> > +	int ret;
>=20
> This needs to validate vma->pgoff

Will validate this.
>=20
> > +	// map to the page indexed by ucontext->doorbell
>=20
> Not kernel style, be sure to run checkpatch and fix the egregious things.
>=20
> > +static void mana_ib_disassociate_ucontext(struct ib_ucontext
> > +*ibcontext) { }
>=20
> Does this driver actually support disassociate? Don't define this functio=
n if it
> doesn't.
>=20
> I didn't see any mmap zapping so I guess it doesn't.

The user-mode deals with zapping.
I see the following comments on rdma_umap_priv_init():

/* RDMA drivers supporting disassociation must have their user space design=
ed
 * to cope in some way with their IO pages going to the zero page. */

Is there any other additional work for the kernel driver to support disasso=
ciate? It seems uverbs_user_mmap_disassociate() has done all the zapping wh=
en destroying a ucontext.

>=20
> > +static const struct ib_device_ops mana_ib_dev_ops =3D {
> > +	.owner =3D THIS_MODULE,
> > +	.driver_id =3D RDMA_DRIVER_MANA,
> > +	.uverbs_abi_ver =3D MANA_IB_UVERBS_ABI_VERSION,
> > +
> > +	.alloc_pd =3D mana_ib_alloc_pd,
> > +	.dealloc_pd =3D mana_ib_dealloc_pd,
> > +
> > +	.alloc_ucontext =3D mana_ib_alloc_ucontext,
> > +	.dealloc_ucontext =3D mana_ib_dealloc_ucontext,
> > +
> > +	.create_cq =3D mana_ib_create_cq,
> > +	.destroy_cq =3D mana_ib_destroy_cq,
> > +
> > +	.create_qp =3D mana_ib_create_qp,
> > +	.modify_qp =3D mana_ib_modify_qp,
> > +	.destroy_qp =3D mana_ib_destroy_qp,
> > +
> > +	.disassociate_ucontext =3D mana_ib_disassociate_ucontext,
> > +
> > +	.mmap =3D mana_ib_mmap,
> > +
> > +	.reg_user_mr =3D mana_ib_reg_user_mr,
> > +	.dereg_mr =3D mana_ib_dereg_mr,
> > +
> > +	.create_wq =3D mana_ib_create_wq,
> > +	.modify_wq =3D mana_ib_modify_wq,
> > +	.destroy_wq =3D mana_ib_destroy_wq,
> > +
> > +	.create_rwq_ind_table =3D mana_ib_create_rwq_ind_table,
> > +	.destroy_rwq_ind_table =3D mana_ib_destroy_rwq_ind_table,
> > +
> > +	.get_port_immutable =3D mana_ib_get_port_immutable,
> > +	.query_device =3D mana_ib_query_device,
> > +	.query_port =3D mana_ib_query_port,
> > +	.query_gid =3D mana_ib_query_gid,
>=20
> Usually drivers are just sorting this list

Will sort the list.

>=20
> > +#define PAGE_SZ_BM (SZ_4K | SZ_8K | SZ_16K | SZ_32K | SZ_64K | SZ_128K=
 \
> > +		    | SZ_256K | SZ_512K | SZ_1M | SZ_2M)
> > +
> > +// Maximum size of a memory registration is 1G bytes
> > +#define MANA_IB_MAX_MR_SIZE	(1024 * 1024 * 1024)
>=20
> Even with large pages? Weird limit..
>=20
> You also need to open a PR to the rdma-core github with the userspace for=
 this
> and pyverbs test suite support

I will open PR to rdma-core. The current version of the driver supports que=
ue pair type IB_QPT_RAW_PACKET. The test case will be limited to querying d=
evice and load/unload. Running traffic tests will require DPDK (or other us=
er-mode program making use of IB_QPT_RAW_PACKET).

Is it acceptable to develop test cases for this driver without traffic/data=
 tests?

Long

>=20
> Thanks,
> Jason
