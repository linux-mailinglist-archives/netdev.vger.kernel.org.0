Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AD752C56B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243093AbiERVF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 17:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243062AbiERVFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 17:05:52 -0400
X-Greylist: delayed 54396 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 May 2022 14:05:40 PDT
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.57.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAC2121;
        Wed, 18 May 2022 14:05:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYG/XAc30djqxIpItMsMAPNr8IR4Mtn28HnGmx5WfcwlPqL3qmwHEbK8t5rcK6HlDzRkNCkZQHZENYhccP1zDZtccXnuS1ZaOURpLOobPpcSRMcK3YlNBNicf1O3oXo2G/Ojyad+4aInOqRFndX/lJYd4ghlcFO1aPAGv+U2BQ1dGXMDjIyEtya41/4POSFgax3TctuSJW5UuD45AX6d4xTPMfKRVso9Z3tdDuc5fJTahIAAplgmaF5+uiK8Aqm07izdisI6CkKTJPUUqT+Ern9wY7SD//4XwTCC2AyvhstkZ1BhyCvi8wUbu/TT1DRHh0Ne0FGQ858uXctcEyrlkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDowKvb964dF9cPooB6ZyXC3VGWUadXmMgGTWKuibbc=;
 b=e7gH1Uz31L1oskK5XymXE708/v6xpTdDdB33Ju5IpbTurzoXPeZeLDffB3GmPHmmlTbsyZooYVZk15MwVm3TBZAW+Hdhc7RFzXH4laKJAi22389/EXBrp2WxKftYsfkiPztgzaXz63tqLReV4DXklLiCcJNcmpDTY4tHPOohB/uUqJNCYfj6REJRzkF/j4Hkyyk2ykAStXvsssjGtUVrFVvHutstpdZjowxhN433qBGBgpGF4nExZcQ1F8496YweauRbqNwPtsocT3S2/Qnl7QN9drQrij72fkUvsACVvwAzc/648AzJzAvzcMNB848WPMs05uIQcI55YLCeyNbRVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDowKvb964dF9cPooB6ZyXC3VGWUadXmMgGTWKuibbc=;
 b=PkaPl2B+a5I88JdxVOO9uZRoGAeHSbnZy0fY7ZpxlJxJs6hTEQnvGUfJKEoYN7Nrq8Ya/6qcIeWoIK+u2qA0HLRQMzp/lMHZHTTKd7FuETMeM/SEEmNwXIJCXoylQ41NpGrK8jCuox62g7Uq2+nQ9dAVMoQBNmLykgPaljn+VDg=
Received: from BL1PR21MB3283.namprd21.prod.outlook.com (2603:10b6:208:39b::8)
 by PH7PR21MB3381.namprd21.prod.outlook.com (2603:10b6:510:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.5; Wed, 18 May
 2022 21:05:22 +0000
Received: from BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::e0d1:ed2f:325a:8393]) by BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::e0d1:ed2f:325a:8393%9]) with mapi id 15.20.5273.005; Wed, 18 May 2022
 21:05:22 +0000
From:   Ajay Sharma <sharmaajay@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
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
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Subject: RE: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max
 page size
Thread-Topic: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max
 page size
Thread-Index: AQHYac0t/cR6HA52CUOHz8pr+lzroa0jKeeAgABLXKCAAAGZgIAABm1QgABEpQCAAFjD8IAAs9+AgABQTyA=
Date:   Wed, 18 May 2022 21:05:22 +0000
Message-ID: <BL1PR21MB32831207F674356EAF8EE600D6D19@BL1PR21MB3283.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-6-git-send-email-longli@linuxonhyperv.com>
 <20220517145949.GH63055@ziepe.ca>
 <PH7PR21MB3263EFA8F624F681C3B57636CECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220517193515.GN63055@ziepe.ca>
 <PH7PR21MB3263C44368F02B8AF8521C4ACECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220518000356.GO63055@ziepe.ca>
 <BL1PR21MB3283790E8270ED6C639AAB0DD6D19@BL1PR21MB3283.namprd21.prod.outlook.com>
 <20220518160525.GP63055@ziepe.ca>
