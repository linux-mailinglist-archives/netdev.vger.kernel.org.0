Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105B96DB046
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjDGQKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjDGQKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:10:48 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020021.outbound.protection.outlook.com [52.101.56.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B60BBAB;
        Fri,  7 Apr 2023 09:10:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnAs9bEnZCElMuWY2efx3KEt01Eg9pmYk3OpevddLBIKh/3bU2JN0+MomsIbbBRnDkiW9uRqsyci9mDmBdZeSVAgd2VLBcHqZWCaRfSn8uPLXWI2xS+2aS+mmDVt52SoNuOa43IS2fDpG+lOOfGpvGWt+qDBjLr5TVlLZJzRycSc+C8FJgxEU3WA/ITe+kmSsmEx779lRXOf5cy+xhprACp0jLCH6xa2m5j/0X5s3mDfxm8cBiBn8oLKi+rZJauWj93YiJe4XIUB/75o56oXHgckiLqwCvTy8lpXm5bipIo+xNP89gCgovDet7zhi3mhYL9V9fzQo3boeCpe4igmfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlN6NTc9Rtd8ba2ZL/V7QIpIIZ0kckiZy+N7la9YvT4=;
 b=TP1PexhfGV5lNGqY8BtkH4XRnOETn3dkGvcOXpu+ZXlsoxbBWRh0bBCHTS3zl9gdlpTrm6SllOQflm1430assiOJolgbmgRocT/aCnw9A9Gjse85IPqkbHtH9RYve3DfXy82tg8PI9QLtXdkqMWuRS94aQ/+8wu0BqeHFx0ZL38XMfqn/M5aB0bpjUe7pVuH/3NkEUBDwjROxsAdo/dlkw3CdfEhfXWhU92DuRsImApg/r+YwkJqa5BbH52U5/zDlIve3RdTM7+zpUcz7kN6bUENniPvYyeAzu8fU4PvJlMYME0uBfWi8PScI1XrDDmqR+0Buf0iiiS3clI1tXA/BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlN6NTc9Rtd8ba2ZL/V7QIpIIZ0kckiZy+N7la9YvT4=;
 b=ZH41tJd71kPo5X+BNh3MQovRnIMc03sxoOmNquCkS41S4JyNlzbCZS4LMT3YTla6ev16arGBA+pqpTaa6zCnz/cMCM9iDlx8z/P3KIreYIptEkMd5EmSCP1/gopAd050CPQYP7x057gnpwSWIUbCiwaaGE5lCD4W7zHUOfRze+Y=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CH2PR21MB1397.namprd21.prod.outlook.com (2603:10b6:610:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 16:10:31 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 16:10:31 +0000
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
Subject: RE: [PATCH v2 5/6] PCI: hv: Add a per-bus mutex state_lock
Thread-Topic: [PATCH v2 5/6] PCI: hv: Add a per-bus mutex state_lock
Thread-Index: AQHZZporLr+yOqyeBUa77TCgr/BqsK8gCXYg
Date:   Fri, 7 Apr 2023 16:10:31 +0000
Message-ID: <BYAPR21MB1688BE7ACC049989A3EE400ED7969@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-6-decui@microsoft.com>
In-Reply-To: <20230404020545.32359-6-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=03ed871d-4a9d-4628-873c-9522ac3f8dc6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:09:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CH2PR21MB1397:EE_
x-ms-office365-filtering-correlation-id: ceb9e91b-0864-4441-c973-08db37829c49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cdlgedbhz9BxkuhVIZXmq819rGtxlclPxFAQ/orqsQUrQ2Q1jCMKoH1F4G+09ORt1zs6Czk/hTnTg5pGZZS7HXVOr68XwCOJ/KhwgJ6VbhZfX0KLBS+A5w44isNVgbmxf8QCqvNQUYap5JFG/dXfwSnXctyetAjk3c/2aFfmsjUT9M2b9NaSuHVZdWjg7y549X0RDbajsPgtqF1vDu9/ce1obbQfqM4O7ioG+RJ/RFVLjAkt2LkRvNLkCgDM/9Mdqs7bNjzFC2gnI8llgkVhAI4xnWF6wHFgadZPi4rEk+y082jHZgeVQaajMqWiLXEHVr17DSKW/whAD4q92Tb2EOCCfM71D451hRbgMga8E9bHdDIppMLsNO97AxZNrmDgiHU9isHbWhm31gDt4YtaJ9bRSXrIqL3pEybforizljw3sKL+I08H/e6+2HXP8nWY8zHHI11ymmZ4KCgv9dIFubz1AVVij7GLc2RNWSyrFb2I6HKTN+eJc9mK4jARuJpzQB9w1xQ14jtXwpHluLYkVnlrpbL1/g2p6hUnjBRcF3z82qBDu0VHWEXCCGI3464+Ti8KJ5id5Q/DoH9oqAFw7H76AJV1Y2tL5HRX75MXCccOYa5GxPVmpKEldLrF7T9t+rFp9ErDz41DGgD1ypQvnioYibHOcWJUo9j3xl9kM7NYdI3rN+HKY/AIaeaSvbB+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(66946007)(7696005)(66476007)(8676002)(478600001)(4326008)(66446008)(64756008)(71200400001)(54906003)(66556008)(41300700001)(786003)(316002)(110136005)(76116006)(33656002)(86362001)(83380400001)(9686003)(6506007)(26005)(8936002)(2906002)(5660300002)(7416002)(10290500003)(8990500004)(55016003)(52536014)(82960400001)(38100700002)(82950400001)(921005)(186003)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uoEz0A6vKALv89DNqtpuOBKsST8aNo1FU+OGcFKeB9YUOK39TqO9Wjyyk0oE?=
 =?us-ascii?Q?mxzqqQErJ3snVadhTwAUoi07dw/9T21SWxuQaGZrkGS4fUw4UJXSaViXMAJ6?=
 =?us-ascii?Q?Qolgkx2Ed0aw/xcmorFzUUSTtVhceJ2tcU0BRnjx+QeulmEjPA7HdiVSr32e?=
 =?us-ascii?Q?HSueMZmjStw5AKkZmGhDJHUH8YMRaesKYZmtqJxrhwtvRe4pQ88e8C8ywKcw?=
 =?us-ascii?Q?+YKaeWuet2PxKHDz2EDy4NwcNbsfm5ijwbjCHmIgVqPLdvW/fw7F1iQeq6J0?=
 =?us-ascii?Q?ruB97X2sRrXpsFXCDflxDf9W+GL6RvX9ENZAOTaAL8aBkliVYI/tym8BoYjF?=
 =?us-ascii?Q?0CZeoIEySGKrUcbMCUfvDRBFZYGzis6A3E4scNl6wasFqlNB+Iq2m7QPrHpe?=
 =?us-ascii?Q?Nbl8Q59zkw3pUpPlnQt/VJ5E+u7WIx9qWMwq+hCONccHJQMwGkutzGF7vhvU?=
 =?us-ascii?Q?2iDsplUcaIbgY8+TibBGI/kxzqfsgT1sk76yEuVLMNMP7rM7r42L1nZRd9CS?=
 =?us-ascii?Q?T0jRKQuwpmzoe0SLRan/8EuztBmOQH6y316fJABZVsZeo8P0uAPRqceqWJ8d?=
 =?us-ascii?Q?eAuspFNX3XdvxsMjlVecwSgfJ90h+UCAcdcCrohzQyabKjrFYOc3aUsa24Ho?=
 =?us-ascii?Q?Pj+4kA8cPlR4d3VlYufh9gET+gf63TLZZs5NKk93JYexNspfD2Tmx4GX5AhJ?=
 =?us-ascii?Q?OYJTomu4aEoomzYrIxUEo+93FIsBzeMndx3m92MeNMns1A3x4V+pLO/Ext1q?=
 =?us-ascii?Q?L/52zKOLqmHzPjF9YiOrDJ8e5Lghtkv+UXT4qBLzbkB1dxftPRbJ2BXtuwL0?=
 =?us-ascii?Q?CIXQyAicTParapgyVqXNde7wDwYUjgOQREX/HMVIbbquER5kWy5yLtWLBqGg?=
 =?us-ascii?Q?bllPjvi3w777/g6trTfGbLAA6cQVKvX+tnY/l4vGXBVqiJ49GluV7P6tB/sw?=
 =?us-ascii?Q?nsD4mVaWQHOpNNFvd8xE5AadWxEB+kIHOBJ0Q3+dcGLdOXRnv4z+er2Z7Gjc?=
 =?us-ascii?Q?RGIvqguHlM8mytW0iX3RF/K1cz6ZN5xF+511kKYRPhb+iYN9o92eSCT50shE?=
 =?us-ascii?Q?aEthOrmRnupg/q4PWMWghlohQYqQu9XgO9rbHdTnFSF6gscmACxotisx5PKF?=
 =?us-ascii?Q?JHsJj7MCJerbUfIx7slRa1Pe9WxYs0ntPYSiw8NkQ9s9u2PYCCcRHgmv4lzx?=
 =?us-ascii?Q?vtf4a/66Fh5xIyGdUh+p4JwOgeCVydHVkbgBDeXM4nHtt6WYrSR+SAXWsH0k?=
 =?us-ascii?Q?icrqNNsaBNKzx8YSACScL0FkbTtMRssHhxUS/rjIAgDdPBfLINc7bKVQ4lYx?=
 =?us-ascii?Q?zgwtkK9ijbsQgrGum1yec9Elq8o9brGQ6uLgbR1EP9A4KBKbi2b855poZ6UJ?=
 =?us-ascii?Q?FOsWEz9RS++IltVmrxcgdoREYB2fx1FXDwdVwxxetIUyl2L/D2uvJ867hDBR?=
 =?us-ascii?Q?XvJGuI/kiwryTas2MqMtHuo25ESD3m2Z2hJjFgLL10EzBqVc2qXFj/GhqPAe?=
 =?us-ascii?Q?Dbg3g+trJXvTxJchOWJNUm/9Frq5PPkYwVIuwOH/SspH/eHFL64nEhTTs9cB?=
 =?us-ascii?Q?fSXQMvWaXg3WpA1JbGohvlSmmNgFtQX36yuL/ImBUzfMx67blbN6dqKb3k7P?=
 =?us-ascii?Q?gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb9e91b-0864-4441-c973-08db37829c49
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 16:10:31.0244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mU2a/WEb2CT/jwhttxlBTJAsszZv59WtQoKbAshjdtICPtNQ4OkPWtlg5VPX0QBHq952Eg8FErkFvsVvErmazS3BNsG9Oh1rK6v4JhaI8v4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1397
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
> In the case of fast device addition/removal, it's possible that
> hv_eject_device_work() can start to run before create_root_hv_pci_bus()
> starts to run; as a result, the pci_get_domain_bus_and_slot() in
> hv_eject_device_work() can return a 'pdev' of NULL, and
> hv_eject_device_work() can remove the 'hpdev', and immediately send a
> message PCI_EJECTION_COMPLETE to the host, and the host immediately
> unassigns the PCI device from the guest; meanwhile,
> create_root_hv_pci_bus() and the PCI device driver can be probing the
> dead PCI device and reporting timeout errors.
>=20
> Fix the issue by adding a per-bus mutex 'state_lock' and grabbing the
> mutex before powering on the PCI bus in hv_pci_enter_d0(): when
> hv_eject_device_work() starts to run, it's able to find the 'pdev' and ca=
ll
> pci_stop_and_remove_bus_device(pdev): if the PCI device driver has
> loaded, the PCI device driver's probe() function is already called in
> create_root_hv_pci_bus() -> pci_bus_add_devices(), and now
> hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able
> to call the PCI device driver's remove() function and remove the device
> reliably; if the PCI device driver hasn't loaded yet, the function call
> hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able to
> remove the PCI device reliably and the PCI device driver's probe()
> function won't be called; if the PCI device driver's probe() is already
> running (e.g., systemd-udev is loading the PCI device driver), it must
> be holding the per-device lock, and after the probe() finishes and releas=
es
> the lock, hv_eject_device_work() -> pci_stop_and_remove_bus_device() is
> able to proceed to remove the device reliably.
>=20
> Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsof=
t Hyper-V VMs")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>=20
> v2:
>   Removed the "debug code".
>   Fixed the "goto out" in hv_pci_resume() [Michael Kelley]
>   Added Cc:stable
>=20
>  drivers/pci/controller/pci-hyperv.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller=
/pci-hyperv.c
> index 48feab095a144..3ae2f99dea8c2 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -489,7 +489,10 @@ struct hv_pcibus_device {
>  	struct fwnode_handle *fwnode;
>  	/* Protocol version negotiated with the host */
>  	enum pci_protocol_version_t protocol_version;
> +
> +	struct mutex state_lock;
>  	enum hv_pcibus_state state;
> +
>  	struct hv_device *hdev;
>  	resource_size_t low_mmio_space;
>  	resource_size_t high_mmio_space;
> @@ -2512,6 +2515,8 @@ static void pci_devices_present_work(struct work_st=
ruct *work)
>  	if (!dr)
>  		return;
>=20
> +	mutex_lock(&hbus->state_lock);
> +
>  	/* First, mark all existing children as reported missing. */
>  	spin_lock_irqsave(&hbus->device_list_lock, flags);
>  	list_for_each_entry(hpdev, &hbus->children, list_entry) {
> @@ -2593,6 +2598,8 @@ static void pci_devices_present_work(struct work_st=
ruct *work)
>  		break;
>  	}
>=20
> +	mutex_unlock(&hbus->state_lock);
> +
>  	kfree(dr);
>  }
>=20
> @@ -2741,6 +2748,8 @@ static void hv_eject_device_work(struct work_struct=
 *work)
>  	hpdev =3D container_of(work, struct hv_pci_dev, wrk);
>  	hbus =3D hpdev->hbus;
>=20
> +	mutex_lock(&hbus->state_lock);
> +
>  	/*
>  	 * Ejection can come before or after the PCI bus has been set up, so
>  	 * attempt to find it and tear down the bus state, if it exists.  This
> @@ -2777,6 +2786,8 @@ static void hv_eject_device_work(struct work_struct=
 *work)
>  	put_pcichild(hpdev);
>  	put_pcichild(hpdev);
>  	/* hpdev has been freed. Do not use it any more. */
> +
> +	mutex_unlock(&hbus->state_lock);
>  }
>=20
>  /**
> @@ -3562,6 +3573,7 @@ static int hv_pci_probe(struct hv_device *hdev,
>  		return -ENOMEM;
>=20
>  	hbus->bridge =3D bridge;
> +	mutex_init(&hbus->state_lock);
>  	hbus->state =3D hv_pcibus_init;
>  	hbus->wslot_res_allocated =3D -1;
>=20
> @@ -3670,9 +3682,11 @@ static int hv_pci_probe(struct hv_device *hdev,
>  	if (ret)
>  		goto free_irq_domain;
>=20
> +	mutex_lock(&hbus->state_lock);
> +
>  	ret =3D hv_pci_enter_d0(hdev);
>  	if (ret)
> -		goto free_irq_domain;
> +		goto release_state_lock;
>=20
>  	ret =3D hv_pci_allocate_bridge_windows(hbus);
>  	if (ret)
> @@ -3690,12 +3704,15 @@ static int hv_pci_probe(struct hv_device *hdev,
>  	if (ret)
>  		goto free_windows;
>=20
> +	mutex_unlock(&hbus->state_lock);
>  	return 0;
>=20
>  free_windows:
>  	hv_pci_free_bridge_windows(hbus);
>  exit_d0:
>  	(void) hv_pci_bus_exit(hdev, true);
> +release_state_lock:
> +	mutex_unlock(&hbus->state_lock);
>  free_irq_domain:
>  	irq_domain_remove(hbus->irq_domain);
>  free_fwnode:
> @@ -3945,20 +3962,26 @@ static int hv_pci_resume(struct hv_device *hdev)
>  	if (ret)
>  		goto out;
>=20
> +	mutex_lock(&hbus->state_lock);
> +
>  	ret =3D hv_pci_enter_d0(hdev);
>  	if (ret)
> -		goto out;
> +		goto release_state_lock;
>=20
>  	ret =3D hv_send_resources_allocated(hdev);
>  	if (ret)
> -		goto out;
> +		goto release_state_lock;
>=20
>  	prepopulate_bars(hbus);
>=20
>  	hv_pci_restore_msi_state(hbus);
>=20
>  	hbus->state =3D hv_pcibus_installed;
> +	mutex_unlock(&hbus->state_lock);
>  	return 0;
> +
> +release_state_lock:
> +	mutex_unlock(&hbus->state_lock);
>  out:
>  	vmbus_close(hdev->channel);
>  	return ret;
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

