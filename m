Return-Path: <netdev+bounces-1538-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F6516FE30D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DA4A2815A3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24EC0171C0;
	Wed, 10 May 2023 17:12:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB133D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 17:12:27 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020019.outbound.protection.outlook.com [52.101.61.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A956019BC;
	Wed, 10 May 2023 10:12:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myJY/0B0G0Xoiee2kdJrXKTnkoF42Gyt17Cdj8FbriLXTfSzyNPn18OywWjNB/doZkKvaSbvslZivrurkCXF+xifXOKndcOWaLJviFl/XLagXcII5zce+69hezO1GBtbwRyCQOjABK86VDXjBeWkwdANl6IQzUzUFaJe5mEk9h1qoUENlEqcq3YjW8mWufVSOZKintUgY4OlX4RplfaRR00c5OBBv2v32IM40siKrHOI7JNFVwDZWWcWYvXTjCTtEw+FB1mzLbjCtOfXaVaVGIvr8zDlr/KAb+8OwzbEVGvh9/cTu1dTF5HFa1JVCoSseObu8MEANqOXlEsNybnrMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmGaJ+7QJHvZA3lxxMY6Ka9nn0rWq79vVJxZ3i+pe5Y=;
 b=Tf9zXZxIJ7fNtLy0YL7MVS9WBntF6DJqp/felufA4ZdgiCDr5q33yWVb81xBq1NH8/yfWIwiKKlfjCjoxKWqa4AZbbHrTWLC+4VAKY1S3ar3iUUzNHCHAK1sdtjWLv4P0TmgmZVYd+h5JCeXGOKnH1DIOk36nfWvG8SLra3KFFuTpqJL3UKeg/ZDX6INihGsNuXKf71PD1EExaUtyPr/XlZ3dHM0VlYs1Y6u2LP64R3Ya8gL9f8/m7k3XMt5i38co6hGRKDIklYPofkfa0pw3YFSfN5/c/bva7/snrV9g29CT7HPhJUShOZGYPkJGwjSeiw9SRrwpWqcdkGDs+1s1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmGaJ+7QJHvZA3lxxMY6Ka9nn0rWq79vVJxZ3i+pe5Y=;
 b=MSE12b7YRp2B7kRpjwSWu9sNqKto7/Bu0vmA0EXAAL+yxX8EKtlf7SdyMk1B3KR8EarGV/6QnVvX+samGpR1GT7hVs8t54XmX2xGm+IMtkU0BqdrnZmSZsTcjWb6+JSIynvMjM5dC5UEVWJjLPYFuz5dOmb48vdQSa+HXpP+P/0=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by DM4PR21MB3176.namprd21.prod.outlook.com (2603:10b6:8:64::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.5; Wed, 10 May
 2023 17:12:24 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::c454:256a:ce51:e983]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::c454:256a:ce51:e983%4]) with mapi id 15.20.6411.005; Wed, 10 May 2023
 17:12:23 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
CC: "bhelgaas@google.com" <bhelgaas@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, Jake Oshins <jakeo@microsoft.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>, KY
 Srinivasan <kys@microsoft.com>, "leon@kernel.org" <leon@kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Michael Kelley
 (LINUX)" <mikelley@microsoft.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh@kernel.org" <robh@kernel.org>, "saeedm@nvidia.com" <saeedm@nvidia.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Long Li <longli@microsoft.com>,
	"boqun.feng@gmail.com" <boqun.feng@gmail.com>, Saurabh Singh Sengar
	<ssengar@microsoft.com>, "helgaas@kernel.org" <helgaas@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Jose Teuttli Carranco
	<josete@microsoft.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZgxiydynY9JdEwE2LUDobn6ASSK9TueZQ
Date: Wed, 10 May 2023 17:12:23 +0000
Message-ID:
 <SA1PR21MB13355D8F2A7AC6CA91FE1D1BBF779@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-7-decui@microsoft.com> <ZFtUgCVaneGVKBsW@lpieralisi>