In-Reply-To: <20220518160525.GP63055@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4ba93844-31f5-48dd-aa44-7fc96505cabc;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-18T20:52:51Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8da95963-13fe-481e-2628-08da39121f85
x-ms-traffictypediagnostic: PH7PR21MB3381:EE_
x-microsoft-antispam-prvs: <PH7PR21MB33811F9CD392ADAA5CED9A14D6D19@PH7PR21MB3381.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yQl6IGbKM8l8Je0Yx54hVEDRK/4Syot/l6dLyA5KWqsgwn55uwRzMHWqcUioqrGELTRBqgpSAgYL5SIZRHk+H9EiWjGMj5N/p2mtcW7iKHY5JydWwA51CvNBnedhHf67S1T7SQo454InaLT/3vQuWGSSJiYDIitm8z1K5iOLg50hsbxGfYcSWBFMn2jYuctyiKWXCEFeG9mzGvQBn/OzuLuL2pqQzi7ey1c41mfZZsvOdeeMRG3lIMqPuGRpNAUH3xlju9eDRvhZn6RpNL3wzqmgxqjJjMsUWwsjW4axjE7Ba/CSSggfaaZQCCJqe1/J/Wv8Bym9CpLQOS0n4qkvY4q+lrDEB+PF3AlbwZzEyx/GEGi6szyit6RqIG3NkBmKqSTis3Tp9/8cCxmHJVK6oFT0SgfGEYxHVwL3b2yyx+3YLB+x2R6tFvbrixeh1qHuyX9FB9OTY4CFeYaTlJnkLHGrOI6mePh+oP3LxrjXIdiXbGR1c9ecSnKYWO0nLejzS2gkue3/AeSBUPIfFYBJNLgnShohf7zpkMJvBiqL5gSkRWq1xsL2NManPYkEoGfD2Sh7K/ls1GIYvObSBzJf1MHoKqQXuyVe0DYASOX/CLlLFfNZ7AgBCm5HKIj4U/SkMHBQkOiDCPppvpWZ3i3Eu26fpLJi1bXwlWZRinXuErgwpjlKVXE3guACLe3MXDBwhKtdU6QX82WB+lTBTIsUUL81kdvdCb6NvECKzB7PkF2OD6jzEdanFZmAIoFt7LX5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3283.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(966005)(83380400001)(33656002)(7416002)(186003)(107886003)(316002)(122000001)(66556008)(76116006)(66446008)(8676002)(66476007)(64756008)(4326008)(82960400001)(66946007)(71200400001)(82950400001)(86362001)(38070700005)(38100700002)(55016003)(508600001)(52536014)(53546011)(8936002)(6506007)(6916009)(9686003)(10290500003)(54906003)(8990500004)(2906002)(7696005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gqe695CfWuUVT38KzOt4J1UMEzEU7RROSWb0+oFo4YNaYx+4zDVvb2cQsmBL?=
 =?us-ascii?Q?R1lNS3uHDcPDd7Xz96pVyK4tkrEl5sarweHPoaoRB4+6OX1Me1StnRgv/S/m?=
 =?us-ascii?Q?WoJQnmbE6TEy90Nml83G4f3CBY7pWH7eJRa/9kPj6IEnOwfNATiqMUUQdNy9?=
 =?us-ascii?Q?nMatT/ChFBM3TI4SdJ/6vmeablUp+ZVoa2lH6POO0pCA36hrrHN0ay1rjP2w?=
 =?us-ascii?Q?zwDua2OkhTbc+vanBM7CnCGapKxrwo1HW0F7KcEqk8vWPAvZAhbH04bba856?=
 =?us-ascii?Q?AmeWYi7XDbICwgEbORlBrptiu8OgZ1OnHwYgMR5W/9xgmCdZ0MFj7srZM8qu?=
 =?us-ascii?Q?HGWqbHsq3E4ghoIpELjQXgqb6As084Aned0MFyB0tsx4ou3K2GfqDzg1mi5t?=
 =?us-ascii?Q?bgIpzSXYliIO34LNip7X/KHZsjIxPvdF2M0pdemEXVqnUkwCz1yHqYc9/UAw?=
 =?us-ascii?Q?DgT3vCpiZPeUN48HQWkn4owAzMsrVYBHa/3YVTbpzZO5Sn1t3M5RZbgUz3W6?=
 =?us-ascii?Q?3WpbNihuawWRZeqA2nywVT5sp2MGQjfmMGBmKJ4p7x4fmD8PJJh6HGtQKIU5?=
 =?us-ascii?Q?sExYdmtKwamFAi6ChRoBN3JWiPd1u4DPm7XUcun7N/ppIlCKR0IkzsZ0fUnZ?=
 =?us-ascii?Q?4o9Sflmn/f7yHRMpe6hCd+OaG5fSot0/F3B7GM6havXqVcnpqoxh+iEnFN/X?=
 =?us-ascii?Q?iZIAeCaAYH6E/z1qHPjOM1Atx6sK1Yx1gbXKsokc5bB4qaK2IdFf0n1f0SdJ?=
 =?us-ascii?Q?BdQbYKTqBHbPyD4g8OKUtIvN66NKH3VpUS7II4F5s4uCz1ug26t3qrzUVKG3?=
 =?us-ascii?Q?G2n98Mf5nUbOpVTi2GKLTg56jef1V9eem7thmLCmdoBuXh02j8J2tyt6lF7R?=
 =?us-ascii?Q?7R5c4xcKLJ4H40HfU+dzIOayoyB2zIU4blP4RQ9rr/aX1brxZQx+YSsXqdHw?=
 =?us-ascii?Q?xuQXyVNKrJyxnYc7CbUHpVknHYEpS0DgDSEPoq4P8PwiZbWElFGs8IZrao+V?=
 =?us-ascii?Q?1UYzWw0n+fwVQI5V+/fZbDSA4j4cBni7/6R4OeEiC6F1QB5QoggfLQ96eX6U?=
 =?us-ascii?Q?w7MDGtRYmz/0+VQ9KJ5w3CTegV4op0NU+kL/nz9nrWdnQh1nbMrju+kjtsUX?=
 =?us-ascii?Q?wqIpYQ9Hz0fLlTffafOwVNcpZzx42IfhOebWQqHkIkHefqsAgbNramhuqchw?=
 =?us-ascii?Q?BT2sDFCiTfFkAOJQOzbgG1wHXMYeSgowSZCedTbWbRpxfsTxnufXcXg1FPHL?=
 =?us-ascii?Q?lmuVBn/e35+4bWir43wIfZyF7QQ0xaoMzvmlCZCHBiDsHUXhU5Xxjbo57ibE?=
 =?us-ascii?Q?3A0EJflPWVtEWEW1X1OqXQMtT2F7LhLdQo0UfM2m5muQLiYiu2zkUViYAgo5?=
 =?us-ascii?Q?r2V57BBIJWUTPAlCa45NjCZURam29CYa2r+6RxTLqx4mqDojwZdyP2rIT+2e?=
 =?us-ascii?Q?Emx+WaJSKRDCpW2CqtT7eyMK3yhGT7rvzh+3YbLKIjC/8moer9vn7qLtJWkB?=
 =?us-ascii?Q?bK6+LmT9bcov25g4RUssZYhP0OgjfbZJAO1ze9QwLdr6KA46vqDAyKbU0RSQ?=
 =?us-ascii?Q?wgNcPnthp2Q5+FQNTzxn2IU5TuzB+5XWdlhN/3BpVgbtIvE2Ee4oJhxLWS+Q?=
 =?us-ascii?Q?F8npAJqlzhQzvob0/L+7k1HmaofAMrZo5DYg5pvrlqdTluJ1oqE3byMF1F1f?=
 =?us-ascii?Q?CLNwwVowjkDUvTApMrKedvAJsuQk7QsZNF4Un4TVISd4EAQh8zCGeGCo3jhE?=
 =?us-ascii?Q?TwS+Cl8QsA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3283.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da95963-13fe-481e-2628-08da39121f85
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 21:05:22.6311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cAz9dx3tBMHxabvxuNqFZx/HMFeFkQbhzapG4DqzJBsMdlw8e6kLZUdMqJfdG5j0vYCHrQ0R2vhyc1YxiOzm08ShXUb27G9m1DLCFhE34F0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3381
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry , I am not able to follow. Below is the reference efa driver implemen=
tation :

static int efa_device_init(struct efa_com_dev *edev, struct pci_dev *pdev)
{
	int dma_width;
	int err;

	err =3D efa_com_dev_reset(edev, EFA_REGS_RESET_NORMAL);
	if (err)
		return err;

	err =3D efa_com_validate_version(edev);
	if (err)
		return err;

	dma_width =3D efa_com_get_dma_width(edev);
	if (dma_width < 0) {
		err =3D dma_width;
		return err;
	}

	err =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(dma_width));
	if (err) {
		dev_err(&pdev->dev, "dma_set_mask_and_coherent failed %d\n", err);
		return err;
	}

	dma_set_max_seg_size(&pdev->dev, UINT_MAX);
	return 0;
}

