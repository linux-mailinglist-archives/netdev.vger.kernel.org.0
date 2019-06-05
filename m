Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A2C35DCA
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfFENUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:20:15 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:40562 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfFENUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:20:15 -0400
Received: by mail-lf1-f50.google.com with SMTP id a9so17646471lff.7
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 06:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=DO7D5eGfZPh8QvxGU3q/q3NaNXnYXn2zGQBCFbLpPDQ=;
        b=beh0BL6GcCR20DqoSBbg1q9zX26ZweZ4cxqvK5XqGFC0YgWE/zUAtf+vzocqFqAIHf
         +igysvAnFP/0stEjHfGRV72UA6kNEUpVGbCzR3PunExIPEXd6unoE674F+AGlXHFzjt/
         8NS8uRWNaYDT5IEMzIG4H/1OrTlsYliyj9CMuWA3HV2gmUUm8nkj0WSfjqpm8QvMEYDf
         ix2UPw83lTFBZPdU+RN6oQSq2xahk63I0at4HboglznNRiRVGqfb0tpfTTbAJFa3W6ie
         rWnoXpoAqfhBQV0B3Gt9Rmf2ZdMqqT6SxcIjX/TfwnfvKy6cQ6loTHwJFwOZwDI0ayWQ
         X+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DO7D5eGfZPh8QvxGU3q/q3NaNXnYXn2zGQBCFbLpPDQ=;
        b=XKPoA99Xb5ZcSwv9pDcQ8iRGiNrxiwOxQgupbQt5UISEGz0QwVS2KLU8puoKSbMG9r
         XBEjPFkfJJZnm/eBP63ET2sVt8do4JWZDLMWMNw0gGpvQX4VukZy9Z9eLbWw7HbGL9C/
         Lw+G+Md0w0XYk0zsLGH7cCxJVhoTsR6ChFtnqSvAQzNZm4LW8eRU/6eD5/O9cAl71Bdp
         Zixt9uLsWxCaU0i2av5QJpD0kubyVj3QzlHPSg5UcZK3aepV1T8L8GrGCKJfE/5a8VMu
         5xzVo7x28fkBZkvc3oOYRhpo7J5Eii9M4j/TkH+dTIgj/0wTFDyOiZ/HdjbqUaZJKuJh
         bHZQ==
X-Gm-Message-State: APjAAAUvHLFYMs+NdCDbaSBsfaw8Hx7XxzcNAgg+cbeTkIop7Fyq2NAU
        68lMu7xkqws2qCiNYGL5hjHplQ==
X-Google-Smtp-Source: APXvYqxnMEac5uvICE+jqkJZ0l9bWQ/ao8lR2Ti7ZO064/CZvxjhrADWlHRjdVyo1QEdZZg6tDX8AA==
X-Received: by 2002:ac2:59c6:: with SMTP id x6mr17692240lfn.169.1559740813157;
        Wed, 05 Jun 2019 06:20:13 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id t3sm1893259lfk.59.2019.06.05.06.20.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 06:20:12 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v3 net-next 0/7] net: ethernet: ti: cpsw: Add XDP support
Date:   Wed,  5 Jun 2019 16:20:02 +0300
Message-Id: <20190605132009.10734-1-ivan.khoronzhuk@linaro.org>
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

Link on previous v2:
https://lkml.org/lkml/2019/5/30/1315

Also regular tests with iperf2 were done in order to verify impact on
regular netstack performance, compared with base commit:
https://pastebin.com/JSMT0iZ4

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


Based on net-next/master

Ilias Apalodimas (2):
  net: page_pool: add helper function to retrieve dma addresses
  net: page_pool: add helper function to unmap dma addresses

Ivan Khoronzhuk (5):
  net: ethernet: ti: cpsw: use cpsw as drv data
  net: ethernet: ti: cpsw_ethtool: simplify slave loops
  net: ethernet: ti: davinci_cpdma: add dma mapped submit
  net: ethernet: ti: davinci_cpdma: return handler status
  net: ethernet: ti: cpsw: add XDP support

 drivers/net/ethernet/ti/Kconfig         |   1 +
 drivers/net/ethernet/ti/cpsw.c          | 555 ++++++++++++++++++++----
 drivers/net/ethernet/ti/cpsw_ethtool.c  | 100 ++++-
 drivers/net/ethernet/ti/cpsw_priv.h     |   9 +-
 drivers/net/ethernet/ti/davinci_cpdma.c | 122 ++++--
 drivers/net/ethernet/ti/davinci_cpdma.h |   6 +-
 drivers/net/ethernet/ti/davinci_emac.c  |  18 +-
 include/net/page_pool.h                 |   6 +
 net/core/page_pool.c                    |   7 +
 9 files changed, 685 insertions(+), 139 deletions(-)

-- 
2.17.1

