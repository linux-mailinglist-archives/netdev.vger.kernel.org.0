Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E6562B0C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404796AbfGHVen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:34:43 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34757 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731606AbfGHVei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:34:38 -0400
Received: by mail-lj1-f194.google.com with SMTP id p17so17477217ljg.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 14:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/jUllDDZ3b7We2EmtZhggvnRSS7NBu/TTaz5tD6/PUc=;
        b=T8pbps6CRd0YYwTNpgOwCFTwOOC7K3bS+QLebfKLWanCnY22hZ2/Fzlhoz21wi9btl
         qeHAu27UExxlUyTgdNIVzORsRVkvD3PDhUCD7Z2LQRxS0R9ofH1QhUxQRs6Te1v6eGyZ
         LG1uW2nD+Ayo0T1reG8dFirp5xGI/MbJiyeG0tO5JKRgedhe7zP2ba2fOODu1NV0RFZq
         0j5U87HXsJ1iFXKpPtbeK9jKHLRN2vUICPWz3OSNeWLZZ1zqhrrdqHV2PEiI7IG2DrQV
         4/303OFQ65FkDNFHHdYHF81pcV4rhG06bASB5InaH3MQxmxx2WsbbMPYxSAN/o98cxgp
         NwQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/jUllDDZ3b7We2EmtZhggvnRSS7NBu/TTaz5tD6/PUc=;
        b=TaHjt226qKaZENwdrpSUM2U1mrDzW83A7IFZyvOh1hynikYphMOz9O6DfD/7niz8wL
         Nwwttz+vrv3sHCn9FUjed/vyp86LEhiXZxLsbe1Cxj0UrZqwKzW2CMkULQp4KYBLFrIq
         02z9Oimer9HvnFWJSa1bmgC7XFvuoaKY7H/YaMO5DZ6BCCmN8b/3WLorVm7prtfC4C/F
         33HiK/t89ruAy8upchByyXVpFGSu1uLqeXftDmGg5RJY2mXr20VcthiogFTvyHYqlHWT
         6IEpimXGma/WcmOCz4fQzEwmSKG9X/JxvqpWctogGJEF9RdRx/A2CQnLvVC+SwpM/1ZF
         xMIA==
X-Gm-Message-State: APjAAAUVl0rFbd5EOZkzVbkv1Jp7jokWkYCPmmHxwJdUk1RmpV2lnu+L
        kKpwo7SbDXRg044pbxKFyfxU4w==
X-Google-Smtp-Source: APXvYqyanSllvP+L4q7Yp4S2QCZWO8l25caUDQzKE7LWtFwOxuNGkd5k/wLMnr72X/k+Tk3RffI2HA==
X-Received: by 2002:a2e:1459:: with SMTP id 25mr8862117lju.153.1562621676013;
        Mon, 08 Jul 2019 14:34:36 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id o24sm3883096ljg.6.2019.07.08.14.34.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 14:34:35 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v9 net-next 0/5] net: ethernet: ti: cpsw: Add XDP support
Date:   Tue,  9 Jul 2019 00:34:27 +0300
Message-Id: <20190708213432.8525-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds XDP support for TI cpsw driver and base it on
page_pool allocator. It was verified on af_xdp socket drop,
af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.

It was verified with following configs enabled:
CONFIG_JIT=y
CONFIG_BPFILTER=y
CONFIG_BPF_SYSCALL=y
CONFIG_XDP_SOCKETS=y
CONFIG_BPF_EVENTS=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_BPF_JIT=y
CONFIG_CGROUP_BPF=y

Link on previous v7:
https://lkml.org/lkml/2019/7/4/715

Also regular tests with iperf2 were done in order to verify impact on
regular netstack performance, compared with base commit:
https://pastebin.com/JSMT0iZ4

v8..v9:
- fix warnings on arm64 caused by typos in type casting

v7..v8:
- corrected dma calculation based on headroom instead of hard start
- minor comment changes

v6..v7:
- rolled back to v4 solution but with small modification
- picked up patch:
  https://www.spinics.net/lists/netdev/msg583145.html
- added changes related to netsec fix and cpsw


v5..v6:
- do changes that is rx_dev while redirect/flush cycle is kept the same
- dropped net: ethernet: ti: davinci_cpdma: return handler status
- other changes desc in patches

v4..v5:
- added two plreliminary patches:
  net: ethernet: ti: davinci_cpdma: allow desc split while down
  net: ethernet: ti: cpsw_ethtool: allow res split while down
- added xdp alocator refcnt on xdp level, avoiding page pool refcnt
- moved flush status as separate argument for cpdma_chan_process
- reworked cpsw code according to last changes to allocator
- added missed statistic counter

v3..v4:
- added page pool user counter
- use same pool for ndevs in dual mac
- restructured page pool create/destroy according to the last changes in API

v2..v3:
- each rxq and ndev has its own page pool

v1..v2:
- combined xdp_xmit functions
- used page allocation w/o refcnt juggle
- unmapped page for skb netstack
- moved rxq/page pool allocation to open/close pair
- added several preliminary patches:
  net: page_pool: add helper function to retrieve dma addresses
  net: page_pool: add helper function to unmap dma addresses
  net: ethernet: ti: cpsw: use cpsw as drv data
  net: ethernet: ti: cpsw_ethtool: simplify slave loops

Ivan Khoronzhuk (5):
  net: core: page_pool: add user refcnt and reintroduce
    page_pool_destroy
  net: ethernet: ti: davinci_cpdma: add dma mapped submit
  net: ethernet: ti: davinci_cpdma: allow desc split while down
  net: ethernet: ti: cpsw_ethtool: allow res split while down
  net: ethernet: ti: cpsw: add XDP support

 .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +-
 drivers/net/ethernet/socionext/netsec.c       |   8 +-
 drivers/net/ethernet/ti/Kconfig               |   1 +
 drivers/net/ethernet/ti/cpsw.c                | 502 ++++++++++++++++--
 drivers/net/ethernet/ti/cpsw_ethtool.c        |  57 +-
 drivers/net/ethernet/ti/cpsw_priv.h           |   7 +
 drivers/net/ethernet/ti/davinci_cpdma.c       | 106 +++-
 drivers/net/ethernet/ti/davinci_cpdma.h       |   7 +-
 include/net/page_pool.h                       |  25 +
 net/core/page_pool.c                          |   8 +
 net/core/xdp.c                                |   3 +
 11 files changed, 640 insertions(+), 88 deletions(-)

-- 
2.17.1

