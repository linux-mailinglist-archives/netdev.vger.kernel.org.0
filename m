Return-Path: <netdev+bounces-10353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C90672DF56
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85DCD1C20C96
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723E42A9DA;
	Tue, 13 Jun 2023 10:25:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667E9DDBC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:25:30 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1451FF9;
	Tue, 13 Jun 2023 03:25:05 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1q91CZ-002Me3-9m; Tue, 13 Jun 2023 18:24:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Jun 2023 18:24:39 +0800
Date: Tue, 13 Jun 2023 18:24:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, dhowells@redhat.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] general protection fault in cryptd_hash_export
Message-ID: <ZIhD53a/6Svmn1aS@gondor.apana.org.au>
References: <0000000000000cb2c305fdeb8e30@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000cb2c305fdeb8e30@google.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 02:43:45AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ded5c1a16ec6 Merge branch 'tools-ynl-gen-code-gen-improvem..
> git tree:       net-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=104cdef1280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
> dashboard link: https://syzkaller.appspot.com/bug?extid=e79818f5c12416aba9de
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c6193b280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c7a795280000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ffd66beb6784/disk-ded5c1a1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e7336ae5a7bf/vmlinux-ded5c1a1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/10ded02dc7e2/bzImage-ded5c1a1.xz
> 
> The issue was bisected to:
> 
> commit c662b043cdca89bf0f03fc37251000ac69a3a548
> Author: David Howells <dhowells@redhat.com>
> Date:   Tue Jun 6 13:08:56 2023 +0000
> 
>     crypto: af_alg/hash: Support MSG_SPLICE_PAGES

David, the logic for calling hash_alloc_result looks quite different
from that on whether you do the hash finalisation.  I'd suggest that
you change them to use the same check, and also set use NULL instead
of ctx->result if you didn't call hash_alloc_result.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

