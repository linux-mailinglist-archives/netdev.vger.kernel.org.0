Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2CF14624D
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAWHLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:11:20 -0500
Received: from relay.sw.ru ([185.231.240.75]:36248 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgAWHLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 02:11:19 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1iuWdp-0005p7-V8; Thu, 23 Jan 2020 10:11:02 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 0/6] netdev: seq_file .next functions should increase position
 index
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org
Message-ID: <4d27bcf7-cebf-0f7d-9d5b-5bf1f681eff7@virtuozzo.com>
Date:   Thu, 23 Jan 2020 10:11:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Aug 2018 NeilBrown noticed 
commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
"Some ->next functions do not increment *pos when they return NULL...
Note that such ->next functions are buggy and should be fixed. 
A simple demonstration is
   
dd if=/proc/swaps bs=1000 skip=1
    
Choose any block size larger than the size of /proc/swaps.  This will
always show the whole last line of /proc/swaps"

Described problem is still actual. If you make lseek into middle of last output line 
following read will output end of last line and whole last line once again.

$ dd if=/proc/swaps bs=1  # usual output
Filename				Type		Size	Used	Priority
/dev/dm-0                               partition	4194812	97536	-2
104+0 records in
104+0 records out
104 bytes copied

$ dd if=/proc/swaps bs=40 skip=1    # last line was generated twice
dd: /proc/swaps: cannot skip to specified offset
v/dm-0                               partition	4194812	97536	-2
/dev/dm-0                               partition	4194812	97536	-2 
3+1 records in
3+1 records out
131 bytes copied

There are lot of other affected files, I've found 30+ including
/proc/net/ip_tables_matches and /proc/sysvipc/*

This patch-set fixes files related to netdev@ 

https://bugzilla.kernel.org/show_bug.cgi?id=206283

Vasily Averin (6):
  seq_tab_next() should increase position index
  l2t_seq_next should increase position index
  vcc_seq_next should increase position index
  neigh_stat_seq_next() should increase position index
  rt_cpu_seq_next should increase position index
  ipv6_route_seq_next should increase position index

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           | 3 +--
 net/atm/proc.c                                     | 3 +--
 net/core/neighbour.c                               | 1 +
 net/ipv4/route.c                                   | 1 +
 net/ipv6/ip6_fib.c                                 | 7 ++-----
 6 files changed, 7 insertions(+), 11 deletions(-)

-- 
1.8.3.1
