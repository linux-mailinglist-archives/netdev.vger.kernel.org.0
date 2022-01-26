Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C29949C200
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbiAZDSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:18:16 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:30305 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237038AbiAZDSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:18:07 -0500
Received: from kwepemi500001.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Jk85y4wvyzbkLb;
        Wed, 26 Jan 2022 11:17:10 +0800 (CST)
Received: from kwepeml500002.china.huawei.com (7.221.188.128) by
 kwepemi500001.china.huawei.com (7.221.188.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 26 Jan 2022 11:18:00 +0800
Received: from huawei.com (10.175.104.82) by kwepeml500002.china.huawei.com
 (7.221.188.128) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 26 Jan
 2022 11:18:00 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>
CC:     <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 4.19 0/1] Fix UBSAN: undefined-behaviour in maybe_deliver
Date:   Wed, 26 Jan 2022 11:36:38 +0800
Message-ID: <20220126033639.909340-1-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepeml500002.china.huawei.com (7.221.188.128)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a syzkaller problem for Linux 4.19 last for over 1 year:
https://www.syzkaller.appspot.com/bug?id=288ae4752bb930c26369d675316de0310264ee34

Mainline patch 7d850abd5f4e(net: bridge: add support for port isolation)
introduces the BR_ISOLATED feature, a pair of ports with the BR_ISOLATED
option set cannot communicate with each other.
This feature applies only to ingress flow, not egress flow. However, the
function br_skb_isolated that checks if an interface is isolated will be
used not only for the ingress path, but also for the egress path.
Since Linux-4.19  not merge the mainline patch fd65e5a95d0838(net: bridge:
clear bridge's private skb space on xmit), the value of skb->cb is unde-
fined because it is not initialized. Therefore, checking 
BR_INPUT_SKB_CB(skb)->src_port_isolated on the egress path will access an
undefined value, resulting in an error in the judgment of br_skb_isolated.
UBSAN triggers an alarm by finding undefined
BR_INPUT_SKB_CB(skb)->src_port_isolated.
So cherry-pick mainline patch fd65e5a95d0838(net: bridge: clear bridge's
private skb space on xmit) to Linux 4.19 to fix it.

Nikolay Aleksandrov (1):
  net: bridge: clear bridge's private skb space on xmit

 net/bridge/br_device.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.25.1

