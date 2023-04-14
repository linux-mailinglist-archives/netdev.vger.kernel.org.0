Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D6D6E1EBD
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjDNIsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjDNIsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:48:17 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2BC76A2;
        Fri, 14 Apr 2023 01:47:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8k7zV3ZqVYRcPe2+V4ziRMw5tDgKUV7c9Iwk2CvCNWz44WtZ4hBFcj7dBFonYA9S0+DS+4R3G1esf4XHLDlEGwHdw2lYwoTgk2S11BHr6fe01iCONk/EyVZ4/kcqOyJ8kB3GOmrQZzQc89ZC/0t2y7ZVB1yuQq9oYuNqJSCOaz5i9emWW6VbuHA8OMYglt6/LlABVZTxB0mzmxKrvKwONueE5zSsBkkexh87M7e4wXdDCXgThIGFkYlhzRnXhSSOePE9SbT2k3xvTMhyMdExt373ryjBWrOBigdAfxPLXzfK6O+Eal2j5PApwaAIGnbDHF2hEmWfqctcSH8k0YRSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuQmV7o/tKU7NpzAPDQ8pL7N8LAwx4boEKnf1Oj0n/Y=;
 b=DWW7DAfHlFzhRE/2fENIQv7F1jtekkHdaNcXhNxmlgC+0I74llKT7/xQyZbHRUMQpp6iYDyxyUwpfKAACFv/GCCilvBFKzL/urKISvtHkwxYW7Zk130zLCZ/bjeCkiJsw236V9+oMFO/dQLteZxQdjNtGALML8M61qAsgJe9/SqTEHFkkGxBzAYrZJm2w4+BIfLcCAzsLr/Cbvw0rPSIQaf3Uhf6eNylMtTB/6xnzBoM+Xsq5n47uZlyd2fj+JbedO3m6JNcBTMNyk1sZq7BFoRHbgb8iiiRDsIsf7eeWrjr2CV1SsfCs9W2uvy/K3uiP/cjA40bYEEi7W0KrcP8lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuQmV7o/tKU7NpzAPDQ8pL7N8LAwx4boEKnf1Oj0n/Y=;
 b=kJv5ySGzaKv2hXM4653UlF/SrN9N6mqoFJGJOZ1DJsL03sXk40zI/URzWqbpwVxE/8qGn94hN/hpJib1C+BSsDUk4mNr/hUodUHSXBQT8YBuFAZXLJ2cvjX/of4Xqd+rNePL41hjyg4PFHZ8ci8spdQTiVUmium8DhaXSGRFIGQ=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AS8PR04MB8499.eurprd04.prod.outlook.com (2603:10a6:20b:342::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 08:47:52 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 08:47:52 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v2 2/4] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Thread-Topic: [PATCH RFC net-next v2 2/4] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Thread-Index: AQHZbme/mkeJwnJnQEeCa96CX11wkK8qfbyJ