static int efa_register_mr(struct ib_pd *ibpd, struct efa_mr *mr, u64 start=
,
			   u64 length, u64 virt_addr, int access_flags)
{
	struct efa_dev *dev =3D to_edev(ibpd->device);
	struct efa_com_reg_mr_params params =3D {};
	struct efa_com_reg_mr_result result =3D {};
	struct pbl_context pbl;
	unsigned int pg_sz;
	int inline_size;
	int err;

	params.pd =3D to_epd(ibpd)->pdn;
	params.iova =3D virt_addr;
	params.mr_length_in_bytes =3D length;
	params.permissions =3D access_flags;

	pg_sz =3D ib_umem_find_best_pgsz(mr->umem,
				       dev->dev_attr.page_size_cap,
				       virt_addr);
....
}

Ideally we would like to read it from HW, but currently we are hardcoding t=
he bitmap. I can change the commit message if you feel that is misleading .
Something along the lines :
RDMA/mana: Use API to get contiguous memory blocks aligned to device suppor=
ted page size

Use the ib_umem_find_best_pgsz() and rdma_for_each_block() API when
registering an MR instead of coding it in the driver.

ib_umem_find_best_pgsz() is used to find the best suitable page size
which replaces the existing efa_cont_pages() implementation.
rdma_for_each_block() is used to iterate the umem in aligned contiguous mem=
ory blocks.


