Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6AA6999A1
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBPQQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBPQQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:16:21 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020016.outbound.protection.outlook.com [52.101.56.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E654B44A2;
        Thu, 16 Feb 2023 08:16:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gubqzdTtUrSS5+eoougtntreeElX7O3XgS3rGG405apyTI7mBB3M6Cav8bszXPdZp5bkQ3/CpezMDSpFDQBSXSXkhbYIsyQFR9Ro88t/2z7Ntl9rjgbqYRioSq7sKXewaZnisWv5oSjX61C1tOQsUo5bIoLnQxEeFjTi9sd7QWhov16hDJAE0ZT+gela5YNby7P2jAItjzUXype8RZEX2qCw9Y2VgrxjoIPmFfuGczmrsdTSREB1DhmsvYEBR+Ac/17tbZLKAMs2vcuqRGfvk7zSRIGWneJ3JnbTPkui04O9E5j4P3e2Rsz5g+hJzbVdiBka1JbeZlxA+71RW2fj/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xNPLTziJ001uBlD7XgeqgoKP/HbXD7Qee7avHIvzR5U=;
 b=K8aNDJY5fuJz7yGN7i4tUgZ8CAvir+tglA4sV4yyKGNaAy0d6K/ElKgc/wHsVmAqH9ViP1LHtzG4zsIdzX1BXDgvuite+TG+9yJqPza8rr1zq7xlz39E5HLPaaNrQ5MEwA0V3XmuihfLnkHOeDxYM9i6heCVYGi2ABiDrMld7PNZkZIKuIDqRQbH2ZjpLtC6yhNU0zW4A3AN/9FrfuXjWpfpoO3RTQssQc1d+jZtz5ZQJT4M2/mPsQZkOtm2Sf5QygrKyAcC+bE5wHOXCdvvNycGSFBUzUIqCx0StRjesKqX3L6vezSlj8DDfw5M5ULVuJ8fK1JeUz+d0ZOqp80DrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNPLTziJ001uBlD7XgeqgoKP/HbXD7Qee7avHIvzR5U=;
 b=IYz/OxPGDyIGpb+3ztvQBYi8rb0p9VqYw24zXFv3nF/SQGTicUJzSc9/pKEz/X6cP7PtDee/Q1r9TM7ifYh7ZBkdC+xGn02lGXG9h3k36Zjqy6OwwZNh4xPnDgcLIYtNr4hIvPrONZZbLNAQF9IF99r/Qy2mdhF7xvcFYMWnhvM=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ1PR21MB3459.namprd21.prod.outlook.com (2603:10b6:a03:451::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.3; Thu, 16 Feb
 2023 16:16:16 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a%7]) with mapi id 15.20.6134.006; Thu, 16 Feb 2023
 16:16:16 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Topic: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95AgAGmoACAAAYigIAAAicAgAAHCQCAAAYXAIAADqWAgAAB8ICAAAP2cIAAK2uAgAjCToCAACg1IA==
