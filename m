Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B972B7887
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgKRIZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:25:15 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:60025 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbgKRIZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:25:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UFmyUVT_1605687910;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UFmyUVT_1605687910)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Nov 2020 16:25:10 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     bjorn.topel@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] xsk: fix for xsk_poll writeable
Date:   Wed, 18 Nov 2020 16:25:07 +0800
Message-Id: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com>
References: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I tried to combine cq available and tx writeable, but I found it very difficult.
Sometimes we pay attention to the status of "available" for both, but sometimes,
we may only pay attention to one, such as tx writeable, because we can use the
item of fq to write to tx. And this kind of demand may be constantly changing,
and it may be necessary to set it every time before entering xsk_poll, so
setsockopt is not very convenient. I feel even more that using a new event may
be a better solution, such as EPOLLPRI, I think it can be used here, after all,
xsk should not have OOB data ^_^.

However, two other problems were discovered during the test:

* The mask returned by datagram_poll always contains EPOLLOUT
* It is not particularly reasonable to return EPOLLOUT based on tx not full

After fixing these two problems, I found that when the process is awakened by
EPOLLOUT, the process can always get the item from cq.

Because the number of packets that the network card can send at a time is
actually limited, suppose this value is "nic_num". Once the number of
consumed items in the tx queue is greater than nic_num, this means that there
must also be new recycled items in the cq queue from nic.

In this way, as long as the tx configured by the user is larger, we won't have
the situation that tx is already in the writeable state but cannot get the item
from cq.

Xuan Zhuo (3):
  xsk: replace datagram_poll by sock_poll_wait
  xsk: change the tx writeable condition
  xsk: set tx/rx the min entries

 include/uapi/linux/if_xdp.h |  2 ++
 net/xdp/xsk.c               | 26 ++++++++++++++++++++++----
 net/xdp/xsk_queue.h         |  6 ++++++
 3 files changed, 30 insertions(+), 4 deletions(-)

--
1.8.3.1

