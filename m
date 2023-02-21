Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB269DB7B
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 08:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbjBUHvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 02:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjBUHvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 02:51:47 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F8A233C7;
        Mon, 20 Feb 2023 23:51:44 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0VcBErAe_1676965900;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VcBErAe_1676965900)
          by smtp.aliyun-inc.com;
          Tue, 21 Feb 2023 15:51:41 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        bpf@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] xsk: add linux/vmalloc.h to xsk.c
Date:   Tue, 21 Feb 2023 15:51:40 +0800
Message-Id: <20230221075140.46988-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
MIME-Version: 1.0
X-Git-Hash: 0548370bf7fd
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the failure of the compilation under the sh4.

Because we introduced remap_vmalloc_range() earlier, this has caused
the compilation failure on the sh4 platform. So this introduction of the
header file of linux/vmalloc.h.

config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230221/202302210041.kpPQLlNQ-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=9f78bf330a66cd400b3e00f370f597e9fa939207
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 9f78bf330a66cd400b3e00f370f597e9fa939207
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash net/

Fixes: 9f78bf330a66 ("xsk: support use vaddr as ring")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302210041.kpPQLlNQ-lkp@intel.com/
---
 net/xdp/xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 45eef5af0a51..2ac58b282b5e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -22,6 +22,7 @@
 #include <linux/net.h>
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
+#include <linux/vmalloc.h>
 #include <net/xdp_sock_drv.h>
 #include <net/busy_poll.h>
 #include <net/xdp.h>
-- 
2.32.0.3.g01195cf9f

