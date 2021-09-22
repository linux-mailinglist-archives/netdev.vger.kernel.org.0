Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026324142FE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhIVH6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbhIVH6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:12 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118F4C061574;
        Wed, 22 Sep 2021 00:56:43 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u18so4133601wrg.5;
        Wed, 22 Sep 2021 00:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZeP3oTMTMngREgXI9w7mSBjRdgycCPqwN8GWP6Qz62o=;
        b=jKkDSM1hVUvqWJbfLgB8WzhQXBayXEPpOZ5WvrWbsqM4AJAHcEcVD8VBgNTASy5i+N
         vHBcNOf8QbPYFzR6aVBoth09jihGTsOHZDs1toa6wNzFO0THnsagulRhyKbfXFtgVieG
         eh+B/3DW1XZQk5Ii1yt1+/lbq3U7FiJuQwCMeYyQE0k8MPV/THl43jC4aNTTc8gp19R4
         1IgK/lja+eSEZRc8MxJnNkkI3dt64ZJTnD8H+4i6zeIHFegBO/GnhW6a3nooOTat3tA5
         kf+f9zuCTLTPVE+bJO5B1rMPxO1wmRNR4g+mL36IFBeb9TmplYB4Qv4mu8ak040QRbZZ
         tzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZeP3oTMTMngREgXI9w7mSBjRdgycCPqwN8GWP6Qz62o=;
        b=bMCC+1UVL5U3wFGEfG2iTdx5fiDt8gzFNBRk7V+pB0nRNFC+ovpOhyt8pjXsVPABK7
         V3DYNwMw/2f5msAqqm8qXEgRYswDzIMjSiuk1KhjcPwhXgidTAdktbxXrYuhbc7TPQXk
         GjTBzzLbOYp5ujU4/IDZcD5lidumHOgipIRXYgK8/ivnj3Qv57q5T7zRvtymEpHIhReA
         exmPEQBCth4BjDwoJx5PbegUBmNimIN5LsDRy72q8zGzvB9Q//ra7WWEehdwrTm+iCHa
         LeQJxEi8LVkOYn2psHGOxq5McO5jAyK4uyg3F3bgbL++lPztmCelgXyOyBA+c8UVNrjE
         aLNQ==
X-Gm-Message-State: AOAM531XOUb4sVYXc/RcM+M4GGIPprwpJ3DULkhUDiCZp1BN4orLTcWc
        f4ZUIgepIMxyPrIGfjp9dNLs0B47tWTWhfKY6s8=
X-Google-Smtp-Source: ABdhPJwMkNA+o/Z4kH94crfzU7OtMgbQCFmtdLpewTLscd1L9Owkkjf1Osfys0n2hVxSGwcqvJjDdQ==
X-Received: by 2002:a5d:630a:: with SMTP id i10mr40745951wru.178.1632297401605;
        Wed, 22 Sep 2021 00:56:41 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:41 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 00/13] xsk: i40e: ice: introduce batching for Rx buffer allocation
Date:   Wed, 22 Sep 2021 09:56:00 +0200
Message-Id: <20210922075613.12186-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a batched interface for Rx buffer allocation
in AF_XDP buffer pool. Instead of using xsk_buff_alloc(*pool), drivers
can now use xsk_buff_alloc_batch(*pool, **xdp_buff_array,
max). Instead of returning a pointer to an xdp_buff, it returns the
number of xdp_buffs it managed to allocate up to the maximum value of
the max parameter in the function call. Pointers to the allocated
xdp_buff:s are put in the xdp_buff_array supplied in the call. This
could be a SW ring that already exists in the driver or a new
structure that the driver has allocated.

u32 xsk_buff_alloc_batch(struct xsk_buff_pool *pool,
                         struct xdp_buff **xdp,
                         u32 max);

When using this interface, the driver should also use the new
interface below to set the relevant fields in the struct xdp_buff. The
reason for this is that xsk_buff_alloc_batch() does not fill in the
data and data_meta fields for you as is the case with
xsk_buff_alloc(). So it is not sufficient to just set data_end
(effectively the size) anymore in the driver. The reason for this is
performance as explained in detail in the commit message.

void xsk_buff_set_size(struct xdp_buff *xdp, u32 size);

Patch 6 also optimizes the buffer allocation in the aligned case. In
this case, we can skip the reinitialization of most fields in the
xdp_buff_xsk struct at allocation time. As the number of elements in
the heads array is equal to the number of possible buffers in the
umem, we can initialize them once and for all at bind time and then
just point to the correct one in the xdp_buff_array that is returned
to the driver. No reason to have a stack of free head entries. In the
unaligned case, the buffers can reside anywhere in the umem, so this
optimization is not possible as we still have to fill in the right
information in the xdp_buff every single time one is allocated.

I have updated i40e and ice to use this new batched interface.

These are the throughput results on my 2.1 GHz Cascade Lake system:

Aligned mode:
ice: +11% / -9 cycles/pkt
i40e: +12% / -9 cycles/pkt

Unaligned mode:
ice: +1.5% / -1 cycle/pkt
i40e: +1% / -1 cycle/pkt

For the aligned case, batching provides around 40% of the performance
improvement and the aligned optimization the rest, around 60%. Would
have expected a ~4% boost for unaligned with this data, but I only get
around 1%. Do not know why. Note that memory consumption in aligned
mode is also reduced by this patch set.

Structure of the patch set:

Patch 1: Removes an unused entry from xdp_buff_xsk.
Patch 2: Introduce the batched buffer allocation API and implementation.
Patch 3-4: Use the batched allocation interface for ice.
Patch 5: Use the batched allocation interface for i40e.
Patch 6: Optimize the buffer allocation for the aligned case.
Patch 7-10: Fix some issues with the tests that were found while
            implementing the two new tests below.
Patch 11-13: Implement two new tests: single packet and headroom validation.

Thanks: Magnus

Magnus Karlsson (13):
  xsk: get rid of unused entry in struct xdp_buff_xsk
  xsk: batched buffer allocation for the pool
  ice: use xdp_buf instead of rx_buf for xsk zero-copy
  ice: use the xsk batched rx allocation interface
  i40e: use the xsk batched rx allocation interface
  xsk: optimize for aligned case
  selftests: xsk: fix missing initialization
  selftests: xsk: put the same buffer only once in the fill ring
  selftests: xsk: fix socket creation retry
  selftests: xsk: introduce pacing of traffic
  selftests: xsk: add single packet test
  selftests: xsk: change interleaving of packets in unaligned mode
  selftests: xsk: add frame_headroom test

 drivers/net/ethernet/intel/i40e/i40e_xsk.c |  52 ++++----
 drivers/net/ethernet/intel/ice/ice_txrx.h  |  16 +--
 drivers/net/ethernet/intel/ice/ice_xsk.c   |  92 +++++++-------
 include/net/xdp_sock_drv.h                 |  22 ++++
 include/net/xsk_buff_pool.h                |  48 +++++++-
 net/xdp/xsk.c                              |  15 ---
 net/xdp/xsk_buff_pool.c                    | 131 +++++++++++++++++---
 net/xdp/xsk_queue.h                        |  12 +-
 tools/testing/selftests/bpf/xdpxceiver.c   | 133 ++++++++++++++++-----
 tools/testing/selftests/bpf/xdpxceiver.h   |  11 +-
 10 files changed, 376 insertions(+), 156 deletions(-)


base-commit: 17b52c226a9a170f1611f69d12a71be05748aefd
--
2.29.0
