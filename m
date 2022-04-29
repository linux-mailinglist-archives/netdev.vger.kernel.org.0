Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AA25150C8
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379101AbiD2Q3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379061AbiD2Q3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:29:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2123.outbound.protection.outlook.com [40.107.93.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEBFDA6C9;
        Fri, 29 Apr 2022 09:26:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnYPKv6cHHooKkxX4CyAInmQOVJL+OziIpN/GllKamJdLXKN9pgc0JLdxdyG5o4Udhig25LbpjMkGVtiJr3BpTywkbrXXha1jvswAm+XYWeYOXi2gjn2dH2uAgTMtLT2jbOTqtuSqOTs6HSmhzLD+7iFYQFUMSmQ2HhcdRz0tckq7wSnmWoEnae03PlAp81C/6Y7A5elDA7JXOm/ubJjoq+tF7vHcRy9sLmepWaqrALujROI2plEhRBl02SgmI6ETipuH8J6Xub66Nv/IDNQ0T1gxK8T1a1OaaPRk9S8MH5BuCJwTRspF9IdY2rGjJfLqh3Y9lm3CV0zLYpvT+I6Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTfneMsIYF8YteyonKPHoonZYmHV8hcH1Ru2q+6fv+0=;
 b=a8eu4ttDG+sEYNKvY+Uwg1P3RBiTiU+aBz6zRlC/6rvyoDzx60kk6vFEe/s42qfutMsEoCQXf26saUU5449UKwK24BAbhL91IpoY51JezhYp+GEiVnxQbqE/iZ+SOACRPpdsYFcOSEYUXdTrLeAFwJtGMnzA7bO3UfPp3ObxWmkMQaJkQa4bt+JR5CbdrtRreISsi/oI8XylYkH3pby6kSXQe+vmLXgJq9WyZhPChMkc4r6YxiCxevLqMJpaBn5Kytf9c8vT5PNtVTGx+ODEAb1aYyH/lQREUWAzeu7eEEE5pR4fiwrhZcFwzS5Xz3T5pA8yf4n50TM4AZeFGPKBZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTfneMsIYF8YteyonKPHoonZYmHV8hcH1Ru2q+6fv+0=;
 b=d+Tijt2euluzrQi71IhaI2QKQVJzCEGzhvDpVQFylauvgmvb+PUHN72mLRXMSu63F1AMA4wWXKpgR7C192SolLu8YaJCvcwzHALT2WPLFSkGE8ihloRhKEhReubWrxbSHp5AZDEZSpJUcCoV3iPIyf5/QVdRfkXrHI+cydNTodI=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by CH2PR21MB1525.namprd21.prod.outlook.com (2603:10b6:610:5f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.6; Fri, 29 Apr
 2022 16:26:02 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%6]) with mapi id 15.20.5227.006; Fri, 29 Apr 2022
 16:26:02 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "coresight@lists.linaro.org" <coresight@lists.linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
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
        "will@kernel.org" <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [PATCH 02/30] ARM: kexec: Disable IRQs/FIQs also on crash CPUs
 shutdown path
Thread-Topic: [PATCH 02/30] ARM: kexec: Disable IRQs/FIQs also on crash CPUs
 shutdown path
