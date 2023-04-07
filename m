Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B16DB01D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbjDGQFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjDGQFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:05:16 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021014.outbound.protection.outlook.com [52.101.57.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F397110C1;
        Fri,  7 Apr 2023 09:05:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtroAwhFSsSaj/YcAJe6Xyb70EVJxryv5LzJL6Wp50kXDdxtobM3nUchtiVRAfnp9wP9w4z0qAV6bx29YO9Olpb0jZNRpunZ5wKgGJMq2lgnbTNfx+gmPapsKOXdERZZPwS23yV4aQAjhuf/rynslomFQhlRnH6auKS4BEam2dbWqQdBOTlrN5c5Me9/ZyaOwnNELvg7J1eqj3enLQRUniZrHJmCWXY4lr8YXVoQUfzotGZA9lpEo5b+4RPNf1OTVYHOyqWPebuA4XsbPFTq1jkcG6JPiirnIOmAcPdpkV/TlHFM6d7pTQqjdHEjvZhuG89O71gDjszP8epxsnNASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AL3XulnDAy0sptUzVFgAutGH7bCvTnyo40aNcg55xPY=;
 b=ffD7YRKD1Wq9qZEgoZmkANH/js62U9dBBa+FOSxcyzYGyLhdNu0Rdy4QgRq7iTUO1FxG+V+54bv8Z1qrtMIlbisd+HsG+Qa1btxsyCxPt+gkkU3Bg2om9gRrgrQKagJ/yXYVBb3SEApdS2MKq0YaH2q6TWFHmThaNm7Su6uxl2BwXwblXOOvLbi78v9Zu+5n/J+bLLwbWgGqYiBGZxFF2pOjLmgVMVrlstK3ScRfb3BVoyOxQ2G4qr/f4o4+1hqdv0YtCtG1p9ZQwOgQDI1fdF7HtGe1y0VILyZXDWQeaJ3c14pDCokzwVBF+JPoU/glgJk/jkbx+FthmW8IM95DjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AL3XulnDAy0sptUzVFgAutGH7bCvTnyo40aNcg55xPY=;
 b=bCffLV50BJIzDNLncxr0MvwHupuDqn9fDvBzEx6eM+dxT7+uGQ2XcR8XJyBF0Y1YQCxfCNLQwekIQAU9ybfCqEG5+FrYrO2QCSqsfXtZrhheo84FMGuyeUXF4vvXE/1H4HayihQsJRTZMSVIBiVWdW6kIuNdzOa30o/i8ezRlfM=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by BY5PR21MB1377.namprd21.prod.outlook.com (2603:10b6:a03:23c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 16:05:11 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 16:05:11 +0000
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
Subject: RE: [PATCH v2 2/6] PCI: hv: Fix a race condition in hv_irq_unmask()
 that can cause panic
Thread-Topic: [PATCH v2 2/6] PCI: hv: Fix a race condition in hv_irq_unmask()
 that can cause panic
Thread-Index: AQHZZpon0D2sNVtizkSC86Mno+32Cq8gCAFw
Date:   Fri, 7 Apr 2023 16:05:11 +0000
Message-ID: <BYAPR21MB1688D11FC50A2B43564D21ECD7969@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-3-decui@microsoft.com>
In-Reply-To: <20230404020545.32359-3-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3ac78d69-e229-45d7-97c9-020d3fd19218;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:04:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|BY5PR21MB1377:EE_
x-ms-office365-filtering-correlation-id: 462ccef8-8eb1-4677-2870-08db3781ddb5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /5/yOlT5/tFyBRP0Sma+YhQ3lY5oAIuX4e34TyzMLbh0Dj/3d0IvP2lfY177CmUpvGzUC8aHGNJOhpO6Q+bIbs62f9dyXUEm0nkiTOsnWxrU/eLok8rNFd+dwEnStaqjisBfqnb28aqxI4x7/S6gGeZGWxXWvHYmioppYrUZNuJvK1YlJsw4MLuBoTnA9EFKxPg3IzFoDgRzVk4NYktCSea4+x7peyrt2GKlJJyklzxPx7R8Lh+E/OdyHi9T3SvIv6yhlIkfRafCg1uMHSSZw14wxnbxUl6vFVYdFXmd9NAazwqdHTbmG4HxwvKYPzCxT7J+iNC34GWd1lbjeFBuy0tHcNSTGUEu9RcQJ2c8TuTyN8BU+PY//ZRuWWDNBaClbXNiZIRmzqTCvPmfE5cuX3yP1BCpi9DB7ZzNxkudX6h7UNZaA/VXsNC27aKlLxikxl8xd0YSXaWlt6vWPn3Wdy72rvVgrc2Pq7CUJLfFi1TrCPP4pHs/hp54zPQuGvuEWuz/J6Ot2WmVkJkCIbEf2cFPmCWBrfsYgqXeO4Gj0arzpBtxRbeE/VfrvlF7p0MxkcGeEUiXYSKhd6AREG35DwMq+P1XQOK/MYLKUaqOHPJ6P4j6cyHN2nQjZj5xQG4oJYvVXYrOBskxVSzfv9WBM+W2KObdhxtZjYfn8uVdoXHzmXfeWQ10zT7vQidhWs9e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(66899021)(66556008)(8676002)(4326008)(66946007)(478600001)(64756008)(66476007)(66446008)(71200400001)(54906003)(7696005)(41300700001)(316002)(786003)(76116006)(110136005)(33656002)(86362001)(83380400001)(9686003)(6506007)(26005)(8936002)(2906002)(5660300002)(7416002)(10290500003)(8990500004)(55016003)(52536014)(82960400001)(38100700002)(82950400001)(921005)(186003)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ol74gDpaIB//AliBRU40ZurpTtl+lidsGH9FdH04gg1rCFq+ikQHZ5s8noeB?=
 =?us-ascii?Q?hdbb/qsGgd98l0h00tXWh+DTanaxtWOfCxagwaBibzwuxYwmm4GerjXAnZXJ?=
 =?us-ascii?Q?Lt97rNaC9xrvTTxnt74PEYVHB4DQIsvBhUZxQ/wbhaDMgslV/DOrW00o72Mt?=
 =?us-ascii?Q?wp5RcQWQG+TUljnUNY4729kCJFX+ZZH8AKsUN8tkc0jHr2mhLVYhcu0jCPoy?=
 =?us-ascii?Q?y5/lfvwVybgql+mEfUWmAxv3euWpP0evfEwKBcYwh/hLvimJjAZ2i/+uJ4jG?=
 =?us-ascii?Q?ip4z/hpOdf6p+u0YLdeGHOo/J3ua9JuSW6c57oCAxLkkzwJVNWtn9EucG8f0?=
 =?us-ascii?Q?3UAJV1Y19WuBDAQ6MbiTTMqRz4X4kbLJpTMXfTa9cbvDggTT+O055rWDjbln?=
 =?us-ascii?Q?QpEXv0rwRodf4RqU+4P/LEcyL50yIipvy9sMszsbgopsyO2fQdwAZY0q8o12?=
 =?us-ascii?Q?4UgfR7cdSXU5dSW/5ziQGhKdpLh30hLylZsRON60+bcd5sxV182WSLVAsVPW?=
 =?us-ascii?Q?VkKVXrvZ7qOY98NUuI/bMJa1/Od6jL1T7lYooXgbQmZ0tlaaVWB5DK2WcaH0?=
 =?us-ascii?Q?WlfE94YXhcYn+Z+1h0eRt1mIZSneF1zNTlq2BrBk5Ns3tEKtlW9JFRV+umK2?=
 =?us-ascii?Q?TT2F2ORrmFI90tAKREtW6JJ6xeDo/u59oKZ8gHd6n7oKeib2kaiyn+BcELPz?=
 =?us-ascii?Q?mjP4A5j4MBDAwPsZRP1IlSdoF4SD62rdk2nFnIs0l338UeNj98CDpk/+Uxz3?=
 =?us-ascii?Q?OyEXg7aXUaD077si4wseZ32wmDprVF2qpUQcI5xgmalsMmfj91G7+XXv98cM?=
 =?us-ascii?Q?w20L27ne6lgmnwh1QdfuCQdxyt5pv4Rh9k1MoXs9CbeXh635MxpO5EuUziNg?=
 =?us-ascii?Q?QvRi1IgGdYnRQOTFxGIkCaKUCDNJQbuV8F/CBG8Pn83u/S2PlDrozGRx9HxN?=
 =?us-ascii?Q?RfXODKC/xzbH5tZTmTSIKQ2OR7LdVeOWhYUhFVtaoIogeFbBLWhn7eJoDRS+?=
 =?us-ascii?Q?06WJi1IGL4j0PLQHhqJtI2RWDzXpCP1OotiDFK2U/wHhT3mFF37P8j5Ptm22?=
 =?us-ascii?Q?cqrn4jymd+PkKwCMFvRUdxWD0d0HxL7yPRrXOkCIgi0ANV1sHzeHfYxw2Cxe?=
 =?us-ascii?Q?Kt87OWox5nLYXqxlwhU7sZ/2kB5u5qEqvkAdd/9Hg2GyME+ZWv/MljEMFZYG?=
 =?us-ascii?Q?nNFP1ze8vdJFCVzLBVS1wh5jlXWtuoTl81i1l616409xs2PpEfFynzG+i2e6?=
 =?us-ascii?Q?rTs+waxoiZX0ooL8UrKIVd1P285Kk9+QLppTdzbybdNZW6m+F7oPyNjeCISY?=
 =?us-ascii?Q?epDY0HjLMOyTMrxDKWtgH8F1swvPiqDyKw/jiuQ31/ecm8cYZedEktNYlbFB?=
 =?us-ascii?Q?XWI7TLE0KijBP96kwc3QqdnmRTFhqI5bLZs+mgg56n2Y/rDcGiIlNyipagIa?=
 =?us-ascii?Q?UdBRXUOyFXXIhvAZdTgTcVuLIzySdJtRRlWdvb2vSpIEl7XvhWxPuu4fektH?=
 =?us-ascii?Q?v9ewFhBKt2s8nVq2fy/UgsUf48QfnIL/3kexUfu3Rzv6OZut77lb0WM9hifa?=
 =?us-ascii?Q?RBEPE/VpZ3q1h6g1Usx9Z8z63viXuwCxVj04ni5o672rjxoEPdFyZ5xercIi?=
 =?us-ascii?Q?RA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462ccef8-8eb1-4677-2870-08db3781ddb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 16:05:11.2935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y8sehKYoBOABWqIdrquDhFyw+XFqO1K0da920PMcXsLUO7/LOLM3i8CGwZPCxpl2EcTNlwi5p5/585fzHsNWKfREP1TpN+siE/QVF6jPkLM=
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
> When the host tries to remove a PCI device, the host first sends a
> PCI_EJECT message to the guest, and the guest is supposed to gracefully
> remove the PCI device and send a PCI_EJECTION_COMPLETE message to the hos=
t;
> the host then sends a VMBus message CHANNELMSG_RESCIND_CHANNELOFFER to
> the guest (when the guest receives this message, the device is already
> unassigned from the guest) and the guest can do some final cleanup work;
> if the guest fails to respond to the PCI_EJECT message within one minute,
> the host sends the VMBus message CHANNELMSG_RESCIND_CHANNELOFFER and
> removes the PCI device forcibly.
>=20
> In the case of fast device addition/removal, it's possible that the PCI
> device driver is still configuring MSI-X interrupts when the guest receiv=
es
> the PCI_EJECT message; the channel callback calls hv_pci_eject_device(),
> which sets hpdev->state to hv_pcichild_ejecting, and schedules a work
> hv_eject_device_work(); if the PCI device driver is calling
> pci_alloc_irq_vectors() -> ... -> hv_compose_msi_msg(), we can break the
> while loop in hv_compose_msi_msg() due to the updated hpdev->state, and
> leave data->chip_data with its default value of NULL; later, when the PCI
> device driver calls request_irq() -> ... -> hv_irq_unmask(), the guest
> crashes in hv_arch_irq_unmask() due to data->chip_data being NULL.
>=20
> Fix the issue by not testing hpdev->state in the while loop: when the
> guest receives PCI_EJECT, the device is still assigned to the guest, and
> the guest has one minute to finish the device removal gracefully. We don'=
t
> really need to (and we should not) test hpdev->state in the loop.
>=20
> Fixes: de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in hv_compose_msi_msg()"=
)
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>=20
> v2:
>   Removed the "debug code".
>   No change to the patch body.
>   Added Cc:stable
>=20
>  drivers/pci/controller/pci-hyperv.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller=
/pci-hyperv.c
> index b82c7cde19e66..1b11cf7391933 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -643,6 +643,11 @@ static void hv_arch_irq_unmask(struct irq_data *data=
)
>  	pbus =3D pdev->bus;
>  	hbus =3D container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
>  	int_desc =3D data->chip_data;
> +	if (!int_desc) {
> +		dev_warn(&hbus->hdev->device, "%s() can not unmask irq %u\n",
> +			 __func__, data->irq);
> +		return;
> +	}
>=20
>  	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
>=20
> @@ -1911,12 +1916,6 @@ static void hv_compose_msi_msg(struct irq_data *da=
ta,
> struct msi_msg *msg)
>  		hv_pci_onchannelcallback(hbus);
>  		spin_unlock_irqrestore(&channel->sched_lock, flags);
>=20
> -		if (hpdev->state =3D=3D hv_pcichild_ejecting) {
> -			dev_err_once(&hbus->hdev->device,
> -				     "the device is being ejected\n");
> -			goto enable_tasklet;
> -		}
> -
>  		udelay(100);
>  	}
>=20
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

