Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B05159029C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237398AbiHKQK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbiHKQJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:09:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F7CA4B19;
        Thu, 11 Aug 2022 08:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52C01B82160;
        Thu, 11 Aug 2022 15:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DF6C43140;
        Thu, 11 Aug 2022 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233300;
        bh=wjXb44oYEnAlhU16rkHyBpckEauNUBNXCbEuTpPCOrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDiRa0bZ954S8IrYamI0dCLcrStQbQceg1RUrryU4CX5/wq0TLgEdE7Ozn+YYPKBJ
         oCBpt5P1QyS9DHpYU2U10wxiNsf/baky47DBVVoVkOcwcYeez1cLw++mXYWZW3LmVa
         lEqXUno3dougC3Jw889nDbT14vswXSw35RP2MTahJE5L/+YpnumnzdAvSllW5/Zl6+
         7LGgg9w99n82FvoCJtukngJmSS6IEcuVH2ZEXpO+0EExWZf2Mz9XFXqoswve5SmXI7
         Ko3NzjT1qOTxzCBZ+RCVAG5VydEiUc5iS9v52QLzZ60Z1mKwUvLqqAOlan+HIYWz/4
         NETkFLHzQ5llw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jie2x Zhou <jie2x.zhou@intel.com>,
        kernel test robot <lkp@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 81/93] bpf/selftests: Fix couldn't retrieve pinned program in xdp veth test
Date:   Thu, 11 Aug 2022 11:42:15 -0400
Message-Id: <20220811154237.1531313-81-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie2x Zhou <jie2x.zhou@intel.com>

[ Upstream commit f664f9c6b4a1bb9a10af812df0fbbf6aac28fcc6 ]

Before change:

  selftests: bpf: test_xdp_veth.sh
  Couldn't retrieve pinned program '/sys/fs/bpf/test_xdp_veth/progs/redirect_map_0': No such file or directory
  selftests: xdp_veth [SKIP]
  ok 20 selftests: bpf: test_xdp_veth.sh # SKIP

After change:

  PING 10.1.1.33 (10.1.1.33) 56(84) bytes of data.
  64 bytes from 10.1.1.33: icmp_seq=1 ttl=64 time=0.320 ms
  --- 10.1.1.33 ping statistics ---
  1 packets transmitted, 1 received, 0% packet loss, time 0ms
  rtt min/avg/max/mdev = 0.320/0.320/0.320/0.000 ms
  selftests: xdp_veth [PASS]

For the test case, the following can be found:

  ls /sys/fs/bpf/test_xdp_veth/progs/redirect_map_0
  ls: cannot access '/sys/fs/bpf/test_xdp_veth/progs/redirect_map_0': No such file or directory
  ls /sys/fs/bpf/test_xdp_veth/progs/
  xdp_redirect_map_0  xdp_redirect_map_1  xdp_redirect_map_2

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jie2x Zhou <jie2x.zhou@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220719082430.9916-1-jie2x.zhou@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xdp_veth.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
index 392d28cc4e58..49936c4c8567 100755
--- a/tools/testing/selftests/bpf/test_xdp_veth.sh
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -106,9 +106,9 @@ bpftool prog loadall \
 bpftool map update pinned $BPF_DIR/maps/tx_port key 0 0 0 0 value 122 0 0 0
 bpftool map update pinned $BPF_DIR/maps/tx_port key 1 0 0 0 value 133 0 0 0
 bpftool map update pinned $BPF_DIR/maps/tx_port key 2 0 0 0 value 111 0 0 0
-ip link set dev veth1 xdp pinned $BPF_DIR/progs/redirect_map_0
-ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
-ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
+ip link set dev veth1 xdp pinned $BPF_DIR/progs/xdp_redirect_map_0
+ip link set dev veth2 xdp pinned $BPF_DIR/progs/xdp_redirect_map_1
+ip link set dev veth3 xdp pinned $BPF_DIR/progs/xdp_redirect_map_2
 
 ip -n ${NS1} link set dev veth11 xdp obj xdp_dummy.o sec xdp
 ip -n ${NS2} link set dev veth22 xdp obj xdp_tx.o sec xdp
-- 
2.35.1

