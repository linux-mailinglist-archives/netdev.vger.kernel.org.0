Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE116D158B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 04:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCaCU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 22:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCaCUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 22:20:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682BDDBF7;
        Thu, 30 Mar 2023 19:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F09CAB82B88;
        Fri, 31 Mar 2023 02:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCC5C433EF;
        Fri, 31 Mar 2023 02:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680229251;
        bh=Qs7l3Yz/B132+q5vXSX799s84Z+/P4SKudvR3kuc+jY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M7C6XBh0tsPTaKgSFEDTq4hyjnyEuChLRkqo8iJntADvfQjLtSFy71wTsjCnEx6VZ
         jZwXXhG0RZY7+vaCvAQ8TCUFAV3lyBYwZmMv+ggT3fY6XDpPOTX53jom4koI+Wqx6Y
         BlbCFlEo1cUyyS7QEgdQZKfU+Fm+K0NDkWm4dkFsB4ukBvdLGyNLt1K8OphJ+U8RFg
         J/lhjgh4kl11LGyPr2zrrgu9qUGIImoJWMgXsvjK1dnPlriUr1phn8m8YJ3pFoefAf
         WmVKQI3ANJHoqpW4hN3EkVGde1m5KWXGeg76r8R338qVVOx6MMzcLQzG87XcN+2Kat
         p9XgvnK6nUHpQ==
Date:   Thu, 30 Mar 2023 19:20:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help
 us tune rx behavior
Message-ID: <20230330192050.1e057776@kernel.org>
In-Reply-To: <CAL+tcoBKiVqETEAPPawLbS_OF0Eb6HgZRHe-=W81bVKCkpr4Rg@mail.gmail.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
        <20230315092041.35482-3-kerneljasonxing@gmail.com>
        <20230316172020.5af40fe8@kernel.org>
        <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
        <20230316202648.1f8c2f80@kernel.org>
        <CAL+tcoCRn7RfzgrODp+qGv_sYEfv+=1G0Jm=yEoCoi5K8NfSSA@mail.gmail.com>
        <20230330092316.52bb7d6b@kernel.org>
        <CAL+tcoBKiVqETEAPPawLbS_OF0Eb6HgZRHe-=W81bVKCkpr4Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 08:48:07 +0800 Jason Xing wrote:
> On Fri, Mar 31, 2023 at 12:23=E2=80=AFAM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> > On Thu, 30 Mar 2023 17:59:46 +0800 Jason Xing wrote: =20
> > > I'm wondering for now if I can update and resend this patch to have a
> > > better monitor (actually we do need one) on this part since we have
> > > touched the net_rx_action() in the rps optimization patch series?
> > > Also, just like Jesper mentioned before, it can be considered as one
> > > 'fix' to a old problem but targetting to net-next is just fine. What
> > > do you think about it ? =20
> >
> > Sorry, I don't understand what you're trying to say :( =20
>=20
> Previously this patch was not accepted because we do not want to touch
> softirqs (actually which is net_rx_action()). Since it is touched in
> the commit [1] in recent days, I would like to ask your permission:
> could I resend this patch to the mailing list? I hope we can get it
> merged.
>=20
> This patch can be considered as a 'fix' to the old problem. It's
> beneficial and harmless, I think :)

The not touching part was about softirqs which is kernel/softirq.c,
this patch was rejected because it's not useful.
