Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B3863AD39
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiK1QEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiK1QEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:04:46 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11022027.outbound.protection.outlook.com [52.101.63.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A586C1F626;
        Mon, 28 Nov 2022 08:04:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fmrza4UNKoj4dshEqq/0/aEpzcW+cuyUIeX0smTGkpQV3bFaO6kt5cpEZqX7Wy2kUF3TNaiXu3cn9jcZnpKVmGTlts62KJjTar4TKxr/FEQblO/gXAq+n6OYIJ0/q1sDC5IYem83zfigJqhNDzp6qMLuynCVBLjHlS4qfgzvr42gaICZUL5I6TWfaUwgx5GiXNIrLSdyE5BU5yIZfyKfyfkk3F4+yEyy06ErfSXb0/dMaBOGLYJiUoKPJw1l9cRxLOz2NP/4/EdUjM5j5WqKA00OGbnDfShwWgMWJ6b8XXszwkv6dpfTgPMf3BB4Cla/8+Yxg87UmX7Nflk+2w9Ceg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VU2eWIwOybc5vtqzwQ9kRYSIuNNvAtwdxsl/9bKXgLs=;
 b=kn3z9dPY6T3qsNG+FvgJxTo+zrI1fBwSQKYkeDvvJf5ig/zcPwiHwJXDxOWGeuuxXtOmjukuHL4VcbxVsx80ku6ZrTPudTCG5yqCycrVcdROB6U0zPJUSvsL2e9Ej9NJTi8TMSqQgNlP95X+FVeisVo14Ro9UOh3yBXTY8i/3nwukumNUfdmiJTmp4DPol6KK611qcMcUPx/xoO0wbG5fspOqfDPvpB2hw0cUTFMFcSxquQu3PXlgVRCr5dAEzymvbHl2ni0Aj5QJMkzjeZKhsWufQENtgAE3w1fAnAZ/OpEo7njH+Tg9DFrrUVKz4CxDMV56SSrtw7/nAjqmGb+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VU2eWIwOybc5vtqzwQ9kRYSIuNNvAtwdxsl/9bKXgLs=;
 b=gNiVmb90dsAUZBWs4AFkHawJjwZ/mgwsg2hKXO/oBg+bNA9ofUbGZ7DO5Txf01hx+ZH/sYRvzRq9lgk+KCf/r0jHh93r9N/Ir08crUqUHftQcG5U+TNvHWmPv6VV1KicaEzR89KknGlJOCDVoWOUKFu0vcjfa9RAfpTd2VZ40bE=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by LV2PR21MB3061.namprd21.prod.outlook.com (2603:10b6:408:17e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Mon, 28 Nov
 2022 16:04:37 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%6]) with mapi id 15.20.5880.008; Mon, 28 Nov 2022
 16:04:37 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Wei Liu <wei.liu@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
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
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Subject: RE: [PATCH v4 1/1] x86/ioremap: Fix page aligned size calculation in
 __ioremap_caller()
Thread-Topic: [PATCH v4 1/1] x86/ioremap: Fix page aligned size calculation in
 __ioremap_caller()
Thread-Index: AQHY/pnBKtjG2pB9XUmkHUxGJNjaHK5PxXQAgASrlLCAABK0gIAABPFA
Date:   Mon, 28 Nov 2022 16:04:37 +0000
Message-ID: <BYAPR21MB168801B17BF6543562E08CF1D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669138842-30100-1-git-send-email-mikelley@microsoft.com>
 <Y4DdCD7555d2SpkZ@liuwe-devbox-debian-v2>
 <BYAPR21MB1688F9B7FC41946DBD9F8784D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4TXpW6vN4j9bULs@zn.tnic>