In-Reply-To: <ZFtUgCVaneGVKBsW@lpieralisi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9404ba2f-9e11-476c-bee1-b05b22020f31;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-10T16:54:12Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|DM4PR21MB3176:EE_
x-ms-office365-filtering-correlation-id: 06c78f4d-9157-4b4a-184d-08db5179b8e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 AB0Dkk/XSm9Ykr50sDlRH7XIerAcUH75c5fJDmXlANjsiw11q+Nxg98Ot+MV+zXevDsZlyKdXy7b5JuGNcGmgGdruzw2tYb5qN2OAAf0O3fUxSEnFuHW/t1XuxrKkNPdsJq1Zr+pEPsMI5BjGLTeWr4gBICGstpq5eohm/55Ara9Fn5+8He2HyNfnVyrlWwyG0UplXkuVANMchT+037wcFvWcdA3BJd24J8JdNrip3PxsB3SL6d22vMehAoQ7hT/8GysP5BaxctCCO6Zpwxa69sI0xI/Sed30ago3nb9krEnLZ79p3V2hJd0g70r4Nhjlg+pKJzsgwB64uCAGCF0KipjizD3dKV39h+XuvrAXdaikyAVVc3CdXzRE+7UbQShzOO9+K4mBpaIei0Igm2MwqISKQRb/fh6mphmrer4palFHT5cyaz6mFN68O//RiTGDm8u+APC4bSh+xkMLxebqi4OTiiYmiuGG28NRLCZLENnc2kTljjWhk92UvQQFg7WjOU/IIw3xjRB/8g4qS6i/ad+l+7kEYNb7SbKLpcB3NE3WP6SgeDMqS6dRyp7EJJjDtfA4SNse1Q+xNZydgttu74wT9hYwio6Gc+8R57iSUwnWHtY2nyRMCISkqrRATz4Wh4F1+QMWvX7BuQqJwG+Gw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(8936002)(8676002)(38100700002)(5660300002)(2906002)(10290500003)(7696005)(71200400001)(966005)(86362001)(186003)(38070700005)(6506007)(8990500004)(26005)(53546011)(33656002)(9686003)(55016003)(52536014)(478600001)(7416002)(83380400001)(6916009)(66556008)(76116006)(66446008)(66946007)(66476007)(64756008)(786003)(316002)(4326008)(82960400001)(82950400001)(41300700001)(54906003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UnDS2tllRV5p9BpnWVm/9cS2XlQ08K9HO/yqjcreRtdAgTxB86wo/EkjGvD8?=
 =?us-ascii?Q?QJXLVxtVFc+3ngQ0Fnfmdaa74Fc9jdmKzK+67WPg0FaKP59OaS3AZEN5gFom?=
 =?us-ascii?Q?rTOoUULaM6MPrqXP94w0Df9qoGiU4SizFl7NujLCqZA+n8s7iqV80kczRfIa?=
 =?us-ascii?Q?Ox0jyrVyQ8XxFbbX68hn9eT1MBGS3k9wvy0Q20qwpQq9jyXKzjybUY9TNK92?=
 =?us-ascii?Q?9Jctv2uX84Nq2zIDbEccVOTH5VV6eWfhphx9/ouTOQiaYQ8S21WpfMbUG1JZ?=
 =?us-ascii?Q?TuiRA338fzBmgkYiV/UYBVoce+6ydk96edsglobvtnA+lXbTc5hdhfr8o5pK?=
 =?us-ascii?Q?A3Kcvn5dQPXhu/TVfd17auIVcJfuJLzyxb9XMQpeKtvmljW0T7nlbsdhznba?=
 =?us-ascii?Q?h2WH28+ZvXGTwI8P0oSQgckb8WrlDFQnAcPgzRSYin/pmuLPJHAHCWKTz1Y5?=
 =?us-ascii?Q?QUEgJgEF4nfSQvuofrxaAdQXbTTnlmx/r7GMVaGO3qNHyfVCosggUOdnfrQP?=
 =?us-ascii?Q?1FAqKj1BJQaACzJbzYLS4BLki6NIRIqhfPT1ABAAQDWEiV9r8QJ30opqOZ00?=
 =?us-ascii?Q?4w9Wb9zFWWhQTVJFqFqXNYW72AW4AS2/heZNEIqXFmnEJmGrs31dRbFymVvD?=
 =?us-ascii?Q?2Hd/nYYeWcjfYKBDFdqNlJ2oboCpuXS/u6y4rSXkAT5kKb9EOwhEqxzZVcje?=
 =?us-ascii?Q?OLNtfrfGb1W0Oi3tsoH58hbCSLb0A1BWi6s2B3jUdKH2eh1FVZbCv8uhzCkJ?=
 =?us-ascii?Q?iuyThuJzIgD3dq1Yifa95/4pjjUisDmxs/4YMhzlmsZqUoO7aRfa2xhuwP6O?=
 =?us-ascii?Q?ZMn0SeUP5MmWaU9OLdkOQ7cRzsydL8DSIgFlMgOcaG0dH8N2NxjtCFWG8Su6?=
 =?us-ascii?Q?zjALimCX9fNrBWJgnCV57fX0QuXD9BvvSZSZOGroDVbD8ThVJoDDWOCS6pMH?=
 =?us-ascii?Q?SUB5cbD3swP8hh+PdtaJfhZLZYAF3p6ckSKISWRDVU1ndQbDDUYUGnLUrsED?=
 =?us-ascii?Q?knawI/e3fWkgRlFTL4Oqo+vVV3Q73xX04MhZE385bnxxt+4xA0FbsB1sWl8A?=
 =?us-ascii?Q?+M/16ST6SJTalkVcaWC5JyCP/S1SyjK2lMjt8JZ251z2Aw+JzSfkfUhoFzDV?=
 =?us-ascii?Q?S5yMCVif35+QD4FaiZKfO3sac+7TY+YUIOYcPBHIaFml+NuFbrztGp+NijiO?=
 =?us-ascii?Q?3L9HxEPeMnLGglN9ozXZg/gw7+4wrUySUWcDPowCUVhLvCJVDc83vN9EDaKP?=
 =?us-ascii?Q?DJQdU+COpj4EccCizN/xh/vocOS1KbXo/pAr6uES5GTdJoMmkb0eF3yWmcOq?=
 =?us-ascii?Q?8zcBtuP/v6ca9PKvhXzhqNMlojdla2ji5PAl6uaudGztnP9oWkzZoVD9P9y5?=
 =?us-ascii?Q?0tGl6wGpBMcF4xwJpNrZ3w5BQEwZTzpx3WrFcOa7Qzw3gABXyLY6AKOZl3CL?=
 =?us-ascii?Q?B+Qzv8vhUzmN2nBB8cllInC1FqliDcVBxaOsHSbdO0rjvju8FAJ+znnvWlz4?=
 =?us-ascii?Q?H6cq8bpfns9NIndwipNz58yhK6khFAA1Ns+GxWFrYy3DR/Eba/Losk3OJ1qK?=
 =?us-ascii?Q?Sa/j3n7i20KFo3TO5CZIKgwN7wnw6p4IkjarVzch?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c78f4d-9157-4b4a-184d-08db5179b8e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 17:12:23.7366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PV7sUKisFFCCK1yWDUu71hXpnF3F2oQ0OrTXHBIAbDCcArm8kV1p+2n9miWbbGOxy1AlR14fqOJGd5X/Yj/7JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3176
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Lorenzo Pieralisi <lpieralisi@kernel.org>
> Sent: Wednesday, May 10, 2023 1:23 AM
> To: Dexuan Cui <decui@microsoft.com>
> ...
> On Wed, Apr 19, 2023 at 07:40:37PM -0700, Dexuan Cui wrote:
> > Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
> > pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
> > create_root_hv_pci_bus() and in hv_eject_device_work() to address the
> > race between create_root_hv_pci_bus() and hv_eject_device_work(), but i=
t
> > turns that grabing the pci_rescan_remove_lock mutex is not enough:
> > refer to the earlier fix "PCI: hv: Add a per-bus mutex state_lock".
>=20
> This is meaningless for a commit log reader, there is nothing to
> refer to.
Correct. Because patch 5
[PATCH v3 5/6] PCI: hv: Add a per-bus mutex state_lock
has not been in any upstream tree, so I don't have a commit id yet.
=20
> > Now with hbus->state_lock and other fixes, the race is resolved, so
>=20
> "other fixes" is meaningless too.
Ditto.=20
=20
> Explain the problem and how you fix it (this patch should be split
> because the Subject does not represent what you are doing precisely,
> see below).
Ok, I will better explain the boot time issue.

