Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDD96DB04E
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjDGQLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjDGQLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:11:51 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020021.outbound.protection.outlook.com [52.101.56.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0E09749;
        Fri,  7 Apr 2023 09:11:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6edX9EIsbR4ZfUZQHatUOe9NIL6SPYI0pEMlv3uoNO7L04VFkWo0uVU/70tB+6H4jz3KN/B1GwdvrYmhs7GsOcqshT560i41GE4GCeKGPLUSdzZijVPpg+nQYlfoK3lyt1kHDqPiDrlyQjGhOJWBnLi3gye0wFgHPuTgAiuoo1WZawlnDYWHz2G9zndfva1/p82N25+XUW88PVo2aR8FTN+dP2qttR+wT1tBRaAqau6e/x9j5ZNMGKD3tlRPVUaqwJ4UKZxEcd+8h7zTNYmk7ktISy0jocQ971GAcdP2etUAfM/rmC7ErIdxLxhfbTUOAXw1E0iUKK7XyWLZoIzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EwOwqaBzTWpoCb1sgib2IIhbLLGxSsnZKpggPuZ+ac=;
 b=jgeFgLdta3RT5LqNsvzj60U6ItN037dWpSVYkG/K07WokJUv5Feo2QCAFCunxYB8JavTVFC8SJeaCTzTfDLvaEiBkpcJtx/7sUDGzd8CndaHaL7/J8a+vFMqbWRb82FFwPjt7BhNlvlNV2wWKF166/wE0Kox+x7wYqg1n+OlM3icUmIZRSpszlmzeaHp0lCL6OKF2/QfDpUw8i0B3lPJjL7B9YYnhPo7XcxAL0nqeSesHKqW8GacSwpzikF7yj5chEpLSGeieq5MC2k5DMNWGbhnN0KLKlNDM9GrcZMFfUGOEz6Fktg0Ag23OlPo89+JJU+nEXYwtjjoR0LEewMhEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EwOwqaBzTWpoCb1sgib2IIhbLLGxSsnZKpggPuZ+ac=;
 b=G6ZHjWE+M31H/sp+LXsAbF0KOBHzAcNrQwh4bsOXIWDZv0o+e2U1w9UU2DNFABoov1IlJmsKF0CbcFFZHpUX6vJayXDKIUT3ivzl1SDCmSLZieSbmx6I5KDbwoHIxJMuTZsbbgeYpe3mVIK+TMBwyArbEEY8lhx9BCapxZ7YwBM=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CH2PR21MB1397.namprd21.prod.outlook.com (2603:10b6:610:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 16:11:31 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 16:11:31 +0000
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
Subject: RE: [PATCH v2 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH v2 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZZposgluJ48qtKkybpggwYjZPaq8gCcZg
Date:   Fri, 7 Apr 2023 16:11:31 +0000
Message-ID: <BYAPR21MB168842E38534BD00CB1D27ABD7969@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-7-decui@microsoft.com>
In-Reply-To: <20230404020545.32359-7-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4268d2ca-a28f-4b1b-ac19-612f0da0821a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:10:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CH2PR21MB1397:EE_
x-ms-office365-filtering-correlation-id: 6aaa74dc-80ce-45bf-2cdb-08db3782c081
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QVrj1KMBi2xHJW+FAgsjbf56UbaNfCh8Ksx//O5+Gq+DgI+PipYhD4MfVWyxbY5lwm8jl8WLi7dw+dz9AeGjJyI/qyjjkXIFv59QvWff69REmceUmKod4N/kSO3fqZPKlG1r08zg2h9zQboHUjCYvAsodNDYqa23BZGNFvrhZED6MymP2Xv6Xt9E+NjhOYDYXV3OzpNcL7SReuE5jbAUHdJ3RlhJ44pXLXnYMmmefY44BVotGbxVcLD3FMMcj66iC3GE9yaRZCP2mCS8pe65AVTfb3+GYmL2yE8xHHjBgTswXNOQ4bObj4fJZ81AiKYPVcsehFm1AsLUmQVUUQcSYjKFL5bdPKxwFKs4YHyZCyiaeU1wYDul3N2xXQ2xFYUWENBtkjAcfpIpfUSNF3v4IitaxSfgxgyNPdGPvCcW7VxbT5uoCl18MWI7EzPrs+K+fgA8eJLK/jV1WkpJl9gBf8H9bS+aIHu+zk2kPCvMKP+NkeVoPMi5/unDzgA3uQbdGXFMmxJgMdfcV7BWcREKrOocrG01nkXXXxjODpLEALioZkiPBbg32FxRk4SK3nJIv5uTommWVIzhZhgvDPsoQPpg1tdc7qvKAlzAQDgfabcqJ+AP3u5buHnP0xLzoSxiD+/OmCbpWA8Yr7xVJ2HbsJ+lhuf/eU5ccWRJcLPJ/xfiiH+Fq4ICQtlkiph11YeZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(451199021)(86362001)(33656002)(316002)(110136005)(76116006)(786003)(41300700001)(8676002)(478600001)(4326008)(66446008)(64756008)(66946007)(7696005)(66476007)(66556008)(71200400001)(54906003)(8990500004)(55016003)(52536014)(5660300002)(7416002)(10290500003)(8936002)(2906002)(921005)(82950400001)(82960400001)(38100700002)(122000001)(38070700005)(186003)(9686003)(6506007)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NBg7muN4ytweR6Hsvaa0SPxNYLsRlhmBPFLcyNqXLyyW/i8WntFytBa6xKxR?=
 =?us-ascii?Q?bzSFChOnj9Gu+mNcTwENLXMKz5bz27AYrjJg+jK+DoJ1xhpHDwzybS0OzXfK?=
 =?us-ascii?Q?dtk8cepiPxbC3JnIi7WVQDrsbcDGM3Nj/6KPP9Ak5694GrPPQD62GGIwax8C?=
 =?us-ascii?Q?8VPj9+htH0bcZwpsLlNjH75kVqf+Oj7YG4EKvp7vKEWH324fnX7GrGjwiHNh?=
 =?us-ascii?Q?qeRTBxdHm3ERKh6QTtq1oKw5fMYX7OwwlEDQZTGyKZgh5Dm1XSnxtJeVjyvz?=
 =?us-ascii?Q?QHz10CbOvsrKzWTrQN45lFOtEU91MnCURN/+bzzaZNErXwOxhll9VvMAcDNm?=
 =?us-ascii?Q?4q+qEKLK0rIEP/Cs3SuPlJ/Btnr+iWR+Qlwg/Bt5kL9m8Yi/ftz3oGhgy4P6?=
 =?us-ascii?Q?IocESaRmAs88D2OLcmD1RqSrIsfuF3jrSFfhs8+kjhSwtt7ZM9RAZkE8ip5b?=
 =?us-ascii?Q?Npyib5OCDAVypWCbf4tz4zR1bOujTCEbL2zihWdfFWeBtYQu3emhN6kqfPcs?=
 =?us-ascii?Q?15FJjQBredd4WTB2tXaDI4eyxBbSIPxX2l8Sf0la82ZMskbTBtgCmpEvUW0+?=
 =?us-ascii?Q?Z0kNHIHGOFHLdMUFxV/GN0amNuVXQfvPQiH5L1pfh7+shGACy4O2KxFM4fok?=
 =?us-ascii?Q?SRkAhvL0sDt3u/6ENG8o8CZ9Ehy5MmLgXdJAgz75VO3D9E51Cprc6FNDEo43?=
 =?us-ascii?Q?KT2ubO0RVDF9sXwOKUtxIO4W5PyiLKFDp3SJYQycckR8xuvKNEQ1alyxiogy?=
 =?us-ascii?Q?nuJuz2G/L4SMJD6pXWd/KjZjsFzDcGmYGGfyePKlN42Pw0iJmBOICf1mdd27?=
 =?us-ascii?Q?qFVi6ZfQq2vF5OREMZrun42CBHnBVeJHgymlkho2ebMdSHdZ4bUGjifXePUf?=
 =?us-ascii?Q?yKwvLproCVP4yrD063wx9bGioAmEo5OWzgSsUtKix9CDluYl1UyUtDJqFCHL?=
 =?us-ascii?Q?MzhIgVwaNRuqrni0yFCjkw1XYdc12FrpntgfkNZqwWCRSj3AyvUEosfHb3s5?=
 =?us-ascii?Q?xonUrxOQffW4uEhYD+FZS0OOp73VG+us21ayi3WsRElOcSG7rctk+eXK6rdN?=
 =?us-ascii?Q?Py3VkN/IRdpXYTalpe54qR1PcnHv9H0QfJbjBlZBChJfrnplI7AvhXfds+6M?=
 =?us-ascii?Q?1Dlx0Vxpg7Nw6K7lo6VLI8zLmm2VCdeYfD9CpZMLQR/ej5K290Q29DU8+cZX?=
 =?us-ascii?Q?gGibbRKXrip7FA9m9CWC0ULh/Y3F+ewLPQ/7/FUgSLnwuiFiK2lZQC/L3J2c?=
 =?us-ascii?Q?02/d3uH74e7enDrVW/97w89loXh0xqzf4RNFhhhvwF50Mo+g/LO+8btAzovU?=
 =?us-ascii?Q?oVk1puyE4Lx7P/FN6WbigfsVuBwO3QnSDqPrdjufJfXgq3E2OxQ/19VpH42Y?=
 =?us-ascii?Q?2lKMnVHLJP4UizXDeLLXxkTXTbsT7ROoTKyeWT9dJZAG2ibZcj6ZWiRmKSUn?=
 =?us-ascii?Q?meuf/mhz0Hv/a6WTtRiEgF0tiwoBvzqYCUmh9FSFgRQwNXjASJiFfeGU2NuV?=
 =?us-ascii?Q?NYwEPH8jcAClxav94uV5YcpLjo/tpWI4ANSu7XcTxKPlUct9XDj8N70+jgt5?=
 =?us-ascii?Q?NtMiqcQr5tP5cviH34RV1TdBA49xoELRi9GewPmSr/HpVhDMyrLYtzYwpKKb?=
 =?us-ascii?Q?AA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aaa74dc-80ce-45bf-2cdb-08db3782c081
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 16:11:31.7502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D7NLZ4iWr5nMRGph/zvYWGRVRxmhp7mBnGU043iSWTLmps8FQqlvo/0NRVopaVsS5ffOAtobmD4ygreVa8Rsbec4piCK/861wr2Aos8CfHE=
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
> Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
> pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
> create_root_hv_pci_bus() and in hv_eject_device_work() to address the
> race between create_root_hv_pci_bus() and hv_eject_device_work(), but it
> turns that grubing the pci_rescan_remove_lock mutex is not enough:
> refer to the earlier fix "PCI: hv: Add a per-bus mutex state_lock".
>=20
> Now with hbus->state_lock and other fixes, the race is resolved, so
> remove pci_{lock,unlock}_rescan_remove() in create_root_hv_pci_bus():
> this removes the serialization in hv_pci_probe() and hence allows
> async-probing (PROBE_PREFER_ASYNCHRONOUS) to work.
>=20
> Add the async-probing flag to hv_pci_drv.
>=20
> pci_{lock,unlock}_rescan_remove() in hv_eject_device_work() and in
> hv_pci_remove() are still kept: according to the comment before
> drivers/pci/probe.c: static DEFINE_MUTEX(pci_rescan_remove_lock),
> "PCI device removal routines should always be executed under this mutex".
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>=20
> v2:
>   No change to the patch body.
>   Improved the commit message [Michael Kelley]
>   Added Cc:stable
>=20
>  drivers/pci/controller/pci-hyperv.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller=
/pci-hyperv.c
> index 3ae2f99dea8c2..2ea2b1b8a4c9a 100644
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

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

