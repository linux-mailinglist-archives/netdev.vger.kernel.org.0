Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674744E73B1
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 13:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356522AbiCYMqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 08:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240996AbiCYMqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 08:46:04 -0400
Received: from smtp.tom.com (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 253D39A9AF
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 05:44:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id C485F4400E7
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 20:44:25 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648212265; bh=vx6jiPGzxriSfAU0zUzWsJReoI3lqmH1luOwYjIJ50U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F61zfOcsTydJhhO38Rg8VPgIrs7/PxMR5LAcx53kw/PzocGjtK54BkwKdOOdTRcP0
         uLmSunOh3txQc5NkEbOX8eYMhdYptx679Tjj2JjYar5z8t1faELg1kqFDl0VEdMu4u
         TbvscjR4lwn0fQ/vppevBrwRYbNg0fMurnm2vQ3A=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID 818082889
          for <netdev@vger.kernel.org>;
          Fri, 25 Mar 2022 20:44:25 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648212265; bh=vx6jiPGzxriSfAU0zUzWsJReoI3lqmH1luOwYjIJ50U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F61zfOcsTydJhhO38Rg8VPgIrs7/PxMR5LAcx53kw/PzocGjtK54BkwKdOOdTRcP0
         uLmSunOh3txQc5NkEbOX8eYMhdYptx679Tjj2JjYar5z8t1faELg1kqFDl0VEdMu4u
         TbvscjR4lwn0fQ/vppevBrwRYbNg0fMurnm2vQ3A=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 5071815415C7;
        Fri, 25 Mar 2022 20:44:19 +0800 (CST)
Date:   Fri, 25 Mar 2022 20:44:18 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220325204418.000041e2@tom.com>
In-Reply-To: <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
References: <20220311103414.8255-1-sunmingbao@tom.com>
        <20220311103414.8255-2-sunmingbao@tom.com>
        <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Combination 2] cubic + switch ECN-marking on

This is a bad scenario.
Since the switch supports ECN-marking, but cubic can not take
advantage of that.
So we can see the bandwidth of each TX node could suddenly drop
several hundreds MB/S due to packet dropping and timeout-retransmission.
And the total bandwidth on the RX node can not reachto the full link
bandwidth (which is about 6 GB/S).

/*
 * before loading traffic, clear the counters on the 2 switches.
 */

hound-dirt# clear qos statistics type queuing interface ethernet 1/1/4
hound-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     0                        0                        0                        0                        
1     0                        0                        0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     0                        0                        0                        0                        
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
hound-dirt#

fox-dirt# clear qos statistics type queuing interface ethernet 1/1/4
fox-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     0                        0                        0                        0                        
1     0                        0                        0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     0                        0                        0                        0                        
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
fox-dirt# 



/*
 * logs of RX node.
 */

ogden-dirt:/home/admin/tyler # echo cubic >/proc/sys/net/ipv4/tcp_congestion_control
ogden-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
cubic
ogden-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 24 -s -r  --data-random --svr-no-wait-all-conn-OK --show-bandwidth-only
Fri Mar 25 08:23:13 EDT 2022
DBG:/mnt/hgfs/src/linux-dev-framework-master/libs/app_utils/src/socket.c(104)-socket_init_2:
bind socket fd 3 to 169.254.85.4:10001 succeed
DBG:perf_frmwk.c(1472)-create_tcp_conns_start_load:
start listen on fd 3
conn [0] local 169.254.85.4:10001 peer 169.254.85.3:59676 created.
rx thread of conn 0 started
conn [1] local 169.254.85.4:10001 peer 169.254.85.3:59678 created.
rx thread of conn 1 started
conn [2] local 169.254.85.4:10001 peer 169.254.85.3:59680 created.
rx thread of conn 2 started
conn [3] local 169.254.85.4:10001 peer 169.254.85.3:59682 created.
rx thread of conn 3 started
conn [4] local 169.254.85.4:10001 peer 169.254.85.3:59684 created.
conn [5] local 169.254.85.4:10001 peer 169.254.85.3:59686 created.
rx thread of conn 4 started
conn [6] local 169.254.85.4:10001 peer 169.254.85.3:59688 created.
rx thread of conn 5 started
rx thread of conn 6 started
conn [7] local 169.254.85.4:10001 peer 169.254.85.3:59690 created.
rx thread of conn 7 started
conn [8] local 169.254.85.4:10001 peer 169.254.85.2:37974 created.
rx thread of conn 8 started
conn [9] local 169.254.85.4:10001 peer 169.254.85.2:37978 created.
rx thread of conn 9 started
conn [10] local 169.254.85.4:10001 peer 169.254.85.2:37980 created.
rx thread of conn 10 started
conn [11] local 169.254.85.4:10001 peer 169.254.85.2:37982 created.
rx thread of conn 11 started
conn [12] local 169.254.85.4:10001 peer 169.254.85.2:37984 created.
rx thread of conn 12 started
conn [13] local 169.254.85.4:10001 peer 169.254.85.2:37986 created.
conn [14] local 169.254.85.4:10001 peer 169.254.85.2:37988 created.
rx thread of conn 13 started
conn [15] local 169.254.85.4:10001 peer 169.254.85.2:37990 created.
rx thread of conn 14 started
rx thread of conn 15 started

