Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3EE518B25
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 19:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbiECRff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240403AbiECRfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:35:32 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021023.outbound.protection.outlook.com [52.101.62.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F3E1CB3E;
        Tue,  3 May 2022 10:31:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jt/KOtRUgIAyksyYK8VnD6ZnzZ/NliFwcadXLsWhztfCamTq3QwkwpGwyMwiutvnUnN9P++1gDsLEiw6Ffs4JzYwWGjG1s32LGaj++fC09TISIbhTPJ22JvpH1sDoC1t8TEEevav+mZukOSpAc/O8A9zMznA1StSx+n+fiDRjrtWV3GTpPnM9y6fYUY9TLjiFeJdopLkIP13Hd3e75u1mME7ICYLLotdeJxv7FFo9dCplpw84PrBxCkN8oMYpv+9SKWUo7v1vDi+yPwDJ8RozZ6cej5bW0lGLjxGVSQUz4zO2RXSdgzKKqzurjdwrIitXCjuYEki2FjSzkfT1QwwKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOJL1aNKBYeOe+uczwmHwdViQyc7IwMUkuukaeURBOs=;
 b=S7HWX64rCgnA9mLOc2eDXyDjV6iC0ehqY8SNFj/n7g9tX/kIZbHomLEI9FL1MH56jcIPtcTLOcqfxQMnuO6iEK3JH7YjdxMdQA+HfoV3LG9zl2jalk2jxwFSWVvdJKaYxR965/HLYUfTNH9sMSpM9KkV6n9THwWb2UXseqq1mVCCB9/2/pYGTGYa0m4B6mGZ8ABVNHH0efDrQpFCtgvcmpBYAxTdOM5BWACtw4nDbSbKbDaQPVrS4f/tC0fAe4egALomaphJqT00udxastUBLuxGhAmPgXopd/cBVnO3YucxlRcHy76OdoyO+bUJQCABjNA8UWZ8RaZuV9puIkhUjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOJL1aNKBYeOe+uczwmHwdViQyc7IwMUkuukaeURBOs=;
 b=iMwLKZ9LBUYKCD7s3OHUGAzQf1eKepDONOGF5h+ECdpSlLnCRD1k8RU9oxx0Yd92mvK8EkErUnr1aFcwYQE1hWsNHP5RV8IZwkrqNwqDR6/GJsTT94uz47EnDd3I5q+sCx4HSe8qnHdaKJZ/stF6cJ7V1IuK4VGpUqTTX4YDSgg=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by MWHPR21MB0191.namprd21.prod.outlook.com (2603:10b6:300:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.6; Tue, 3 May
 2022 17:31:43 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%5]) with mapi id 15.20.5250.006; Tue, 3 May 2022
 17:31:43 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
        <openipmi-developer@lists.sourceforge.net>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "halves@canonical.com" <halves@canonical.com>,
        "fabiomirmar@gmail.com" <fabiomirmar@gmail.com>,
        "alejandro.j.jimenez@oracle.com" <alejandro.j.jimenez@oracle.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "bp@alien8.de" <bp@alien8.de>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "feng.tang@intel.com" <feng.tang@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hidehiro.kawai.ez@hitachi.com" <hidehiro.kawai.ez@hitachi.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH 24/30] panic: Refactor the panic path
Thread-Topic: [PATCH 24/30] panic: Refactor the panic path
Thread-Index: AQHYWooewzaZJbWMbkqYc1HZNUkdQa0HKRAQgAAz7QCABhB0MA==
Date:   Tue, 3 May 2022 17:31:43 +0000
Message-ID: <PH0PR21MB302570C9407F80AAD09E209ED7C09@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
 <PH0PR21MB30252C55EB4F97F3D78021BDD7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <50178dfb-8e94-f35f-09c3-22fe197550ef@igalia.com>
