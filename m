Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121A0188BFF
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgCQR3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:29:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:49719 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbgCQR3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZBmY4P+IejI5fUw3LmCinKxHarEM4o//CwDGCgfhQyg=;
        b=UBcy20B09E3Kofv9z6lqzZByfuGMOGTNUNK8HKGc7VP9vARpym9YDmG66pSUYd/ccfiDz4
        nO8JHro73z+vX6cxKVQZY9MRDc/dAUsSb4Z80BqbqhvnUrdowEzG+xxDJKXMITtxikoAVO
        Rm9GBns7wrRC05N7X1+KZx072OhWLx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-aUrmac8WOlWZEkyKLGAaTg-1; Tue, 17 Mar 2020 13:29:16 -0400
X-MC-Unique: aUrmac8WOlWZEkyKLGAaTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCDC61137848;
        Tue, 17 Mar 2020 17:29:12 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C912D272A2;
        Tue, 17 Mar 2020 17:29:08 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id AC51030737E05;
        Tue, 17 Mar 2020 18:29:07 +0100 (CET)
Subject: [PATCH RFC v1 00/15] XDP extend with knowledge of frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     thomas.petazzoni@bootlin.com,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 17 Mar 2020 18:29:07 +0100
Message-ID: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Early RFC *before* I finish converting all drivers... so I can get
feedback that might affect the design...

XDP have evolved to support several frame sizes, but xdp_buff was not
updated with this information. This have caused the side-effect that XDP
frame data hard end is not known. It also limited the BPF-helper
bpf_xdp_adjust_tail to only shrink the packet.

This patchset tries to address this and add packet tail extend/grow.

The purpose of the patchset is ALSO to reserve a memory area that can be
used for storing extra information, specifically for extending XDP with
multi-buffer support. One proposal is to use same layout as
skb_shared_info, which is why this area is currently 320 bytes.

---

Jesper Dangaard Brouer (15):
      xdp: add frame size to xdp_buff
      mvneta: add XDP frame size to driver
      bnxt: add XDP frame size to driver
      ixgbe: fix XDP redirect on archs with PAGE_SIZE above 4K
      ixgbe: add XDP frame size to driver
      sfc: fix XDP-redirect in this driver
      sfc: add XDP frame size
      xdp: allow bpf_xdp_adjust_tail() to grow packet size
      xdp: clear grow memory in bpf_xdp_adjust_tail()
      net: XDP-generic determining XDP frame size
      xdp: xdp_frame add member frame_sz and handle in convert_to_xdp_frame
      xdp: cpumap redirect use frame_sz and increase skb_tailroom
      tun: add XDP frame size
      veth: xdp using frame_sz in veth driver
      dpaa2-eth: add XDP frame size


 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c    |    1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe.h         |   17 ++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |   17 +++++++-----
 drivers/net/ethernet/marvell/mvneta.c            |    1 +
 drivers/net/ethernet/sfc/efx_common.c            |    9 ++++--
 drivers/net/ethernet/sfc/net_driver.h            |    6 ++++
 drivers/net/ethernet/sfc/rx.c                    |    3 +-
 drivers/net/ethernet/sfc/rx_common.c             |    6 ++--
 drivers/net/tun.c                                |    2 +
 drivers/net/veth.c                               |   15 +++++++++--
 include/net/xdp.h                                |   31 +++++++++++++++++++++-
 include/uapi/linux/bpf.h                         |    4 +--
 kernel/bpf/cpumap.c                              |   21 ++-------------
 net/core/dev.c                                   |   14 ++++++----
 net/core/filter.c                                |   24 ++++++++++++++++-
 net/core/xdp.c                                   |    7 +++++
 17 files changed, 133 insertions(+), 46 deletions(-)

--

