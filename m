Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EBB2B1B44
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgKMMmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMMmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 07:42:08 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A3DC0613D1;
        Fri, 13 Nov 2020 04:42:08 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdYOy-0055Pi-RC; Fri, 13 Nov 2020 12:42:04 +0000
Date:   Fri, 13 Nov 2020 12:42:04 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
Subject: Re: csum_partial() on different archs (selftest/bpf)
Message-ID: <20201113124204.GI3576660@ZenIV.linux.org.uk>
References: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 11:36:08AM +0100, Björn Töpel wrote:
> I was running the selftest/bpf on riscv, and had a closer look at one
> of the failing cases:
> 
>   #14/p valid read map access into a read-only array 2 FAIL retval
> 65507 != -29 (run 1/1)
> 
> The test does a csum_partial() call via a BPF helper. riscv uses the
> generic implementation. arm64 uses the generic csum_partial() and fail
> in the same way [1]. arm (32-bit) has a arch specfic implementation,
> and fail in another way (FAIL retval 131042 != -29) [2].
> 
> I mimicked the test case in a userland program, comparing the generic
> csum_partial() to the x86 implementation [3], and the generic and x86
> implementation does yield a different result.
> 
> x86     :    -29 : 0xffffffe3
> generic :  65507 : 0x0000ffe3
> arm     : 131042 : 0x0001ffe2
> 
> Who is correct? :-) It would be nice to get rid of this failed case...

Don't expose unfolded csums to *anything* that might care about the
specific bit pattern.   All you are guaranteed is the value mod 0xffff.
Full 32bit value is not just arch-specific - it can change from moving
the area you are giving it by two bytes.  Yes, really.

It's *NOT* suitable for passig to userland.  Or for sending over the
wire.  Or for storing in filesystem metadata (as reiserfs xattrs have
done).

__wsum is purely internal thing; BPF has no business sticking its
fingers there, let alone exposing it as part of any kind of stable ABI.  
