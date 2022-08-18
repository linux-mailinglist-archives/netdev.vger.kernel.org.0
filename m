Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83705597D47
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243230AbiHREYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 00:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243253AbiHREX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 00:23:57 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA2AB7D4;
        Wed, 17 Aug 2022 21:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660796637; x=1692332637;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=T9t+BwVCPnBTVq7Nxc/0MBdx1bAE4u4hZONSTIagpYA=;
  b=qy6E14WYhvsAVyixJ23YhcPMD7BmtmmFZIkWe+KNxYexttajn3UvrhWr
   eIt6o2CUm5qKJIWdmqUb2/FcgsCHbEYrM7CEF87HmxaIyGH/zQP3JWod9
   muEKUey5RznzbW7oezBDia8R9axsVFxmr5Ka/RU+EKhQvTBc+zwPQUiGH
   4=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="250097160"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-d803d33a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:23:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-d803d33a.us-west-2.amazon.com (Postfix) with ESMTPS id A956C8518A;
        Thu, 18 Aug 2022 04:23:54 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 04:23:53 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.158) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 04:23:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 bpf 0/4] bpf: sysctl: Fix data-races around net.core.bpf_XXX.
Date:   Wed, 17 Aug 2022 21:23:35 -0700
Message-ID: <20220818042339.82992-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D43UWC002.ant.amazon.com (10.43.162.172) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series split from [0] fixes data-races around 4 bpf knobs
in net_core_table.

[0]: https://lore.kernel.org/netdev/20220818035227.81567-1-kuniyu@amazon.com/


Kuniyuki Iwashima (4):
  bpf: Fix data-races around bpf_jit_enable.
  bpf: Fix data-races around bpf_jit_harden.
  bpf: Fix data-races around bpf_jit_kallsyms.
  bpf: Fix a data-race around bpf_jit_limit.

 arch/arm/net/bpf_jit_32.c        |  2 +-
 arch/arm64/net/bpf_jit_comp.c    |  2 +-
 arch/mips/net/bpf_jit_comp.c     |  2 +-
 arch/powerpc/net/bpf_jit_comp.c  |  5 +++--
 arch/riscv/net/bpf_jit_core.c    |  2 +-
 arch/s390/net/bpf_jit_comp.c     |  2 +-
 arch/sparc/net/bpf_jit_comp_32.c |  5 +++--
 arch/sparc/net/bpf_jit_comp_64.c |  5 +++--
 arch/x86/net/bpf_jit_comp.c      |  2 +-
 arch/x86/net/bpf_jit_comp32.c    |  2 +-
 include/linux/filter.h           | 16 ++++++++++------
 kernel/bpf/core.c                |  2 +-
 net/core/sysctl_net_core.c       |  4 ++--
 13 files changed, 29 insertions(+), 22 deletions(-)

-- 
2.30.2

