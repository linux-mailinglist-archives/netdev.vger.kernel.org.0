Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847806EB4A2
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 00:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbjDUWXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 18:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUWXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 18:23:08 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020014.outbound.protection.outlook.com [52.101.61.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411091BE2;
        Fri, 21 Apr 2023 15:23:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOon/ub7rD0RUJFork7blrLbxzbJqxsMzlsbnUgU0CziKJFLJ7B5edA4/u6ab06gNvDJ5lR52P+9TFBaPgPnQkLOUae+SCzPuFr2d6fDe1tADX34XhyjyXXtocnxtMs3gHgz2sIlC/cDptkXGtoFKEOTAxzgml2hK+ncYShLhaOL14Oa/PMBk5t7WZxysZcND2yOlNLF4fD8qe9ZEFm3aDCKOWkkgaK/EyVe9bnUrzN4rzWFWDtLXg2hmhAfsvXCRMHI62NmUEaH83h0lmWeCkM50Mlnrs+ACQzPA2GYDgqRzviNAUjx1MsHTPytxndmv43dTpg3wY6TzUScTVqDwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4suVS48XdwgHpvuiu+Yhj0EJk7aK+3Xr8FYUV7Aj6bE=;
 b=bEh2bLwV6m/0pjLn1hGnXc3w74JhdOHjtTY8YmSY/XOQvQqKEUfTyMnNlvBYgItS5iB7A4+IKSUUhlV3nUYu6QZizO15j/ZMYsQ/beO0D531w/JBnqjSKCuMnGUIkRrBAv5nqbTNBrTqBFfNT71Z/NXLRn8IDKRFMCwpF+ow89JvuIETDuVzfO41Ed2X8GgXsF/HHSf/VF6ROY8fRzPlcc3PoHnMHrKd/s7ft9mz0Y5632suA6qZZuHjHilRVomehXaDIetCZBz5a+p/5RG/Q6pjp7v7EF9tkN5Jo1/C87TuMa+7eh5lEl+9lr8Q0cczSOXnioAMJE0N5uJacblA4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4suVS48XdwgHpvuiu+Yhj0EJk7aK+3Xr8FYUV7Aj6bE=;
 b=H9ZbPlCoh6LKSe4fckvjUnO/Qzq+fZtrM80mtpCh2S24gzqr+xF41dVxSfoZuHdwCwad5sU1kEgmi19Qfu2e3Uslzq/3PxbIZkZbv5EJ/3xrdS+k22CDX6uMXf7ffSL4HzcbshT1VSH75o1PaXMlp/G/NAJ4YU0xM3pS7bAe0wo=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by IA1PR21MB3737.namprd21.prod.outlook.com (2603:10b6:208:3e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.1; Fri, 21 Apr
 2023 22:23:04 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::eeec:fa96:3e20:d13]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::eeec:fa96:3e20:d13%6]) with mapi id 15.20.6340.009; Fri, 21 Apr 2023
 22:23:04 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "'bhelgaas@google.com'" <bhelgaas@google.com>,
        "'davem@davemloft.net'" <davem@davemloft.net>,
        "'edumazet@google.com'" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "'kuba@kernel.org'" <kuba@kernel.org>,
        "'kw@linux.com'" <kw@linux.com>, KY Srinivasan <kys@microsoft.com>,
        "'leon@kernel.org'" <leon@kernel.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
        "'lpieralisi@kernel.org'" <lpieralisi@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "'pabeni@redhat.com'" <pabeni@redhat.com>,
        "'robh@kernel.org'" <robh@kernel.org>,
        "'saeedm@nvidia.com'" <saeedm@nvidia.com>,
        "'wei.liu@kernel.org'" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "'boqun.feng@gmail.com'" <boqun.feng@gmail.com>,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        "'helgaas@kernel.org'" <helgaas@kernel.org>
CC:     "'linux-hyperv@vger.kernel.org'" <linux-hyperv@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        Jose Teuttli Carranco <josete@microsoft.com>
Subject: RE: [PATCH v3 0/6] pci-hyper: Fix race condition bugs for fast device
 hotplug
Thread-Topic: [PATCH v3 0/6] pci-hyper: Fix race condition bugs for fast
 device hotplug
