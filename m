Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BD7352F0C
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhDBSRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:17:40 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:37401 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbhDBSRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:17:39 -0400
Received: by mail-wm1-f54.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so4669658wml.2;
        Fri, 02 Apr 2021 11:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I1/j1JCKbYAjTheXlH22Tm2brD6BjaSfIOTEMjLXwo0=;
        b=mUhY2i6YDpSe9/ANkWZ9awKnkrpETZeCX5TkMyjRHcmzZ46KhIfYg9pIEt3929Zd4C
         KPCn3rlgxMvCiLmh1MOBu+L00vHcyt7asZoDrcoVne26fUNRixRjArdd1a6382j80bt4
         p5z+LU3y+8tzAcV4ypOzg7CO3KuZanw0LKMCbFPKs7247q62ivke06VUW1TQhnmTw2l7
         qhe515OkLT+KgI7MQHcHy26Dx7irDkr72dG9XlaVxRKvBG8QFP9FV8kSGMA8C9zijv43
         3c8qjmo7GKNa9vyTAAeMJsENblRXSGypPrNzj1PvsnFC60v9Sgsd7LRdVF6NNB2vc17H
         1z1w==
X-Gm-Message-State: AOAM533pIU9Q/MkMCYG1mgrz5pg//ijJwfqujsqKHkLHISMfKaV+g7yA
        GJjRPpGuaRO9mLgR6zLat5LmdAP4ARg=
X-Google-Smtp-Source: ABdhPJzJ4yMg92UW8pr7VxN6+KU2EF36UWYUyzYTscFovmbgfsGyTxio6hQkI0SpB9ZV7Kte2yXyHQ==
X-Received: by 2002:a1c:4e07:: with SMTP id g7mr13983194wmh.29.1617387456750;
        Fri, 02 Apr 2021 11:17:36 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id l9sm11472831wmq.2.2021.04.02.11.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 11:17:36 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/5] page_pool: recycle buffers
Date:   Fri,  2 Apr 2021 20:17:28 +0200
Message-Id: <20210402181733.32250-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This is a respin of [1]

This  patchset shows the plans for allowing page_pool to handle and
maintain DMA map/unmap of the pages it serves to the driver.  For this
to work a return hook in the network core is introduced.

The overall purpose is to simplify drivers, by providing a page
allocation API that does recycling, such that each driver doesn't have
to reinvent its own recycling scheme.  Using page_pool in a driver
does not require implementing XDP support, but it makes it trivially
easy to do so.  Instead of allocating buffers specifically for SKBs
we now allocate a generic buffer and either wrap it on an SKB
(via build_skb) or create an XDP frame.
The recycling code leverages the XDP recycle APIs.

The Marvell mvpp2 and mvneta drivers are used in this patchset to
demonstrate how to use the API, and tested on a MacchiatoBIN
and EspressoBIN boards respectively.

[1] https://lore.kernel.org/netdev/154413868810.21735.572808840657728172.stgit@firesoul/

v1 -> v2:
- fix a commit message
- avoid setting pp_recycle multiple times on mvneta
- squash two patches to avoid breaking bisect

Ilias Apalodimas (1):
  page_pool: Allow drivers to hint on SKB recycling

Jesper Dangaard Brouer (1):
  xdp: reduce size of struct xdp_mem_info

Matteo Croce (3):
  mm: add a signature in struct page
  mvpp2: recycle buffers
  mvneta: recycle buffers

 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  7 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++----
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 include/linux/mm_types.h                      |  1 +
 include/linux/skbuff.h                        | 35 ++++++++++++--
 include/net/page_pool.h                       | 15 ++++++
 include/net/xdp.h                             |  5 +-
 net/core/page_pool.c                          | 47 +++++++++++++++++++
 net/core/skbuff.c                             | 20 +++++++-
 net/core/xdp.c                                | 14 ++++--
 net/tls/tls_device.c                          |  2 +-
 13 files changed, 142 insertions(+), 27 deletions(-)

-- 
2.30.2

