Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31396CB614
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 07:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjC1F3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 01:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjC1F3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 01:29:14 -0400
Received: from HK2P15301CU002.outbound.protection.outlook.com (mail-eastasiaazon11020024.outbound.protection.outlook.com [52.101.128.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6467B19BC;
        Mon, 27 Mar 2023 22:29:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+bTumz/ZTTZV768m7EuzgaNr5QshPzMFSfYK7E/r7XlEoZ3antgONOzwRrTUNPG/u7DEJnlHn4fh3JwYPEWbEqVLqzsrDjI9I8c+SWiAsXY1+NE9eNOGY07lILCsN00yU8qTpUNtUTj+zAD3q/PaG2ufk5KiP9cfapET69kx33qg5cwiSVP6B4xdmtUx++SHLFYX22MMAh04mOV4NcnSsVkBwli8lN6ij2De30v4uYFSJfmy4pO8Gz0m9Zw5A6ULdCHU3K3E0uCjAgI/XPPtRVCzB9NaclTpldIh6BD4BtzGmYE0rOhQyE1ZQMottgU/8ZlGX9XIQhsuVeAYljBNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUHUSeFoF6gfydKyyf7RHI7Z1Oj2+9M3ySdv1jb451c=;
 b=Spy3LfUUzO4D/mlzSp8NdnbibAfIVTyILYk6DM4uxiqlSTDoLEf09wZ9YMQcUViwnQtmfMCTRY+1rBQQgYkMQaXUmNPJu0kWG/7EGV4ZTeW5jxvGEVX4dykMxjbpBfudFnoWjov1YJDkPz9HUP4K0gs1GW1amR8cBW5P3Bcq4F9XqfMqBoBZgkJbxdbJWrqVvg46Htw5MAPm16BZQZ6sF6x6AXUCgpR4Lhgzmb7TWGKBflddn22YsZyjzGdWFB7ZFO/K3kS2ikb1qdG32eRZDuIJZ3lK1/8DCAeUZamPTXLsFJ68UannZe/4lIqbGEet29lREf/k+Natvgr371G/zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUHUSeFoF6gfydKyyf7RHI7Z1Oj2+9M3ySdv1jb451c=;
 b=TJcjoc9tDIxO6N9LyV02NjbehZLIlwLswxURilnKPx/H1ZduR0ob/L6DxFXP1C8asUxV796j7tyT6XuTU5lduZ3Qmjt2g1G39iRWTqYUMLE7jyjvwsExVBimjM+6/SIyygFX0tDHq1fGwQDsHDhonuw0uSChr4cYTqQVB6dYkLQ=
Received: from PUZP153MB0749.APCP153.PROD.OUTLOOK.COM (2603:1096:301:e6::8) by
 SEZP153MB0648.APCP153.PROD.OUTLOOK.COM (2603:1096:101:99::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.5; Tue, 28 Mar 2023 05:29:07 +0000
Received: from PUZP153MB0749.APCP153.PROD.OUTLOOK.COM
 ([fe80::ce12:9abe:af7f:5097]) by PUZP153MB0749.APCP153.PROD.OUTLOOK.COM
 ([fe80::ce12:9abe:af7f:5097%7]) with mapi id 15.20.6277.005; Tue, 28 Mar 2023
 05:29:07 +0000
From:   Saurabh Singh Sengar <ssengar@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
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
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Topic: [EXTERNAL] [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Index: AQHZYTE8ycJYvqlEuU6bxR9LLTVmZa8Pqarw
Date:   Tue, 28 Mar 2023 05:29:07 +0000
Message-ID: <PUZP153MB0749F39A34DEC9FABE17C615BE889@PUZP153MB0749.APCP153.PROD.OUTLOOK.COM>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-2-decui@microsoft.com>
In-Reply-To: <20230328045122.25850-2-decui@microsoft.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5d1d925f-e8b4-40db-8d9d-c9f4d2e55f0d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-28T05:27:45Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZP153MB0749:EE_|SEZP153MB0648:EE_
x-ms-office365-filtering-correlation-id: b2f49125-bc39-4d06-0b38-08db2f4d5a0f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gkmkbLuznKltVtb3+eLKFcXmAHvaCN+n3sz2hQ9GbGrJijAeqc8ZOp+biQ8dtwhKs7jVEK9SkSmkLxzix2xMDQAonbtPH9s17iomZFPmL3LLBcBKu5Xp7YuLYoSWufFa4PxRP6KF+XDSxp3eyhsPXUEYzQlfvMTngnG9SenF6IRef2iUFsZNe6vOOIDJkc+n3qbGVJHouYRAWXoyzBiXKUmqk5lcYNjmnrU86dTa4gWTRbilQ54Hfa6LWiOdAMMf3gG4uVhwGE9K83rEePiGR13utBDRkEZXHB4+jQHDSAQLEqA2xOLeYNN4kD5V3UJRHROFSFV+ZD0dvjXVPBzlWjWrcZv9Hh9Opgk+Jx+94/Bjxx2DdGmwPZb0c7oBINGfZhR62H5sFeSuRnTrgfCDFRnKqoM4ab4gMK1yzbevUxxJm3j+sCtoOXsOdgOzPH1TSyYHSG9dzas1QGiSWNN98MudTlraTJq5r3Jz15YDF85MPGlxHiQ+p+N0g//uzSSnosWo97DePW3wlFz6a3PohSLSYDP+66ScxXtW1v2qmk0yVXP7KOaYbeZB3s8eokECUzZMoG7oOe8MKvmZuIbd03ZeBWaCvywU2Dv4Jndw+QawQxgOGClt2ctt1oXLpZsJWyCD6AKAcgZxHDZOZdQhn6I0uBQd7fvk8L6q8GYaZnrkkVmoGXRCbOBnca6ymJTo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZP153MB0749.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199021)(38070700005)(8990500004)(7696005)(9686003)(33656002)(53546011)(186003)(6506007)(55016003)(41300700001)(82960400001)(82950400001)(86362001)(76116006)(4326008)(8676002)(66556008)(66946007)(66476007)(64756008)(66446008)(38100700002)(8936002)(52536014)(921005)(7416002)(122000001)(5660300002)(316002)(110136005)(54906003)(10290500003)(478600001)(83380400001)(71200400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tNQHnrpVqQtzsduPOz0cMJwhn40CcjIoNySCHGlI6KtI2Zd/dyQnBDHmsylb?=
 =?us-ascii?Q?4sDOOMUIDM2rATfRPbQ1OiWq+giBLEd16XkXQdOHT8OQ6WnchjtyGEAiUuIJ?=
 =?us-ascii?Q?tlbjv3MWVgqLeOfkC3nOEqNp5B/7Q10XUNfYolIzZgXQdGHVB5OPSZKMWgpv?=
 =?us-ascii?Q?RwoH+jR+T1cfjMwoYqkFGh7X21YgCPi4h84OyD/BAMLe5/GQ0KZUjeYm2wxI?=
 =?us-ascii?Q?FbqcyIZ6ZVG+5P5s+QHvnmWjQnjXyTFKePDV9AT8ZB9vWH3YAJiDJuL7rUu+?=
 =?us-ascii?Q?BCnxIwiDAm+dO4dRaHjd8gsGLK4wMT+Gk+52p/OozDEcYc/wMlIJ7H9oDB3I?=
 =?us-ascii?Q?oTS/9vUiNWpjNdbkmGNfP5nSGD/6R/9gP5yM3H6aGSGaXZgqaVGKH5x5MEls?=
 =?us-ascii?Q?VdjkwwDMu+kg2mQKA2Qqap8E315K+Mwgsjj0rUVMHxMLmLy+nCNOfOxTgxET?=
 =?us-ascii?Q?bwOyjwg1vGnWs/KhLsxbdGtJKvoivIXLNY01JexGOIJFxd4KvAbtMd5FJPEi?=
 =?us-ascii?Q?1L9/ETgnpP9TmYdTp0evO6GmzfD9AdrSCpExh9K2TuW1q2K673TtZH88cFAf?=
 =?us-ascii?Q?IfpzUBEuHv/EPha4CbBDcODjyBuO8QJM4W+kUoqyTf1lcOUJJDelHOxmIQRq?=
 =?us-ascii?Q?A6DTkTwB/4vGtif/Sc9zcN5jRpDv4O4CXum1KM8O7xQ88dwBa865ZQ+APITJ?=
 =?us-ascii?Q?GFWxkTbhEwzZmBdw9LCuhZRyts+GmAeuCQOAz19uI6cxmf3lhFVOBXldwTmQ?=
 =?us-ascii?Q?+R3v0LJeswaMcW/Nm9Hz6SVB6AfzTzAgnocPRL+rOQFUxorHsHTxv8FmQrW5?=
 =?us-ascii?Q?mzXTWdyT45Qa1lKZCV9GonmpggDgpIWBjDkZjX7YbE5INwXdiyrSL6MQrRDO?=
 =?us-ascii?Q?Q5v6ZD0n2dbRMi1X6+Lt1qBKNZJCwPusSJsFmxYmXDfOC/VWiRhbqqFxa9vl?=
 =?us-ascii?Q?JNQj+2PIBZ34/tbnFTzu77OII0UDMM2AfRocZpIo8nbGpbnSHgWQJcBUUZsV?=
 =?us-ascii?Q?55ILNht79b6f57ENxw6P5Yn9uPOpt4+ZW3kPEhhTLPibKcdJkPjpUDGslTUV?=
 =?us-ascii?Q?vWzhTD0dRy7oXstSY8VSbDBPk1cBl9lUtmDn9MO506SQ8/BvFP175Yoo9ARj?=
 =?us-ascii?Q?Sq0TMZME6zM9k7vAFBFmKG5GaW9RFRYN4a48aLPO27YtILEf/iOhZptIIQL1?=
 =?us-ascii?Q?DKnW0pm+m8+fNwkZAHvBjp/LnspK0AWY3pv2pJxvmowQunmocKIyvXwyZkf9?=
 =?us-ascii?Q?txXmR+4MJqrJapoRLS4hJbIXN0+iu6poEctFPcOaPJxdzyhDKFeStiIu8qRI?=
 =?us-ascii?Q?/VcPFxqQO3mNazIqiFyql6BBK0ECdWkkZWwWxplnoUAEcXQcDLQSvGEnvbnq?=
 =?us-ascii?Q?q0HtBnR1yBVlN4E7wQkKI46JHc1aiIjEdEoanELYkR002P7uTgKnUEEFJDkH?=
 =?us-ascii?Q?6f5eknRaVwW00zGevM9Viovg/iMe+Q5/2RZpBagxbvOOYGC8GIhbgQFta+o8?=
 =?us-ascii?Q?GeN4s1y91xPg35WDRuFV2h0PvSJPXk3BwcHJRGixOpTbeV7z+6zxzQkylXqw?=
 =?us-ascii?Q?bhnl5Q9myr0vBFc0zUh3fjmQy/tOT/F88dN9WxtZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZP153MB0749.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f49125-bc39-4d06-0b38-08db2f4d5a0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 05:29:07.2570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dbb7u5VSrb9CoHAofQTZdSjrrQwNzeHnCGuaELaJyQjiK30LHHDKqPMPOcz3qyxWVgWBdrVohnBa8Gd9UYHcCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZP153MB0648
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Tuesday, March 28, 2023 10:21 AM
> To: bhelgaas@google.com; davem@davemloft.net; Dexuan Cui
> <decui@microsoft.com>; edumazet@google.com; Haiyang Zhang
> <haiyangz@microsoft.com>; Jake Oshins <jakeo@microsoft.com>;
> kuba@kernel.org; kw@linux.com; KY Srinivasan <kys@microsoft.com>;
> leon@kernel.org; linux-pci@vger.kernel.org; lpieralisi@kernel.org; Michae=
l
> Kelley (LINUX) <mikelley@microsoft.com>; pabeni@redhat.com;
> robh@kernel.org; saeedm@nvidia.com; wei.liu@kernel.org; Long Li
> <longli@microsoft.com>; boqun.feng@gmail.com
> Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; netdev@vger.kernel.org
> Subject: [EXTERNAL] [PATCH 1/6] PCI: hv: fix a race condition bug in
> hv_pci_query_relations()
>=20
> Fix the longstanding race between hv_pci_query_relations() and
> survey_child_resources() by flushing the workqueue before we exit from
> hv_pci_query_relations().
>=20
> Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsof=
t
> Hyper-V VMs")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>=20
> ---
>  drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> With the below debug code:
>=20
> @@ -2103,6 +2103,8 @@ static void survey_child_resources(struct
> hv_pcibus_device *hbus)
>  	}
>=20
>  	spin_unlock_irqrestore(&hbus->device_list_lock, flags);
> +	ssleep(15);
> +	printk("%s: completing %px\n", __func__, event);
>  	complete(event);
>  }
>=20
> @@ -3305,8 +3307,12 @@ static int hv_pci_query_relations(struct hv_device
> *hdev)
>=20
>  	ret =3D vmbus_sendpacket(hdev->channel, &message, sizeof(message),
>  			       0, VM_PKT_DATA_INBAND, 0);
> -	if (!ret)
> +	if (!ret) {
> +		ssleep(10); // unassign the PCI device on the host during the
> 10s
>  		ret =3D wait_for_response(hdev, &comp);
> +		printk("%s: comp=3D%px is becoming invalid! ret=3D%d\n",
> +			__func__, &comp, ret);
> +	}
>=20
>  	return ret;
>  }
> @@ -3635,6 +3641,8 @@ static int hv_pci_probe(struct hv_device *hdev,
>=20
>  retry:
>  	ret =3D hv_pci_query_relations(hdev);
> +	printk("hv_pci_query_relations() exited\n");

Can we use pr_* or the appropriate KERN_<LEVEL> in all the printk(s).

> +
>  	if (ret)
>  		goto free_irq_domain;
>=20
> I'm able to repro the below hang issue:
>=20
> [   74.544744] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI VMBus
> probing: Using version 0x10004
> [   76.886944] hv_netvsc 818fe754-b912-4445-af51-1f584812e3c9 eth0: VF sl=
ot
> 1 removed
> [   84.788266] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: The device is
> gone.
> [   84.792586] hv_pci_query_relations: comp=3Dffffa7504012fb58 is becomin=
g
> invalid! ret=3D-19
> [   84.797505] hv_pci_query_relations() exited
> [   89.652268] survey_child_resources: completing ffffa7504012fb58
> [  150.392242] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  150.398447] rcu:     15-...0: (2 ticks this GP)
> idle=3D867c/1/0x4000000000000000 softirq=3D947/947 fqs=3D5234
> [  150.405851] rcu:     (detected by 14, t=3D15004 jiffies, g=3D2553, q=
=3D4833
> ncpus=3D16)
> [  150.410870] Sending NMI from CPU 14 to CPUs 15:
> [  150.414836] NMI backtrace for cpu 15
> [  150.414840] CPU: 15 PID: 10 Comm: kworker/u32:0 Tainted: G        W   =
E
> 6.3.0-rc3-decui-dirty #34
> ...
> [  150.414849] Workqueue: hv_pci_468b pci_devices_present_work
> [pci_hyperv] [  150.414866] RIP:
> 0010:__pv_queued_spin_lock_slowpath+0x10f/0x3c0
> ...
> [  150.414905] Call Trace:
> [  150.414907]  <TASK>
> [  150.414911]  _raw_spin_lock_irqsave+0x40/0x50 [  150.414917]
> complete+0x1d/0x60 [  150.414924]  pci_devices_present_work+0x5dd/0x680
> [pci_hyperv] [  150.414946]  process_one_work+0x21f/0x430 [  150.414952]
> worker_thread+0x4a/0x3c0
>=20
> With this patch, the hang issue goes away:
>=20
> [  186.143612] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: The device is
> gone.
> [  186.148034] hv_pci_query_relations: comp=3Dffffa7cfd0aa3b50 is becomin=
g
> invalid! ret=3D-19 [  191.263611] survey_child_resources: completing
> ffffa7cfd0aa3b50 [  191.267732] hv_pci_query_relations() exited
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller=
/pci-
> hyperv.c
> index f33370b75628..b82c7cde19e6 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -3308,6 +3308,19 @@ static int hv_pci_query_relations(struct hv_device
> *hdev)
>  	if (!ret)
>  		ret =3D wait_for_response(hdev, &comp);
>=20
> +	/*
> +	 * In the case of fast device addition/removal, it's possible that
> +	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but
> we
> +	 * already got a PCI_BUS_RELATIONS* message from the host and the
> +	 * channel callback already scheduled a work to hbus->wq, which can
> be
> +	 * running survey_child_resources() -> complete(&hbus-
> >survey_event),
> +	 * even after hv_pci_query_relations() exits and the stack variable
> +	 * 'comp' is no longer valid. This can cause a strange hang issue
> +	 * or sometimes a page fault. Flush hbus->wq before we exit from
> +	 * hv_pci_query_relations() to avoid the issues.
> +	 */
> +	flush_workqueue(hbus->wq);
> +
>  	return ret;
>  }
>=20
> --
> 2.25.1

