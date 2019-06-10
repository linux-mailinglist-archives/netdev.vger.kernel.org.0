Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475003B8D5
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391387AbfFJQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:03:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36892 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389928AbfFJQDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:03:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so4732482pfa.4;
        Mon, 10 Jun 2019 09:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U438d19y5dnauVkK+RbwCgrR87EIuw1L0MHsdg/GgXI=;
        b=Yh+UgWXVkD6bWwh4Z9lPMwEJ2oEviCSbz2Byurs61+9+QzA22Q8GHR3d/WKERG54fK
         aS9eabUTc76iBTYWKGR9koPNKiaAT09KqKuqq254wYVziGni5WYuSYdi1OoS2Mva2RBp
         Z+cHkOiU3N11+7dl0lk3Qoc2bUReWqBKkwHRxBn5EeGq5X+g+RGKlhyiozncvqAFK3kQ
         8cjkuIAq44Z1tCw5n9LbqVcURll9nOj7nT5dwREpdsITLcHvrg8U1zZOv7yj7M5EixVX
         x3jfmOzwlmA6HMmX/ghY1Ao1m1kTyl6hwuGGOvjBSXiiFtU4Ne4H1qEDR+eoAQ/o6N7J
         Ozsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U438d19y5dnauVkK+RbwCgrR87EIuw1L0MHsdg/GgXI=;
        b=en9DJKHPpSpPMY+/a5t1g+AkGTvLh+mBvQ13WKX5PKI2KbZ1mtX5oAtUhBt/1VvvK/
         eTN+Cfqc1Slk/ACu3KIY86uU7wq8k6oZf7SJNVhukZz15WJ+/uvC05IoXtTUTZ0B7/F1
         g18pQFWMVudnynONzowp1NTpzxuxvgQbF/6SNh5mOwHXnmQs1bTr7kagpcGxcO69rl+P
         DPxE+1gjb8DdVbMNMeilQP4QCwq0WWE1kCFYC6uURvwycn3csPG/gfs1hjdNW4AkXgZ9
         uv8NaN9o15LRpsZlZH4rZh8xHyQnfr1YhNbLnlEv6CWNZ8Pre2BdoJKu+A5dr0TPyehJ
         814g==
X-Gm-Message-State: APjAAAUSho9+SWNf11ZGNl0qpcyPn4p7WcYbZ5Bg4N1KMc7U6cnRXQ9W
        0FX76sZL8U2PuEup7Nj7+Ii7Zp+zpsvANA==
X-Google-Smtp-Source: APXvYqwJHvbYTV8vQ3jamQHemoubGczKvoW6u6iw6WvYi15SJ8njpChz4JxYwvwFcrvsyPcRmXJrsA==
X-Received: by 2002:a62:4c5:: with SMTP id 188mr74866318pfe.19.1560182579407;
        Mon, 10 Jun 2019 09:02:59 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id f5sm10574118pfn.161.2019.06.10.09.02.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:02:58 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, toke@redhat.com,
        brouer@redhat.com, bpf@vger.kernel.org,
        jakub.kicinski@netronome.com, saeedm@mellanox.com
Subject: [PATCH bpf-next v3 0/5] net: xdp: refactor XDP program queries
Date:   Mon, 10 Jun 2019 18:02:29 +0200
Message-Id: <20190610160234.4070-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's yet another attempt tomove the XDP_QUERY_PROG{,_HW} code out
from the drivers to generic netdev code.

I took a bit different approach with the v3. In this revision I
introduced to a new netdev_xdp structure that tracks the XDP programs,
and instead of sharing the xdp_prog member between DRV and SKB (again,
they mutual exclusive). With this, there's no need for a special
"what-mode-am-I-in" flag for SKB/DRV.

Jakub, what's your thoughts on the special handling of XDP offloading?
Maybe it's just overkill? Just allocate space for the offloaded
program regardless support or not? Also, please review the
dev_xdp_support_offload() addition into the nfp code.

The last two patches move the attach flag checks to generic code, and
removes the flags member from netdev_bpf.

Please refer to the individual commit messages for more details.

The series passes test_offload.py from selftests. Thanks to Jakub for
pointing this out.


Thanks,
Björn

Björn Töpel (5):
  net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
  nfp, netdevsim: use dev_xdp_support_offload() function
  net: xdp: remove XDP_QUERY_PROG{,_HW}
  net: xdp: refactor XDP flags checking
  net: xdp: remove xdp_attachment_flags_ok() and flags member

 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   4 -
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   3 -
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   4 -
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   4 -
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  24 ---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  18 --
 .../ethernet/netronome/nfp/nfp_net_common.c   |  10 -
 .../net/ethernet/netronome/nfp/nfp_net_main.c |   7 +
 .../net/ethernet/qlogic/qede/qede_filter.c    |   3 -
 drivers/net/netdevsim/bpf.c                   |   7 -
 drivers/net/netdevsim/netdev.c                |   4 +
 drivers/net/netdevsim/netdevsim.h             |   2 +-
 drivers/net/tun.c                             |  15 --
 drivers/net/veth.c                            |  15 --
 drivers/net/virtio_net.c                      |  17 --
 include/linux/netdevice.h                     |  30 +--
 include/net/xdp.h                             |   5 -
 net/core/dev.c                                | 172 ++++++++++++------
 net/core/rtnetlink.c                          |  31 +---
 net/core/xdp.c                                |  22 ---
 22 files changed, 147 insertions(+), 256 deletions(-)

-- 
2.20.1