[time lasts]: 1
        rx_msg_succ_bytes                   0x1625d0000       (5,945,229,312)
conn [16] local 169.254.85.4:10001 peer 169.254.85.1:49484 created.
rx thread of conn 16 started
conn [17] local 169.254.85.4:10001 peer 169.254.85.1:49486 created.
rx thread of conn 17 started
conn [18] local 169.254.85.4:10001 peer 169.254.85.1:49490 created.
rx thread of conn 18 started
conn [19] local 169.254.85.4:10001 peer 169.254.85.1:49492 created.
rx thread of conn 19 started
conn [20] local 169.254.85.4:10001 peer 169.254.85.1:49494 created.
rx thread of conn 20 started
conn [21] local 169.254.85.4:10001 peer 169.254.85.1:49496 created.
rx thread of conn 21 started
conn [22] local 169.254.85.4:10001 peer 169.254.85.1:49498 created.
rx thread of conn 22 started
conn [23] local 169.254.85.4:10001 peer 169.254.85.1:49488 created.
24 connection(s) created in total
rx thread of conn 23 started

[time lasts]: 2
        rx_msg_succ_bytes                   0x153a90000       (5,698,551,808)

[time lasts]: 3
        rx_msg_succ_bytes                   0x1589a0000       (5,781,454,848)

[time lasts]: 4
        rx_msg_succ_bytes                   0x156770000       (5,745,606,656)

[time lasts]: 5
        rx_msg_succ_bytes                   0x155e30000       (5,735,907,328)

[time lasts]: 6
        rx_msg_succ_bytes                   0x1583f0000       (5,775,491,072)

[time lasts]: 7
        rx_msg_succ_bytes                   0x159de0000       (5,802,688,512)

[time lasts]: 8
        rx_msg_succ_bytes                   0x153b00000       (5,699,010,560)

[time lasts]: 9
        rx_msg_succ_bytes                   0x153a50000       (5,698,289,664)

[time lasts]: 10
        rx_msg_succ_bytes                   0x1568a0000       (5,746,851,840)

[time lasts]: 11
        rx_msg_succ_bytes                   0x157bb0000       (5,766,840,320)

[time lasts]: 12
        rx_msg_succ_bytes                   0x15a2a0000       (5,807,669,248)

[time lasts]: 13
        rx_msg_succ_bytes                   0x155020000       (5,721,161,728)

[time lasts]: 14
        rx_msg_succ_bytes                   0x154b40000       (5,716,049,920)

[time lasts]: 15
        rx_msg_succ_bytes                   0x157610000       (5,760,942,080)

[time lasts]: 16
        rx_msg_succ_bytes                   0x157cd0000       (5,768,019,968)

[time lasts]: 17
        rx_msg_succ_bytes                   0x153cf0000       (5,701,042,176)

[time lasts]: 18
        rx_msg_succ_bytes                   0x151820000       (5,662,441,472)

[time lasts]: 19
        rx_msg_succ_bytes                   0x153fa0000       (5,703,860,224)

[time lasts]: 20
        rx_msg_succ_bytes                   0x150af0000       (5,648,613,376)

[time lasts]: 21
        rx_msg_succ_bytes                   0x152a70000       (5,681,643,520)

[time lasts]: 22
        rx_msg_succ_bytes                   0x154e10000       (5,718,999,040)

