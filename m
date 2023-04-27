Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1939B6F088E
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbjD0PoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 11:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243577AbjD0PoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 11:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600FE2D72
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 08:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F029D63DEF
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 15:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14655C433D2;
        Thu, 27 Apr 2023 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682610249;
        bh=BAsPAYOQms1KNmnPmcNjdmwrFBUf2bOjsrU1x9v12UQ=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=JZTlHBwt502zDwyrM7iKK+bUcSFQQ28EKDd9RZXcQpkk+bzTSLo+r/xkDU/MJKWQO
         /drE/91k+P1nvhtNx0R7933UDIC9oR2SqQIb6Bd8q7NKy6woKEyMkhoezjoONzi6gY
         42+DhBbN0CHGKnZoGYXGn2jSlq779K/f8mAmGH8yKstIqtbWcOehyp/5L3+Tlk64AO
         Eoq2M1xOVcnoiY0YaJJ1z0GUYHZHazy7VWSnRP1ZuIGD2IoYGWOGAy2nIMarmHlbBu
         oKp0zrFS5kOuQ0hEC66ta1oXZtWkBip8X2ys0xiWV4qS+TGYTs5lHjpR1LezVz93BM
         jwpep8DOF6nvw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANn89iK1=r21a66FVxYf3Zfecvs-QYjkZS+atArRJfJxYw=26Q@mail.gmail.com>
References: <20230427134527.18127-1-atenart@kernel.org> <CANn89iK1=r21a66FVxYf3Zfecvs-QYjkZS+atArRJfJxYw=26Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: tcp: make txhash use consistent for IPv4
From:   Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
To:     Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Apr 2023 17:44:06 +0200
Message-ID: <168261024638.4620.18301394280493060559@kwain>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Eric Dumazet (2023-04-27 17:15:27)
> On Thu, Apr 27, 2023 at 3:45=E2=80=AFPM Antoine Tenart <atenart@kernel.or=
g> wrote:
> >
> > Series is divided in two parts. First two commits make the txhash (used
> > for the skb hash in TCP) to be consistent for all IPv4/TCP packets (IPv6
> > doesn't have the same issue). Last two commits improve doc/comment
> > hash-related parts.
> >
> > One example is when using OvS with dp_hash, which uses skb->hash, to
> > select a path. We'd like packets from the same flow to be consistent, as
> > well as the hash being stable over time when using net.core.txrehash=3D=
0.
> > Same applies for kernel ECMP which also can use skb->hash.
>=20
> How do you plan to test these patches ?

I did perform manual checks (with net.core.txrehash=3D0 to make sure the
hash was consistent) using a setup with OvS and dp_hash (~ECMP like) and
looking which path packets took. Not sure if there is a simpler test
that could be automated, we can't use autoflowlabel to make simple
scripts like for IPv6. Anything you'd like to see specifically?

> > IMHO the series makes sense in net-next, but we could argue (some)
> > commits be seen as fixes and I can resend if necessary.
>=20
> net-next is closed...

I was convinced to have checked, but well, completely missed it. Sorry
about that... Will resend when appropriate.

Thanks,
Antoine
