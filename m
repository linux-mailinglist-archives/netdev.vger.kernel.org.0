Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7384608B8
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfGEPFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:05:08 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39105 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGEPFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:05:07 -0400
Received: by mail-lf1-f65.google.com with SMTP id v85so3593236lfa.6
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=t4hREu48yBnNnsCNkLAAjVA+oW6+KCJ+i2tHd3IV11E=;
        b=XucT8mV2bn8M6+M5EBsqcx85sYF0juNmA8uMTvRwSlotpvmRHojKtgF3XR01w/4vTe
         rFgwuvm8O2C8jvcS8CPPL0Y43ZAmtyLOR8q5umFqHOkP18t0hCQtxwFzabcZzw3sWo6J
         On4/cQhQ2Sb9UTZtouhT+zyRzv1ysEepTo8Kh7kwptKpy44YjWq+B6+fdFiHqFobRtkz
         qq18nU+g8j7mmV4811k0DN8ySLwnp43/Pq5CzQqtxOz64Vzyijwt8mQfRmPg3XiZHhjy
         KX9MMPu9CmSrTHzVyE30Z6hFhLhWJX8t5BO2Q3FrGGw8zNpeBO5JCL2NJHO7lxmm+RmP
         F6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t4hREu48yBnNnsCNkLAAjVA+oW6+KCJ+i2tHd3IV11E=;
        b=QG9B5rTY36s9uVojUNZXssfK5ppxrMHWKvI1EZq+aZUTZYSMl2os3QzxNQHdBqYaZL
         tjkbGrmmnmqMUn3sQzKKqI01TemQ0gzvgdkAvMfihiZEVvClkqlbr7tm1vgTC5ucbkj+
         dd5X9qOz6HHQJLh/NK83l+V0IzYqbChlo3If6LTrjHn1ELfrTZy94YwECoxce0Py9d9w
         D0dfK14OtajWQ0MM/O4Qe7/1YkwzfY606KP2ol4Y/Wbie62p1ksI8GNypu8D3uC++6UY
         YbOIPb509f2J1KJYLhcdh/Fqn8MDC5nEQIS8m06cgV5krrXXMkG1wM4SDEwwJj2TgCyy
         sRrg==
X-Gm-Message-State: APjAAAUcq7Ihgx29qsIrd0uaD5oLPeO5pr6rScLznab2tKgkvn9NX8J1
        p4zUEYsH9VQkR+IZ1m4OKU//7A==
X-Google-Smtp-Source: APXvYqwYRYc3jsjZ+mK2EnOEXmF8Zex6VVfLBO6dpr1GmnEL7ua1JEJo/rRGGAShvVcj57nHCOQOWw==
X-Received: by 2002:ac2:5336:: with SMTP id f22mr2194391lfh.180.1562339105564;
        Fri, 05 Jul 2019 08:05:05 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id y4sm1433660lfc.56.2019.07.05.08.05.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 08:05:04 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v8 net-next 0/5] net: ethernet: ti: cpsw: Add XDP support
Date:   Fri,  5 Jul 2019 18:04:57 +0300
Message-Id: <20190705150502.6600-1-ivan.khoronzhuk@linaro.org>
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

