Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B67D6D3A05
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 21:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjDBTix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 15:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBTiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 15:38:52 -0400
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F398A26C;
        Sun,  2 Apr 2023 12:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rotj83wze4t1sbbS+I3e4YBLaI6HPS7zMBZwoW6zk/0=; b=KGLPjsiz+ywD3mCYn53avmOOqZ
        g44VjzjY8EWruO0egdQMCJLShDMhiEFnNw2U/vJpDq+d/hJFDJpVcsO/hyPOWtZWu/BByhjSadViQ
        hjGVYayjhm0KK9nO0fSJpRy2lC+s5wZ7PrvZUjxI1hhfFtSyVSySsf8k0fjGTAX/QQio=;
Received: from [88.117.56.218] (helo=hornet.engleder.at)
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pj3XK-0007Gn-MY; Sun, 02 Apr 2023 21:38:46 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/5] tsnep: XDP socket zero-copy support
Date:   Sun,  2 Apr 2023 21:38:33 +0200
Message-Id: <20230402193838.54474-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement XDP socket zero-copy support for tsnep driver. I tried to
follow existing drivers like igc as far as possible. But one main
difference is that tsnep does not need any reconfiguration for XDP BPF
program setup. So I decided to keep this behavior no matter if a XSK
pool is used or not. As a result, tsnep starts using the XSK pool even
if no XDP BPF program is available.

Another difference is that I tried to prevent potentially failing
allocations during XSK pool setup. E.g. both memory models for page pool
and XSK pool are registered all the time. Thus, XSK pool setup cannot
end up with not working queues.

Some prework is done to reduce the last two XSK commits to actual XSK
changes.

Gerhard Engleder (5):
  tsnep: Rework TX/RX queue initialization
  tsnep: Add functions for queue enable/disable
  tsnep: Move skb receive action to separate function
  tsnep: Add XDP socket zero-copy RX support
  tsnep: Add XDP socket zero-copy TX support

 drivers/net/ethernet/engleder/tsnep.h      |   9 +
 drivers/net/ethernet/engleder/tsnep_main.c | 770 ++++++++++++++++++---
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  67 ++
 3 files changed, 738 insertions(+), 108 deletions(-)

-- 
2.30.2

