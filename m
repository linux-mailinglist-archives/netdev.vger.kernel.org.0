Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E26290D41
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 07:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfHQFrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 01:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfHQFrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Aug 2019 01:47:45 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3A021019;
        Sat, 17 Aug 2019 05:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566020865;
        bh=lxUYLtvBEUEzWwLJTyyeXIKjo7WX90NrxflgYrnNUqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jeRLKw7DJRurEy3f37XGcoTkX3Nwld4cB9Mc0cDVvJsxY86HlYN1+O5+7BXYt7cnH
         qXYb/MFgYR42ncN4hn6LV5DzX31WLZbSprTpvnlYcCZ2pNAA+cemdubOEnt4GFmIOL
         hZNdLVu/6In1utJjVCqoBoGhO2vBiNlSnr6GpDVw=
Date:   Fri, 16 Aug 2019 22:47:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot <syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, hdanton@sina.com, john.fastabend@gmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: INFO: task hung in tls_sw_release_resources_tx
Message-ID: <20190817054743.GE8209@sol.localdomain>
Mail-Followup-To: Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot <syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, hdanton@sina.com, john.fastabend@gmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
References: <000000000000523ea3059025b11d@google.com>
 <000000000000e75f1805902bb919@google.com>
 <20190816190234.2aaab5b6@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816190234.2aaab5b6@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+Steffen, who is the maintainer of pcrypt]

On Fri, Aug 16, 2019 at 07:02:34PM -0700, Jakub Kicinski wrote:
> On Thu, 15 Aug 2019 11:06:00 -0700, syzbot wrote:
> > syzbot has bisected this bug to:
> > 
> > commit 130b392c6cd6b2aed1b7eb32253d4920babb4891
> > Author: Dave Watson <davejwatson@fb.com>
> > Date:   Wed Jan 30 21:58:31 2019 +0000
> > 
> >      net: tls: Add tls 1.3 support
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118e8dee600000
> > start commit:   6d5afe20 sctp: fix memleak in sctp_send_reset_streams
> > git tree:       net
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=138e8dee600000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=158e8dee600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6a9ff159672dfbb41c95
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17cb0502600000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d5dc22600000
> > 
> > Reported-by: syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com
> > Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
> > 
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> CC Herbert, linux-crypto
> 
> This is got to be something in the crypto code :S 
> 
> The test case opens a ktls socket and back log writes to it.
> Then it opens a AF_ALG socket, binds "pcrypt(gcm(aes))" and dies.
> 
> The ktls socket upon close waits for async crypto callbacks, but they
> never come. If I unset CRYPTO_USER_API_AEAD or change the alg to bind
> to "gcm(aes)" the bug does not trigger.
> 
> Any suggestions?

Seeing as pcrypt is involved and this is a "task hung" bug, this is probably
caused by the recursive pcrypt deadlock, which is yet to be fixed.

See the original thread for more info:

	https://groups.google.com/forum/#!msg/syzkaller-bugs/1_CXUd3gBcg/BvsRLH0lAgAJ

And the syzbot dashboard link:

	https://syzkaller.appspot.com/bug?id=178f2528d10720d563091fb51dceb4cb20f75525

Let's tell syzbot this is a duplicate:

#syz dup: INFO: task hung in aead_recvmsg


Steffen, do you have any plan to fix this?

- Eric
