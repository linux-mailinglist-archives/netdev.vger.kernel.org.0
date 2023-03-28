Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC9D6CBAFE
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjC1J31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjC1J26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:28:58 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFCC619E;
        Tue, 28 Mar 2023 02:28:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VesbhcT_1679995727;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VesbhcT_1679995727)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:28:48 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 00/16] virtio-net: split virtio-net.c
Date:   Tue, 28 Mar 2023 17:28:31 +0800
Message-Id: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
MIME-Version: 1.0
X-Git-Hash: e880b402863c
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Considering the complexity of virtio-net.c and the new features we want
to add, it is time to split virtio-net.c into multiple independent
module files.

This is beneficial to the maintenance and adding new functions.

And AF_XDP support will be added later, then a separate xsk.c file will
be added.

This patchset split virtio-net.c into these parts:

* virtnet.c:         virtio net device ops (napi, tx, rx, device ops, ...)
* virtnet_common.c:  virtio net common code
* virtnet_ethtool.c: virtio net ethtool callbacks
* virtnet_ctrl.c:    virtio net ctrl queue command APIs
* virtnet_virtio.c:  virtio net virtio callbacks/ops (driver register, virtio probe, virtio free, ...)

Please review.

Thanks.

Xuan Zhuo (16):
  virtio_net: add a separate directory for virtio-net
  virtio_net: move struct to header file
  virtio_net: add prefix to the struct inside header file
  virtio_net: separating cpu-related funs
  virtio_net: separate virtnet_ctrl_set_queues()
  virtio_net: separate virtnet_ctrl_set_mac_address()
  virtio_net: remove lock from virtnet_ack_link_announce()
  virtio_net: separating the APIs of cq
  virtio_net: introduce virtnet_rq_update_stats()
  virtio_net: separating the funcs of ethtool
  virtio_net: introduce virtnet_dev_rx_queue_group()
  virtio_net: introduce virtnet_get_netdev()
  virtio_net: prepare for virtio
  virtio_net: move virtnet_[en/dis]able_delayed_refill to header file
  virtio_net: add APIs to register/unregister virtio driver
  virtio_net: separating the virtio code

 MAINTAINERS                                   |    2 +-
 drivers/net/Kconfig                           |    8 +-
 drivers/net/Makefile                          |    2 +-
 drivers/net/virtio/Kconfig                    |   11 +
 drivers/net/virtio/Makefile                   |   10 +
 .../net/{virtio_net.c => virtio/virtnet.c}    | 2368 ++---------------
 drivers/net/virtio/virtnet.h                  |  213 ++
 drivers/net/virtio/virtnet_common.c           |  138 +
 drivers/net/virtio/virtnet_common.h           |   14 +
 drivers/net/virtio/virtnet_ctrl.c             |  272 ++
 drivers/net/virtio/virtnet_ctrl.h             |   45 +
 drivers/net/virtio/virtnet_ethtool.c          |  578 ++++
 drivers/net/virtio/virtnet_ethtool.h          |    8 +
 drivers/net/virtio/virtnet_virtio.c           |  880 ++++++
 drivers/net/virtio/virtnet_virtio.h           |    8 +
 15 files changed, 2366 insertions(+), 2191 deletions(-)
 create mode 100644 drivers/net/virtio/Kconfig
 create mode 100644 drivers/net/virtio/Makefile
 rename drivers/net/{virtio_net.c => virtio/virtnet.c} (50%)
 create mode 100644 drivers/net/virtio/virtnet.h
 create mode 100644 drivers/net/virtio/virtnet_common.c
 create mode 100644 drivers/net/virtio/virtnet_common.h
 create mode 100644 drivers/net/virtio/virtnet_ctrl.c
 create mode 100644 drivers/net/virtio/virtnet_ctrl.h
 create mode 100644 drivers/net/virtio/virtnet_ethtool.c
 create mode 100644 drivers/net/virtio/virtnet_ethtool.h
 create mode 100644 drivers/net/virtio/virtnet_virtio.c
 create mode 100644 drivers/net/virtio/virtnet_virtio.h

--
2.32.0.3.g01195cf9f

