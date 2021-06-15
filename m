Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF8C3A7682
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 07:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhFOFeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 01:34:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50658 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhFOFeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 01:34:13 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lt1gD-0006u3-8A; Tue, 15 Jun 2021 13:32:05 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lt1g7-0001R0-Bs; Tue, 15 Jun 2021 13:31:59 +0800
Date:   Tue, 15 Jun 2021 13:31:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+e4c1dd36fc6b98c50859@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_selector_match
Message-ID: <20210615053159.GA5412@gondor.apana.org.au>
References: <000000000000008a6c05c46e45a4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000008a6c05c46e45a4@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 12:19:26PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    13c62f53 net/sched: act_ct: handle DNAT tuple collision
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=16635470300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
> dashboard link: https://syzkaller.appspot.com/bug?extid=e4c1dd36fc6b98c50859
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e4c1dd36fc6b98c50859@syzkaller.appspotmail.com
> 
> UBSAN: shift-out-of-bounds in ./include/net/xfrm.h:838:23
> shift exponent -64 is negative
> CPU: 0 PID: 12625 Comm: syz-executor.1 Not tainted 5.13.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
>  addr4_match include/net/xfrm.h:838 [inline]
>  __xfrm4_selector_match net/xfrm/xfrm_policy.c:201 [inline]
>  xfrm_selector_match.cold+0x35/0x3a net/xfrm/xfrm_policy.c:227
>  xfrm_state_look_at+0x16d/0x440 net/xfrm/xfrm_state.c:1022

This appears to be an xfrm_state object with an IPv4 selector
that somehow has a prefixlen (d or s) of 96.

AFAICS this is not possible through xfrm_user.  OTOH it is not
obvious that af_key is entirely consistent in how it verifies
the prefix length, in particular, it seems to be possible for
two addresses with conflicting families to be provided as src/dst.

Can you confirm that this is indeed using af_key (a quick read
of the syzbot log seems to indicate that this is the case)?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
