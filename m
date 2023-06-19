Return-Path: <netdev+bounces-11924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC2473549D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:57:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 266B9280FA6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE998825;
	Mon, 19 Jun 2023 10:57:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2484CBE56;
	Mon, 19 Jun 2023 10:57:43 +0000 (UTC)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42359173A;
	Mon, 19 Jun 2023 03:57:42 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VlV8Dkn_1687172258;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VlV8Dkn_1687172258)
          by smtp.aliyun-inc.com;
          Mon, 19 Jun 2023 18:57:39 +0800
From: Heng Qi <hengqi@linux.alibaba.com>
To: netdev@vger.kernel.org,
	bpf@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next 0/4] virtio-net: avoid XDP and _F_GUEST_CSUM
Date: Mon, 19 Jun 2023 18:57:34 +0800
Message-Id: <20230619105738.117733-1-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

virtio-net needs to clear the VIRTIO_NET_F_GUEST_CSUM feature when
loading XDP. The main reason for doing this is because
VIRTIO_NET_F_GUEST_CSUM allows to receive packets marked as
VIRTIO_NET_HDR_F_NEEDS_CSUM. Such packets are not compatible with
XDP programs, because we cannot guarantee that the csum_{start, offset}
fields are correct after XDP modifies the packets.

There is also an existing problem, in the same host vm-vm (eg
[vm]<->[ovs vhost-user]<->[vm]) scenario, loading XDP will cause packet loss.

To solve the above problems, we have discussed in the [1] proposal, and
now try to solve it through the method of reprobing fields suggested
by Jason.

[1] https://lists.oasis-open.org/archives/virtio-dev/202305/msg00318.html

Heng Qi (4):
  virtio-net: a helper for probing the pseudo-header checksum
  virtio-net: reprobe csum related fields for skb passed by XDP
  virtio-net: virtio-net: support coexistence of XDP and _F_GUEST_CSUM
  virtio-net: remove F_GUEST_CSUM check for XDP loading

 drivers/net/virtio_net.c | 173 +++++++++++++++++++++++++++++++++++----
 1 file changed, 158 insertions(+), 15 deletions(-)

-- 
2.19.1.6.gb485710b


