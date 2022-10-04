Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4785F4780
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 18:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJDQZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 12:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJDQZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 12:25:07 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021027.outbound.protection.outlook.com [52.101.52.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F71DEE7;
        Tue,  4 Oct 2022 09:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeU0xxM/5lrBVQ7Sg67477bnFqMSY619ftd4f63/yFL4rjjIzGSJ2UecAINkM+xyKMy5OfZHyY4a7tEsHym5RI7h/hnHMQ+/95kQO0LRHcYbVcVZAB5jNLNrR8p9Dkt3qX1zOXvtRazL0ZH4jsvVYJAQCCAe4AXJdN/yWm/eVSV74EB6uw4mAPwaERQn7vtYGYJf7T6xUudyu8MjTXjYAsR+xjB+NcsfTvgx7cO4wksak56wnGu9rffFlmXetF1kijYRJ+rvbqsN6O4lgHixLLjYtrU1+x5AJT5io92eUrf9x5Sj8JXQ03OqhIDuxFoNpdMSWbrvi6v74/R92DOz6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/b6Ha+MsTOARvvgjjvEkZtX3juzFkVFAYdJYiV7ph0=;
 b=Frtf0V6NzdqNRGLctYLj6E1AxQqDhg5X2kV+4tQFkusTM6GoEyxj0jrOX2zYl2QdPOgkwXB5rFEE3rnaYYAhamBbbXeT+CUUfsgZgKrODNZH8o7aF0k1EJvgj3+7ANAs9EhbwFBkauzJsee5tCyqrrcIsKN2XZPiKnx5GE9NmtFQdqPjGEVh1plpM+/EB0FGHK8DAn6zrx/wGoGikOgTfLve2XAkMt6H0FcV5ObfRDsBG/zmfe0EdxIrMouLhENotce+sn6kSX4s0lyzUtvsz2WDWnQnLOGkFVN11NTy/6GffCOa3drCnYqnMot+iVeAi+xgfIVT6iVzfJ4ScX89JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/b6Ha+MsTOARvvgjjvEkZtX3juzFkVFAYdJYiV7ph0=;
 b=fGae/ynV2c6ggAMeUbKzLU8yOu8bqe2cG8ElGe7rI5XknwDDw0rrFJdRPtvbpKQdopcctmTxsoRNrZRIYOZGyXhcUhFh5q3L3Wgbz040zhO2IfKo5xziyaubSww2oLrK0F2gkAgzZx0u4f22VmvPK8tb4f6faeFa/VHYCKyLTIM=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ1PR21MB3675.namprd21.prod.outlook.com (2603:10b6:a03:451::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.7; Tue, 4 Oct
 2022 16:24:54 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::930d:c800:6edc:ccbd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::930d:c800:6edc:ccbd%7]) with mapi id 15.20.5709.008; Tue, 4 Oct 2022
 16:24:54 +0000
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
        "xuqiang36@huawei.com" <xuqiang36@huawei.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: RE: [PATCH V3 10/11] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Thread-Topic: [PATCH V3 10/11] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Thread-Index: AQHYtBrLfXqegDojNkO+rF0jYYkCGq3+sWWQ
