Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C4D6F0D01
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 22:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344205AbjD0UVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 16:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344203AbjD0UVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 16:21:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4D34494
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABE8360DC6
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 20:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EB4C433EF;
        Thu, 27 Apr 2023 20:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682626887;
        bh=kQBVHC/1oqaIga+0qmU8ker4moiz6ztcIVH7s0kmGYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T4YIQFmYfDw7HuExDblrbDBDhZW3RWhQY4pFpwMCgzIxsJeBqc7tTPfHM1tMuonIr
         QkU021KMqCCf7uUilSgNsa3AzhumSqVNK1v5KMDusORBbKTWIibFKuzm1RXB/15uHa
         p81sYFKB4XZnMqikf62ZSUVMx+O7tD5X507NTzyZcyrZav8H3KayPbHMGQfM0w8+T8
         ZKGIELaU1L6ylbKSk7Hk+1v6jIajWMTA0orPd4hN7Sqh64DIT4/LkaFDX1FpdNzvDD
         SuJkGYyJ9YFLEsW28XneZPM6rVJ4v+kzwhohyFXdKR6JDRkPNGo2qrxjjGRZ2aiLXq
         J+Pjhju4QpqLg==
Date:   Thu, 27 Apr 2023 13:21:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     netdev@vger.kernel.org, Haye.Haehne@telekom.de,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@toke.dk>
Subject: Re: knob to disable locally-originating qdisc optimisation?
Message-ID: <20230427132126.48b0ed6a@kernel.org>
In-Reply-To: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Apr 2023 14:54:30 +0200 (CEST) Thorsten Glaser wrote:
> when traffic (e.g. iperf) is originating locally (as opposed to
> forward traffic), the Linux kernel seems to apply some optimisations
> probably to reduce overall bufferbloat: when the qdisc is =E2=80=9Cfull=
=E2=80=9D or
> (and especially) when its dequeue often returns NULL (because packets
> are delayed), the sender traffic rate is reduced by as much as =E2=85=93 =
with
> 40=C2=A0ms extra latency (30 =E2=86=92 20 Mbit/s).

Doesn't ring a bell, what's your setup?

> This is probably good in general but not so good for L4S where we
> actually want the packets to queue up in the qdisc so they get ECN
> marking appropriately (I guess there probably are some socket ioctls
> or something with which the sending application could detect this
> state; if so, we=E2=80=99d be interested in knowing about them as well).
>=20
> This is especially bad in a testbed for writing L4S-aware applications,
> so if there=E2=80=99s a knob (sysctl or something) to disable this optimi=
sation
> please do tell (I guess probably not, but asking doesn=E2=80=99t hurt).
