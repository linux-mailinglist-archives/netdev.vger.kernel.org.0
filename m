Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AD66C82F5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjCXRKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjCXRKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:10:34 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021014.outbound.protection.outlook.com [52.101.57.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0AA21966;
        Fri, 24 Mar 2023 10:10:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B//V/pAoXrnB4n4DjqjWMI1vo4xD5cdBim+AaHQ7CdxPC42wHzOVDywxKCY7pH9DtIC6qhc0isM05Wot+almgi/h8+tPDKggnJ7Ts3GkpSZ8JItJiekoWTnRW/j9QByt190MPsqsd4sYnk0SDnCl5GmN3Tw5dUBaLQeldrIXC9Llz5Z63pu4CqPu39u9KxBxtINxlSUR4vxKLTsj6bBziv7UBJATn6oIvz/6vt17ufpmBSx481lUS1knQv9ccO5AaCvwL5xzKsil1HkM3/BmBXh6ww0ngSQcr4B4KMPLHuQD0KV7bncYNO5XAIz/w0X65AS6nxrEgeE1gluT6+9tpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uowLIybn2D8Vibiy/QHd14+sP470plt8QIxjJvG8onE=;
 b=EWcDeDrfIE2D27q/ARVnk7Vd4M8UCwJI+wXeZwj9SSsfpFehLusdTbOLPtUyKv7aPfx/2WA1mZNHEBYlnW7qV6ctLesdgKSqpPJ+nF7YLHicUOTe7rFo8NV+iZzmvv9ZAqyuIpvNpYO3a0RT2gCzNo5lH1np6Mp2KBCTQRdHaHk67rB/iFNDJ83wmYFs03N1rLTGSW0gB24RotguOSbPJ64zrgljLmJxs8zvn869Dh1R6RKArl3YbXJHZK5LR03NH++actFajyrTG07Z4iJjlPhaPHAvgfxhZgWTI+r+xxlsIHbZuXhmtEDbhS1mZ6ZTsysrYi7m3AeyPelMD7jlCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uowLIybn2D8Vibiy/QHd14+sP470plt8QIxjJvG8onE=;
 b=Us7ivAqHWOYzQ1Z+Q0gfNeE2QWFQt0k8IUBv4iAyc24VwpKazgWo7bu3+h0cMqpdlShbGQVVEIrbEo8KscrZriGS0h8lSKcmaPHsjzhfHbw641aE14WJkHutTBscCzqUkZFtHL1y0Ye5QEbLqBkJX2u4SG2yvNE2/SD8cZ1RJlk=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by DM6PR21MB1468.namprd21.prod.outlook.com (2603:10b6:5:25b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.9; Fri, 24 Mar
 2023 17:10:26 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6254.011; Fri, 24 Mar 2023
 17:10:26 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
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
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHZXmgw+OdhZXSmY06XlWsFUPOSLa8KKbWw
Date:   Fri, 24 Mar 2023 17:10:26 +0000
Message-ID: <SA1PR21MB1335023500AE3E7C8AE6F867BF849@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
 <20230320112258.GCZBhCEpNAIk0rUDnx@fat_crate.local>
 <BYAPR21MB16880C855EDB5AD3AECA473DD7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230320181646.GAZBijDiAckZ9WOmhU@fat_crate.local>
 <BYAPR21MB1688DF161ACE142DEA721DA1D7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230323134306.GEZBxXahNkFIx1vyzN@fat_crate.local>
 <20230324154856.GDZB3GaHG/3L0Q1x47@fat_crate.local>
In-Reply-To: <20230324154856.GDZB3GaHG/3L0Q1x47@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2bd99fea-2fe3-4f34-8b9b-fa2b2fc0f56e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-24T17:08:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|DM6PR21MB1468:EE_
x-ms-office365-filtering-correlation-id: a6b59117-7b26-4b3b-d39c-08db2c8aa965
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EculslW8KpiexXf8Yy7+hBJy2JaaNKCCMA/TxhkfHCDZEhA2H2psHCGjGjOgTdHuqK9RmTIWWABX/zq5xZOIO44y0y8Q64r7lbP0R4am9Bzk4UFKdWeDtEOgynQHfnslVU5LqtPWeyKYSlQEMPsSveRWuSuO2WF0f6t6qyCialfnJM1rEpP5zStlUvBRb62YZUrsO1HAR3uGS5vWuaJxCRm7WInJDok/v6JB2iDrPSj78/LSc0F+TMI/KSHxZaCcpbw8aZ1qhjwzWofN8RzZ0HYyw0JbkhArgmn7XP+qfQKl6uFXu2qn0lse5+pd/hVDImQFtMe1WZGzLxLjX+h6zwo0lFTYioDDAbxbjSmHrlwacEeH8pF7PIDWizPaPs+jRQO1aQaiPGs9MVeeoaBkxjwI91mVfSLt4GT1VxfWssDwZyQvRWDh5rjScIWVI3W5qYjEuC5DdzS6BNwlrW/bGpE4J+Lm2vomg2IKRGxWaOAp+mUfBjlV394DLqmbd0PAT7MgMPqsWEEvCaVmN3p4r04FUeyTsCAum2V3/y8bg1IXMhZi7aZL2L/O8TSS2ob6kDlc60wXf70Urz+TCC0IzWovVYN195ebXzZ7fXrUSZ6ISLCfqEH4Dj9aMQDuF5Pnrs83pCV/R3Hf0WRVqxr8tvRFQnPBqkfIpofO6vbd6fI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199018)(4744005)(52536014)(8936002)(8990500004)(2906002)(86362001)(38070700005)(478600001)(33656002)(82950400001)(82960400001)(38100700002)(122000001)(41300700001)(10290500003)(7696005)(66946007)(6636002)(8676002)(54906003)(4326008)(66476007)(66556008)(76116006)(71200400001)(316002)(66446008)(64756008)(7406005)(5660300002)(7416002)(55016003)(110136005)(9686003)(6506007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B2w3L3240UWCFERXv05KoCSk31zPaA+GSUHjw7j7BK6r3XJB9Xtu576GVTGP?=
 =?us-ascii?Q?w+uH7IQTKCKQwMnULVi+rLowfB7fmHbAUtWIZ4w7jRUTGJtjtP/emMdZIDwe?=
 =?us-ascii?Q?E67Z0XYN+BK/A+6DZnqC9+8VAPMp76w9fpbsdWrfislwzCvUeoZh22id68Zk?=
 =?us-ascii?Q?/zId6lTvVBEHXguuG5kBD1AoHOpjSs9m+OWl/3uWmYLa+MzCuJsstCvxAD65?=
 =?us-ascii?Q?9zX+7GVaFEJeufYAzpSrJjQmC7Q7JbiVzuRrSSC/To9Az7ZBCf6gC/TyVx3N?=
 =?us-ascii?Q?LdSz2qZyXYJQwiV0FWkanEotLxjZzqy83GV8lUrV/S0Al/PV3PkBB+p8ZtC1?=
 =?us-ascii?Q?tehquiDwoN3XPg5e4iGcwEJFIn66W+5BUXYrS26r4NQaZ0QQSewihq/R2Lpz?=
 =?us-ascii?Q?kCtZvkYyCFuRBh5j1ty9PPjUOmXV/tVoKmJ2pVKaNocuzCsuqX5eEuUELnTC?=
 =?us-ascii?Q?PM77H+Xq5ImAZl5J82vVvOh5AP7nh4HH0uzn6NGrGyGekzAtw6nmzzx7ldf7?=
 =?us-ascii?Q?eGr8lfkil1NBuN0TXCi0dc4bYXnykvbLH37C15NEnluq4PDgSYVoVbdKVXi0?=
 =?us-ascii?Q?rjSmeCXBk0fqhJxwSRkrlFymyMlLqjxolxKmBbHKoLSOTaAluMeA99ROyfwV?=
 =?us-ascii?Q?f/8mrgC5KeLISQTTZyWLzCcwtSQKjNfGDma9X2eqTIrgk8mCzZOmrNRfGGnX?=
 =?us-ascii?Q?hCHlP8HxDG134+ukNVS68/SdGF0gRYJ7DhTVai98UKcpfaV1LDUgfA8PhRNP?=
 =?us-ascii?Q?x+Pg3C1F3L+mVm4Ckow+5/b5LYEHQ68fxWF4YVsThDVbhsBwona02DUkbdXx?=
 =?us-ascii?Q?Lw/HAjNc6KqipQOY3mIqX/GDjBvghCKTh+aX3WPoR7qz127fBI9kK2C2D+3R?=
 =?us-ascii?Q?TakH/TMqdEHxoQp2Nv9iVHOrRLyu6ouYkA+Juhggcew5aVquWNOiapjtj4Fa?=
 =?us-ascii?Q?sb9Li3cZGoufelGegtvdmgURK2yiFz9576GjYm7r1zvktI+MV0Ge4Z2iVolU?=
 =?us-ascii?Q?sroZFjSzQgD4jPdXTmsrFp948BvYgkMwIXzKLn2hTDlWL6CpOYOB5qNIJQ7p?=
 =?us-ascii?Q?5HjuIypeaG/zS60BQUl2e599WsFVS6sPY51UjlAY3m44+PwnsxyU4wvTzuhf?=
 =?us-ascii?Q?vWy6f0qtWyj+sbdgIiNKQcUDqPGjl5nB1UzH4FWLOz64QlHCgjL2VTzg2upk?=
 =?us-ascii?Q?DdOnTAAD9M6j6BRoZXb4AmNRYGz2mZwDwsBHrtcjsRx6ChPzaXB0fLJOn5aV?=
 =?us-ascii?Q?dJo9O0OPdFAMRTgpfn1EE7+oQsMALR8r/+3ibGk2mlePYxIyPXiQXYC6nuEK?=
 =?us-ascii?Q?42PAp0UP5qjqUNRtiKKec9Oi02ffIytzIj69oj8fv7CqzTngiDJGr9NAFbdM?=
 =?us-ascii?Q?RVA3h0UTWMy2hULkLHPMxxImHUeT1cih6ROfkT8D/X5DcRgIzHA2KlFpXr0d?=
 =?us-ascii?Q?OPjmzuSGnbqLFLdiWvs6YHBC3acjJ/8UE8Mj3qrfMe6iJ8j9WqVI2+HgkosT?=
 =?us-ascii?Q?ApyD18PhyjpFVhFRHm30JjRggCo+7kG8cvi7Ics6lmFI6MFX0oVE4FBIqMvO?=
 =?us-ascii?Q?Rots6vCbeuAAOnwAhPsbF2yZCbMoXEwiLMrgNQA4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b59117-7b26-4b3b-d39c-08db2c8aa965
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 17:10:26.1924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Utks9mHhFnhXAFsHfTdgMEJM6dH1S4snBIlU9VeGhTcBGoHQa9pZTDDIUp8V5RlQaz5xWDPaqbTtHF5W/ZhkhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1468
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Borislav Petkov <bp@alien8.de>
> Sent: Friday, March 24, 2023 8:49 AM
> ...
> With first six applied:
>=20
> arch/x86/coco/core.c:123:7: error: use of undeclared identifier 'sev_stat=
us'
>                 if (sev_status & MSR_AMD64_SNP_VTOM)
>                     ^

Your config doesn't define CONFIG_AMD_MEM_ENCRYPT:
# CONFIG_AMD_MEM_ENCRYPT is not set
