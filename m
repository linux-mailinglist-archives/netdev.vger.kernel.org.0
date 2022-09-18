Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063E95BBEC5
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 17:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIRPwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 11:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiIRPww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 11:52:52 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08A31EAEF
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 08:52:50 -0700 (PDT)
Received: from fsav313.sakura.ne.jp (fsav313.sakura.ne.jp [153.120.85.144])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28IFqmkS092637;
        Mon, 19 Sep 2022 00:52:49 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav313.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp);
 Mon, 19 Sep 2022 00:52:48 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28IFqmON092633
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 19 Sep 2022 00:52:48 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <693b572a-6436-14e6-442c-c8f2f361ed94@I-love.SAKURA.ne.jp>
Date:   Mon, 19 Sep 2022 00:52:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: WARNING: locking bug in inet_autobind
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <00000000000033a0120588fac894@google.com>
Cc:     netdev@vger.kernel.org,
        syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <00000000000033a0120588fac894@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting locking bug in inet_autobind(), for
commit 37159ef2c1ae1e69 ("l2tp: fix a lockdep splat") started
calling 

  lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class, "l2tp_sock")

in l2tp_tunnel_create() (which is currently in l2tp_tunnel_register()).
How can we fix this problem?

  ------------[ cut here ]------------
  class->name=slock-AF_INET6 lock->name=l2tp_sock lock->key=l2tp_socket_class
  WARNING: CPU: 2 PID: 9237 at kernel/locking/lockdep.c:940 look_up_lock_class+0xcc/0x140
  Modules linked in:
  CPU: 2 PID: 9237 Comm: a.out Not tainted 6.0.0-rc5-00094-ga335366bad13-dirty #860
  Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
  RIP: 0010:look_up_lock_class+0xcc/0x140

On 2019/05/16 14:46, syzbot wrote:
> HEAD commit:    35c99ffa Merge tag 'for_linus' of git://git.kernel.org/pub..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10e970f4a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
> dashboard link: https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

C reproducer is available at
https://syzkaller.appspot.com/text?tag=ReproC&x=15062310080000 .

