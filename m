Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2997C6DB02F
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240677AbjDGQGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjDGQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:06:43 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021014.outbound.protection.outlook.com [52.101.57.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39B7BB95;
        Fri,  7 Apr 2023 09:06:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpMOi1tgnoWnbWv6TvpTo1WGc642tJGk77qUyboBMm2TIn3CQZeTvUnWxSPGOJWfzkqdAVzUK4q/oZqjlO3O+LQTmCzp+CEd47Th1XDvhKwJOoOrsLgp6OS0UH1bgwQgMzOZZvoSatnr8aoKdJzJgiydCQpuL1ZhQPy4M/5tW6p0Xm4WkA2DOB9Dw73vlBMC1SUS+sce9NVF0244/1/bVJjkbe+OeBVYvgaBJkI1jkTRXcKaShjE71kXkLb6cvDv7ogwXmjdDaI8hff6L2XYiRAdPTJMufi2iffrl3vZgKUBNz0M679a74xUgsSwZxLHAk0DYuVJFMbdhozCgeA8/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhgBG55SH5dD8E74pFIM0qZ50zdeixpdEI/AIS7eEzM=;
 b=DzQSunMV9p1T5aC8jPcOzDbETKAxNIgzMBjjR6RbvNzUhJCj47PiQaTB3dnYeSbNC5imcIxRVaKtQiHuAaeHbJHg7TLNLaKOYwC+lp4TKQydiNQU0+WWEtncADQ8lWQXK0TaU8nDWTgHf6ai+m+tQi64nvCYgdJpdB/bQcYItGA/L+XhI7Xx7+/fEceEykdIKSQmTQUqyw3N+5uLXRXkGuTisJOIjbXF/RqngWZlOwFfF81oYHgceTrQTVwMmej7UtfqRLUsZzT6uD7LMCo8/+p9p4UbALRygFO176RxKPe9fDZmWDslERQIoP6+A15YoArSTey8pfOH/YA7TESr7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhgBG55SH5dD8E74pFIM0qZ50zdeixpdEI/AIS7eEzM=;
 b=F06CF+z82U/DkpWYPhPOIYT4jrUrf7qY+C3IW2bVFC63NoE03+FSBHtxHiBC7NElFvLpi3WoWz9tnrIQrkBv0VWDzCHwgZCSCyWQj+TLK0EdVCSAPAXEVX0gyIhp+zPfxiPnvavFbsJRykTVCZKLlCxDpq6nyTpT4oCGpMh6lC0=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by BY5PR21MB1377.namprd21.prod.outlook.com (2603:10b6:a03:23c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 16:05:58 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 16:05:58 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 3/6] PCI: hv: Remove the useless hv_pcichild_state from
 struct hv_pci_dev
Thread-Topic: [PATCH v2 3/6] PCI: hv: Remove the useless hv_pcichild_state
 from struct hv_pci_dev
Thread-Index: AQHZZpooHkfzWrG4kUeVOvuCsbYlba8gCEQA
Date:   Fri, 7 Apr 2023 16:05:58 +0000
Message-ID: <BYAPR21MB1688B9918F1ACDBEBC9F24A2D7969@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-4-decui@microsoft.com>
In-Reply-To: <20230404020545.32359-4-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=21e35bdc-98f4-4cd5-907c-11edd73c8182;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:05:13Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|BY5PR21MB1377:EE_
x-ms-office365-filtering-correlation-id: 623e182e-4825-49e5-3e5b-08db3781f9b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hxfCXgdYytngXg2ml4Hu9RGn69HhAzGF8y8siV5JcT74gdFSAorv9Vc9gBOALiB5MZhYdw4y50ym5UFThwh3aj4eH2ttWHbG41gtM0gF3KlcHTTnR9y4lw0K62qj17h+EeaYsX0Z2v23fzM3zk7dbnUQkABKhOmSxvnO9IPotuWJWR4vkTOTldyKJf/P6LuhVB9daw1ZAGp5h8N/a8eabeqvLg9meRxarECV2187pOif6hnEPvQAHeUb7/i5ByFwiPnS4uKdFWrk05CxQA5C12hYVtao8Uw55WgPgdaZ6AIYnNP/gA5b5mp3T/1WAg33G8UPtpmZAZzUT2R3a72X21YQPH3Pa3aIbIDTxfXToQtQReFP91Sh2hdp7pGqUxtMRS1OmYXrm94ki4aKYSYPrXWf6pG2O+5qLKhhB9tnZ/o47PYXvGFyJi7Xa4P/fYCcX6bGvp+ZNJ03YfTsKigAu/BvgZa/N+k9L0mziiIyB2t5oG/DaqlcPq/Vtg0w0IJy6RmWd6CLQRYMstr3vvX4TDvyUjgUq4K5K9xc9x6F297Q3rvwWV1ERmC+9TBYk6vKrow21JOhoI9D1aC7U5PqGA9sAQ11J/P//7kTLNuO9bTSISYYnxMbT8FG6ujm6AhGswb7p28KdKbVSoDLDKjU9raUQ76YRl5adDFftfU9Z3W4/jVMnLV4wE+CZAuVOGv9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(66556008)(8676002)(4326008)(66946007)(478600001)(64756008)(66476007)(66446008)(71200400001)(54906003)(7696005)(41300700001)(316002)(786003)(76116006)(110136005)(33656002)(86362001)(83380400001)(9686003)(6506007)(26005)(8936002)(2906002)(5660300002)(7416002)(10290500003)(8990500004)(55016003)(52536014)(82960400001)(38100700002)(82950400001)(921005)(186003)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uFXikA6pGUZ+tnktXB2eUb5USi7K6nt4mETzYceGwGWo56XmKiXkjwM+k5vd?=
 =?us-ascii?Q?VZhO6oQF9QwgS3iT7B3bRi6icnWe5aHdPjRaPC0jFaNUAMl2oyb4CtkjTHz4?=
 =?us-ascii?Q?dVqnymshwYPATNHL3Rr6NV5alZZdxdCACH79XnhlSJbSOrQqdgXmVglc7PyF?=
 =?us-ascii?Q?dUBKsvi6tXDUQXNBp5G/VcZ9zHi2WhgIwLoFkz+1RvFYa7pPEAb26G8LRj/h?=
 =?us-ascii?Q?VLL1mTdLETluPe+UbuyRszEGanQt8IKq18R4XrQ6qA+p8WqB4AgBRfPNozcO?=
 =?us-ascii?Q?z0o1N29AWBhxmbihYCOXA8B42B8qh6JeQwRYg8ij8jP5O7NTetYu2KbAaqdV?=
 =?us-ascii?Q?/D3M/j/rZGNs3cFHPx/VQgMaFLixn76467yw5EMf4nFZwVfY1F1EEucMso+1?=
 =?us-ascii?Q?cGh/1cFpgcPZzLQfOg9uQrcObV2K1uA6k+xzmiqo55lGW3jQw/Z7VSOwNjul?=
 =?us-ascii?Q?44wgiDbbKCKWuCGgVATpCjU97jKSp9PD8jweq7htxQq91Xl148G+8HnSY9LW?=
 =?us-ascii?Q?hscgTd6rnfSdl8bpCvPxMz56ChfAcSLC8vGzXwlH2kcRK//xTYNhjVQ1+ZQp?=
 =?us-ascii?Q?WzZGRbldQb05pgdNMfP7jshad4m26XN8Eph3u9Pb5renbyPxqN44UKq8LC87?=
 =?us-ascii?Q?tQIG6TS+9iHOvtqTGVG/knSng2tTCTLGaPjbfDK/M6hFokizsZtS0S5wXk7Y?=
 =?us-ascii?Q?RfHBDibbNeV1lLnTVzUSFKW/Z2LGAcH8xgwrl2tyaAo8YzzOW8PMvFxsx80p?=
 =?us-ascii?Q?T6PCoTsk0lCwCzoeFw9ItBEGUn2dCR6Kz3ux/UrPHmupDFEVDlxRJW+nsbn7?=
 =?us-ascii?Q?km+C5jK9pr0PJNqIZGNCnYOCZau83z3rWpz8hjRbNRB0sD3IrNGX8GyeR2SY?=
 =?us-ascii?Q?TOLkzzAhIu+tQNIp8fZEDCDOvmFuhJhtGWm4zsxyTGvOerZUt2Rc349KRuEV?=
 =?us-ascii?Q?lUok7JGPus5v3Pj2eXHpkWQuzWuaqE6uvaLxyu5DZGp+kXWoZjJBwEP0IlY+?=
 =?us-ascii?Q?X6i0gjb2P7RDtaURO5Ec/vkSWXBMoKHTiEp/ZTE8K80HSVxfj7Ghz3V3EqZy?=
 =?us-ascii?Q?TQeH+BVkMldr8QjD8xG7DMg/4izpT1187q81MZF6GPRCF8ukCJ7FcdD5bLJp?=
 =?us-ascii?Q?jlYQjz0EkpgrcSfTpJJsvl+9DurgYOOPBVYozR8ofoLET3M0s+ja3mozGTdA?=
 =?us-ascii?Q?dnsZzdjg4BbmaIM2YwedSWeDgRMf3pvncoKSHMW0DQ1TC8KfIGiLJ231hfsT?=
 =?us-ascii?Q?uSoXMtJ02Xz1AZy7FTfVCuGc5sChijbK43IgWli7RDvM7IgrpaMS4/O+QzLv?=
 =?us-ascii?Q?5FozjZOvGQTDuZt8erQUK0x3yvrucX/8fWKdzf0/47Hm1Q5cywg5qE4dUTw3?=
 =?us-ascii?Q?R8c47nFJrlpolscz5CCSn6DS5OHTzkM/4Lw5eSBcxMC5vse77AMHFkCWapE4?=
 =?us-ascii?Q?xLwNViorMCDjvqgFSrhQiz36YzalOG3ggFMPGz6aE0xUV77nWTahCTXnWN/5?=
 =?us-ascii?Q?Zo4YxIuDCEbSntmwSKLkZwWcreNbnomwo1D148+clPq01rV5QCgPb1QrjaKn?=
 =?us-ascii?Q?CqFQQIoFlolot3dvyT4/Ldx+RCW6fy6E+RpE+9fFXAeQgKrJCYd/kYZ2jelk?=
 =?us-ascii?Q?ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623e182e-4825-49e5-3e5b-08db3781f9b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 16:05:58.2415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 40LmSwQM1VY9foPHKSUglq/SUDEnOKLKg52XUCtbBxgIdzqt+oDtRQu4PeVCgBNLoQyXEZFZHfjyTi923HikPYqTGJs+ej7JTk68PJQNMBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1377
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com> Sent: Monday, April 3, 2023 7:06 PM
>=20
> The hpdev->state is never really useful. The only use in
> hv_pci_eject_device() and hv_eject_device_work() is not really necessary.
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/pci/controller/pci-hyperv.c | 12 ------------
>  1 file changed, 12 deletions(-)
>=20
> v2:
>   No change to the patch body.
>   Added Cc:stable
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller=
/pci-hyperv.c
> index 1b11cf7391933..46df6d093d683 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -553,19 +553,10 @@ struct hv_dr_state {
>  	struct hv_pcidev_description func[];
>  };
>=20
> -enum hv_pcichild_state {
> -	hv_pcichild_init =3D 0,
> -	hv_pcichild_requirements,
> -	hv_pcichild_resourced,
> -	hv_pcichild_ejecting,
> -	hv_pcichild_maximum
> -};
> -
>  struct hv_pci_dev {
>  	/* List protected by pci_rescan_remove_lock */
>  	struct list_head list_entry;
>  	refcount_t refs;
> -	enum hv_pcichild_state state;
>  	struct pci_slot *pci_slot;
>  	struct hv_pcidev_description desc;
>  	bool reported_missing;
> @@ -2750,8 +2741,6 @@ static void hv_eject_device_work(struct work_struct=
 *work)
>  	hpdev =3D container_of(work, struct hv_pci_dev, wrk);
>  	hbus =3D hpdev->hbus;
>=20
> -	WARN_ON(hpdev->state !=3D hv_pcichild_ejecting);
> -
>  	/*
>  	 * Ejection can come before or after the PCI bus has been set up, so
>  	 * attempt to find it and tear down the bus state, if it exists.  This
> @@ -2808,7 +2797,6 @@ static void hv_pci_eject_device(struct hv_pci_dev *=
hpdev)
>  		return;
>  	}
>=20
> -	hpdev->state =3D hv_pcichild_ejecting;
>  	get_pcichild(hpdev);
>  	INIT_WORK(&hpdev->wrk, hv_eject_device_work);
>  	queue_work(hbus->wq, &hpdev->wrk);
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