[time lasts]: 23
        rx_msg_succ_bytes                   0x157d60000       (5,768,609,792)

[time lasts]: 24
        rx_msg_succ_bytes                   0x1581d0000       (5,773,262,848)

[time lasts]: 25
        rx_msg_succ_bytes                   0x157240000       (5,756,944,384)

[time lasts]: 26
        rx_msg_succ_bytes                   0x159e50000       (5,803,147,264)

[time lasts]: 27
        rx_msg_succ_bytes                   0x1535b0000       (5,693,440,000)

[time lasts]: 28
        rx_msg_succ_bytes                   0x157390000       (5,758,320,640)

[time lasts]: 29
        rx_msg_succ_bytes                   0x155620000       (5,727,453,184)

[time lasts]: 30
        rx_msg_succ_bytes                   0x153c80000       (5,700,583,424)

[time lasts]: 31
        rx_msg_succ_bytes                   0x154cb0000       (5,717,557,248)

[time lasts]: 32
        rx_msg_succ_bytes                   0x153ea0000       (5,702,811,648)

[time lasts]: 33
        rx_msg_succ_bytes                   0x1577f0000       (5,762,908,160)

[time lasts]: 34
        rx_msg_succ_bytes                   0x158090000       (5,771,952,128)

[time lasts]: 35
        rx_msg_succ_bytes                   0x154040000       (5,704,515,584)

[time lasts]: 36
        rx_msg_succ_bytes                   0x1577f0000       (5,762,908,160)

[time lasts]: 37
        rx_msg_succ_bytes                   0x154900000       (5,713,690,624)

[time lasts]: 38
        rx_msg_succ_bytes                   0x155750000       (5,728,698,368)

[time lasts]: 39
        rx_msg_succ_bytes                   0x154ca0000       (5,717,491,712)

[time lasts]: 40
        rx_msg_succ_bytes                   0x158110000       (5,772,476,416)

[time lasts]: 41
        rx_msg_succ_bytes                   0x155c90000       (5,734,203,392)

[time lasts]: 42
        rx_msg_succ_bytes                   0x1563a0000       (5,741,608,960)

[time lasts]: 43
        rx_msg_succ_bytes                   0x1566e0000       (5,745,016,832)

[time lasts]: 44
        rx_msg_succ_bytes                   0x158d20000       (5,785,124,864)

[time lasts]: 45
        rx_msg_succ_bytes                   0x156c70000       (5,750,849,536)

[time lasts]: 46
        rx_msg_succ_bytes                   0x1536c0000       (5,694,554,112)

[time lasts]: 47
        rx_msg_succ_bytes                   0x15b030000       (5,821,890,560)

[time lasts]: 48
        rx_msg_succ_bytes                   0x156ac0000       (5,749,080,064)

[time lasts]: 49
        rx_msg_succ_bytes                   0x151950000       (5,663,686,656)

[time lasts]: 50
        rx_msg_succ_bytes                   0x156f80000       (5,754,060,800)

[time lasts]: 51
        rx_msg_succ_bytes                   0x158250000       (5,773,787,136)

[time lasts]: 52
        rx_msg_succ_bytes                   0x156830000       (5,746,393,088)

[time lasts]: 53
        rx_msg_succ_bytes                   0x157470000       (5,759,238,144)

[time lasts]: 54
        rx_msg_succ_bytes                   0x1557a0000       (5,729,026,048)

[time lasts]: 55
        rx_msg_succ_bytes                   0x156270000       (5,740,363,776)

[time lasts]: 56
        rx_msg_succ_bytes                   0x158da0000       (5,785,649,152)

[time lasts]: 57
        rx_msg_succ_bytes                   0x158980000       (5,781,323,776)

[time lasts]: 58
        rx_msg_succ_bytes                   0x154fe0000       (5,720,899,584)

[time lasts]: 59
        rx_msg_succ_bytes                   0x155530000       (5,726,470,144)

[time lasts]: 60
        rx_msg_succ_bytes                   0x156da0000       (5,752,094,720)

[time lasts]: 61
        rx_msg_succ_bytes                   0x155f70000       (5,737,218,048)

[time lasts]: 62
        rx_msg_succ_bytes                   0x154500000       (5,709,496,320)

[time lasts]: 63
        rx_msg_succ_bytes                   0x157c50000       (5,767,495,680)

