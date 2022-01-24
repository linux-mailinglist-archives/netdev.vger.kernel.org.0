Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C0A497C43
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 10:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiAXJnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 04:43:35 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:45840 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229985AbiAXJnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 04:43:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0V2iRAxk_1643017400;
Received: from hao-A29R.hz.ali.com(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V2iRAxk_1643017400)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 Jan 2022 17:43:29 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     netdev@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [RFC 0/3] io_uring zerocopy receive
Date:   Mon, 24 Jan 2022 17:43:17 +0800
Message-Id: <20220124094320.900713-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Integrate the current zerocopy receive solution to io_uring for eazier
use. The current calling process is:
  1) mmap a range of virtual address
  2) poll() to wait for data ready of the sockfd
  3) call getsockopt() to map the address in 1) to physical pages
  4) access the data.

By integrating it to io_uring, 2) and 3) can be merged:
  1) mmap a range of virtual address
  2) prepare a sqe and submit
  3) get a cqe which indicates data is ready and mapped
  4) access the data

which reduce one system call and make users be unaware of 3)

Also provide a test case which basically reuses
tools/testing/selftests/net/tcp_mmap.c:
https://github.com/HowHsu/liburing/tree/zc_receive

server side:
taskset -c 1-2 ./zc_receive -s -4 -z -M $((4096+12))

client side:
taskset -c 3 ./tcp_mmap -H '127.0.0.1' -z -4 -M $((4096+12))

no much difference of the result since no functionality change.


Hao Xu (3):
  net-zerocopy: split zerocopy receive to several parts
  net-zerocopy: remove static for tcp_zerocopy_receive()
  io_uring: zerocopy receive

 fs/io_uring.c                 |  72 ++++++++++++++++++
 include/net/tcp.h             |   8 ++
 include/uapi/linux/io_uring.h |   1 +
 net/ipv4/tcp.c                | 134 ++++++++++++++++++++--------------
 4 files changed, 159 insertions(+), 56 deletions(-)

-- 
2.25.1

