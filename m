Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38A96F2A35
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 20:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjD3SPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 14:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjD3SPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 14:15:09 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EED410EF;
        Sun, 30 Apr 2023 11:15:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6RimzNE0E19Xmi6cnNmiIwu6Z/rePyr6IXKNyY6b/sJ7qc7OZZw3WlGXQffTWHs9dgPnrCtWLwWj6ytakDCqYtQ9YMKftEC8iqHJ1B4ok/pj4DhpFmw+KGTcVAAFgLFZl4jV+y8L0VTmAXve+NWYzmQlWsIhuAjf+LhqZ1zmvW7CMXoTlmVOwXpRV/ZH3EFA8DsgHRSZ5rPx0MiltVkI1hBkcuSCuUsfEvnWTcaxxO87g2PgfiURAS+IYrm7zYw5BavEbrw/UG7S7JZepkXtQ9RDZeqwg5PCsKIGKMwdPSDwg5jCI+cs9WGhKNUIC13dySzRljJPEX1NxclEyyKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+aB0rbqKpY0iHEyVxFI/Hv/KV9REEgPTcxR1KG/GS0=;
 b=Z6N9K+XoKZky5j9JcSjaAF8iLpSBxN3mAdqTQ+0zZjXMO7Jdswy+hd2nGzruqoX7VVduYLGjyc3rc0FUw3Nr6D2mjDRBsD5El0SgKLeHIJC3YJ0ynfyOMB8DpiLdez1+4PUm+zQ+OYuhWLPd9tV1Smo301rcGx7t/Hjevc6iDWyFqNqK8dOoCYtJwl0Ueqk+tAC4kolYCV+gddzLqVlNVC8FcCEVgIPcLo8qMFLj3Qd/wiMe4iQuGfzVXkIEmDhyk6JyjYjnBgkw2OUYd2QhPORQSs9ll2S09k2I6/Bx9Lr9HyxPC/iaCPNX3OunmX6OnBdmOdtIvyrNAYndySNnmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+aB0rbqKpY0iHEyVxFI/Hv/KV9REEgPTcxR1KG/GS0=;
 b=IhKAcIrN1SgJJ6M3AGnGWh7ihIAkIJns+GlHVLV43u/7XKc2hoQHeQzeNGJH1wNzkfP06i3O2kEJmi41xvIlc1wbiYwbNlK9YAAOAEt/ALCjZvrYlWRjHppaczMDQkT7HbksdBact4HWs+EunRag38cvoh0FwA9TfDW2UK6XQsA=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by DB8PR04MB7180.eurprd04.prod.outlook.com (2603:10a6:10:12c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.26; Sun, 30 Apr
 2023 18:15:03 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106%5]) with mapi id 15.20.6340.026; Sun, 30 Apr 2023
 18:15:03 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH net 0/3] virtio-net: allow usage of small vrings
