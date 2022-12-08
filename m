Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A166468A3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 06:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiLHFlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 00:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLHFlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 00:41:09 -0500
Received: from mx02lb.world4you.com (mx02lb.world4you.com [81.19.149.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3905E81DB7;
        Wed,  7 Dec 2022 21:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=blHgNHLOg0zzqk7/Dd1JvOCdXk5X+N0gS2mQmQD1Ka4=; b=gV6pH+x5RypvKHm+CUcEJUj3n3
        kVWbLT6+L69XAoM+mdcPkSgXXBlLiavJpqMewg7cHnawbsEDi2+GDxVcZrkfr8dGW57KDkr/pCgre
        mc+1ZMxlaiC3poX51YSiKI729HTVQfGM9oFteAaUakeZwaHIaGt7MtSmSkX8oyOYIDzI=;
Received: from [88.117.56.227] (helo=hornet.engleder.at)
        by mx02lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p39eb-0002ut-F1; Thu, 08 Dec 2022 06:41:05 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 0/6] tsnep: XDP support
Date:   Thu,  8 Dec 2022 06:40:39 +0100
Message-Id: <20221208054045.3600-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement XDP support for tsnep driver. I tried to follow existing
drivers like igb/igc as far as possible. Some prework was already done
in previous patch series, so in this series only actual XDP stuff is
included.

Thanks for the NetDev 0x14 slides "Add XDP support on a NIC driver".

v2:
- move tsnep_xdp_xmit_back() to commit where it is used (Paolo Abeni)
- remove inline from tsnep_rx_offset() (Paolo Abeni)
- remove inline from tsnep_rx_offset_xdp() (Paolo Abeni)
- simplify tsnep_xdp_run_prog() call by moving xdp_status update to it (Paolo Abeni)

Gerhard Engleder (6):
  tsnep: Add adapter down state
  tsnep: Add XDP TX support
  tsnep: Support XDP BPF program setup
  tsnep: Prepare RX buffer for XDP support
  tsnep: Add RX queue info for XDP support
  tsnep: Add XDP RX support

 drivers/net/ethernet/engleder/Makefile     |   2 +-
 drivers/net/ethernet/engleder/tsnep.h      |  31 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 423 +++++++++++++++++++--
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  27 ++
 4 files changed, 453 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c

-- 
2.30.2

