Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472DE437FF6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhJVVdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:33:11 -0400
Received: from [52.101.62.24] ([52.101.62.24]:55010 "EHLO
        na01-obe.outbound.protection.outlook.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S231997AbhJVVdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 17:33:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvyFu8v0TfAPtXk35TCtX9FBNSJvbQha37iQkOGmA22Y5jjynIZAG1W4AlaBYohjfdhhUrrGH3gUznVXDPAMVcv6RK7oVj3XmTnIi5y0XnpT32yibAQfBS4FlyUFD1mP+P5kN5QmM/8sULB4sNoeVMEy/a2Elritc9Z3EuHXc9wDAk8bjlu+QyFNEJXxmXoHGJ4SQRFD4Pckmt3LLw7VQS/OuoTsopyzM6O21/M32xffJ8dlhnuIyTAdfmZN0nYMH82tUb6yjmUfTCLZ0rnnlh86agjmBqZYt52x9s3opio3fMU9GSv0qrTvAhd/bqWJKSrSTcMbbeFv0+PdoSDJLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+W2rI0U0BK9UCAGJnDpsgZCVsrvbwQxmXhS1+Y5gLU=;
 b=jOHSBSYvZkckT5TDca6KbnJB4aRuVCd/Z4Hs7nDt94O87u4DFP6WPrhRkXXX+uP7LIzdcU3GYWMtbGLM9iX3R7Tbv3LlOhe2mSWkJmCYt7EppdtN6i33/mGKOsST5NYt3XrMRSPZqPdgEYs8DOWMIEU1W/V5/vA6INgBCLav/vwFb6OQt4KSWjLsbgzv7tpkXO0y0puZrUqU3luKzwIthQZu+9FmnlXYoBXdO9mU3xqevfWtulHzJyqMn5ouxSgOBPBCnkeDR7Gl6GDSml5Of73Ek+uxjxXViNH4i0//Z2GcSl/WDo1h6z4GKUHCwrqkIXqAz6By25Z3wdoP0D+V2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+W2rI0U0BK9UCAGJnDpsgZCVsrvbwQxmXhS1+Y5gLU=;
 b=QtsvY4AWMes0obUB2z7l5DjUr8DdAGNUJlHrF8H6YwYyHYyVjCQkX+8dycMq1/ZSz6MH13GKnpfD2PHr+G+hmGbIrBpj8CtoOkQBUy4WMIdTZGw9a739IOLNKx14V+QrSH4+dp4EevUq583MhMzXr8fC90fFaTFBzcWlgj2MBic=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB1577.namprd21.prod.outlook.com (2603:10b6:301:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.4; Fri, 22 Oct
 2021 20:58:01 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::240b:d555:8c74:205c]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::240b:d555:8c74:205c%4]) with mapi id 15.20.4649.011; Fri, 22 Oct 2021
 20:58:01 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "rientjes@google.com" <rientjes@google.com>
