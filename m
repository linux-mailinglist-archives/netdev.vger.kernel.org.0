Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F82640F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 14:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbfEVMyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 08:54:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44159 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbfEVMyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 08:54:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id c5so1034332pll.11;
        Wed, 22 May 2019 05:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y/iHFnqagpDsDyCYiTUDf5N1dEeXjUcnVe8sgUuGOL8=;
        b=qYp0hfhvSwIJC8LsdXTvKV4kRx/FEZm7Au6BSy8FkOQw0/3JEkmhybmdj53JsshThc
         aqFWB3v5pUB7SSCWBQjlbZGZsLXp3LNYRgjKgtkDTOgOnAXVV6W9dxUm2pR+qrdqNE6d
         bcQzoN1Br05m/o4TSHklwuCQww1Qd9OAfh8qffiSREOUkoFvloinWaF0WqM/yxlBeYze
         X+sBXi7kjyi3RXXmZWCFuG92iHL+EA5T5MBrsd3KrOsg2Ke3dYNAC94opSZIcTiAeBGn
         R+mzjQVW9MRXJFMzYgZwRjpap5BerwNBrfzZVQWn/Gu0OHPOff4Sx6+/Mxeob7lzkt4D
         p3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y/iHFnqagpDsDyCYiTUDf5N1dEeXjUcnVe8sgUuGOL8=;
        b=kQGLzLvzC6+0wF+e0gS0YWtQDwUE4+c9UOmae0gsJYTNEpjvDf32RvTeZse9o4yhQm
         tattG0pxPVENmKGJqEiBuGb/bGdDO4sVc/HnldkPyVlJOZge8HomGSyfuedHVs7rdsT/
         eRxi6eESDcJmPhkOO8l8ZOUp6cGBNU1itRpbH44nd0z8iheImbCDoXjtFmiy40OClV7b
         pUX2+yc6B9GXBRDE+JqaVNF+oPE3SokqEAOLF8STmBH0S8Is2/Et3Qz3Qs6TirEIK+1T
         3zKbHxJexqUa2obrrqC2Emna6Bzigml3brKFsEw26jSELEnKuHFnR4cmHbT/x7n/fFLE
         4E5Q==
X-Gm-Message-State: APjAAAVJ3RP121ITNSPesKSjX5kV8cpWq7Wn/wRti65/yokQHCO+cft1
        5vfdE2AWj1ueQlVc5ZvTiq8=
X-Google-Smtp-Source: APXvYqxH+7LdH8si+KOHfCNNqEhYLEzNBJ4z++SDzNNaT6Oot7/XMjRuOvllJZqEYTMg3nMjDbH28w==
X-Received: by 2002:a17:902:e104:: with SMTP id cc4mr89713767plb.254.1558529648406;
        Wed, 22 May 2019 05:54:08 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id 127sm29671054pfc.159.2019.05.22.05.54.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 05:54:07 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     toke@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        brouer@redhat.com, bpf@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: [PATCH bpf-next 0/2] net: xdp: refactor the XDP_QUERY_PROG and XDP_QUERY_PROG_HW code
Date:   Wed, 22 May 2019 14:53:50 +0200
Message-Id: <20190522125353.6106-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's another attempt (the first, horribly broken one, here [1]) to
move the XDP_QUERY_PROG{,_HW} code out from the drivers to generic
netdev code.

The first patch in the series move the XDP query functionality, and
the second remove XDP_QUERY_PROG{,_HW} from all drivers.

Please refer to the individual commit messages for more details.

Shout out to all XDP driver hackers to check that the second patch
doesn't break anything (especially Jakub). I've only been able to test
on the Intel NICs.


Thanks,
Björn

[1] https://lore.kernel.org/netdev/CAJ+HfNjfcGW=b_Ckox4jXf7od7yr+Sk2dXxFyO8Qpr-WJX0q7A@mail.gmail.com/

Björn Töpel (2):
  net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
  net: xdp: remove XDP_QUERY_PROG{,_HW}

 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   4 -
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   3 -
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   4 -
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   4 -
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  24 ----
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  18 ---
 .../ethernet/netronome/nfp/nfp_net_common.c   |   4 -
 .../net/ethernet/qlogic/qede/qede_filter.c    |   3 -
 drivers/net/netdevsim/bpf.c                   |   4 -
 drivers/net/netdevsim/netdevsim.h             |   2 +-
 drivers/net/tun.c                             |  15 ---
 drivers/net/veth.c                            |  15 ---
 drivers/net/virtio_net.c                      |  17 ---
 include/linux/netdevice.h                     |  21 ++-
 include/net/xdp.h                             |   2 -
 net/core/dev.c                                | 125 +++++++++---------
 net/core/rtnetlink.c                          |  33 +----
 net/core/xdp.c                                |   9 --
 20 files changed, 77 insertions(+), 236 deletions(-)

-- 
2.20.1

