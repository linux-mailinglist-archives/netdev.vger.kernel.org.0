Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB086B1032
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 18:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjCHR3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 12:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHR3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 12:29:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CB11F481;
        Wed,  8 Mar 2023 09:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44A62618B4;
        Wed,  8 Mar 2023 17:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7244C433D2;
        Wed,  8 Mar 2023 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678296538;
        bh=Wqa/KalA/Vbvm5eG3gwGeS8DBtfZGMnOyqZm3no1gBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d3UFvfcsS7z60xJAqi1wOkhv3EKHASmmJaIpJfs/q51Z4ZBer0/8gzfNNEjBhOycf
         INLMqcuvJFYnE6lxoYdby55cLnzOtUlnzVGg+4zmFYyq45zJhdM6A0Dgw6s/3K1lht
         eyPTC+R98gNkwKv3MHyCLmQYlZEH1e6fcMS/2QZfTjDuTZl0V0b4z0wvzMe+prhYMI
         jAL1fEArafJSR1ejBxd0zbxzYbj1MJcAewmrnvxs3lIYuDE0gPeBvzu6WQDqTJw/vr
         1+M4PEZL8zj6QxWEtkKp7BSF6TAvjitLANXVyh69LsLQ8ODy5e4p73e4bOvg/614rs
         0rW58wmUvmOGw==
Date:   Wed, 8 Mar 2023 09:28:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org,
        martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org
Subject: Re: [PATCH v13 bpf-next 00/10] Add skb + xdp dynptrs
Message-ID: <20230308092856.508129b1@kernel.org>
In-Reply-To: <CAEf4BzZzqFW=YBkK1+PKyXPhVmhFSqU=+OHJ6_1USK22UoKEvQ@mail.gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
        <20230308001621.432d9a1a@kernel.org>
        <CAEf4BzZzqFW=YBkK1+PKyXPhVmhFSqU=+OHJ6_1USK22UoKEvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Mar 2023 09:08:09 -0800 Andrii Nakryiko wrote:
> On Wed, Mar 8, 2023 at 12:16=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> =
wrote:
> > On Wed,  1 Mar 2023 07:49:43 -0800 Joanne Koong wrote: =20
> > > This patchset is the 2nd in the dynptr series. The 1st can be found h=
ere [0].
> > >
> > > This patchset adds skb and xdp type dynptrs, which have two main bene=
fits for
> > > packet parsing:
> > >     * allowing operations on sizes that are not statically known at
> > >       compile-time (eg variable-sized accesses).
> > >     * more ergonomic and less brittle iteration through data (eg does=
 not need
> > >       manual if checking for being within bounds of data_end)
> > >
> > > When comparing the differences in runtime for packet parsing without =
dynptrs
> > > vs. with dynptrs, there is no noticeable difference. Patch 9 contains=
 more
> > > details as well as examples of how to use skb and xdp dynptrs. =20
> >
> > Oddly I see an error trying to build net-next with clang 15.0.7,
> > but I'm 90% sure that it built yesterday, has anyone seen: =20
>=20
> yep, it was fixed in bpf-next:
>=20
> 2d5bcdcda879 ("bpf: Increase size of BTF_ID_LIST without
> CONFIG_DEBUG_INFO_BTF again")

Perfect, thanks! Could you get that to us ASAP, please?
