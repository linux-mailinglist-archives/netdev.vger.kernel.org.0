Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63D030A800
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhBAMuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbhBAMuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:50:14 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC65C0613D6;
        Mon,  1 Feb 2021 04:49:33 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l6Yds-00EQVZ-PU; Mon, 01 Feb 2021 13:49:20 +0100
Message-ID: <0a982b705b37e7bd3f47cd437b37d8f62dce15e4.camel@sipsolutions.net>
Subject: Re: possible deadlock in cfg80211_netdev_notifier_call
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mike Rapoport <rppt@linux.ibm.com>,
        syzbot <syzbot+2ae0ca9d7737ad1a62b7@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, davem@davemloft.net, hagen@jauu.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com
Date:   Mon, 01 Feb 2021 13:49:18 +0100
In-Reply-To: <20210201123728.GF299309@linux.ibm.com>
References: <000000000000c3a1b705ba42d1ca@google.com>
         <20210201123728.GF299309@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-01 at 14:37 +0200, Mike Rapoport wrote:
> On Mon, Feb 01, 2021 at 01:17:13AM -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    b01f250d Add linux-next specific files for 20210129
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14daa408d00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=725bc96dc234fda7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=2ae0ca9d7737ad1a62b7
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1757f2a0d00000
> > 
> > The issue was bisected to:
> > 
> > commit cc9327f3b085ba5be5639a5ec3ce5b08a0f14a7c
> > Author: Mike Rapoport <rppt@linux.ibm.com>
> > Date:   Thu Jan 28 07:42:40 2021 +0000
> > 
> >     mm: introduce memfd_secret system call to create "secret" memory areas
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1505d28cd00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=1705d28cd00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1305d28cd00000
> 
> Sounds really weird to me. At this point the memfd_secret syscall is not
> even wired to arch syscall handlers. I cannot see how it can be a reason of
> deadlock in wireless...

Yeah, forget about it. Usually this is a consequence of the way syzbot
creates tests - it might have created something like

  if (!create_secret_memfd())
    return;
  try_something_on_wireless()

and then of course without your patch it cannot get to the wireless
bits.

Pretty sure I know what's going on here, I'll take a closer look later.

johannes