Thread-Index: AQHZczGRNBEm3wYLi0mCVhJUsObBRK81ANQggAFVMfA=
Date:   Fri, 21 Apr 2023 22:23:03 +0000
Message-ID: <SA1PR21MB13353B83E4DE3E6EEB62483ABF609@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <SA1PR21MB1335B7E8FFBE1C03E9B0FDE2BF609@SA1PR21MB1335.namprd21.prod.outlook.com>
In-Reply-To: <SA1PR21MB1335B7E8FFBE1C03E9B0FDE2BF609@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4e85d79e-2b8e-4358-9752-9918b95e1f18;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-21T01:50:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|IA1PR21MB3737:EE_
x-ms-office365-filtering-correlation-id: e5e81ac7-31bb-4e06-30ac-08db42b6f97f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kxxe8oyvjVsSmsWdMiiVPl4DvbGJSvpwPUEXrrdc6l7rF9dS3AV359BNcB/QK8ROg5M16WKh0xsOJrsyKAx17Ou66zfOJcMRfwVMq9KTsGe2+n/gwmjXBOSkgRrK7alyfR5uVuiX5QJhbaQbZj0eOaR3V4TTA43ucISIrgYdzvkmzo9RRcxYhMSxrC0O9XeE88yJhZXrv8ADCbX9qS9RJqK4a0YEEL0InYQR/EmO8XGkc6mdDUiPT+3HIh6thFlfCCUmwZTTfUJpyD7Z7UMMz10MdsNxEr9z8BWoYpCho0mAPJkCG2c4yKFjWBdM3Rdj918jGajFu5mXZpVy836pwgs5vhproGy42HRzt/QyNyo0UKC2y0p9eLpEmgiY0qAsfa34ZhH8KvfOoHrpxICKGvTFPaLX62f6kZtN4QQoPpckuDgInpYBM38onBKbCtU9uZ9JpOGjynuZOdpAJm5xqq0fGkpW0viwWgmyQVNaLw7NZy116p1E1KkKOug9NcEfm6H9c4OjI7NWoWfN3ex/tvVNsFJhNHFOFjHUp4Yva+RS66DhRDG1wsIfvfl6Q7L7keo6YEp9slxCE3ZxWE5/+dcjGo2BoUCsTFum8+gX1JLFtuJ9w+GASik13lgDvGwnUHADAts5r7G8DeWjWrqeoPX5VLnmb25CjmFQILm7pGSBRDyvaqQLA+mmdILXTk/Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199021)(33656002)(76116006)(110136005)(4326008)(316002)(66556008)(66476007)(54906003)(786003)(966005)(66446008)(66946007)(64756008)(478600001)(55016003)(8676002)(71200400001)(10290500003)(8990500004)(5660300002)(8936002)(2906002)(52536014)(7416002)(38070700005)(86362001)(41300700001)(38100700002)(122000001)(2940100002)(107886003)(9686003)(6506007)(82950400001)(921005)(82960400001)(186003)(83380400001)(7696005)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ugwjYiJfYV09rS4vFM7W+qGNTKFilJUVq0VmejvrhdDeypeX3tqumGSUCc4R?=
 =?us-ascii?Q?R9Ltli/HAkfpw5xtHOyMkdGmbEXd88P9TIC0q+b6Ic5Cd49VB/fSAbgWmwlj?=
 =?us-ascii?Q?AsU57YM6OfhX6e4jhqE41QRVR6SU4MLDknu80pXTChIkDMyuKDUTzToitwCT?=
 =?us-ascii?Q?ZUNU3ZoqakKbNdy0p2V7p91AB80ulqKTg1CQZq6t+a61eHBgOZis+h4vxrTO?=
 =?us-ascii?Q?j1D4zpN/JsJGaWdo8gpYasaoOHGbFGGDKmqUCNZz7tIl8hXqNAjUXst5Tgpq?=
 =?us-ascii?Q?0nPTk1O9cuam5df1Ptz9YqJgwACpmyDxwyqmPfLDermlzyt9Mwg3/xNbn3ic?=
 =?us-ascii?Q?RHBu5fSP6PgM1RK4RqaSELNkX70nTMPmhl3483nN7cfp9g9f55F/D8InMdvN?=
 =?us-ascii?Q?sLipouprcbgMDs6cDT+uqEiuFayTtbDA5e4BqeWhqjgh/GWmXAJlrQPv9Xt6?=
 =?us-ascii?Q?6sA3DAcGZR6ii1+HUWeXYIi8lkbtzZWtokAPk5pDG02SvD0j7Du5K24prc2z?=
 =?us-ascii?Q?9ENqbvwO/YisEGq3pCusH3BLJa6x7hES9m5q/OhaydI1uIF6yACs1wiZEYKx?=
 =?us-ascii?Q?/Z8AbhjZVDVVhoMR3bgubm3AXSfy4EqceflByvjaL1mTRfFqzOpWNpJgZ//B?=
 =?us-ascii?Q?IlrQpyDif7AE5CIVDiz0b47N3YiIRSMSiPppMU1u6IWciuAcMLh2Vo3OKWZ/?=
 =?us-ascii?Q?vzcQ0g+xoqA8oHL0YBIB7axEl+9B3TziKC4I+fVyaSK0NUJx6X8NujNFRdQo?=
 =?us-ascii?Q?+/otCdTbDXEY46GHzkA0SevPuUyiM91iQGV6SEmOJKj6uCZdrvW+K13wtv1J?=
 =?us-ascii?Q?cI9mw5JH6HX+5Qr5AYBA57XUpfEy5oR7MtFF6XnHsUaGlHniRXWmvrNoJR4w?=
 =?us-ascii?Q?vrNdK1yN2iMn7iwwlvmWWbjhVxCHkb79jf679DLwq2TvmqxzdbpUKcAivsgJ?=
 =?us-ascii?Q?sKkkCvXAdL3viITmnq9+0kSUJNMAg6zFJ1IwWITqfiBWZJcaabqqjXOdTI3z?=
 =?us-ascii?Q?kVPsHqJ47LGF3NSS3HJNtpfn5S36n9qtkMESqVML4LxuDu+E0J3XxwwenjNZ?=
 =?us-ascii?Q?SbauwpNl7paEJGU13aM1HHN67yF5bNbgrYphbYbfZZB6ZvzPxl3AfxUyFpiT?=
 =?us-ascii?Q?nUiZg7iO4/6q39HGgsmgzqjq2mLngWl8GxenRMM5BdlB5dskj+iDg6wcc3Gn?=
 =?us-ascii?Q?uKLvhpRi8mCOx4f4oi7XTYl9EHcHKXH+iexFK7KGK09BsMB2DwLbnNyAjxA0?=
 =?us-ascii?Q?lmjIjHNGM9paaiG/T+t3GiF+i3B86QkCe4tFfKLgUuprrtXjxTiy/zD92A11?=
 =?us-ascii?Q?4twiTEbALry+nvqs1n/UbGLXIJuXooDMsP2gAvdl1cF+tnBy6rLoh8LZepGQ?=
 =?us-ascii?Q?6uH/YejaVGV1/B/kD+ngChO4nzpHHRx57biAiWpIAHEo6IU4kV8wzQSoLb/f?=
 =?us-ascii?Q?IQyH1og4GbV6kGWquN2VnmLXDmx3FON2p1uP6pcBn8rbhLCnnoMC7eyQ+C7U?=
 =?us-ascii?Q?tPyitBRA3H8R9rhtYzA4cqfsehLzrI0LVmhjuHvEQef5Y2br87BN8cWLtI4x?=
 =?us-ascii?Q?TiD6QPnfHlABM2OEW0q4/RGM4VvnpRMg0+95Ujse/B5osDUPDa6x08izxOw5?=
 =?us-ascii?Q?PGMjJJTL4DN9iNTvg+egTx/uqz/YBboTHnEmiBFMKtrh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e81ac7-31bb-4e06-30ac-08db42b6f97f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 22:23:04.0129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EoNboWjUcPns7lqfzrbzcowqZDo2n7UnIfb98aBulPogYFFweceTsUUgUf0NXdRR3mNDAl2tc0oi2lOKXztCWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3737
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui
> Sent: Thursday, April 20, 2023 7:04 PM
> > ...
> >
> > Dexuan Cui (6):
> >   PCI: hv: Fix a race condition bug in hv_pci_query_relations()
> >   PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
> >   PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
> >   Revert "PCI: hv: Fix a timing issue which causes kdump to fail
> >     occasionally"
> >   PCI: hv: Add a per-bus mutex state_lock
> >   PCI: hv: Use async probing to reduce boot time
> >
> >  drivers/pci/controller/pci-hyperv.c | 145 +++++++++++++++++-----------
> >  1 file changed, 86 insertions(+), 59 deletions(-)
>=20
> Hi Bjorn, Lorenzo, since basically this patchset is Hyper-V stuff, I woul=
d
> like it to go through the hyper-v tree if you have no objection.
>=20
> The hyper-v tree already has one big PCI patch from Michael:
> https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git/commit/?=
h=3D
> hyperv-next&id=3D2c6ba4216844ca7918289b49ed5f3f7138ee2402
>=20
> Thanks,
> Dexuan

Hi Lorenzo, thanks for Ack'ing the patch:
  Re: [PATCH v2] PCI: hv: Replace retarget_msi_interrupt_params with hyperv=
_pcpu_input_arg

It would be great if you and/or Bjorn can Ack this patchset as well :-)

v1 of this patchset was posted on 3/28:
https://lwn.net/ml/linux-kernel/20230328045122.25850-1-decui%40microsoft.co=
m/
and v3 got Michael Kelley's and Long Li's Reviewed-by.

I have done a long-haul testing against the patchset and it worked
reliably without causing any issue: without the patchset, usually the VM
can crash within 1~2 days; with the patchset, the VM is still running fine=
=20
after 2 weeks.

Thanks,
Dexuan
