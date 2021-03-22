Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1391344C9B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCVRDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:03:23 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:33665 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhCVRDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:03:11 -0400
Received: by mail-ed1-f46.google.com with SMTP id w18so20292349edc.0;
        Mon, 22 Mar 2021 10:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hiS2EpWobHI9LUAiVe5wAQU0vX3JpbvHUOvmyCBf7ug=;
        b=pG9Eh1AOavelW9I6wDd3MW/mdgpcO24ng/5Cczt1SdghMjkfegXz4UOf+205Ia5Tcm
         FexvUfaxAA5q6j39ezx0XCA1IvDvYzI4MprKM5/Dgdk2EkBf0mtEDhvmzopeuw9VzYth
         ImlS9/YqwLG3K4GKXc+Eivi44RINRvimaSCBuRWoKMEWjCi2+SiER4PDqhsCoSahetaT
         wz41Vzljh6X0XZ9RhS/HIr2pUuQDfELTUf0MJQUvwtup4wOCe1uHQSUOrL0pw6iHeIEm
         eWS1O9YcWDMJIgTX7/WYGxCSb+aFhKvP+fqgBwO4cnWg4e5R70NsOkaX7wd8xkM2m2Qt
         QKKw==
X-Gm-Message-State: AOAM530shd7KwRukx8Nb+bnjty+ybRSy3MtD/9tHaDSk+FREQdUJGswy
        5mSaLrRhXgWeLNFSHZNbvDA3T+O0Hrs=
X-Google-Smtp-Source: ABdhPJxbTAXrNsbW7kwIKKL5u68tbfli8yNSyW4D/O4niGv6aeQC0u0A6aFw8ZDocMSs2yeDpDyppw==
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr570402edd.103.1616432590087;
        Mon, 22 Mar 2021 10:03:10 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id h22sm9891589eji.80.2021.03.22.10.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:03:09 -0700 (PDT)
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
Subject: [PATCH net-next 0/6] page_pool: recycle buffers
Date:   Mon, 22 Mar 2021 18:02:55 +0100
Message-Id: <20210322170301.26017-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
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
  page_pool: DMA handling and allow to recycles frames via SKB
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
2.30.2

