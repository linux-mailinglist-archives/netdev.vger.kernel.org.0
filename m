Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF89CC668
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbfJDXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:19:43 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46544 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDXTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:19:43 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so10801049qtq.13
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JLr7bExcnmQvsGjy61840oTbll0Y4GYLRzDw92J99Uc=;
        b=XX/VGP24QAitc5KCDGUPSp406yGxt8unaNbNB2aGIckToyPsTahwFqcksI8h8+xIDW
         hAAdQiyqB+k6fYp+MfmdRgN78SsbFDduCMeIZehEos/iXn+p4Ym7lANSwU+HjimNypGE
         Hfi8vp+erP9yWg9JGN53WaKRc2qa7ycKqthgZOFd/shxLGLo6vlRjIYHXIpyLL6ruche
         gcEcMq92GtE3fWAY0uqryx/5oj3Qv/W248Z1dcvqwHQ7qH3UeKNUFJCM9nImS0r5qwcJ
         pDrspltqutxBxPaZbNLIjaC4BnLtRYRkUVkjagqno8xyMuavtul9KcvW0pPIJkHHYTHC
         pNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JLr7bExcnmQvsGjy61840oTbll0Y4GYLRzDw92J99Uc=;
        b=SgSGT0oVLsjD3O+51SjAehmG7CiZA5CtLZPFoX5o+jhJUuh1vBLU8DhXCdGPEz9ktr
         6f4ZjPwSZn3hiHRpzoRyDPktVPWqF2mobVDAcczmtebvVN3SLPVGIDbiolGZCS+W7dIT
         Z04pjuOGFCWir2Z3wPevxbS6l3tUgCzJdH0h9FjxIxxolkY/YLSo5N0KBHzJFb4CaPw1
         RUIIt3LOFRY00ORE1WXQRVPIMY6eqZ15b6ilBrpea50BVmKkg0ktVvFKLnAN1UsdwSin
         e0CJvANMqhHwAOUXYPI+htCnqlSI8kxQjELq+StR8lhQVQ3Ayi8fJmzS5l0yGFFnl4rR
         2U0Q==
X-Gm-Message-State: APjAAAWUX2tw0wrGTcMvkqs1mEWFZoT5jzK9WZtctgpObAlwvOSzbjbq
        knwR0SnNRmtuYfg7QTdv+vo19g==
X-Google-Smtp-Source: APXvYqzZohaqceDFCdR3yd5vca0geeA7wOdvSrX1ZxI5CH6K/wbeLEtBumkNP6989k5XNRYOFixH1A==
X-Received: by 2002:a0c:9638:: with SMTP id 53mr16851154qvx.13.1570231182417;
        Fri, 04 Oct 2019 16:19:42 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z46sm4653398qth.62.2019.10.04.16.19.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 16:19:41 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/6] net/tls: add ctrl path tracing and statistics
Date:   Fri,  4 Oct 2019 16:19:21 -0700
Message-Id: <20191004231927.21134-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set adds trace events related to TLS offload and basic MIB stats
for TLS.

First patch contains the TLS offload related trace points. Those are
helpful in troubleshooting offload issues, especially around the
resync paths.

Second patch adds a tracepoint to the fastpath of device offload,
it's separated out in case there will be objections to adding
fast path tracepoints. Again, it's quite useful for debugging
offload issues.

Next four patches add MIB statistics. The statistics are implemented
as per-cpu per-netns counters. Since there are currently no fast path
statistics we could move to atomic variables. Per-CPU seem more common.

Most basic statistics are number of created and live sessions, broken
out to offloaded and non-offloaded. Users seem to like those a lot.

Next there is a statistic for decryption errors. These are primarily
useful for device offload debug, in normal deployments decryption
errors should not be common.

Last but not least a counter for device RX resync.

Jakub Kicinski (6):
  net/tls: add tracing for device/offload events
  net/tls: add device decrypted trace point
  net/tls: add skeleton of MIB statistics
  net/tls: add statistics for installed sessions
  net/tls: add TlsDecryptError stat
  net/tls: add TlsDeviceRxResync statistic

 Documentation/networking/tls.rst              |  30 +++
 .../ethernet/netronome/nfp/nfp_net_common.c   |   3 +-
 include/net/netns/mib.h                       |   3 +
 include/net/snmp.h                            |   6 +
 include/net/tls.h                             |  21 +-
 include/uapi/linux/snmp.h                     |  17 ++
 net/tls/Makefile                              |   4 +-
 net/tls/tls_device.c                          |  36 +++-
 net/tls/tls_main.c                            |  60 +++++-
 net/tls/tls_proc.c                            |  47 ++++
 net/tls/tls_sw.c                              |   5 +
 net/tls/trace.c                               |  10 +
 net/tls/trace.h                               | 202 ++++++++++++++++++
 13 files changed, 429 insertions(+), 15 deletions(-)
 create mode 100644 net/tls/tls_proc.c
 create mode 100644 net/tls/trace.c
 create mode 100644 net/tls/trace.h

-- 
2.21.0

