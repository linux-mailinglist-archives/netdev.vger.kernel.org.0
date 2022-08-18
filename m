Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791F65988CB
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244868AbiHRQ0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344866AbiHRQZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:25:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE2315700
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B620CB821CE
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 16:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AC4C433D6;
        Thu, 18 Aug 2022 16:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660839801;
        bh=BBgDTOJtsTiJZXPOlB5twytLW+iZE8gXpa7Oj82HMwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRsrrvwcSAEn8HO3HjPuqSDUr9CALN2RUmjv1CgfCbPc7SUFze42Y1NZtVG7i/qws
         A9aqZvvd7RHNQQoMrZ21+z22MIpScxRw4GdrjJ7GzsvPPDASBRDlvVbDV+qL8Q0GpW
         G+jV5RMh3LcsI8AxzC25XdSj9KpIBMnQIPZ3pqVyDeJ8SkE3ZnU3hTtIlczhjnvVAF
         htJbaydJVZUUtJGoRhvSYphZLpW1gy4IUld8cgSz0BLuEkkIs2BBMMkSmv4JYpr7z+
         6sE7nOHYJ6/GoETQgZCC8ByJKT+GwyLD1Qtzx2cxog01aV1UQxj0cduI+5agxkLsM3
         x6Hb1jaNezv4A==
Date:   Thu, 18 Aug 2022 09:23:19 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     lkp@intel.com, davem@davemloft.net, edumazet@google.com,
        kbuild-all@lists.01.org, kuba@kernel.org, llvm@lists.linux.dev,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 net 13/17] net: Fix data-races around
 sysctl_fb_tunnels_only_for_init_net.
Message-ID: <Yv5nd3cVX2ZKysC/@dev-arch.thelio-3990X>
References: <202208181615.Lu9xjiEv-lkp@intel.com>
 <20220818150154.29112-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818150154.29112-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 08:01:54AM -0700, Kuniyuki Iwashima wrote:
> From:   kernel test robot <lkp@intel.com>
> Date:   Thu, 18 Aug 2022 16:51:37 +0800
> > Hi Kuniyuki,
> > 
> > Thank you for the patch! Yet something to improve:
> > 
> > [auto build test ERROR on net/master]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/net-sysctl-Fix-data-races-around-net-core-XXX/20220818-115941
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git fc4aaf9fb3c99bcb326d52f9d320ed5680bd1cee
> > config: riscv-randconfig-r032-20220818 (https://download.01.org/0day-ci/archive/20220818/202208181615.Lu9xjiEv-lkp@intel.com/config)
> > compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project aed5e3bea138ce581d682158eb61c27b3cfdd6ec)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install riscv cross compiling tool for clang build
> >         # apt-get install binutils-riscv64-linux-gnu
> >         # https://github.com/intel-lab-lkp/linux/commit/6bc3dfb3dc4862f4e00ba93c45cd5c0251b85d5b
> >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> >         git fetch --no-tags linux-review Kuniyuki-Iwashima/net-sysctl-Fix-data-races-around-net-core-XXX/20220818-115941
> >         git checkout 6bc3dfb3dc4862f4e00ba93c45cd5c0251b85d5b
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash
> > 
> > If you fix the issue, kindly add following tag where applicable
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> ld.lld: error: undefined symbol: sysctl_fb_tunnels_only_for_init_net
> >    >>> referenced by ip_tunnel.c
> >    >>>               ipv4/ip_tunnel.o:(ip_tunnel_init_net) in archive net/built-in.a
> >    >>> referenced by ip_tunnel.c
> >    >>>               ipv4/ip_tunnel.o:(ip_tunnel_init_net) in archive net/built-in.a
> 
> Hmm... I tested allmodconfig with x86_64 but it seems not enough...
> 
> I don't think just using READ_ONCE() causes regression.
> Is this really regression or always-broken stuff in some arch,
> or ... clang 16?
> 
> Anyway, I'll take a look.

You'll see the same error with the same configuration and GCC:

riscv64-linux-gnu-ld: net/ipv4/ip_tunnel.o: in function `.L536':
ip_tunnel.c:(.text+0x1d4a): undefined reference to `sysctl_fb_tunnels_only_for_init_net'
riscv64-linux-gnu-ld: ip_tunnel.c:(.text+0x1d4e): undefined reference to `sysctl_fb_tunnels_only_for_init_net'

$ scripts/config --file build/riscv/.config -s SYSCTL
undef

Prior to your change, the '!IS_ENABLED(CONFIG_SYSCTL)' would cause
net_has_fallback_tunnels() to unconditionally 'return 1' in the
CONFIG_SYSCTL=n case, meaning 'fb_tunnels_only_for_init_net' was never
emitted in the final assembly so the linker would not complain about it
never being defined (the kernel relies on this trick a lot, which is why
you cannot build the kernel with -O0).

After your change, sysctl_fb_tunnels_only_for_init_net is
unconditionally used but it is only defined in sysctl_net_core.c, which
is only built when CONFIG_SYSCTL=y, hence the link error.

I suspect hoisting '!IS_ENABLED(CONFIG_SYSCTL)' out of the return into
its own conditional would fix the error:

  static inline bool net_has_fallback_tunnels(const struct net *net)
  {
      int fb_tunnels_only_for_init_net;

      if (!IS_ENABLED(CONFIG_SYSCTL))
          return true;

      fb_tunnels_only_for_init_net = READ_ONCE(sysctl_fb_tunnels_only_for_init_net);

      return !fb_tunnels_only_for_init_net ||
             (net == &init_net && fb_tunnels_only_for_init_net == 1)
  }

Cheers,
Nathan
