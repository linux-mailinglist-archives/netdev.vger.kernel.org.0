Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CBB580448
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiGYTKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiGYTKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:10:37 -0400
X-Greylist: delayed 905 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Jul 2022 12:10:36 PDT
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.56.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B8565B5;
        Mon, 25 Jul 2022 12:10:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jajFDOZSNj9pbUlxEAvF6km4vhQotpQK3wYd/vBzjSuGalXP5JtO5QNsxKIxGptj4Q+sISakD20TSAXnZ5u6eCwtyO2CQ3nKXl/EezKoQbev5WmoxFsxAwUV9ZYz1XTgeKC3OhX+MEL7lOtrx4kObL9ukmZCBKeOnJG41ziw9uAC3WxfA0ER3Edda5PF09f6J4z/tYnybEUxcX5hvnu55+42gbC9qdduB5ltxC+YDAyrM0PklUb+J2pCoFIgn2Ga2lPrCwH8QU8DkFpi1XQ2hfRVXWlCwWYH4StEapUcnSDfc2Jd7rUEcshz/CwXmA0IJkCWq1lbPFFvFeHBqiIETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3V9EprHVaFVfAHYbvVX/PjJRxfN1vl01/MwrXXaV1Y=;
 b=G57InTKXx/69i+eJd8bJnO1zGOq/892mBsuJpwm/ZxQALP4e6zlfVG0hkKsGwyrR7hcOIRnprh3OsPzE5LcaS4BqNaAxHn3NTtogJn3KXAB7+bb8352lqpPNzDSAI9meWas9XbnlEHBBSjLLNhw2nCCqJPOMSF40o7cIWxwq5PRee0FbCgATXDs0bphVOZWUB8S3nMMESm4Macboi2QNckpOkPIcK1q8WTCqkvN8fVqZxbuzoqgtO2wlhpMp5xa+q3MFPGTbpY8zDhsKuz2/VvdFEQgJLPzA/sVd0gf0DhuK3j/THG+PM/UGStgEb7aBF4mrTSyjcpG43PYSkbGxcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3V9EprHVaFVfAHYbvVX/PjJRxfN1vl01/MwrXXaV1Y=;
 b=YCuL6/gfsyvYIVH5s+oV03SaNr2Npgl8fn27yGPI6rCNMUlIUk7p4HXBZ1r2HiMCYTAeO8flCOBQCKkjghghbdBEW6tIHXFRqC7VzYdYXHt+eMHt/K4Ion2nOFQJP6mLPCzNpYxPoyVzQID/R1ycSVy5l4O456TvmWqfP7Fi3VM=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by BY5PR21MB1506.namprd21.prod.outlook.com (2603:10b6:a03:23d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.2; Mon, 25 Jul
 2022 18:55:20 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ddda:3701:dfb8:6743]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ddda:3701:dfb8:6743%4]) with mapi id 15.20.5504.001; Mon, 25 Jul 2022
 18:55:20 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Subject: RE: [PATCH v2 12/13] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Thread-Topic: [PATCH v2 12/13] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Thread-Index: AQHYm6noKMm0jEh4LkCj+vXutuSDiK2PeF0w
