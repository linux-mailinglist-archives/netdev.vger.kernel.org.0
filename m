Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1A06CB625
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 07:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjC1FjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 01:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjC1FjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 01:39:03 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020016.outbound.protection.outlook.com [52.101.61.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050FF2685;
        Mon, 27 Mar 2023 22:39:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpsS9pLjcHn++vOsewQ9sbwnfhmA7FgJNnR2yGR3SV0DSXmji8sW2GzptKBzc8F0XrCmuqF0+JiV5PsrIJfU2HHKafNPaqoGkR9i7RwuqVbyESKM/PI1+5lmP5BfuaJ8RekicpMS6I/ILSgm64acP793I7jvZTQIVySYPFFEn3n9SL/hu+9heJQGP/TMat5AiJQqgVvkTw3t3N5MHvWRHAj7HzNZmL/IB2f1VDybJCFkAbPBbQ1eBg+SV6RuqJCjgwRnIWipQ275mw6fJDJfyBKtAD3LDKVH40sYci6TJZKe3xenlqlUYZqV0kTtXrK1/SCoAAbL4PzgffBqCJpjXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pse6oqGPGZ1zPD1gcIKd7v9UBwzkToQk3+ikLFzcyIc=;
 b=JVczqWmTEIe84SSgep7jQPiCIEhHyzWMxmDUuMVjnCOWNmD9JG1WZFJy2PpIC0R2JRFXqt1fcbG9YFq3C74QPlaeV6dHFcyZzH0rvrI7Bf6Wdrf+boTXuQoYmgY9NQbBqfYVD270zn2EIXAeZgzB7e6YMxzLa1yeyTAwlTm7UTg0VqPcbhWNkCq0XPkiYZInIZczE1RSJ0XLKWFuErpVMO27rS/kXTxQaKnaSxXHPbPJq7WCqh3R+xhZvuicKIKiJhQ+/woWpntLr0S7KzNoiQRyjinEcQQTz0Somob2wSUe4Nh6CtKOM2h5unxhUH98HeYohd8QA8Zd+lAgwxcdmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pse6oqGPGZ1zPD1gcIKd7v9UBwzkToQk3+ikLFzcyIc=;
 b=AhZhpk2LeAOPxK8zz80OvAJAbtTho9vbgj/tuxdH0DeKw7WV+6XcoiKaFKLYWoOoMW+G15DyfnPwE32sjhUqn1MYPXRZvn0i9kQH76M9olICPCqgjc6bMueMQwQe5JN9OWYFgCDHuiutH9WOtZeLSbWcvh7OUTpAu7nQaZtK0Oc=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by PH7PR21MB3358.namprd21.prod.outlook.com (2603:10b6:510:1de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 05:38:59 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6277.006; Tue, 28 Mar 2023
 05:38:59 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Saurabh Singh Sengar <ssengar@microsoft.com>,
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
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
Subject: RE: [EXTERNAL] [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Topic: [EXTERNAL] [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Index: AQHZYTE8ycJYvqlEuU6bxR9LLTVmZa8PqarwgAABRpA=
Date:   Tue, 28 Mar 2023 05:38:59 +0000
Message-ID: <SA1PR21MB133553326FBAD376DE9DB48ABF889@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-2-decui@microsoft.com>
 <PUZP153MB0749F39A34DEC9FABE17C615BE889@PUZP153MB0749.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PUZP153MB0749F39A34DEC9FABE17C615BE889@PUZP153MB0749.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5d1d925f-e8b4-40db-8d9d-c9f4d2e55f0d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-28T05:27:45Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|PH7PR21MB3358:EE_
x-ms-office365-filtering-correlation-id: 1f0fc65f-ae04-4389-d3cf-08db2f4ebb02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 45aI6MPtioyxbQtXoulhl78GF+qT15gb8FPRHyTSM6fIVQ9+RDswGtgQ/+H3Q43yGphCBEyHyYtxImL6hEl/cl+MLeCfBP71Pv0R/XZ+ypH5US/UY/wdcahQP6QWNJjV4xfWSXyh2KTK4qBWGKoae2kGyUxRpLuijloZH/NnWbm3vWnKdvs3P7OlkxZH0Vh39VBtCH1qjQTavZ6myaonnPtg7vUsx6konLBRqeRKS93fP/kNb35ShSNICLN9o8WaXMfPkPi+bLaDlC58UZG7IgL7XcRPyMW+Veg9z8ChITKygM9VAZoYu691VfhW6kRl3hc3gQ9U3JjcA6r4acZYG0eFYM+2SCAsDNtMeYmLbO1cTc7Wjh7ieqUMdUrjpv6QT/pZbvhJnfTl4WKbUSOC4N8+sKa8QDKC1qJyKdbkSYJYprZiuqolFqAz0ZAFBSGlawMWfQT41hUK79JbQOJUTrDhshSWVckppZ3EC/GFxSCzP9BUM97rbblEwUDiKBWiSyDgwAbr3w5qayJjvkO6kONE27GxrIyVoVMgUSuCdpUz6GHWWZFDEIA2x7+HN8Qg2KnThpXY69ADJ+MDXuNS/VyLmCR4x0L/nhdI8ncO10jEeOHT213rzrogo6gSDUr98M8XqZVzVIgfzoDW/C0mDm5bwiiK5dBc20EsfTpN0RjYiOgDQoy76GIsBP3x3iOA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199021)(110136005)(54906003)(316002)(186003)(9686003)(6506007)(71200400001)(7696005)(4744005)(33656002)(122000001)(86362001)(478600001)(38100700002)(38070700005)(8990500004)(8936002)(5660300002)(7416002)(10290500003)(55016003)(82950400001)(76116006)(66946007)(82960400001)(921005)(64756008)(66446008)(66476007)(8676002)(4326008)(66556008)(41300700001)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O5bwjpFFQY2+F1HMNcE3f/VyU2veRRDbO4m1CDplL4/BMFNh1r0gz5M731rO?=
 =?us-ascii?Q?KTtdpxQZz/ocqardYT3RmXQ/M9GVRG4QeYRH89xx/ilLT7S+WAAa5k0YQYoO?=
 =?us-ascii?Q?E+Rot1U010VeaQs/9FfKtcFr3LCKCfTHbk+yYM4vGpEKeqMc2rXPhKQdIYQf?=
 =?us-ascii?Q?b3+DL3EI1hMdb5qBUzWTr/nUgrpDXT41cbxy4M6Q1HbrprPZDvZJ1lqnskHe?=
 =?us-ascii?Q?TDM/zyey5xY+Mg0H1++fHPhgDbV/5WT8KJ3S6AF4UCZSKv+rS3hBs722yCuJ?=
 =?us-ascii?Q?5lfvp4ugov1Ov/oIfuNhGdV/2gttfFV90pLKkCwKtU3kfZ+xYQ1TEFukCZLM?=
 =?us-ascii?Q?106CKxWmPsm69ebMo/xeK+TLaDYtIb553hXN3WHttXLMVnFx+VvrMfD1+aC6?=
 =?us-ascii?Q?os+I3dEpzoWVBlwmU6z0drMpeP5YgO2G9+7sN/D9fC8xBteo3DPCpsxOds65?=
 =?us-ascii?Q?Xrj9r2QgWLSviQuJzVhEaCauogq2pQXBfkVxil1YcfvB9bQt8q40aotGlmyM?=
 =?us-ascii?Q?YN27UIW+UIo4+uE1yB3JG/IJ7tpxUwYGXupj5QR0WU5FJ3ZwFD3y1O4GYjCC?=
 =?us-ascii?Q?PCjvBj5srbtObTdtl7FwEmub1rSu7s8wpqDvPv1QlxKUVQzjdo9rrKYiD8cd?=
 =?us-ascii?Q?nDcSus1/+uGgYRe2fLcsOeblBEf2blzuJUdwV50/Bi0xUSMbUg2UqlGjpZoq?=
 =?us-ascii?Q?mLmCahUgrg5YUJBCr+U05QxaQBbawPbzTDrU0dejYtEC1+ySYQFyf6pxMhyM?=
 =?us-ascii?Q?iZdwLoS9RxBBVMADCIl/uBh1eatJ6iDTEFnVbIguaN1njuFSHkIaIYcT/0cl?=
 =?us-ascii?Q?QCU9yphQSJcRDyfOCJY4EKRrQVV0qzfeSvCCEztNnOG7Wtiu7yVAfHaGw9ih?=
 =?us-ascii?Q?GKlPSUwcWDURUE5mQCZskwM7FQbe/xDNxWT9imOqrfzayKVn6voYWLuqgrd9?=
 =?us-ascii?Q?cpPz1jFXRqdZRCbpVuwk57IkNLS72kJR0VetxbSeR7wXbopq92RTH7DjtPz2?=
 =?us-ascii?Q?wkfRBFIADcosOvsZS/NLZwZE0SqvtXsAJSEbqkVwxfVz/CQVIlbRhfnfO0vm?=
 =?us-ascii?Q?jSPaKgGn6kTPqsGxcKYSzjupgZvvIUwMMj26ghyJJLU2MGXiBVHu9fkytaTQ?=
 =?us-ascii?Q?lyPa18HK+9eYiDjF4q3/Cdn4uNX8eIavYrels/hA2xPqNkJEZ4nBAiAsHxVl?=
 =?us-ascii?Q?WSxaHavekV8QwspziGRhKxIpWfIQmVTHiShw9ngw0dsAyd5O7VLlPdrVtfqR?=
 =?us-ascii?Q?yr1ff4qmtqB7mXS9xMKIqsLQp1NRRj3AmIjFpLfh3b761vJFndYpTUYlErEH?=
 =?us-ascii?Q?0i3CMKwPqW27RvvgWayPE6QLYCpLbZEgZUJc2bU+fKbLz9Rl766AU1lYz3/1?=
 =?us-ascii?Q?cVSIKZ9x5iy12i5tA9GKfG6+6LNR3ZkV2KoFqqZje/4VS8CvADWytTjeEpMt?=
 =?us-ascii?Q?F3B4XnNCi3Mq9bCpKSSQOjpUCKGWyHautSgDGPt9y48DinPf1fzCTOOev9ue?=
 =?us-ascii?Q?d4TZglL3Uyc2jlxvo7tW/9yGhN/d5KEfWlTO1O1ai98Tr40/W3ZX7V+efR3i?=
 =?us-ascii?Q?K54uX7O1Wjc0NR2WYmIIPE726wFpEnjFOB0g2moCe7rDsozIhVcdx3gIJduq?=
 =?us-ascii?Q?et1KdMFat1erpAayU3WvTJHPl15F3f2s9PrC6p9bH7tp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0fc65f-ae04-4389-d3cf-08db2f4ebb02
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 05:38:59.4122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBzsgqGaYvfpVL4v7+1C8vHfoOcnF4RnzEo4Ks+TiHbju344NljcRYgskkSAx4JRTPVOHIcr57xuJIe9nPtW+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3358
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Saurabh Singh Sengar <ssengar@microsoft.com>
> Sent: Monday, March 27, 2023 10:29 PM
> > ...
> > ---

Please note this special line "---".=20
Anything after the special line and before the line "diff --git" is discard=
ed
automaticaly by 'git' and 'patch'.=20

> >  drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > @@ -3635,6 +3641,8 @@ static int hv_pci_probe(struct hv_device *hdev,
> >
> >  retry:
> >  	ret =3D hv_pci_query_relations(hdev);
> > +	printk("hv_pci_query_relations() exited\n");
>=20
> Can we use pr_* or the appropriate KERN_<LEVEL> in all the printk(s).

This is not part of the real patch :-)
I just thought the debug code can help understand the issues
resolved by the patches.
I'll remove the debug code to avoid confusion if I need to post v2.
