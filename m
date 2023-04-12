Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4D86DED85
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjDLIZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDLIZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:25:03 -0400
X-Greylist: delayed 89973 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 01:24:56 PDT
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A144D5BB0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:24:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 06027220003;
        Wed, 12 Apr 2023 10:24:54 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i_SUmv-1XEmx; Wed, 12 Apr 2023 10:24:52 +0200 (CEST)
Received: from think-1.home (147.249.6.85.dynamic.wline.res.cust.swisscom.ch [85.6.249.147])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 54A6E220001;
        Wed, 12 Apr 2023 10:24:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
        s=default; t=1681287892;
        bh=qOGXGGawzYRYVCNzIU5U63mQGMmG5ibb/gw+nPfGPK8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WOhtVUGpsKzn4wDTb4xtygu6N5DNTgbF3JpT0HBPixkmP321p7yQCsamG3ZJfkUxt
         nniZJmE06bRcBeuaaoP1MW1vL18usvo4WsnGT5VxZod1gCYs2/Xci0uRvR1hYRmfk+
         5PSkZWAx8EQVlFXqUQOx8XUxBJfX46CeBcmqZ+k0Bb7v5/lqlpTGDgctMCpVuEVoCw
         NIxb0h0qGSthfsABcEOLq6fxnoboukWK6z1T/Da56LPgaEv+Fvi58fn4aVir/d9BtA
         18WOUk3r9Rc5a5RAPGlWhDI94o6B8gavvODDpLBwpKuywkcfSjnPW0+EjVjzC3wyqk
         c88gYQiUwIoyg==
Message-ID: <507dac097ddd5b906de363319c46000c91041b36.camel@strongswan.org>
Subject: Re: [PATCH ipsec] xfrm: Preserve xfrm interface secpath for packets
 forwarded
From:   Martin Willi <martin@strongswan.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Benedict Wong <benedictwong@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Date:   Wed, 12 Apr 2023 10:24:51 +0200
In-Reply-To: <CAHsH6Gv1Vhr3unAsG-0WiJf5CD85NyrgDitLmMtxdphD4__aSA@mail.gmail.com>
References: <20230411072502.21315-1-martin@strongswan.org>
         <CAHsH6GtyE8HE2TnU_QUVg2s+Dass0GtGsaWKqo-g+1aUprmSxw@mail.gmail.com>
         <CAHsH6Gv1Vhr3unAsG-0WiJf5CD85NyrgDitLmMtxdphD4__aSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eyal,

> > The benefit I think is in not deducing whether we are in
> > forwarding.
>=20
> After another look the secpath is reset in that case anyway.
> So in that case, which flow is missing when just using:
>=20
> if (if_id && dir !=3D XFRM_POLICY_FWD)
> =C2=A0=C2=A0=C2=A0 secpath_reset(skb);

This is obviously the better and simpler approach, and it works just
fine in my testing. I'll post a v2.

Thanks,
Martin
