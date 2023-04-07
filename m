Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833266DB017
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjDGQEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDGQEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:04:02 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021026.outbound.protection.outlook.com [52.101.57.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF030B8;
        Fri,  7 Apr 2023 09:04:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+vjYHV2RpPELqP1VAb94F//wwKLfeTQWolzJxXT1PMJEyymKGAbfC+kUJ3H6YojqmW5plhxDbASmzEO2sveYfCCLUWZU1teYt70AvTL1SUypc5hgJRrnD3w3//ltH1aXQnSxG/oV5rrlKCYhcyf5dP3PB+7/0fkUMJ3gz9u2iTL6Nth/mau3Wnai8rTw/qXXO+RtAYNUEp7pA5OZBTudQ/vp9MUmBXlpA4tCxlVn+qHa9n+ahBuT1Nv9tRWnrOOm5nv3wrxvF5uuQjh7D5AkIsLy94cWOmLJMY1UAov1W+AZykkDFqLtuA3s73MtLkQRbmKzWgQfS4laX4eFhnx8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4lmz2FnmJIjoziYKrqG7Nr3moOZVo1SjROCAn7lFiE=;
 b=eODVmQiK2XvSBMLJwgWMD7wLxSmCWnbXXs3VdfEjqD18Z10CPTvR5DMhIhH1bsnM2IlvJOn0TPat90ML+uOa9QmrAK2g3ZF9zI08YLEE8T0b5rqW08E3XqhYTmuTg76Llk936o4tN77jmdMurtu54PWUVGiCuMT5RMPbqXQSKRhHb3HVZAjGGbOdBRR2K0OSsdwIn4NAIzw54sC95S8mtgcQ594oxkUiere01A+DE9QCZ8w2Yt//uHkDw66eR3luB/v8m0i2ppxdUmdaq+/bDx1yJbC6EmqM1TgqptOPzVsUeDgQVLONyW1cKewzYNt1XzVd6e8qg7Z2Pb6J15NoAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4lmz2FnmJIjoziYKrqG7Nr3moOZVo1SjROCAn7lFiE=;
 b=Ybr3BVaABrPP+jNM2kRWnsnaUTiRtnjwBGumrPDRWorIP4hQ2NcNp+x1PRKuW0sbWL0yBn6xo+uDtnNMN8JVf7L8Tqe+yrreF0/UM9nVyOkpokWhXXqHx53MZCJgxc2En/4ipxf/Qz6/585ud9eVQvohMFXtPoWy8ca18Yw0foQ=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by BY5PR21MB1377.namprd21.prod.outlook.com (2603:10b6:a03:23c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 16:03:57 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 16:03:57 +0000
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
Subject: RE: [PATCH v2 1/6] PCI: hv: Fix a race condition bug in
 hv_pci_query_relations()
Thread-Topic: [PATCH v2 1/6] PCI: hv: Fix a race condition bug in
 hv_pci_query_relations()
Thread-Index: AQHZZpomvbk4R6YhiUi3EzsVimhRK68gB8Zw
Date:   Fri, 7 Apr 2023 16:03:57 +0000
Message-ID: <BYAPR21MB16883C7A762A013B791B6091D7969@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-2-decui@microsoft.com>
In-Reply-To: <20230404020545.32359-2-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0114b784-c581-4e48-ad4f-ba61c10da6d0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:03:27Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|BY5PR21MB1377:EE_
x-ms-office365-filtering-correlation-id: 29821df9-01df-4c50-8273-08db3781b1b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jdSJUZo5te8WXLg+/W4wLzf4uGhAmgOPKWov2AoRXif0bWUpwJrsiBFY7UZ6b/RcHPiZFEVQhtFu9e5mmaFEUFn/F/7oWQzcjrAyAQQcnpHC282B9Qna0rqPZT/HO+x+jftDXgKSwa6Ctef5pPzA2Tx/8W8mQY25zvS/9ZLhSAjqxBCkks8jMP3bHoe2L/45WlYugBuZGAQwYytJorx23EjF0ZhKM3OIuQv0ap1wdAqmeEi/BDtuwlZ1IoRbXRxhbQR2ms0BRY174Au2KAFT1/xRZs+H3/X76eKQ2MzvXtMueEB6NiqAZxvNFHuF7Zj6kcv3Cl++h+A08jh9OxTHT48Tehk2FuhZBoP9ZKmLnjJWnyNS59bWc/ONQXwFwEgWd3Infuo1pxl8rYdV2Ua1c3SP5ibvGhRZDu+esI/qdH3V1p0JkEgWVWiQFsz2v6tVrmrS4LG+lTaJXh9VaF8O8V/ufE2tnC+BUwCYlfT/YPAbYG3lOojJlVcdnUPySbBHJSuLhNWhqh5xbueLuBUmp8Ic3zkSyGl1hT15ZAZBEeKSO97eCJFtsslBydUsia55BGKuJyB2+SAyB0TlbpsT2fy1vI5v2KbjWrNY6sSvyAPVixMKpcD+Mp/nAF23l/9za+cEm0ZnbzCMYJIKVMpljWtyDEizG8kwaiN7kEW9I3lss1rS+kT9A3MSbqeXG5F+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(66556008)(8676002)(4326008)(66946007)(478600001)(64756008)(66476007)(66446008)(71200400001)(54906003)(7696005)(41300700001)(316002)(786003)(76116006)(110136005)(33656002)(86362001)(83380400001)(9686003)(6506007)(26005)(8936002)(2906002)(5660300002)(7416002)(10290500003)(8990500004)(55016003)(52536014)(82960400001)(38100700002)(82950400001)(921005)(186003)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L89sphVyD2l59ZndUEwJFFcYTyQYiOkqGIHZXxaF+TPH37doQgUhIf/sPVc9?=
 =?us-ascii?Q?ZaOOrk2Sfegv4LSDKp1XYFDZBTXHE315vZkm/T1/2E0QSFz10iRr5Ms3Atgr?=
 =?us-ascii?Q?kGGmrN3f/e26jnF6TXH8Lc5i+PxFq2TnEtHkecSwP8tJW3CS3ZcWXufMgabU?=
 =?us-ascii?Q?jDd6uXmv/YBUqfPDuTMrNYSQfu1DAyRnYK/0B04Cciffrjb/E0Kls/qUEJy0?=
 =?us-ascii?Q?RAhBJvpkJGX/2PLMs6R8kobT0/YA7q/qtCs5Va8ed5UhnlN0yvNKo/anhp9/?=
 =?us-ascii?Q?6KvkImUZymZJxAxSD5rMxaVwtApnI5uZ664+vHWEtHcB/mPAyWlVOixXukoz?=
 =?us-ascii?Q?hF4woKH8IfKj1RFqepZmyXIIQ4mBD4JOsR/a50zaHfIQTU97rIEjq2OHcD7m?=
 =?us-ascii?Q?QVoWAwLNs0mtZ/cgY9YnfT8UNM1EQo/oUrwSnp70U2DVKXlVnf6i3LqHWK6J?=
 =?us-ascii?Q?ljXtLlkHXgDybaZi7WSRQ6I3TlQoWnwOQZdk3RsTRW4EEzMWegpxdBg6N/OD?=
 =?us-ascii?Q?heSymViawgrI22cjoD83e5xXU8yty9OtDCdUGNmndO+uj4BECDv+Ci9dJJd7?=
 =?us-ascii?Q?F4bl0N8MZRPtieQdLphVaXzaVAHlwq6K+8DCV19QDiyN99Z4nn19WkuSGGdm?=
 =?us-ascii?Q?e0cY8W59T18mSNXHNNFweRzkRF7jmK25Am7lZ9g3M8jEMI6eaEq6OvZWTPBe?=
 =?us-ascii?Q?S8VrdbDzA39DycLkKmluE1r8rtjb8BUcHIVsuucQSeOqpsqHu98MEOtkO3ki?=
 =?us-ascii?Q?1WIsnkReNfgXdDC0LP2slpPkteEtsEiRBn6Rwg7PlZ99V9OXMmV5pmnzLXEf?=
 =?us-ascii?Q?Ggy/QACuYybuZjh+sE9hP2wLREJnk+EZl4VKqT5W0OrdXXwBIA2GhwEgDwik?=
 =?us-ascii?Q?6BQPZsKBxeW7+lXnm1xFovb4uP6Nu21D21/N4cL5on/fexYwXQxMvmpLoDPt?=
 =?us-ascii?Q?vu6FZ53eRNNeZhOponDWJoRY/yRpoWyd3IphXwlW77cqgi5xE5HNR5gW9Qjv?=
 =?us-ascii?Q?QQp2wrGsvfMKWLwI7ZjYoyELDd7HX90bIJh57+KMFmQxSTjCer1y6UA2t3W+?=
 =?us-ascii?Q?fF1Goi3zosLhzMAYQ7S6+bAPMa4X+3ZdNIXTG6XZ3CwWeevDKaI2uG34XxLP?=
 =?us-ascii?Q?ZfZ0AEujXDEuvNkgsGymSsHtVO35wDFHmcqbWJzEaDTs+TRIxGGpjG9e+Gd9?=
 =?us-ascii?Q?EcFK7x7TNzN5szJz0GAA5QN3xCKQ1pHcbcKJDFk97kZW8nufpf1Azy/0/dg1?=
 =?us-ascii?Q?8RcsYRicXhJ+8yuFlOpnnxv8bI90MxpyAlnGt7cQaTFjlwLMmWZu9CmwEuMv?=
 =?us-ascii?Q?mEzSd+0BpBHxyC062sTr2fs51ypdaTLl+X3woO6tgtTrEDu69/dQyxhm03eS?=
 =?us-ascii?Q?w7+Nchb4v75hEOJX0SPpsjeSUhU+tRqACsLKQZwyzHUCwBjutndZBh6N0e7T?=
 =?us-ascii?Q?m5zdN9B2wBSV7NOko3sFa/50zSJzwoOuzKi9KJ4Djyor+KbxG2UL7SdZx1Kz?=
 =?us-ascii?Q?vfy9S+XDtKSj4XMRZq536dGBzn2T4Kxwm4S5JKBrtNHhtNKHVHv7mtwnn1FL?=
 =?us-ascii?Q?y1epLoIkNJCawbTP0DiCucbP/rJHJG77Oi4axD1WkvP5pOss+1yY8+IzhZ26?=
 =?us-ascii?Q?qQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29821df9-01df-4c50-8273-08db3781b1b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 16:03:57.4911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zVDP+by0qg3pT8KLOMOon3Fbz1rWhSd+eq/y5BvyjpTzMHDAJAdiponQIfQ/QWbFuTOz6Q6wzuMO7ZUSn+gHFvVmAM4h7XWv5R35EK6PrnY=
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
> Fix the longstanding race between hv_pci_query_relations() and
> survey_child_resources() by flushing the workqueue before we exit from
> hv_pci_query_relations().
>=20
> Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsof=
t Hyper-V
> VMs")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>=20
> v2:
>   Removed the "debug code".
>   No change to the patch body.
>   Added Cc:stable
>=20
>  drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller=
/pci-hyperv.c
> index f33370b756283..b82c7cde19e66 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -3308,6 +3308,19 @@ static int hv_pci_query_relations(struct hv_device=
 *hdev)
>  	if (!ret)
>  		ret =3D wait_for_response(hdev, &comp);
>=20
> +	/*
> +	 * In the case of fast device addition/removal, it's possible that
> +	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but we
> +	 * already got a PCI_BUS_RELATIONS* message from the host and the
> +	 * channel callback already scheduled a work to hbus->wq, which can be
> +	 * running survey_child_resources() -> complete(&hbus->survey_event),
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

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

