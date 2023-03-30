Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21AE6CFAA5
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjC3FR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC3FRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:17:20 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2098.outbound.protection.outlook.com [40.107.117.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8745B89;
        Wed, 29 Mar 2023 22:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WojBwx53PtLk/mWnkACbD/mFVH/dDpkpjGev9sFlvmrt2mDgqke8ZcSd1Cj35AOb9zUDMF6hILB495vvlx3CXN9yu7O+ymY+bpQCZvnlIXtoODGY4+olYMpE+BrXnahWIBeTXTiNYJsL68JDDf0VBua4DbYTXbw7DZVv9EfBSqR4LpZYmMSh4TtXvsafuULp1jarZepeN1B9s7GEfs/LlxTISWolLii/ROb2zUjlCpXKLmwsOG6ME9VahfdsZw+arQFgx4QtRiYnM6P02wRmvDQnh31vXgco6oPmZBqOOcb8JJFi1ho8V43WqjtXlas9y8VGzkW9s1isWo3h8yBLMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlYD1zoxVHMgkh/XHNQvEm7APlY/N6YQFJwv9HqIgUw=;
 b=VNImZ8AB13Bx6Qjcve/4P89DEf3Jow4Nf/zDeW55LbMdOgLSDIVIxQY/+3Cmb1cxFM9XMI/hQpKfwknoPgtuz9dH6McliaEhQ2xiXFQGzzcLsoV0/+Lp7CquDlWwVB66bMGbQlm14bN690pEUUMMQaPLzO990TY2lJjGmjVN1H/vpmDqHPeGhshKd49i1Gjpmr6Vo8/5vv4aVTUsRUScLuh5PGRQopKYgbWZVqxb9LSSz9Il8Qnt/bfGS2AOb5PSeh4IPTKy4PoUydVwXvnkNDQk+9OSB7BebqRKpEKVRobvQ4BpwHz7GmqwEDMye/4mgBBCm60dqnlPWlmXWzaZog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlYD1zoxVHMgkh/XHNQvEm7APlY/N6YQFJwv9HqIgUw=;
 b=auWqX4Ts3z80ECIzh13O5PEc3QNkW0fmkW9xu9WuI8XpD6uAzVT9Pwv1om5EY354hphpQtOjS/VThvpYTnRRzfA01TjcO7AgGduyWGzN+Ahwmeeg29TEa26TtnZH6tVcSuOcTeCG/vHVAyq5IHn6oDck8LUd5zXJjbiVaA9SJN4=
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM (2603:1096:4:fc::7) by
 TY0P153MB0781.APCP153.PROD.OUTLOOK.COM (2603:1096:400:267::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.13; Thu, 30 Mar 2023 05:17:05 +0000
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::9544:9f03:90e7:b2cb]) by SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::9544:9f03:90e7:b2cb%5]) with mapi id 15.20.6277.013; Thu, 30 Mar 2023
 05:17:04 +0000
From:   Wei Hu <weh@microsoft.com>
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
Subject: RE: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Topic: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Index: AQHZYTE02QJw3cJyrE2OQ7EX2SDB268Pu6LwgAMPN3A=
Date:   Thu, 30 Mar 2023 05:17:04 +0000
Message-ID: <SI2P153MB0441FE43849F116C84C61A8ABB8E9@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-5-decui@microsoft.com>
 <SA1PR21MB13356A77700580DF0C742856BF889@SA1PR21MB1335.namprd21.prod.outlook.com>
