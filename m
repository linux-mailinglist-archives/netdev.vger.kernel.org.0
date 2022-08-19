Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E6359A8F4
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbiHSWy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242812AbiHSWy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:54:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93ADB2BB03;
        Fri, 19 Aug 2022 15:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FFCCB8280F;
        Fri, 19 Aug 2022 22:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1553C43140;
        Fri, 19 Aug 2022 22:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660949663;
        bh=X0ogePNNlSeDRsY3fzWimjrtxpMAJRwCWte81D4J8fU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=esGVZEqm4i1XkWJJfodRqvZeUsrLFqo6ppzuJjfKj/pg37vVV5ezs+cau9Qi5+ySs
         nL2Ff5ChwGzN5l4uYBiIEhff3ph1mpCd/EJqj6hHgMgC0wOGoKtC7hZ2OKHyvrruSW
         0JhsWRaueEsiu6ZKoTmBb2RuA1gL1L8AbLrk2IwmZDsJGmWE2fLDpr/3O9DvXDhWO0
         O995cPmwQIL+ykEBy8jmvT2iRt25WK8JEZEa+UTB0teLl0hxIsRjQRLK53paQ2W0zX
         YL0SnEJZc3Mji4FDz7ofro97SaSd5ShfypFp8JdgTvYqaCFSMJzTvIV1qqmN6EtTon
         GxkwT/fTNbJXg==
Date:   Fri, 19 Aug 2022 15:54:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/3] dev: Move received_rps counter next to RPS
 members in softnet data
Message-ID: <20220819155421.3ca7d6d6@kernel.org>
In-Reply-To: <87bksgv26h.fsf@toke.dk>
References: <20220818165906.64450-1-toke@redhat.com>
        <20220818165906.64450-2-toke@redhat.com>
        <20220818200143.7d534a41@kernel.org>
        <87bksgv26h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 14:38:14 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Thu, 18 Aug 2022 18:59:03 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te: =20
> >> Move the received_rps counter value next to the other RPS-related memb=
ers
> >> in softnet_data. This closes two four-byte holes in the structure, mak=
ing
> >> room for another pointer in the first two cache lines without bumping =
the
> >> xmit struct to its own line. =20
> >
> > What's the pointer you're making space for (which I hope will explain
> > why this patch is part of this otherwise bpf series)? =20
>=20
> The XDP queueing series adds a pointer to keep track of which interfaces
> were scheduled for transmission using the XDP dequeue hook (similar to
> how the qdisc wake code works):
>=20
> https://lore.kernel.org/r/20220713111430.134810-12-toke@redhat.com

I see, it makes more sense now :)

> Note that it's still up in the air if this ends up being the way this
> will be implemented, so I'm OK with dropping this patch for now if you'd
> rather wait until it's really needed. OTOH it also seemed like a benign
> change on its own, so I figured I might as well include this patch when
> sending these out. WDYT?

Whatever is easiest :)
