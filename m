Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271506E31B2
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDOOJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOOJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:09:10 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021014.outbound.protection.outlook.com [52.101.62.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610CA35BB;
        Sat, 15 Apr 2023 07:09:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgcCidAI5SlqMvX1vVi84QGvYog2bm/5g2qcR0oEuXmo67q0m9NsWUy43+s9mLxPNOlBkxqRgFzmRuTwdcVyEsm+Oxi2nJL5SBiusmvTSJlv4UXTiDDr8jG07QRzKIs2nMr7ZwL/CRSidzqKB2eI5JHoQyIDxSkYeypZSggIwu7HP/6q8boUMMqY+n3hgi9aF9+gGD3978YbkpH5vwSmJiFjqrOZwZBVLzrKbc8STfdz55Jcw94i44qg2rp2I6JpItS0gDCVK8K6qCDRhXY06f7HebMyxXbl0nVvGYsHa4J2Juy5rUNQq490eB3WbGmdIBJz7yU8x2q5ljj8D3j+hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+IkorIVvKjEZYhTCdiQn1BN/dQ3+P6Y34xFb2iwcuQ=;
 b=mDHxKSUFWGdtrE9SyGIO6/oyVan00ohMvvql80yRyD/CeSNAUGhqwlJ5YyI0hESW7VBCDHcsuvNkYRhzeloClJxDHC4ZOS6y3t2kGbSUPThNkairzasxVVAp+ii36r3/V53cOQ41Xh8NKoIGUIkyCMq4kpbKh/PACyzgUYx6YId8RcyMEhgZSDB9Mhzceu6aRfBifNFZiDEfhs86ODbThiYw9/VZD2yl+oEUZE6T9w0LIVZX/YYGOZ8SSWKcpz53ee/jUlJCdXvxKz2+fQ6n2cg4WECh156voYW+vTFpYa8BKYTtPeGTbDuG5B8S6Sta3rBkeov2IBG9tGeLGQyFyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+IkorIVvKjEZYhTCdiQn1BN/dQ3+P6Y34xFb2iwcuQ=;
 b=ZcSgopaq58e8t0TtOaqus3enRXR7bFGCFFXK621Au2asBq4y1QTUAJJLI7Fj7Dzb13oth2cReNZdyFzwWo7EWRMXX2XQjAY/cBSaURzcxkcDRATzYz0UdUY73updwvcZgUwBX6ePvO9uJoi99XTkvEXcCW1NUDlf2zBemXlBiCo=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3179.namprd21.prod.outlook.com (2603:10b6:8:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Sat, 15 Apr
 2023 14:09:06 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5d8d:b97a:1064:cc65]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5d8d:b97a:1064:cc65%6]) with mapi id 15.20.6340.001; Sat, 15 Apr 2023
 14:09:06 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer allocation
 code to prepare for various MTU
Thread-Topic: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer
 allocation code to prepare for various MTU
Thread-Index: AQHZbYQujzvOlLV/4Ey68gIm6XL6d68rokUAgADJeQA=
Date:   Sat, 15 Apr 2023 14:09:06 +0000
Message-ID: <PH7PR21MB31169AA6B8BBB17C0144713ACA9E9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
        <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
 <20230414190446.719f651f@kernel.org>
