Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519254A37F6
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 19:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245541AbiA3SDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 13:03:08 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:58703 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355774AbiA3SDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 13:03:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V3B8I4H_1643565783;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V3B8I4H_1643565783)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 31 Jan 2022 02:03:04 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH net-next 0/3] net/smc: Improvements for TCP_CORK and sendfile()
Date:   Mon, 31 Jan 2022 02:02:54 +0800
Message-Id: <20220130180256.28303-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, SMC use default implement for syscall sendfile() [1], which
is wildly used in nginx and big data sences. Usually, applications use
sendfile() with TCP_CORK:

fstat(20, {st_mode=S_IFREG|0644, st_size=4096, ...}) = 0
setsockopt(19, SOL_TCP, TCP_CORK, [1], 4) = 0
writev(19, [{iov_base="HTTP/1.1 200 OK\r\nServer: nginx/1"..., iov_len=240}], 1) = 240
sendfile(19, 20, [0] => [4096], 4096)   = 4096
close(20)                               = 0
setsockopt(19, SOL_TCP, TCP_CORK, [0], 4) = 0

The above is an example of Nginx, when sendfile() on, Nginx first
enables TCP_CORK, write headers, the data will not be sent. Then call
sendfile(), it reads file and write to sndbuf. When TCP_CORK is cleared,
all pending data is sent out.

The performance of the default implement of sendfile is lower than when
it is off. After investigation, it shows two parts to improve:
- unnecessary lock contention of delayed work
- less data per send than when sendfile off

Patch #1 tries to reduce lock_sock() contention in smc_tx_work().
Patch #2 removes timed work for corking, and let applications control
it. See TCP_CORK [2] MSG_MORE [3].
Patch #3 adds MSG_SENDPAGE_NOTLAST for corking more data when
sendfile().

Test environments:
- CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4
- socket sndbuf / rcvbuf: 16384 / 131072 bytes
- server: smc_run nginx
- client: smc_run ./wrk -c 100 -t 2 -d 30 http://192.168.100.1:8080/4k.html
- payload: 4KB local disk file

Items                     QPS
sendfile off        272477.10
sendfile on (orig)  223622.79
sendfile on (this)  395847.21

This benchmark shows +45.28% improvement compared with sendfile off, and
+77.02% compared with original sendfile implement.

[1] https://man7.org/linux/man-pages/man2/sendfile.2.html
[2] https://linux.die.net/man/7/tcp
[3] https://man7.org/linux/man-pages/man2/send.2.html

Tony Lu (3):
  net/smc: Send directly when TCP_CORK is cleared
  net/smc: Remove corked dealyed work
  net/smc: Cork when sendpage with MSG_SENDPAGE_NOTLAST flag

 net/smc/af_smc.c |  8 ++++---
 net/smc/smc_tx.c | 59 ++++++++++++++++++++++++++++++++----------------
 net/smc/smc_tx.h |  3 +++
 3 files changed, 47 insertions(+), 23 deletions(-)

-- 
2.32.0.3.g01195cf9f

