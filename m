Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A60C2B1CF8
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 15:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgKMOPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 09:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgKMOPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 09:15:49 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D57EC0613D1;
        Fri, 13 Nov 2020 06:15:49 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdZra-0058ih-LK; Fri, 13 Nov 2020 14:15:42 +0000
Date:   Fri, 13 Nov 2020 14:15:42 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: csum_partial() on different archs (selftest/bpf)
Message-ID: <20201113141542.GJ3576660@ZenIV.linux.org.uk>
References: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
 <20201113122440.GA2164@myrica>
 <CAJ+HfNiE5Oa25QgdAdKzfk-=X45hXLKk_t+ZCiSaeFVTzgzsrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNiE5Oa25QgdAdKzfk-=X45hXLKk_t+ZCiSaeFVTzgzsrw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 02:22:16PM +0100, Björn Töpel wrote:

> Folding Al's input to this reply.
> 
> I think the bpf_csum_diff() is supposed to be used in combination with
> another helper(s) (e.g. bpf_l4_csum_replace) so I'd guess the returned
> __wsum should be seen as an opaque value, not something BPF userland
> can rely on.

Why not reduce the sucker modulo 0xffff before returning it?  Incidentally,
implementation is bloody awful:

        /* This is quite flexible, some examples:
         *
         * from_size == 0, to_size > 0,  seed := csum --> pushing data
         * from_size > 0,  to_size == 0, seed := csum --> pulling data
         * from_size > 0,  to_size > 0,  seed := 0    --> diffing data
         *
         * Even for diffing, from_size and to_size don't need to be equal.
         */
        if (unlikely(((from_size | to_size) & (sizeof(__be32) - 1)) ||
                     diff_size > sizeof(sp->diff)))
                return -EINVAL;

        for (i = 0; i < from_size / sizeof(__be32); i++, j++)
                sp->diff[j] = ~from[i];
        for (i = 0; i <   to_size / sizeof(__be32); i++, j++)
                sp->diff[j] = to[i];

        return csum_partial(sp->diff, diff_size, seed);

What the hell is this (copying, scratchpad, etc.) for?  First of all,
_if_ you want to use csum_partial() at all (and I'm not at all sure
that it won't be cheaper to just go over two arrays, doing csum_add()
and csum_sub() resp. - depends upon the realistic sizes), you don't
need to copy anything.  Find the sum of from, find the sum of to and
then subtract (csum_sub()) the old sum from the seed and and add the
new one...

And I would strongly recommend to change the calling conventions of that
thing - make it return __sum16.  And take __sum16 as well...

Again, exposing __wsum to anything that looks like a stable ABI is
a mistake - it's an internal detail that can be easily abused,
causing unpleasant compat problems.
