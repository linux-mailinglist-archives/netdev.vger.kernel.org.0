Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47763BBE8
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387809AbfFJSlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387398AbfFJSlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 14:41:07 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40CCA20820;
        Mon, 10 Jun 2019 18:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560192066;
        bh=2ymFpgEEZ8TWmSlRAxNiVZGhcCAfLnl6klJhS+j3XUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Riz7I1FaxSrLQkloA/Pah1yPP2bFV5nQCZ61L7dhwoIYboWKcUmM44zCctE4a8Y7x
         MavM2RftvPG0mE2WBlFeOkuoMwIba+1mgK//6LFg57gJx/OZXCClhXUUXlqJo/kwLp
         3fPJ0Gf+XXD3XRA74YgdmP2WK7hrnI4OIcF3qcP0=
Date:   Mon, 10 Jun 2019 11:41:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     syzbot <syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: kernel BUG at include/linux/scatterlist.h:LINE!
Message-ID: <20190610184103.GF63833@gmail.com>
References: <000000000000f41cd905897c075e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f41cd905897c075e@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 08:58:05AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    af8f3fb7 net: stmmac: dma channel control register need to..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=17c2d418a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=df0d4ec12332661dd1f9
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b53ce4a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b0aa52a00000
> 
> The bug was bisected to:
> 
> commit f295b3ae9f5927e084bd5decdff82390e3471801
> Author: Vakul Garg <vakul.garg@nxp.com>
> Date:   Wed Mar 20 02:03:36 2019 +0000
> 
>     net/tls: Add support of AES128-CCM based ciphers
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16915282a00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=15915282a00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11915282a00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
> Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
> 
> ------------[ cut here ]------------
> kernel BUG at include/linux/scatterlist.h:97!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8868 Comm: syz-executor428 Not tainted 5.2.0-rc1+ #21
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:sg_assign_page include/linux/scatterlist.h:97 [inline]
> RIP: 0010:sg_set_page include/linux/scatterlist.h:119 [inline]
> RIP: 0010:sk_msg_page_add include/linux/skmsg.h:246 [inline]
> RIP: 0010:tls_sw_do_sendpage net/tls/tls_sw.c:1171 [inline]
> RIP: 0010:tls_sw_sendpage+0xd63/0xf50 net/tls/tls_sw.c:1230

Hi Vakul, when are you planning to fix this?

- Eric