CC:     "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V8.1 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
Thread-Topic: [PATCH V8.1 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to
 call ghcb hv call out of sev code
Thread-Index: AQHXx0n2gV45EoRZbEKwYtomMcK0Bqvff3+Q
Date:   Fri, 22 Oct 2021 20:58:00 +0000
Message-ID: <MWHPR21MB1593716CD7DDE1326AC93AD4D7809@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211021154110.3734294-6-ltykernel@gmail.com>
 <20211022133721.2123-1-ltykernel@gmail.com>
In-Reply-To: <20211022133721.2123-1-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=23f3987a-cec8-4da3-984f-8b375fbd179f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-22T20:54:42Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35474ded-f756-406e-eca4-08d9959ea269
x-ms-traffictypediagnostic: MWHPR21MB1577:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB15772D66A68D097109E2C109D7809@MWHPR21MB1577.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yA2Y7WfWQBsXHvKSN9djOm608cPhyvdSg5AZEfG+ovgxPNZ8ogiZz0YpdkxD+/7NI6pQ/k0HYkTmdBdlZdYRgIcmLqnPvO5y7RTlXTrh6t3aC+BrMHQG48yhDIHytxD1eaLHROMvE1xU0+9NOiGODV6SOBLojaBRQd97BGY1+ZL7bQbtNoZwKRAQZdcj0PxqjzGJ8KIPC4wFk97TxyWoUFwWbOh7QLsuo51q9BIetyF5eM+eKaYrnjv4hTTLAEcbBUsltSot9SO8twNeYPqCPnNz0s9R6hfLqDCKtAEzelIrfCGf2uj1ykEXfQHDiY7rKlqx5aSNitQJohmhuKHD6RBlbbheQImCpHlFkDECbExOzoUxV1mTCP0ptAhttw+OJhrzxkDWN95YNJeZgwJXSAoLXecdos8wr31ueaeIcZfXKLP2S3DUgEUV5Noet8YniC5ZuyWtRLsL0EPdSlADx6O4ijW3FiKhs65TqzF05X0Bd36oKufHNHzc6oLOFc0Vt6DlltWesu+Uk3GwFbqCgy5T2ESDBrqOXcpiTPZ/G/hJ5uYSHX9PshiFPdhQCIMExKSxTq1wm9yakozJXWHpVPEyFNMjhgCg0yMyesJ+DFFw+//khuVVNsyiF6XDhQ0v2jAH+lUXteDJaijHAa7438zluWk7x96QOBZuCwcdQRtu5zSapEqDfsBZiOyQ8GWQP/GuxQAUc8okcB/DP1CxTGfvecFu/Vq+yskm81TScRg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(8936002)(55016002)(4326008)(66946007)(8676002)(6506007)(10290500003)(26005)(66446008)(186003)(33656002)(66476007)(64756008)(71200400001)(66556008)(52536014)(76116006)(508600001)(110136005)(54906003)(316002)(7696005)(86362001)(83380400001)(5660300002)(2906002)(82960400001)(7406005)(122000001)(38100700002)(82950400001)(7416002)(8990500004)(921005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+Ok/cvPNoFRT5jCGpjJTQHCJPuHjRLwq9ijMn2jwUeRRCR5FeqcCt0xRWI4W?=
 =?us-ascii?Q?1qmoCMRSQzHTd2B6ZXcxLV/kPSi5uVcGejfeYZjs92D1L/1AFMaNSKshpzb2?=
 =?us-ascii?Q?KNQKvzWEVo5d0ZkFHRkwQwEaunc7VJD2xZ/4qRpClzbAso7cI+30GPJ8LGBH?=
 =?us-ascii?Q?5LBUzuqMdgm7UhyNbOxYDWqZtLGf2WXmBvLUo1pLodjgSu5JWgwF2bsEnD5y?=
 =?us-ascii?Q?MxefnSEgQIxNiy8QVR8fw+ciMdycEQVWJVQoG/CqQ/1DMaTrxTGmVQdwaNCY?=
 =?us-ascii?Q?d2sH1eaE24PS/b9n5+M8bBYxkqe9LE88dV34l8e4TFot2jLYS7YcrLamV+Fx?=
 =?us-ascii?Q?rn2SMcnkd+QpkzLhpzyQWpuYY9/Qf2vIiSsPPv06QuqDOBrLIEOqghaSG04j?=
 =?us-ascii?Q?rHA5s57VpSZh8/t2ihvchU3HTUYFYPgaCRB0u7o+giZVECDDeFqX01zQgb8S?=
 =?us-ascii?Q?QuIXJwPKDTlonWJ1s+27x7P0bsJKeLQrTgNJ8EwLI1hf79a8DV03VEUBiVLI?=
 =?us-ascii?Q?WbZsdN3R3HS/cmckYkjRHp4jWUARNqEc+3rA6N6VcxsZcyuN4lzdUPQBkJm5?=
 =?us-ascii?Q?rxUu237m/l/egXXuvmG+hoR3tT5LJzUx/dtVBuzV1ZyrSRKAOITDFAfDCiEV?=
 =?us-ascii?Q?Dg028oU94/GYfpwefJhTVq0yOiRO4PdQicEDHAPhlC4WX7tYBl5aNSuv2hOI?=
 =?us-ascii?Q?ULlhkHfrUlrwGo5GCsD/HdjhnXDGtHGmQybv7Y1SpgzOpp2TrTvGa/lB7KRZ?=
 =?us-ascii?Q?FuBnJz0ftPTZMpGWOx5XGBWsbPHizlUVBxIlCj40eqhTH2HkEjbLIv9WvmZm?=
 =?us-ascii?Q?M03HyTy9FJjdYBv0iFrWT5YLbWtZLpzQPHnotT/NYBdlEQu54bEBUxvBp6mO?=
 =?us-ascii?Q?CnSd4UnzfbJp6Vl5WzvdACjN1wOM89L/aVXxj6/AgsyAWBTZFZ1m/Hggusqy?=
 =?us-ascii?Q?nd85Kd/VJ55XfalA7+FBlwhzaDTwMc9+SnCCnO7br6eyUczg2uSCoUP0iyLI?=
 =?us-ascii?Q?crByeHJLPulNFBbHxYj6vXed3+JBGTlzPlxBHOQ05V3gabVQG1hNNb48r7Fw?=
 =?us-ascii?Q?sWV19LjtpxnwDyGHdakLDobwQasgp52YFL74K8/5wBUHR2hDvWxM69iPKFE+?=
 =?us-ascii?Q?hdwTKvsiHoIo5HRtf+XmlKWBynnCbZJWQWfCUNrC8dPBEFAM2WaaJi+DfhWr?=
 =?us-ascii?Q?pBRVTsg+ipWAoyvyHvYhiLfQ2Tlw6ej5PK0jettLKYO7hcR0WSeuGmi48soF?=
 =?us-ascii?Q?QTAV6up0NsQ7+wHnNQ/YSh2SwxBY5EU77hRwK6pqgFS4ZUmIG3tnwi9mMjGp?=
 =?us-ascii?Q?Cw/RgDH3Ne/JrJqvDVsWHqVjZ50PzOvy8HOp/HU6WQmIXKBFNdfUjbXoqGVr?=
 =?us-ascii?Q?KoXG6VUf7EqDhl0w99lKdw5V9Qjt4ZM9hp/vam2zirQ+fH0t46amxJVqwttO?=
 =?us-ascii?Q?9V/sigkgcsJzbwUxzKYt4CKOC1nNTcTd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35474ded-f756-406e-eca4-08d9959ea269
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 20:58:01.0209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mikelley@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB1577
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Friday, October 22, 2021 6:37 =
AM
>=20
> Hyper-V needs to call ghcb hv call to write/read MSR in Isolation VM.
> So expose sev_es_ghcb_hv_call() to call it in the Hyper-V code.
>=20
> Hyper-V Isolation VM is unenlightened guests and run a paravisor in the
> VMPL0 for communicating and GHCB pages are being allocated and set up by
> that paravisor. Linux gets ghcb page pa via MSR_AMD64_SEV_ES_GHCB
> from paravisor and should not change it. Add set_ghcb_msr parameter for
> sev_es_ghcb_hv_call() and not set ghcb page pa when it's false.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v8:
>         Fix commit in the sev_es_ghcb_hv_call().
>=20
>  arch/x86/include/asm/sev.h   | 12 ++++++++++++
>  arch/x86/kernel/sev-shared.c | 25 ++++++++++++++++---------
>  arch/x86/kernel/sev.c        | 13 +++++++------
>  3 files changed, 35 insertions(+), 15 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index fa5cd05d3b5b..5b7f7e2b81f7 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -81,12 +81,24 @@ static __always_inline void sev_es_nmi_complete(void)
>  		__sev_es_nmi_complete();
>  }
>  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +extern enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +					  bool set_ghcb_msr,
> +					  struct es_em_ctxt *ctxt,
> +					  u64 exit_code, u64 exit_info_1,
> +					  u64 exit_info_2);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
>  static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rm=
h) { return 0; }
>  static inline void sev_es_nmi_complete(void) { }
>  static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
> +static inline enum
> +es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +			      bool set_ghcb_msr, u64 exit_code,

The "struct es_em_ctxt *ctxt" argument is missing from this declaration,
which would presumably produce a compile error.

> +			      u64 exit_info_1, u64 exit_info_2)
> +{
> +	return ES_VMM_ERROR;
> +}
>  #endif
>=20
>  #endif
