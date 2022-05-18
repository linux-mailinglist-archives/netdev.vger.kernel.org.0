Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770D652BF0C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbiERPdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239411AbiERPdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:33:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5224674DD0;
        Wed, 18 May 2022 08:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE295B8200E;
        Wed, 18 May 2022 15:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFF1C385A5;
        Wed, 18 May 2022 15:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652888026;
        bh=s07V932BNkgk8fGk/5H1DcJc3Tku9n/FoVcvJgqGTPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j0dowNXu6AQDo0YwCQxkg2F+nvj55QhRA6AIMD34Npm2HEjfGv01deIbcde//jQHr
         qEnxnmQ0jZF0R6Ja3hcz+WvyzSoA1ASNcWRsHZxoMX3LN/bpER9QR4LHwe48UA6a+3
         vORDfND9Vtuec8cLPVGB9zM+MxgKX9fdhWpyBXRp8WlslWTE/fp1BzEZqbb6tWYx8b
         jiOWoulZTjrJuMrFPQxiovfkV69BOVpOr+6qFzA+8Cq5NK3AEWqaitkBUhJYrFjYZd
         RMcQTu22BEQaz+RzvkHzCqG9xWdHSsl32hlzqWxH3tApzBI0eoKX5ueeBR/jzAXBxZ
         2AXNbS5qrjcRw==
Date:   Wed, 18 May 2022 08:33:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Guo Zhengkui <guozhengkui@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Ian King <colin.king@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        zhengkui_guo@outlook.com
Subject: Re: [PATCH linux-next] net: smc911x: replace ternary operator with
 min()
Message-ID: <20220518083344.0886bd6f@kernel.org>
In-Reply-To: <CAMuHMdWH1rdP22VnhR_h601tm+DDo7+sGdXR-6NQx0B-jGoZ1A@mail.gmail.com>
References: <20220516115627.66363-1-guozhengkui@vivo.com>
        <CAMuHMdWH1rdP22VnhR_h601tm+DDo7+sGdXR-6NQx0B-jGoZ1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 11:07:08 +0200 Geert Uytterhoeven wrote:
> On Mon, May 16, 2022 at 10:36 PM Guo Zhengkui <guozhengkui@vivo.com> wrot=
e:
> > Fix the following coccicheck warning:
> >
> > drivers/net/ethernet/smsc/smc911x.c:483:20-22: WARNING opportunity for =
min()
> >
> > Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com> =20
>=20
> Thanks for your patch, which is now commit 5ff0348b7f755aac ("net:
> smc911x: replace ternary operator with min()") in net-next/master.
>=20
> > --- a/drivers/net/ethernet/smsc/smc911x.c
> > +++ b/drivers/net/ethernet/smsc/smc911x.c
> > @@ -480,7 +480,7 @@ static void smc911x_hardware_send_pkt(struct net_de=
vice *dev)
> >         SMC_SET_TX_FIFO(lp, cmdB);
> >
> >         DBG(SMC_DEBUG_PKTS, dev, "Transmitted packet\n");
> > -       PRINT_PKT(buf, len <=3D 64 ? len : 64);
> > +       PRINT_PKT(buf, min(len, 64)); =20
>=20
> Unfortunately you forgot to test-compile this with
> ENABLE_SMC_DEBUG_PKTS=3D1, which triggers:
>=20
>         drivers/net/ethernet/smsc/smc911x.c: In function
> =E2=80=98smc911x_hardware_send_pkt=E2=80=99:
>         include/linux/minmax.h:20:28: error: comparison of distinct
> pointer types lacks a cast [-Werror]
>            20 |  (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
>               |                            ^~
>         drivers/net/ethernet/smsc/smc911x.c:483:17: note: in expansion
> of macro =E2=80=98min=E2=80=99
>           483 |  PRINT_PKT(buf, min(len, 64));
>=20
> "len" is "unsigned int", while "64" is "(signed) int".

Ah, damn. I did double check that the build test actually compiles
smc911x.o 'cause this patch looked suspicious. Didn't realize that
more than allmodconfig is needed to trigger this :/

How do you enable ENABLE_SMC_DEBUG_PKTS? You edit the source?

> I have sent a fix
> https://lore.kernel.org/r/ca032d4122fc70d3a56a524e5944a8eff9a329e8.165286=
4652.git.geert+renesas@glider.be/

Thanks a lot!
