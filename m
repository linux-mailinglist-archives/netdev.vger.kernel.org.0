Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589AF6E4765
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjDQMRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjDQMRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:17:52 -0400
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822B840C8;
        Mon, 17 Apr 2023 05:17:41 -0700 (PDT)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4Q0Qzl5NChz8RTWk;
        Mon, 17 Apr 2023 20:17:39 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
        by mse-fl2.zte.com.cn with SMTP id 33HCHWra054181;
        Mon, 17 Apr 2023 20:17:32 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Mon, 17 Apr 2023 20:17:35 +0800 (CST)
Date:   Mon, 17 Apr 2023 20:17:35 +0800 (CST)
X-Zmail-TransId: 2b03643d38df06a-f65b9
X-Mailer: Zmail v1.0
Message-ID: <202304172017351308785@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <edumazet@google.com>
Cc:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgMC8zXSBzZWxmdGVzdHM6IG5ldDogdWRwZ3NvX2JlbmNoX3J4OiBGaXggdmVyaWZ0eSwgZ3Nvc2l6ZSwgYW5kIHBhY2tldCBudW1iZXIgZXhjZXB0aW9ucw==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 33HCHWra054181
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 643D38E3.000/4Q0Qzl5NChz8RTWk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>

1.Fix verifty exception
Executing the following command fails:
bash# udpgso_bench_tx -l 4 -4 -D "$DST"
bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
bash# udpgso_bench_rx -4 -G -S 1472 -v
udpgso_bench_rx: data[1472]: len 2944, a(97) != q(113)

This is because the sending buffers are not aligned by 26 bytes, and the
GRO is not merged sequentially, and the receiver does not judge this
situation. We think of the receiver to split the data and then validate
it, just as the application actually uses this feature.

2.Fix gsosize exception
Executing the following command fails:
bash# udpgso_bench_tx -l 4 -4 -D "$DST"
bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
bash# udpgso_bench_rx -4 -G -S 1472
udp rx:     15 MB/s      256 calls/s
udp rx:     30 MB/s      512 calls/s
udpgso_bench_rx: recv: bad gso size, got -1, expected 1472
(-1 == no gso cmsg))

 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 7360
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 1472
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 1472
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 4416
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 11776
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 20608
recv: got one message len:1472, probably not an error.
recv: got one message len:1472, probably not an error.

This is due to network, NAPI, timer, etc., only one message being received.
We believe that this situation should be normal.

3.Fix packet number exception
bash# udpgso_bench_rx -4 -n 100
bash# udpgso_bench_tx -l 1 -4 -D "$DST"
udpgso_bench_rx: wrong packet number! got 0, expected 100

This is because the packets is cleared after print.

Zhang Yunkai (3):
  selftests: net: udpgso_bench_rx: Fix verifty exceptions
  selftests: net: udpgso_bench_rx: Fix gsosize exceptions
  selftests: net: udpgso_bench_rx: Fix packet number exceptions

 tools/testing/selftests/net/udpgso_bench_rx.c | 45 +++++++++++++++++++++------
 1 file changed, 35 insertions(+), 10 deletions(-)

--
2.15.2
