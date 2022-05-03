Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CC7518C0B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 20:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241127AbiECSRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 14:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241121AbiECSRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 14:17:38 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020022.outbound.protection.outlook.com [52.101.61.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970063E5FB;
        Tue,  3 May 2022 11:14:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=he4GrjUJs+pbbWOQAVUF9nF+ZBMO4NsBCGINPa3zG0Bz1QzGye7Hk6i58aQzP3Blsk4b3K481euJuFtVdA2Zl8Y9mhnDmx4UXp3nDA+I9uaN0WjUXEvwqxyunj30uyFdLPvsh9QNCwG5izqZo+EK0KzoTtamKSkqRqHzvoVQurdi/xURo6vL0AtXF6EhXCNcLLW4aPu7HrQvw+xU2zbD/dD/frLKp7O3y+bzOKLeBqXNtsEsnaWHIUMmyPLivm3BGEnNiyZpnm/0uTsvEZ6C6Plz7pX/bbiWmLQuAfY6WUyxI/e9r/KBnxIFktKIoSecveRqgN64wh8mo4s0A8CH4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHdWyr/lQ4oMAILHgYnTcyVdhz+H5tpb/ZbxMPdRznY=;
 b=Z8Q7zSE2FHB3mX9406scaZ7L/J5DU+5rZWfUrzWaCXcLS/K/Bms05PaCHEzN2F0GO7mbO6MP/3efMdcYTEEe6qc6Zsvo2EtFOPVsWEPlAvCGrkAh+cFw5roduWkgm8+olQJb+7ki2gL4oCfx5PGOE4yNt+SwPcn5h9gLzy86+3AHBjA6HCldqjdgt7TTYQ8wvJjH4tT01cap8x/HBDfBqMP1s1hw6+naeoy1L5qe3eXoSLNH9T1uTOMsGhvGrZM99GizzxF42pM4Xn/M5rWCreeHz3I/LVKPYt0pTXJYbtmxmNqft5UKqxvNh52cg/eUbLZXIi8dpy/iPrIu+ZR2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHdWyr/lQ4oMAILHgYnTcyVdhz+H5tpb/ZbxMPdRznY=;
 b=N8b4zUYeoSjVoBnIOHZk9x7r326uVrpKbKzx6XXMOIrzFUAHQx5Vf0lGVGrXZlrXWa6AW+P6rzthVyShps/A6r3TZdabpgEBaTS9lCeVdBHNNE//vXD9jQ0tGm9xQNx3bTBkWGRMD+GYCBn7m/MbMeekivw2v/V0MngTJJcvwwM=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by PH7PR21MB3140.namprd21.prod.outlook.com (2603:10b6:510:1d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.6; Tue, 3 May
 2022 18:13:52 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%5]) with mapi id 15.20.5250.006; Tue, 3 May 2022
 18:13:52 +0000
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
Thread-Index: AQHYWonHTKAKlsJlK0mi6B2rKp5WnK0HF4GAgABmLoCABfgOgA==
Date:   Tue, 3 May 2022 18:13:52 +0000
Message-ID: <PH0PR21MB3025A46643EEDA6B14AC1ECED7C09@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-17-gpiccoli@igalia.com>
 <PH0PR21MB30250C9246FFF36AFB1DFDECD7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <2787b476-6366-1c83-db80-0393da417497@igalia.com>
