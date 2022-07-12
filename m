Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54490572A11
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 01:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiGLXql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 19:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGLXqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 19:46:39 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020017.outbound.protection.outlook.com [52.101.61.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F9FC051A;
        Tue, 12 Jul 2022 16:46:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yx3WTbaBy2FUD/GzPKChmU764cCw7xZDhlK5OmU7jWdKYx4afkY8twtnYlJ5nFeujp0VGXjvISSkii8Wd1uP1qLhw49pxd2yRkJ3qP9jiqSZMQsQimizzuvbcUarF5FUSOi2F3EGkOmvz4Rv8ScS7/Iijq7SVjEasMfDOr+DeP3Dn0DVUhzoxxLW4MXXCmVbI5hgZE7/k22TtHkQmYOcfj3OAQ6f2GaevjqYK4O5+FgZSdLDyjW3FNZ2jUCuKLjNZBzg/uj+qCJo+/UKPFLjvndAG6//Pn5B48pvxprRjTFt3RPOWYynYSoAzisLhn+AqEYF3dcw5YpUI4M28g1yHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eq7Tnr5tBKc3OL/a7Z2pIY5OWVWSw0negU7mFLQD7RI=;
 b=LFmEn2dEGMc1gfxFmNT5GvUuJKNezJs+UbjiMAKJArXjACR4Gcu3pgigTra9LV4Nn0B8AfRmrgHeAkoKWiWyWDLXVnvt+F6xX6AqpirXmuE94wyuB9YEbQ14Xz9y9Ad4du9GFxvP53vgzadwvUC7jtUbXtfdmtXSTmgjdeaBJvGBuwjx5Sh2Al6+sbIORLcIaThAVC5zbwjjdFoJ7xqREqGcD5qruvhHirTcB/NQ/0p0qD+CDs+1IHdT/Xj81b8jPbdukhtF7nUsC3lufwQhQl/xQADMNp/mooDcqemicLMJLiBUy8lHa7ABLjfT5YtpTdi3h7M9YA4sp6a5RlYErw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eq7Tnr5tBKc3OL/a7Z2pIY5OWVWSw0negU7mFLQD7RI=;
 b=PH6IzU/gLvcTzZ66PrBByfxNAmb4dpixH0rZI+u8Qd060jcotNCJuCUeKOfVtcqe2Qd1VV0ggRyYkC6XJDukwMtEl4TUqPu1RSFOqK9lsD02MsdyzgXhLCzY6HIuhd/p418o823kttO30S6GMQyK3Y4bYBG6ck/hKRwX0yKnmYo=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by MN0PR21MB3336.namprd21.prod.outlook.com (2603:10b6:208:37d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Tue, 12 Jul
 2022 23:46:36 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9%6]) with mapi id 15.20.5458.004; Tue, 12 Jul 2022
 23:46:36 +0000
From:   Long Li <longli@microsoft.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYgSXbjJmQZA89Xkq00e3L3Okxs617RQ+AgAAvyFA=
Date:   Tue, 12 Jul 2022 23:46:36 +0000
Message-ID: <PH7PR21MB32632A5DCB5EF60A4D599FC2CE869@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
 <Ys3IM6S3nbT0NFs0@kroah.com>
