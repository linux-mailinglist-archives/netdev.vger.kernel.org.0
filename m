Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800C6668FDF
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240696AbjAMIBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240931AbjAMIBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:01:02 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE556D515;
        Fri, 13 Jan 2023 00:00:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VZTopb2_1673596816;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VZTopb2_1673596816)
          by smtp.aliyun-inc.com;
          Fri, 13 Jan 2023 16:00:16 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH net-next v4 00/10] virtio-net: support multi buffer xdp
Date:   Fri, 13 Jan 2023 16:00:06 +0800
Message-Id: <20230113080016.45505-1-hengqi@linux.alibaba.com>
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

Changes since PATCH v3:
- Separate fix patch for MTU calculation of single buffer xdp.
  Note, this patch needs to be backported to the stable branch.

Changes since PATCH v2:
- Even if single buffer xdp has a hole mechanism, there will be no
  problem (limiting mtu and turning off GUEST GSO), so there is no
  need to backport "[PATCH 1/9]";
- Modify calculation of MTU for single buffer xdp in virtnet_xdp_set();
- Make truesize in mergeable mode return to literal meaning;
- Add some comments for legibility;

Changes since RFC:
- Using headroom instead of vi->xdp_enabled to avoid re-reading
  in add_recvbuf_mergeable();
- Disable GRO_HW and keep linearization for single buffer xdp;
- Renamed to virtnet_build_xdp_buff_mrg();
- pr_debug() to netdev_dbg();
- Adjusted the order of the patch series.

Currently, virtio net only supports xdp for single-buffer packets
or linearized multi-buffer packets. This patchset supports xdp for
multi-buffer packets, then larger MTU can be used if xdp sets the
xdp.frags. This does not affect single buffer handling.

In order to build multi-buffer xdp neatly, we integrated the code
into virtnet_build_xdp_buff_mrg() for xdp. The first buffer is used
for prepared xdp buff, and the rest of the buffers are added to
its skb_shared_info structure. This structure can also be
conveniently converted during XDP_PASS to get the corresponding skb.

Since virtio net uses comp pages, and bpf_xdp_frags_increase_tail()
is based on the assumption of the page pool,
(rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag))
is negative in most cases. So we didn't set xdp_rxq->frag_size in
virtnet_open() to disable the tail increase.

Heng Qi (10):
  virtio-net: disable the hole mechanism for xdp
  virtio-net: fix calculation of MTU for single buffer xdp
  virtio-net: set up xdp for multi buffer packets
  virtio-net: update bytes calculation for xdp_frame
  virtio-net: build xdp_buff with multi buffers
  virtio-net: construct multi-buffer xdp in mergeable
  virtio-net: transmit the multi-buffer xdp
  virtio-net: build skb from multi-buffer xdp
  virtio-net: remove xdp related info from page_to_skb()
  virtio-net: support multi-buffer xdp

 drivers/net/virtio_net.c | 371 ++++++++++++++++++++++++++-------------
 1 file changed, 250 insertions(+), 121 deletions(-)

-- 
2.19.1.6.gb485710b