In-Reply-To: <20230414190446.719f651f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=60c33190-8368-43ae-b481-d01483384e9f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-15T14:05:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3179:EE_
x-ms-office365-filtering-correlation-id: 206d27dd-8731-4f71-d398-08db3dbaf968
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Wpa6N6Bwdl4TcuBPD0f/pea9uhHHU/katWR9RdTJtl6TlROT/AtZ8aY7dIGvZcCaCbNN05SRjok8MgTIu7r/7VEWbHAR/q0M3dHPPuP4N6NV8xRr1F7nz7iSwR5f2im7EiF3foq1PooLFf4fuBvLE2rVHE79oiN6KcrfojdH85mH0V5ZT0wwUxz7fb1rQSS7TvoQP/k/ahNJd+f3sRm92wMtBUqFJQRRhPCrMcxlF9M5/juwyjsBVtWMGYrrQqgCdmBbYk7zTxGxiqtPkII1SlzB6Q70iFA4QAU1BXA1QTn7/JtEtjgX70V6xtN6JBpIJo7SQtAecmmku9d+puMKj7JY8jTXMlYZT66ZVqrnCh3/BItsTnWPVPqtJAB/Z6t3txDMH/zg5zIcJAjP/e1mVFmnzo0SU3gL7szLyrAgxzykjhHBL0DKparea/VezUoi7oYJvgMDsYPF5IaQ2d8RhmIO+9hz/gHmL89pqGBoM/HpYG60vyUhsIdmsVN+UC/F4TKJc2Ww/JmAKkDt01BUdV3+usM31e9th7028DMh4SpKjjePO5MLyV+cSE1oW9ngt7UekzczU/rpg05IOslPmYQLh2sGHZepIZcCYv+tylUvSSkG3j72MBJGKYZ/cT/IHQQ3vWZ7ORcBcQoqohbPWxdurwBCHxG3ErIuu0exLI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199021)(786003)(2906002)(6916009)(4326008)(86362001)(8936002)(41300700001)(38070700005)(8676002)(7696005)(76116006)(8990500004)(66946007)(64756008)(66476007)(66446008)(66556008)(7416002)(5660300002)(52536014)(122000001)(54906003)(82960400001)(82950400001)(316002)(10290500003)(478600001)(38100700002)(71200400001)(6506007)(55016003)(53546011)(9686003)(33656002)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0+BJDZ0j75D3nMjaQ7uF9ddKryFrK6c77K0UeMV1eLLCQnf3Q0IPLbG8ANmU?=
 =?us-ascii?Q?BDKre1fR7VjyscfMUkejWGhjDGekRQe5jk/3R7JtOiO1G/hLrayMA3P/3rPU?=
 =?us-ascii?Q?DPA6C3kkLikYbuUOWU/Xd1PnaE5CID1DYVIvwiqzSptAXHAuoosVXCVdm1LO?=
 =?us-ascii?Q?MOM8GWNjILm5De+gni3cLTu9Kr+K0GIWeyr7qXGespJ0lmAuYDDEMivaG1yV?=
 =?us-ascii?Q?GJNj0oN5oEtw3fm6mmg+S9kDMRIvq7DSABiQ10A67GpKqruHe6eTlqrckoqX?=
 =?us-ascii?Q?BH67tgi4iabtr+vXL9o1uTI7R64oj+dF4tCGN3kpw+PGnYmcAHFYD/XVWyS/?=
 =?us-ascii?Q?nwDxfnlqvRoZKhTEjWYkfjk9yFnIxIMDifY9CgSz3jy1EOQ1RnO8F6G0Pgel?=
 =?us-ascii?Q?AdcV9Jk9Pd5H/4hSUyOxOingh7+vQoVJJ7DAh7SXqnF+JrkrBDeQ8t0dEGZH?=
 =?us-ascii?Q?Wg2Gw5vFI3GdwS02tpb/VzKzKq9v14UwJ/DgsBG2mWg1IXmZpjqWEwC9bQfm?=
 =?us-ascii?Q?hP2qlNUQtiU2qQqE3rHKmQG3pfVenXBNV7V6KB7O5TUsTw8T3KpwXjjrr8Pj?=
 =?us-ascii?Q?nxdlEqTTYD0b9MdGZXlxgBGgh14sJLiH+U8dsciE77TAsne3BdzdvrfS6lD9?=
 =?us-ascii?Q?vmI6sIpt1GfKoEdqccoNQ1JoVO/itT59ZPQfkmonMxS8HexpK6g4OfJnhlDy?=
 =?us-ascii?Q?DFAp0h9SbBMZZjjiqC1LnGwdwzxOpNqPS2s3qLdrTbk1OkbQBqgl9CqwXBwz?=
 =?us-ascii?Q?nkkeJm0y9GGWYJ6ENtnV9RkP3Y3nBKOGyq1jrIaAqlg5doxKGqdM3wgZ7b+3?=
 =?us-ascii?Q?AnyyP1H3Z26bbtg3b64Qq1p+4K7vEQ+AdT/sJQfRwKTNfxtYs81cFntKKe+v?=
 =?us-ascii?Q?pAegPMoSKfYifU2E76NlGRyO8h1xDzr2sQzEW9y3o6posok2lxTLNsrpT69O?=
 =?us-ascii?Q?0WhflAhzxtcGwn6myZPyIjJ4i9s2ZFLCE6mHxXYtNqttvB7Fm4+6+k8B7m8L?=
 =?us-ascii?Q?3CM2D/vXTLBHDr1UQHj3it6naANdQzBB9JcDuZaTA2FSkjMDotTW5841WvZO?=
 =?us-ascii?Q?Ene8qp/XQoi4xFfK6rYWOH0MSH7bK4T+nUGUw1Wxn5KNvu6KYvD8zD1VjrYo?=
 =?us-ascii?Q?MzSe70V6gRnGVRpFvm6Q897dzmLm10yAt1efIFNK4ESC9EKzlSkumEJfUSHL?=
 =?us-ascii?Q?dwUVDFumWkKy9pYYBEfUyWVbWWMPUNVdYu0JU/fHZRMRPC93lNIsu0uf0pgk?=
 =?us-ascii?Q?zvu9zgk1UjzRdwWJR/Has0CTT++z5Uw2VuHtErcxRczODsKEEaZvlwX7NRdH?=
 =?us-ascii?Q?YXxsaKq2PPrPEpzGKyv+6Mnyfms7FhiQ7zzefITlpvOBHKjQxC/v55yFl6f1?=
 =?us-ascii?Q?2YYV4Cze8N9K107OO0bIpAPV6DnSMMC77FPwBwY+1aIZS/HV1v2OjNkVgMRi?=
 =?us-ascii?Q?J/nKjU53ohrTFdzez123hXBJQk/yL5558jobrt2E4BI714AkEY8ZPPU7h0zQ?=
 =?us-ascii?Q?+CR2m6uCxsJTHLxdgcM2030NHtMLggAJdaisGU68+QCN4B6qE4iPGkTgcjxP?=
 =?us-ascii?Q?TJMUWBNgfZkHKNyyezopriRZol9M0Hd++kkMVQRC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206d27dd-8731-4f71-d398-08db3dbaf968
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2023 14:09:06.0579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfM9Dd+HrQShWJqA0hCIUn+yQRUaESzwrgDRYytleB1qZMc2iCUrf4o4UcHsSxQA7oEWMKEkt5JvOeotIoOxMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, April 14, 2023 10:05 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> pabeni@redhat.com; leon@kernel.org; Long Li <longli@microsoft.com>;
> ssengar@linux.microsoft.com; linux-rdma@vger.kernel.org;
> daniel@iogearbox.net; john.fastabend@gmail.com; bpf@vger.kernel.org;
> ast@kernel.org; Ajay Sharma <sharmaajay@microsoft.com>;
> hawk@kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer alloc=
ation
> code to prepare for various MTU
>=20
> On Wed, 12 Apr 2023 14:16:01 -0700 Haiyang Zhang wrote:
> > +/* Allocate frag for rx buffer, and save the old buf */
> > +static void mana_refill_rxoob(struct device *dev, struct mana_rxq *rxq=
,
>=20
> The fill function is spelled with a _ between rx and oob,
> please be consistent.

Will do.
>=20
> > +			      struct mana_recv_buf_oob *rxoob, void
> **old_buf)
> > +{
> > +	dma_addr_t da;
> > +	void *va;
> > +
> > +	va =3D mana_get_rxfrag(rxq, dev, &da, true);
> > +
>=20
> no empty lines between function call and error check.
> Please fix this in all the code this patch set is touching.

Sure. Since the patch set is accepted, I will fix the empty lines
in a new patch.

Thanks,
- Haiyang
