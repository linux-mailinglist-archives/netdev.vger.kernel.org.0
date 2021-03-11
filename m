Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECA6337E58
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCKTnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:43:47 -0500
Received: from mail-ed1-f42.google.com ([209.85.208.42]:40869 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhCKTnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 14:43:15 -0500
Received: by mail-ed1-f42.google.com with SMTP id i61so4591296edd.7;
        Thu, 11 Mar 2021 11:43:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z5ciSZitYSYl/8QYy48GlcTDZDuaVmpQ6UyrV3mvyc4=;
        b=jPWuQIkr+3mdWH7mf5y0qmkw6q13/h9R8XlmQ2H7rpdicWcGsKSdv2RUqILWcszK8X
         AwOhxwnSNA1mu2h+eoFSXCtUBlESs9H3QFt2hujAJiKVeTPFXYPuVR6oYuGxUDC2kNd9
         CYaIsPGM8Fl+F30k8kCO41GluLfhpJ8e6LejMShBXW62Mv4li9FpxTcloZi5WR+vH0wk
         bxUpvm3ADZD+nZBDho+hwGUB7qPR+7ohpYrFIr6ceCfBYf9zXQ0YNAwNkwf02dzK+XXd
         Mz5yksfsunqCxdfgAPgx2M3o4cDGdMeERc33AR00mCzZBByaqRkAtXR6Jb1UJSTV/xDp
         OQ3A==
X-Gm-Message-State: AOAM531bLx1VZewSSlak6BAnUs28YAJpNk0O/o1f5q4WzJfCN2BQz+m1
        jmf/j7kYN3tqrvMzaoiG7CcQzL7dFbI=
X-Google-Smtp-Source: ABdhPJz1K2CK/LtqqXGROIOjA+JNQmclVrovKlgXJDd4QbKMdSc9idmHOLgMzwEbB9WDPtLZYRYlDA==
X-Received: by 2002:a05:6402:5203:: with SMTP id s3mr10300100edd.79.1615491794268;
        Thu, 11 Mar 2021 11:43:14 -0800 (PST)
Received: from msft-t490s.teknoraver.net (net-188-216-41-250.cust.vodafonedsl.it. [188.216.41.250])
        by smtp.gmail.com with ESMTPSA id t16sm1875652edi.60.2021.03.11.11.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:43:13 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [RFC net-next 0/6] page_pool: recycle buffers
Date:   Thu, 11 Mar 2021 20:42:50 +0100
Message-Id: <20210311194256.53706-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This series enables recycling of the buffers allocated with the page_pool API.
The first two patches are just prerequisite to save space in a struct and
avoid recycling pages allocated with other API.
Patch 2 was based on a previous idea from Jonathan Lemon.

The third one is the real recycling, 4 fixes the compilation of __skb_frag_unref
users, and 5,6 enable the recycling on two drivers.

In the last two patches I reported the improvement I have with the series.

The recycling as is can't be used with drivers like mlx5 which do page split,
but this is documented in a comment.
In the future, a refcount can be used so to support mlx5 with no changes.

Ilias Apalodimas (2):
  page_pool: DMA handling and frame recycling via SKBs
  net: change users of __skb_frag_unref() and add an extra argument

Jesper Dangaard Brouer (1):
  xdp: reduce size of struct xdp_mem_info

Matteo Croce (3):
  mm: add a signature in struct page
  mvpp2: recycle buffers
  mvneta: recycle buffers

 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  4 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++----
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 include/linux/mm_types.h                      |  1 +
 include/linux/skbuff.h                        | 33 +++++++++++--
 include/net/page_pool.h                       | 15 ++++++
 include/net/xdp.h                             |  5 +-
 net/core/page_pool.c                          | 47 +++++++++++++++++++
 net/core/skbuff.c                             | 20 +++++++-
 net/core/xdp.c                                | 14 ++++--
 net/tls/tls_device.c                          |  2 +-
 13 files changed, 138 insertions(+), 26 deletions(-)

-- 
2.29.2

