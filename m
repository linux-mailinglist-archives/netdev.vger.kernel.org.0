Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71AA57344
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 23:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFZVEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 17:04:14 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39825 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726289AbfFZVEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 17:04:14 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5QL3pbG018099
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 17:03:52 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0F73942002E; Wed, 26 Jun 2019 17:03:51 -0400 (EDT)
Date:   Wed, 26 Jun 2019 17:03:51 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, davem@davemloft.net, eladr@mellanox.com,
        idosch@mellanox.com, jiri@mellanox.com, john.stultz@linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Message-ID: <20190626210351.GF3116@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, davem@davemloft.net, eladr@mellanox.com,
        idosch@mellanox.com, jiri@mellanox.com, john.stultz@linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
References: <000000000000d3f34b058c3d5a4f@google.com>
 <20190626184251.GE3116@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626184251.GE3116@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reproducer causes similar rcu stalls when using xfs:

RSP: 0018:ffffaae8c0953c58 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000288 RBX: 000000000000b05a RCX: ffffaae8c0953d50
RDX: 000000000000001c RSI: 000000000000001c RDI: ffffdcec41772800
RBP: ffffdcec41772800 R08: 00000015143ceae3 R09: 0000000000000001
R10: 0000000000000000 R11: ffffffff96863980 R12: ffff88d179ac7d80
R13: ffff88d174837ca0 R14: 0000000000000288 R15: 000000000000001c
 generic_file_buffered_read+0x2c1/0x8b0
 xfs_file_buffered_aio_read+0x5f/0x140
 xfs_file_read_iter+0x6e/0xd0
 generic_file_splice_read+0x110/0x1d0
 splice_direct_to_actor+0xd5/0x230
 ? pipe_to_sendpage+0x90/0x90
 do_splice_direct+0x9f/0xd0
 do_sendfile+0x1d4/0x3a0
 __se_sys_sendfile64+0x58/0xc0
 do_syscall_64+0x50/0x1b0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f8038387469

and btrfs

[   42.671321] RSP: 0018:ffff960dc0963b90 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[   42.673592] RAX: 0000000000000001 RBX: ffff89eb3628ab30 RCX: 00000000ffffffff
[   42.675775] RDX: ffff89eb3628a380 RSI: 00000000ffffffff RDI: ffffffff9ec63980
[   42.677851] RBP: ffff89eb3628aaf8 R08: 0000000000000001 R09: 0000000000000001
[   42.680028] R10: 0000000000000000 R11: ffffffff9ec63980 R12: ffff89eb3628a380
[   42.682213] R13: 0000000000000246 R14: 0000000000000001 R15: ffffffff9ec63980
[   42.684509]  xas_descend+0xed/0x120
[   42.685682]  xas_load+0x39/0x50
[   42.686691]  find_get_entry+0xa0/0x330
[   42.687885]  pagecache_get_page+0x30/0x2d0
[   42.689190]  generic_file_buffered_read+0xee/0x8b0
[   42.690708]  generic_file_splice_read+0x110/0x1d0
[   42.692374]  splice_direct_to_actor+0xd5/0x230
[   42.693868]  ? pipe_to_sendpage+0x90/0x90
[   42.695180]  do_splice_direct+0x9f/0xd0
[   42.696407]  do_sendfile+0x1d4/0x3a0
[   42.697551]  __se_sys_sendfile64+0x58/0xc0
[   42.698854]  do_syscall_64+0x50/0x1b0
[   42.700021]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   42.701619] RIP: 0033:0x7f21e8d5f469

So this is probably a generic vfs issue (probably in sendfile).  Next
steps is probably for someone to do a bisection search covering
changes to the fs/ and mm/ directories.  This should exclude bogus
changes in the networking layer, although it does seem that there is
something very badly wrong which is breaking bisectability, if you
can't even scp to the system under test for certain commit ranges.  :-( :-( :-(

      	       	      	     	   	    - Ted
