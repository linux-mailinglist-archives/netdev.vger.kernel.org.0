Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B9D51517F
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379483AbiD2RUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 13:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379151AbiD2RU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 13:20:28 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020017.outbound.protection.outlook.com [52.101.61.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0258878E;
        Fri, 29 Apr 2022 10:17:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URt1keDbmBYpByak8BMw2WLHo2bkoLNKsyAqefiLdx4hcDh+VaWHHr/IrnwKxtuwyWvonjTN7LNBD4ywp3IUkZtg3fLTBzc03nkASHfSBaLKiY9txUkZGTYizwG/bljAw1XgI7zDOp+Ltm2PBHQwuet/bgAgcycp+FnQXrE9tGuLxsSfzl9WSDOrbTjre+mvldRx8oS/9KThf2H9OzphMR3ZbHlB33XoUh3i4RpaxuFrhpJPhRNP+NFW2e5dc8C+bT8+8SE/p63rmUfijzQOFTJ4dm/pMJw6F/KMhXQ9f+oTSeh0RCRwvKAhtLb8EwzoNeQdbmCqox+npnAHmhVfhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1MSaduGN1AEz6gGdbjAeFMSbDhhPZ73iNsd4tjQN9I=;
 b=k/3c/R2wdnbzLU/OcdhOUbhlE5FrxBN4OZBtNLQVN9r5snmxzPZBdl+XYEUVUPkkr97EmA6lxq+ZPVP1MOARmOsLC2hcEvVIIP5YYa4LfrS0tx98M6XHPrzqIteeyXrbotwEcNcmYnIfwiMNZqK5t+8d+pMODVq95oDkBqljSL2O70QPckEBDgIJKxlneoyB/MsSiXDrAhoPpTYuDG1nmYHA68IubyI72MSjS0zE7eS8H7jGsFyL3YjdiEwGgbVd6fG/Xa4KoKvGxjc/x5CbfDxQduPmrRvYXCEzz4fCMSXBZsSeVf2KvjWWg+vmJU8I3RoBlzjNDXTtViDmpoZ4Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1MSaduGN1AEz6gGdbjAeFMSbDhhPZ73iNsd4tjQN9I=;
 b=cS9+179RG/61x4VdHipVPHqqRTJBnmdfe6m8GNL4SybzXHAHGDXPPpyHqr8XdYPz6jNfk4L58J6vQvT4W0sPT6R4oBVYiW0q20tFmK4wguWLRFEkPwtqH1JMI4Cn4bqUNJuds1zkHPNsQvZEKKZt7StxIoQLPjh78p6FPwwvEXg=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by PH7PR21MB3044.namprd21.prod.outlook.com (2603:10b6:510:1e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.1; Fri, 29 Apr
 2022 17:16:59 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%6]) with mapi id 15.20.5227.006; Fri, 29 Apr 2022
 17:16:59 +0000
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
        "will@kernel.org" <will@kernel.org>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: RE: [PATCH 16/30] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Thread-Topic: [PATCH 16/30] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Thread-Index: AQHYWonHTKAKlsJlK0mi6B2rKp5WnK0HF4GA
