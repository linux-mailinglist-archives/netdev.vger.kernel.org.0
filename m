Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653DE6CEF64
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjC2Q35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjC2Q34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:29:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEE065BA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 09:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680107346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LRGCUeVsUs6xmha+0hhW8PleaE0DpIvvn/LbxoOLCm4=;
        b=C/DJfQhP2XLiWg8JSd6io6PzWVsXhoUvys2a2vU4l/NEl2NUOwLql52/P0SoGn3ojLX2dL
        B060HS3kErfb9zGgvQ34Am123FW6gY7l909MCHVTPC6e6ljurK3trinpYJ1JD6E5epgfpl
        GnPIeXxD62QvI+e3qLwSzWztlr1vkDg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-SNscpT1SPMeRb3UWBuCMQw-1; Wed, 29 Mar 2023 12:29:01 -0400
X-MC-Unique: SNscpT1SPMeRb3UWBuCMQw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9C3F2806046;
        Wed, 29 Mar 2023 16:28:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FD59492B00;
        Wed, 29 Mar 2023 16:28:59 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 368D430736C72;
        Wed, 29 Mar 2023 18:28:58 +0200 (CEST)
Subject: [PATCH bpf RFC-V2 0/5] XDP-hints: API change for RX-hash kfunc
 bpf_xdp_metadata_rx_hash
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Date:   Wed, 29 Mar 2023 18:28:58 +0200
Message-ID: <168010726310.3039990.2753040700813178259.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Notice targeted 6.3-rc kernel via bpf git tree.

Current API for bpf_xdp_metadata_rx_hash() returns the raw RSS hash value,
but doesn't provide information on the RSS hash type (part of 6.3-rc).

This patchset proposal is to use the return value from
bpf_xdp_metadata_rx_hash() to provide the RSS hash type.

Alternatively we disable bpf_xdp_metadata_rx_hash() in 6.3-rc, and have
more time to nitpick the RSS hash-type bits.

---

Jesper Dangaard Brouer (5):
      xdp: rss hash types representation
      igc: bpf_xdp_metadata_rx_hash return xdp rss hash type
      veth: bpf_xdp_metadata_rx_hash return xdp rss hash type
      mlx5: bpf_xdp_metadata_rx_hash return xdp rss hash type
      mlx4: bpf_xdp_metadata_rx_hash return xdp rss hash type


 drivers/net/ethernet/intel/igc/igc_main.c     | 22 +++++-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 20 ++++-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 61 +++++++++++++-
 drivers/net/veth.c                            |  7 +-
 include/linux/mlx5/device.h                   | 14 +++-
 include/net/xdp.h                             | 79 +++++++++++++++++++
 net/core/xdp.c                                |  4 +-
 7 files changed, 196 insertions(+), 11 deletions(-)

--
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

