Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA0F515230
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 19:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377866AbiD2Reg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 13:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379764AbiD2Rea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 13:34:30 -0400
X-Greylist: delayed 3790 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 29 Apr 2022 10:31:08 PDT
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.56.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B84D14021;
        Fri, 29 Apr 2022 10:31:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTnYIoTyFDjM5JUklkUkeZSVHdB/KbpjWUKMrwxPKtMBCELnhwwVxh3SyOWp+1En+lBB80Pmi2MOFKxrdFIAO1tVkwmz31aHf3c0WXJgTJO4H8WZ8wWDi+ZLogiDuQYv43MvDvBMsiShc3M4W6FuR/wPAy1Edr9Ejm4EmMmHgoezg8BixUKBI7OUSVmU0/dlrFC57AU3xqY9yjnUIy1vXdv9nlj9XWZBE29iaC+cnW5L/0PZPRadrHbf3+g4UC7EMWCusYpZlk+0nFrTbZZbgil9754PaHuq87Xs5x2NPKguVl+xJisWMMhTPBDhnZUpXDwN8SYDRRPJVsZL70yHUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lb7HJaoovhC6aIWP9rKJ4VgGH06NMpJYC4i1j5JxsI=;
 b=cllHTkoF7/QGmRKVAfZLbB2EINE8+FyPVK/DhZU1IvHmvPGKiv37XAYsy2ztQQZBV0S2wCJT80Qzf+ODT8pn9hxUAriFcnDhg0MQtoQDmk99sbR4eoHjIBnESHA8RFpDL0QZ9TQIFYrTQ1sa0LxWuC2wFr9KEoOKWkswbeTWdtT8qAKyinjpnI2y79/6J5xxB374yWzqyHNG2OYd8Xse8Q49miwVkxuAjSdxGMc/d6kQcSSLV+ETreRF9TXQzVouszl+GMZqY9q76aTtD+gRUELbgbQQXH756uY5Jmx8Y7/63+0pYcIqxk4hn9ecg4cqgoQJyCOfZkljvQwjcZgnhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lb7HJaoovhC6aIWP9rKJ4VgGH06NMpJYC4i1j5JxsI=;
 b=QSQxqWpJqa0hyyFA2XDVFvIF6LUCH46zWRApVCGDtXYWI6H38+ofNY2enqE+SH/qIy3nfoGgoNGiAJVzByKlaoklJK7MeqAmDXe2OQgK7UNp04ELgeYfkgc7YvIny43HOtGavqk6L/OU2tQ5UUDZXTksZysdcEpxlosr405yQD8=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by DM5PR21MB0761.namprd21.prod.outlook.com (2603:10b6:3:a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.6; Fri, 29 Apr
 2022 17:30:45 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%6]) with mapi id 15.20.5227.006; Fri, 29 Apr 2022
 17:30:45 +0000
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
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Doug Berger <opendmb@gmail.com>,
        Evan Green <evgreen@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Julius Werner <jwerner@chromium.org>,
        Justin Chen <justinpopo6@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Scott Branden <scott.branden@broadcom.com>,
        Sebastian Reichel <sre@kernel.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: RE: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Thread-Topic: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Thread-Index: AQHYWonjjKMtrubrvUiw63ryI2yC7q0HJOjg
