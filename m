Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D482366AA83
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 10:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjANJgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 04:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjANJgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 04:36:33 -0500
X-Greylist: delayed 344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 Jan 2023 01:36:27 PST
Received: from forward501b.mail.yandex.net (forward501b.mail.yandex.net [178.154.239.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8541BD
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 01:36:27 -0800 (PST)
Received: from myt5-18b0513eae63.qloud-c.yandex.net (myt5-18b0513eae63.qloud-c.yandex.net [IPv6:2a02:6b8:c12:571f:0:640:18b0:513e])
        by forward501b.mail.yandex.net (Yandex) with ESMTP id 82FCE5E695;
        Sat, 14 Jan 2023 12:30:25 +0300 (MSK)
Received: by myt5-18b0513eae63.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id MUdJCjAZZOs1-flbRRSHy;
        Sat, 14 Jan 2023 12:30:24 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1673688624;
        bh=E4aVW5qmH+HYiwQz5YGUgQLSKCNbPWZh4OEFHACFk9I=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=r5+lY79wVMg1SXRzGZyyMH7kJCG+YH4rk1Aw0QMh/v9CB8KudyD4qMvRwOAQK6v7G
         myHOf3vh4vHWPw/hZ/ljawWe92FWEDCTL3nHOojrD2mD9oucYJ+LOWsPiAK8KIBKvm
         mOdHhnUhmnJzicNMBSnEXTMgyu1hbjNqoQ7vHhtk=
Authentication-Results: myt5-18b0513eae63.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <9c8018ba-4808-73eb-a6c2-13c194097d4b@ya.ru>
Date:   Sat, 14 Jan 2023 12:30:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next] unix: Improve locking scheme in
 unix_show_fdinfo()
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
References: <9d951e81-2051-5b67-a394-2cb819e5bf57@ya.ru>
 <202301141349.PUsDqg8t-lkp@intel.com>
From:   Kirill Tkhai <tkhai@ya.ru>
In-Reply-To: <202301141349.PUsDqg8t-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.01.2023 08:30, kernel test robot wrote:
> Hi Kirill,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Kirill-Tkhai/unix-Improve-locking-scheme-in-unix_show_fdinfo/20230114-082118
> patch link:    https://lore.kernel.org/r/9d951e81-2051-5b67-a394-2cb819e5bf57%40ya.ru
> patch subject: [PATCH net-next] unix: Improve locking scheme in unix_show_fdinfo()
> config: x86_64-rhel-8.3-rust
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/1c3b5ffa3da1bc362d28489fc860432b09e8a451
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Kirill-Tkhai/unix-Improve-locking-scheme-in-unix_show_fdinfo/20230114-082118
>         git checkout 1c3b5ffa3da1bc362d28489fc860432b09e8a451
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/unix/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> net/unix/af_unix.c:824:12: warning: variable 'nr_fds' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>                    else if (s_state == TCP_LISTEN)
>                             ^~~~~~~~~~~~~~~~~~~~~
>    net/unix/af_unix.c:827:34: note: uninitialized use occurs here
>                    seq_printf(m, "scm_fds: %u\n", nr_fds);
>                                                   ^~~~~~
>    net/unix/af_unix.c:824:8: note: remove the 'if' if its condition is always true
>                    else if (s_state == TCP_LISTEN)
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~
>    net/unix/af_unix.c:812:12: note: initialize the variable 'nr_fds' to silence this warning
>            int nr_fds;
>                      ^
>                       = 0

Strange, my gcc didn't warn me... I will send v2.

>    1 warning generated.
> 
> 
> vim +824 net/unix/af_unix.c
> 
>    806	
>    807	static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
>    808	{
>    809		struct sock *sk = sock->sk;
>    810		unsigned char s_state;
>    811		struct unix_sock *u;
>    812		int nr_fds;
>    813	
>    814		if (sk) {
>    815			s_state = READ_ONCE(sk->sk_state);
>    816			u = unix_sk(sk);
>    817	
>    818			/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
>    819			 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
>    820			 * SOCK_DGRAM is ordinary. So, no lock is needed.
>    821			 */
>    822			if (sock->type == SOCK_DGRAM || s_state == TCP_ESTABLISHED)
>    823				nr_fds = atomic_read(&u->scm_stat.nr_fds);
>  > 824			else if (s_state == TCP_LISTEN)
>    825				nr_fds = unix_count_nr_fds(sk);
>    826	
>    827			seq_printf(m, "scm_fds: %u\n", nr_fds);
>    828		}
>    829	}
>    830	#else
>    831	#define unix_show_fdinfo NULL
>    832	#endif
>    833	
> 

