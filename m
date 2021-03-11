Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2892C3380B1
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCKWhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhCKWhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 273BF64F88;
        Thu, 11 Mar 2021 22:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502258;
        bh=t/u3ExuZALyqVpZMcuuwC2I8ZAGtc5veCpKTeOi0g88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNnwSSk5iIehtNvuuMqhVDAK1J5zTgYhMP0BsVnEy5Xfd2zlB/nQfSYyk4beTybLl
         uX7U0nvJNxzxBgc8fiI7IhSmNPbFNneNNFZ8/y7lNA5ClTkWmrX2Rr75nJJ7rv/UzH
         WZ2p3bRMrljVstqA9WhGB79ceuj4oXuZh2bgnCXBCDSXSNit9kelVK26VdF7uZ518J
         4xw+jIY6ZPa4dtF+uTH3TzBI3pRjrTJSXWy4WLdxv+O0qMNW2kltngehcGBvtqGkKh
         Y/gCdIsF17fs1wLZjP/q4f/YiMY6I3k/zpca0rYjz6lIlfEQDQb+sN3slTxOUjM4Yj
         N0wgamu4pwwKg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Add missing include
Date:   Thu, 11 Mar 2021 14:37:17 -0800
Message-Id: <20210311223723.361301-10-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

When CONFIG_IPV6 is disabled the header nexthop.h is not included by
fib_notifier.h which causes tc_tun_encap.c to fail to compile:

   In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:5:
   In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h:7:
   In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h:7:
   In file included from drivers/net/ethernet/mellanox/mlx5/core/en_tc.h:40:
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:78:5: warning: no previous prototype for function 'mlx5e_tc_tun_update_header_ipv6' [-Wmissing-prototypes]
   int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
       ^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:78:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
   ^
   static
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:12: error: implicit declaration of function 'fib_info_nh' [-Werror,-Wimplicit-function-declaration]
           fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
                     ^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:12: note: did you mean 'fib_info_put'?
   include/net/ip_fib.h:528:20: note: 'fib_info_put' declared here
   static inline void fib_info_put(struct fib_info *fi)
                      ^
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:42: error: member reference type 'int' is not a pointer
           fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ^
   include/net/ip_fib.h:113:21: note: expanded from macro 'fib_nh_dev'
   #define fib_nh_dev              nh_common.nhc_dev
                                   ^
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1552:13: error: incomplete definition of type 'struct fib6_entry_notifier_info'
           fen_info = container_of(info, struct fib6_entry_notifier_info, info);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:694:51: note: expanded from macro 'container_of'
           BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&   \
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:256:74: note: expanded from macro '__same_type'
   #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
                                                                            ^
   include/linux/build_bug.h:39:58: note: expanded from macro 'BUILD_BUG_ON_MSG'
   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                       ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
   include/linux/compiler_types.h:320:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
           ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:308:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
           ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:300:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1546:9: note: forward declaration of 'struct fib6_entry_notifier_info'
           struct fib6_entry_notifier_info *fen_info;
                  ^
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1552:13: error: offsetof of incomplete type 'struct fib6_entry_notifier_info'
           fen_info = container_of(info, struct fib6_entry_notifier_info, info);
                      ^                  ~~~~~~
   include/linux/kernel.h:697:21: note: expanded from macro 'container_of'
           ((type *)(__mptr - offsetof(type, member))); })
                              ^        ~~~~
   include/linux/stddef.h:17:32: note: expanded from macro 'offsetof'
   #define offsetof(TYPE, MEMBER)  __compiler_offsetof(TYPE, MEMBER)
                                   ^                   ~~~~
   include/linux/compiler_types.h:140:35: note: expanded from macro '__compiler_offsetof'
   #define __compiler_offsetof(a, b)       __builtin_offsetof(a, b)
                                           ^                  ~
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1546:9: note: forward declaration of 'struct fib6_entry_notifier_info'
           struct fib6_entry_notifier_info *fen_info;
                  ^
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1552:11: error: assigning to 'struct fib6_entry_notifier_info *' from incompatible type 'void'
           fen_info = container_of(info, struct fib6_entry_notifier_info, info);
                    ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1553:12: error: implicit declaration of function 'fib6_info_nh_dev' [-Werror,-Wimplicit-function-declaration]
           fib_dev = fib6_info_nh_dev(fen_info->rt);
                     ^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1553:37: error: incomplete definition of type 'struct fib6_entry_notifier_info'
           fib_dev = fib6_info_nh_dev(fen_info->rt);
                                      ~~~~~~~~^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1546:9: note: forward declaration of 'struct fib6_entry_notifier_info'
           struct fib6_entry_notifier_info *fen_info;
                  ^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1555:14: error: incomplete definition of type 'struct fib6_entry_notifier_info'
               fen_info->rt->fib6_dst.plen != 128)
               ~~~~~~~~^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1546:9: note: forward declaration of 'struct fib6_entry_notifier_info'
           struct fib6_entry_notifier_info *fen_info;
                  ^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1562:39: error: incomplete definition of type 'struct fib6_entry_notifier_info'
           memcpy(&key.endpoint_ip.v6, &fen_info->rt->fib6_dst.addr,
                                        ~~~~~~~~^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1546:9: note: forward declaration of 'struct fib6_entry_notifier_info'
           struct fib6_entry_notifier_info *fen_info;
                  ^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1563:24: error: incomplete definition of type 'struct fib6_entry_notifier_info'
                  sizeof(fen_info->rt->fib6_dst.addr));
                         ~~~~~~~~^
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1546:9: note: forward declaration of 'struct fib6_entry_notifier_info'
           struct fib6_entry_notifier_info *fen_info;
                  ^
   1 warning and 10 errors generated.

Manually include net/nexthop.h in tc_tun_encap.c.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 6a116335bb21..32d06fe94acc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021 Mellanox Technologies. */
 
 #include <net/fib_notifier.h>
+#include <net/nexthop.h>
 #include "tc_tun_encap.h"
 #include "en_tc.h"
 #include "tc_tun.h"
-- 
2.29.2