Ajay=20


-----Original Message-----
From: Jason Gunthorpe <jgg@ziepe.ca>=20
Sent: Wednesday, May 18, 2022 9:05 AM
To: Ajay Sharma <sharmaajay@microsoft.com>
Cc: Long Li <longli@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Haiy=
ang Zhang <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.c=
om>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui <decui@microsoft.com>; David =
S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Paolo Ab=
eni <pabeni@redhat.com>; Leon Romanovsky <leon@kernel.org>; linux-hyperv@vg=
er.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-=
rdma@vger.kernel.org
Subject: Re: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max=
 page size

[You don't often get email from jgg@ziepe.ca. Learn why this is important a=
t https://aka.ms/LearnAboutSenderIdentification.]

On Wed, May 18, 2022 at 05:59:00AM +0000, Ajay Sharma wrote:
> Thanks Long.
> Hello Jason,
> I am the author of the patch.
> To your comment below :
> " As I've already said, you are supposed to set the value that limits to =
ib_sge and *NOT* the value that is related to ib_umem_find_best_pgsz. It is=
 usually 2G because the ib_sge's typically work on a 32 bit length."
>
> The ib_sge is limited by the __sg_alloc_table_from_pages() which uses=20
> ib_dma_max_seg_size() which is what is set by the eth driver using=20
> dma_set_max_seg_size() . Currently our hw does not support PTEs larger=20
> than 2M.

*sigh* again it has nothing to do with *PTEs* in the HW.

Jason
