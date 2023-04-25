Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3A06EE26D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjDYNCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjDYNCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:02:44 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2075.outbound.protection.outlook.com [40.107.14.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D561210FE;
        Tue, 25 Apr 2023 06:02:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ktt9LIDYHFu3O3UBhN/e9BUjU1znTv3U0OKm7ogMkD8OJ+S0vqQvpH+/hFG6uqwCUWf1IZnxVfivshIAXccofwL9kIR72OIRdXR1CBLEmuEo6p8JPkA7jZfxQ179SDSCAR372wFN8RC0AbBQc2o1kqvvQAoDY7HEKXuXuYuKaZqedbQkEy37EdjK8MDvEdF0ujtOm3Xv4ZflIOj5s7s0ZYOPEIdQpJqiclW3NAiKaE6bfnh5L9+CrYooTEVRcSiTJUM57QYdOXVzKdp9K+8ibJ9CPGfs6rGBQ7gh8GIFgsj6r1GwSetFBwdioYTWyxQ3Wt7QF+9iIzWf1XxAAn7jhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5nXzrKyMN2nQRVA9lKzE1CjyRt9uI3etfyyyRgJXMk=;
 b=BEle8rqbl9Zvn5nYSA1Zdud4jnqp1R1vDx/wI2y51n8Cai6VOMhMbAxQDJlL6g3HYoI5mvScx47rLnEBsG0wqI++C9jhceFW+U57zGGJJIv1BEaZkG8tuN2USj3YWOdH0cicjQgiz6oVNaB8G4WRFBq+FY0oAuCcCJuIVMszN4dEVITa9Ak2ujpIz4UOVpalHOR2MjUwVemYwsiUklqqSeMdskk7nyoPM5Fm3te7mdlNHOEH9l9/YWYl59l0FwwiowKtZKuWOkmYCVghfKNzSj3xic1SVg43rtXT9s2FnMcCOUZu5BDd162GMysXwKp8WrdjDLZP88x4+3/39YQpWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5nXzrKyMN2nQRVA9lKzE1CjyRt9uI3etfyyyRgJXMk=;
 b=Jq/Eggzn2VM7lm0qUXcWcCKDdLcbYEZU2w5WayVDrqz9XbFNIr0GCROLbvvLah/75fAGffKN/XUQgCZhkaWI7aQu18WODAMF5wPejK8dpvqVepRo59uKoG/SWtDS2byVhGISy0Ao7iNJnRtH3+BuXxREHv/pYlFqayUm4BE3tNE=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AS1PR04MB9431.eurprd04.prod.outlook.com (2603:10a6:20b:4d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 13:02:39 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::d2fd:ad65:a6e0:a30a]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::d2fd:ad65:a6e0:a30a%5]) with mapi id 15.20.6319.034; Tue, 25 Apr 2023
 13:02:38 +0000
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
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uIjT9gABGFgCAAG90AIAAMSwAgAABjzCAAARBAIAABATIgAAENICAAAM4M4AAIQOAgAALfyGAABuqgIAAAQKHgAADxACACRVQMYAACvaAgAAGduWAADkhgIAADWLzgALs2ACAAATeH4AAPVUAgAADdeg=
Date:   Tue, 25 Apr 2023 13:02:38 +0000
Message-ID: <AM0PR04MB4723E38859953B6C531D3E5CD4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423065132-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237D46ADE7954289025B66D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230425041352-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723CE2A9B8BFA7963A66A98D4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230425082150-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230425082150-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AS1PR04MB9431:EE_
x-ms-office365-filtering-correlation-id: a1919bb3-12a8-4d02-c928-08db458d58f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3mLjFGzj/3NYVyimOdtpEvvFlPEHi3eJTUSC62nW/E1GnGjvwjFFBGeyiCUd4SsyVMZvNOPE0e8Rs4G6aqibJEaeJzoEUtVRQkjPybXxUHp1K8289dD8/hRFVNqy7M27KTF+O/9OW2wSsXgu2dgkqhaX2X/+Eu/sInyD4xrhVW7VRzSepVZhMNiXBgrc3YUpHX4IEHuR2xl9yz8/5orF/K9yyP99yaPE0XCcyaP13nqzpGemYC0leznbNl08+yuifnSUtqEHoXmmr0HczQbqM/pA2BVIjN9gTpMPX5lEcBue8+ACQDNfm2Ald4nWcf1ncnVzN69+yihum8aaqMcQuxXhgxyFsaLJ2yOyOpUd5MKSvLPKbSwm0/1q53ZnKUDXPIvoT7mkh8zdsm0H0A/rXTvgtlk1mDTnqstWqBxsTJwLCnxJCGLNqaqrO4s3GQWGGp3jCLqcIZgsPmdEnTU2AeTUFFLvCeXTrE6MAV5d2jO7ZXP87+sZnqeAIQezCTBsgWUiQFG4ufDVwhFhDO7FKUn9wvP0GyJhZ4geHeLfjI40BcN+CL7633NaanxaaWp3z0rJ0m0WoNUwufGWPx9LeC0VosUzDjzIQrquMP2F5dg96y0I4krti0BRPAjHubzV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(39840400004)(396003)(366004)(346002)(451199021)(38100700002)(122000001)(6506007)(9686003)(55016003)(186003)(83380400001)(8936002)(44832011)(33656002)(2906002)(8676002)(52536014)(5660300002)(478600001)(54906003)(7696005)(38070700005)(316002)(71200400001)(4326008)(6916009)(66556008)(76116006)(64756008)(41300700001)(66446008)(66946007)(91956017)(86362001)(66476007)(66899021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?YQ9xsjZfEKAAssIiBXEsoNBSQAK5Vl/blA9h8qzsTBJdJModdD23WoQsrf?=
 =?iso-8859-1?Q?H28uRS6mAynx97hLuP0PVVfp0k97BuJtGkaxDuOnl2tYTjUmlS2RhKMkK7?=
 =?iso-8859-1?Q?141LBx8+f8MKvc5G/nXO+LFF38brD5AcGgbI0QxAyEZ8AtI/f9XAbpHTek?=
 =?iso-8859-1?Q?ZCAOLddiKP02XW/k1w/5BGZiF8icDHSHKes0BsoIt3ie2uFZR/mPe8WvE4?=
 =?iso-8859-1?Q?vr4F9KLIz6QdFLYNxIwzMsvSIK4RWT0l8nNvVHmgZNnRRBeeY99EMpFEoq?=
 =?iso-8859-1?Q?qN9kumouva0BxKTKjJ4Ki0wHzcAL3z3GCpaQgBYrSd5/alqV/Ljd1D8/HU?=
 =?iso-8859-1?Q?oZKgZvEvzTPEyiL3IxgA0pQnvIk2xBp45JcJt3JxTvkPQEWcXFP7JRWY/a?=
 =?iso-8859-1?Q?rUlyjwQp4DWguHg0ZUw6zEWYynLdtpDyh4bhDvPVOa5GHeCf0raH6KbEYW?=
 =?iso-8859-1?Q?cqwm1R1ihwDjATyk4kOqM3HWXDoGvX4GahpKc90dI6hiGYizgEkg9AR9/v?=
 =?iso-8859-1?Q?jDzkhMW8whifqmjR72mm2kAUA+4dFlxehhRjnLjKtlvToESv9Hhsn1WxyP?=
 =?iso-8859-1?Q?fmhGYdaBLb1l0KLM8BWjBthlYRd4oxLA7EHcAEtonrnwV0ser2X05Wyzty?=
 =?iso-8859-1?Q?0ptGbUT1j9U1xtpZz0xpbOLi6hBm7zedMVk8o7PXSnU+gYj01nu6NGvhCh?=
 =?iso-8859-1?Q?b+YYzw4acEEvQbwp4DwqRDHtpEQZcauq6SnhzoKTmpS+6H2TMXUF2vZWFu?=
 =?iso-8859-1?Q?qwVmaPWK66yiZVyXoUVv/daYpvxQ5UjOYiTJK8uIwdJ/XOnjFpj2NdUKX0?=
 =?iso-8859-1?Q?NclEKRngqMx5bGCbr3HxIcFyjji3nP81tB2jjNf58Ep7QojB+kOBRVGZcw?=
 =?iso-8859-1?Q?kDM+ZREi3CxjZg4Ld8RC2Z05cxZ0lfd2qjeV5361RlOAzm2jRIrd+NtBJ+?=
 =?iso-8859-1?Q?cd0BsJPQPjTPN3Yba22+68n2I0S1eZNTB0IsJzgzeITKXtzghNkIVjckJE?=
 =?iso-8859-1?Q?Rx9iD41I46WgNCrSlBQ3pGomnbu890GYJEifO4T+4G6zpdLKfvd1hBxvej?=
 =?iso-8859-1?Q?nBM950zeOwHO8EO7iardUQfUn/4MJtmzH9yj4GFGVbnoo52WTvD0jA7KBt?=
 =?iso-8859-1?Q?7EddLEc+vE1o7Dfv+WYmIY1i8+vf7Uum0f6nsc69mFj9lkJLc/OkZsWsYJ?=
 =?iso-8859-1?Q?Qd8YAoPONMogd9aY6eT7FJJ2skoo4W67xvk9xcim6k95z62nRxeDI1WiC5?=
 =?iso-8859-1?Q?1HfCM4ae34c4Ojjs8gzzX8Ce8wzKK4NQzK2lwKaIh0ossocbbGpJSMCgTQ?=
 =?iso-8859-1?Q?qVz02kkEAta4JZkx2jDfsq127v0wpZ/ZHpYQE1Xk+c1UYOcZl7q41cTh6m?=
 =?iso-8859-1?Q?IBa+wSXmN6tVbM9RNxm3gNfThMBNRN6bNpKMTkBVoYRTooDYMmpbaApQ3v?=
 =?iso-8859-1?Q?5GIV8id0o2J7s8NWzxZ1QBHjBjaghKjzWk2SHx2gUwvVYBzlJRgdRnifzc?=
 =?iso-8859-1?Q?9b4vZshE2c3wGdP59MA9oZMwz3GChDC82tgpTS8CPyMgphfDQEcY+m2S1y?=
 =?iso-8859-1?Q?ZKM4J9lCLsQuVhNVg+gUTM6sREvdw7bquY3FSYG3YWLOxuaWiIDH6lVRcR?=
 =?iso-8859-1?Q?Tn13Z5KpYeVyvSfil2yRQjUYd3SYGF3apROcKOaNw92jOnSkD441Bz5bhq?=
 =?iso-8859-1?Q?hUemCXAo1P1WEH/5utod+B5BapJxXClVgJ6f5LvAF2L9o1DBjLvjsArQh0?=
 =?iso-8859-1?Q?LjwA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1919bb3-12a8-4d02-c928-08db458d58f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 13:02:38.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vVbCG61Y4y+YvAhNzXPjzVJTZkmxeEpEZbVlnIR5L5wx8P7H379aLQByiyQYWXnAHNWxqVi5hwPuOtGvCZiWKuwNQFW4rPyDmZXowiJnAvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9431
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > In the virtnet case, we'll decide which features to block based on the =
ring size.=0A=
> > 2 < ring < MAX_FRAGS + 2  -> BLOCK GRO + MRG_RXBUF=0A=
> > ring < 2  -> BLOCK GRO + MRG_RXBUF + CTRL_VQ=0A=
> =0A=
> why MRG_RXBUF? what does it matter?=0A=
> =0A=
=0A=
You're right, it should be blocked only when ring < 2.=0A=
Or we should let this pass, and let the device figure out that MRG_RXBUF is=
 meaningless with 1 entry..=0A=
=0A=
> > So we'll need a new virtio callback instead of flags.=0A=
> > Furthermore, other virtio drivers may decide which features to block ba=
sed on parameters different than ring size (I don't have a good example at =
the moment).=0A=
> > So maybe we should leave it to the driver to handle (during probe), and=
 offer a virtio core function to re-negotiate the features?=0A=
> >=0A=
> > In the solution I'm working on, I expose a new virtio core function tha=
t resets the device and renegotiates the received features.=0A=
> > + A new virtio_config_ops callback peek_vqs_len to peek at the VQ lengt=
hs before calling find_vqs. (The callback must be called after the features=
 negotiation)=0A=
> >=0A=
> > So, the flow is something like:=0A=
> >=0A=
> > * Super early in virtnet probe, we peek at the VQ lengths and decide if=
 we are=0A=
> >    using small vrings, if so, we reset and renegotiate the features.=0A=
> =0A=
> Using which APIs? What does peek_vqs_len do and why does it matter that=
=0A=
> it is super early?=0A=
> =0A=
=0A=
We peek at the lengths using a new virtio_config.h function that calls a tr=
ansport specific callback.=0A=
We renegotiate calling the new, exported virtio core function.=0A=
=0A=
peek_vqs_len fills an array of u16 variables with the max length of every V=
Q.=0A=
=0A=
The idea here is not to fail probe.=0A=
So we start probe, check if the ring is small, renegotiate the features and=
 then continue with the new features.=0A=
This needs to be super early because otherwise, some virtio_has_feature cal=
ls before re-negotiating may be invalid, meaning a lot of reconfigurations.=
=0A=
=0A=
> > * We continue normally and create the VQs.=0A=
> > * We check if the created rings are small.=0A=
> >    If they are and some blocked features were negotiated anyway (may oc=
cur if=0A=
> >    the re-negotiation fails, or if the transport has no implementation =
for=0A=
> >    peek_vqs_len), we fail probe.=0A=
> >    If the ring is small and the features are ok, we mark the virtnet de=
vice as=0A=
> >    vring_small and fixup some variables.=0A=
> >=0A=
> >=0A=
> > peek_vqs_len is needed because we must know the VQ length before callin=
g init_vqs.=0A=
> >=0A=
> > During virtnet_find_vqs we check the following:=0A=
> > vi->has_cvq=0A=
> > vi->big_packets=0A=
> > vi->mergeable_rx_bufs=0A=
> >=0A=
> > But these will change if the ring is small..=0A=
> >=0A=
> > (Of course, another solution will be to re-negotiate features after ini=
t_vqs, but this will make a big mess, tons of things to clean and reconfigu=
re)=0A=
> >=0A=
> >=0A=
> > The 2 < ring < MAX_FRAGS + 2 part is ready, I have tested a few cases a=
nd it is working.=0A=
> >=0A=
> > I'm considering splitting the effort into 2 series.=0A=
> > A 2 < ring < MAX_FRAGS + 2  series, and a follow up series with the rin=
g < 2 case.=0A=
> >=0A=
> > I'm also thinking about sending the first series as an RFC soon, so it =
will be more broadly tested.=0A=
> >=0A=
> > What do you think?=0A=
> =0A=
> Lots of work spilling over to transports.=0A=
> =0A=
> And I especially don't like that it slows down boot on good path.=0A=
=0A=
Yes, but I don't think that this is really significant.=0A=
It's just a call to the transport to get the length of the VQs.=0A=
If ring is not small, we continue as normal.=0A=
If ring is small, we renegotiate and continue, without failing probe.=0A=
=0A=
> =0A=
> I have the following idea:=0A=
> - add a blocked features value in virtio_device=0A=
> - before calling probe, core saves blocked features=0A=
> - if probe fails, checks blocked features.=0A=
>   if any were added, reset, negotiate all features=0A=
>   except blocked ones and do the validate/probe dance again=0A=
> =0A=
> =0A=
> This will mean mostly no changes to drivers: just check condition,=0A=
> block feature and fail probe.=0A=
> =0A=
=0A=
I like the idea, will try to implement it.=0A=
=0A=
Thanks,=
