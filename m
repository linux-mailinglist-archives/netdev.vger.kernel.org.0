Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217D76DB060
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjDGQOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjDGQOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:14:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71710A5CE;
        Fri,  7 Apr 2023 09:14:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1VYx8ZXTnaErrJcM/WSM1fvIHSrigH55N6Icqi5kLJyKyMa+SaItJ7mxJRbRkR/U+6TrdKRxLOh/dumk4YrvGW4X9IZh3qTqwKze0uHDPn/8irnlv/iVvrwymCNJrWVc7QaoYnSerhXUuiBWl6etG6FEpUcD2cWUBVYETZmqFJKKgk5L9EeGQ/Yhjxy2r5OmARBPRtoYTBQ7LZ0zsL96uMwtodh8XIzR9YS9LxBh3H2n99cxW32nNiq2+BPygzyIHT1bNAR6uaEQLXTrviubf+LnYZLr3i1gdClYBtpVcgimD/ruwsmAT7tePBWdUfZLr+uWY1vECa7J0+T6h4TmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ia4BmKg2SULcZS5fmSsXFx243m7uPVj3dpVBAwAxgV0=;
 b=aIWYqD5tVQ/WEukmV06kYVQ3B+DAKAOvfOljOUN5augZfmbRg17taldAvM9neXgaBz/tDhZfdK90/qKkX+NAinNoc2TZG7nPLltXA8MjSqMMRKAXPdkd7rsNymSZ2MGCNd1J20YLi2D2iRaakQZd1WRoQHpaSKEx1vmCN3K+D2/jy5vO2ZEXTo3d5h4XenOaGPBxfJNot1uoD2x6t7XNNVTaCnOJs7oNOhKeJm4nYHdjpdl2gOvfCp5m6zbBnLn3wHJZWq0Vox6S1k8lGiXS0Y2aiXLjt1uInQ4bSteLsS6x/pNE74Y5OnDTh5rXU9KZgU8iiUILZtQf5ngkdqFLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ia4BmKg2SULcZS5fmSsXFx243m7uPVj3dpVBAwAxgV0=;
 b=KGEZ+v3Kn7heBoTtRcOPaAVOSaKkdaB0ewdvNekbZUdOUUwvdndgGXpoTCTwWPgibs+vt3O9swDzWLU+TR8pSH0/QJbAGMRmsPNj118imLKMSkHKshR0ZBTnd/F+YJ5eOm0aUNwDoQ7fKLJSy4/NZyaFXMaZS1pqxjPVXujqsAU=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CH2PR21MB1397.namprd21.prod.outlook.com (2603:10b6:610:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 16:14:34 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 16:14:34 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
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
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH v2 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZZposgluJ48qtKkybpggwYjZPaq8gCcZggAAAu1A=
Date:   Fri, 7 Apr 2023 16:14:34 +0000
Message-ID: <BYAPR21MB168864316A9E2523BD74F270D7969@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230404020545.32359-1-decui@microsoft.com>
 <20230404020545.32359-7-decui@microsoft.com>
 <BYAPR21MB168842E38534BD00CB1D27ABD7969@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB168842E38534BD00CB1D27ABD7969@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4268d2ca-a28f-4b1b-ac19-612f0da0821a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-07T16:10:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CH2PR21MB1397:EE_
x-ms-office365-filtering-correlation-id: 153bae6e-1817-4ac1-179c-08db37832d6a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qI5hFKAAuUdOILrLnvl33smNqpuDXh0kejrntzsVNQt7pF5a+yz3tNCYFUFD8lb5BR205+IpOvEArCU0xB0NXrgAhUrw18G1KVd1j8Uj/8s/uF0BfKift3TwkO2ffevw9Y4yAaLiJblphQUqm8YoImwj7WbnzTkXxoK47o0gFMFAQrAbVIcAiiZcKb1P63AcD/g6khPg/M60SUGWWMA+yENZPSr2ZdPYx217mijNg0bFkbGVZy2a10Lc8g1yl4TJgCz8oZFFUVAWZHSl6ETVd4DfekzYwrzk6cvMLeySz/zj5RxjX4Gcc+3qYICTgOabXgWF85102V/9tu66zP+ochjS0cBnvPpG9iePitlJjK/iSH0M+LRjjbJSkjwY388pqUS7oQMockX/eueWQ+YkfOwZ0rfSQKCxBSIVzXQp+QR4qkOaBZrPtuHYs8RtW+UCmOVKkgNXSC0RWnJiaXwSYf59nppyR6TSgWOFpJma8hzyPWTIgUzSjOqiYjBkM+vImXO+Czk1h16T9wODHk48Z418coHsiC1uVwSBRrZBOIbfDcOBr68A00SVCSpLVmj/tDhrNUrT/7MP4y3vd1LkJQYon72nVyA9N3zetmIB1ICJgJYxglfG2j3SFlSe3h8lKgjD8bTKB80/0KmExG0RrIJHE8DYYl56KsDuRhYqWwjFOpHC/a6vpYByzZ46lW62
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(451199021)(86362001)(33656002)(316002)(110136005)(76116006)(786003)(41300700001)(8676002)(478600001)(4326008)(66446008)(64756008)(66946007)(7696005)(66476007)(66556008)(71200400001)(54906003)(8990500004)(55016003)(52536014)(5660300002)(7416002)(10290500003)(8936002)(2906002)(921005)(82950400001)(82960400001)(38100700002)(122000001)(2940100002)(38070700005)(186003)(9686003)(6506007)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yV39tILWDq+TqgfyxTWkG7hw9xFBsuwISxbJBpbkkiv8n0T6RXl56O2e2ert?=
 =?us-ascii?Q?IiReCJbg4H2hkQbRCha4kebjjeHWylg9o9gJP7wPY2f6a22Y61CKlFBchL0B?=
 =?us-ascii?Q?mA27rRQOJUn9grjHtbKo8GHDytwHkB3bhbTBSXZQIoHLfY1BBxphG4WZv9sm?=
 =?us-ascii?Q?ZXx9f1W3V3uZjGHbjT0AnJ1ZqhiaCEXGJclGeTXQM3kGptGG73bP61BdrJwx?=
 =?us-ascii?Q?NAknA2h2GMR7GklZxXIxpx1QpG4FAcvEOPURaICOfUhaNrD8cIzh3JACJmrJ?=
 =?us-ascii?Q?x3qAQNzcAuzraLedbSP7H5RRNUb2YA/xOTRth0X9oE4lS8aBJJxso3y8sLi4?=
 =?us-ascii?Q?Htk48yN3OmlTT4R4aQ8pIr1w+qKrKzxZOk2qmYAfAplfWtmhHxAKhZsJV7Ov?=
 =?us-ascii?Q?i9QPGap1V3eg6BrONZYqxfNEixzC2OaLhiEdH9F7cVtJ48THQnRB5BJU+lKH?=
 =?us-ascii?Q?WK4gjPK9sDK8H4lA52aS/vYtdr+3ecbd910uThdvR0rkcblfaekU94Qhb9uD?=
 =?us-ascii?Q?Nvgxz8sI8z0/Qdiu+WQAIYdxzGnBC3rBF25sMd4sA1IByZ1lRxLfnjdCpgHB?=
 =?us-ascii?Q?htPUIAIN91hF8kRZa6b8VZbqVBpqZT82Hlc9bPrRYXYUXorrxfEklg6KGAmI?=
 =?us-ascii?Q?IPVdfA08Y/i8q0N8eP6fZeA2QJ7UMxxpUY9ooVVC0Z/5CCVE2IK6Cemf0kxl?=
 =?us-ascii?Q?zKTd2I8R/KJGPn88fh8paAcb+h7iXVXUqTRRwtugNveVgrftK2YBMkUDf+yc?=
 =?us-ascii?Q?Ar3vZpCe9kMQea+GyXiNTRuQA5ZLcqU9PZxP8RUeczVBrSqsQSsFZ0Uk+s8O?=
 =?us-ascii?Q?SZkoUGnzNTUXDe4CwcLHOv+WDQ4WO8ussKD+Xw9MzxBvKKbXnSRG6jiz2cei?=
 =?us-ascii?Q?D7nKJcHlLXSN+rjUlzI0wbiqN7qR/sUF3osXFPKR4B7D1JxcEoxRsMdRlf2Z?=
 =?us-ascii?Q?uLJuw0W0JCMpAsfenGtyoKTi3dxkXBX1uTErD62tKvatQRWHqDinQUoxQaei?=
 =?us-ascii?Q?X5QbeYRbws6om+IsiywPYgSfLiTwC/K10rQX3Yy8XrWD6zSfBPmMsuBtgJRb?=
 =?us-ascii?Q?DuLGgTuLQ8Wjj01QLnAlPBa6mhKq630k2yrnb9TXmtHTwIibn9vkbtjIYXTz?=
 =?us-ascii?Q?UkXt3g9CEiNFVOVgMomD1D0l2JNJE42+OyY+gwx2ykzTFKurykjIREq+BbPW?=
 =?us-ascii?Q?tcEY+iZbfYId4eaz5dhBRLBGSldwmXD5uwe/Ucr72lBc18ZSAZ9cfM/ndMlK?=
 =?us-ascii?Q?si9ROvISqhMIWAQpv4cIS36lXn0uKwAKCIjNFeKen9JWOWj8Jr5l5dgR+Afw?=
 =?us-ascii?Q?ux0drpP95bjQ/eGqHeCjK6CkzHJ7+h1lFfwgAfgebCE6GpN1dDvWcXtEuW5s?=
 =?us-ascii?Q?512wuzD0vKlIKXxYx6k6aljBFb3UyDVAD/Bjh1mEWsdYQiWsFHYsxQJWv8hH?=
 =?us-ascii?Q?feTLec5o2H7MoW/GQy+OmSLT2FW49YyB3a0iPcdU9HY6OXAQfnschWaG51rf?=
 =?us-ascii?Q?yUXJ4JwdNjtSCMWvsIH7eGbAD9+6GmyL7Bydb+RkC8VCvJMquAImQUHI/yBK?=
 =?us-ascii?Q?8TJVL5hPNcY+MRjz1vSVb+1QcltiQmDjcy3nWUlcFI9xoLBLRDL+AWZnsGPm?=
 =?us-ascii?Q?sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153bae6e-1817-4ac1-179c-08db37832d6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 16:14:34.5094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KVKEcn8SUyq4aKP84wIYcISiwtp8MZfPb0KXnHMG8V2Qp5IrJvA8nO6wCqIyWSS4gAGzrsG2QBNU9FAZy408N4pGVvVrzbGHaQ4lfTFxtek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1397
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Kelley (LINUX) <mikelley@microsoft.com> Sent: Friday, April 7=
, 2023 9:12 AM
>=20
> From: Dexuan Cui <decui@microsoft.com> Sent: Monday, April 3, 2023 7:06 P=
M
> >
> > Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
> > pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
> > create_root_hv_pci_bus() and in hv_eject_device_work() to address the
> > race between create_root_hv_pci_bus() and hv_eject_device_work(), but i=
t
> > turns that grubing the pci_rescan_remove_lock mutex is not enough:

There's some kind of spelling error or typo above.  Should "grubing" be
"grabbing"?  Or did you intend something else?

Michael


> > refer to the earlier fix "PCI: hv: Add a per-bus mutex state_lock".
> >
> > Now with hbus->state_lock and other fixes, the race is resolved, so
> > remove pci_{lock,unlock}_rescan_remove() in create_root_hv_pci_bus():
> > this removes the serialization in hv_pci_probe() and hence allows
> > async-probing (PROBE_PREFER_ASYNCHRONOUS) to work.
> >
> > Add the async-probing flag to hv_pci_drv.
> >
> > pci_{lock,unlock}_rescan_remove() in hv_eject_device_work() and in
> > hv_pci_remove() are still kept: according to the comment before
> > drivers/pci/probe.c: static DEFINE_MUTEX(pci_rescan_remove_lock),
> > "PCI device removal routines should always be executed under this mutex=
".
> >
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > Cc: stable@vger.kernel.org