> > remove pci_{lock,unlock}_rescan_remove() in create_root_hv_pci_bus():
> > this removes the serialization in hv_pci_probe() and hence allows
> > async-probing (PROBE_PREFER_ASYNCHRONOUS) to work.
> >
> > Add the async-probing flag to hv_pci_drv.
>=20
> Adding the asynchronous probing should be a separate patch and
> I don't think you should send it to stable kernels straight away
> because a) it is not a fix b) it can trigger further regressions.
Agreed. I'll remove the line "Cc: stable".

> > pci_{lock,unlock}_rescan_remove() in hv_eject_device_work() and in
> > hv_pci_remove() are still kept: according to the comment before
> > drivers/pci/probe.c: static DEFINE_MUTEX(pci_rescan_remove_lock),
> > "PCI device removal routines should always be executed under this mutex=
".
>=20
> This patch should be split, first thing is to fix and document what
> you are changing for pci_{lock,unlock}_rescan_remove() then add
> asynchronous probing.
>=20
> Lorenzo
Ok, I'll split this patch into two.

Thanks for reviewing the patch.=20
Can you please give an "Acked-by" or "Reviewed-by" to patch 1~5=20
if they look good to you? The first 5 patches have been there for a
while, and they already got Michael's Reviewed-by.=20

I hope the first 5 patches can go through the hyperv-fixes branch in
the hyperv tree
https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git/log/?h=3Dh=
yperv-fixes
since they are specific to Hyper-V.

After the first 5 patches are in, I can refer to the commit IDs, and I
will split this patch (patch 6).

Thanks,
Dexuan