Date:   Mon, 25 Jul 2022 18:55:20 +0000
Message-ID: <PH0PR21MB3025B2542FE6212AA95D4783D7959@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-13-gpiccoli@igalia.com>
In-Reply-To: <20220719195325.402745-13-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a3b86401-864c-4326-854b-4c24128acd62;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-25T18:53:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5963b47f-de35-4067-1e51-08da6e6f3923
x-ms-traffictypediagnostic: BY5PR21MB1506:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R+Q23QRTVuC0nvvMx/FIXKcsEW923wEY1jGyDBczmBQ54aBupu2Ysp/3kXhXfOb23CBOFpu9rU1hr5+qHMMNJLUT1fnTqlrurJESPGHxfSl/1QLHW4prherFvNdJSHYSWH92sGmnvz4fZV9oOYALBStWBOJLhbVeubVv2/+rRzfumbo51a6QY6AcJ8uctxjH95qauVe9BOql9pbNkL184/WF6B5S3yhWnMTlvAW+FBpJ1T87G8zQVCd2urudXPEly3j7kgkucCaV3NRIadgJYcZPg0fhefnodeIrcDIuuzaX22LWTnSSbqGFUabUSA723SYdMythRkANtjhOEz4On8fGrgiLc1gyuosFDs4A+WT/aDs6qgTVuVCy2+dwe0LnJ2VsPxnwWIwEdhLqOg5PN9jNWEFQoj5bG+6glb61zUX625HPq1LsD97EwU2GFdoJTHy6X3hdy22OjhmlxDTkSK4kdWyVSqbja/DIziHsSmCD6ETbasKPQKT7DX2583dqexXDJe/5y+MAQxKOHM10MM/e5RbcDh5lP6M429sz/1DHlHmb/fdjkWRYq8X0WubTUIKdfuCyZOSXlbFC6KJ2qrRZtvZt60m0QPeDHwyEBWTf0LcH9zF8v+C/cOoh78CWEHynKjn/YhMCuKdBYvXwZXbdIHqHgABBGDzXbDQ6yPzoFPRvpKX7JRL/YMc+UtZYaNIEM3A2JR3+3kIFJKepClkq8yPZ8qlW4rl2PkSS0jrJT5nIqe6oOEFD4h3oCxZIh/hYl1ggvegU/xw7kGe2AdDnkr/ABokKAbx0aPkQDDT8U7mTxGITJMo5FCQ8yNdpulcd1qMOMafVOATUIZ7toPuevHCaA0e7a5+38GIq6t3o0JoxlXmAy/Ku4s2WbYN0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199009)(7416002)(64756008)(7406005)(5660300002)(66556008)(33656002)(52536014)(8676002)(4326008)(82960400001)(9686003)(966005)(26005)(7696005)(8936002)(110136005)(122000001)(55016003)(2906002)(66446008)(76116006)(6506007)(86362001)(316002)(66946007)(66476007)(82950400001)(8990500004)(54906003)(71200400001)(10290500003)(478600001)(41300700001)(38070700005)(186003)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a6frRVs6DITru84z+K4iCwTU/qpxkzaf2YEO4gK5SIWEpCIzY3vTjsu/7PtU?=
 =?us-ascii?Q?RVjDmpA5rJonhr6fgiMUm5uL88rCUiiEVOypPtM4SB2a3oQYFNv6eruJXktu?=
 =?us-ascii?Q?Q/jFKvIoGmZPwZ/pZDu6C/uD9gCwfvT5ZYGraYD9eSqmtQdh5FuEIumEmmjy?=
 =?us-ascii?Q?OHqpZ6amJMsFeKLZuogOrHJEext/j9l8eX8oZsSUOIDqu1WOOJYnd5njEL+L?=
 =?us-ascii?Q?ZrDLbI5Ncnr45dZWZ0fTyelJJD6UEZCdeliEiou486crYT2rTa9mTLg7hJ41?=
 =?us-ascii?Q?+3HHacSoMbrFM9aB8fmgg6bBYGlJDQhMiwjBWGXNohB1oyFZzTH1Lq95f60G?=
 =?us-ascii?Q?Hko+KvWV7wC4QoguBwg06QybhooIwWfP7lV00s3XELIwK47ugv1MfVql9tao?=
 =?us-ascii?Q?OOTWUWMyM8GrsjDp6F7nhu+4G1spEwBxGHUekMUrP8KPLoz0X/HFsSK7zNup?=
 =?us-ascii?Q?dzxCk6W07BiShhkggjdl+nT6wzUjK7iDXvkD615FQYCoAc9vh8QXAttnMcVE?=
 =?us-ascii?Q?8EUT0dOGsTeZFbYY/58zwQ8wUdJcp5P4LQN2Quz6BqJp+Nn9mxCnm7tyLtXX?=
 =?us-ascii?Q?kT3GkYGiF3EejssJhFthWn7n3kAS/vpN99/PiUv3sU05IX82UDNXUwTVwCTN?=
 =?us-ascii?Q?I2x+odz4nkKWKqFPqyd5LldCVsO8+Zzy2RrnLlFnF1PKVOwC3PZAZ1bCp0dG?=
 =?us-ascii?Q?sQrmP+y3sSNOYfyfpGhRV2bEO5HPBGTRY89p74sKXjk/azQLCDbkDE1PUfSq?=
 =?us-ascii?Q?yJ0bQotYPbTidBgkZ3Jr55CvuHLjMyACvLnB5lc/ohMBgzXShuLsixFf6szD?=
 =?us-ascii?Q?kOa0gDlZXYqsqveJS9IDptZrzcyD4AWleQb2jJ15OJFW6cABdOqD9W6JdFVM?=
 =?us-ascii?Q?RjOTQgidvvqcd3Oa9ToI0fh615iDJgZz6pyDjshsslrFC93wHwBb8zAcm0CW?=
 =?us-ascii?Q?GYeMqDUfdHlVM7mNOYzCitCEj1GgDHa2TGo9To9DmvtizPSXcQuc9eRgwZL+?=
 =?us-ascii?Q?NN6s6m8CVQWPJfiRsiMRT9CcuAfiCg5VoAAsvl0eHxfR6wMA7i35pe/mJXst?=
 =?us-ascii?Q?KGDse3jmEatEDFE8FRj7IZdLKaOJfksQjGbV1iDDC/tqpKJhUTCXk4EMsq97?=
 =?us-ascii?Q?rL8IZDf9ymsofd7+i7uoJL5/IPAlI+B1EbOjYEy4Qq80GcYLvDh6fyxjpXpf?=
 =?us-ascii?Q?2z4wIBlTQSiDxzaUBgQtpjemafgSz1mSfyxVbZVMVnhIDHmOqwuc+CYa8PJ+?=
 =?us-ascii?Q?uBzdxPRuK1hEnNN7VOraKCuf0BZ/bERy9tdy3euOjAWAF544ESFNcyVQ7mf2?=
 =?us-ascii?Q?PBkzJttGhLG36G2KyPGAkKmb5TbTKWZAEcY8kYTD4yH/rUP7WNPveah1bemn?=
 =?us-ascii?Q?QpFccrYYdv9Aqq42K3ALZb78+nlyC9SGLEUqEi8+kK6npwb7fDX5MKeSA6a6?=
 =?us-ascii?Q?7lk7qrlePLSdEUTI4OWjMZcpFldP6KUxVhwquSKuypK2lDQPJ4XZRu13rBYW?=
 =?us-ascii?Q?cNXEj4izs13gtuZv8/GOn+eLAhSrsE9fZjjjrdIIyiS7bnf8LOSz0PslvHqQ?=
 =?us-ascii?Q?Y2Tp2RZXE9nOTQMemzHC1tXvy+t5IE4U2H16Nj3YpASUfwqToUuXYAPhiGc8?=
 =?us-ascii?Q?hA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5963b47f-de35-4067-1e51-08da6e6f3923
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 18:55:20.4749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ik2QAyYrx5RzPt4kkG/lM8ecfrnYXkh1BubyhHVkJDRevsDcuqK5rkyueedd3jm4vleoAYhik1ve+o+m7UWpxKigWnB65wX0M2CKOQR7LnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1506
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Tuesday, July 19, 20=
22 12:53 PM
>=20
> Currently Hyper-V guests are among the most relevant users of the panic
> infrastructure, like panic notifiers, kmsg dumpers, etc. The reasons rely
> both in cleaning-up procedures (closing hypervisor <-> guest connection,
> disabling some paravirtualized timer) as well as to data collection
> (sending panic information to the hypervisor) and framebuffer management.
>=20
> The thing is: some notifiers are related to others, ordering matters, som=
e
> functionalities are duplicated and there are lots of conditionals behind
> sending panic information to the hypervisor. As part of an effort to
> clean-up the panic notifiers mechanism and better document things, we
> hereby address some of the issues/complexities of Hyper-V panic handling
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
> (b) There is a Hyper-V framebuffer panic notifier, which relies in doing
> a vmbus operation that demands a valid connection. So, we must order this
> notifier with the panic notifier from vmbus_drv.c, to guarantee that the
> framebuffer code executes before the vmbus connection is unloaded.
>=20
> Also, this commit removes a useless header.
>=20
> Although there is code rework and re-ordering, we expect that this change
> has no functional regressions but instead optimize the path and increase
> panic reliability on Hyper-V. This was tested on Hyper-V with success.
>=20
> Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Michael Kelley <mikelley@microsoft.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>=20
> ---
>=20
>=20
> V2:
> - Unfortunately we cannot rely in the crash shutdown (custom) handler
> to perform the vmbus unload - arm64 architecture doesn't have this
> "feature" [0]. So, in V2 we kept the notifier behavior and always
> unload the vmbus connection, no matter what - thanks Michael for
> pointing that;
>=20
> - Removed the Fixes tags as per Michael suggestion;
>=20
> - As per Petr suggestion, we abandoned the idea of distinguish among
> notifiers using an id - so, in V2 we rely in the old and good address
> comparison for that. Thanks Petr for the enriching discussion!
>=20
> [0]
> https://lore.kernel.org/lkml/427a8277-49f0-4317-d6c3-4a15d7070e55@igalia.=
com/
>=20
>=20
>  drivers/hv/vmbus_drv.c          | 109 +++++++++++++++++++-------------
>  drivers/video/fbdev/hyperv_fb.c |   8 +++
>  2 files changed, 74 insertions(+), 43 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