Thread-Index: AQHYWolciKXO2fn1XUueFH8wz+psXK0HFf6Q
Date:   Fri, 29 Apr 2022 16:26:02 +0000
Message-ID: <PH0PR21MB3025F5AADF3CCEF714585912D7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-3-gpiccoli@igalia.com>
In-Reply-To: <20220427224924.592546-3-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=da7688d4-abf9-471b-8371-b8d1f4f7a276;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-29T16:24:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12d2e652-94f5-4275-caf3-08da29fcf3a3
x-ms-traffictypediagnostic: CH2PR21MB1525:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CH2PR21MB1525A56096F29DA35274DF06D7FC9@CH2PR21MB1525.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wB8XZ1/NZe0RxqPcMyP9Fl0jn5spPmxDwsu1zSlW6C0kyE5ykFkLFABY5ragQHHt4qFaO6+geen2Ziig93fScW0al/m8IHVYIsiAab4ANv6Po4YsCkZ+eD2CMdpIZqo2H3/NBWooxmu7ohtHxciOfGYLHiAcHjO3yTaMe7NkhERBhAkla1wJ3WTY5b4GnGVMBKdmBhXs038s3YC8KBQBChzYwORF2w+j5eypjrRxQ/hungUzeBkm8NgF/SZVuGFgPKlpagUj8AV9O2n+y203gTS7Q3axk1bs9Vry0snJOw5dIZgOSmNF8sXtOqCxX7t5Qff59Qv6eS2ETSnQZ+Jn14GG0hX7Lb5Dw8hgyHu8i92nY0GH1DLFB/fe1WIZES0JyYvE8jFKYN5sViiLIo4ZyC1IH7IFNC+G+jdTIv/2zffnpmRdJ5s8QmGQL93vWotrzk+UzVXQU+nJ3aMUrmYQrApWY5L6BH9NeHgXmtgEfoKGjdt+LDt7m/ONjF5umDYj8PCEzxX7jwKXP1ukzcjGKglLSE5LkvERS+PCB5fOAaBFqdNfctPErxc5ftlkdrgmBhbZMIGVCzZJVdgajqAdVm5Gh4a5z41n0pvweuQjq0ptieR5IivpdIn8d3MA3WAmwPD8MZ8xQvNINpM5HJa9vMtpk/PGHSsNyIUjUY9RSpRgYogXTnaPjfU33i+sSXmpGaGlMdirdlcwIYQ88kqcCkhtwOlnm8I4QvjnWfjwhmSsqf7DJ13MfqHMkBe2YAC2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(10290500003)(86362001)(26005)(54906003)(2906002)(83380400001)(186003)(316002)(38100700002)(38070700005)(33656002)(8936002)(55016003)(5660300002)(110136005)(8990500004)(64756008)(4326008)(52536014)(8676002)(82960400001)(82950400001)(122000001)(7406005)(6506007)(508600001)(7696005)(76116006)(9686003)(66446008)(7366002)(7416002)(66946007)(66556008)(66476007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HOVOBMjGnBhzww+fSAuwt5Y26ag/vTm7WJsA/0I+lrHqOX4Kij7UXrUK9ioi?=
 =?us-ascii?Q?Apfoi6F26pG/5LFLJ6/sVCcXGpmG8Szt0yI2g6I87VtbMuNFixlFmlAts5Kp?=
 =?us-ascii?Q?juzfxPQr8QSJsvRkR1FCEBWX7zDFGljJEmkOuhvWZA5iu95GzHEl9smQupkQ?=
 =?us-ascii?Q?uA1vkvhMWl3SN2UtN8Re01sF69mYEyvKEoq5OeH3RYS/9dAMLsbAoCG64hkr?=
 =?us-ascii?Q?yWa1lBi9LU2n+8TPjAIiu/xsEMXrZL92OmZnVWGPEUBkziTcpTCTVmPJHuDH?=
 =?us-ascii?Q?trWdGcvtEnuDI2OqJqEsTUfBBaYMcW+NTMhpaG+I+y0koUVV5JEoRh4J4SVc?=
 =?us-ascii?Q?4gJ5Tb6edzw7Aww0E9SBwOx0OIJzqZ3T0zdt211/2sSx2hG+vGGna5Ep/fZx?=
 =?us-ascii?Q?FzmXpK2rWabCCg1tSzk87qixyQjNHWTDrzoZPsfu4aCUZIRQsst+gOimR9FM?=
 =?us-ascii?Q?7x+ffC3s93rLaKZdUqKPMMnb6PmqoG/hcxmoMAT7j8YoUyHenRzCc1Vv7Q3i?=
 =?us-ascii?Q?SQNSOyH7lw8R3ZlHVbQcqk/BkpNfJunTf6v1V+4/yoXhMGLVdP0NEqoGmSkW?=
 =?us-ascii?Q?oiBKZ1I/ksmYecWTsu5aI4ZMylDc7mPHzOSNypIyncccCthwKLfgL5zE2pmc?=
 =?us-ascii?Q?Bsqfdovl3XaYF9zRCZWFnwiN5FUUsKuWQOtW/SxKtHxipD85E7gTtdEjp0hB?=
 =?us-ascii?Q?eezovK8Dqv02f72andbcnbhslU6/CIaDGkpdF+rxxO0t9FLkmx0HzdrCQ6m9?=
 =?us-ascii?Q?PYM4UMY5gCzR72PVLPooj7dZQ9ORhxxarnRAsqkPx+OoZlJxdpZLm5Xlnn8h?=
 =?us-ascii?Q?ejv/fRH9oYEB0YT3wVYMufGEdETBE6lIuS4e1CQn8btX6+N6lqNr/sDwrzoK?=
 =?us-ascii?Q?yG/kNL/WyW+pWnmlD73aGxBm3oTlfy92yh7mFiGx3XoP1H67xibXilHvjHeq?=
 =?us-ascii?Q?CIQ9jSr1Yml4yr9Ze4AZSarYeEkA51U+ZYqM2WsPJxtslTIjdOn9VrMmfC+c?=
 =?us-ascii?Q?Un9f8WuFOi4FrffZLKk7eV56OScnFML7IH1frQOE/TVLYyY4S+zsEAoxutET?=
 =?us-ascii?Q?7vtA97Tev2KRlXwu7g8i9dpLRscID48LCT9WdFTpdrDcrQCA9X+4U3HLVaEy?=
 =?us-ascii?Q?bvDwUxLjCXV5E7MX6B0iIdxqMeLZJHDcLIsE3BkMSFZ0eRBw9tqvixK5ITek?=
 =?us-ascii?Q?KEcQ9L/MHgkugZs/5SXapjVC2M+tW6029NxUWMMRr6cYdz5WJJN/xL4fuXGr?=
 =?us-ascii?Q?reNb1So3iGx9/B4i2r6GbXK8QiV1VdL+cmrYuXNzspThAeIVevwZsZixA5wp?=
 =?us-ascii?Q?5Qj8MYvb7BUV6ie9V0iec61TynvQ/w3V5kg9Wsfj4s2rlxFsuP5c5E/LfdKm?=
 =?us-ascii?Q?AGMRFARkVLGBAuACPa4Z+rEwWjWn9eO0FnNg6W+yjyG1tZ/2FU5PwKw96fo3?=
 =?us-ascii?Q?zhJKN9CaUFHYrMwnYpS6v1LQEhx9OJ49Z8LplX4t/xvLeOETvjp07zOztXY8?=
 =?us-ascii?Q?yWTDOzSQv2FjyFjGVPzqtRHm7xg9uDRC3DzC+aWpNFiEh6KvdQZ1v5OwR3m0?=
 =?us-ascii?Q?OnN8mIndbJhD97RCmboNmOMpBSpaI1JPK7DI4PB/6oonTzc1omct6SDMFM4p?=
 =?us-ascii?Q?/tVAjdpQ1ctoAmWKB8CBMjVxEofkH9ri48pnp4FraSGWIwUp4jQPX3POvr72?=
 =?us-ascii?Q?BRZcCEMDdJWPVsq3pJZvDpAhyaHOx0b45Z7m1cE9VAHlAi5dc/L8k9VGYwOF?=
 =?us-ascii?Q?l3tv1fE1Q8ybciN7k3D85UcPN2nclxk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d2e652-94f5-4275-caf3-08da29fcf3a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 16:26:02.2141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iO+PqzIAdZZfIpEhplUNNDiJF+yGhuHwl3BsWuuQSH2Wxe1HA34Es/xn0LzDD3atpaDnvY9htz4Fd+iXjEy5lQqxIugHEad6MWW3aMA9kUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1525
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Wednesday, April 27,=
 2022 3:49 PM
>=20
> Currently the regular CPU shutdown path for ARM disables IRQs/FIQs
> in the secondary CPUs - smp_send_stop() calls ipi_cpu_stop(), which
> is responsible for that. This makes sense, since we're turning off
> such CPUs, putting them in an endless busy-wait loop.
>=20
> Problem is that there is an alternative path for disabling CPUs,
> in the form of function crash_smp_send_stop(), used for kexec/panic
> paths. This functions relies in a SMP call that also triggers a

s/functions relies in/function relies on/

> busy-wait loop [at machine_crash_nonpanic_core()], but *without*
> disabling interrupts. This might lead to odd scenarios, like early
> interrupts in the boot of kexec'd kernel or even interrupts in
> other CPUs while the main one still works in the panic path and
> assumes all secondary CPUs are (really!) off.
>=20
> This patch mimics the ipi_cpu_stop() interrupt disable mechanism
> in the crash CPU shutdown path, hence disabling IRQs/FIQs in all
> secondary CPUs in the kexec/panic path as well.
>=20
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>  arch/arm/kernel/machine_kexec.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_ke=
xec.c
> index f567032a09c0..ef788ee00519 100644
> --- a/arch/arm/kernel/machine_kexec.c
> +++ b/arch/arm/kernel/machine_kexec.c
> @@ -86,6 +86,9 @@ void machine_crash_nonpanic_core(void *unused)
>  	set_cpu_online(smp_processor_id(), false);
>  	atomic_dec(&waiting_for_crash_ipi);
>=20
> +	local_fiq_disable();
> +	local_irq_disable();
> +
>  	while (1) {
>  		cpu_relax();
>  		wfe();
> --
> 2.36.0

