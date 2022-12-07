Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17638645491
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiLGH1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGH1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:27:36 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF6B276;
        Tue,  6 Dec 2022 23:27:31 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NRplP6XBTz4y0vN;
        Wed,  7 Dec 2022 15:27:29 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl1.zte.com.cn with SMTP id 2B77RJwO026399;
        Wed, 7 Dec 2022 15:27:19 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Wed, 7 Dec 2022 15:27:22 +0800 (CST)
Date:   Wed, 7 Dec 2022 15:27:22 +0800 (CST)
X-Zmail-TransId: 2b046390405affffffffbd27def7
X-Mailer: Zmail v1.0
Message-ID: <202212071527223155626@zte.com.cn>
In-Reply-To: <20221205184742.0952fc75@kernel.org>
References: 20221205175314.0487527a@kernel.org,20221205184742.0952fc75@kernel.org
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <kuba@kernel.org>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tedheadster@gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBsaW51eC1uZXh0XSBuZXQ6IHJlY29yZCB0aW1lcyBvZiBuZXRkZXZfYnVkZ2V0IGV4aGF1c3RlZA==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B77RJwO026399
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 63904061.001 by FangMail milter!
X-FangMail-Envelope: 1670398049/4NRplP6XBTz4y0vN/63904061.001/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63904061.001/4NRplP6XBTz4y0vN
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Dec 2022 10:47:07 +0800 (CST) kuba@kernel.org wrote:
> But are you seeing actual performance wins in terms of throughput
> or latency? 

I did a test and see 7~8% of performance difference with small and big
netdev_budget. Detail:
1. machine
In qemu. CPU is QEMU TCG CPU version 2.5+.
2. kernel
Linux (none) 5.14.0-rc6+ #91 SMP Tue Dec 6 19:55:14 CST 2022 x86_64 GNU/Linux
3. test condition
Run 5 rt tasks to simulate workload, task is test.sh:
---
#!/bin/bash

while [ 1 ]
do
      ls  > /dev/null
done
---
4. test method
Use ping -f to flood.
# ping -f 192.168.1.201 -w 1800 

With netdev_buget is 500, and netdev_budget_usecs is 2000: 
497913 packets transmitted, 497779 received, 0% packet loss, time 1799992ms
rtt min/avg/max/mdev = 0.181/114.417/1915.343/246.098 ms, pipe 144, ipg/ewma 3.615/0.273 ms

With netdev_budget is 1, and netdev_budget_usecs is 2000: 
457530 packets transmitted, 457528 received, 0% packet loss, time 1799997ms
rtt min/avg/max/mdev = 0.180/123.287/1914.186/253.883 ms, pipe 147, ipg/ewma 3.934/0.301 ms

With small netdev_budget, avg latency increases 7%, packets transmitted
decreases 8%.

> Have you tried threaded NAPI? (find files called 'threaded' in sysfs)

Thanks, we had researched on threaded NAPI, much applaud for it!
But we think someone maynot use it because some kinds of reasons.
One is threaded NAPI is good for control, but maynot good for
throughput, especially for those who not care real-time too much.
Another reason is distribution kernel may too old to support
threaded NAPI?

>Well, we can't be sure if there's really nobody that uses them :(

As we still retain netdev_budget*, and there maybe some using it,
should it be improve? Netdev_budget* are sysctl for administrator,
when administrator adjust them, they may want to see the effect in
a direct or easy way. That's what this patch's purpose.