In-Reply-To: <Ys3IM6S3nbT0NFs0@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=24ba8f2f-38a1-4216-9ac1-d33d76791d2b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-12T22:05:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cd3f056-c243-45f8-f1a3-08da6460c23e
x-ms-traffictypediagnostic: MN0PR21MB3336:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IbWE7sq/KUQKDfcZMuyKGUpgXYgEF2qSqrLeF8maRxN1CBkSpXAHRSxRbeHv3MTVnqOuVbgjOddPaSCapMlw4d9Q/5b4FpOBzuur4rFBRPe/i/GJEkQpkowkZCkOw+B2qAPIJ/+kLcpEhalLykJMZcovkzYAYn2ebBkx190NnxBdnEmA8UshrVt+FSqhbd6cixkDP1l7XZDEO4Cyeiab1blgTmEDWcFTCKe7iTA4kB/1mSuhp9wl5GDZ0nbAn1Dm1DxJlfHkx3/Wo+q2HDke6n0xbPN0C5fR//bOz56N5pJLOnOG4RXKLWnXRQBEiaTPbn54lIncnci6XmjZsR1Obz8s52JUR7NI/5zica2p4DiV2eLu5T6J/z5GrpVKPCiSFsmtvo2C/FSTkLV6DfYQ6625adew3RisZuP45PbpueNAVe0p8m4BTTLR+qYnH2tvmejvo/Y2eJ5bvEztItRMtu4q/eRA2kdAwL7PXemnTR5tn158BICVSIZ696bIcJVzNDC44ZysGgcPA7r9sv4BWcG1sazsBOEdf4rYTN6DJ7Bj73s6uhyhOA1LvEVeGPGS5vHg809h8gfxkRpsgfS/i4eowjSeiVXAdQvRfXeqiuSRzOEddNHvbcmltHg+wSGyhtM/Th5Wg/ZyNiCryx2SL6+rYUNpZl2d90PxZcJ2RzK2vuX0Gxi0xiFUDCdOR3zBaL1yFXRdqcOv4mNmP7r4hgj6p7UywikxWqiTm6d6w2YbT3X60L/m10EbbarHjATJfV6BjJptYo/z/uZfFFwxCPcY9iMfmRyFavTAUId0LnOcn0t2d0wLLxZbI0IeQffYHplnowbkM2tvLB1N0fEW7fjQZsJHLrw0kAKfJ8zTU4pRhC+85GaUKKcOhjEinl/1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(47530400004)(451199009)(82960400001)(6506007)(82950400001)(8676002)(64756008)(10290500003)(66946007)(66446008)(66476007)(66556008)(71200400001)(54906003)(186003)(38070700005)(9686003)(4326008)(6916009)(76116006)(7696005)(478600001)(5660300002)(86362001)(38100700002)(2906002)(122000001)(8936002)(26005)(55016003)(8990500004)(316002)(4744005)(7416002)(33656002)(52536014)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PsQpdkMVf8OGVRxtTqdxpqQxpeFbJtv5M7UonozhlBghv1oQ1OGSdV7c3zTz?=
 =?us-ascii?Q?KQmtCpep3rqgx2jgZqA/2g4AtwX2bpNlhBgOz92cYP71wuXf/9aiiZHoaTbI?=
 =?us-ascii?Q?AWsQPFqbtw2dLK/N0XvemH1WEoKUBMJ4RsUdC3xoS8p7jmPh1nUMM2NH9JHr?=
 =?us-ascii?Q?3STeUZezbSesDILjlSokgb/sH5l9ljm7rC4W234EweWrH6+avNi0QuuGpHjt?=
 =?us-ascii?Q?6wn5kB17EKoiYySPhyFcaOKZ0VI7tBq61ux93oZgkZjuhUTbdEqOPc/CLy8a?=
 =?us-ascii?Q?D/rM1yvabu4D1UU3pPT+QIznLOve64eaAcU/npExMyfZv0XPGPPmnzAIeSDA?=
 =?us-ascii?Q?cuXFqZMkemk4Oyqbsq2V9nTcqZRpqVwmovv2SwBwhGkVStAr7v+dehB9Xaf/?=
 =?us-ascii?Q?dcpzOEFPCyN4m3C8ayFzpCn4yQGZ63/HsWgK4Vnmma9VNvzf/xeDyGqxIr+p?=
 =?us-ascii?Q?ZQC8gd4ftJLjPSCLw3MiwbbzHRD2NfI+VEeJ8DyC5iUGYp7LCN+QlzJ7dWKj?=
 =?us-ascii?Q?lRzX1yTGLIBY94BOvnJVN/fHkXOl91K3Dk+yQuQSIPnKH2vo23+epRAmxXgv?=
 =?us-ascii?Q?sSLCRj7KWwQ0IcLHUoueDK0zD5c8Ii9Gay5hmwbQi+ka6ziaRy1W/UyWkm4P?=
 =?us-ascii?Q?ilwI8jmBvsHlPi3EmwqfzMxEtWb0Y34IZLERJkGAH9w1E2OQi7FT8BMJkO3N?=
 =?us-ascii?Q?gCBLWI76lF2kX4GxKuDzbbR8iVaKNgfGHRYLsTUiHT7aFAG9Io4HFD/9gVGW?=
 =?us-ascii?Q?oyMxDG4CmHB62ltvjpoPQRTKM1b0eK7zXX/c9C8sQTKbsJnPk7gMeNUMX6Lr?=
 =?us-ascii?Q?y7P6D3YuCd+RY0GFCD9e7olgYCWXfvIp2HwRs/F6AWxEq0d4VnbTOEUs6rTF?=
 =?us-ascii?Q?olZsHs1+LUqvw5SL/MxAU1Hm+X1wYtx4Dz886hh2imcUnrFL4ay0k8AvynZi?=
 =?us-ascii?Q?9gJxQNulYVrvNyA6+0PPaDeULyx4NdQFoikjarfQER9tijDzeY7LulRWTZGY?=
 =?us-ascii?Q?nF1PN/eQQdJQ4H581bFpkAJ0dfiYnZudr9fITGmRvG/NbOsUTIaZ0+a7QDN+?=
 =?us-ascii?Q?IhgWPn4dgRdhrzF3OcuAXJsy0xFdBOi+c7tTSuC1PXosnzFf38dOrGGlMIL2?=
 =?us-ascii?Q?NGiEwlDrIbTgt/Kau5adjIt//IQEyybBiuqzQxEtwR+BZzwzcLNtjXgnvEUv?=
 =?us-ascii?Q?QoQP7ynbryv8GrUOT0NUYlSazETOkXN34AA0vWi/vu8s6m4ypCIpAA6kx0f7?=
 =?us-ascii?Q?Tx3UxyTQvqF4mXBUsD2/K0jzp2O1V+qIW2DADCnBUANN56pUgrVKFK6570D7?=
 =?us-ascii?Q?EHZ8UJJJ/vS+myNMMbqQElTwMq0cK1whjXq/DhQHd9kEAxVRjFreYEWCp+gp?=
 =?us-ascii?Q?041ULKKkFntbAgHsaFHyXNsFakKwy/35GDWUZELA2Jnqj/x/umVhvbHiazLa?=
 =?us-ascii?Q?fQ8s5SsMyCWDXZlxSxtmkcbIeyTTWCVWDHaU+5HW9dhvDWTyDaNjl8PppyDW?=
 =?us-ascii?Q?O12Ip3Y/7NztKQpMbWn3KuxW+lwgOHQdXHkzwtGsrCkpO5+f0WHYqCwwqtxi?=
 =?us-ascii?Q?rKgbWD7JDKa6gYPsveu4nL4xb8QXiyp1u77Tgtr5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd3f056-c243-45f8-f1a3-08da6460c23e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 23:46:36.4420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQ0eMtta447ooSZf+GFNn50IoW9IbgMj3GJGC8wDmY4kYZievWqxkbrtpkT1mU2zAib6Gx3DfGeMcbqn8LXTbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3336
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Az=
ure
> Network Adapter
>=20
> On Wed, Jun 15, 2022 at 07:07:20PM -0700, longli@linuxonhyperv.com wrote:
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/mana/cq.c
> > @@ -0,0 +1,80 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>=20
> Why perpetuate this mess that the OpenIB people created?  I thought that =
no
> new drivers were going to be added with this, why does this one need to h=
ave it
> as well if it is new?

I apologize for the incorrect license language. I followed other RDMA drive=
r's license terms but didn't' realized their licensing language is not up t=
o the standard.

The newly introduced EFA RDMA driver used the following license terms:
(drivers/infiniband/hw/efa/efa_main.c)
// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause

Is it acceptable that we use the same license terms?

Thanks,
Long