Date:   Fri, 29 Apr 2022 17:30:44 +0000
Message-ID: <PH0PR21MB30256260CCF4CAB713BBB11ED7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com>
In-Reply-To: <20220427224924.592546-20-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ffbe4afc-a779-4ef6-ac4b-fe8bbe7e97a6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-29T17:17:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eeb8e09c-7f93-4457-468d-08da2a05fdd8
x-ms-traffictypediagnostic: DM5PR21MB0761:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB076153F3B23BA9EDA94AA480D7FC9@DM5PR21MB0761.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ODUHNdNoyMm3+AjwwTGZa1uU+b7TzZfWBoAD8U4KhH1PO+xsXH02vwPBpyB/mIWIIZLzexbTDM4Vu/gZXstTguCwFin3jx/rAWvym7fQtAAg7bf3LoRbUADVs29tsGDy7+TAF7XXuJ2XtQpxtKth+FDvvHqKkOMz6t9UN3qxlX6X2/8DIw+GSljUyUj0tBw+/yPNu/lWy8bf/Am8dAdq1sDNbEC96RfsPekPyfP+ABzhwQ7PYKa/WylVKbqc6qF9DBAiGkEhIue/W/buwkdT7hYfHatG+zYOokfeiF3mlfl6KUzf5D5VNniM5lrQaX04V1qe1DNhDfiM2zUJp+UaaATU3lWntWn8XhQuwQ43saBb+whCvgo88zwSOnEtmfyXyJ7jSHr1E4zfj918Eh9wqTjnj+ly+wc+lrYnrbxMrLnOqL7bIfdILybyElXp12gbfm2vduDRh4SqY47pT+etRXV897ZE09O7/kJq3qYvGYtzXFoW19u/PKLiR28Z4TH/0eiE3v99EQFM/nm9qKWOIJz0AQ2aN9R7RyGMJ2el+s3C9YrtAh+XKMmCa/DuIpJihY98t7SoGzymQzR/oWmks7/DWMg11/eTBUSMF7oGyj/sryAvEYyImB8qi3eqsEWUoi0UGVpgJYUtiNLHN8PgE27Kl/BKSUCkJOXB2SWOuZP/2y/mimDRuhjjLgpCS8XKOFW4CADcxyTlrPyV6BZvcWd8nLypxsa6tVzXjuIb6HQVUSBs7DXSfR7irbmoVbPr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(508600001)(8936002)(9686003)(86362001)(5660300002)(122000001)(66556008)(76116006)(66946007)(4326008)(64756008)(8676002)(66476007)(66446008)(52536014)(55016003)(7696005)(2906002)(83380400001)(33656002)(8990500004)(7366002)(6506007)(71200400001)(186003)(7336002)(7416002)(7406005)(110136005)(38100700002)(38070700005)(54906003)(82960400001)(82950400001)(316002)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TlM1hb7C2zMfewQaGJedC++RJRP9D1fk9jo5g85b/VbEJjlvhufD/+3GvsdT?=
 =?us-ascii?Q?2RVoig3NgPv+9kMAhzt2yayxBFL+XC6TKbfh6r5z8+a3Ialq4pqnl+61min4?=
 =?us-ascii?Q?AQUbYZF6RM2WxWAWaWbmf4pZvHkqxCNxh2tBKbbAZG7zTWlGRE0yrn46CpjQ?=
 =?us-ascii?Q?Kg+FF3RMjkh0xhKb7YhWVGFRR4cUFfDwAE8Y0u/ayL9EvN7YfHgvbTwnFibg?=
 =?us-ascii?Q?wxrs8ZKT9gyje95TfWsysjrlEo2AMhjijQYf+wk++uxUxKjFMFcFM0TK/o0U?=
 =?us-ascii?Q?SkFo0xaTlF5faRiiVtJr3loo9S/Ku6rNW972dcU4pAdU566LuvrnO7MFZjdh?=
 =?us-ascii?Q?AFmbPsT2BzLJiaocFxkmdlQu7LQAu7OqTCRt6l+PZ9/gSfZuPhUus2hHDtrB?=
 =?us-ascii?Q?SDM9omiIG+Hxx9v9sHNTsQnym8IgjtRHARJqPiuuOrhzGW6rnMAOXglrCflV?=
 =?us-ascii?Q?Rov5f0XftngP4p/15HVk/xZ3U6CF21Y8wkL46j9LuXmnR1XoUchKnTl+E2LX?=
 =?us-ascii?Q?HVGrWe5ghuEiAOI2CIdLYYiZOLMOSKHkPVS5tEsF0puhwsUw4JMbLD+YZac+?=
 =?us-ascii?Q?XngxLj2g0ToSfUytDuBtW/xckOvI92+dCx8pO+ZAYP+e0eVn9cwp1Kvm1xNb?=
 =?us-ascii?Q?rAV5CaVoCci7b8QWoR2QN+Fu5dk7/CqjmTz1tOeFdsuqD6uz1SRGrS1d03HL?=
 =?us-ascii?Q?xDH9ipJZ+o8EfvcxNjL+NjflstJUNBTDD179PIJ02lIR/lqudf7+UQyDID84?=
 =?us-ascii?Q?q6tjz0iN9UUKGwVqgivgZXrsYwAytqrnKmINVNW4wb3XLk5w9neXRmUH+j78?=
 =?us-ascii?Q?KsamX4Pm+/ES4p923iT/O1j8Dc0iz2HIDjQusOUqKqy+1Cmv74o7qNPXqarR?=
 =?us-ascii?Q?SV+zg4wh7LaN+6mQPM9GRAC/fCDGlfCRDE0pObSvJCER5gHColet4D4oXi/M?=
 =?us-ascii?Q?whLKv3In3ycb8NG9SfzBHT6UBBuTXzlk8Z1cOw5HxwbJpQLcoJRyOznkhaFh?=
 =?us-ascii?Q?puB+TPg2v7gG43STuXsZuBPdxeBcD8t22uNy09Tm5VdFwD19dW7BANqzNvjE?=
 =?us-ascii?Q?6ltEeCK6kZsWlNtZnhZXzDkWfGec7QKD5T4837WQofWzk4AFyNmw3P07gbzW?=
 =?us-ascii?Q?DPRwU0bZQmEfow5pS46fZjnBJLIMizPbjOrxqQF88Hjdw7YkIlxIIPy9nOq5?=
 =?us-ascii?Q?rkOk+PDUI9sQbFgNvnFlRVqa5M9e8Cy3bVoX1i0e+J8fFasucl92zOySG7x1?=
 =?us-ascii?Q?dB0URJnSLwBlrJmIq2kHvmFM17BCiSIY6KmZnlsYBBc1zFLorv7VM7LxtvfK?=
 =?us-ascii?Q?eWEn4xu8Zu2XCbhm1RGjyA5mb3yJm+3MMLIWqa+D7mjqfMW4n/WDwOBGp4aX?=
 =?us-ascii?Q?7QIVcVDS2FQO8HGQtL0ZKsEXbyBGRrNCLrnSGQeM3c6sITs7FuMznsa3uTQ1?=
 =?us-ascii?Q?RzaG53kxTddhkwnYFMCH33OZDDS2VRKVGp0nCTknijgA/sd/pqAgBqx5FXNZ?=
 =?us-ascii?Q?LATiyW6hMVS3IQCBsELFD/kPKZZBR2r77QSiuWPyw2p8Pov/AXvouaHqr3Ks?=
 =?us-ascii?Q?aS3oN5XL5IHgKsiBu9N05s7MHrTT+fYH1fgDf196dY2Y2fYMpnG/9O22tFVZ?=
 =?us-ascii?Q?lsqy47lRHWMZ83W8zC+zPLhsXx6hfG0s/4A7rNIm78PqkrB2VME1eEucYCy8?=
 =?us-ascii?Q?YLC3m+W9TrKfxD8jKOYF9JNku02hxJAdCmjBpA8ShRZwpe21dzNz+uH7NKFr?=
 =?us-ascii?Q?FMBdMIBAEVrPX2S6uKBKGZRc/W3b2C8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb8e09c-7f93-4457-468d-08da2a05fdd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 17:30:44.8209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w0NqD7w01G3MX0hLhA/dcwb32L6tMn458kJlZ8pEiHHtKKqoR4vHWxkneKizeI4TFabvPMLpsqtoLF7uJprzpME6TmOX5LZO5vkLMC+rFzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0761
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
> The goal of this new panic notifier is to allow its users to register
> callbacks to run very early in the panic path. This aims hypervisor/FW
> notification mechanisms as well as simple LED functions, and any other
> simple and safe mechanism that should run early in the panic path; more
> dangerous callbacks should execute later.
>=20
> For now, the patch is almost a no-op (although it changes a bit the
> ordering in which some panic notifiers are executed). In a subsequent
> patch, the panic path will be refactored, then the panic hypervisor
> notifiers will effectively run very early in the panic path.
>=20
> We also defer documenting it all properly in the subsequent refactor
> patch. While at it, we removed some useless header inclusions and
> fixed some notifiers return too (by using the standard NOTIFY_DONE).
>=20
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Brian Norris <computersforpeace@gmail.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Cc: David Gow <davidgow@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Doug Berger <opendmb@gmail.com>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Hari Bathini <hbathini@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Julius Werner <jwerner@chromium.org>
> Cc: Justin Chen <justinpopo6@gmail.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Markus Mayer <mmayer@broadcom.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Michael Kelley <mikelley@microsoft.com>
> Cc: Mihai Carabas <mihai.carabas@oracle.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Scott Branden <scott.branden@broadcom.com>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Wang ShaoBo <bobo.shaobowang@huawei.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: zhenwei pi <pizhenwei@bytedance.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>  arch/mips/sgi-ip22/ip22-reset.c          | 2 +-
>  arch/mips/sgi-ip32/ip32-reset.c          | 3 +--
>  arch/powerpc/kernel/setup-common.c       | 2 +-
>  arch/sparc/kernel/sstate.c               | 3 +--
>  drivers/firmware/google/gsmi.c           | 4 ++--
>  drivers/hv/vmbus_drv.c                   | 4 ++--
>  drivers/leds/trigger/ledtrig-activity.c  | 4 ++--
>  drivers/leds/trigger/ledtrig-heartbeat.c | 4 ++--
>  drivers/misc/bcm-vk/bcm_vk_dev.c         | 6 +++---
>  drivers/misc/pvpanic/pvpanic.c           | 4 ++--
>  drivers/power/reset/ltc2952-poweroff.c   | 4 ++--
>  drivers/s390/char/zcore.c                | 5 +++--
>  drivers/soc/bcm/brcmstb/pm/pm-arm.c      | 2 +-
>  include/linux/panic_notifier.h           | 1 +
>  kernel/panic.c                           | 4 ++++
>  15 files changed, 28 insertions(+), 24 deletions(-)