[time lasts]: 64
        rx_msg_succ_bytes                   0x1550b0000       (5,721,751,552)

[time lasts]: 65
        rx_msg_succ_bytes                   0x1586c0000       (5,778,440,192)
^Ccaught signal 2

/*
 * logs of TX node 1.
 */

provo-dirt:/home/admin/tyler # echo cubic >/proc/sys/net/ipv4/tcp_congestion_control 
provo-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
cubic
provo-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 08:23:18 EDT 2022
conn [0] local 169.254.85.1:49484 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.1:49486 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.1:49488 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.1:49490 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.1:49492 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.1:49494 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.1:49496 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.1:49498 peer 169.254.85.4:10001 created.
8 connection(s) created in total
tx thread of conn 0 started
tx thread of conn 1 started
tx thread of conn 2 started
tx thread of conn 3 started
tx thread of conn 4 started
tx thread of conn 5 started
tx thread of conn 6 started
tx thread of conn 7 started

[time lasts]: 1
        tx_succ_bytes                       0x76930000        (1,989,345,280)

[time lasts]: 2
        tx_succ_bytes                       0x639f0000        (1,671,364,608)

[time lasts]: 3
        tx_succ_bytes                       0x7e1d0000        (2,115,829,760)

[time lasts]: 4
        tx_succ_bytes                       0x770b0000        (1,997,209,600)

[time lasts]: 5
        tx_succ_bytes                       0x68900000        (1,754,267,648)

[time lasts]: 6
        tx_succ_bytes                       0x53dd0000        (1,406,992,384)

[time lasts]: 7
        tx_succ_bytes                       0x6eab0000        (1,856,700,416)

[time lasts]: 8
        tx_succ_bytes                       0x4c200000        (1,277,165,568)

[time lasts]: 9
        tx_succ_bytes                       0x6eab0000        (1,856,700,416)

[time lasts]: 10
        tx_succ_bytes                       0x793e0000        (2,034,106,368)

[time lasts]: 11
        tx_succ_bytes                       0x5b7a0000        (1,534,722,048)

[time lasts]: 12
        tx_succ_bytes                       0x6c220000        (1,814,167,552)

[time lasts]: 13
        tx_succ_bytes                       0x65660000        (1,701,183,488)

[time lasts]: 14
        tx_succ_bytes                       0x77860000        (2,005,270,528)

[time lasts]: 15
        tx_succ_bytes                       0x6eff0000        (1,862,205,440)

[time lasts]: 16
        tx_succ_bytes                       0x65330000        (1,697,841,152)

[time lasts]: 17
        tx_succ_bytes                       0x73600000        (1,935,671,296)

[time lasts]: 18
        tx_succ_bytes                       0x7cf30000        (2,096,300,032)

[time lasts]: 19
        tx_succ_bytes                       0x838d0000        (2,207,055,872)

[time lasts]: 20
        tx_succ_bytes                       0x8ea90000        (2,393,440,256)

[time lasts]: 21
        tx_succ_bytes                       0x5ef50000        (1,593,114,624)

[time lasts]: 22
        tx_succ_bytes                       0x693e0000        (1,765,670,912)

[time lasts]: 23
        tx_succ_bytes                       0x64390000        (1,681,457,152)

[time lasts]: 24
        tx_succ_bytes                       0x69400000        (1,765,801,984)

[time lasts]: 25
        tx_succ_bytes                       0x69fb0000        (1,778,057,216)

[time lasts]: 26
        tx_succ_bytes                       0x710a0000        (1,896,480,768)

[time lasts]: 27
        tx_succ_bytes                       0x70170000        (1,880,555,520)

[time lasts]: 28
        tx_succ_bytes                       0x7ed30000        (2,127,757,312)

[time lasts]: 29
        tx_succ_bytes                       0x70830000        (1,887,633,408)

[time lasts]: 30
        tx_succ_bytes                       0x6fcb0000        (1,875,574,784)

[time lasts]: 31
        tx_succ_bytes                       0x6dc30000        (1,841,496,064)

[time lasts]: 32
        tx_succ_bytes                       0x7f060000        (2,131,099,648)

[time lasts]: 33
        tx_succ_bytes                       0x79760000        (2,037,776,384)

[time lasts]: 34
        tx_succ_bytes                       0x78f30000        (2,029,191,168)

