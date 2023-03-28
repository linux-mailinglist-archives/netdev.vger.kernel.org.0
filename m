Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0D26CB738
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 08:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjC1GdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 02:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjC1GdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 02:33:14 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020027.outbound.protection.outlook.com [52.101.56.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB51D7;
        Mon, 27 Mar 2023 23:33:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e++AJPXbuWL7E55yRTMDwXxViU53WT18WPDAcdx9zlIWarXtxJBzgJeUTtxi70TUJpNGga8QsoXpb7/e9v1Ry1I8HF4LyiDifp1kd93ClKBOlsiDAtoLi00/G31tTspDEk4VU7FJatI3s3vHe4B9qfF77dJV2Bu+3K/sj8KrrZXjOWunC7OL2PAJyfS4ljSXotGb+VSUFVwJBGrsdJWetLrMJ8nS9ISj1oYFIRMQUD0j5DIDQaRdUeCny04d3liLVGX9xHt+WR4ZH1cRAOU+IzZpjUZHe9EOo5BFtbauga61QYlTjgqCa7LFzUB0Itx742fFgso/G67ydmTPHmMolA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7r9PpR7eUNwtLHSk358CPjmcIa9Kd4lua7g7MEzmfY=;
 b=nNQAR45y7T2vZj5PHVypbF/WqWH4ryUGUmfBIZ9KRQAEDJZoM+BlzxOEkdi7tX/zv/n3HoCrWxSRaA7M35ANuzgQFXepWJx5Rov++lRi1fW02m/Zu5judh/xXU+Je4lRkOyQ8pHcfPfBHQ1fO26bATa6/4jTzmVoi0pBIdvBDKKVMy2TaYW1eDVTSjgVL7Y79+TBStT+ESvtEsGEaqQu/Ya4C9mAPiJv3fHzfyc8pQR63SEOWvxsoFUgW09FW+FYmSBPxUek13+tbCwEz6aGkUIjY3Nv7wm7AFcfHxUcQFpe/857LInSoXfVmtoK8G/vq/hKW2iJA1uttxKTirEESg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7r9PpR7eUNwtLHSk358CPjmcIa9Kd4lua7g7MEzmfY=;
 b=I6qsCpgdv2yEOO3QTs7Fa7vScgG9nrWcMwAWYaiXHiNOLzrssk1WtbeYIeN0ZwYqLl8iFAtchzbxQH/k4ZMS6w3Zbh47adVaA63DiDHl/OzN+PpHTHZXxBhT0YYjjfvwa1VCA4G1mN2QWVcG4KzUc+vgaDbBO9k/yepjqYw4C8g=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by DS7PR21MB3078.namprd21.prod.outlook.com (2603:10b6:8:72::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16; Tue, 28 Mar
 2023 06:33:07 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6277.006; Tue, 28 Mar 2023
 06:33:07 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        Wei Hu <weh@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Topic: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Index: AQHZYTE02QJw3cJyrE2OQ7EX2SDB268Pu6Lw
Date:   Tue, 28 Mar 2023 06:33:07 +0000
Message-ID: <SA1PR21MB13356A77700580DF0C742856BF889@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-5-decui@microsoft.com>
In-Reply-To: <20230328045122.25850-5-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6f6d75c5-e156-425e-9f36-09272bf9a5a0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-28T06:32:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|DS7PR21MB3078:EE_
x-ms-office365-filtering-correlation-id: b17f5ae7-e892-495b-649b-08db2f564ae7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WqJIOolqq5LvxCphcbRZHdLCx8m7MKvJixYNezW6ctzu/vOBMdIARbd0oBogmMB3ar0cNuzgQfRaFV8UhozTNH+r1b80ukogx2gV4rQ7ZPEMss/r07Q64FlpQMEnvNQc+7GAdPo4JuN5QqfGJxhCl+w3RPXQMlS8bK8Eca/sw4+1HMy13tAc9WTJe6JoaaYYQyi4Yd4RVhl/NDMnwg7su3fO4D1ZPsB+6XUKmb8g+LbrW2ZhkFM2WCl/szTS771yUYh10c2RHXgx/q8jnisFTwjzzjsbslzyDZzKS9Mje2mv9j70sw40ZId6v6EAwj64JOaQvxzCLmpKnIq4BVCjShmpA8L/nxtXnd664D/vof7uJkMmKOz98ljBj6u0a3fsrgFpPCIIMtDS37pw0NWt8ARIc/sw/zmoMpP33GoTLSzp4g4WagleO7EMl72LyUFAlrnMY8HOfgUTiYt//haSne27dNywaoP4FO0/3wtYftcZt2ZE2tDiGxbCd4yWP6IzVi+hbnkXEMK4TO6kUBdJXo31ITaBOPSFg6wXN2pV2akGARKHO1u7AD5F402QTwgms/OhEKRaLfY5AV3ftPWEhu7oxgg8psGmMjTVQYikoncxnaJ5Z90QwUPYRgF+J4Nrg5utMdyARwKg3RezwStFa5WuRg/BmMmPnbSfM0LKWzeXqrzw0+8cFozM6/G9zoAO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(122000001)(38100700002)(82960400001)(82950400001)(55016003)(33656002)(86362001)(2906002)(38070700005)(921005)(10290500003)(9686003)(186003)(26005)(6506007)(478600001)(53546011)(7416002)(8936002)(5660300002)(7696005)(71200400001)(52536014)(41300700001)(110136005)(316002)(66446008)(64756008)(83380400001)(66476007)(8676002)(4326008)(8990500004)(66946007)(6636002)(54906003)(66556008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mTYyHmqHa/vb892e+oxHlk/sPaxSNYJttSBn4ohdZfnSag0yB7Ljsk3NGqZz?=
 =?us-ascii?Q?d7GN0IlMVJxmoIo4szhdIIDdkS3vtTznjNovRtVKXeH2AYqNy0yYqm9uM3Z5?=
 =?us-ascii?Q?DipSZfYGLkkJfj4J+pT80bEsqpzi/Rdw7CCTEnNY9Sgmkaj98YzGAlqhCoTB?=
 =?us-ascii?Q?b9ha7XoSUVE42Q4Yvsgys7EaFZTUD8jAoKD2bXvXC/zez2aVOOny6mDhPsc7?=
 =?us-ascii?Q?agVLUEh/2snmYa2RzLJN93Y5YOoCHZz3nyuEFsAY8vpoUZJ18uSBGPha5LZJ?=
 =?us-ascii?Q?O7YSbA8PLxGvxrita6rS3S33gavyYsQOmiALuBb4npKBkYKFbFX+f+IptUun?=
 =?us-ascii?Q?+aZuOMM6jjxt4C73JtRRKS5LW6WNK22tpxw70sRahOJVJuu/ulpX7Xc1XI75?=
 =?us-ascii?Q?1GD3bPsU36AgWd8rP5lI68ZXqzSTzy3QfnRlnaAOzbi76GU52Fji1fd4xs25?=
 =?us-ascii?Q?yl/dFc3PvrglxVs7iAcGPCQ+52tcVouxXOXUxhG8qsssUZDQscyfY7CwHD4g?=
 =?us-ascii?Q?ZLFT2NOaODUMeTvS8sBg4AoW2Ut2PKImbaD8jvPRWqAZjrAgFl6zpsdA6+r7?=
 =?us-ascii?Q?VUOFWfXBSMhYSxIHR8I+el/sji+bzyvC04WNtAawcWXSbfX3/EC99KYMIJas?=
 =?us-ascii?Q?MkW+YzIdGLhV1p8zThMGlq3Pp4jOVi0QdxwgbWdDvgZSqS3pKkv19VfV/fup?=
 =?us-ascii?Q?7srgsRti8msPZB31NYLbD9ygo0YO+t/30iAz/4I51guXncmUuabtf5U/Kn3w?=
 =?us-ascii?Q?Fy6DXK+H5pE9epF9BVnMc6ps0x+Axc/Tdo3AC+32J0SnLbApHnbb+3646H7y?=
 =?us-ascii?Q?Mo1gIwrGiCG5FybXFowH3bl4OOIjwQRW29saZoIxy4iFs7ZNwpc+CgmyNWOz?=
 =?us-ascii?Q?uFIhGf4+//69p6grtqwvkQljEJ0a9da5xHSYXFAw3UuJjnKkS87YVqzGv0md?=
 =?us-ascii?Q?uogTopUcXs92kP23MY0VYSaHzuVG6gGRIbSFyoaBSsFXYdcOo369SdTh5IH/?=
 =?us-ascii?Q?2w47yz8KtRtsArtvZkiw3RGATLVIEggoGYIYYch4NUjMZWsGdwJDGMrWvlmq?=
 =?us-ascii?Q?fXx589S99Kcu4ztPtUmzFFujB8icZedgkQgYw8VAeHGXx5Gy0qZHg7xto1Jt?=
 =?us-ascii?Q?zlgefhSJbrldps7Q3PienlfmN2wQ7Ik754qqkKN7o+32piN9dumMx6yaoC76?=
 =?us-ascii?Q?TTCa4iNNkZh+hTI1ADYYBHg5XMAjRqcrqw+w9WZof0Z5bPB+er1vbv3iXX08?=
 =?us-ascii?Q?vwv3ABp3U0Ir3X07wpWflfASRmkEniCDKsz4DQrwOhoSyeVcsZL8sZmlgMwM?=
 =?us-ascii?Q?UNtrZcJYiY+nWmb1jZuVGLhqMTg5Xa6HdBto6n0lRAdbT7lC8K349hbD+9ML?=
 =?us-ascii?Q?lgWPqhxAafoH7/8vd93wm9dAdH25iPBvUdYzQzw6SJ0sE2Y+uM6MSXiEU5uu?=
 =?us-ascii?Q?b1L/g/FAwYLSBSoJdiGQ5HqejICIjc3UWmCD1egOCHiPJCRyzRU7Qt1xXyHd?=
 =?us-ascii?Q?HU3EHHAxtiY/m7ehNk7y5vO+of8JglQnvn99ebehjaUJLj6k2nmTgb8Ci4fE?=
 =?us-ascii?Q?BqV3PtuEKJG8H8qOLxGw8HSz8CJQHoUzOksbBtNX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b17f5ae7-e892-495b-649b-08db2f564ae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 06:33:07.3099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bzPzjoYrUaMMTe9arR1ET5mObVt1yl3ZfpLWUyTv8pB6thUFmywVan2FYnoY4VvVAmFaZFLo9JINR+P7mxSZRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3078
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui <decui@microsoft.com>
> Sent: Monday, March 27, 2023 9:51 PM
> To: bhelgaas@google.com; davem@davemloft.net; Dexuan Cui
> <decui@microsoft.com>; edumazet@google.com; Haiyang Zhang
> <haiyangz@microsoft.com>; Jake Oshins <jakeo@microsoft.com>;
> kuba@kernel.org; kw@linux.com; KY Srinivasan <kys@microsoft.com>;
> leon@kernel.org; linux-pci@vger.kernel.org; lpieralisi@kernel.org; Michae=
l
> Kelley (LINUX) <mikelley@microsoft.com>; pabeni@redhat.com;
> robh@kernel.org; saeedm@nvidia.com; wei.liu@kernel.org; Long Li
> <longli@microsoft.com>; boqun.feng@gmail.com
> Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-rdma@vger.kernel.org; netdev@vger.kernel.org
> Subject: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes kdu=
mp to
> fail occasionally"
>=20
> This reverts commit d6af2ed29c7c1c311b96dac989dcb991e90ee195.
>=20
> The statement "the hv_pci_bus_exit() call releases structures of all its
> child devices" in commit d6af2ed29c7c is not true: in the path
> hv_pci_probe() -> hv_pci_enter_d0() -> hv_pci_bus_exit(hdev, true): the
> parameter "keep_devs" is true, so hv_pci_bus_exit() does *not* release th=
e
> child "struct hv_pci_dev *hpdev" that is created earlier in
> pci_devices_present_work() -> new_pcichild_device().
>=20
> The commit d6af2ed29c7c was originally made in July 2020 for RHEL 7.7,
> where the old version of hv_pci_bus_exit() was used; when the commit was
> rebased and merged into the upstream, people didn't notice that it's
> not really necessary. The commit itself doesn't cause any issue, but it
> makes hv_pci_probe() more complicated. Revert it to facilitate some
> upcoming changes to hv_pci_probe().
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/pci/controller/pci-hyperv.c | 71 ++++++++++++++---------------
>  1 file changed, 34 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c
> b/drivers/pci/controller/pci-hyperv.c
> index 46df6d093d68..48feab095a14 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -3225,8 +3225,10 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
>  	struct pci_bus_d0_entry *d0_entry;
>  	struct hv_pci_compl comp_pkt;
>  	struct pci_packet *pkt;
> +	bool retry =3D true;
>  	int ret;
>=20
> +enter_d0_retry:
>  	/*
>  	 * Tell the host that the bus is ready to use, and moved into the
>  	 * powered-on state.  This includes telling the host which region
> @@ -3253,6 +3255,38 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
>  	if (ret)
>  		goto exit;
>=20
> +	/*
> +	 * In certain case (Kdump) the pci device of interest was
> +	 * not cleanly shut down and resource is still held on host
> +	 * side, the host could return invalid device status.
> +	 * We need to explicitly request host to release the resource
> +	 * and try to enter D0 again.
> +	 */
> +	if (comp_pkt.completion_status < 0 && retry) {
> +		retry =3D false;
> +
> +		dev_err(&hdev->device, "Retrying D0 Entry\n");
> +
> +		/*
> +		 * Hv_pci_bus_exit() calls hv_send_resource_released()
> +		 * to free up resources of its child devices.
> +		 * In the kdump kernel we need to set the
> +		 * wslot_res_allocated to 255 so it scans all child
> +		 * devices to release resources allocated in the
> +		 * normal kernel before panic happened.
> +		 */
> +		hbus->wslot_res_allocated =3D 255;
> +
> +		ret =3D hv_pci_bus_exit(hdev, true);
> +
> +		if (ret =3D=3D 0) {
> +			kfree(pkt);
> +			goto enter_d0_retry;
> +		}
> +		dev_err(&hdev->device,
> +			"Retrying D0 failed with ret %d\n", ret);
> +	}
> +
>  	if (comp_pkt.completion_status < 0) {
>  		dev_err(&hdev->device,
>  			"PCI Pass-through VSP failed D0 Entry with status %x\n",
> @@ -3493,7 +3527,6 @@ static int hv_pci_probe(struct hv_device *hdev,
>  	struct hv_pcibus_device *hbus;
>  	u16 dom_req, dom;
>  	char *name;
> -	bool enter_d0_retry =3D true;
>  	int ret;
>=20
>  	/*
> @@ -3633,47 +3666,11 @@ static int hv_pci_probe(struct hv_device *hdev,
>  	if (ret)
>  		goto free_fwnode;
>=20
> -retry:
>  	ret =3D hv_pci_query_relations(hdev);
>  	if (ret)
>  		goto free_irq_domain;
>=20
>  	ret =3D hv_pci_enter_d0(hdev);
> -	/*
> -	 * In certain case (Kdump) the pci device of interest was
> -	 * not cleanly shut down and resource is still held on host
> -	 * side, the host could return invalid device status.
> -	 * We need to explicitly request host to release the resource
> -	 * and try to enter D0 again.
> -	 * Since the hv_pci_bus_exit() call releases structures
> -	 * of all its child devices, we need to start the retry from
> -	 * hv_pci_query_relations() call, requesting host to send
> -	 * the synchronous child device relations message before this
> -	 * information is needed in hv_send_resources_allocated()
> -	 * call later.
> -	 */
> -	if (ret =3D=3D -EPROTO && enter_d0_retry) {
> -		enter_d0_retry =3D false;
> -
> -		dev_err(&hdev->device, "Retrying D0 Entry\n");
> -
> -		/*
> -		 * Hv_pci_bus_exit() calls hv_send_resources_released()
> -		 * to free up resources of its child devices.
> -		 * In the kdump kernel we need to set the
> -		 * wslot_res_allocated to 255 so it scans all child
> -		 * devices to release resources allocated in the
> -		 * normal kernel before panic happened.
> -		 */
> -		hbus->wslot_res_allocated =3D 255;
> -		ret =3D hv_pci_bus_exit(hdev, true);
> -
> -		if (ret =3D=3D 0)
> -			goto retry;
> -
> -		dev_err(&hdev->device,
> -			"Retrying D0 failed with ret %d\n", ret);
> -	}
>  	if (ret)
>  		goto free_irq_domain;
>=20
> --
> 2.25.1

+ Wei Hu.
