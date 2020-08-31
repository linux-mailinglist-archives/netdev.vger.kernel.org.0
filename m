Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD98258235
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgHaUDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgHaUDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:03:37 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A75C061573;
        Mon, 31 Aug 2020 13:03:36 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCq1Y-008Gwk-RN; Mon, 31 Aug 2020 20:03:29 +0000
Date:   Mon, 31 Aug 2020 21:03:28 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     syzbot <syzbot+e24baf53dc389927a7c3@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        maz@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in sock_close
Message-ID: <20200831200328.GX1236603@ZenIV.linux.org.uk>
References: <000000000000dc862405ae31ae9b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000dc862405ae31ae9b@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 12:48:13PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    15bc20c6 Merge tag 'tty-5.9-rc3' of git://git.kernel.org/p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a85669900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=891ca5711a9f1650
> dashboard link: https://syzkaller.appspot.com/bug?extid=e24baf53dc389927a7c3
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127d3c99900000

> The issue was bisected to:
> 
> commit a9ed4a6560b8562b7e2e2bed9527e88001f7b682
> Author: Marc Zyngier <maz@kernel.org>
> Date:   Wed Aug 19 16:12:17 2020 +0000
> 
>     epoll: Keep a reference on files added to the check list

All of those are essentially duplicates.

The minimal fix is below; I'm not happy with it long-term, but I'm still
digging through the eventpoll locking, and there's a good chance that this
is the least intrusive variant for -stable.  Folks, could you check if the
following patch fixes those suckers?  Again, all reports bisected to that
commit are essentially the same.

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e0decff22ae2..8107e06d7f6f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1995,9 +1995,9 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 			 * during ep_insert().
 			 */
 			if (list_empty(&epi->ffd.file->f_tfile_llink)) {
-				get_file(epi->ffd.file);
-				list_add(&epi->ffd.file->f_tfile_llink,
-					 &tfile_check_list);
+				if (get_file_rcu(epi->ffd.file))
+					list_add(&epi->ffd.file->f_tfile_llink,
+						 &tfile_check_list);
 			}
 		}
 	}