Date:   Tue, 4 Oct 2022 16:24:54 +0000
Message-ID: <BYAPR21MB16880251FC59B60542D2D996D75A9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-11-gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-11-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5698c1a4-50dd-41cd-b234-9c6646aa94cd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-04T16:17:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ1PR21MB3675:EE_
x-ms-office365-filtering-correlation-id: 4cb28ce7-f8a3-4146-8349-08daa624f86c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N54jixJGP56NTJtkSQFz004NGjEh7+q+iz6HZ6Ge4C9eOnUaNh5JWDjN/pYa3E6CBSk9o+CKwuBRjQl5QZBKR6b8DhytZJL2lInqZkYziJ0xdvP2YOiLJKYpnU6vyEtWoRB3asdNlgUoraLUJmRYc3HHB4dgaud6OL6Xepxq9fcbuob2dPqWohUlAyQqQ+rVqsh45LuSYiHxXdtafG7aVcO9vjkAsCHIX6ky0Wn1wFT5gWh859cAFl9UNdcTnZPfyFQCMbjXWwm61YT94rDnQfgWm7HD1bIRGbuqXio2nkKY+HmAH0eeM8/n51plDcBBpib3D/HJRbzkZ6aZ0adyXVIx+bmkjbGXR/x/n68A5pWkLB/mmEcJnoGfYK8Q4ZWi/cYZqjrzINQAhLdRk3dFYA1/wK/SqTdaWHrsPi15nnGIawRYDXSK+QPuvLLLZ/GnTc2PAu8oYCJIPCq/PMVWrhJVyDexFPoRk3p/V3gCbQdYnvsOAqPIMSENELqA0Vdv5GI6RN5MxMeplV1qYbq6r8YKYloUiudKRpa+541zWf10iZeqRUuH6iPVTYzlfAYbkbIIxUoIg//GK7DZyGt4kqMgcnuAPguilheSdj6I+8BiKD8SjouY/7kgmhQ9EBeCDZ3U49f/aX7QXpou8SRFK+Qfi3u+42jA3wMu+B+XREQhaC58g7TcwPOglZocei8pCba8fgzYXixnC2lV62oAtLy0p1ln3R+AvpHm63VbKNykoVSA2jmLppJxNsoaL/0KHYI/9/zfREm3Z4C+RkzLi5U65E4mUayQRXjRtQbP1urmP5dPSQdG7gLvt5hQm0xoE7JF8lbxwGTvWp7FRdQdGMvai3tUMkdTVsbEA+kIArk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199015)(478600001)(316002)(4326008)(66556008)(64756008)(8676002)(76116006)(66946007)(66446008)(66899015)(10290500003)(71200400001)(66476007)(966005)(54906003)(8936002)(52536014)(82960400001)(38100700002)(9686003)(26005)(7416002)(82950400001)(5660300002)(7696005)(110136005)(6506007)(41300700001)(8990500004)(7406005)(186003)(2906002)(33656002)(122000001)(38070700005)(86362001)(55016003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yYjr/pJ8c4a+SkvuOMT5paFv3RrLsoaNhVPebOyroC0WZePxjGysczu7o5U1?=
 =?us-ascii?Q?zHhbom4G5PdT31jX0bBRPG/Bkcpgq2laox8TzniDllh7nFIfM7FMbn7ndZR8?=
 =?us-ascii?Q?dDqLTSnhXjFxx9L3GWTtYv0ApMIr0vdvLXze7uPwowp2aN1MIzTJcOEAgRRD?=
 =?us-ascii?Q?vTU2j/2b3fQkAz/D5X65a9OA/Bl1hBCsy36MWAgfTIJXmFT/ko9wsgLxdWAt?=
 =?us-ascii?Q?qyKQAhyV46oIZUBDzR75yyGkhJQ4PJy1H+qlY9ubBjwJamimCGQupR09gB7e?=
 =?us-ascii?Q?bd0eqTRKMBG17aeCNtmQkI9kqCotD66dbcUaVyzS2mgIYLlMa4zU3TCjzuHe?=
 =?us-ascii?Q?pr1qIRf18LZBX1FMoUH7ZBZTLaCog965znpkwwQZ7lvR2IxbcfQzC/uBcbLv?=
 =?us-ascii?Q?p6eElEHp8ukNGkO+CF0S/MC0jqI/ejEwsQ8e453yzdlpBbl87t+SzdFIS0WB?=
 =?us-ascii?Q?GWKvaLzv9TMymwnGIO+KkN7UlJf04b0FiYyZotFJvqnfxJhVwyr396mrpgJK?=
 =?us-ascii?Q?7ySWnWgYhz6JSJgu2/mrgslgLDmJ7yno9hfi5byswakWio5xIzJ/aAbwPX8J?=
 =?us-ascii?Q?o50FDXvVyZkBai9fMWm6vsnrmiQQoxYIZNPoufEsJUpa67oMrANcqXc7PB/i?=
 =?us-ascii?Q?EHXJXlC/Zy6tDduWPqV6PlQhcXfYwLUHpGJjKNpDC20xnXlp1uTbGzD1vHl+?=
 =?us-ascii?Q?haqf64udsnobZ+p57DcaNo+tsQXgHBZKGKmdj/wqOMgNwmaKIOfbw4ZW8e8y?=
 =?us-ascii?Q?8jxRA8/iFNktnNW05J2QllDf+4bWAQrwnE3tf5yfE8aN/0cPX70+pePx6DR3?=
 =?us-ascii?Q?FGiTxMHLPJlFdWL8O84XyC+C2yvh2uMgW22doaTcILSEv2t8+Qm1tT5Nfcy7?=
 =?us-ascii?Q?A17QlkxF4R2Rm34zFQmopFnzs1jMmk/nNuTC0xhUljjGPGRXOHHDp64qbjye?=
 =?us-ascii?Q?TvnBEgdNjFdywx8ntzCqZ5Pf1vL9/nh/shAKjztykmlADhiKxIAXSs9S02LC?=
 =?us-ascii?Q?RQlo0PDeJwbbIPzzcn6TQiVk5nFpLJguFjDxsycunI3sAALxfFutXhBVa6Aq?=
 =?us-ascii?Q?r7Md1MVZE/WeCogOdQoWyF1HcfRxU+2MDO8E6+3Au7d7K4mXmY9WlW2V4GqD?=
 =?us-ascii?Q?92PhKpzAN/M5dtsB9ENQK7WqG0hgec//PfzbdoXERBbLJdoNPpd7hqSCfuZb?=
 =?us-ascii?Q?0B+QDf+0YF3Ay8IFHjJvvzaAMxSeLlX66mv1/GMWVVTPBHqWSmUQ6LpkdYup?=
 =?us-ascii?Q?xRbfBYgdE3LW3BVpBz2x3OjGzzkjHsfkWTkk7WQn6g2MxpKpZvhev6YEayB+?=
 =?us-ascii?Q?PirAyURKKm1ZMl7KKTNnQDFfmp6fFbP5uw3z9uEV1DyU3zUaFPa7cQw4kZIx?=
 =?us-ascii?Q?6v8+YXqjQEcXhwoTGGJIidl6Ps0ekw1ODA9QEYV1VcIKlF2CWfYsIXevptz+?=
 =?us-ascii?Q?ujRCeqZ5vhdkyh+KiS/21JAeTYZ31aJ3CPO2gJPJj5ziIGtE6e3btV7BaGRK?=
 =?us-ascii?Q?Z/CD1uRJ9lbVmY5wqDG0fxXkt8d0jCriALyh6xzRw12N52l2Yajm1j3s+lTQ?=
 =?us-ascii?Q?J+4tbHXPpA2JM0kWFIBG/8AwZ0OjuF/1yJJfphiL1ovaBOV4Jc+RADgqhPEC?=
 =?us-ascii?Q?mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb28ce7-f8a3-4146-8349-08daa624f86c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 16:24:54.2616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CKBJLSpr4HTKjx5A5oHp1Hqfd6rbmqarvxbG1rEY/KRgwsFtkAsxk55tPDdPnYBGipLV9EnRxEdEXPS7GWt/rQfmYaSB2Y1UX/Xu+HE9Z30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3675
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Friday, August 19, 2=
022 3:18 PM
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
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>=20
> ---
>=20
> V3:
> - Added Michael's review tag - thanks!
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
> [0] https://lore.kernel.org/lkml/427a8277-49f0-4317-d6c3-4a15d7070e55@iga=
lia.com/
>=20
>=20
>  drivers/hv/vmbus_drv.c          | 109 +++++++++++++++++++-------------
>  drivers/video/fbdev/hyperv_fb.c |   8 +++
>  2 files changed, 74 insertions(+), 43 deletions(-)
>=20

