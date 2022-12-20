Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76FB652228
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiLTOO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiLTOOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:14:55 -0500
Received: from out30-7.freemail.mail.aliyun.com (out30-7.freemail.mail.aliyun.com [115.124.30.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDD3231;
        Tue, 20 Dec 2022 06:14:53 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VXliaQH_1671545689;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VXliaQH_1671545689)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 22:14:50 +0800
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
Subject: [PATCH v2 0/9] virtio_net: support multi buffer xdp
Date:   Tue, 20 Dec 2022 22:14:40 +0800
Message-Id: <20221220141449.115918-1-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Heng Qi (9):
  virtio_net: disable the hole mechanism for xdp
  virtio_net: set up xdp for multi buffer packets
  virtio_net: update bytes calculation for xdp_frame
  virtio_net: build xdp_buff with multi buffers
  virtio_net: construct multi-buffer xdp in mergeable
  virtio_net: transmit the multi-buffer xdp
  virtio_net: build skb from multi-buffer xdp
  virtio_net: remove xdp related info from page_to_skb()
  virtio_net: support multi-buffer xdp

 drivers/net/virtio_net.c | 332 ++++++++++++++++++++++++++-------------
 1 file changed, 219 insertions(+), 113 deletions(-)

-- 
2.19.1.6.gb485710b