Date:   Fri, 29 Apr 2022 17:16:59 +0000
Message-ID: <PH0PR21MB30250C9246FFF36AFB1DFDECD7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-17-gpiccoli@igalia.com>
In-Reply-To: <20220427224924.592546-17-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5894e0d7-48ac-4694-a612-22bf4cd0226a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-29T16:29:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ee08c10-8795-4ffb-8d36-08da2a0411b3
x-ms-traffictypediagnostic: PH7PR21MB3044:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PH7PR21MB30444C7AF44CF950E0362EC8D7FC9@PH7PR21MB3044.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uv/yl6f/BdJJwj8MKE54LMCpY16sv/VMkBm5Bux19qb9yZFrMo9werEEvN+0ub2kM1sB+PlTVhjAKNi7/fAUcGChJ7882bpNX/5eNWYRxEU2nPTyROmnPjCO3rMdBW03Gfo3GhFCSqUf2N679RELIWadFJLXkHDjI09/tT8nHupgY9maWtlGoafg653LSsQMecJ2dqfViZIJPIA5buIfNLkfZvoCHchqHyXx3MgF69kRm/AlkA/oomMEc0jADv3X00DdbQermZhuvSUPLpRQFsrn+i5VBHkfzA+0C1IMmAk5gFfY3yFNYXETPPSvJnIewiA2i9WbTbpIiPknKzh7ZCgi6O+YewZimrgwuRVXoM3uyhtAGYp0J3dSbNL/WCFmYCosfJyWyt/OAqswR0d8FYpJBwDeJ4y4fFMji/s+9cA+0JSVh8ZTzLqsnZ5URa1DFUy5Byj7ZJFFcUPe5n/8vmKCvqc2xCIQ7w4KkA7xY/SVhIe/OoC4UvaR+LU4oaLhwmYw7MBFAtzRLfOfUeywHgCWd2I/egtIb31EuvqNY/H3gYQf1Jk7tMZrYgIUjP1b0S8diKZm+BMHaprLTTbxbrCVF++LNp9HSVDZLP+GxhmiD2C425/smPWmAZvZVetnj8WAwXjCqxYLRcy8jXhSgugUTMdJYu0BHOYNI1aRnfbAdTYG60e9hFN7/n/NFgvFkCI/t2nDZ4HgVul8vHdv7V8PsMJGF4ncet9B/nPiBjh10lp9xXhtYTi0gG1H7JYQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(2906002)(186003)(4326008)(66446008)(66946007)(76116006)(66476007)(64756008)(8676002)(5660300002)(316002)(26005)(7696005)(6506007)(66556008)(55016003)(86362001)(33656002)(9686003)(71200400001)(508600001)(7416002)(122000001)(8990500004)(83380400001)(110136005)(8936002)(54906003)(52536014)(10290500003)(38070700005)(38100700002)(30864003)(7406005)(7366002)(82950400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xaf3lHKNZ0TtwG8wQrQ8tlZwWch2tizm/QDdnEDkq6EX57mCLA2YJFCxqIZo?=
 =?us-ascii?Q?/CiZ2Wp7M+/9M/RMUZeQNDuunS7CgGnS7veCbONC6g780Sycjb9YsaA4s/Pl?=
 =?us-ascii?Q?hbioPJaCLOxELo4NhFekChWnbffzm/8SyQbP0B3b/SwpPEQynEywZ9T9EgN8?=
 =?us-ascii?Q?nVDMcl+gOQpToDUZP7guhbueiRbTuKnpv42BoYbUUk5cJptHKkt3gcnWlKbF?=
 =?us-ascii?Q?FNzFpJEfMewlRPxEYu4pOFtBohCAtJ7ngQnzzSClgslx9PBpAuJQOISuf4Q8?=
 =?us-ascii?Q?5FCiDeskIfldEO3cPhEfDGNW7OK4qYUE6z1MhNiz0Ze/jKtWM2HmfdjHPdMN?=
 =?us-ascii?Q?JSdV45AoPuxl1kVQzAKZ7YmwTuf2XjN0p/D3XO6Cim21s7iTi5rqIw9Kmzlv?=
 =?us-ascii?Q?uKpmGyuce/qMehcSEQK0ZvPny4o5LA/cqwV+FmcPlsw04kSJ5Wj+4Mi8Nv8Y?=
 =?us-ascii?Q?ME60uS7JIkR4YuR7D+5kzNQVsHSgtLCGrGGA1pbZ0rng6XAy4ysv3azC1CFP?=
 =?us-ascii?Q?fi5HYxL3dYUVWyT9ZRsKmYBQ2jaPenexEzDBprEkhmBisxUnwd18U8dQaLvh?=
 =?us-ascii?Q?flPcRN1fqjCs82TJFxe86kVYnGopY8jCmrW1NZZm+uTPgLGoPn7AAog/7UQy?=
 =?us-ascii?Q?xpJV/hGNZ2M5LbzKFil3wL4WbW9BJYrJZ+sh7qZ4wG0U7NACvCE2T29EI2TY?=
 =?us-ascii?Q?F+/gZE8msGZOCQlmoDnzqGaX3K42HrR1KHWaCvRVy0WpUiQi+PkRTq2haB/x?=
 =?us-ascii?Q?z3hd/rOLlyLyQvMfgSSGWcL2dCIQntOCQzdi1FzIhvbGg6Uqqj4gFD94S+La?=
 =?us-ascii?Q?azrzqYdWvV64BMdgHHO3hiV+PDyZ850oaA/IVIQDbyYo6UoKLCjeHcB6dOsC?=
 =?us-ascii?Q?ExwBv7rOmH5WAgWxvSWs7uCEmf2hPjHkXXFutxNc6oZF0NQTm6ZLe2US3kV1?=
 =?us-ascii?Q?2dBv7i2lYHEWtEZHYuRMjqI0eoQjmgMtSFMK2nyvB6wGjDJQnQJnzCZJzu+k?=
 =?us-ascii?Q?8X/tmGO5a/QXrvo8DAOZDXRF8yHMAtW2qbOSHh/f0N/Kr/5wmi5kq66298Vg?=
 =?us-ascii?Q?8F9zr2wKnP7RmZoW1RLpUofCKw7CRwzK/3h4oJlWC/YBloHR+PtmiI+lFTHj?=
 =?us-ascii?Q?0Q7RPLTqPND5oJNPnGNVTtO82ypCISGnOAPhX+I8iAp4xt8GikiYT3/zOzyo?=
 =?us-ascii?Q?My24qDFKD9+w7NefTZumfuOW4veQKD9Sz/ZTpC7/M3HSKSOgAh864XoJ7hEr?=
 =?us-ascii?Q?C+rwnaGCChVvzEJvtXrvNg1Gb+HMAYmlurj90jmdmxJuRZsP8HvzRspvb77S?=
 =?us-ascii?Q?QAqiNF7J3kXU2eV4M2FvGorefimM0Kd1EVf01/cA1gHB6RupvcUx7q0rQDRC?=
 =?us-ascii?Q?kwyO3cCxyt/dlg7Cywpgili6yGcb9sSsp8l4bOeQdGWbQg7F7ufP2dZ8T6Ex?=
 =?us-ascii?Q?ZVpSfM/PJGqMnIlPp/M2RiTLvV2cQa7rNEDxcwrSOe9wG0UETJsRlM5yY8Vb?=
 =?us-ascii?Q?cZd2InecTanmGqrZn8ovT7yWLiknKtoCLaAI084lTiE0xZhnmwyA5/SpPBeJ?=
 =?us-ascii?Q?FYik20mn3+zMwimzMeSaoN434cXne+xZ2gUMAKwOzDrB++oZk+qUDjSI9uTG?=
 =?us-ascii?Q?5kId3mU1gxwsyYmNcOeq/m5aGZlqw4SkObPDGXzlAJELgp+LVvVAY5nwIBS2?=
 =?us-ascii?Q?MvMluW0c9uKvW3opqyw6mG65vTKGcoCygp7Wlcgnp7avbIHQj302J+WTNjSb?=
 =?us-ascii?Q?rjUdg07eny+pqvz9K0cc8XoH4Y64Epw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee08c10-8795-4ffb-8d36-08da2a0411b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 17:16:59.0862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9qRMIqeGqCT6lpOJ0z77u+sW/YCPHCtrfjizxejds1UxGOcvlUAbEteC59UC9TmkcRx/jSQ3DPCoipx7zC8pg4LKbOtmgrY8pLvBUZL2IBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3044
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Wednesday, April 27,=
 2022 3:49 PM
>=20
> Currently Hyper-V guests are among the most relevant users of the panic
> infrastructure, like panic notifiers, kmsg dumpers, etc. The reasons rely
> both in cleaning-up procedures (closing a hypervisor <-> guest connection=
,
> disabling a paravirtualized timer) as well as to data collection (sending
> panic information to the hypervisor) and framebuffer management.
>=20
> The thing is: some notifiers are related to others, ordering matters, som=
e
> functionalities are duplicated and there are lots of conditionals behind
> sending panic information to the hypervisor. This patch, as part of an
> effort to clean-up the panic notifiers mechanism and better document
> things, address some of the issues/complexities of Hyper-V panic handling
> through the following changes:
>=20
> (a) We have die and panic notifiers on vmbus_drv.c and both have goals of
> sending panic information to the hypervisor, though the panic notifier is
> also responsible for a cleaning-up procedure.
>=20
> This commit clears the code by splitting the panic notifier in two, one
> for closing the vmbus connection whereas the other is only for sending
> panic info to hypervisor. With that, it was possible to merge the die and
> panic notifiers in a single/well-documented function, and clear some
> conditional complexities on sending such information to the hypervisor.
>=20
> (b) The new panic notifier created after (a) is only doing a single thing=
:
> cleaning the vmbus connection. This procedure might cause a delay (due to
> hypervisor I/O completion), so we postpone that to run late. But more
> relevant: this *same* vmbus unloading happens in the crash_shutdown()
> handler, so if kdump is set, we can safely skip this panic notifier and
> defer such clean-up to the kexec crash handler.

While the last sentence is true for Hyper-V on x86/x64, it's not true for
Hyper-V on ARM64.  x86/x64 has the 'machine_ops' data structure
with the ability to provide a custom crash_shutdown() function, which
Hyper-V does in the form of hv_machine_crash_shutdown().  But ARM64
has no mechanism to provide such a custom function that will eventually
do the needed vmbus_initiate_unload() before running kdump.

I'm not immediately sure what the best solution is for ARM64.  At this
point, I'm just pointing out the problem and will think about the tradeoffs
for various possible solutions.  Please do the same yourself. :-)