In-Reply-To: <SA1PR21MB13356A77700580DF0C742856BF889@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6f6d75c5-e156-425e-9f36-09272bf9a5a0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-28T06:32:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2P153MB0441:EE_|TY0P153MB0781:EE_
x-ms-office365-filtering-correlation-id: 4a79bcab-c212-4f5a-cb3f-08db30de001e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mANX8sI8VT49aNJQpCYL6Ebh35iSUq2DxCyyCHKD2GrzawDb2soU67mfMdaZ3iUvq/oyck1Ulq8m5u9VUyoq4geBN+VQvahDn5ylGDCXX66GpioBN31L9HYLbaF7b8U0I0BTa4LAhUNm9iSOTTrmJyQ9CI6AnCTuGhRhQGAuATU/xV8XgxIJK39XtIrLcvdpGP6SHyvVJjPrSrkpyXSKGkeQF4mzzwIRv2xBJQ5w0bZUhApDXnVj6ldrw1pCo2He10p7/lETpdNLwg5j+ZmSVdKo1EqhaHdYm0t7XvnNQgKuETJv+i1e51C7MQVPZPzEznSSnyhqNh/hBKBKziI5bcDwtrGC9575qTZdoeyyk/h6cQOCKJ01++bNCdByur7fGGixW9JBQe2peMK9UheSlaG4NaVTNnn+i30tvNDCf0dH2QO+B2lOYLFWyKBalgpHailZ99j18EG4DvJmccJADwlJhSvrqNxr5R0oWOnbSmoazBHdgY3Et/0dkteN4SGU4yce5jFcP38My0I1CbDI6LCNb7kwYAajNCvXLO9tSP3MD0q55GPGgW3Qf7XC9Gsa7Hbho26t3YZvFnq2k/5Ezrvj+mcOPK9CY9JBXmHZYkXGJgHVrVC/gLKFagLtrTu4Bmm0CWKBzjDalB5Pl07eCZJS4gAD/KcsihhBnR3cmATLdOQsarQ90bf865HoP90i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2P153MB0441.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(33656002)(921005)(38100700002)(122000001)(7416002)(5660300002)(8936002)(38070700005)(82950400001)(66946007)(66476007)(76116006)(64756008)(52536014)(82960400001)(55016003)(4326008)(66556008)(66446008)(8676002)(41300700001)(83380400001)(26005)(54906003)(9686003)(6506007)(86362001)(8990500004)(2906002)(478600001)(7696005)(186003)(110136005)(786003)(10290500003)(316002)(71200400001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R24EYbQ3Vv96k0ka/mNgX3Phk+GlrEY+J8vT2+OVoZ0DJR9h7RmBMaXzUxc3?=
 =?us-ascii?Q?woHyszk+MD5SiGMa5NNFN58J3M8McH14EhgIIPVCe7Qe8YoBnJtjq5+m7gWp?=
 =?us-ascii?Q?djwbGzcYdsjeWpGf3l2S9H2n9pWbCHM6Gc+GWfRtjkRHxD7rF58RY2iSp3C1?=
 =?us-ascii?Q?fmoRsZROALlFvHZp2Tac2rb/xox5m7jpGZqA0ZO2j3LSZ+3vgcJq8oCim8sV?=
 =?us-ascii?Q?nNHJ/ycVEGLTRbo3ceBOu+IelBD9J8sBs6vHJfjrnBNp4PrYBdvta+YTOpEA?=
 =?us-ascii?Q?iJAqZ3lpb2hnGdjP583VMA2O1FmNS+8NX+LIGzpWJXXpf1syLD/GvXB0lq5f?=
 =?us-ascii?Q?hdBLymITvCoCS3mZXtQRhclQmm4R7Q+nHrH3zM+GTVkDUHe9z3NKZ2nosZMG?=
 =?us-ascii?Q?vNL8VPh3s6UP9HCnbYRVRL2APawfCp4b2u05ixqCIfdCPBL0b4EFwy+x+jlE?=
 =?us-ascii?Q?YVyWThElL8Q0Gj20eIXTwSJrUOAnynRiXedmddyRkxG3TPU/BblgIpBhk/zH?=
 =?us-ascii?Q?zAl56fFDJ+ZjtAA6SNELIRXTj3rD3JPLj4FyuwyRtw7LH/+hU9a6gELvT3ez?=
 =?us-ascii?Q?suwJ4NKdcIuoTpd8yleJH7qKoRKlZIom6KpWUeYd0VynbIUcrPOSHc01nyoR?=
 =?us-ascii?Q?949+8w1B8cOGW0LlqsM72wS1UmRSAI+wwrPG13vomKSeEwyUwm4RjnQPGVEH?=
 =?us-ascii?Q?l6NpuxAYZ7Jp2+yDHe3muKzMf9uHGzHd8H+b1EGs+uolmXOjTsvZc5yX6hyF?=
 =?us-ascii?Q?mLVEHGJwSiR/GB59nlJR+jXXCgRSzHvoRHXiN7PdUKEeCaTU3Cwyhvfj4/xt?=
 =?us-ascii?Q?hNWuiWcEp1ALPfJqcyT4mBO+pr3tVc/baFdJrics7vQiBbRNvCtTwUyK1+iD?=
 =?us-ascii?Q?k3xctvw5vwblzILCupxcTRjYXyM5ICD7irsM7zYJHC4OPnOtMuCJAWMqRNIU?=
 =?us-ascii?Q?0rgmpusUTdsm4rjYDXwlF5y94EDQQtniQKm+J9mU8XNSgoCRz8Px5zX7skOz?=
 =?us-ascii?Q?IjZbuEu90NfDKGlVzjJDYh32nPIelIv0l3d1q+YPv7UtKRrqd7lXDMM2YQaN?=
 =?us-ascii?Q?WsXvZyYiDpcKK0TGphGjWVeO5LE9qpO7TagXJmQDcpf1SeM300cCpFT6kNk6?=
 =?us-ascii?Q?6JtkKxqhdEmAzDUCibklV6EE5jsyli5EAl0YKRzev8SQ2XJc2MW2vdpOhiiq?=
 =?us-ascii?Q?u+W1dy2+1YR6NYIJpeJ7VyA2E+JFWk57U6cXOeL0Rwmifvg8k4PoUps8/IQR?=
 =?us-ascii?Q?qoVrdX8z8D/pgqtK7G3H0b2dTtd7aThamTUX8jrLMQt0CGNaIeDBxU9wrFfm?=
 =?us-ascii?Q?NEg9jeUJqJcqklXK12NCpSDVkQ1zcFfEoqdtYVA9oP7MgGZ7n3NYOL1xPHOD?=
 =?us-ascii?Q?qOIQ/+JKa0k/YvVTPis+/qNlcU+tl1gNF06CUD+Cl9Yiyib4MT+HNk/mfgRk?=
 =?us-ascii?Q?p3kqMHWn2PG0TP13cd/1uJ71pb8bMTCiSjmFc+xWQf9DdnKFMiCelrS31eN4?=
 =?us-ascii?Q?3KXJRqRgX2ceJlYScq1SbWiBWs5ZpvTtvi34/HF4f3W25bLC+LreWXgNoSbP?=
 =?us-ascii?Q?Ky8v4fbjrkjICqS1k10=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a79bcab-c212-4f5a-cb3f-08db30de001e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 05:17:04.5547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QooUtAVnuHzKxH0+ctcC5sAb/V5qFqThTmfwMLbvdInmjfDXLLjaHteoeAAYrocbQCbJGb1zUgkSCAYL1cLEIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0P153MB0781
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Tuesday, March 28, 2023 2:33 PM
> To: bhelgaas@google.com; davem@davemloft.net; edumazet@google.com;
> Haiyang Zhang <haiyangz@microsoft.com>; Jake Oshins
> <jakeo@microsoft.com>; kuba@kernel.org; kw@linux.com; KY Srinivasan
> <kys@microsoft.com>; leon@kernel.org; linux-pci@vger.kernel.org;
> lpieralisi@kernel.org; Michael Kelley (LINUX) <mikelley@microsoft.com>;
> pabeni@redhat.com; robh@kernel.org; saeedm@nvidia.com;
> wei.liu@kernel.org; Long Li <longli@microsoft.com>; boqun.feng@gmail.com;
> Wei Hu <weh@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; netdev@vger.kernel.org
> Subject: RE: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
> kdump to fail occasionally"
>=20
> > From: Dexuan Cui <decui@microsoft.com>
> > Sent: Monday, March 27, 2023 9:51 PM
> > To: bhelgaas@google.com; davem@davemloft.net; Dexuan Cui
> > <decui@microsoft.com>; edumazet@google.com; Haiyang Zhang
> > <haiyangz@microsoft.com>; Jake Oshins <jakeo@microsoft.com>;
> > kuba@kernel.org; kw@linux.com; KY Srinivasan <kys@microsoft.com>;
> > leon@kernel.org; linux-pci@vger.kernel.org; lpieralisi@kernel.org;
> > Michael Kelley (LINUX) <mikelley@microsoft.com>; pabeni@redhat.com;
> > robh@kernel.org; saeedm@nvidia.com; wei.liu@kernel.org; Long Li
> > <longli@microsoft.com>; boqun.feng@gmail.com
> > Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-rdma@vger.kernel.org; netdev@vger.kernel.org
> > Subject: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
> > kdump to fail occasionally"
> >
> > This reverts commit d6af2ed29c7c1c311b96dac989dcb991e90ee195.
> >
> > The statement "the hv_pci_bus_exit() call releases structures of all
> > its child devices" in commit d6af2ed29c7c is not true: in the path
> > hv_pci_probe() -> hv_pci_enter_d0() -> hv_pci_bus_exit(hdev, true):
> > the parameter "keep_devs" is true, so hv_pci_bus_exit() does *not*
> > release the child "struct hv_pci_dev *hpdev" that is created earlier
> > in
> > pci_devices_present_work() -> new_pcichild_device().
> >
> > The commit d6af2ed29c7c was originally made in July 2020 for RHEL 7.7,
> > where the old version of hv_pci_bus_exit() was used; when the commit
> > was rebased and merged into the upstream, people didn't notice that
> > it's not really necessary. The commit itself doesn't cause any issue,
> > but it makes hv_pci_probe() more complicated. Revert it to facilitate
> > some upcoming changes to hv_pci_probe().
> >
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > ---
> >  drivers/pci/controller/pci-hyperv.c | 71
> > ++++++++++++++---------------
> >  1 file changed, 34 insertions(+), 37 deletions(-)
> >
> > diff --git a/drivers/pci/controller/pci-hyperv.c
> > b/drivers/pci/controller/pci-hyperv.c
> > index 46df6d093d68..48feab095a14 100644
> > --- a/drivers/pci/controller/pci-hyperv.c
> > +++ b/drivers/pci/controller/pci-hyperv.c
> > @@ -3225,8 +3225,10 @@ static int hv_pci_enter_d0(struct hv_device
> *hdev)
> >  	struct pci_bus_d0_entry *d0_entry;
> >  	struct hv_pci_compl comp_pkt;
> >  	struct pci_packet *pkt;
> > +	bool retry =3D true;
> >  	int ret;
> >
> > +enter_d0_retry:
> >  	/*
> >  	 * Tell the host that the bus is ready to use, and moved into the
> >  	 * powered-on state.  This includes telling the host which region @@
> > -3253,6 +3255,38 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
> >  	if (ret)
> >  		goto exit;
> >
> > +	/*
> > +	 * In certain case (Kdump) the pci device of interest was
> > +	 * not cleanly shut down and resource is still held on host
> > +	 * side, the host could return invalid device status.
> > +	 * We need to explicitly request host to release the resource
> > +	 * and try to enter D0 again.
> > +	 */
> > +	if (comp_pkt.completion_status < 0 && retry) {
> > +		retry =3D false;
> > +
> > +		dev_err(&hdev->device, "Retrying D0 Entry\n");
> > +
> > +		/*
> > +		 * Hv_pci_bus_exit() calls hv_send_resource_released()
> > +		 * to free up resources of its child devices.
> > +		 * In the kdump kernel we need to set the
> > +		 * wslot_res_allocated to 255 so it scans all child
> > +		 * devices to release resources allocated in the
> > +		 * normal kernel before panic happened.
> > +		 */
> > +		hbus->wslot_res_allocated =3D 255;
> > +
> > +		ret =3D hv_pci_bus_exit(hdev, true);
> > +
> > +		if (ret =3D=3D 0) {
> > +			kfree(pkt);
> > +			goto enter_d0_retry;
> > +		}
> > +		dev_err(&hdev->device,
> > +			"Retrying D0 failed with ret %d\n", ret);
> > +	}
> > +
> >  	if (comp_pkt.completion_status < 0) {
> >  		dev_err(&hdev->device,
> >  			"PCI Pass-through VSP failed D0 Entry with
> status %x\n", @@
> > -3493,7 +3527,6 @@ static int hv_pci_probe(struct hv_device *hdev,
> >  	struct hv_pcibus_device *hbus;
> >  	u16 dom_req, dom;
> >  	char *name;
> > -	bool enter_d0_retry =3D true;
> >  	int ret;
> >
> >  	/*
> > @@ -3633,47 +3666,11 @@ static int hv_pci_probe(struct hv_device *hdev,
> >  	if (ret)
> >  		goto free_fwnode;
> >
> > -retry:
> >  	ret =3D hv_pci_query_relations(hdev);
> >  	if (ret)
> >  		goto free_irq_domain;
> >
> >  	ret =3D hv_pci_enter_d0(hdev);
> > -	/*
> > -	 * In certain case (Kdump) the pci device of interest was
> > -	 * not cleanly shut down and resource is still held on host
> > -	 * side, the host could return invalid device status.
> > -	 * We need to explicitly request host to release the resource
> > -	 * and try to enter D0 again.
> > -	 * Since the hv_pci_bus_exit() call releases structures
> > -	 * of all its child devices, we need to start the retry from
> > -	 * hv_pci_query_relations() call, requesting host to send
> > -	 * the synchronous child device relations message before this
> > -	 * information is needed in hv_send_resources_allocated()
> > -	 * call later.
> > -	 */
> > -	if (ret =3D=3D -EPROTO && enter_d0_retry) {
> > -		enter_d0_retry =3D false;
> > -
> > -		dev_err(&hdev->device, "Retrying D0 Entry\n");
> > -
> > -		/*
> > -		 * Hv_pci_bus_exit() calls hv_send_resources_released()
> > -		 * to free up resources of its child devices.
> > -		 * In the kdump kernel we need to set the
> > -		 * wslot_res_allocated to 255 so it scans all child
> > -		 * devices to release resources allocated in the
> > -		 * normal kernel before panic happened.
> > -		 */
> > -		hbus->wslot_res_allocated =3D 255;
> > -		ret =3D hv_pci_bus_exit(hdev, true);
> > -
> > -		if (ret =3D=3D 0)
> > -			goto retry;
> > -
> > -		dev_err(&hdev->device,
> > -			"Retrying D0 failed with ret %d\n", ret);
> > -	}
> >  	if (ret)
> >  		goto free_irq_domain;
> >
> > --
> > 2.25.1
>

Acked-by: Wei Hu <weh@microsoft.com>


