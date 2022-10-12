Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550A55FCCC0
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiJLVH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJLVH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:07:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB78CE07;
        Wed, 12 Oct 2022 14:07:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38FED615BB;
        Wed, 12 Oct 2022 21:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75151C433D6;
        Wed, 12 Oct 2022 21:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665608844;
        bh=biag1swUwokIN/xIvjLt3+O1PtANgMFTYQBZrYP2aLc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2Hw3VeMk1ybU0L/TQJL7kvLFcdLYeXPSin997VWQ+kJsqKRoTZSi7JR/ZZNSosTXd
         oM7E9YX4d8MmIrkPm+wpd2ZxLI3Rucacww5MUZM+XRDVOvL4vPrOUjP1VlIodP86bS
         fRHFWwX6mg4dGRn7DRAu9YESCd0PasLqUHpc5IC4=
Date:   Wed, 12 Oct 2022 14:07:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     syzbot <syzbot+12320e263831dd4ddb91@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in register_shrinker
Message-Id: <20221012140723.8aa014105efab04c5206e072@linux-foundation.org>
In-Reply-To: <0000000000004655fa05ead5c9f6@google.com>
References: <0000000000004655fa05ead5c9f6@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 05:46:49 -0700 syzbot <syzbot+12320e263831dd4ddb91@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2e30960097f6 bpf, x64: Remove unnecessary check on existen..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15934fbc880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=796b7c2847a6866a
> dashboard link: https://syzkaller.appspot.com/bug?extid=12320e263831dd4ddb91
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1055b15c880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1018112a880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/f0f073bdb6eb/disk-2e309600.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6062312f63fe/vmlinux-2e309600.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+12320e263831dd4ddb91@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __list_add_valid+0xa5/0xb0 lib/list_debug.c:30
> Read of size 8 at addr ffff8880775905c8 by task syz-executor328/3786
> 
> CPU: 1 PID: 3786 Comm: syz-executor328 Not tainted 6.0.0-syzkaller-02744-g2e30960097f6 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:317 [inline]
>  print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
>  kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
>  __list_add_valid+0xa5/0xb0 lib/list_debug.c:30
>  __list_add include/linux/list.h:69 [inline]
>  list_add_tail include/linux/list.h:102 [inline]
>  register_shrinker_prepared mm/vmscan.c:684 [inline]

I trust that tree didn't have this fix?

commit bd86c69dae65de30f6d47249418ba7889809e31a
Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Mon Oct 10 14:59:02 2022 +0900

    NFSD: unregister shrinker when nfsd_init_net() fails
    