Date:   Fri, 14 Apr 2023 08:47:52 +0000
Message-ID: <AM0PR04MB47238453B33915D18F247ABBD4999@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AS8PR04MB8499:EE_
x-ms-office365-filtering-correlation-id: b7b0e732-4e7c-4bb3-4690-08db3cc4eefc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hqpDPxrr2SM5afTS+mVL7tdPRS0J5IWBHyROL5kXAzzfoeA5FahgkPMedSyGPDM7h6a+kqfuybpEHC0mgm+85Zceit7aS8EC704ZI01aP4BfEz7tKSTXavuyzkQU/9xTluHc1b4STKo0XuhM75oY9ycDpyxxi/Sq2K2BrsrWeiitOLZNisSu8ZU12aaHYcvdL/ldKV+39olDGPk6yxkgdnAvkCy3GeXknQLB/7JeWUMadXqXxguelkaFjHFjeLibxEm7NX6DsQ8R8WgIDkaxtyx1nCFRbXpjIZJjxvpS68g6+2ohY335Gd18eX0dO8KGg0Ku2BzaznUwK6VGk42DwopRL35dAvO4Y2zieYLYI86H6Y72l9B8AaDFA/35l2aVV7Tn19gqY7bXezFhQxOwaWlHT9ux0pNSDCPPCYkXuaWIvaFemDEMBLe712iAIrd3UBonigNRq5CbUgcRzFKCMMMGkC2mdDI7r9bZ9PE+J/pEskW/fCBjDE9UJjt/UzgO5D71THTktzHErny7tqRWE3Pr/VIjHooXIXj9xb1DJ7ax5uhHE3hK4lQ5nDj74qlzHZXTWvZoznMnt0I38vrQkdXYgGb2u0kGw9lfSBoAVk3rm7Nqpy2IDQYcXr6EgRzC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39840400004)(136003)(346002)(366004)(396003)(451199021)(38070700005)(9686003)(186003)(6506007)(54906003)(33656002)(478600001)(55016003)(110136005)(122000001)(921005)(2906002)(7416002)(8676002)(8936002)(4744005)(41300700001)(44832011)(5660300002)(52536014)(38100700002)(316002)(4326008)(66946007)(66556008)(91956017)(76116006)(66476007)(64756008)(66446008)(86362001)(966005)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Wy8Zkk4YikPeAcrnguQijUMqkW6wRFhib9sctXPbmJflq7GSuoh41c2kNE?=
 =?iso-8859-1?Q?abRK2zRsaBecPqOLNcFBsFMSVyOsxQyp+68kB8gqMqOgz8desF4M5PJBNp?=
 =?iso-8859-1?Q?R4TSuwQcdxFhiZQ9NjutQG8yVM1mfWjR/RRM+eqwp8E15HEEoGDaESuAnE?=
 =?iso-8859-1?Q?Rgpiy0rJmb5+lFtoPglBxvbbMcz81dIvFzkM2g0TH1juSRgqsiovkrOTWB?=
 =?iso-8859-1?Q?wCSSEXt73xphKbkHKBqmyPoSgh2uWPK61eEGgrxhvqtfbM2cQjm/TCTQtj?=
 =?iso-8859-1?Q?hzHWjly9k0XdpCZFcqrUiRbU20XpCn3LONCerqd07qKjKtYfqt7OgY3/Xd?=
 =?iso-8859-1?Q?hbY+oU3o9YD+Pi0C9E1dElJw8Fdz8CumJgUAwQqXUYXdf1WUihQKLKk8v8?=
 =?iso-8859-1?Q?47E8rO1IpOFn9HoZTvhc3/IECegzDXrkXk00PL5jwDv9I6JHnucDXdo1kp?=
 =?iso-8859-1?Q?ZUtc6AExcOAurZnrVbpilYNV5mJaPQmeM17dsIDCvFYyaXd7HTbHsOf9c9?=
 =?iso-8859-1?Q?md2QyHElRfROjcuj/5shl5pCzVvH5oacGC2/oeC9A4Yd1xhkyIxYMoa1rm?=
 =?iso-8859-1?Q?xmU/G568uaZ3QySXZ9LD/cMVGFOplp6cYBslFf0TZe2laKyhu4bNExk92z?=
 =?iso-8859-1?Q?XQy4T0FHDjKbvOciZ38QaUUhxNYDDfu6tRIYoFjbg2Mj4JdVSaDlVivLxg?=
 =?iso-8859-1?Q?Ar6GzCHlN12GJsuMLTh+qSaaV1DZwl3n2cHpcXUZvuuAo2y3U+lEreR01n?=
 =?iso-8859-1?Q?aboELXp87Fl+ykVmq87SHCOR8gtOPtbIIC/v4TN/jKeIJLpIoziKfTmn+X?=
 =?iso-8859-1?Q?5uYHTIp9PJNQI2P1k6icWP+UMaDM0beXw6+8babDEhsTWjbjoLhf7BTw5R?=
 =?iso-8859-1?Q?Qg0Tn/rQRE7oQ8QkbJs+/Zpl0XTdpw5e8+Y3Jt5fZFZQ+ZZ8c0A7Ub1PiM?=
 =?iso-8859-1?Q?maQFaTI0DkcyiCnhqUjZixmVTr6GC3A9VvwHrTAztzoHHGifc1To6DYX+X?=
 =?iso-8859-1?Q?A+TH06iwSwiNl9E/7k1/SYRewv/8tE2KeGNXp1esTxN4kenoDm4L5zvR91?=
 =?iso-8859-1?Q?iI3szK2Dh+0BYZehCw+7CsThvHI0UXhAOus8Jw5s9Z5RBQI3W/ogPnx4nS?=
 =?iso-8859-1?Q?TmVtawQCb86170IqhfA1XxoWydQHndD4ffb3OkTdvmzphVIVk9oHEsnu2C?=
 =?iso-8859-1?Q?G5LNOJntTv27Rv6mRG1jCmBCRE1hcwUOfDcTlaop8YYw7jSL1ZycGHQSUi?=
 =?iso-8859-1?Q?xWm77fAWNMCbn42fCgF16j9ht9857wEHExvOVvc98zf4QSgybcdbs63rjq?=
 =?iso-8859-1?Q?V0JWKp17X3bSLLAZNHoookNVHXePtZKGTYubBFmwnG0PrvOrNMwwr5oOkB?=
 =?iso-8859-1?Q?pkiXsq/WmlrK0TSNyLsjPT5b0R6HzN5+e+hCpM1XtjQe+u78YmwuTmEtXJ?=
 =?iso-8859-1?Q?dnwC0TNElCrarYSn2AcTJBCwd9u5/Pd58/upX2ocUjyzEXbieuF3aeg1gd?=
 =?iso-8859-1?Q?xGMWRSffiFhRB1rfghSFx7/LLe+4ar17HFEzTKWuQCTZYq0qNUHt7wvUh4?=
 =?iso-8859-1?Q?ZIF9/5B0WdbST2vQcGEQdRFb7I5/ZXtuBDWiVKy2MBKOIL7C0gSzYlDrKU?=
 =?iso-8859-1?Q?/AMjaYCjIn1sVwyjyoC2/rCf/wXuMX1ZTwSDk10NsEQDROu4Gx1bKFlxtO?=
 =?iso-8859-1?Q?+ujNEbDMcoc+LaIo4ukIIBNbiPEFmi8l/rTIzujr?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b0e732-4e7c-4bb3-4690-08db3cc4eefc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 08:47:52.3522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D7q7P4CgIRaFGYvscoad9nLNS6PGNgtTZJV1VLiDT5+UOI7qW/jbPS789znxC3T77bBacjBvEqlFG6iBerciEArd2CsJbgvWMxqaVBEoHGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8499
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bobby,=0A=
=0A=
>  /* The feature bitmap for virtio vsock */=0A=
>  #define VIRTIO_VSOCK_F_SEQPACKET       1       /* SOCK_SEQPACKET support=
ed */=0A=
> +#define VIRTIO_VSOCK_F_DGRAM           2       /* Host support dgram vso=
ck */=0A=
=0A=
Seems that bit 2 is already taken by VIRTIO_VSOCK_F_NO_IMPLIED_STREAM.=0A=
=0A=
https://github.com/oasis-tcs/virtio-spec/commit/26ed30ccb049fd51d6e20aad3de=
2807d678edb3a=0A=
