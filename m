Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9E26F3089
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 13:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjEALlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 07:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjEALlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 07:41:49 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2059.outbound.protection.outlook.com [40.107.6.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAE59C;
        Mon,  1 May 2023 04:41:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMvxRw6aFt7KVoUPy3in642S6mDxTWALNPQQTtgBHowEGGCO1uOch/PfZB+aOKuTw4zCXmzP4ifbvty5pnBmimBCHiEObbnaRZO7NpVHcHlGbl8ZKMXX36FP6ZGULrnMnDWcvyzbK6bSYFNK0bRE4A3W9GLYFAQ1TJpsyk5bvH4fLTmCR7bkPka1B8EAVfqPW1Sc4Ot7DlpeYq/lM61/z7tI9z2/YdP1VOkuomE/U0/6G2xTE9HOXrALrhhmXkh5ThNqQDUsuxy2aozHphQeOGwF1SXS4t5GZDGq8rnLMMDhDaZ1agizQWZKlALzRE2//jqWA4JL0YTijPxKSM2KRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcAInZbJBJqgfhVKDgOZdkc2KP1MXt0/S7HFcHBWDwU=;
 b=ZuhOFAv9PLbum8MysTmf9JVJF85CJwhhXmgvr9jIKvJUsqGddRgtpHHi0kq9rhQMyNMjvalH+O/RnJdsJZBOoGyhLGM1wcVf8x9rqJD85K1QmzisuYgp8F2+TNzXApzyhyql7iacBl8SbmP5P0yqAOlasaKHgtT78ZGF7h5Z8a5HRyspfZlNeEthkUduNk92y6NhROPr2jcvttq2AyygLzUpBgIrmBhgsyoe/TvoM5lTtDRQmoiUxqoAu6gCTuujd35QPsTX0ndFUt1/YF2mqF/pZPK2Ulb84XlJwrYTk2xKa9pQi5hoAXnN3qJqH6Sf7PHNiHKSFg8/znKFhpAFFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcAInZbJBJqgfhVKDgOZdkc2KP1MXt0/S7HFcHBWDwU=;
 b=Sw01ouClehxyIwV6BlmCW0pKWyhfscxo3EsxBrzzBEKBkz5AV/75bJBVktOrFmTgbamkiUSQUyLtQpo3qJi+LfX+EMrQYlzJRL/WTeoHJHJ6xZ9aGCu00s/q6PvFSijemIdQnmt0SwBtVtTkX4fI9i6jk9PbIMfHCDhwOAtSDmg=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AS8PR04MB7925.eurprd04.prod.outlook.com (2603:10a6:20b:2a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 11:41:44 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 11:41:44 +0000
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
Thread-Index: AQHZe2XUAgTluM5nJU6YPxcdS/aP2K9D4yuAgABAXH+AARTDAIAAB/SV
Date:   Mon, 1 May 2023 11:41:44 +0000
Message-ID: <AM0PR04MB4723E9A0AED11B60360D27C2D46E9@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430100535-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723C479C388266434DE415ED4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230501062107-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230501062107-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AS8PR04MB7925:EE_
x-ms-office365-filtering-correlation-id: 311a3fac-74d7-4708-715a-08db4a3909e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bFEDHnrjpgP+QHQt0Ny+pol3rLxbXbm5InyWqp4LGBgDXf+MutPur9BhMFhaQ5qyB6JdHf4o9c8+Jap7slrl3mRDi0kTQO1+pW3a/LJ8AUcm9UD0UGQNXURCFJaKql4y6y33VTFXcl9A0w9knHqZ4FdRenZhEGPycHaGEdQAUFjXrSkPzUYUJ4bBN0fY4Qw4slUVjI0NgjEOgNQ5j3iLfD64oNm1We0U0nxxsh8iuRpzkSq5Q5YbblmpMNgKT4B2BWnUR35kQq6BQZ9Wm5KWLxIbURkC2OCf9RH29eRqTAXR6cwnUT8M2usaPU9QzU6664iZG666whvTRO0iqjSTPT7FuYG12x3Wt1Wbtx0xNomvbEIyFn6hhDOszDqlQpGvZ8h/qcRwKmYSiEXGucl+W1Y8i0v2qIfWX33sagtgAuuepbEb3eHu5Mytxd2XpqfXG6TyOU4jpFX/t0VAzcRdMulo3ewExs8X7XaM1bS8ZL4qBPQHvzlRHCLUNrVtFnk0s/W6bUVkbU3o/lDHRZkmJgLsFJtUe58DOCch0ILHc0J+2Aq0+h1KD/u0wnYTASNuiZB9FshrthPW0JmHbZJGaO/YQPoUFw6LUnStqk7R6Ss=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(346002)(136003)(396003)(376002)(366004)(451199021)(478600001)(83380400001)(186003)(4326008)(54906003)(91956017)(76116006)(64756008)(66476007)(66446008)(66556008)(66946007)(6916009)(71200400001)(7696005)(9686003)(26005)(6506007)(316002)(8676002)(8936002)(52536014)(7416002)(5660300002)(41300700001)(44832011)(2906002)(55016003)(38100700002)(122000001)(38070700005)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?fboXAPH8iTHZG/R2+cleJts3o0oqIKW7ybZBMEhomzjKDqKf20eoZgOk8F?=
 =?iso-8859-1?Q?Uuro715BudtojZgIb4RhmB/J5hbu+NCie/XRkqC0zllIi1As0sY3tHu4Bh?=
 =?iso-8859-1?Q?Gj29RwRm2f3BFMP5ai2f+gIS5cHKt4RQMF4r8Es9S5aTRsMAtrM7FhVPy8?=
 =?iso-8859-1?Q?uxyKKUvdiCNtxqYga/eTnbgnE0H7RcNoz37GMcA8AbCCc/v5j1QbEal2L7?=
 =?iso-8859-1?Q?eDp6dfdN9rWjp8t6ptWEbAtZSKikbnaXUCdnkz15dFqQL+O3BNHvr9VDMg?=
 =?iso-8859-1?Q?mKoWdqMAp2Y6vD0sXroTrZ8Pl8dL2TofhNKC2xbDUxOIvgzMyRr5O7Ie9h?=
 =?iso-8859-1?Q?bPMSEdeIK/BLwo/nb2gDzvy8wWC8NZAjMOrHdKbsSyL++QrBKDwKoIP0xT?=
 =?iso-8859-1?Q?EKdqG0buKykpZJpmAcdcA3yCLJ/3awQXD89SDoRXO/dDhJurPXnSH7AybW?=
 =?iso-8859-1?Q?EhLjyqtjz5LLR1B0a+6FGX23+/gHPOuNiczRmkHERIewuoaw87BOuHDTjs?=
 =?iso-8859-1?Q?e6dalDf7PYsPhUJevr7fk8QMTXaMpcara7VtJynYJSDrzlkaFxqtUl7ced?=
 =?iso-8859-1?Q?eyrocHE8jcbvUslHgknY/WLavtYz7QzxCmAkArMsFYx8ImEgNslkGTgQG9?=
 =?iso-8859-1?Q?F0KfojZwl6wihilYJeKhoqYzZaO4jJ0mc9rq88V9hSci0gof3fus4uBU6K?=
 =?iso-8859-1?Q?5EryPX8sHx52qg79ho/+gupRGt3KHj3EDyn5tCBLc+JO/TZpx+kMHe6S+w?=
 =?iso-8859-1?Q?KIzR3lJb4GZDeoecpm+GF3oC0zkm8TTKKuDEsf2PiEkxU5gkPHA7EKoOAv?=
 =?iso-8859-1?Q?wV939XcPoOWb2+npQSV19Flbsh+7Etu0adIFLQmC4/xDR5SC0QFaHpZr/+?=
 =?iso-8859-1?Q?jgwARTAJfzoOvYD3JbPxL1Sy5QMbNW4XrkeUS4v9ekanzDqKkUdIwZ3t6L?=
 =?iso-8859-1?Q?oe8dcyz3d8ep5rUAg9fJ4Ijq8wkIIk+xjIlLOTpiUWSLW6ombOhmmEJA58?=
 =?iso-8859-1?Q?sooSE8P6fT5xgcgGh+m7vXohJ3hR6sv6Ycqzgq19L8BAKDAt7hgGCo062H?=
 =?iso-8859-1?Q?T5cs935Kmi0hJWtt2xkNxZEEI6PRMZpqEyqx303vvC84qWDm6aeZeI1XoD?=
 =?iso-8859-1?Q?F9gY5SpS4JTSkoiVdYpinBkeiTUJqhAuWdexdR0XxmtuY1JtCADTFaBTGP?=
 =?iso-8859-1?Q?l3Lan/CkCrhTOWyEmuN4O2b/e0xqkqiPTtZ/XXenzGc8FimDzBTdgusxal?=
 =?iso-8859-1?Q?8Am7YtIFkW8hpmH59F0zcnEqAE8icS/uXgSaRNQpRaretuhGaZmiCXMjbA?=
 =?iso-8859-1?Q?HQseF0BMAq0BmfPndNdQ6GPzZSQFq3IrlgGhwCwmcq1ssGse5agjtEGr8y?=
 =?iso-8859-1?Q?G35rqg+L8+OhESYOLymKZsGMSvzE7lhmKvMmp5U7T8VCjmXkbPGQbCv9xI?=
 =?iso-8859-1?Q?/Vr59svxwpOI6kG5AEPnNrC0xqvPNj+OMEV7ayfO8Rf8drx0t2kzzRLrAY?=
 =?iso-8859-1?Q?yYWray81ZVLKDViOuZwsXEG8quUzEUIG8JbJwFYQW5LD7TxCHyhkcbBPEf?=
 =?iso-8859-1?Q?ntsPIrbafO7BHAU/b0CYcx7icAZcqttueBsiRjkyq80z+wzqnPmgvWXvAZ?=
 =?iso-8859-1?Q?tXtXaWfgYpf9Wcw2famGESuThpU1xN6F4e?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 311a3fac-74d7-4708-715a-08db4a3909e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 11:41:44.2741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4EsOQnlNpJztqsesl10QGPiz7HlOR5IWzOsdSgsIjkN8ms1TnM510RE41a4pp7NHl6jmXSa4wBsxtL3e9MAESfZCLRFHXSS2WYP2OpTqGe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7925
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Why the difference?=0A=
> > >=0A=
> >=0A=
> > Because the RING_SIZE < 4 case requires much more adjustments.=0A=
> >=0A=
> > * We may need to squeeze the virtio header into the headroom.=0A=
> > * We may need to squeeze the GSO header into the headroom, or block the=
 features.=0A=
> =0A=
> We alread do this though no?=0A=
> I think we'll need to tweak hard_header_len to guarantee it's there=0A=
> as opposed to needed_headroom ...=0A=
> =0A=
> > * At the moment, without NETIF_F_SG, we can receive a skb with 2 segmen=
ts, we may need to reduce it to 1.=0A=
> =0A=
> You are saying clearing NETIF_F_SG does not guarantee a linear skb?=0A=
> =0A=
=0A=
I don't know..=0A=
I'm not sure what is the cause, but using this patchset, without any host G=
SO feature, I can get a chain of 3 descriptors.=0A=
Posing an example of a 4 entries ring during iperf3, acting as a client:=0A=
(TX descriptors)=0A=
=0A=
len=3D86       flags 0x1         addr 0xf738d000=0A=
len=3D1448   flags 0x0         addr 0xf738d800=0A=
len=3D86       flags 0x8081   addr 0xf738e000=0A=
len=3D1184,   flags 0x8081  addr 0xf738e800=0A=
len=3D264     flags 0x8080   addr 0xf738f000=0A=
len=3D86       flags 0x8081   addr 0xf738f800=0A=
len=3D1448   flags 0x0         addr 0xf7390000=0A=
len=3D86       flags 0x1         addr 0xf7390800=0A=
len=3D1448   flags 0x0         addr 0xf7391000=0A=
len=3D86       flags 0x1         addr 0xf716a800=0A=
len=3D1448   flags 0x8080   addr 0xf716b000=0A=
len=3D86       flags 0x8081   addr 0xf7391800=0A=
len=3D1448   flags 0x8080   addr 0xf7392000=0A=
=0A=
We got a chain of 3 in here.=0A=
This happens often.=0A=
=0A=
Now, when negotiating host GSO features, I can get up to 4:=0A=
=0A=
len=3D86       flags 0x1         addr 0xf71fc800=0A=
len=3D21328 flags 0x1         addr 0xf6e00800=0A=
len=3D32768 flags 0x8081   addr 0xf6e06000=0A=
len=3D11064 flags 0x8080   addr 0xf6e0e000=0A=
len=3D86       flags 0x8081   addr 0xf738b000=0A=
len=3D1         flags 0x8080   addr 0xf738b800=0A=
len=3D86       flags 0x1         addr 0xf738c000=0A=
len=3D21704 flags 0x1         addr 0xf738c800=0A=
len=3D32768 flags 0x1         addr 0xf7392000=0A=
len=3D10688 flags 0x0         addr 0xf739a000=0A=
len=3D86       flags 0x8081   addr 0xf739d000=0A=
len=3D22080 flags 0x8081   addr 0xf739d800=0A=
len=3D32768 flags 0x8081   addr 0xf73a3000=0A=
len=3D10312 flags 0x8080   addr 0xf73ab000=0A=
=0A=
TBH, I thought that this behaviour was expected until you mentioned it,=0A=
This is why virtnet_calc_max_descs returns 3 if no host_gso feature is nego=
tiated, and 4 otherwise.=0A=
I was thinking that we may need to use another skb to hold the TSO template=
 (for headers generation)...=0A=
=0A=
Any ideas?=0A=
=0A=
> > * We may need to change all the control commands, so class,  command an=
d command specific data will fit in a single segment.=0A=
> > * We may need to disable the control command and all the features depen=
ding on it.=0A=
> =0A=
> well if we don't commands just fail as we can't add them right?=0A=
> no corruption or stalls ...=0A=
> =0A=
> > * We may need to disable NAPI?=0A=
> =0A=
> hmm why napi?=0A=
> =0A=
=0A=
I'm not sure if it's required to disable it, but I'm not sure what's the po=
int having napi if the ring size is 1..=0A=
Will it work?=0A=
=0A=
> > There may be more changes..=0A=
> >=0A=
> > I was thinking that it may be easier to start with the easier case RING=
_SIZE >=3D 4, make sure everything is working fine, then send a follow up p=
atchset with the required adjustments for RING_SIZE < 4.=0A=
> =0A=
> =0A=
> it's ok but I'm just trying to figure out where does 4 come from.=0A=
> =0A=
=0A=
I guess this part was not clear, sorry..=0A=
In case of split vqs, we have ring size 2 before 4.=0A=
And as you saw, we still get chains of 3 when NETIF_F_SG is off (Which I th=
ought was expected).=0A=
