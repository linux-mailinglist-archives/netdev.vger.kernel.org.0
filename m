Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116F16E4001
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjDQGnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjDQGnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:43:43 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2082.outbound.protection.outlook.com [40.107.249.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26671131;
        Sun, 16 Apr 2023 23:43:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSaLm1mwvJ4twTWT1cAlTutR4krqDakEx/F5aEEFy4UPBJW/U0v/bLEroILyKCq6qfRe79UwLcjPk53zA+HexoFxdTa5oHFyAWIWVVNUeUqO8qTgKLlTHUJaXrT4Cur8LYvSxyzniFYJi9WZ7+k9vjDWpLE6ga+G1yJJVtoQqW3kILfk+Xb9v4LM3CDi0QA1r5AAuP90TGh7SK2EnUvw0RHxR5wwO40gu0Mm+id/7aKjwfMgoWbazdOvamcfRBcjI5Z49lAsktjN78yqPyFMRWDL0pRhg2oKqNHljWyrAmbofBf6i0r7h1kTJv1h8sIKNXd3wcrSifp+HzFDJYx4Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4G+Kp1TGckcVkEBCgt5mBIdtxaN9uAuPw1NF7VQTi+o=;
 b=G8F4oSEYFcpMUaaWjRvy7tiDHiXRIcElZY9TaQTulTLx9wWaJhuaVvAvKl2Tc3qX+1zf5q+W6ndvbVNUlL7x/BHmVrF8rARh/lDxJkutel5qXwv8JUEN3DWCzQK2K/EiTNBZ3GVRghDtWIk4maSegMwGlcWplDY5SgA+hmA0UyiFHU6P1lzxiDUcW7tAmx28S/GhdKwwMVqE+MBloIWgBB9yucxA5kpldnso0fMXB+9fRo3Xh44TVS7QgbXyaDaRkYRvEGn3J4DfPrYEWxywDKzoRu1wY2FZmzwXnVd0nec8rUWIB5UDrC063ZfCPtfjQcnhcc5zQQkCMOX/mqPiiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4G+Kp1TGckcVkEBCgt5mBIdtxaN9uAuPw1NF7VQTi+o=;
 b=iTrdDzdB9dl2N7KscB0yqxdGHRZio944xfLIASLttfx6sHMv16tpRQe6i9U9VLp+9BRY2uUm2idLReXX4scWcwom7ip/IEu3LdVlf/zS9ZmHjZgOvYhdgqxaSsTnyMryAC3+Gt1ZynsWCichjlW4qJ8S6IszCddskn+qFwfAejU=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AM9PR04MB8384.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 06:43:39 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 06:43:39 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Thread-Topic: [PATCH net] virtio-net: reject small vring sizes
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uZkiAgACnyXQ=
Date:   Mon, 17 Apr 2023 06:43:39 +0000
Message-ID: <AM0PR04MB4723F658DCBF66632A74592BD49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <20230416163751-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230416163751-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AM9PR04MB8384:EE_
x-ms-office365-filtering-correlation-id: 45d9d39b-c80e-42a2-614f-08db3f0f13fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6U2EK3Zt3l+ZmdxvwobjWWpuFslz7OQMQwAKh2QMyRrgr+5Rv+RL+5LL0ut8rSY8YgZ7dTMXK1jV7vPMs9F6LRufHKrRsn0HEzQTw3eZnI5AliazMYnz5Rd+KfmJb/lH7IGhbVMDfpDh3TpMECP1tuPvfXzohqaEoter86J5D8Wua9oTwfnh6AQOU8qgbuoAWeVMJ6JivXcWa17MSLUh8V4iv+V+MLw8DJnUaZsvJ8N8JJbyJYdHXTd9q8GzGuvgVddgME7ZZ4s0mk88YiWVnHDF8StjqNnvLQD+wtETQ5okvA5Pi1aXT9hnfktr0QGEz3bdY2GTHMqZH+fFLDA+aEZWghZ4Y4ckqN6y6MLdtRx7IIo4zzmgawFRFRQ8l1QD1XasBbJgd0pVq8Pk/KMrOq60mjEtG4a14JZEFVfKYWj72eAWyiMWyzVPp/CAC1F7WwwTryuxl7zee3v6HG3NmemW7ZQ7XScZJ9t3NLbaFneE25ctgXGaA8G8YpJv9nwqeqlf/NlUQawAIXVVUGV2T7AkvjDg5wYVtGaLOSawGMtZmM8CFwLag+C0WwWK6ZtGwg+U8XcOK/CsH1H2Ni8RPz7O7AvmQCGGfu2e5t5gtwQCL4c7tdJiqSfXzFt5TQzH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(136003)(39840400004)(346002)(451199021)(54906003)(55016003)(7696005)(71200400001)(478600001)(41300700001)(316002)(83380400001)(91956017)(6916009)(4326008)(64756008)(66556008)(186003)(66446008)(26005)(6506007)(9686003)(66946007)(66476007)(76116006)(52536014)(5660300002)(44832011)(4744005)(2906002)(8936002)(8676002)(38100700002)(38070700005)(122000001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?eGLgcah2P17N2gPSRDkenlAVbbFVk4LbiDqhswLHb+ta5FBGMaofeY4hZL?=
 =?iso-8859-1?Q?5PrFmv0GBwGF9Ws9mnTMoWFvvPr52u0My36QRjotEjgnyUD2M0WrnEU6dU?=
 =?iso-8859-1?Q?wOwkAmaTRheBAGrXiP6idyMMVqFKXHMwdPvdLYp97RED4k5dZgebZEKL8G?=
 =?iso-8859-1?Q?G8zwxVQTdxPwu21MX5ZTWJ8ha1Bid/6UIzFmk8ZJXItTcIiHqXcSA+ho12?=
 =?iso-8859-1?Q?YTomNSbpUahLPkOKWvwfnGGrQv3sUc7bTU6JyEz5g7c/mEJT0dZQmd7KmJ?=
 =?iso-8859-1?Q?u1KYxqYtgCggndn0XgynTcturJKfXSjejwrqlA3RUPednkUTi0+lz7MygK?=
 =?iso-8859-1?Q?oec4h8qdx/kTZ8rrQDjH9K/0+L5EDnuoJeAzGj5TnIA4BGvXvt6gBTACvr?=
 =?iso-8859-1?Q?E7Q5h067IvO1umPp5n/xSd7shIEjJssS54rPS1OrxFUKHWGLYwrts30kGp?=
 =?iso-8859-1?Q?aRqRSPtoC7cBsDOm/ESq3QbyAOfcj4Nv+Y/ea4MJKvYJXF9o8RL+ZuVtcW?=
 =?iso-8859-1?Q?/ay8DxWDIJiwQ6cF3C0ab2QcBplpK0tx8znV/RSZ2vEscHwcRkVh/7q9VT?=
 =?iso-8859-1?Q?FgckciVtDKE63xhpXPp0Tx0DGuAq5Ja5QAmkTHwSWy/GGylk6U1ntpLgVP?=
 =?iso-8859-1?Q?z9YLFWXGhYE9ia7b5Bx3dfK+ErSZ3aKDEWp6QK2epQ+3CVsFLyt8Ab4gE1?=
 =?iso-8859-1?Q?ZuqHxLZ0pqQrzlVfbul5AExULkIhuO245vQR+ntibUZSGTV3Gz7w73TGA8?=
 =?iso-8859-1?Q?9p7vZ7XiUbVWY78m7x8CAPfuTX1O69LWz/CjoKaA/5Xx4f8j9bYn2kWocB?=
 =?iso-8859-1?Q?G+jq6uD/sYIw9uhfqvlSZg1cI/sRMxZVfUxPYXzQdjCYZD2JwUothG67az?=
 =?iso-8859-1?Q?T4w/C/lrnQbWe9btZ/Jb9EzIaMeFqniZ0Wi0GvFYpuDA26ubGZcfD3mOyy?=
 =?iso-8859-1?Q?x9INQfniDhg52wjNMpfsmZcexIHlbL3l3bszb74lTQH4pF6SanzuOM6998?=
 =?iso-8859-1?Q?xiIu7EzYZ9jRexiOqcmcJhGmZD5TLvSWE3hBL/CH9OnHDGKZJ+zJThvvuU?=
 =?iso-8859-1?Q?d3Uv6Bm2T35NXyJ7/f00hNA7LPrTH30GuJQRMmtfQxjL7vl1lbqMY1ih4D?=
 =?iso-8859-1?Q?OwCqz/QwyTo4BAGapLn0PMKD4Wng7i1aRXGgF1bJLxyVzSBxwUb9GP+Twg?=
 =?iso-8859-1?Q?1rQ6T01moPxKaOhjwdqWa2hEl8jKxaodMXulwov1qQH03rVBFh7+gMuL+b?=
 =?iso-8859-1?Q?B1o4Av3sGQHnGv4Z09RNKyIMFvEOw7xsgDBVIY0NIMxM+G7zCIKVQfBfIH?=
 =?iso-8859-1?Q?fZ1EIPagKAgtEbyT9MR4p0SA8c4QC/fsAiecvP94V6ZgVlUcGjbxDy2pTg?=
 =?iso-8859-1?Q?YIVNdKCMvZAUpzUmrNwWvVGX90vBEBbdRC8zzayNrVJ9elzEsRTmRRUjiP?=
 =?iso-8859-1?Q?hKq94WPIRH1VLaHK3dJ/pLXMSbj76sDwBWUV8/AdPIuLXboPau5dD2pmmW?=
 =?iso-8859-1?Q?2RDDTq+f65ara3V7lcqOCpPxtWy6uXP9JFHSFADA4zAJlZq9AA8fFBv2Tw?=
 =?iso-8859-1?Q?rAde5qK4ZwpjB4MIAcrXAh8V5PcoTc0piUXCeEfPYHjNbkMJ2QhakDRvsp?=
 =?iso-8859-1?Q?DggCBA03k0M6EFAAnR1U0LQR51bvINrdFI?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d9d39b-c80e-42a2-614f-08db3f0f13fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 06:43:39.5130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ps2K2I6HP3ns+vAFHFun3tLpGQOhATn0I2zG6JAU0gThC0ep4hIS2sRHk3XU4wtAbN4KEyKgdmLA5AtvOCINYMT+EdZYGF+lTOG5eccwF70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8384
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int virtnet_validate_vqs(struct virtnet_info *vi)=0A=
> > +{=0A=
> > +     u32 i, min_size =3D roundup_pow_of_two(MAX_SKB_FRAGS + 2);=0A=
> =0A=
> why power of two?=0A=
=0A=
The ring size is always a power of 2, so checking against MAX_SKB_FRAGS + 2=
 or against roundup_pow_of_two will result in the same, and I think that pr=
inting the warning with the actual min value is more helpful.=0A=
I can check the condition against MAX_SKB_FRAGS + 2, and print the rounded =
value in case of an error.=0A=