In-Reply-To: <50178dfb-8e94-f35f-09c3-22fe197550ef@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8353cb62-2ed7-400a-b7eb-a0eb08ff48b4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-03T17:14:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c02534b1-161e-4271-51ad-08da2d2aca6d
x-ms-traffictypediagnostic: MWHPR21MB0191:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB01911FB5FF350E4B06750FD0D7C09@MWHPR21MB0191.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d+Vj8BD2ptagF97e+OKWd6KIi9dJnQ7gaUDc6wlNZqB6d87vNQwAg9gTTz7gmEe5peNSxQquSkNJzQZbbI/RlISFgBlQoQpdhadxVIaq7nDryyXKXewxJ0vEK70rT16ZqNlNHh03BpEBnX+MiIth//WHnfeBrwZmsv0wDp5R3AQsTrWJaSMiwJUOUWRAJ4NNbdjAtd6NDcqyYBbe/F2sAryTMSyjGpc4aonCjZ4cV15U71QaHrIwDBpm9Ott4b/b9qtwd1Umqb+3ozGfrT9PkBMRsd3ruDpgUupJRy0jUOCMhPng7xTHxD5JfAgZjtHX9KAOIfg/a4LVLYLDxSzDOj0bVriAYEXmhf3mtG/3z/Ov87p4l4gyWHPi3JZPxGGlFR/SgW76EoWXJHfAJtuldYHbL9T4rhbaORwQLgLnzmqfYlau6+M/dYNT8y/uw3q3K6oZ6wuFLStOV7xMc3LAlTPyYJYxe8F0WsMoFQutNHnbjeH5rRpCrzTR2byFdYk4tRWkm1W2B7lovCjTOPhfiNyLfasP6HjbeopVJGp91XcI8s8jb7bFMITNKq0NhyelZQt8vkTqhEUT0hpbvLrqX/4zxvGqf7KS+O5k9BlNztUgNOk4AEnflbZjadvWOVpCU6KgEsLHWGGqJTczV5btT+4ftNTK4/5RNcc5r8t81x3Qng82ku6C6Sy2px6abE7hE+MJFVQt3wDG7R39G1tnCbrKEwajs+OkqxRln1S9lmH2pp5HwuLL5xpibnmFTPHDx410FyVKd08iauOHoDTrAWdkY/rGrhSinmO9G7HzK/JuxyBxSsA50phwfKS7qvGXabAWJbIIe81HboIaEq2IyXifJPQJp+rKDJXr+pJU+kmIR57hSHvkeiJudnDxrp8n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(71200400001)(10290500003)(82950400001)(5660300002)(7406005)(7366002)(122000001)(8676002)(8936002)(83380400001)(53546011)(7416002)(7696005)(508600001)(86362001)(6506007)(64756008)(38070700005)(38100700002)(52536014)(9686003)(186003)(26005)(66476007)(66446008)(66946007)(76116006)(66556008)(82960400001)(54906003)(110136005)(966005)(316002)(4326008)(8990500004)(2906002)(55016003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/JpsvICJW831GtJhoHUV7R5VNJCByy4wAGc71QhpgpZ9H5twFSHjEwLRUjNq?=
 =?us-ascii?Q?+xcjP/YzIJDPmEBkCiHEwmnaevTU0pHzAC/ToQf+XxP9Pq/V6V/4zX1GbtCC?=
 =?us-ascii?Q?6TfuHBuuBf+9ejbz00o1x7xRKy5CUtBmEvw+0X5/cQSU/lR6323jos9/PanL?=
 =?us-ascii?Q?wXSQfD6SMNaQHS0AB5Ww12hs+qWMOFKkpyXTSvfTfP8xd/65gZ5GX5qeH3ZV?=
 =?us-ascii?Q?rk0XFNSTh0qp1DUHgrYLDStU+U5kweGv+JzhMITo15+lB9pZO6tKK5u1+yIv?=
 =?us-ascii?Q?S4Xc3FVp/A2a7E9dcITnFLqGq8Di8UadZMR9ty8GUfGmqGizf2j2+zN6Qlzq?=
 =?us-ascii?Q?W9G42fDKK65EIbamjxiBd7kwvsgKpWjadf0mTRG5wd6RhvSnjRfUC5DWAVD5?=
 =?us-ascii?Q?MU43loH4ELMFnUomwAGDwpb7Jfq72+KlTxdLXSlfvyrd8qfZhVbosi5rq778?=
 =?us-ascii?Q?OsgybK0DVpMIm4u97jRl8TRFD0Kumg8jUSvxHQuMK9IhffuYGS7J9Tj2fF2L?=
 =?us-ascii?Q?r+wWJ+bpmnK5isJwURS9DQA7ZKjeauso0WcwJatwsHZY3tW07ezQw3LdF3eC?=
 =?us-ascii?Q?BPQIpQ6Gv1hgqaMvEOFvz5j6jFIRH9bIafnMpeUmwQl+IsmP/e+s+Kd0pIA8?=
 =?us-ascii?Q?CIiIqq7GIvYQqYCaH4Kai4JM2R6PQ+UBr3bT7802u8YJSEfQhlKqznchSm1L?=
 =?us-ascii?Q?sFnvGGX1BvEzcBWZ3oNjA72XewKggji1hhR1Up+TJlOngapGMliMmVKtyRpR?=
 =?us-ascii?Q?An0XeQ+OjtTeo13bQmj3o132J/r6YJrJZCI+V/lxQ6TabhCmPKsgkx6KEQFy?=
 =?us-ascii?Q?EZWA9YNVksZkcqfHPRmKtvhtt2t4VXJSlooO/gsEDGU5UK5xWoD1C7xNOfr5?=
 =?us-ascii?Q?3HfkPGhe+KL3/FSEczi29DIyhslBql9QRZkeyGBED6xWcoHeWQICeopseWe5?=
 =?us-ascii?Q?rA8Wyj2STMJj1XZPMf2Ig4T4uCLE53Jc87GKJPrWk6guBYcZNQTUlsP3RRi/?=
 =?us-ascii?Q?eOj1pnly+b3D0souCKgk9bVVlIewyhQFC3rDkdNqeEG0iyC/c1NIFpQ7BTsM?=
 =?us-ascii?Q?hQT3d/1an0zHG5geRp6eUSgzazxJdw9FWfdwnXJUKyvfQvNvOAaERsNw0wWC?=
 =?us-ascii?Q?zzbU8jX3dNYLUKrrOH0NV12CHX4jYkTVYJmbKnkX28nQt/c7qhnxyRVWxt4U?=
 =?us-ascii?Q?u/pUED5lDnxYr0//LOtOOggezR1tW5+2vlOst3LzoPjmy4cuZHMrmgqV62jX?=
 =?us-ascii?Q?BsTaKSRtmBDE4jLeImBYd42cPgdVttbyKVo3SSX+u+qV7FBwHvuSK4mGTMT9?=
 =?us-ascii?Q?zj2OyZyV0iIcCMnAv5bRh9jZYYdeuQlOMcJi0Pn8A3/QGdmQwclZu0/BD9kV?=
 =?us-ascii?Q?/tpGTxTS8CYjFK9L6GpSBkcjBAzbZd9DdPM2tD4KDdhhv9FOvl9K893/rqJT?=
 =?us-ascii?Q?EcvMYmZsYOFNp939/EQ02tRp5Tk4RTZDzUZOytVvYLm9Etqrtk0we6fyWqZW?=
 =?us-ascii?Q?7h2jGVdTyiXaZJo3zpc2u2E8R/4sxXQWFdY/7hAQ6pZiB/jfXGIsWWCT/h2j?=
 =?us-ascii?Q?seEitHQyk3PZuYC26Tt+Aep09FET5ZeUVkFhE2lDKvZGqW2p2FuH0IsbWnHJ?=
 =?us-ascii?Q?APq546lgGacp3dNPPra6++6k5Ze+ibilIXYr2871lf75Po05kxywWn2YS7tE?=
 =?us-ascii?Q?7ihfERru7bbVvMU0KOB53AE4IzmeefbD40voYwTcNdMO7hDuylseW+MXFABQ?=
 =?us-ascii?Q?3Alqkuy65DPhYQjdaZpxE27nYeShtF4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c02534b1-161e-4271-51ad-08da2d2aca6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 17:31:43.3884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uCZvqjHqBSnDDITyIgv33IArtj67sulx9219DtqDuXN15ic3u3zIh/wV/287GSYh6ohZ68LzN/uqJT/ZRhTo5qXHXhMXRCpanWwblZGK3w4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0191
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Friday, April 29, 20=
22 1:38 PM
>=20
> On 29/04/2022 14:53, Michael Kelley (LINUX) wrote:
> > From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Wednesday, April=
 27, 2022