Tested this patch in combination with Patch 9 in this series.  Verified
that both the panic and die paths work correctly with notification to
Hyper-V via hyperv_report_panic() or via hv_kmsg_dump().  Hyper-V
framebuffer is updated as expected, though I did not reproduce
a case where the ring buffer lock is held.  vmbus_initiate_unload() runs
as expected.

Tested-by: Michael Kelley <mikelley@microsoft.com>

> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 23c680d1a0f5..0a77e2bb0b70 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -25,7 +25,6 @@
>  #include <linux/sched/task_stack.h>
>=20
>  #include <linux/delay.h>
> -#include <linux/notifier.h>
>  #include <linux/panic_notifier.h>
>  #include <linux/ptrace.h>
>  #include <linux/screen_info.h>
> @@ -69,53 +68,74 @@ static int hyperv_report_reg(void)
>  	return !sysctl_record_panic_msg || !hv_panic_page;
>  }
>=20
> -static int hyperv_panic_event(struct notifier_block *nb, unsigned long v=
al,
> +/*
> + * The panic notifier below is responsible solely for unloading the
> + * vmbus connection, which is necessary in a panic event.
> + *
> + * Notice an intrincate relation of this notifier with Hyper-V
> + * framebuffer panic notifier exists - we need vmbus connection alive
> + * there in order to succeed, so we need to order both with each other
> + * [see hvfb_on_panic()] - this is done using notifiers' priorities.
> + */
> +static int hv_panic_vmbus_unload(struct notifier_block *nb, unsigned lon=
g val,
>  			      void *args)
> +{
> +	vmbus_initiate_unload(true);
> +	return NOTIFY_DONE;
> +}
> +static struct notifier_block hyperv_panic_vmbus_unload_block =3D {
> +	.notifier_call	=3D hv_panic_vmbus_unload,
> +	.priority	=3D INT_MIN + 1, /* almost the latest one to execute */
> +};
> +
> +static int hv_die_panic_notify_crash(struct notifier_block *self,
> +				     unsigned long val, void *args);
> +
> +static struct notifier_block hyperv_die_report_block =3D {
> +	.notifier_call =3D hv_die_panic_notify_crash,
> +};
> +static struct notifier_block hyperv_panic_report_block =3D {
> +	.notifier_call =3D hv_die_panic_notify_crash,
> +};
> +
> +/*
> + * The following callback works both as die and panic notifier; its
> + * goal is to provide panic information to the hypervisor unless the
> + * kmsg dumper is used [see hv_kmsg_dump()], which provides more
> + * information but isn't always available.
> + *
> + * Notice that both the panic/die report notifiers are registered only
> + * if we have the capability HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE set.
> + */
> +static int hv_die_panic_notify_crash(struct notifier_block *self,
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
> +	if (self =3D=3D &hyperv_panic_report_block) {
> +		is_die =3D false;
>  		regs =3D current_pt_regs();
> -		hyperv_report_panic(regs, val, false);
> +	} else { /* die event */
> +		if (val !=3D DIE_OOPS)
> +			return NOTIFY_DONE;
> +
> +		is_die =3D true;
> +		regs =3D ((struct die_args *)args)->regs;
>  	}
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
> -		return NOTIFY_DONE;
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
>=20
> -static struct notifier_block hyperv_die_block =3D {
> -	.notifier_call =3D hyperv_die_event,
> -};
> -static struct notifier_block hyperv_panic_block =3D {
> -	.notifier_call =3D hyperv_panic_event,
> -};
> -
>  static const char *fb_mmio_name =3D "fb_range";
>  static struct resource *fb_mmio;
>  static struct resource *hyperv_mmio;
> @@ -1538,16 +1558,17 @@ static int vmbus_bus_init(void)
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
> @@ -2776,15 +2797,17 @@ static void __exit vmbus_exit(void)
>=20
>  	if (ms_hyperv.misc_features &
> HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
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
> index e1b65a01fb96..9234d31d4305 100644
> --- a/drivers/video/fbdev/hyperv_fb.c
> +++ b/drivers/video/fbdev/hyperv_fb.c
> @@ -1216,7 +1216,15 @@ static int hvfb_probe(struct hv_device *hdev,
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
> 2.37.2

