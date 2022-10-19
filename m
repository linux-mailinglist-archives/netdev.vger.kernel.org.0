Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED343605334
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiJSWam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiJSWaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53872108269;
        Wed, 19 Oct 2022 15:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1694619D6;
        Wed, 19 Oct 2022 22:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2479C433D6;
        Wed, 19 Oct 2022 22:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666218620;
        bh=Cq/bLozlxpeY8ks0XLyBdRr22Rf73ID4hOVpAJhwhEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fwzhcrqhCeKxMRoYFDjx+TDOX3zbvsHfKO9J/q3WLDvisIHLLCyqkPuwLoo6PHZeZ
         SRzUsXd1Q7Kma81lv+HMR+PTJn0IUeqKYHVJlgVmnVofLZOrkLug0gi6TsjsffrHFj
         +gTFDxN1nLYj86UAdVJ51itkZmn9wxrCak/fjakm2ruepsu2km8vO2W4H4mg16MEH+
         7e+oYcRsmAVy7TmhKFwbDh9W+8Rb9pRxqIKLjV8z5zPIbm/BTvrKNAPbd4qetYQUFe
         Jh+GXxWa6psCKzsn9+FMMSX2i3soEmjpvoF9sYlkM/todIfp2F0bUOxyKDQTipKoJ7
         ANR7ywt67w/1g==
Date:   Wed, 19 Oct 2022 15:30:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com>
Cc:     andrew@lunn.ch, bagasdotme@gmail.com, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, lkp@intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in pse_prepare_data
Message-ID: <20221019153018.2ca0580d@kernel.org>
In-Reply-To: <00000000000044139d05eb617b1c@google.com>
References: <00000000000044139d05eb617b1c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 04:26:35 -0700 syzbot wrote:
> HEAD commit:    55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=140d5a2c880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
> dashboard link: https://syzkaller.appspot.com/bug?extid=81c4b4bbba6eea2cfcae
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13470244880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146e88b4880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/9d967e5d91fa/disk-55be6084.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9a8cffcbc089/vmlinux-55be6084.xz
> 
> Bisection is inconclusive: the first bad commit could be any of:
> 
> 331834898f2b Merge branch 'add-generic-pse-support'
> 66741b4e94ca net: pse-pd: add regulator based PSE driver
> 2a4187f4406e once: rename _SLOW to _SLEEPABLE
> f05dfdaf567a dt-bindings: net: pse-dt: add bindings for regulator based PoDL PSE controller
> 18ff0bcda6d1 ethtool: add interface to interact with Ethernet Power Equipment
> e52f7c1ddf3e Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
> 681bf011b9b5 eth: pse: add missing static inlines
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11fc42b4880000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000008: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
> CPU: 1 PID: 3609 Comm: syz-executor227 Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> RIP: 0010:pse_prepare_data+0x66/0x1e0 net/ethtool/pse-pd.c:67

Yeah, looking at ethtool internals - info can be NULL :(

For reasons I haven't quite grasped yet myself we use a different
structure for info on do and dump which makes getting to extack in
generic code inconvenient.