> 3:49 PM
> >> [...]
> >> +	panic_notifiers_level=3D
> >> +			[KNL] Set the panic notifiers execution order.
> >> +			Format: <unsigned int>
> >> +			We currently have 4 lists of panic notifiers; based
> >> +			on the functionality and risk (for panic success) the
> >> +			callbacks are added in a given list. The lists are:
> >> +			- hypervisor/FW notification list (low risk);
> >> +			- informational list (low/medium risk);
> >> +			- pre_reboot list (higher risk);
> >> +			- post_reboot list (only run late in panic and after
> >> +			kdump, not configurable for now).
> >> +			This parameter defines the ordering of the first 3
> >> +			lists with regards to kdump; the levels determine
> >> +			which set of notifiers execute before kdump. The
> >> +			accepted levels are:
> >> +			0: kdump is the first thing to run, NO list is
> >> +			executed before kdump.
> >> +			1: only the hypervisor list is executed before kdump.
> >> +			2 (default level): the hypervisor list and (*if*
> >> +			there's any kmsg_dumper defined) the informational
> >> +			list are executed before kdump.
> >> +			3: both the hypervisor and the informational lists
> >> +			(always) execute before kdump.
> >
> > I'm not clear on why level 2 exists.  What is the scenario where
> > execution of the info list before kdump should be conditional on the
> > existence of a kmsg_dumper?   Maybe the scenario is described
> > somewhere in the patch set and I just missed it.
> >
>=20
> Hi Michael, thanks for your review/consideration. So, this idea started
> kind of some time ago. It all started with a need of exposing more
> information on kernel log *before* kdump and *before* pstore -
> specifically, we're talking about panic_print. But this cause some
> reactions, Baoquan was very concerned with that [0]. Soon after, I've
> proposed a panic notifiers filter (orthogonal) approach, to which Petr
> suggested instead doing a major refactor [1] - it finally is alive in
> the form of this series.
>=20
> The theory behind the level 2 is to allow a scenario of kdump with the
> minimum amount of notifiers - what is the point in printing more
> information if the user doesn't care, since it's going to kdump? Now, if
> there is a kmsg dumper, it means that there is likely some interest in
> collecting information, and that might as well be required before the
> potential kdump (which is my case, hence the proposal on [0]).
>=20
> Instead of forcing one of the two behaviors (level 1 or level 3), we
> have a middle-term/compromise: if there's interest in collecting such
> data (in the form of a kmsg dumper), we then execute the informational
> notifiers before kdump. If not, why to increase (even slightly) the risk
> for kdump?
>=20
> I'm OK in removing the level 2 if people prefer, but I don't feel it's a
> burden, quite opposite - seems a good way to accommodate the somewhat
> antagonistic ideas (jump to kdump ASAP vs collecting more info in the
> panicked kernel log).
>=20
> [0] https://lore.kernel.org/lkml/20220126052246.GC2086@MiWiFi-R3L-srv/
>=20
> [1] https://lore.kernel.org/lkml/YfPxvzSzDLjO5ldp@alley/
>=20

To me, it's a weak correlation between having a kmsg dumper, and
wanting or not wanting the info level output to come before kdump.
Hyper-V is one of only a few places that register a kmsg dumper, so most
Linux instances outside of Hyper-V guest (and PowerPC systems?) will have
the info level output after kdump.  It seems like anyone who cared strongly
about the info level output would set the panic_notifier_level to 1 or to 3
so that the result is more deterministic.  But that's just my opinion, and
it's probably an opinion that is not as well informed on the topic as some
others in the discussion. So keeping things as in your patch set is not a
show-stopper for me.

However, I would request a clarification in the documentation.   The
panic_notifier_level affects not only the hypervisor, informational,
and pre_reboot lists, but it also affects panic_print_sys_info() and
kmsg_dump().  Specifically, at level 1, panic_print_sys_info() and
kmsg_dump() will not be run before kdump.  At level 3, they will
always be run before kdump.  Your documentation above mentions
"informational lists" (plural), which I take to vaguely include
kmsg_dump() and panic_print_sys_info(), but being explicit about
the effect would be better.

Michael

>=20
> >[...]
> >> +	 * Based on the level configured (smaller than 4), we clear the
> >> +	 * proper bits in "panic_notifiers_bits". Notice that this bitfield
> >> +	 * is initialized with all notifiers set.
> >> +	 */
> >> +	switch (panic_notifiers_level) {
> >> +	case 3:
> >> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> >> +		break;
> >> +	case 2:
> >> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> >> +
> >> +		if (!kmsg_has_dumpers())
> >> +			clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> >> +		break;
> >> +	case 1:
> >> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> >> +		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> >> +		break;
> >> +	case 0:
> >> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> >> +		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> >> +		clear_bit(PN_HYPERVISOR_BIT, &panic_notifiers_bits);
> >> +		break;
> >> +	}
> >
> > I think the above switch statement could be done as follows:
> >
> > if (panic_notifiers_level <=3D 3)
> > 	clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> > if (panic_notifiers_level <=3D 2)
> > 	if (!kmsg_has_dumpers())
> > 		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> > if (panic_notifiers_level <=3D1)
> > 	clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> > if (panic_notifiers_level =3D=3D 0)
> > 	clear_bit(PN_HYPERVISOR_BIT, &panic_notifiers_bits);
> >
> > That's about half the lines of code.  It's somewhat a matter of style,
> > so treat this as just a suggestion to consider.  I just end up looking
> > for a better solution when I see the same line of code repeated
> > 3 or 4 times!
> >
>=20
> It's a good idea - I liked your code. The switch seems more
> natural/explicit for me, even duplicating some lines, but in case more
> people prefer your way, I can definitely change the code - thanks for
> the suggestion.
> Cheers,
>=20
>=20
> Guilherme