>=20
> (c) There is also a Hyper-V framebuffer panic notifier, which relies in
> doing a vmbus operation that demands a valid connection. So, we must
> order this notifier with the panic notifier from vmbus_drv.c, in order to
> guarantee that the framebuffer code executes before the vmbus connection
> is unloaded.

Patch 21 of this set puts the Hyper-V FB panic notifier on the pre_reboot
notifier list, which means it won't execute before the VMbus connection
unload in the case of kdump.   This notifier is making sure that Hyper-V
is notified about the last updates made to the frame buffer before the
panic, so maybe it needs to be put on the hypervisor notifier list.  It
sends a message to Hyper-V over its existing VMbus channel, but it
does not wait for a reply.  It does, however, obtain a spin lock on the
ring buffer used to communicate with Hyper-V.   Unless someone has
a better suggestion, I'm inclined to take the risk of blocking on that
spin lock.

>=20
> Also, this commit removes a useless header.
>=20
> Although there is code rework and re-ordering, we expect that this change
> has no functional regressions but instead optimize the path and increase
> panic reliability on Hyper-V. This was tested on Hyper-V with success.
>=20
> Fixes: 792f232d57ff ("Drivers: hv: vmbus: Fix potential crash on module u=
nload")
> Fixes: 74347a99e73a ("x86/Hyper-V: Unload vmbus channel in hv panic callb=
ack")

The "Fixes:" tags imply that these changes should be backported to older
longterm kernel versions, which I don't think is the case.  There is a
dependency on Patch 14 of your series where PANIC_NOTIFIER is
introduced.

> Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Michael Kelley <mikelley@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>=20
> Special thanks to Michael Kelley for the good information about the Hyper=
-V
> panic path in email threads some months ago, and to Fabio for the testing
> performed.
>=20
> Michael and all Microsoft folks: a careful analysis to double-check our c=
hanges
> and assumptions here is really appreciated, this code is complex and intr=
icate,
> it is possible some corner case might have been overlooked.
>=20
> Thanks in advance!
>=20
>  drivers/hv/vmbus_drv.c          | 109 ++++++++++++++++++++------------
>  drivers/video/fbdev/hyperv_fb.c |   8 +++
>  2 files changed, 76 insertions(+), 41 deletions(-)
>=20
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 14de17087864..f37f12d48001 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -24,11 +24,11 @@
>  #include <linux/sched/task_stack.h>
>=20
>  #include <linux/delay.h>
> -#include <linux/notifier.h>
>  #include <linux/panic_notifier.h>
>  #include <linux/ptrace.h>
>  #include <linux/screen_info.h>
>  #include <linux/kdebug.h>
> +#include <linux/kexec.h>
>  #include <linux/efi.h>
>  #include <linux/random.h>
>  #include <linux/kernel.h>
> @@ -68,51 +68,75 @@ static int hyperv_report_reg(void)
>  	return !sysctl_record_panic_msg || !hv_panic_page;
>  }
>=20
> -static int hyperv_panic_event(struct notifier_block *nb, unsigned long v=
al,
> +/*
> + * The panic notifier below is responsible solely for unloading the
> + * vmbus connection, which is necessary in a panic event. But notice
> + * that this same unloading procedure is executed in the Hyper-V
> + * crash_shutdown() handler [see hv_crash_handler()], which basically
> + * means that we can postpone its execution if we have kdump set,
> + * since it will run the crash_shutdown() handler anyway. Even more
> + * intrincated is the relation of this notifier with Hyper-V framebuffer

s/intrincated/intricate/

> + * panic notifier - we need vmbus connection alive there in order to
> + * succeed, so we need to order both with each other [for reference see
> + * hvfb_on_panic()] - this is done using notifiers' priorities.
> + */
> +static int hv_panic_vmbus_unload(struct notifier_block *nb, unsigned lon=
g val,
>  			      void *args)
> +{
> +	if (!kexec_crash_loaded())

I'm not clear on the purpose of this condition.  I think it means
we will skip the vmbus_initiate_unload() if a panic occurs in the
kdump kernel.  Is there a reason a panic in the kdump kernel
should be treated differently?  Or am I misunderstanding?

> +		vmbus_initiate_unload(true);
> +
> +	return NOTIFY_DONE;
> +}
> +static struct notifier_block hyperv_panic_vmbus_unload_block =3D {
> +	.notifier_call	=3D hv_panic_vmbus_unload,
> +	.priority	=3D INT_MIN + 1, /* almost the latest one to execute */
> +};
> +
> +/*
> + * The following callback works both as die and panic notifier; its
> + * goal is to provide panic information to the hypervisor unless the
> + * kmsg dumper is gonna be used [see hv_kmsg_dump()], which provides
> + * more information but is not always available.
> + *
> + * Notice that both the panic/die report notifiers are registered only
> + * if we have the capability HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE set.
> + */
> +static int hv_die_panic_notify_crash(struct notifier_block *nb,
> +				     unsigned long val, void *args)
>  {
>  	struct pt_regs *regs;
> +	bool is_die;
>=20
> -	vmbus_initiate_unload(true);
> -
> -	/*
> -	 * Hyper-V should be notified only once about a panic.  If we will be
> -	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
> -	 * here.
> -	 */
> -	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
> -	    && hyperv_report_reg()) {
> +	/* Don't notify Hyper-V unless we have a die oops event or panic. */
> +	switch (val) {
> +	case DIE_OOPS:
> +		is_die =3D true;
> +		regs =3D ((struct die_args *)args)->regs;
> +		break;
> +	case PANIC_NOTIFIER:
> +		is_die =3D false;
>  		regs =3D current_pt_regs();
> -		hyperv_report_panic(regs, val, false);
> -	}
> -	return NOTIFY_DONE;
> -}
> -
> -static int hyperv_die_event(struct notifier_block *nb, unsigned long val=
,
> -			    void *args)
> -{
> -	struct die_args *die =3D args;
> -	struct pt_regs *regs =3D die->regs;
> -
> -	/* Don't notify Hyper-V if the die event is other than oops */
> -	if (val !=3D DIE_OOPS)
> +		break;
> +	default:
>  		return NOTIFY_DONE;
> +	}
>=20
>  	/*
> -	 * Hyper-V should be notified only once about a panic.  If we will be
> -	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
> -	 * here.
> +	 * Hyper-V should be notified only once about a panic/die. If we will
> +	 * be calling hv_kmsg_dump() later with kmsg data, don't do the
> +	 * notification here.
>  	 */
>  	if (hyperv_report_reg())
> -		hyperv_report_panic(regs, val, true);
> +		hyperv_report_panic(regs, val, is_die);
> +
>  	return NOTIFY_DONE;
>  }
> -
> -static struct notifier_block hyperv_die_block =3D {
> -	.notifier_call =3D hyperv_die_event,
> +static struct notifier_block hyperv_die_report_block =3D {
> +	.notifier_call =3D hv_die_panic_notify_crash,
>  };
> -static struct notifier_block hyperv_panic_block =3D {
> -	.notifier_call =3D hyperv_panic_event,
> +static struct notifier_block hyperv_panic_report_block =3D {
> +	.notifier_call =3D hv_die_panic_notify_crash,
>  };
>=20
>  static const char *fb_mmio_name =3D "fb_range";
> @@ -1589,16 +1613,17 @@ static int vmbus_bus_init(void)
>  		if (hyperv_crash_ctl & HV_CRASH_CTL_CRASH_NOTIFY_MSG)
>  			hv_kmsg_dump_register();
>=20
> -		register_die_notifier(&hyperv_die_block);
> +		register_die_notifier(&hyperv_die_report_block);
> +		atomic_notifier_chain_register(&panic_notifier_list,
> +						&hyperv_panic_report_block);
>  	}
>=20
>  	/*
> -	 * Always register the panic notifier because we need to unload
> -	 * the VMbus channel connection to prevent any VMbus
> -	 * activity after the VM panics.
> +	 * Always register the vmbus unload panic notifier because we
> +	 * need to shut the VMbus channel connection on panic.
>  	 */
>  	atomic_notifier_chain_register(&panic_notifier_list,
> -			       &hyperv_panic_block);
> +			       &hyperv_panic_vmbus_unload_block);
>=20
>  	vmbus_request_offers();
>=20
> @@ -2817,15 +2842,17 @@ static void __exit vmbus_exit(void)
>=20
>  	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
>  		kmsg_dump_unregister(&hv_kmsg_dumper);
> -		unregister_die_notifier(&hyperv_die_block);
> +		unregister_die_notifier(&hyperv_die_report_block);
> +		atomic_notifier_chain_unregister(&panic_notifier_list,
> +						&hyperv_panic_report_block);
>  	}
>=20
>  	/*
> -	 * The panic notifier is always registered, hence we should
> +	 * The vmbus panic notifier is always registered, hence we should
>  	 * also unconditionally unregister it here as well.
>  	 */
>  	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &hyperv_panic_block);
> +					&hyperv_panic_vmbus_unload_block);
>=20
>  	free_page((unsigned long)hv_panic_page);
>  	unregister_sysctl_table(hv_ctl_table_hdr);
> diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv=
_fb.c
> index c8e0ea27caf1..f3494b868a64 100644
> --- a/drivers/video/fbdev/hyperv_fb.c
> +++ b/drivers/video/fbdev/hyperv_fb.c
> @@ -1244,7 +1244,15 @@ static int hvfb_probe(struct hv_device *hdev,
>  	par->fb_ready =3D true;
>=20
>  	par->synchronous_fb =3D false;
> +
> +	/*
> +	 * We need to be sure this panic notifier runs _before_ the
> +	 * vmbus disconnect, so order it by priority. It must execute
> +	 * before the function hv_panic_vmbus_unload() [drivers/hv/vmbus_drv.c]=
,
> +	 * which is almost at the end of list, with priority =3D INT_MIN + 1.
> +	 */
>  	par->hvfb_panic_nb.notifier_call =3D hvfb_on_panic;
> +	par->hvfb_panic_nb.priority =3D INT_MIN + 10,
>  	atomic_notifier_chain_register(&panic_notifier_list,
>  				       &par->hvfb_panic_nb);
>=20
> --
> 2.36.0

