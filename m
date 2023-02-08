Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924F068E4E3
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjBHASp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBHASo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:18:44 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021018.outbound.protection.outlook.com [52.101.62.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BD9358E;
        Tue,  7 Feb 2023 16:18:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMBt9bwEE9E1iXjP7wdx8FJjnTUrrHHqt0ms4yruFUh2aevBbOQEytnBqu536uJD6lEK8oIyJvq3bRicYsdUeF2fGAyX2i5Gb/7p8ErFKsRU9DcVwxxY1XI73CAGv2QPzWpD7H6nGML6ERq+9RZc3kohoZRfwnqOApXLPIF/IBkcfDfAqR19VRfREOaNM+O3LxZgv6Ja88NLsufubw4Cf/x8Fu19qX6PAb0zTmkRY4BxvMVbHsmcj2D9gsE7Ge/vebk18HjL9QZEtOn3RPB3NnJ5SwOdStviwNBe3aeRTP4R1JZiY19esnjs0+VZDiKHnVSopHvIhzsBBktD8NnGdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXBN8ASEISYh6GP+LBgcDCzTQMazZYhCLhNR+pKRTXo=;
 b=Jq2KKQhy82tZF6XagWWP4GIK32Z9hOOrzWrgyKKkB2r9PRkyuTpzLk1A0MsB2xSDQn+eq1nirTEAvUYNR8F2DABtYdLrjBwis39NnMFuV2c0TvZRtnig6fOws5skNeoonElWwseSNkTLrgCcOt+egnZbGR33Uc0sZFaEmgg1GNl0CetJ1LnXkXyFA9LPL0dXL620fKgokQYQGPP2KS36tq0RQK4eBj63PayVPZ82nJ0UMuSgPiURH2UKJQIqZFdDLO5ummNPphRFslUN8TcxRaQ8W0K193ae1czGPx0UY/3sHtpmo+/7B3wniOPbazVuqL1YIq83WC4Oo2NTf7FrZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXBN8ASEISYh6GP+LBgcDCzTQMazZYhCLhNR+pKRTXo=;
 b=NpcAwOFcLg98Oab6A/Zjfc84I50APxCCczaGC6HkI8PGGSNIegHqMM1nAuj7NVbcSVGicWJH0HAqLCh5UY13lmKLdyy/8sKsCCuz8rq0KG2m0MviIWDXYKFl0d3kWndkW+2iUlunAVpKNJtzKeRAA6pMpnn1zIXV6gQqaYDggfI=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.2; Wed, 8 Feb
 2023 00:18:39 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.002; Wed, 8 Feb 2023
 00:18:38 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
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
Subject: RE: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Topic: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAGgMUIAACvuAgAACa5CAAAOQgIAAR90Q
Date:   Wed, 8 Feb 2023 00:18:38 +0000
Message-ID: <BYAPR21MB16880F67072368255CBD815AD7D89@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic>
 <BYAPR21MB1688A80B91CC4957D938191ED7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+KndbrS1/1i0IFd@zn.tnic>
 <BYAPR21MB1688608129815E4F90B9CAA3D7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+KseRfWlnf/bvnF@zn.tnic>
In-Reply-To: <Y+KseRfWlnf/bvnF@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e5f30e3d-b8a5-417e-9cb3-596cc8393e4c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-08T00:11:45Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MW4PR21MB1953:EE_
x-ms-office365-filtering-correlation-id: 814985bd-845b-4b3e-d040-08db096a06d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: StP/m+Hh/1jJfT/1FhfVTBskZRIAD/30q1HdpA49/f+jLUKio+Pq9Ra1LtEHQO3jAJV9489EhqLQwhl+AuUITZsNaFOU3PgEq4AJ9+/aoW5zh4ubPppx2i6qzjubudkh+6Ja9p1b+/yWe82NWcR+gUE9fwHQyjhYf8/hCflNsOQysejIGt77UpgcBz58ED6y0znSvfUCPBV/dMaNL3Jokk3zFI6ykBQYMNEb7jM/GS9vcx78rU3WlJKGMACv+IUlM+x6fGEhNUCMZKELXdOu2QF/GlgL7LQF1UIIPMd5IU1Luos9P3Ny5Fdd1ZxY5bz6XqAIiJVNbFRAfdNj/OG/AKy6GaR0SDw5TgEE97QGdYgLAv6syNkMlzpoE+iDDciS3ga/t70BdX8nApwmCiRRpPg9QJEaRFskjE9cbKTvNfVGloI0787H9aeuzazKiZ34vF86uNPzehPe1hqlPWEPdbWv3aiP05DwV/tH0+4PKW+0nXajMUCM7/86Kt4xzH9GHV0RiaIW6G8/5Q/U3A/M5GSDsG5ZultzcWzuL9Ld0Ls+u5GNkiy2uxqpL89DdFhZlZ2301ykWBjlVTkNY19kzE+2TKDegtFU5nQHvkQym1nywKEqIwHCvZttwjgml+rV/Gf4EWK6UOMYNK0LNuMa4qqeJFNOymX45vGmZl2IeTps4iehIR6qhjh1+s8Ui5s80/ErFjqTOtrEVHSeVxaDY95P7vuugBro83o4/xgw7UdJTEruJGDxkcu40grKYjtH78V1tFRvUEPUIUxosbT4RMktjnj/9kxLPaGS5KIny0w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199018)(33656002)(86362001)(38070700005)(82960400001)(82950400001)(38100700002)(122000001)(316002)(66476007)(5660300002)(8936002)(41300700001)(8676002)(52536014)(7416002)(4326008)(110136005)(54906003)(66556008)(66446008)(64756008)(76116006)(66946007)(7406005)(55016003)(2906002)(8990500004)(966005)(478600001)(10290500003)(83380400001)(7696005)(9686003)(186003)(26005)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rn2YmIS0NYndmEV0BIq0F7HECJxi9bFGPEsZcUYgvM6muZii9ciya5XR4LJa?=
 =?us-ascii?Q?XF/mIHq6wl+XiRf9AP7uFxkjTeHuY4XfYyrHyLX14M3olqS+BJANU7EBbiK1?=
 =?us-ascii?Q?bW5vn9pG3+kuUIYEd++WhLwFdxkNy9YQT87JbE5CJYngzPjl97uIv6NVsAmc?=
 =?us-ascii?Q?DeIRtvLmaznYipUWup1/mA94SKF5NuhFMnV8tQqTO00UGXhX0rTjQwlcpxPB?=
 =?us-ascii?Q?rcdcEb1E7fdrDQQKYfxDDYkmYqH8qQcCI6E7MFMA8AZ0/amzYqSBNNwuyPLV?=
 =?us-ascii?Q?m0UfcnJNXTkRgIa8U3AQQuPou2RAuBSXRSUmk3YpZmRZ2ssp9ZDuV/RdeZ6z?=
 =?us-ascii?Q?uu1VMOUbe/h/7OhgjRNf7jAgEF32KY9YH+H5Pn9iY7EyDqymH9oBSWxwyk/b?=
 =?us-ascii?Q?Z1mv5CmJZtZ++OFArvgoN5tUL6uApyR1qbgdinidp0iWJd8WMY8/LIsVi9Cm?=
 =?us-ascii?Q?KuVc9T73fUmnZzuegCXh2QWVOhUVkTU9G+8a2POOG2DuB0vTTsA2HOMWpdrz?=
 =?us-ascii?Q?KV6I+UP/HZGHO+g7sJ8ycWahyjkOZzY9kd6tf4DLQ8f3O8rXRTl1oRJgNYDC?=
 =?us-ascii?Q?tKQWTc/MuNdrQVqyKROIOX+DCSSLS7UAC+IpS89o8ghb4vFyGESXR2EV90Kd?=
 =?us-ascii?Q?smccOcM19Mjh3cnl7BWl6lDbRcl22YoCqWbk6RW4ABTwU2UPr9rxuN9gi7rJ?=
 =?us-ascii?Q?5HFFLgmfhKZ075yr+EEcdneONzVbSLwTye0gidxitH09zBlaIhmlkf68HIsg?=
 =?us-ascii?Q?TJm6B0k+VU5AKJyMwU0xo3j++Z6fhJmF7qaA8vFZWl1Z8yiVCpm2EUF5O6qv?=
 =?us-ascii?Q?DeOG96eO9I8KT0BTPeoEGjal5l1mXh6++SSR2/J8P+fewxmMIEzkDO1RJOp7?=
 =?us-ascii?Q?3llycuBpZNJdb3LngG+foOBjcI0nElB4TQeDVsdi1WY5xlMH8oWG0qYkq3Y6?=
 =?us-ascii?Q?rwWdE/mJVh3tClgNlrUx90OAQdfdhDz0NB5eo27iWL/cGaqeDeGBHCIBiSOG?=
 =?us-ascii?Q?b5guV4hxPNGsC/qjMJ3fJyH9irC6yxyQVy4ChNv/FO7Rfq9L/QNmIcWlFKzO?=
 =?us-ascii?Q?1Z2Qc+SYnQwIEm+LccP9tVWgl4BHLnw2oSDl3biBk95IHpIGZ3wY6xmtt8gX?=
 =?us-ascii?Q?eAkPFLyEA+ugkH+tAMUSVCgM7tD4fn1MUujPfIad/roOr2PLRX8iRxfLcDDD?=
 =?us-ascii?Q?3cfGZcw5FjexqGMUd7bMEQ/YBcfVYMTSMfPh2V3zZtfdw12n6EXmJZrftFAT?=
 =?us-ascii?Q?iWjypBRVnixcvhcxYwuEb5Phj+OntDI0SRWPTQl0cUAsw5qkM889qHAqZoSA?=
 =?us-ascii?Q?Zqib653mvMdqyALzwAlPN8BHsjDEqUoMgCGZhblhB7VNq1ao7n6h9RU4Ew1F?=
 =?us-ascii?Q?EX6Rlt97L9hyqataNwuIMR3mZnrBDf1moX5myWJpxEeVE32II0EEcWIdwzce?=
 =?us-ascii?Q?hI8j4Rt8uAZNrsZaujEo9XKtlkYEe43fsM309iDzTy3tbE05aXTR7/Ap4NYB?=
 =?us-ascii?Q?suMyWES8xqo4AlHgNojLMqAdQtr6oK55WncOoPdLPzWeD0aqSD9cALopbNSo?=
 =?us-ascii?Q?HjPbSO0WuAVB6pNBEoXgbfw/dTfb5ofIPeEzm5wI1XQB1REPBAdX7iN3VIoM?=
 =?us-ascii?Q?kA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814985bd-845b-4b3e-d040-08db096a06d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 00:18:38.8956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dXtrUYOzaM8vdt6Dgs7V7DCYqr6mZXTGZafrxadeIKsw0b5LJYjadk8HEh8JkezQtjul2SeOdF/EHPxhTmU9bpRq4gn8zRqdiIByXrX009s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1953
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, February 7, 2023 11:55 =
AM
>=20
> On Tue, Feb 07, 2023 at 07:48:06PM +0000, Michael Kelley (LINUX) wrote:
> > From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, February 7, 2023 11=
:33 AM
> > >
> > > On Tue, Feb 07, 2023 at 07:01:25PM +0000, Michael Kelley (LINUX) wrot=
e:
> > > > Unless there are objections, I'll go with CC_ATTR_PARAVISOR_DEVICES=
,
> > >
> > > What does "DEVICES" mean in this context?
> > >
> > > You need to think about !virt people too who are already confused by =
the
> > > word "paravisor". :-)
> > >
> >
> > Maybe I misunderstood your previous comment about "Either 1".   We can
> > avoid "PARAVISOR" entirely by going with two attributes:
>=20
> No, I'm fine with CC_ATTR_PARAVISOR. Why would you have to have
> CC_ATTR_PARAVISOR_DEVICES? I.e., the string "_DEVICES" appended after
> "PARAVISOR". Isn't CC_ATTR_PARAVISOR enough?
>=20

Dave --

In v2 of this patch series, you had concerns about CC_ATTR_PARAVISOR being =
too
generic. [1]   After some back-and-forth discussion in this thread, Boris i=
s back to
preferring it.   Can you live with CC_ATTR_PARAVISOR?  Just trying to reach
consensus ...=20

Michael

[1]   https://lore.kernel.org/linux-hyperv/Y258BO8ohVtVZvSH@liuwe-devbox-de=
bian-v2/T/#m593853d8094453ad3f1a5552dad995ccc6c019b2
