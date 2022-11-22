Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9DC633607
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiKVHnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiKVHny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:43:54 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D1E30569;
        Mon, 21 Nov 2022 23:43:52 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVRCo4h_1669103028;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVRCo4h_1669103028)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 15:43:49 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH 0/9] virtio_net: support multi buffer xdp
Date:   Tue, 22 Nov 2022 15:43:39 +0800
Message-Id: <20221122074348.88601-1-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, virtio net only supports xdp for single-buffer packets
or linearized multi-buffer packets. This patchset supports xdp for
multi-buffer packets, then GRO_HW related features can be
negotiated, and do not affect the processing of single-buffer xdp.

In order to build multi-buffer xdp neatly, we integrated the code
into virtnet_build_xdp_buff() for xdp. The first buffer is used
for prepared xdp buff, and the rest of the buffers are added to
its skb_shared_info structure. This structure can also be
conveniently converted during XDP_PASS to get the corresponding skb.

Since virtio net uses comp pages, and bpf_xdp_frags_increase_tail()
is based on the assumption of the page pool,
(rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag))
is negative in most cases. So we didn't set xdp_rxq->frag_size in
virtnet_open() to disable the tail increase.

Heng Qi (9):
  virtio_net: disable the hole mechanism for xdp
  virtio_net: set up xdp for multi buffer packets
  virtio_net: update bytes calculation for xdp_frame
  virtio_net: remove xdp related info from page_to_skb()
  virtio_net: build xdp_buff with multi buffers
  virtio_net: construct multi-buffer xdp in mergeable
  virtio_net: build skb from multi-buffer xdp
  virtio_net: transmit the multi-buffer xdp
  virtio_net: support multi-buffer xdp

 drivers/net/virtio_net.c | 356 ++++++++++++++++++++++++---------------
 1 file changed, 219 insertions(+), 137 deletions(-)

-- 
2.19.1.6.gb485710b