In-Reply-To: <Y4TXpW6vN4j9bULs@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=726d1df4-1fe9-4ea0-aa50-2fbb026bb3ca;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-28T16:03:22Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|LV2PR21MB3061:EE_
x-ms-office365-filtering-correlation-id: 7c735343-666c-4bf1-4231-08dad15a3ffb
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Aum5dy9+eH+LK+aaZp4KUocHw7r0pcSt6KwmQ07snLKZsaGIf7Ufm1NIHXQ0Zwp7rBp55nwwpvaCL4jVgZi7TXXsGO2S4fhKUT6SH+58ua5VJ6gxsLWHdBYmoQPCaMSNAW+JxigpYJsbzvJIlasoCAzWVG5b7xWJR04CC+G/ilu9WuVMES2kWhavhOwE0hvFe2H/5E/wx6AvL7wNJHuY7qX88BeYgA1AzEwdCNzeIIjkQZYn3oIgzQn8XR7NP28eDu5ZtNsdeOecE7ymHJljr9JQukboKg+OySd6FyGW0AyVG/2BN+v4zUUEra90grDsQAZwNP9S6dNc4vIeK1QS2+uJ9AoJoDl2SN4uCboBi1fQdbTbHxEv6sTine26Nmb/X5FA8GRayBIaqGNQ9nQy1DiL0Pcj4ChvMme3cxcNdgHJF/fqSi8t9Mziqjk8b75HkLgvC/Nlyi/xkMbKcBjK2eV/UFzOZPI0kFJ1hx3t5oOt2UdCJPZe3yzMNLd441xmD3qxMkIq+QVKh6gbgpJqLnUM4skm778eKFWEy0mZYuVwK3GY0MOB8iy2ooeRoJtywbiinhjeiPFSYehhjN8IOmPDSW/6+q1W9fsXTvnTrDtLVxmI9fSlatyRKvKSjYfTwuzLqV1xfCM+C0cpy0bLzRtZfL8PpsDYWF7rDvPgdcm0O8tcea2w4lI6XIokMZnV38ZoWlIN87DVIEf2w/AiVoDjswFimabV0eSLtjKyJirei8zVABimHOhQawUoA/grq0qCXgzck7O/bX3j4u45w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(7696005)(83380400001)(2906002)(9686003)(26005)(6506007)(478600001)(38070700005)(86362001)(5660300002)(52536014)(71200400001)(316002)(10290500003)(6916009)(54906003)(966005)(38100700002)(122000001)(82960400001)(82950400001)(66446008)(76116006)(186003)(66556008)(7416002)(7406005)(66476007)(64756008)(4744005)(8936002)(8676002)(66946007)(8990500004)(41300700001)(33656002)(4326008)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7B2O0eATX2ZE/3PJfMuf87TeSExIDh8GR5OIE5k7hvKUzqLlF/hH+8h+J5i/?=
 =?us-ascii?Q?TLvCPkuonObnu1gWNhgQPbyY4FGdZ6Z8+Yr9py0H8s1oK2yapk5/3M47Bxor?=
 =?us-ascii?Q?u9Q6I2Oc1YaPH41yppfHDn2tDNYCVyqt7VkLMjAD4Z543I2avZb5jBP4VUNL?=
 =?us-ascii?Q?hZ2vFRIZTuVfqipsux157ApjEkDDpCZh0IAygBgEH5j32EZOkAYuF3zFtfI1?=
 =?us-ascii?Q?oiKAmnDv9auVCUm+arsBGHyuS9rGn29ybHj5E2GAUiSZOP2awt0hKUPljAAV?=
 =?us-ascii?Q?I75df1nDoc1m+EjKGY/OrPcGo9R97lfFOGOnWkziPGwk2l+SdEFmeAr1/S9g?=
 =?us-ascii?Q?gfyi8k73I4Zhun6QhsbMzUvCwC+iM3JuIhY5jcrLiLJtBJS435w2qgjlNdtN?=
 =?us-ascii?Q?SNBIjOlsl+sHMH9IXSHe3wbpEA8vyeQvAAL+YFQz6iAVWNJBLDUTNWCEwZ8O?=
 =?us-ascii?Q?K4Wni00ilclBxlbaqhlk+vaFLVZsa0Z7H6eJurUgXn7cCZq7VU4ZbN94Jjmi?=
 =?us-ascii?Q?vU4klLvwek2jYOCqFiOi5aLLygXmpNMfhPOR2/OaevKdqQ5zwF09PALopJs1?=
 =?us-ascii?Q?EFgZrhhSk7XPQ8aKFQQuhCcqO96V2kw7pc+mZw2JMl1/Lfcm1G+wLvQ33fwN?=
 =?us-ascii?Q?XK+ha3puKL0IVZX+m3csOQkOzVIBLzuXKiHWzVaBZWYriMrleyu950nPbvoq?=
 =?us-ascii?Q?CDQCvUYje/JlpaAntJsK5Z4IHb8G4qmz1psZ9T4+6T9Sd2ExD/gZqLTEuqlK?=
 =?us-ascii?Q?+h/9vA+7AjX81RMn13PrWKSpdTeMryY3j885JN6ZTBwEPmcygAEhB6F8sCvm?=
 =?us-ascii?Q?UcDb85dtxTTHnxvKC6lqu2weZLLMS4bJK9ksN1PZswKUURVSBW6l4xuUggVX?=
 =?us-ascii?Q?316qeq1RlZGHsMKk2mXPzAFD07dwLez8Uq3tqPHT7cY/T2nKrbvMTjvUheLu?=
 =?us-ascii?Q?Va3a3Lu9pHHrNyKC0XXJquUv/CRavFshRYHrYEGtYdWyF7/lD7xIOSQ4I75c?=
 =?us-ascii?Q?UKI3zHjKSFJxlXgjxbAFW03AMRv6kAuuhWHZq85Ogn+7W8U5P+BcvfFWs+tt?=
 =?us-ascii?Q?o3Dj8Y6BD09FOKZN/N+uJEV68gv2No1sFtl0e8Ps08axoi/1xNyKW22WblJv?=
 =?us-ascii?Q?KHwvySZiaRQ6UJEIzq9wD/U5Foow+lCKGcdXXj7hM5GUEp8D0LxuF4bGTdnC?=
 =?us-ascii?Q?QZLWja1Lrl6SvjvvigilECTYd/5j891br4p0BECgtZZ+RAiZzHsI3PU+jqtp?=
 =?us-ascii?Q?p9qy6GzOuI3NWMpxyQ2KE4bes7hlYflrKL8QGMgpy6b5ra2XPG37yzOMaHR3?=
 =?us-ascii?Q?Rd5A+jUCoJn/masCs3feH05Wan/MWcAtvcIrP27+wEg5+E5hzdKxEIYRbott?=
 =?us-ascii?Q?nYMWI/KFESJS+PdXFzAWj4wBlTWkbNS3E2P/BIvq70F/TLHVIs3TWGRUuh1N?=
 =?us-ascii?Q?iZ+Tn8CAKpadd3BApJzRd2Ognn0krjDdnZqNCJc0xUzzFv4seppFsrXlUJoe?=
 =?us-ascii?Q?aIdWnWcwo7gWHafTBYx9cH2W3D7101kJkvUp01Gi+wRVuFKC9KPmt15HAboF?=
 =?us-ascii?Q?S0Th9wV9JDV0IE4Jr/OkN34hi7ped93nsLJKWs7OzyYqkCkXzKcdxEv9LEH4?=
 =?us-ascii?Q?WA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c735343-666c-4bf1-4231-08dad15a3ffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 16:04:37.6726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LwBHvAQX142BHFo5AgT1OQsESWC22LG4xOe8gppfaVXrpit42q5oNRFYccMs7XqK/EadKKhS+4j46UYng1yqCgObs3Lav/supNHxGTQidxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3061
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, November 28, 2022 7:46 A=
M
>=20
> On Mon, Nov 28, 2022 at 02:43:28PM +0000, Michael Kelley (LINUX) wrote:
> > Boris -- you were going to pick up this patch separately
> > though urgent.  Can you go ahead and do that?
>=20
> Did you not get the tip-bot notification?
>=20
> https://lore.kernel.org/all/166911713030.4906.16935727667401525991.tip-bo=
t2@tip-bot2/
>=20
> you're on Cc there too.
>=20

Argh.  My mistake.  Thanks.

Michael


