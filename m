Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537286095B5
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiJWSw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJWSwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 14:52:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4CC5A2F7;
        Sun, 23 Oct 2022 11:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BBFC60F3A;
        Sun, 23 Oct 2022 18:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF3CC433C1;
        Sun, 23 Oct 2022 18:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666551142;
        bh=HNwcqER76u92VjnWqSlerVcCGjVrALqwLw5X+szcw8k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=M5PNJf4C74L472H9YDvVkkubU7NczmOc6Eqfgroo3ASHEhHJUJ7jY96CZx1xWmITR
         B/GfR72xzNy1Zob3FDhufWgjrHG8bf1n8gkGaoUyzdX5t9Izlwbhvh6t/Uqv1XYimA
         0WvdmyG9EIWZYsX68Toe0G+mZkXeJJDNborQKlmLC+Cqc9h3G5Vs9aiizr9+wqifzy
         gfl6p/SUbK8U4qeVS094olPQhd7IdKlOf56EEG84tm3wsFKLyPXig33aJkjF9Z/T/0
         NAsEIZ+omwjaoBUqfMNH/M6ntEUSlp7+L6gthjyzBSq8mIzI3wdPAScMRLm53GQuP0
         YDPWtAwWdySLA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/12] net: dpaa2-eth: AF_XDP zero-copy support
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
Date:   Sun, 23 Oct 2022 20:52:19 +0200
Message-ID: <87r0yy2x0c.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ioana Ciornei <ioana.ciornei@nxp.com> writes:

> This patch set adds support for AF_XDP zero-copy in the dpaa2-eth
> driver. The support is available on the LX2160A SoC and its variants and
> only on interfaces (DPNIs) with a maximum of 8 queues (HW limitations
> are the root cause).
>
> We are first implementing the .get_channels() callback since this a
> dependency for further work.
>
> Patches 2-3 are working on making the necessary changes for multiple
> buffer pools on a single interface. By default, without an AF_XDP socket
> attached, only a single buffer pool will be used and shared between all
> the queues. The changes in the functions are made in this patch, but the
> actual allocation and setup of a new BP is done in patch#10.
>
> Patches 4-5 are improving the information exposed in debugfs. We are
> exposing a new file to show which buffer pool is used by what channels
> and how many buffers it currently has.
>
> The 6th patch updates the dpni_set_pools() firmware API so that we are
> capable of setting up a different buffer per queue in later patches.
>
> In the 7th patch the generic dev_open/close APIs are used instead of the
> dpaa2-eth internal ones.
>
> Patches 8-9 are rearranging the existing code in dpaa2-eth.c in order to
> create new functions which will be used in the XSK implementation in
> dpaa2-xsk.c
>
> Finally, the last 3 patches are adding the actual support for both the
> Rx and Tx path of AF_XDP zero-copy and some associated tracepoints.
> Details on the implementation can be found in the actual patch.
>
> Changes in v2:
>  - 3/12:  Export dpaa2_eth_allocate_dpbp/dpaa2_eth_free_dpbp in this
>    patch to avoid a build warning. The functions will be used in next
>    patches.
>  - 6/12:  Use __le16 instead of u16 for the dpbp_id field.
>  - 12/12: Use xdp_buff->data_hard_start when tracing the BP seeding.
>
> Changes in v3:
>  - 3/12: fix leaking of bp on error path
>

Again, sorry about the feedback delay.

I don't have access to the hardware, so I mostly glossed over the
patches that didn't touch AF_XDP directly.

The series looks clean, and is easy to follow. The XSK pool usage looks
correct. Awesome to see yet another AF_XDP capable driver!

Feel free to add:
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