In-Reply-To: <2787b476-6366-1c83-db80-0393da417497@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b41f9d07-1c9e-45a3-8ea4-5e837b666291;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-03T17:44:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40ac3dec-95e5-41bb-b783-08da2d30adb3
x-ms-traffictypediagnostic: PH7PR21MB3140:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PH7PR21MB3140268695323CBF6259C45AD7C09@PH7PR21MB3140.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FnIu9JpCdSU0bQtZUV5dEj7PTdHFP+LtwhgAsFHYKotKFZawzkNh1lUKYQokTK/oCA2oTWbBewVD72G73c3XzAhVtFhiLcEIRL5qdiF/xtEroSX1oj54Gq2PNnlzvUiCrd5TgrPM8LLQol7Wv8rD+kp4HyGQqXAFjMMN/Q2b4ZnVWNQ00/Vk5ypMiLQC/Ge/LCjSKneNG1xvmc2w9eX5SQ+/NyoLbnPryEqqBn7XuhMGDPslUzBOCcBN9YzUH68DS3hVF/Y5YhZtptZAZl2fTODZaJ2OwlykQp2I7Y6oG604LaPSsD0WPRmfpuaxoaOJIBdg0z+sdf+ubxmrC2Lr6MC6CrHAYG2L9kYqxZ4TqUtfoYZe7iudHWuxS69IuDr6iBZqdpgoDeHt3w3VzP9WxgI8jPwJCQwQv1mBZQJmhCbOFyKbCW388TQmxGJBM+r/qP9RJnhIgeQ5lWNdHZQKBsJxXz9+WhNGVkCgDdXgrY8MH9TQ2Sf3xIRTrK1LLXk+zeEbeaxHdfl56bAKPB5NuJiRqc1btjZYZQk16htM9PY07KltFPdC2rrMXk7odT8u+eVy+MBlh+KWuBEiY95z+g0uDfcC050kDJa8XsOULxaq6Wf52amSPQlpcL9dg6HDsB0YS1ka7dqVfJuoxshV5S/Ebu1mJvmoKPDJAT4s5+acqoljARobFpoBsZLvfqrvHnUWSvRY+07fOtsxPKpPoCJ8/mvijdRVVId+MDSBmoOuSdmutfrJNctuNoWS/Afw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(7366002)(10290500003)(5660300002)(508600001)(52536014)(7416002)(8936002)(9686003)(26005)(122000001)(71200400001)(7406005)(38070700005)(38100700002)(66556008)(86362001)(53546011)(76116006)(7696005)(110136005)(8676002)(66446008)(66476007)(64756008)(4326008)(6506007)(54906003)(66946007)(82950400001)(82960400001)(2906002)(186003)(55016003)(316002)(83380400001)(8990500004)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDhJRGpJaGwrNTR3ZDdabHBaaGZVMTUvb1hqVWwrclBlK0wrMzIzQmRXWlVN?=
 =?utf-8?B?RFB5cC91SGNPZ09CQ1RhWDZEbDBnZHI5d29CRFFlb2ZRdzYyZ3ViV2VmWVZS?=
 =?utf-8?B?L1NqZ3hyM3BTTW9YT2pQZFBtUVN1SmFERjM4Sk5qT2RlbkVQWU55bGJLZ3FE?=
 =?utf-8?B?TmJyZmV4VHJ3MjQvV212REJjTDJlMHZabGZ1RWtUUHpnUGVOUlNya2lNZHpR?=
 =?utf-8?B?V3lzZm1nb1FDZVR3Z3JmUVZPTEVEYkZCSUVjUVhpbU1QRkpwWEVOK2NzRU8v?=
 =?utf-8?B?Y0hSN0toQWFJRFFrVXZJR2tlZUtnd3JmOTVObnJla0NLSVE2Y1haRTlEd3Vw?=
 =?utf-8?B?eVUveFhjVWMybVE4V2FHZWNDdzY3d3habUZMcndIK21GdHp3Wmw3RWFMTEtu?=
 =?utf-8?B?NURSWU5UY28xbzdYL1hINmtEdUZGd210MTFSVGVvVWFnMnJwT3YxVDJCa1dK?=
 =?utf-8?B?cm8ra2ppeHdnalJnRDM5aU8zZFBjMEoyZXhUU3ZTZ05vSFZOT1hHTFFGOXNB?=
 =?utf-8?B?U1BaVXFxOGRhTWRadnZ4YW5yYWFrZU5oWlJ5N0xvb05ZU0JtSW9ZdE1hVmRy?=
 =?utf-8?B?RXpGS3h5a2JkYkJEbW0wcVF2eWZtSVpsTVF1MnJ0dUxqTEdFY1htaThXY0g4?=
 =?utf-8?B?T0QzODZMQVB1ejl4b3ZOWHA4TDErbWxzNFpjOVNqNjUrbGJVVGpieS9SV2pS?=
 =?utf-8?B?VFZPU1ErQXlFbTZZek45Nk5WZVF5eThLQUk1bmxSMUxyeDgwUjFJMHQwQkc1?=
 =?utf-8?B?QmdSVjFyQ1p3RzV0SDRCTjhKdzFwdU5Ec0M0SDV4M2JBbHJxRXJhRm1IaW9E?=
 =?utf-8?B?bHF5WHlCczd3bU9VeXhERGw0L21jalFmOGxBTHhBWEhiT3pIMU5zb0FkZDNi?=
 =?utf-8?B?QUZGUEFoSjRiNUx4ZUxoekRZeHhwRmd5R3lSOTNJNVhXbzYvaTVCOFU1M0NY?=
 =?utf-8?B?YUtiWXZuQlJDcnYzWUVDRURpWmYxb0ppaXN6cWU2L1U4YzBFNGdXQ0FJWHNU?=
 =?utf-8?B?WlBkTjdzSFc4Sk1QSEYwMERjY0xnSGpUVTdhMmJqV3ZQYVYyN1dBT0pzNVVL?=
 =?utf-8?B?OHQ1QXg5VXJic3p1WHdDc2xKRklMOUk2KzRYTmMvWHBDQ3B6d2hLSVkxRm9M?=
 =?utf-8?B?aWtCaktiYWx4blJGVjQxV3dJczBSTzQzNVNMYVdWZTJpUG5GVUJWV2RNTHNI?=
 =?utf-8?B?bk5hRlJNVmZFOENOVk1nOVVDMldvcUlGRzVMR0dCNnBRVDBySVNvWVZrUnFG?=
 =?utf-8?B?SFMrVVh6SW9VVWZ0N2pUNDFiRStHaVNiVkZJZGJSQ2c5aERqRnBuZDg1T3dy?=
 =?utf-8?B?dDhKdngyWFZBSGtUS2lacmlPYWJDay9LYkFNc0JZM1JNSmRSQ2hjeGRqa1pj?=
 =?utf-8?B?eFI5S2s1MkcwOEI4dWFjU1ordnlCM0IrQnhycWJWYVEwVXVLTVIyeGJabGhJ?=
 =?utf-8?B?N1YvTkhWNVlBUXVyaUF2UkZ0ZnlvdEhxbEJWU3FsMTM1Sjc4QWxQdy8xNVMw?=
 =?utf-8?B?K05NazBSdkV6VjllUllTdzFUK2k0NExGSlpVbkcyUVBqSjEwS3lpYVBucGd5?=
 =?utf-8?B?eXZiM3ZaMjM5OTF1S3JNYmY0SXlmQ2RiODNZY1Npd3JXcGxOTW03a1YycFN3?=
 =?utf-8?B?V3UydCt4NkxEWWhxMFh0YjNLWElJdHRablBrVzdPZDM5azBYQm5RNUxnbHNV?=
 =?utf-8?B?eVhKdDIxSHl5d01DZEp1emFCK3VOM2VKekF1Y2w3N0gwTHVnZmNXVUtrL2M4?=
 =?utf-8?B?UXlSc0YybWxncEVJZVNBNXkxWEVhcForc3Y5TGJZUjNsNEwwcWlPaTJjME44?=
 =?utf-8?B?VjJ1K25uQmZ0RGtMaHIrb0oxQnJ1Sm9vMGdTd1RxVklDcFoveHcybkxlOTJ3?=
 =?utf-8?B?eXhvWkRySEx5WlBmcG5KdEtBalZrcHNwMXZwbWJnYUpHU1dsT3ltMFgzRVd3?=
 =?utf-8?B?Nk03eEZHOWRRUkIvYVZXZGJTdXJibnpvcHpuby9ESThJTGNKVTFjYkxQQWlK?=
 =?utf-8?B?VlBVcVI5VmtYYms2bFF5cFl0WUFoOW9YOFNkZTh1bG5DQlJoWkJNQ0g0VU5B?=
 =?utf-8?B?M2RHRW1CNEtFRnFaVkhSN2p1UnVFczFpdHRYQ3JadnZoSzJyZFlqKzl2SlJO?=
 =?utf-8?B?VWpDVGlDSVdmbTJIOWNVa3hMMm9vMHFVOTQvSng0RG9HWEgvdTN0VkdtUFcr?=
 =?utf-8?B?amE1NWRNWUlMeUJKQk40aU9pUGRrU1E0SmxZTTdRMWh4RUhFOVpkR2hTRXps?=
 =?utf-8?B?aDRxeUdKbHJTc281c0hObXdkbCt2TFE1aHVES0VBczgwMjE2b0pqYmVOUTNv?=
 =?utf-8?B?VnVaZlRiTmpjQWVUeE00V0p5cERtUWpuVFU4YVFOd1V3ZHY5SGJqRXNYLzhW?=
 =?utf-8?Q?teI2zGknLdIGYpMk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ac3dec-95e5-41bb-b783-08da2d30adb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 18:13:52.1349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ui4kPv1QwwCeWcwraRIbiZaeFVEkUzs/5EQ9xwdazJ0cXTpmhELoQLf2pdHck77pdCw8h9HzCi86jIk8NpF5JK+JkBkOskELkyDCBUt8k0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3140
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3VpbGhlcm1lIEcuIFBpY2NvbGkgPGdwaWNjb2xpQGlnYWxpYS5jb20+IFNlbnQ6IEZy
aWRheSwgQXByaWwgMjksIDIwMjIgMzozNSBQTQ0KPiANCj4gSGkgTWljaGFlbCwgZmlyc3Qgb2Yg
YWxsIHRoYW5rcyBmb3IgdGhlIGdyZWF0IHJldmlldywgbXVjaCBhcHByZWNpYXRlZC4NCj4gU29t
ZSBjb21tZW50cyBpbmxpbmUgYmVsb3c6DQo+IA0KPiBPbiAyOS8wNC8yMDIyIDE0OjE2LCBNaWNo
YWVsIEtlbGxleSAoTElOVVgpIHdyb3RlOg0KPiA+IFsuLi5dDQo+ID4+IGh5cGVydmlzb3IgSS9P
IGNvbXBsZXRpb24pLCBzbyB3ZSBwb3N0cG9uZSB0aGF0IHRvIHJ1biBsYXRlLiBCdXQgbW9yZQ0K
PiA+PiByZWxldmFudDogdGhpcyAqc2FtZSogdm1idXMgdW5sb2FkaW5nIGhhcHBlbnMgaW4gdGhl
IGNyYXNoX3NodXRkb3duKCkNCj4gPj4gaGFuZGxlciwgc28gaWYga2R1bXAgaXMgc2V0LCB3ZSBj
YW4gc2FmZWx5IHNraXAgdGhpcyBwYW5pYyBub3RpZmllciBhbmQNCj4gPj4gZGVmZXIgc3VjaCBj
bGVhbi11cCB0byB0aGUga2V4ZWMgY3Jhc2ggaGFuZGxlci4NCj4gPg0KPiA+IFdoaWxlIHRoZSBs
YXN0IHNlbnRlbmNlIGlzIHRydWUgZm9yIEh5cGVyLVYgb24geDg2L3g2NCwgaXQncyBub3QgdHJ1
ZSBmb3INCj4gPiBIeXBlci1WIG9uIEFSTTY0LiAgeDg2L3g2NCBoYXMgdGhlICdtYWNoaW5lX29w
cycgZGF0YSBzdHJ1Y3R1cmUNCj4gPiB3aXRoIHRoZSBhYmlsaXR5IHRvIHByb3ZpZGUgYSBjdXN0
b20gY3Jhc2hfc2h1dGRvd24oKSBmdW5jdGlvbiwgd2hpY2gNCj4gPiBIeXBlci1WIGRvZXMgaW4g
dGhlIGZvcm0gb2YgaHZfbWFjaGluZV9jcmFzaF9zaHV0ZG93bigpLiAgQnV0IEFSTTY0DQo+ID4g
aGFzIG5vIG1lY2hhbmlzbSB0byBwcm92aWRlIHN1Y2ggYSBjdXN0b20gZnVuY3Rpb24gdGhhdCB3
aWxsIGV2ZW50dWFsbHkNCj4gPiBkbyB0aGUgbmVlZGVkIHZtYnVzX2luaXRpYXRlX3VubG9hZCgp
IGJlZm9yZSBydW5uaW5nIGtkdW1wLg0KPiA+DQo+ID4gSSdtIG5vdCBpbW1lZGlhdGVseSBzdXJl
IHdoYXQgdGhlIGJlc3Qgc29sdXRpb24gaXMgZm9yIEFSTTY0LiAgQXQgdGhpcw0KPiA+IHBvaW50
LCBJJ20ganVzdCBwb2ludGluZyBvdXQgdGhlIHByb2JsZW0gYW5kIHdpbGwgdGhpbmsgYWJvdXQg
dGhlIHRyYWRlb2Zmcw0KPiA+IGZvciB2YXJpb3VzIHBvc3NpYmxlIHNvbHV0aW9ucy4gIFBsZWFz
ZSBkbyB0aGUgc2FtZSB5b3Vyc2VsZi4gOi0pDQo+ID4NCj4gDQo+IE9oLCB5b3UncmUgdG90YWxs
eSByaWdodCEgSSBqdXN0IGFzc3VtZWQgQVJNNjQgd291bGQgdGhlIHRoZSBzYW1lLCBteQ0KPiBi
YWQuIEp1c3QgdG8gcHJvcG9zZSBzb21lIGFsdGVybmF0aXZlcywgc28geW91L290aGVycyBjYW4g
YWxzbyBkaXNjdXNzDQo+IGhlcmUgYW5kIHdlIGNhbiByZWFjaCBhIGNvbnNlbnN1cyBhYm91dCB0
aGUgdHJhZGUtb2ZmczoNCj4gDQo+IChhKSBXZSBjb3VsZCBmb3JnZXQgYWJvdXQgdGhpcyBjaGFu
Z2UsIGFuZCBhbHdheXMgZG8gdGhlIGNsZWFuLXVwIGhlcmUsDQo+IG5vdCByZWx5aW5nIGluIG1h
Y2hpbmVfY3Jhc2hfc2h1dGRvd24oKS4NCj4gUHJvOiByZWFsbHkgc2ltcGxlLCBiZWhhdmVzIHRo
ZSBzYW1lIGFzIGl0IGlzIGRvaW5nIGN1cnJlbnRseS4NCj4gQ29uOiBsZXNzIGVsZWdhbnQvY29u
Y2lzZSwgZG9lc24ndCBhbGxvdyBhcm02NCBjdXN0b21pemF0aW9uLg0KPiANCj4gKGIpIEFkZCBh
IHdheSB0byBhbGxvdyBBUk02NCBjdXN0b21pemF0aW9uIG9mIHNodXRkb3duIGNyYXNoIGhhbmRs
ZXIuDQo+IFBybzogbWF0Y2hlcyB4ODYsIG1vcmUgY3VzdG9taXphYmxlLCBpbXByb3ZlcyBhcm02
NCBhcmNoIGNvZGUuDQo+IENvbjogQSB0YWQgbW9yZSBjb21wbGV4Lg0KPiANCj4gQWxzbywgYSBx
dWVzdGlvbiB0aGF0IGNhbWUtdXA6IGlmIEFSTTY0IGhhcyBubyB3YXkgb2YgY2FsbGluZyBzcGVj
aWFsDQo+IGNyYXNoIHNodXRkb3duIGhhbmRsZXIsIGhvdyBjYW4geW91IGV4ZWN1dGUgaHZfc3Rp
bWVyX2NsZWFudXAoKSBhbmQNCj4gaHZfc3luaWNfZGlzYWJsZV9yZWdzKCkgdGhlcmU/IE9yIGFy
ZSB0aGV5IG5vdCByZXF1aXJlZCBpbiBBUk02ND8NCj4gDQoNCk15IHN1Z2dlc3Rpb24gaXMgdG8g
ZG8gKGEpIGZvciBub3cuICBJIHN1c3BlY3QgKGIpIGNvdWxkIGJlIGEgbW9yZQ0KZXh0ZW5kZWQg
ZGlzY3Vzc2lvbiBhbmQgSSB3b3VsZG4ndCB3YW50IHlvdXIgcGF0Y2ggc2V0IHRvIGdldCBoZWxk
DQp1cCBvbiB0aGF0IGRpc2N1c3Npb24uICBJIGRvbid0IGtub3cgd2hhdCB0aGUgc2Vuc2Ugb2Yg
dGhlIEFSTTY0DQptYWludGFpbmVycyB3b3VsZCBiZSB0b3dhcmQgKGIpLiAgVGhleSBoYXZlIHRy
aWVkIHRvIGF2b2lkIHBpY2tpbmcNCnVwIGNvZGUgd2FydHMgbGlrZSBoYXZlIGFjY3VtdWxhdGVk
IG9uIHRoZSB4ODYveDY0IHNpZGUgb3ZlciB0aGUNCnllYXJzLCBhbmQgSSBhZ3JlZSB3aXRoIHRo
YXQgZWZmb3J0LiAgQnV0IGFzIG1vcmUgYW5kIHZhcmllZA0KaHlwZXJ2aXNvcnMgYmVjb21lIGF2
YWlsYWJsZSBmb3IgQVJNNjQsIGl0IHNlZW1zIGxpa2UgYSBmcmFtZXdvcmsNCmZvciBzdXBwb3J0
aW5nIGEgY3VzdG9tIHNodXRkb3duIGhhbmRsZXIgbWF5IGJlY29tZSBuZWNlc3NhcnkuDQpCdXQg
dGhhdCBjb3VsZCB0YWtlIGEgbGl0dGxlIHRpbWUuDQoNCllvdSBhcmUgcmlnaHQgYWJvdXQgaHZf
c3RpbWVyX2NsZWFudXAoKSBhbmQgaHZfc3luaWNfZGlzYWJsZV9yZWdzKCkuDQpXZSBhcmUgbm90
IHJ1bm5pbmcgdGhlc2Ugd2hlbiBhIHBhbmljIG9jY3VycyBvbiBBUk02NCwgYW5kIHdlDQpzaG91
bGQgYmUsIHRob3VnaCB0aGUgcmlzayBpcyBzbWFsbC4gICBXZSB3aWxsIHB1cnN1ZSAoYikgYW5k
IGFkZA0KdGhlc2UgYWRkaXRpb25hbCBjbGVhbnVwcyBhcyBwYXJ0IG9mIHRoYXQuICBCdXQgYWdh
aW4sIEkgd291bGQgc3VnZ2VzdA0KZG9pbmcgKGEpIGZvciBub3csIGFuZCB3ZSB3aWxsIHN3aXRj
aCBiYWNrIHRvIHlvdXIgc29sdXRpb24gb25jZQ0KKGIpIGlzIGluIHBsYWNlLg0KDQo+IA0KPiA+
Pg0KPiA+PiAoYykgVGhlcmUgaXMgYWxzbyBhIEh5cGVyLVYgZnJhbWVidWZmZXIgcGFuaWMgbm90
aWZpZXIsIHdoaWNoIHJlbGllcyBpbg0KPiA+PiBkb2luZyBhIHZtYnVzIG9wZXJhdGlvbiB0aGF0
IGRlbWFuZHMgYSB2YWxpZCBjb25uZWN0aW9uLiBTbywgd2UgbXVzdA0KPiA+PiBvcmRlciB0aGlz
IG5vdGlmaWVyIHdpdGggdGhlIHBhbmljIG5vdGlmaWVyIGZyb20gdm1idXNfZHJ2LmMsIGluIG9y
ZGVyIHRvDQo+ID4+IGd1YXJhbnRlZSB0aGF0IHRoZSBmcmFtZWJ1ZmZlciBjb2RlIGV4ZWN1dGVz
IGJlZm9yZSB0aGUgdm1idXMgY29ubmVjdGlvbg0KPiA+PiBpcyB1bmxvYWRlZC4NCj4gPg0KPiA+
IFBhdGNoIDIxIG9mIHRoaXMgc2V0IHB1dHMgdGhlIEh5cGVyLVYgRkIgcGFuaWMgbm90aWZpZXIg
b24gdGhlIHByZV9yZWJvb3QNCj4gPiBub3RpZmllciBsaXN0LCB3aGljaCBtZWFucyBpdCB3b24n
dCBleGVjdXRlIGJlZm9yZSB0aGUgVk1idXMgY29ubmVjdGlvbg0KPiA+IHVubG9hZCBpbiB0aGUg
Y2FzZSBvZiBrZHVtcC4gICBUaGlzIG5vdGlmaWVyIGlzIG1ha2luZyBzdXJlIHRoYXQgSHlwZXIt
Vg0KPiA+IGlzIG5vdGlmaWVkIGFib3V0IHRoZSBsYXN0IHVwZGF0ZXMgbWFkZSB0byB0aGUgZnJh
bWUgYnVmZmVyIGJlZm9yZSB0aGUNCj4gPiBwYW5pYywgc28gbWF5YmUgaXQgbmVlZHMgdG8gYmUg
cHV0IG9uIHRoZSBoeXBlcnZpc29yIG5vdGlmaWVyIGxpc3QuICBJdA0KPiA+IHNlbmRzIGEgbWVz
c2FnZSB0byBIeXBlci1WIG92ZXIgaXRzIGV4aXN0aW5nIFZNYnVzIGNoYW5uZWwsIGJ1dCBpdA0K
PiA+IGRvZXMgbm90IHdhaXQgZm9yIGEgcmVwbHkuICBJdCBkb2VzLCBob3dldmVyLCBvYnRhaW4g
YSBzcGluIGxvY2sgb24gdGhlDQo+ID4gcmluZyBidWZmZXIgdXNlZCB0byBjb21tdW5pY2F0ZSB3
aXRoIEh5cGVyLVYuICAgVW5sZXNzIHNvbWVvbmUgaGFzDQo+ID4gYSBiZXR0ZXIgc3VnZ2VzdGlv
biwgSSdtIGluY2xpbmVkIHRvIHRha2UgdGhlIHJpc2sgb2YgYmxvY2tpbmcgb24gdGhhdA0KPiA+
IHNwaW4gbG9jay4NCj4gDQo+IFRoZSBsb2dpYyBiZWhpbmQgdGhhdCB3YXM6IHdoZW4ga2R1bXAg
aXMgc2V0LCB3ZSdkIHNraXAgdGhlIHZtYnVzDQo+IGRpc2Nvbm5lY3Qgb24gbm90aWZpZXJzLCBk
ZWZlcnJpbmcgdGhhdCB0byBjcmFzaF9zaHV0ZG93bigpLCBsb2dpYyB0aGlzDQo+IG9uZSByZWZ1
dGVkIGluIHRoZSBhYm92ZSBkaXNjdXNzaW9uIG9uIEFSTTY0IChvbmUgbW9yZSBQcm8gYXJndW1l
bnQgdG8NCj4gdGhlIGlkZWEgb2YgcmVmYWN0b3JpbmcgYWFyY2g2NCBjb2RlIHRvIGFsbG93IGEg
Y3VzdG9tIGNyYXNoIHNodXRkb3duDQo+IGhhbmRsZXIgaGVoKS4gQnV0IHlvdSdyZSByaWdodCwg
Zm9yIHRoZSBkZWZhdWx0IGxldmVsIDIsIHdlIHNraXAgdGhlDQo+IHByZV9yZWJvb3Qgbm90aWZp
ZXJzIG9uIGtkdW1wLCBlZmZlY3RpdmVseSBza2lwcGluZyB0aGlzIG5vdGlmaWVyLg0KPiANCj4g
U29tZSBpZGVhcyBvZiB3aGF0IHdlIGNhbiBkbyBoZXJlOg0KPiANCj4gSSkgd2UgY291bGQgY2hh
bmdlIHRoZSBmcmFtZWJ1ZmZlciBub3RpZmllciB0byByZWx5IG9uIHRyeWxvY2tzLCBpbnN0ZWFk
DQo+IG9mIHJpc2tpbmcgYSBsb2NrdXAgc2NlbmFyaW8sIGFuZCB3aXRoIHRoYXQsIHdlIGNhbiBl
eGVjdXRlIGl0IGJlZm9yZQ0KPiB0aGUgdm1idXMgZGlzY29ubmVjdCBpbiB0aGUgaHlwZXJ2aXNv
ciBsaXN0Ow0KDQpJIHRoaW5rIHdlIGhhdmUgdG8gZG8gdGhpcyBhcHByb2FjaCBmb3Igbm93Lg0K
DQo+IA0KPiBJSSkgd2UgaWdub3JlIHRoZSBoeXBlcnZpc29yIG5vdGlmaWVyIGluIGNhc2Ugb2Yg
a2R1bXAgX2J5IGRlZmF1bHRfLCBhbmQNCj4gaWYgdGhlIHVzZXJzIGRvbid0IHdhbnQgdGhhdCwg
dGhleSBjYW4gYWx3YXlzIHNldCB0aGUgcGFuaWMgbm90aWZpZXINCj4gbGV2ZWwgdG8gNCBhbmQg
cnVuIGFsbCBub3RpZmllcnMgcHJpb3IgdG8ga2R1bXA7IHdvdWxkIHRoYXQgYmUgdGVycmlibGUN
Cj4geW91IHRoaW5rPyBLZHVtcCB1c2VycyBtaWdodCBkb24ndCBjYXJlIGFib3V0IHRoZSBmcmFt
ZWJ1ZmZlci4uLg0KPiANCj4gSUlJKSB3ZSBnbyB3aXRoIGFwcHJvYWNoIChiKSBhYm92ZSBhbmQg
cmVmYWN0b3IgYXJtNjQgY29kZSB0byBhbGxvdyB0aGUNCj4gY3VzdG9tIGNyYXNoIGhhbmRsZXIg
b24ga2R1bXAgdGltZSwgdGhlbiBbd2l0aCBwb2ludCAoSSkgYWJvdmVdIHRoZQ0KPiBsb2dpYyBw
cm9wb3NlZCBpbiB0aGlzIHNlcmllcyBpcyBzdGlsbCB2YWxpZCAtIHNlZW1zIG1vcmUgYW5kIG1v
cmUgdGhlDQo+IG1vc3QgY29ycmVjdC9jb21wbGV0ZSBzb2x1dGlvbi4NCg0KQnV0IGV2ZW4gd2hl
bi9pZiB3ZSBnZXQgYXBwcm9hY2ggKGIpIGltcGxlbWVudGVkLCBoYXZpbmcgdGhlDQpmcmFtZWJ1
ZmZlciBub3RpZmllciBvbiB0aGUgcHJlX3JlYm9vdCBsaXN0IGlzIHN0aWxsIHRvbyBsYXRlIHdp
dGggdGhlDQpkZWZhdWx0IG9mIHBhbmljX25vdGlmaWVyX2xldmVsID0gMi4gIFRoZSBrZHVtcCBw
YXRoIHdpbGwgcmVzZXQgdGhlDQpWTWJ1cyBjb25uZWN0aW9uIGFuZCB0aGVuIHRoZSBmcmFtZWJ1
ZmZlciBub3RpZmllciB3b24ndCB3b3JrLg0KDQo+IA0KPiBJbiBhbnkgY2FzZSwgSSBndWVzcyB3
ZSBzaG91bGQgYXZvaWQgd29ya2Fyb3VuZHMgaWYgcG9zc2libGUgYW5kIGRvIHRoZQ0KPiB0aGlu
Z3MgdGhlIGJlc3Qgd2F5IHdlIGNhbiwgdG8gZW5jb21wYXNzIGFsbCAob3IgYWxtb3N0IGFsbCkg
dGhlDQo+IHBvc3NpYmxlIHNjZW5hcmlvcyBhbmQgZG9uJ3QgZm9yY2UgdGhpbmdzIG9uIHVzZXJz
IChsaWtlIGVuZm9yY2luZyBwYW5pYw0KPiBub3RpZmllciBsZXZlbCA0IGZvciBIeXBlci1WIG9y
IHNvbWV0aGluZyBsaWtlIHRoaXMuLi4pDQo+IA0KPiBNb3JlIGZlZWRiYWNrIGZyb20geW91IC8g
SHlwZXItViBmb2xrcyBpcyBwcmV0dHkgd2VsY29tZSBhYm91dCB0aGlzLg0KPiANCj4gDQo+ID4N
Cj4gPj4gWy4uLl0NCj4gPiBUaGUgIkZpeGVzOiIgdGFncyBpbXBseSB0aGF0IHRoZXNlIGNoYW5n
ZXMgc2hvdWxkIGJlIGJhY2twb3J0ZWQgdG8gb2xkZXINCj4gPiBsb25ndGVybSBrZXJuZWwgdmVy
c2lvbnMsIHdoaWNoIEkgZG9uJ3QgdGhpbmsgaXMgdGhlIGNhc2UuICBUaGVyZSBpcyBhDQo+ID4g
ZGVwZW5kZW5jeSBvbiBQYXRjaCAxNCBvZiB5b3VyIHNlcmllcyB3aGVyZSBQQU5JQ19OT1RJRklF
UiBpcw0KPiA+IGludHJvZHVjZWQuDQo+ID4NCj4gDQo+IE9oLCB0aGlzIHdhcyBtb3JlIHJlbGF0
ZWQgd2l0aCBhcmNoZW9sb2d5IG9mIHRoZSBrZXJuZWwuIFdoZW4gSSdtDQo+IGludmVzdGlnYXRp
bmcgc3R1ZmYsIEkgcmVhbGx5IHdhbnQgdG8gdW5kZXJzdGFuZCB3aHkgY29kZSB3YXMgYWRkZWQg
YW5kDQo+IHRoYXQgdXN1YWxseSByZXF1aXJlIHNvbWUgdGltZSBnaXQgYmxhbWluZyBzdHVmZiwg
c28gaGF2aW5nIHRoYXQgcHJvbnRvDQo+IGluIHRoZSBjb21taXQgbWVzc2FnZSBpcyBhIGJvbnVz
Lg0KPiANCj4gQnV0IG9mIGNvdXJzZSB3ZSBkb24ndCBuZWVkIHRvIHVzZSB0aGUgRml4ZXMgdGFn
IGZvciB0aGF0LCBlYXN5IHRvIG9ubHkNCj4gbWVudGlvbiBpdCBpbiB0aGUgdGV4dC4gQSBzZWNv
bmRhcnkgYmVuZWZpdCBieSB1c2luZyB0aGlzIHRhZyBpcyB0bw0KPiBpbmRpY2F0ZSB0aGlzIGlz
IGEgX3JlYWwgZml4XyB0byBzb21lIGNvZGUsIGFuZCBub3QgYW4gaW1wcm92ZW1lbnQsIGJ1dA0K
PiBhcyB5b3Ugc2F5LCBJIGFncmVlIHdlIHNob3VsZG4ndCBiYWNrcG9ydCBpdCB0byBwcmV2aW91
cyByZWxlYXNlcyBoYXZpbmcNCj4gb3Igbm90IHRoZSBGaXhlcyB0YWcgKEFGQUlLIGl0J3Mgbm90
IG1hbmRhdG9yeSB0byBiYWNrcG9ydCBzdHVmZiB3aXRoDQo+IEZpeGVzIHRhZykuDQo+IA0KPiAN
Cj4gPj4gWy4uLl0NCj4gPj4gKyAqIGludHJpbmNhdGVkIGlzIHRoZSByZWxhdGlvbiBvZiB0aGlz
IG5vdGlmaWVyIHdpdGggSHlwZXItViBmcmFtZWJ1ZmZlcg0KPiA+DQo+ID4gcy9pbnRyaW5jYXRl
ZC9pbnRyaWNhdGUvDQo+IA0KPiBUaGFua3MsIGZpeGVkIGluIFYyIQ0KPiANCj4gDQo+ID4NCj4g
Pj4gWy4uLl0NCj4gPj4gK3N0YXRpYyBpbnQgaHZfcGFuaWNfdm1idXNfdW5sb2FkKHN0cnVjdCBu
b3RpZmllcl9ibG9jayAqbmIsIHVuc2lnbmVkIGxvbmcgdmFsLA0KPiA+PiAgCQkJICAgICAgdm9p
ZCAqYXJncykNCj4gPj4gK3sNCj4gPj4gKwlpZiAoIWtleGVjX2NyYXNoX2xvYWRlZCgpKQ0KPiA+
DQo+ID4gSSdtIG5vdCBjbGVhciBvbiB0aGUgcHVycG9zZSBvZiB0aGlzIGNvbmRpdGlvbi4gIEkg
dGhpbmsgaXQgbWVhbnMNCj4gPiB3ZSB3aWxsIHNraXAgdGhlIHZtYnVzX2luaXRpYXRlX3VubG9h
ZCgpIGlmIGEgcGFuaWMgb2NjdXJzIGluIHRoZQ0KPiA+IGtkdW1wIGtlcm5lbC4gIElzIHRoZXJl
IGEgcmVhc29uIGEgcGFuaWMgaW4gdGhlIGtkdW1wIGtlcm5lbA0KPiA+IHNob3VsZCBiZSB0cmVh
dGVkIGRpZmZlcmVudGx5PyAgT3IgYW0gSSBtaXN1bmRlcnN0YW5kaW5nPw0KPiANCj4gVGhpcyBp
cyByZWFsbHkgcmVsYXRlZCB3aXRoIHRoZSBwb2ludCBkaXNjdXNzZWQgaW4gdGhlIHRvcCBvZiB0
aGlzDQo+IHJlc3BvbnNlIC0gSSBhc3N1bWVkIGJvdGggQVJNNjQveDg2XzY0IHdvdWxkIGJlaGF2
ZSB0aGUgc2FtZSBhbmQNCj4gZGlzY29ubmVjdCB0aGUgdm1idXMgdGhyb3VnaCB0aGUgY3VzdG9t
IGNyYXNoIGhhbmRsZXIgd2hlbiBrZHVtcCBpcyBzZXQsDQo+IHNvIHdvcnRoIHNraXBwaW5nIGl0
IGhlcmUgaW4gdGhlIG5vdGlmaWVyLiBCdXQgdGhhdCdzIG5vdCB0cnVlIGZvciBBUk02NA0KPiBh
cyB5b3UgcG9pbnRlZCwgc28gdGhpcyBndWFyZCBhZ2FpbnN0IGtleGVjIGlzIHJlYWxseSBwYXJ0
IG9mIHRoZQ0KPiBkZWNpc2lvbi9kaXNjdXNzaW9uIG9uIHdoYXQgdG8gZG8gd2l0aCBBUk02NCBo
ZWgNCg0KQnV0IG5vdGUgdGhhdCB2bWJ1c19pbml0aWF0ZV91bmxvYWQoKSBhbHJlYWR5IGhhcyBh
IGd1YXJkIGJ1aWx0LWluLg0KSWYgdGhlIGludGVudCBvZiB0aGlzIHRlc3QgaXMganVzdCBhcyBh
IGd1YXJkIGFnYWluc3QgcnVubmluZyB0d2ljZSwNCnRoZW4gaXQgaXNuJ3QgbmVlZGVkLg0KDQo+
IA0KPiBDaGVlcnMhDQo=