[time lasts]: 35
        tx_succ_bytes                       0x621a0000        (1,645,871,104)

[time lasts]: 36
        tx_succ_bytes                       0x7a5d0000        (2,052,915,200)

[time lasts]: 37
        tx_succ_bytes                       0x7fb80000        (2,142,765,056)

[time lasts]: 38
        tx_succ_bytes                       0x73ed0000        (1,944,911,872)

[time lasts]: 39
        tx_succ_bytes                       0x6fb20000        (1,873,936,384)

[time lasts]: 40
        tx_succ_bytes                       0x72110000        (1,913,716,736)

[time lasts]: 41
        tx_succ_bytes                       0x59240000        (1,495,531,520)

[time lasts]: 42
        tx_succ_bytes                       0x55e30000        (1,440,940,032)

[time lasts]: 43
        tx_succ_bytes                       0x69e20000        (1,776,418,816)

[time lasts]: 44
        tx_succ_bytes                       0x849a0000        (2,224,685,056)

[time lasts]: 45
        tx_succ_bytes                       0x7a930000        (2,056,454,144)

[time lasts]: 46
        tx_succ_bytes                       0x79230000        (2,032,336,896)

[time lasts]: 47
        tx_succ_bytes                       0x6d690000        (1,835,597,824)

[time lasts]: 48
        tx_succ_bytes                       0x77c60000        (2,009,464,832)

[time lasts]: 49
        tx_succ_bytes                       0x5c670000        (1,550,254,080)

[time lasts]: 50
        tx_succ_bytes                       0x6a210000        (1,780,547,584)

[time lasts]: 51
        tx_succ_bytes                       0x64ef0000        (1,693,384,704)

[time lasts]: 52
        tx_succ_bytes                       0x810a0000        (2,164,916,224)

[time lasts]: 53
        tx_succ_bytes                       0x7a4f0000        (2,051,997,696)

[time lasts]: 54
        tx_succ_bytes                       0x70ac0000        (1,890,320,384)

[time lasts]: 55
        tx_succ_bytes                       0x92260000        (2,451,963,904)

[time lasts]: 56
        tx_succ_bytes                       0x5d500000        (1,565,523,968)

[time lasts]: 57
        tx_succ_bytes                       0x59030000        (1,493,368,832)

[time lasts]: 58
        tx_succ_bytes                       0x7ad60000        (2,060,845,056)

[time lasts]: 59
        tx_succ_bytes                       0x765a0000        (1,985,609,728)

[time lasts]: 60
        tx_succ_bytes                       0x6c1e0000        (1,813,905,408)

[time lasts]: 61
        tx_succ_bytes                       0x6eeb0000        (1,860,894,720)

[time lasts]: 62
        tx_succ_bytes                       0x6ab50000        (1,790,246,912)

[time lasts]: 63
        tx_succ_bytes                       0x64cf0000        (1,691,287,552)

/*
 * logs of TX node 2.
 */

sandy-dirt:/home/admin/tyler # echo cubic >/proc/sys/net/ipv4/tcp_congestion_control
sandy-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
cubic
sandy-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 08:23:16 EDT 2022
conn [0] local 169.254.85.2:37974 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.2:37978 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.2:37980 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.2:37982 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.2:37984 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.2:37986 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.2:37988 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.2:37990 peer 169.254.85.4:10001 created.
8 connection(s) created in total
tx thread of conn 0 started
tx thread of conn 1 started
tx thread of conn 2 started
tx thread of conn 3 started
tx thread of conn 4 started
tx thread of conn 5 started
tx thread of conn 6 started
tx thread of conn 7 started

[time lasts]: 1
        tx_succ_bytes                       0x87790000        (2,272,854,016)

[time lasts]: 2
        tx_succ_bytes                       0x62f50000        (1,660,223,488)

[time lasts]: 3
        tx_succ_bytes                       0x70030000        (1,879,244,800)

[time lasts]: 4
        tx_succ_bytes                       0x5b990000        (1,536,753,664)

[time lasts]: 5
        tx_succ_bytes                       0x64210000        (1,679,884,288)

[time lasts]: 6
        tx_succ_bytes                       0x6a0a0000        (1,779,040,256)

[time lasts]: 7
        tx_succ_bytes                       0x75720000        (1,970,405,376)

