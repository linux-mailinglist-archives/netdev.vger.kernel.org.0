Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672176CF689
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 00:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjC2Wma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 18:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjC2Wm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 18:42:29 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2120.outbound.protection.outlook.com [40.107.100.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8B7E5;
        Wed, 29 Mar 2023 15:42:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2jjQitQC1FY3ijl9S9lOyxhJuAAxpEd9hogaj2rQ/zFUIutk7FSo9KhV6F7UWbI72U3q/bDCVWNLTZBlg00kG22opBPUhim37ih+ORg+7H5YRxviYCAp5Wj6TLwuTqGTSsxXCPI/O62L4EzVaL68bdNJ9dB5Y8Apil7kkF3aLPG5QnuMOTF+krc9XXMs0fQCFZCTintp/tZ7Rc/TIVOBZyJq/JgClpVXs9g1AHp1pA+tG5O5q85pQtoin1+jJg0F7lZeBEuwOx3hLGDe2Hkgsk0gMSOv2oWHClkmMY7p2PgK+KGkVpCLm192XzXEYtZrES5/0gb3BDyU+b2oUISOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2dLycVZ1hAMTiFfYaxmzm8nMaXG1DZoyQqgjaIuvpE=;
 b=nPQWGcmSzphEU7QEZpUzDiUhBAEv5T19IFZ0KYGA8oxcRpt7Hrr/zW8bOeMrDNjHiUIan5gLMPtC6WWzhB2UH7KY2iRvjF554fUH9tQm61M0Pp00dyxtocIC6mf8W84MKKoXSgPepzFnaVNBAdeHEntpa0uKnB3VSHM3Wo/L58kcN5ijvK1zipfP6x8Hj1RyU/nj4iynChaEjY9u9K88bhAf7xEA0ztD8sohMlbTSQV/6ORNqaSTsnYNgPfmAiD2YY+RO89pjJWbyDpboi+r1a7NYZ0ApcVpnzzr5A29QvPMgCbzI1qt5l2gSAfxlJj2ifJXjH0PuwNL6mdlgSDFpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2dLycVZ1hAMTiFfYaxmzm8nMaXG1DZoyQqgjaIuvpE=;
 b=cMrd0ksZC9+1RAGe+297aLNSDxmzNHv0Ug4lVSZS3GGRjv0PgNZ9DVc24Nc2ro0VDSzSVviOhBmqgYU0tFfDDsP0eatedG7LzwmROWn9qLmwjFEgWYWGDNrarJqhnUGSCqwm/i8uTyZvJ/fjHLxv0Iwu6It4VhX8tdxqpt89fYc=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by IA1PR21MB3400.namprd21.prod.outlook.com (2603:10b6:208:3e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Wed, 29 Mar
 2023 22:42:22 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6277.010; Wed, 29 Mar 2023
 22:42:22 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZYTE3Y7FHmXDCGE2Fxs3dSXPnlK8R+TMggABgSeA=
Date:   Wed, 29 Mar 2023 22:42:22 +0000
Message-ID: <SA1PR21MB1335C7F73F4921B4D8426AEABF899@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-7-decui@microsoft.com>
 <BYAPR21MB16882A3C717721090777D308D7899@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB16882A3C717721090777D308D7899@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c1c38967-f9ee-4864-a2bc-af561a32b5d8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-29T16:44:56Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|IA1PR21MB3400:EE_
x-ms-office365-filtering-correlation-id: f668c469-a152-43d7-e46e-08db30a6dcab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S8Zlf4ltaOssPUqK+bjyEuTeNJs9/jEInuegWvg9n8Hi3SydN8zCcfprY9Ry2joT7qqFplgOGon4Qxul8vTlp6pDUUSjo/Rwll70cs28Qtiq4AZVxkDok4TpfIl0T6Ak1i3T5sU64d8CKfCAZzcbUoKqUjAJbXx1iBbomUvQkc3/+3It2oybhD+Q92ajKmGQn0whPflaU50Jy0mFmeILbFBCo2t1hjF3etuOXzxO01evH3vSoXTVLLlnQUx9W6PB9cVu7yoDbbcCSyQcuAO7OAcq+xQ2HqlFL2S3oTBN3BFTWnmPyHPavYzwoTR+pVkp2IzRRp3dBXa6mGPuXCKMagTYy/LKijNuXACD/o8wMpFyNRrfEUp/Fy/FglyddtjpiPbDylxnKHS7hJGNKtSgp+u1jSkEZ4Gf2BHEx9dQU9RTefU8kOCKtKiMGCteMlHmLbqiBatgvTQlPbgba17dqGnTgYi2UWazpwfLIHRu7SBpgX3EDGNKTKBZqH3jLaTajP1r7XA/xFIGhcGn0xUHXhV0t6F9P/YGou8JShceXh6ZqrVEADqYaFYxo4TR0GodSxWQTmErEafeEfq2rJPulJ5uNV0cVn5yFJX2aQkiD6L9w+ZUDytqziLSwYPl+vk6hatA5pZoeNVNmqoWpnANds4jVOYFsSGl7WEenEZvAMMz+Ip/2EuqKUuia+JIc4R5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199021)(26005)(8990500004)(921005)(9686003)(86362001)(83380400001)(6506007)(71200400001)(38070700005)(33656002)(5660300002)(7416002)(82960400001)(2906002)(186003)(82950400001)(52536014)(8936002)(41300700001)(7696005)(478600001)(64756008)(55016003)(66946007)(66446008)(76116006)(66556008)(66476007)(10290500003)(54906003)(110136005)(786003)(316002)(8676002)(122000001)(38100700002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lzsOdHJlP/hdi2mKxKEZO/KRTnBnxMCLCJPbtsTGR2nwFVmS45c0rpJzGzQx?=
 =?us-ascii?Q?mr1yTcZeTYL7OfolbktpOCUdcyb43ozKTV8NjlTQnNvZUicvIgPirpL5KsUQ?=
 =?us-ascii?Q?vNJPiMUZoJjgDmGqKDElv34RjcAGM1FV7ZImtC37wHTv/onC6yXrR6ije4VH?=
 =?us-ascii?Q?IJH3fMzn62gK3OgXocVip7hXOg1mwvH8nee9SwhM3he6QgfQbLpRo9dHIccV?=
 =?us-ascii?Q?3GsgTx7pajuFvwmx8fxtX9tYiO6/w0wzWJqzifOnY/c/EM0LwVimAZmVMRbd?=
 =?us-ascii?Q?KhVvb0ARtYDekPA2synhQU2xS8Ep0lpoCUmUoQOQXtoaLKhPHvDEBuOt7dmg?=
 =?us-ascii?Q?MYQbBpOOeFZRl1/t5BjLGdt+I07CHTliUJoH+Eex/c34dmFngIRDFGFvPMKK?=
 =?us-ascii?Q?mZjShnXGiXBDIMLn1hf98MjzPncTZFa/O0wNcG3n+wupkey6kvaySY98qYNy?=
 =?us-ascii?Q?WL7PYtDuADk9mTBgYvRtRH3J1TJVmCvNk8IRADd2Jv0MzEXKOsAU9X5UyGm0?=
 =?us-ascii?Q?RUQyeWMxeFhKPPAfzR8qe4+0tmJwcEBgjVtkaQc26ScBJ1zClFlgUi1Jze9D?=
 =?us-ascii?Q?odx/GHMBS4pGolmHhFRk3nROwqQVvLU1Nxo96U9RC5y6XfpHEsvfyaHxtUid?=
 =?us-ascii?Q?JhccX48hj/E4B4GrLGsIP5OaV3obRMJQjLiHxFhIfMfVwSCaaeL9BcGtFDci?=
 =?us-ascii?Q?SmqIdlaqnkfHFYvWcJqG4qy6NG0ICRC0H8c/ACgu3gRVAjNhlroZc6OK9hQG?=
 =?us-ascii?Q?HI1R2SfD7CqZ8Zl0vv/A2s5p2HcK+lHAT1Eo3zTrmctM+/TtCW/T2NBlRurD?=
 =?us-ascii?Q?b3ebXi672UKzm7n+iWF2z/ck/Wn1NLx1du/VIT0CYJ6j/oP3ldgL5Ld+kh/y?=
 =?us-ascii?Q?tY+h7wRivELmvAKqp/e41+yEKH1hWKHLqWNDspkg7bv+6n2ZU3FlpV6GEUwU?=
 =?us-ascii?Q?whVhuFFHmhUFt7pBLZxBXSg1hGUDWlXezD0p4nr6fkM+NSPV2NTgJRpyTbO4?=
 =?us-ascii?Q?PpNSqC6XlvosFICsEXF6B72VIuUrxwvcZKnkAxln8iV1+HKAkVRs8WLROy/F?=
 =?us-ascii?Q?GzbnSz1cUh0aDpGpcbQjVRJmSK8EGckaykHZloAckEBEdp/hS8Xxk6eUtBGR?=
 =?us-ascii?Q?7VOcgiS4/2xD4vP52l++tjxWBnRtPStoxzBdmUdhf9MoPVPFp8RCBihCwRA1?=
 =?us-ascii?Q?mzidGp+dMT5GMbnaqssqLRVmVpRx0XgHK3VcBV4k5aenZHhRC6agSQvjSecb?=
 =?us-ascii?Q?rQYtHqB4jn7hA0gi9l+SgyMiaioqnQEqvMm0A38a6ek6G8BZIPrVOQ6/8HvA?=
 =?us-ascii?Q?Ml9+Tri1v/r5ywVgAA69gCM/j/hYR+Tq8gQKmUQLN8+faeMzYoAcue1/7spL?=
 =?us-ascii?Q?ENnQpwtI3EexpD04+kvieIiZ/dDzMz9wNhHPe9Q5bhcroB+3qrd6hWzbaBLe?=
 =?us-ascii?Q?ZYoY1RecM6vPzCbdVRwZfFqhcxq6FuJFJrpmudoAcKaSMjSTtwmCYEjzJCXq?=
 =?us-ascii?Q?1VwcP0IF64ElKfO7tchsIlkcccaOInnN68WlSsQJXv6t/d2vVIWk2n5dULgL?=
 =?us-ascii?Q?IQXClEiUxnlNm9fmP2YArg/g3hJndLV94RMkbEOC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f668c469-a152-43d7-e46e-08db30a6dcab
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 22:42:22.7777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uKbTw7xmrN1a3tMOqPWMGE0Bu7y2BtFVLp43CoyINuVOq/G/i/C7kbu8K+v6T4jV1+vCXoYBixDBeU0+cRe9HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3400
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Wednesday, March 29, 2023 9:55 AM
>=20
> From: Dexuan Cui <decui@microsoft.com>
> >
> > Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added the
> > pci_lock_rescan_remove() and pci_unlock_rescan_remove() to address the
> > race between create_root_hv_pci_bus() and hv_eject_device_work(), but i=
t
> > doesn't really work well.
> >
> > Now with hbus->state_lock and other fixes, the race is resolved, so
> > remove pci_{lock,unlock}_rescan_remove().
>=20
> Commit 414428c5da1c added the calls to pci_lock/unlock_rescan_remove()
> in both create_root_hv_pci_bus() and in hv_eject_device_work().  This
> patch removes the calls only in create_reboot_hv_pci_bus(), but leaves
> them in hv_eject_device_work(), in hv_pci_remove(), and in=20
> pci_devices_present_work().
> So evidently it is still needed to provide exclusion for other cases.  Pe=
rhaps
> your commit message could clarify that only the exclusion of
> create_root_hv_pci_bus() > is now superfluous because of the
> hbus->state_lock.  And commit 414428c5da1c > isn't fully reverted
> because evidently the lock is still needed in hv_eject_device_work().
>=20
> Michael

Thanks! I'll update the commit message in v2.
