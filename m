Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA966E4121
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjDQHgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDQHgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:36:00 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1e::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D1D5BB3;
        Mon, 17 Apr 2023 00:34:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0amTUAoDGhJVV2IvgQDB9QdS75ZuvStM4cbi3+aB7WBwQiU4XTrftSwByx8BEnAklWzwPrYJKYGQeQXAAmg0rwCMD8NU28iaZrWiFiIuzaXE2e4o+aVkcZGKsDSyxpM7UXpssJaM7gSs5bks4j3R59F9Yi1svyJAEqQBdbYfH4eUdKXsilwYdxx5BVenEl9WpZAIf4z6u6AlZU4q0mUUJ/q3aUkct6PqMvkYNi5+UmGD32nPiK5GGEO3hL1//HlFfs3oFpOT9hahPjJdwP3i5SULgw4HM5UNTjxzIW0gM+MOoAm3Z57UM7SN5vdssVNVp8bAjGei7ic+G9k8UGkvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHH1UOp1kdHERDYPaKU16BISIii18fSin6jeUbEGdY8=;
 b=Cf/VyLqRGmrguFaM0MQbL25YOOFO4AwvONbSaESjtdoEDfqJGeZveXaraTV50RsGyuj+OiE03OUO67rDPyceiX50DwCqo8HrpppJ6zX4yF7XVq7DHBTWc0Gj03BJk/T8aJBSfgVfNII1HMcTw0OEixiyCLl0pgvNBK1nr6BUps6TUIupyoS1dkxLs0B4fxj59OCVDJhlzSIEbDuREbGknIZaPxchAGMRcfy9Ug8f7YnF0CP/1TXJJXulYQhwe2MAcX63+bxdjrWIKlOhvmhxj0FT6irZc0PRCJ1I7KU3QSPRs036ccLdSntSY7nf7wGGWLxI08auyUvF38eEF/QtNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHH1UOp1kdHERDYPaKU16BISIii18fSin6jeUbEGdY8=;
 b=qll58cOPbE2jFNpd123U9XYYGlmIcW4zJ1HSWgw4YmbEWcQn+V524/oKwt+LvMFvjJ5n0wrQKJdmCRlcwkZbuLrelG50wW1y5BCgKy5qmlAw1ZJ5jM9pRka5eAMO81RgbwmDA27ZQu5R/pCilX65IEMIBT4RlY+r0I8cUV18Vew=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by DU2PR04MB8840.eurprd04.prod.outlook.com (2603:10a6:10:2e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 07:33:58 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 07:33:58 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
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
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uIjT9gABGFgCAAG90AIAAMSwAgAABjzCAAARBAIAABATIgAAENICAAAM4Mw==
Date:   Mon, 17 Apr 2023 07:33:58 +0000
Message-ID: <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
 <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417030713-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230417030713-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|DU2PR04MB8840:EE_
x-ms-office365-filtering-correlation-id: e19b4be2-c3ab-42ca-ab39-08db3f161b48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VP7jBj0ZGSSF1pkKs03p/bc+06yuLdnRUKzOg/KgbgtARBUGU73UTXnP4L8r82+ax5V0iX5NCKG3aO7yVqrF8p0CjWwSKgT6S+wPrzXcckj8nFiD4bz4VG6WxjcGAb8YxILkdeLOLWv5BAshdEk79BPas7/9tzILM3MTplH9kMQD60OhVkE46O9nqB7p2vcND8sUfVWkAmS90nSjwq971YD95M+dpoCfgOowy5pIyuX4T7vjJsfV0+8nKqHYNJbd9rfD9A0alncfON+U22ICS1vue0jC8+L+PJXJBrpE9r943uRL2ZC9rWEzw4u1nR2tJ6JDWpdMq8N7NKEEjzgYfjKrWIu+Iq+mtEOj3grFNkbIlCN6xpiOjLAr9SUrEIMuJxdhzgseI7M/hYLdbs1ya0SjXR5/XriID/L2HxQFoDgBsAuJagjk2UmcFhUq82ebEgDpLpXSuccBv2o75rRUuG44ISJ4AME6glyx0o2vc8BwVG2Pm87XZHwZoG/aYX0u3osTkxA2cLnAOy6wpmupjmfyc4lY2B/fX/jJtlnICb8teLOMEcEIh87yGxmxOfvbxLzBpAguyIDrwJ7259hBLMLwf/Fwk8F0up34t54qCvMj++8KfL3+Dk1h1HZGhOUD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39840400004)(136003)(366004)(396003)(376002)(451199021)(55016003)(91956017)(66476007)(76116006)(66946007)(66556008)(66446008)(64756008)(6916009)(4326008)(478600001)(316002)(54906003)(5660300002)(52536014)(44832011)(8676002)(41300700001)(122000001)(8936002)(38100700002)(186003)(9686003)(71200400001)(7696005)(26005)(6506007)(33656002)(86362001)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?SZR4FT3691BVrjxka/bYA2FHv8ZTzKXzjSEqoZHp/oIfTjW3vLEEY9E1mB?=
 =?iso-8859-1?Q?4Si56Ykgi1WRYHHj73x7GiHvGT6GpcPKM3XGG8VbyQ/1q/mlB2TQztssh0?=
 =?iso-8859-1?Q?bNJHskNFL11XmFT5aKHExBuhUH1TSBfPUTSRJLKbx7Ww2aukpAfXFn0/ZY?=
 =?iso-8859-1?Q?tRjkahDsqISgv1mOeNNdpSHn/btIrfd1BoKRazAnA4fYHHwIBExFSUC1uF?=
 =?iso-8859-1?Q?ArjzVFCZfEb4U3Hzaz1tIHErbyErUfl3qCH+y1AQA+MRDc8BWAjjyFm0lJ?=
 =?iso-8859-1?Q?vhTqFPQXYGPK3cMzXKu9fQnlzTAWBmd2PN2ms/p2/Ubz7VxZv9WF2pAPcF?=
 =?iso-8859-1?Q?smJGb486xJCj7CTrKGGZaR0LCSHQNdrEuAQ1iDiPbZ+go5leSXK0E1ZSh5?=
 =?iso-8859-1?Q?IMCf9TlMnIBy7Dk1Iy31KwOh8p6Z2qxXQ4/5QeqoWBuCG7VWicBkXEz28x?=
 =?iso-8859-1?Q?G35zHIVq+Hl228cnF8aGdQV7TKQpn0A/8FncUtBbgeFZc3ZHT7LuMxpROF?=
 =?iso-8859-1?Q?tzHE3oOx09hPY5Z6xQAOf5Wh8BqQn6iBweBKF5BPJGe6zLbFTfD2o8gSwq?=
 =?iso-8859-1?Q?wcrOSuU58zgrfZRWCsYngsVo8TXK7gPaSKv+S6JPKDNuVRDgWVDXOcUevS?=
 =?iso-8859-1?Q?XFiYH/d+lWGFGLWDhuH2tB5HX3G1KZBqbvFd0xhw1EtYeOEBj1sjl2hws+?=
 =?iso-8859-1?Q?1ivNUw3wQiLYc3PILve6idGbvE6rYz8RNIeaDsTZtj3e13WEovyfDRauVy?=
 =?iso-8859-1?Q?nMv5V/n4IlWoyM8KRCdFMEkL60FoABz2TeCIUUnqkd/0C+M7vnF/MoOwAU?=
 =?iso-8859-1?Q?/BUbhzsZXsMjypUYqv6JixYoAtolZLrDXWq68aRLXhevwa8aXpq7mO4JbV?=
 =?iso-8859-1?Q?2p99D23R4sqOyorw9iZw0guJ78mO3YBhsOoDwTwzrgf0KCFEkglixXpG3y?=
 =?iso-8859-1?Q?FIq6bXaZXif13adnrXaOiK3SnrZlISV1Gz+mteAygUpbXJ2kF4VCQtoPqK?=
 =?iso-8859-1?Q?FuRAQe8eMAGDV7cqPkVCCbWKlfEcmw8lCPo/QuE3C8fIOaMSPENF6/Djpc?=
 =?iso-8859-1?Q?qj/yKCQmsVRoJAmOqgjXewAEXtJP7Ow+51f3Aw/sK/rf6OVQgsn+MWj5RA?=
 =?iso-8859-1?Q?jcOxIErj6L3HdRjgVZPwk2T23sn2kNxrZHtR9seR169Z8nHfSGtz4TW1aM?=
 =?iso-8859-1?Q?UVUiMFpUL3vHff3WDQGqSm2ArM7FoNOkVB2A2lUIZLtzpWBwy8LzDozfHl?=
 =?iso-8859-1?Q?88kn+eReyHeUjnsihuiA3V/s8Yab5PYNJTzaWkQkiN1GptDj4IZzaSGYJe?=
 =?iso-8859-1?Q?5yc7htzMm5XpbbT2wy2uQ+2K/kTYo76ELN60bSv6Kr8t02rGgM+gHO9ojR?=
 =?iso-8859-1?Q?7yI+mudhfPdkSlm0cGmzyjEG2KgsHhiRrSdc5xU/c4c45gBVE5KOM5nUac?=
 =?iso-8859-1?Q?TECgO5Se2w71kSYZebcwanTFm5DVSHSFetl3C9Jy1cyXvqjGu/8MTorPuP?=
 =?iso-8859-1?Q?mPhFz8aXsxTsyySEhbEB9hGeAQ9jHhP4gLp2TzuS2qTmijSoFrfddn5VEz?=
 =?iso-8859-1?Q?7+E3u28v32aMwJ86pRlZPHhi7z8PMQo2ATOaHd0RCQ6PNYy7pvxNLclH9D?=
 =?iso-8859-1?Q?H5Cfwgwhuiw1C5K4mwAEpDdjhm+bhljJKc?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19b4be2-c3ab-42ca-ab39-08db3f161b48
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 07:33:58.2135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DSsQCOFNf/7Pki4w9Z0PxuhPISOtUw3DwrVOqV8+iMGoCDNp09myASUxGIk1nt3oWfU8qsG2QxAu8mVEIMXaFecjYK/UDb+o71ElhIcgceI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8840
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > > Actually, I think that all you need to do is disable NETIF_F_SG,=
=0A=
> > > > > and things will work, no?=0A=
> > > >=0A=
> > > > I think that this is not so simple, if I understand correctly, by d=
isabling NETIF_F_SG we will never receive a chained skbs to transmit, but w=
e still have more functionality to address, for example:=0A=
> > > > * The TX timeouts.=0A=
> > >=0A=
> > > I don't get it. With a linear skb we can transmit it as long as there=
's=0A=
> > > space for 2 entries in the vq: header and data. What's the source of =
the=0A=
> > > timeouts?=0A=
> > >=0A=
> >=0A=
> > I'm not saying that this is not possible, I meant that we need more cha=
nges to virtio-net.=0A=
> > The source of the timeouts is from the current implementation of virtne=
t_poll_tx.=0A=
> >=0A=
> > if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS)=0A=
> >       netif_tx_wake_queue(txq);=0A=
> =0A=
> Oh right. So this should check NETIF_F_SG then.=0A=
> BTW both ring size and s/g can be tweaked by ethtool, also=0A=
> needs handling.=0A=
> =0A=
=0A=
Good point.=0A=
=0A=
> >=0A=
> > > > * Guest GSO/big MTU (without VIRTIO_NET_F_MRG_RXBUF?), we can't cha=
in page size buffers anymore.=0A=
> > >=0A=
> > > I think we can.  mergeable_min_buf_len will just be large.=0A=
> > >=0A=
> >=0A=
> > I meant that we can't just by clearing NETIF_F_SG, we'll need to change=
 virtio-net a little bit more, for example, the virtnet_set_big_packets fun=
ction.=0A=
> >=0A=
> =0A=
> Right - for RX, big_packets_num_skbfrags ignores ring size and that's=0A=
> probably a bug if mtu is very large.=0A=
> =0A=
=0A=
So, what do you think, we should fix virtio-net to work with smaller rings?=
 we should fail probe?=0A=
=0A=
I think that since this never came up until now, there is no big demand to =
such small rings.=0A=