[time lasts]: 8
        tx_succ_bytes                       0x7d980000        (2,107,113,472)

[time lasts]: 9
        tx_succ_bytes                       0x8d070000        (2,366,046,208)

[time lasts]: 10
        tx_succ_bytes                       0x74030000        (1,946,353,664)

[time lasts]: 11
        tx_succ_bytes                       0x71f20000        (1,911,685,120)

[time lasts]: 12
        tx_succ_bytes                       0x7f900000        (2,140,143,616)

[time lasts]: 13
        tx_succ_bytes                       0x6f690000        (1,869,152,256)

[time lasts]: 14
        tx_succ_bytes                       0x8edd0000        (2,396,848,128)

[time lasts]: 15
        tx_succ_bytes                       0x80c30000        (2,160,263,168)

[time lasts]: 16
        tx_succ_bytes                       0x79a40000        (2,040,791,040)

[time lasts]: 17
        tx_succ_bytes                       0x82120000        (2,182,217,728)

[time lasts]: 18
        tx_succ_bytes                       0x69e30000        (1,776,484,352)

[time lasts]: 19
        tx_succ_bytes                       0x64c80000        (1,690,828,800)

[time lasts]: 20
        tx_succ_bytes                       0x6e430000        (1,849,884,672)

[time lasts]: 21
        tx_succ_bytes                       0x6b110000        (1,796,276,224)

[time lasts]: 22
        tx_succ_bytes                       0x753c0000        (1,966,866,432)

[time lasts]: 23
        tx_succ_bytes                       0x80c30000        (2,160,263,168)

[time lasts]: 24
        tx_succ_bytes                       0x7c700000        (2,087,714,816)

[time lasts]: 25
        tx_succ_bytes                       0x72ec0000        (1,928,069,120)

[time lasts]: 26
        tx_succ_bytes                       0x84d20000        (2,228,355,072)

[time lasts]: 27
        tx_succ_bytes                       0x70f60000        (1,895,170,048)

[time lasts]: 28
        tx_succ_bytes                       0x613c0000        (1,631,322,112)

[time lasts]: 29
        tx_succ_bytes                       0x7cf00000        (2,096,103,424)

[time lasts]: 30
        tx_succ_bytes                       0x61270000        (1,629,945,856)

[time lasts]: 31
        tx_succ_bytes                       0x608d0000        (1,619,853,312)

[time lasts]: 32
        tx_succ_bytes                       0x7cdd0000        (2,094,858,240)

[time lasts]: 33
        tx_succ_bytes                       0x6e430000        (1,849,884,672)

[time lasts]: 34
        tx_succ_bytes                       0x5d820000        (1,568,800,768)

[time lasts]: 35
        tx_succ_bytes                       0x78f40000        (2,029,256,704)

[time lasts]: 36
        tx_succ_bytes                       0x66c20000        (1,723,990,016)

[time lasts]: 37
        tx_succ_bytes                       0x7ba60000        (2,074,476,544)

[time lasts]: 38
        tx_succ_bytes                       0x58600000        (1,482,686,464)

[time lasts]: 39
        tx_succ_bytes                       0x64710000        (1,685,127,168)

[time lasts]: 40
        tx_succ_bytes                       0x6e410000        (1,849,753,600)

[time lasts]: 41
        tx_succ_bytes                       0x65d00000        (1,708,130,304)

[time lasts]: 42
        tx_succ_bytes                       0x83490000        (2,202,599,424)

[time lasts]: 43
        tx_succ_bytes                       0x95950000        (2,509,570,048)

[time lasts]: 44
        tx_succ_bytes                       0x81980000        (2,174,222,336)

[time lasts]: 45
        tx_succ_bytes                       0x6acb0000        (1,791,688,704)

[time lasts]: 46
        tx_succ_bytes                       0x73320000        (1,932,656,640)

[time lasts]: 47
        tx_succ_bytes                       0x70000000        (1,879,048,192)

[time lasts]: 48
        tx_succ_bytes                       0x73b40000        (1,941,176,320)

[time lasts]: 49
        tx_succ_bytes                       0x5bdd0000        (1,541,210,112)

[time lasts]: 50
        tx_succ_bytes                       0x7e980000        (2,123,890,688)

[time lasts]: 51
        tx_succ_bytes                       0x7cf00000        (2,096,103,424)