Thread-Topic: [RFC PATCH net 0/3] virtio-net: allow usage of small vrings
Thread-Index: AQHZe2XUAgTluM5nJU6YPxcdS/aP2K9D4yuAgABAXH8=
Date:   Sun, 30 Apr 2023 18:15:03 +0000
Message-ID: <AM0PR04MB4723C479C388266434DE415ED4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430100535-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230430100535-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|DB8PR04MB7180:EE_
x-ms-office365-filtering-correlation-id: b22d48ba-eef2-4904-252f-08db49a6d1bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t5Za2ZmqJafiZbFfAH0GRgAL6l7aVdszskRaqNnIro3iRDKpVrHXo2asb1OAdCKeFY9vayK4eu+JUyc29PuDiFaQOY4/VgpTyj8feNKMkbt/YNn4RU0+vf2rIObLgcRL1DjhA+O5kAfmVRUkzjUFASLX+ikeVLSADZg+D0+RMwIomF16QVO/539LsPvXGTquH9jXVt2cHVFop3Qf0XIwar5CojbfcJgwh5L6LAYwZ+UpXAjjw+pQYLxtUMLZzwcfph2+hPxOj23z4nJJGog8bfbSQOCVREpf5McyYtmQKqn3qV5XJOhLVjeotvvEI6EATABdZmEfzlmzPdt8YAHoNUJQJs++ghGmzK6/7SBFBwWsKhk9xuYJofSipyGBxAfrG0G8x2DRQsU2eQ3k4RJggTAdi4RjZ9vw+x8B0/QwypGBNLP1cGUEeLTi1J6ViI4Q5FB+pNvQIzlQHoMbOCfd2aKP2EUh0UOdGrl2+MAfXvHqQsq+jdQlGPV9zPzxD9WHoqlZhZAjXyKW7pWvvTDWW1K2JZa5HNT6qSJ7mZGrFATihgUFHYxz4LjVG6Qha7bDmEIFizjhNm2Tn4yXmu47TO1IyhkNhsMjWibTa8h0Fe8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(376002)(39840400004)(136003)(451199021)(33656002)(38100700002)(5660300002)(7416002)(52536014)(44832011)(2906002)(4744005)(38070700005)(8676002)(8936002)(86362001)(55016003)(316002)(66476007)(66556008)(66946007)(76116006)(66446008)(64756008)(122000001)(41300700001)(4326008)(6916009)(91956017)(83380400001)(186003)(6506007)(54906003)(9686003)(478600001)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?mB81HHEImBwU1OUg8TDQIOUH1uVEz6YRMuATKUBAPtnEpegYVvvdwqdlgA?=
 =?iso-8859-1?Q?YA209LPNvTu9tE0jr6CZ7HbswPwi3Gn9Ujn/hMgOGI3ukQOnjvR8SJbU/i?=
 =?iso-8859-1?Q?YuMYisPCjF0ajFEL6eMv59K72OQ89zz1663+hRgeieH7A0zA5zxC8uniMm?=
 =?iso-8859-1?Q?6wnNhnwaVrrgSigLc0/kie7oH6KcfAwAANmY1XIDvXh/FV8Trlad90jaXB?=
 =?iso-8859-1?Q?8FvobSuaO3emYBOGss/JXgzG12bxDuv47qYonVVMCBrrrb6EZzkrKzWeTI?=
 =?iso-8859-1?Q?NPp9tHg6kEk1ZMqHeXUnkoRhuYM1ZkBNLgTeGkpSAde2QBTAA9u/ECVO24?=
 =?iso-8859-1?Q?KgiyAGSlvTSdYtJRiND0B7ma4pIx1hCJcu2KW8OUW1eR5TUzQsmJJOVm8V?=
 =?iso-8859-1?Q?UX1kgc9KMV7gBm+utADsD/YvQoZmRnvh2JBZ5qdI6pGxqmhMuFn1ytcpDP?=
 =?iso-8859-1?Q?KTjt13779QLtea/j5q5uJcehakHGvApO798lZ1jgggAAdklhU3UVUrgXfH?=
 =?iso-8859-1?Q?R+gLB3/11A0MnRj6LoBOS0gSSkgcO4/8P4c5J6z0/6NL8LPiU1qE3VE5Mn?=
 =?iso-8859-1?Q?lcxo5R0c91voHeY6QBqFEAxeS2OXCSCUbnx0XuHEAsRLUChoq0TShYDuva?=
 =?iso-8859-1?Q?zuE3RaBabDInlPPNVElbMFdLwdwTB5jkj+Pk7hq+7raIOCoteHVVWxzr+K?=
 =?iso-8859-1?Q?qx19l5BG8h4l8k8Vop198CIXaD8O8ozqbreFt+7HB3TzZ1kN91mbdUrDyt?=
 =?iso-8859-1?Q?JxxBOdTEiTQll4zWxyYK44f+4tzAYuCyRf7xk4XkPX/AwJ24D5afWaHbQj?=
 =?iso-8859-1?Q?E5iP3sLlvVH5lwRy3qgbxAUmvwPg2kNx4yh+Ok0O+8MgdjPeXZeQXnm5fg?=
 =?iso-8859-1?Q?eurVyjHqlaNI0TtjVsn5cE4hj6EMb3qgQ8Xxz/7X0yZh8i9KKunVnTLUtc?=
 =?iso-8859-1?Q?s7NpRcmANg8TRSOaU3E860hkVCCOltkdh6+dHj2hceBJPQkTuvTby9TQty?=
 =?iso-8859-1?Q?Gzg5+zCcRlzddDG8Zg0DJjIwIS9lEhNPgCEMudhXM7hLUuqfvj0HAWa8mg?=
 =?iso-8859-1?Q?n17L2B1gxPH7DmPD8FqCCnpUwpmFekB2WTwiGApILIeX3u4ZBbRhD7elvJ?=
 =?iso-8859-1?Q?Dj47//k9fFyzp+6NuieIE+lvna91clzfC5giML3GXcVbQYc3S0gU6wE4VM?=
 =?iso-8859-1?Q?baBMpwDCqrmEHink2RBoVhLJDqsnGdTFqhObZF/TbUeo4ifhdGPJPPfdAf?=
 =?iso-8859-1?Q?2OkT7SlQ6DLps31UkUDwpMgep9Ptt12Y4Pw7n0idlCSRdyT3Bu8Djwx0i+?=
 =?iso-8859-1?Q?uQYepqQvInOkAwpDwtwY/qL+hDjsn4Hw4NLIN64ldzQ8nlUsrYcNT14oN0?=
 =?iso-8859-1?Q?GEGE+XJXI54T0evRuKQOy4qx7tVD1ronA2JBLIizEPIufoyZ5TSw/nyO9U?=
 =?iso-8859-1?Q?tQ8L+vZ2TWzyN8QzcD0fGNMasJf5E1RP8QUMPDdsJ+835M3umZjhNNJHer?=
 =?iso-8859-1?Q?/by+04ua3lEwHDqHxvz3UCzfwxgaM/b79P+kTadmJOoLryfP64JMJTHb60?=
 =?iso-8859-1?Q?KzeyUjbuTE/QXkYP4up79U3qRnESlpGczRnktfqY8eaynrnBwg4iU86ngK?=
 =?iso-8859-1?Q?XSEfmxvazJtifSmJSSVrbzwvVb3PSQOeZUk7SkVifTrmLtDThkwK57lwGj?=
 =?iso-8859-1?Q?2sUGBQWEMhaQsH908Y7srGHzF86qqyOJ4v9NDxGLPwDxDYq60+Z1pUeSe5?=
 =?iso-8859-1?Q?LAUQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22d48ba-eef2-4904-252f-08db49a6d1bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2023 18:15:03.4546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2oyIetSwaqfLu3+X6zeff4E0RN32GwCfk785fQsUcCHHoILlvC3fD9ZFGE9BDjwhjQapKXnGC+nazO5MDZ6ipoy50UUn+sbnYmZvy6KPSUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7180
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> > This patchset follows a discussion in the mailing list [1].=0A=
> >=0A=
> > This fixes only part of the bug, rings with less than 4 entries won't=
=0A=
> > work.=0A=
> =0A=
> Why the difference?=0A=
> =0A=
=0A=
Because the RING_SIZE < 4 case requires much more adjustments.=0A=
=0A=
* We may need to squeeze the virtio header into the headroom.=0A=
* We may need to squeeze the GSO header into the headroom, or block the fea=
tures.=0A=
* At the moment, without NETIF_F_SG, we can receive a skb with 2 segments, =
we may need to reduce it to 1.=0A=
* We may need to change all the control commands, so class,  command and co=
mmand specific data will fit in a single segment.=0A=
* We may need to disable the control command and all the features depending=
 on it.=0A=
* We may need to disable NAPI?=0A=
=0A=
There may be more changes..=0A=
=0A=
I was thinking that it may be easier to start with the easier case RING_SIZ=
E >=3D 4, make sure everything is working fine, then send a follow up patch=
set with the required adjustments for RING_SIZE < 4.=0A=
