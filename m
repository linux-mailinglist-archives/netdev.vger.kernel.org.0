Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD56922CF45
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgGXUO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgGXUO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:14:27 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35A4C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:14:27 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so6012973pgf.0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wAD6uE1E722YF/ciq7r49mYV/3co1+crfinh1iVchVQ=;
        b=XN4QjMkweGXJauH2zS2yuSuTFXXMNEzrJF3gmOlTUT0X1pqIin+nKeEN1uwumSbD2+
         /PBQ/XSbWZIPNHsST8waBTZSOEhBzZmeYUmBcohdG6a6j3kURjBOr3VgN8gvq4P4h49g
         vxqKCNSW++zmYXFO7/IiQ6YKs7obRrpKNTcsJbd6iOUa4ikMGknBVuHTQo4SBoqzjtAh
         BCqnxy1+RpFFOwFZ3335VDgEOVjUrwPWhJIQ7qc7GaIhQ0BBSDFhyi/0EFFJvc8GjXAO
         tk6vma3GQSIYIp55/6ja0lzUxyU1YXWlhaYX9iAusnMv/ytRb2vuSSjsnVFhDfoRGVOx
         mH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wAD6uE1E722YF/ciq7r49mYV/3co1+crfinh1iVchVQ=;
        b=HNW2wi44XU9afl/OeEMKCqyhn01MOHHAMwWyqFmZWMqirkcoKaAqhOaGFtxW+PdGza
         rBb8uhSUYlq/ykrqrGnW1jAcKzz5VBmSJWNEYTRwUqotSErehhudx71RkF6eGaGYANNY
         vEiT0hGJBe3s734wzgQazghRs1vbx/htB1exlhOJ3b04aci2LCwgraxfpHyUByq0f+4Z
         SJ+81IDH1zhc3zRGYn3hVcnVEq/jcLIcZ5j0UlFLxhmVm3MSS1WwNLR7Um3zAI8Ry5pP
         r+EVzlwIv7y5/59BazHZ3JRtI30DV278klwMBuJvPip5MrPYs5Qi2QNcOHP4fH4TbXJf
         budQ==
X-Gm-Message-State: AOAM533cmSKNlgJK/japWPmYYIiTOrzg1nso/tnybmTBlp+0GzuhQKdA
        TxBqooGVbuzvXt0MsbU6625+77VWrdg=
X-Google-Smtp-Source: ABdhPJwuk+Gi0gy8JHfIkKAtu2PDZ8X/h1IuXTppPI2cO2lSpiApEJA7mYA4Uct2TB/zSjUddR2JAA==
X-Received: by 2002:a62:2b96:: with SMTP id r144mr10321136pfr.272.1595621666745;
        Fri, 24 Jul 2020 13:14:26 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id ci23sm6496539pjb.29.2020.07.24.13.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 13:14:26 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org, amritha.nambiar@intel.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH net-next 0/3] sock: Fix sock queue mapping to include device
Date:   Fri, 24 Jul 2020 13:14:09 -0700
Message-Id: <20200724201412.599398-1-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The transmit queue selected for a packet is saved in the associated sock
for the packet and is subsequently used to avoid recalculating the queue
on subsequent sends. The problem is that the corresponding device is not
also recorded so that when the queue mapping is referenced it may
correspond to a different device than the sending one, resulting in an
incorrect queue being used for transmit. A similar problem exists in
recording the receive queue in the sock without the corresponding
receive device.

This patch set fixes the issue by recording both the device (via
ifindex) and the queue in the sock mapping. The pair is set and
retrieved atomically. The caller getting the mapping pair checks
that both the recorded queue and in the device are valid in the
context (for instance, in transmit the returned ifindex is checked
against that of the transmitting device to ensure they refer to
same device before apply the recorded queue).

This patch set contains:
	- Definition of dev_and_queue structure to hold the ifindex
	  and queue number
	- Generic functions to get, set, and clear dev_and_queue
	  structure
	- Change sk_tx_queue_{get,set,clear} to
	  sk_tx_dev_and_queue_{get,set,clear}
	- Modify callers of above to use new interface
	- Change sk_rx_queue_{get,set,clear} to 
          sk_rx_dev_and_queue_{get,set,clear}
        - Modify callers of above to use new interface

Tom Herbert (3):
  sock: Definition and general functions for dev_and_queue structure
  sock: Use dev_and_queue structure for TX queue mapping in sock
  sock: Use dev_and_queue structure for RX queue mapping in sock

 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  10 +-
 drivers/net/hyperv/netvsc_drv.c               |   9 +-
 include/net/busy_poll.h                       |   2 +-
 include/net/request_sock.h                    |   2 +-
 include/net/sock.h                            | 126 +++++++++++++-----
 net/core/dev.c                                |  15 ++-
 net/core/filter.c                             |   7 +-
 net/core/sock.c                               |  10 +-
 net/ipv4/tcp_input.c                          |   2 +-
 9 files changed, 124 insertions(+), 59 deletions(-)

-- 
2.25.1