Date:   Thu, 16 Feb 2023 16:16:16 +0000
Message-ID: <BYAPR21MB168853FD0676CCACF7C249B0D7A09@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com> <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic> <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com> <Y+4wiyepKU8IEr48@zn.tnic>
In-Reply-To: <Y+4wiyepKU8IEr48@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=90b10f9b-a95b-42e9-90ec-6e2afbf06c41;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-16T15:56:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ1PR21MB3459:EE_
x-ms-office365-filtering-correlation-id: f92a8bad-cbb2-4a8a-6ae0-08db10392178
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nFAMoAc4k2bPubhYan86CM2GEg+sUHbUzaqkTYw6EYN5hsLLtOPRK0paGWyC/fQyicaIBDaSek7IW4KUmWFnSAo0voqzyKA3HqBx8562rLxP3sv37rTYl8v6Z5Ui5SB8lqPh/VVKHUJjW07T5oV5areBZ4/oPo5Cr+k2No8x85eBjs6uBXliqEj4HeziSfzGT18hIncfcSEW79sxXrOosPRNl46zzt51FNvfK/JB/3VwoO+q5efzK63UA1bx2VI7gzko8jo9mRn3azMs3wq2UAA/LrMEZOeKAqE05OMtqo5lrH3jWdmz+Di/bh0HCS6E75jMhsIvwyu6SXTSf8xSiChYFASD1pVSdHXa/hDBZzClyA9OuFnyvsfRIt0qbMr8cKYm3nqor4wEhY9Nrq4DJRoWO/CF8781ZEoo6sjhts0hVculZyx+isBbz7xNgZkMAY1UskKVxAWMQxzGarHrLNjZh38k4xH6IkAR/HiAIIgK/V8Ff3s3JJnytz3sXtX2aq34UXuT/WTcCyG4MY+JOnRzETukiV4zoZWxc/K0kTvCS7M2hGmYlK+lI7CtnvGVOdBieB+i3ojI5o9dDpp0wRIyRcSj6LqtYFk2v4MIMU0PXiuUJFN2CQD95DDWxJYaPc1sJ0eZOiAaOg89Lv5gJjlnWd34QE+M25vF1csN76QtLaB5zmodNq2J0czijnHLS6RycM8zdFL+KNGQJUQgjMzDhDrxM6StQgUjroWw2CE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199018)(55016003)(8990500004)(66574015)(7406005)(2906002)(38070700005)(33656002)(186003)(6506007)(71200400001)(7696005)(966005)(7416002)(9686003)(4326008)(82950400001)(8936002)(122000001)(66946007)(82960400001)(66476007)(64756008)(38100700002)(86362001)(76116006)(66556008)(8676002)(5660300002)(66446008)(110136005)(316002)(54906003)(478600001)(41300700001)(10290500003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?b1x8myDDjTtJ+R59r9WuIx/9svl0rDplmLSnG6sHB0Akl0YCGJ3Uhfg3oq?=
 =?iso-8859-1?Q?vnfrb5Ary2hZO9fd0lz/+CP+eHlOf4agk4RFm1sAbI37QjvcQlq7O5IIjY?=
 =?iso-8859-1?Q?YadygC9x37qKmOzZ+3CI77dgaA0fruyzmdzyvHWVtZKH4lr51P7+LSGA4u?=
 =?iso-8859-1?Q?Hrby8qmptO4oYMOWBOLdn6W1bZuXHPuSDTprs0tB9TNf+PYf60UK8ZwxpE?=
 =?iso-8859-1?Q?hS1ydRlscCkrsjnzWMzUN7b7Ohd4Nb8r92i19b2DeRve2h5KKu4oP8duxm?=
 =?iso-8859-1?Q?nYFzZXgMwfYXCTnj6wP348R7I03D2pl5sbSF7aw85Qfl/Q5M+O+IiQRumq?=
 =?iso-8859-1?Q?PeyDzri93LkExcw/5AoRbewIJfkMR3K515VpEBtdKh8/RoUcd4k+G+Npne?=
 =?iso-8859-1?Q?MHUvHJOegY31fJvQIm/5lC8Q04z2+aiJrL9j5dtTNZy4gHPH17EiM9HA9+?=
 =?iso-8859-1?Q?FE8Rf7zwjGpujuHzYWgctnuqnWEEQX6SVa/G1NBnplU2k561iqlenbObAD?=
 =?iso-8859-1?Q?mFgqomNJu5qJnyuREJ5m4SkkcvP7dshGy4iOecU0xts4sl49LfttdYnZic?=
 =?iso-8859-1?Q?4g+3wLq5GNyHakR3yrFACubKCKF+nBSzLtXMQq5eE8DOwpKl78MtqVc+cU?=
 =?iso-8859-1?Q?OAEwf76IgH1I+SQltjQZqDF25Dw7vCqs49/locTAkJpguBfXifA4VsWlpB?=
 =?iso-8859-1?Q?SPW1yusnf0kpvoDAsFnnGhi8lwsj56qe4pXUDsMIWVtfSb0fWEXIKi+83z?=
 =?iso-8859-1?Q?KvWRX6/JkvFmkLoy9ChPvKNkUj8rWeB3ItTWDW1VjHG2uUXWAZ2/wp4nk5?=
 =?iso-8859-1?Q?LTL3cKAOjwiOwDBtJD4aiBdop734p0RnFhWnWM0ywdd3TUZPDE0ZePYdw+?=
 =?iso-8859-1?Q?aKVyM8ZjBLZnuQw1GcCcUtfnwGuAZ34fes6tEv0EZwH03DDjfMfHYGcYoF?=
 =?iso-8859-1?Q?x4/FoZs7sC+1qfzIgVw4fitrgmUUtLYL+/Go64axqts7FljqAxGTlEfO/j?=
 =?iso-8859-1?Q?wDVWHkbkuQBTXA9KaD4eoj7V96JXhjV9izuIYteBMMHlP9Sh6xCRpmhvuX?=
 =?iso-8859-1?Q?3lEL1rO3oFKDafBCPjpEc+gLeOjIx+Nzc/sUDdmu612jrKtzVEHU+o65/8?=
 =?iso-8859-1?Q?WO6Pkq2LP55viHT4s3EpjorWAi6nnTVwHHwdxrb6qxzfmC9eMJmU3J2R+f?=
 =?iso-8859-1?Q?zNN4JAp7GcBUwu/5xRUCBrn/M6mT/TtL7aqgQIi2Fh/wDg+kUJjE+28HdE?=
 =?iso-8859-1?Q?dkUBhSo5EnWks++TcVu3tg2PhC3vYrCt37oaOPSQdLyq9RY0VvNnPBdjuA?=
 =?iso-8859-1?Q?h2x0F5YQKRZOyO3DmyjH+0iCZY5b0r36lC0n8FSHDCR0YnZJMREYUIICTz?=
 =?iso-8859-1?Q?LOaNb6U3TnrEr/QFkeI0ZJ1P+sqMEXlT2K9Dh9Ae4KwPf0CxdFwK3j/TxP?=
 =?iso-8859-1?Q?oAS46dbCgsf0q/HsbmtQFqoVN7gRKumk3EHOvTKl4ctIf525HxPaBC9aBO?=
 =?iso-8859-1?Q?MRTlyKktO4ji5Wb1nSr/A7zaC5I3u1OT8v/pSH/Ut10uDp9AF5UjN5Adqc?=
 =?iso-8859-1?Q?uIVLOO6s+ubXM2Pgs8SrqQANUBjXn5CJjVPUVRZvS9kf586kzmfOClrnuh?=
 =?iso-8859-1?Q?/qeCx9IzC1bPOonefb8tgzQOSCQJI9o+EwOAylT311alF+pdSqUeUNcoWx?=
 =?iso-8859-1?Q?uV7PVKs+z7eDmfWjGrKTlWxTsbGH9p9YMNYbzAvvIM+pSgriKIufH9CFe3?=
 =?iso-8859-1?Q?iV3w=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92a8bad-cbb2-4a8a-6ae0-08db10392178
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 16:16:16.3450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2IMepmreeR6Xq0ddlAZvcQNYM/iH3Qgz7kiGXO1Vrsdr+uV1wXUO3C31wAYqV57EbvaKfEX22ZpQxk86eSi+qNEVIfgCZ+7Y+pDQtH4TZ6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3459
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Thursday, February 16, 2023 5:33=
 AM
>=20
> On Fri, Feb 10, 2023 at 11:47:27PM +0000, Sean Christopherson wrote:
> > I agree with Boris' comment that a one-off "other encrypted range" is a=
 hack, but
> > that's just an API problem.  The kernel already has hypervisor specific=
 hooks (and
> > for SEV-ES even), why not expand that?  That way figuring out which dev=
ices are
> > private is wholly contained in Hyper-V code, at least until there's a g=
eneric
> > solution for enumerating private devices, though that seems unlikely to=
 happen
> > and will be a happy problem to solve if it does come about.
>=20
> I feel ya and this all makes sense and your proposals look clean enough
> to me but we still need some way of determining whether this is a vTOM
> on hyperv=20

Historically, callbacks like Sean proposed default to NULL and do nothing
unless they are explicitly set.  The Hyper-V vTOM code would set the callba=
ck.
Is that not sufficient?  Or in the two places where the callback would
be made, do you want to bracket with a test for being in a Hyper-V vTOM
VM?  If so, then we're back to needing something like CC_ATTR_PARAVISOR
on which to gate the callbacks.

Or do you mean something else entirely?

Michael

> because there's the next crapola with
>=20
> https://lore.kernel.org/all/20230209072220.6836-4-jgross@suse.com/
>=20
> because apparently hyperv does PAT but disables MTRRs for such vTOM
> SEV-SNP guests and ... madness.
>=20
> But that's not the only example - Xen has been doing this thing too.
>=20
> And J=FCrgen has been trying to address this in a clean way but it is
> a pain.
>=20
> What I don't want to have is a gazillion ways to check what needs to
> happen for which guest type. Because people who change the kernel to run
> on baremetal, will break them. And I can't blame them. We try to support
> all kinds of guests in the x86 code but this support should be plain and
> simple.
>=20