[ snip]

>=20
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index f37f12d48001..901b97034308 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -1614,7 +1614,7 @@ static int vmbus_bus_init(void)
>  			hv_kmsg_dump_register();
>=20
>  		register_die_notifier(&hyperv_die_report_block);
> -		atomic_notifier_chain_register(&panic_notifier_list,
> +		atomic_notifier_chain_register(&panic_hypervisor_list,
>  						&hyperv_panic_report_block);
>  	}
>=20
> @@ -2843,7 +2843,7 @@ static void __exit vmbus_exit(void)
>  	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
>  		kmsg_dump_unregister(&hv_kmsg_dumper);
>  		unregister_die_notifier(&hyperv_die_report_block);
> -		atomic_notifier_chain_unregister(&panic_notifier_list,
> +		atomic_notifier_chain_unregister(&panic_hypervisor_list,
>  						&hyperv_panic_report_block);
>  	}
>=20

Using the hypervisor_list here produces a bit of a mismatch.  In many cases
this notifier will do nothing, and will defer to the kmsg_dump() mechanism
to notify the hypervisor about the panic.   Running the kmsg_dump()
mechanism is linked to the info_list, so I'm thinking the Hyper-V panic rep=
ort
notifier should be on the info_list as well.  That way the reporting behavi=
or
is triggered at the same point in the panic path regardless of which
reporting mechanism is used.



