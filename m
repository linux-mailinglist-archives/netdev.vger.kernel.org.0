Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FB36CEFF2
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjC2Qzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjC2QzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:55:17 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020019.outbound.protection.outlook.com [52.101.61.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57576592;
        Wed, 29 Mar 2023 09:55:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTS5DIhSV6xLT7XiE9e+et7Pxz6q7HeuFvAtmgEotOJdkIxp+oQaGbT15cgFbKRt0NuCcLGZdAVWX4cClSv3Br6/gx4piCfjmExoIm6/THjzh4HQqXj410oFTXfKkGydaL26Qv5vIQgH6qMIkPa0JQosRC26gsmkTMMRSVUNlwHqeETG0mGcAulkE2c2skIvQQVHwFIFqIRE4mh+3KSFUyYtKUtfsmuqVdsrPpWm9v4gbx+6vq6fZYHB5JsO37tlios6U14xE5z0wp5tss2phE5sr/6qBQn5ru1tJo6YGUZuX/4yGnNtyXJ1/UwT+sF5i/KVsosHZVR/8xwyZ0trNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKNsvxkpU/T7p0MXXhb6BItXezxwKqS92g9BQO8FVrw=;
 b=L/FngbHqM9q6/T7fmU9ECjLIBx86PGo9n1Vmxla3IDnNSVQb/14vsm7I33723IWdZqWctM3YRNL/ymNfcgL2zwpXNImd0+KFJ+mP67zNMhoyXufR1abSXs+rHUHTAiWvZpqbrmMjVpUggZypjAQv8lYEn5+uyDDeqEdkqnVdPj6rnu4wyXlZAlx4PvyYiKgTfEy/KLpv64afgzdEe1bdCJ+bMGiKp1dSeYEYkB01bWdN6EOUqSmhVch8APdcS3Q6GR3wfePLCKCXU0PnmVIS9U2UwCtHcTMB2osqCBIf+FoMWcIdcPLo5bqYxEK/r9cqoL/tNaGYLjGzLi/ZZdjaMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKNsvxkpU/T7p0MXXhb6BItXezxwKqS92g9BQO8FVrw=;
 b=V9JNErY/yOpXV4nRNMBAaLZpntVGDUVbXLCwE+PRUEzdZhrDYjOvGm4B2fde3pngPheJgKCLAGHhS6BK4+TRt7wZPTzfPKaqt7Ipgge5zkMKvqAQqQ3ip5Psm/DLBlzdYDLdIOnx8plQJH6CODiNLSkObkcWUzAsk1CrbSwGbkU=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by BY1PR21MB3966.namprd21.prod.outlook.com (2603:10b6:a03:522::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.10; Wed, 29 Mar
 2023 16:55:08 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6277.010; Wed, 29 Mar 2023
 16:55:08 +0000
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
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZYTE3Y7FHmXDCGE2Fxs3dSXPnlK8R+TMg
Date:   Wed, 29 Mar 2023 16:55:08 +0000
Message-ID: <BYAPR21MB16882A3C717721090777D308D7899@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-7-decui@microsoft.com>
In-Reply-To: <20230328045122.25850-7-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c1c38967-f9ee-4864-a2bc-af561a32b5d8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-29T16:44:56Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|BY1PR21MB3966:EE_
x-ms-office365-filtering-correlation-id: ed61f4a8-f3ce-4a7c-2865-08db30765a8e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zLM4ga1LaSw/9+tA0DaUkJbMYSLtsteKCzVOqWdSClqZm+8/geE/9AuI02qWIeCdZlY9oi3SgwDzFr7QQsVz2g42saTfJ0dlQw6cTt7UaWb67DsBoUdUstZXbbM9z/KXWOJdjL9bipUDv3eBpd04ICsKZrifO6cZD43ua3hhWWX+aELZ0VdZcO2KBBbbR9NQyTbxigJcrwFWxL8KivOkpCVvCrU858rTy8Qd22i3PdgrQ+LiFDfO7ca+zcxN2EbHMJIu1Cvz+JAy0nCipZl/b2Vsks0BmJR6hhj3lqUQFhvVXfKzdk5r+3QDqgLy+G0uGhzYn939/Zw5O3hwPpcJ8WIpVkTnYiKOBHpPaxpjmwLDyfBujOsPmO352iilUHHZBjnEb3vh/X3ggxu6hub6cfzRB1s/WARaBMzykLIzeSFymwDaAKiVrA1/8nb1n5pCtSPqrYt7XoPmu1MZyEbyC2KLUJk9F1xhA6Udf9OxMWKOfjZPvnswp3GVeYsZONfKFb0FWflAXRkk3SajVsFnmzHx9DmhxlVD9ibBbfgFt+DKYyNhkDoGUziCjRQEx8nlEZmTxCD2VlCuxr/T216/lMrH69b3wvnXd5ZkoD/URZQ9dKHbxqoRFgZj4iFT6IIOV5bLa38z3AA2/z6KaY0I1a9haTlIVjJIxP0DByjLOUJRAHaSHQYj/ru1cqxyVra8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199021)(2906002)(8990500004)(10290500003)(41300700001)(83380400001)(316002)(66556008)(71200400001)(7416002)(8936002)(52536014)(54906003)(110136005)(66446008)(4326008)(64756008)(8676002)(786003)(66476007)(7696005)(55016003)(478600001)(76116006)(33656002)(66946007)(86362001)(186003)(82950400001)(122000001)(5660300002)(921005)(82960400001)(9686003)(6506007)(26005)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d0siNzxFIz7lEknsSodjehfznKDaqRa9CVSkSOqlHbns/30XFL3OPXeQCeca?=
 =?us-ascii?Q?GEgARmUPf/qsF16Bphg3F53jKYDK/L9JnqY3IA1J1QhTmCFAqiJH/cS8jgpH?=
 =?us-ascii?Q?gCXd5p7+rYORQq1dhE7EaIuWyg34CbA11Z1JclIMOMboUWXYqDEl87yWYIVc?=
 =?us-ascii?Q?bJcl6TN0mt5ueeU8+CKoXu8pl8F1+t5gs0MZPsWAAl3+o5lCFAs0CNmWanMu?=
 =?us-ascii?Q?4a0hl3yXSvMv/K8vyHpIfqECFAt4//09nYJHtghAE7kcpqL4RgdGAI+OPArh?=
 =?us-ascii?Q?onxqDEmfCB+aNbyMO3a60PUZlrh7vNorp+QCXuNpah1ez++mt5Gj00+NEcod?=
 =?us-ascii?Q?vkWnN29mZoi8YD94A/pZkfp5bV8RIPukVRikK0eGYbEM1Kp4mXHmBk3ViRvv?=
 =?us-ascii?Q?+G/dfhpo9liyi3ysPn/LBUIwdTTj/R3ZEYfsSay90tkD4jxrb8HsmraRVTDU?=
 =?us-ascii?Q?oyGLnHoYL0JX5aLAqtVTOCzSrIyC/kuxyjaD+X/eGAGFpmvxRs96EdyI5GZ2?=
 =?us-ascii?Q?IABNiMX75D3diRk8ssGQSeBTzmi7DwximT7vBSA+PAFaYabZ5BlGG6ZB3eMk?=
 =?us-ascii?Q?xUOMXkwQ4uD4vWt5kQYk2/P6g/dStQBpLC2oTqqJagc6czkkt5VIYUfMp18Y?=
 =?us-ascii?Q?8tPDVZ3P0LXXfN1mnX7CVBBe9TSCYxfvxIDhpS6TURrB/tO4p7cPw8NXqgxx?=
 =?us-ascii?Q?tOoKS/p/1mGRz/C9ZsuW0c6LYOtgEvoGBsVHZye54nd47CfTtryG/b4ZW94o?=
 =?us-ascii?Q?l7Q/TTFvTvHk1CiJBWSsgWP5/EqV5y9tS7FswzRdlA+riBEYHsZsd/8B29ks?=
 =?us-ascii?Q?AxkbWuqfaWsUYuKiDvegeSwlgdQeKQHsKdooWi1s7dOKKEnFfHiSZic4hoZC?=
 =?us-ascii?Q?Tebz7XvLiZ1LoFXnOjRzptcNibnRsPErWwf50nld08VGVNAIC2nS/DYmydoN?=
 =?us-ascii?Q?wy+W9lY+VwDGE4u4wtLkl2NR4aXgJsz1eiCoM+OZy6fPAZSZZVFUgKOYNFRm?=
 =?us-ascii?Q?xNkhShX288uzOtgkROkbvDb5Gqxotj7RSVNHiCHcS5zzlqCb1je1UMCzpP77?=
 =?us-ascii?Q?eiKYNhO0yVj7Xvk2CcxtwkC3KZytcsuB0/R4XKxUeeHI0yWovAWfPkTEI4dl?=
 =?us-ascii?Q?KVtrOpOlH6VIb5KM1xA6vrxxJV+Y6V8aDY3Nvl6DSZiHdje8AX4tN2wyMkrY?=
 =?us-ascii?Q?1mOZz6vN4DAPDIu228PuyMwzSNvCxdDeObtKYCl3FZQo4NsRm1V6AP4hoOhI?=
 =?us-ascii?Q?fkPK8uB/22ApN4adSVBR5NuYtXCntC6bDvYU686xO6Q8SXafAzXPiV8bSsYr?=
 =?us-ascii?Q?t9OC51xRDqiisddyiv7xX7Wk9HmkSyIoYZyZCEfG3o2EkrhAsnT8MQG5iDzY?=
 =?us-ascii?Q?7gw8DLbL0CI7nNMjfZOZeWL5FNrwcUwfmMgwsSt08BRbj+i+93w+jpHE8vPs?=
 =?us-ascii?Q?VLRg/WLGE6RlPE0roxDh4xrkGsO1whTjpu7CyQlpiSkvE/l2PFDUdS4FkcD3?=
 =?us-ascii?Q?49r21xqNsVfgDvAKibsSRTv5RWvFE4qJp5mY6bT4asIHoHyecFsydjfsCrkX?=
 =?us-ascii?Q?EYJufYbnzrUdvqyLTASE5a+LglZYvYyzYo6TcpeetDEqTa51aZgfaFRujD7g?=
 =?us-ascii?Q?LA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed61f4a8-f3ce-4a7c-2865-08db30765a8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 16:55:08.6423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hOla9tCD4WbbsasKvbIAVVQeTuG47zybUrstArZ6XG5HtdTh4RAsbjXuetAzDcs+FVz4n6o2/I+r31tWF6nwY7jH3oBpC1R+3Ev88OtXycU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR21MB3966
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
>=20
> Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added the
> pci_lock_rescan_remove() and pci_unlock_rescan_remove() to address the
> race between create_root_hv_pci_bus() and hv_eject_device_work(), but it
> doesn't really work well.
>=20
> Now with hbus->state_lock and other fixes, the race is resolved, so
> remove pci_{lock,unlock}_rescan_remove().

Commit 414428c5da1c added the calls to pci_lock/unlock_rescan_remove()
in both create_root_hv_pci_bus() and in hv_eject_device_work().  This patch
removes the calls only in create_reboot_hv_pci_bus(), but leaves them in
hv_eject_device_work(), in hv_pci_remove(), and in pci_devices_present_work=
().
So evidently it is still needed to provide exclusion for other cases.  Perh=
aps your
commit message could clarify that only the exclusion of create_root_hv_pci_=
bus()
is now superfluous because of the hbus->state_lock.  And commit 414428c5da1=
c
isn't fully reverted because evidently the lock is still needed in
hv_eject_device_work().

Michael

>=20
> Also enable async probing to reduce boot time.
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/pci/controller/pci-hyperv.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller=
/pci-hyperv.c
> index 2c0b86b20408..08ab389e27cc 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -2312,12 +2312,16 @@ static int create_root_hv_pci_bus(struct
> hv_pcibus_device *hbus)
>  	if (error)
>  		return error;
>=20
> -	pci_lock_rescan_remove();
> +	/*
> +	 * pci_lock_rescan_remove() and pci_unlock_rescan_remove() are
> +	 * unnecessary here, because we hold the hbus->state_lock, meaning
> +	 * hv_eject_device_work() and pci_devices_present_work() can't race
> +	 * with create_root_hv_pci_bus().
> +	 */
>  	hv_pci_assign_numa_node(hbus);
>  	pci_bus_assign_resources(bridge->bus);
>  	hv_pci_assign_slots(hbus);
>  	pci_bus_add_devices(bridge->bus);
> -	pci_unlock_rescan_remove();
>  	hbus->state =3D hv_pcibus_installed;
>  	return 0;
>  }
> @@ -4003,6 +4007,9 @@ static struct hv_driver hv_pci_drv =3D {
>  	.remove		=3D hv_pci_remove,
>  	.suspend	=3D hv_pci_suspend,
>  	.resume		=3D hv_pci_resume,
> +	.driver =3D {
> +		.probe_type =3D PROBE_PREFER_ASYNCHRONOUS,
> +	},
>  };
>=20
>  static void __exit exit_hv_pci_drv(void)
> --
> 2.25.1