[time lasts]: 52
        tx_succ_bytes                       0x802c0000        (2,150,367,232)

[time lasts]: 53
        tx_succ_bytes                       0x61540000        (1,632,894,976)

[time lasts]: 54
        tx_succ_bytes                       0x5f690000        (1,600,716,800)

[time lasts]: 55
        tx_succ_bytes                       0x6cde0000        (1,826,488,320)

[time lasts]: 56
        tx_succ_bytes                       0x6af90000        (1,794,703,360)

[time lasts]: 57
        tx_succ_bytes                       0x9ba10000        (2,611,019,776)

[time lasts]: 58
        tx_succ_bytes                       0x82ea0000        (2,196,373,504)

[time lasts]: 59
        tx_succ_bytes                       0x80a30000        (2,158,166,016)

[time lasts]: 60
        tx_succ_bytes                       0x5d4c0000        (1,565,261,824)

[time lasts]: 61
        tx_succ_bytes                       0x789e0000        (2,023,620,608)

[time lasts]: 62
        tx_succ_bytes                       0x65cf0000        (1,708,064,768)

[time lasts]: 63
        tx_succ_bytes                       0x83050000        (2,198,142,976)

/*
 * logs of TX node 3.
 */

orem-dirt:/home/admin/tyler # echo cubic >/proc/sys/net/ipv4/tcp_congestion_control
orem-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
cubic
orem-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 08:23:15 EDT 2022
conn [0] local 169.254.85.3:59676 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.3:59678 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.3:59680 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.3:59682 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.3:59684 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.3:59686 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.3:59688 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.3:59690 peer 169.254.85.4:10001 created.
8 connection(s) created in total
tx thread of conn 0 started
tx thread of conn 1 started
tx thread of conn 2 started
tx thread of conn 3 started
tx thread of conn 4 started
tx thread of conn 5 started
tx thread of conn 6 started
tx thread of conn 7 started

[time lasts]: 1
        tx_succ_bytes                       0x15b6d0000       (5,828,837,376)

[time lasts]: 2
        tx_succ_bytes                       0xb1590000        (2,975,399,936)

[time lasts]: 3
        tx_succ_bytes                       0x8e2e0000        (2,385,379,328)

[time lasts]: 4
        tx_succ_bytes                       0x79cd0000        (2,043,478,016)

[time lasts]: 5
        tx_succ_bytes                       0x7e280000        (2,116,550,656)

[time lasts]: 6
        tx_succ_bytes                       0x80dc0000        (2,161,901,568)

[time lasts]: 7
        tx_succ_bytes                       0x7fa90000        (2,141,782,016)

[time lasts]: 8
        tx_succ_bytes                       0x8d530000        (2,371,026,944)

[time lasts]: 9
        tx_succ_bytes                       0x6bf10000        (1,810,956,288)

[time lasts]: 10
        tx_succ_bytes                       0x7d2c0000        (2,100,035,584)

[time lasts]: 11
        tx_succ_bytes                       0x6cca0000        (1,825,177,600)

[time lasts]: 12
        tx_succ_bytes                       0x755f0000        (1,969,160,192)

[time lasts]: 13
        tx_succ_bytes                       0x78240000        (2,015,625,216)

[time lasts]: 14
        tx_succ_bytes                       0x7a880000        (2,055,733,248)

[time lasts]: 15
        tx_succ_bytes                       0x5e980000        (1,587,019,776)

[time lasts]: 16
        tx_succ_bytes                       0x59fe0000        (1,509,818,368)

[time lasts]: 17
        tx_succ_bytes                       0x6e370000        (1,849,098,240)

[time lasts]: 18
        tx_succ_bytes                       0x6db80000        (1,840,775,168)

[time lasts]: 19
        tx_succ_bytes                       0x72f60000        (1,928,724,480)

[time lasts]: 20
        tx_succ_bytes                       0x6b7c0000        (1,803,288,576)

[time lasts]: 21
        tx_succ_bytes                       0x64040000        (1,677,983,744)

[time lasts]: 22
        tx_succ_bytes                       0x63c80000        (1,674,051,584)

[time lasts]: 23
        tx_succ_bytes                       0x7abd0000        (2,059,206,656)

[time lasts]: 24
        tx_succ_bytes                       0x78b60000        (2,025,193,472)

