Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6E5570E9
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfFZSnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:43:18 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:34866 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726227AbfFZSnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:43:17 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5QIgrkG019522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 14:42:54 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E3B1A42002B; Wed, 26 Jun 2019 14:42:51 -0400 (EDT)
Date:   Wed, 26 Jun 2019 14:42:51 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>
Cc:     adilger.kernel@dilger.ca, davem@davemloft.net, eladr@mellanox.com,
        idosch@mellanox.com, jiri@mellanox.com, john.stultz@linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Message-ID: <20190626184251.GE3116@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, davem@davemloft.net, eladr@mellanox.com,
        idosch@mellanox.com, jiri@mellanox.com, john.stultz@linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
References: <000000000000d3f34b058c3d5a4f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d3f34b058c3d5a4f@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 10:27:08AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1435aaf6a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
> dashboard link: https://syzkaller.appspot.com/bug?extid=4bfbbf28a2e50ab07368
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11234c41a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d7f026a00000
> 
> The bug was bisected to:
> 
> commit 0c81ea5db25986fb2a704105db454a790c59709c
> Author: Elad Raz <eladr@mellanox.com>
> Date:   Fri Oct 28 19:35:58 2016 +0000
> 
>     mlxsw: core: Add port type (Eth/IB) set API

Um, so this doesn't pass the laugh test.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10393a89a00000

It looks like the automated bisection machinery got confused by two
failures getting triggered by the same repro; the symptoms changed
over time.  Initially, the failure was:

crashed: INFO: rcu detected stall in {sys_sendfile64,ext4_file_write_iter}

Later, the failure changed to something completely different, and much
earlier (before the test was even started):

run #5: basic kernel testing failed: failed to copy test binary to VM: failed to run ["scp" "-P" "22" "-F" "/dev/null" "-o" "UserKnownHostsFile=/dev/null" "-o" "BatchMode=yes" "-o" "IdentitiesOnly=yes" "-o" "StrictHostKeyChecking=no" "-o" "ConnectTimeout=10" "-i" "/syzkaller/jobs/linux/workdir/image/key" "/tmp/syz-executor216456474" "root@10.128.15.205:./syz-executor216456474"]: exit status 1
Connection timed out during banner exchange
lost connection

Looks like an opportunity to improve the bisection engine?

							- Ted
