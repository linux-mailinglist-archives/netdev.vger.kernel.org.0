Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A772E598912
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344861AbiHRQlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344884AbiHRQlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:41:36 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4097C00D9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660840895; x=1692376895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A62wNNnyRHyyzxZ6tSE+cebI/CQZDEfNq/drzCzLzj8=;
  b=DP0FQuPyPAcl0JLeuSlxpZh+heIXLMXTcp1fDdgmOmwxpQ83bFAV9YMu
   iFJ8Ov7EsFjWRHot5dKpY+VB742wZLw4+p7LXjGkprittLwW4F3oM6FzC
   TWbeIxY+IaD+BhbMPCfS3P3IBa90GNgBiSoKWlkogNU81ruomPCTUdkaL
   0=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="219007245"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 16:41:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id 9F1FF44E57;
        Thu, 18 Aug 2022 16:41:14 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 16:41:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.158) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 16:41:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <nathan@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <kbuild-all@lists.01.org>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <lkp@intel.com>, <llvm@lists.linux.dev>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH v2 net 13/17] net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
Date:   Thu, 18 Aug 2022 09:41:04 -0700
Message-ID: <20220818164104.33802-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Yv5nd3cVX2ZKysC/@dev-arch.thelio-3990X>
References: <Yv5nd3cVX2ZKysC/@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D45UWA001.ant.amazon.com (10.43.160.91) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Nathan Chancellor <nathan@kernel.org>
Date:   Thu, 18 Aug 2022 09:23:19 -0700
> On Thu, Aug 18, 2022 at 08:01:54AM -0700, Kuniyuki Iwashima wrote:
> > From:   kernel test robot <lkp@intel.com>
> > Date:   Thu, 18 Aug 2022 16:51:37 +0800
> > > Hi Kuniyuki,
> > > 
> > > Thank you for the patch! Yet something to improve:
> > > 
> > > [auto build test ERROR on net/master]
> > > 
> > > url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/net-sysctl-Fix-data-races-around-net-core-XXX/20220818-115941
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git fc4aaf9fb3c99bcb326d52f9d320ed5680bd1cee
> > > config: riscv-randconfig-r032-20220818 (https://download.01.org/0day-ci/archive/20220818/202208181615.Lu9xjiEv-lkp@intel.com/config)
> > > compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project aed5e3bea138ce581d682158eb61c27b3cfdd6ec)
> > > reproduce (this is a W=1 build):
> > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         # install riscv cross compiling tool for clang build
> > >         # apt-get install binutils-riscv64-linux-gnu
> > >         # https://github.com/intel-lab-lkp/linux/commit/6bc3dfb3dc4862f4e00ba93c45cd5c0251b85d5b
> > >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> > >         git fetch --no-tags linux-review Kuniyuki-Iwashima/net-sysctl-Fix-data-races-around-net-core-XXX/20220818-115941
> > >         git checkout 6bc3dfb3dc4862f4e00ba93c45cd5c0251b85d5b
> > >         # save the config file
> > >         mkdir build_dir && cp config build_dir/.config
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash
> > > 
> > > If you fix the issue, kindly add following tag where applicable
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > 
> > > All errors (new ones prefixed by >>):
> > > 
> > > >> ld.lld: error: undefined symbol: sysctl_fb_tunnels_only_for_init_net
> > >    >>> referenced by ip_tunnel.c
> > >    >>>               ipv4/ip_tunnel.o:(ip_tunnel_init_net) in archive net/built-in.a
> > >    >>> referenced by ip_tunnel.c
> > >    >>>               ipv4/ip_tunnel.o:(ip_tunnel_init_net) in archive net/built-in.a
> > 
> > Hmm... I tested allmodconfig with x86_64 but it seems not enough...
> > 
> > I don't think just using READ_ONCE() causes regression.
> > Is this really regression or always-broken stuff in some arch,
> > or ... clang 16?
> > 
> > Anyway, I'll take a look.
> 
> You'll see the same error with the same configuration and GCC:
> 
> riscv64-linux-gnu-ld: net/ipv4/ip_tunnel.o: in function `.L536':
> ip_tunnel.c:(.text+0x1d4a): undefined reference to `sysctl_fb_tunnels_only_for_init_net'
> riscv64-linux-gnu-ld: ip_tunnel.c:(.text+0x1d4e): undefined reference to `sysctl_fb_tunnels_only_for_init_net'
> 
> $ scripts/config --file build/riscv/.config -s SYSCTL
> undef
> 
> Prior to your change, the '!IS_ENABLED(CONFIG_SYSCTL)' would cause
> net_has_fallback_tunnels() to unconditionally 'return 1' in the
> CONFIG_SYSCTL=n case,

Yes, you are right.
I've just noticed it and this fixed the error.
Also, I did the same mistake in the 14th patch...
Thank you, Nathan!

---8<---
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2563d30736e9..78dd63a5c7c8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -640,9 +640,14 @@ extern int sysctl_devconf_inherit_init_net;
  */
 static inline bool net_has_fallback_tunnels(const struct net *net)
 {
-	return !IS_ENABLED(CONFIG_SYSCTL) ||
-	       !sysctl_fb_tunnels_only_for_init_net ||
-	       (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1);
+#if IS_ENABLED(CONFIG_SYSCTL)
+	int fb_tunnels_only_for_init_net = READ_ONCE(sysctl_fb_tunnels_only_for_init_net);
+
+	return !fb_tunnels_only_for_init_net ||
+		(net_eq(net, &init_net) && fb_tunnels_only_for_init_net == 1);
+#else
+	return true;
+#endif
 }
 
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
---8<---


> meaning 'fb_tunnels_only_for_init_net' was never
> emitted in the final assembly so the linker would not complain about it
> never being defined (the kernel relies on this trick a lot, which is why
> you cannot build the kernel with -O0).
> 
> After your change, sysctl_fb_tunnels_only_for_init_net is
> unconditionally used but it is only defined in sysctl_net_core.c, which
> is only built when CONFIG_SYSCTL=y, hence the link error.
> 
> I suspect hoisting '!IS_ENABLED(CONFIG_SYSCTL)' out of the return into
> its own conditional would fix the error:
> 
>   static inline bool net_has_fallback_tunnels(const struct net *net)
>   {
>       int fb_tunnels_only_for_init_net;
> 
>       if (!IS_ENABLED(CONFIG_SYSCTL))
>           return true;
> 
>       fb_tunnels_only_for_init_net = READ_ONCE(sysctl_fb_tunnels_only_for_init_net);
> 
>       return !fb_tunnels_only_for_init_net ||
>              (net == &init_net && fb_tunnels_only_for_init_net == 1)
>   }
> 
> Cheers,
> Nathan