[time lasts]: 25
        tx_succ_bytes                       0x73c00000        (1,941,962,752)

[time lasts]: 26
        tx_succ_bytes                       0x779e0000        (2,006,843,392)

[time lasts]: 27
        tx_succ_bytes                       0x6ba70000        (1,806,106,624)

[time lasts]: 28
        tx_succ_bytes                       0x73140000        (1,930,690,560)

[time lasts]: 29
        tx_succ_bytes                       0x79e20000        (2,044,854,272)

[time lasts]: 30
        tx_succ_bytes                       0x64210000        (1,679,884,288)

[time lasts]: 31
        tx_succ_bytes                       0x80b70000        (2,159,476,736)

[time lasts]: 32
        tx_succ_bytes                       0x79450000        (2,034,565,120)

[time lasts]: 33
        tx_succ_bytes                       0x72e30000        (1,927,479,296)

[time lasts]: 34
        tx_succ_bytes                       0x664f0000        (1,716,453,376)

[time lasts]: 35
        tx_succ_bytes                       0x81120000        (2,165,440,512)

[time lasts]: 36
        tx_succ_bytes                       0x6abd0000        (1,790,771,200)

[time lasts]: 37
        tx_succ_bytes                       0x88530000        (2,287,140,864)

[time lasts]: 38
        tx_succ_bytes                       0x5a210000        (1,512,112,128)

[time lasts]: 39
        tx_succ_bytes                       0x7e4a0000        (2,118,778,880)

[time lasts]: 40
        tx_succ_bytes                       0x86fe0000        (2,264,793,088)

[time lasts]: 41
        tx_succ_bytes                       0x73c10000        (1,942,028,288)

[time lasts]: 42
        tx_succ_bytes                       0x83620000        (2,204,237,824)

[time lasts]: 43
        tx_succ_bytes                       0x7f900000        (2,140,143,616)

[time lasts]: 44
        tx_succ_bytes                       0x699c0000        (1,771,831,296)

[time lasts]: 45
        tx_succ_bytes                       0x5e0d0000        (1,577,910,272)

[time lasts]: 46
        tx_succ_bytes                       0x66890000        (1,720,254,464)

[time lasts]: 47
        tx_succ_bytes                       0x75a10000        (1,973,485,568)

[time lasts]: 48
        tx_succ_bytes                       0x6b3f0000        (1,799,290,880)

[time lasts]: 49
        tx_succ_bytes                       0x764d0000        (1,984,757,760)

[time lasts]: 50
        tx_succ_bytes                       0x83320000        (2,201,092,096)

[time lasts]: 51
        tx_succ_bytes                       0x75ca0000        (1,976,172,544)

[time lasts]: 52
        tx_succ_bytes                       0x759e0000        (1,973,288,960)

[time lasts]: 53
        tx_succ_bytes                       0x6b160000        (1,796,603,904)

[time lasts]: 54
        tx_succ_bytes                       0x74430000        (1,950,547,968)

[time lasts]: 55
        tx_succ_bytes                       0x7ed90000        (2,128,150,528)

[time lasts]: 56
        tx_succ_bytes                       0x74ff0000        (1,962,868,736)

[time lasts]: 57
        tx_succ_bytes                       0x60dd0000        (1,625,096,192)

[time lasts]: 58
        tx_succ_bytes                       0x5eca0000        (1,590,296,576)

[time lasts]: 59
        tx_succ_bytes                       0x73890000        (1,938,358,272)

[time lasts]: 60
        tx_succ_bytes                       0x5e8c0000        (1,586,233,344)

[time lasts]: 61
        tx_succ_bytes                       0x7d010000        (2,097,217,536)

[time lasts]: 62
        tx_succ_bytes                       0x76cd0000        (1,993,146,368)

[time lasts]: 63
        tx_succ_bytes                       0x81620000        (2,170,683,392)

[time lasts]: 64
        tx_succ_bytes                       0x6b980000        (1,805,123,584)

/*
 * counters on the switch.
 * we can see, the rate of packet dropping is so high (~5%).
 */

hound-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     0                        0                        0                        0                        
1     9                        882                      0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     21377065                 191400217674             1263665                  11321730380              
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
hound-dirt#

fox-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     10                       654                      0                        0                        
1     6                        588                      0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     21228491                 189957815718             1192655                  10677602488              
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
fox-dirt#
