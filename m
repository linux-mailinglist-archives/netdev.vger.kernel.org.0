Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21481ABEA0
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 12:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505862AbgDPK7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 06:59:13 -0400
Received: from regular1.263xmail.com ([211.150.70.199]:35094 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505830AbgDPK6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 06:58:51 -0400
Received: from localhost (unknown [192.168.167.13])
        by regular1.263xmail.com (Postfix) with ESMTP id 2D704405;
        Thu, 16 Apr 2020 18:46:04 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from [172.16.12.20] (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P18326T139707671365376S1587033963544784_;
        Thu, 16 Apr 2020 18:46:04 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <a98a3eaf7f26672e4e75f7610d3b21fb>
X-RL-SENDER: david.wu@rock-chips.com
X-SENDER: wdc@rock-chips.com
X-LOGIN-NAME: david.wu@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
X-System-Flag: 0
Subject: Re: [RFC,PATCH 2/2] net: stmmac: Change the tx clean lock
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200324093828.30019-1-david.wu@rock-chips.com>
 <20200324093828.30019-2-david.wu@rock-chips.com>
 <BN8PR12MB32665A2AA9302F64C1F4871BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   David Wu <david.wu@rock-chips.com>
Message-ID: <0031cd20-5131-b9d7-0a8e-f72f6c2de486@rock-chips.com>
Date:   Thu, 16 Apr 2020 18:46:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB32665A2AA9302F64C1F4871BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

 From the test I did, there will be some improvement, an improvement of 
tens Mbits/sec.

Before patch:
# iperf -c 192.168.1.102 -i 1 -t 10 -w 300K -u -b 1000M
------------------------------------------------------------
Client connecting to 192.168.1.102, UDP port 5001
Sending 1470 byte datagrams, IPG target: 11.76 us (kalman adjust)
UDP buffer size:  600 KByte (WARNING: requested  300 KByte)
------------------------------------------------------------
[  3] local 192.168.1.103 port 45018 connected with 192.168.1.102 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec   103 MBytes   862 Mbits/sec
[  3]  1.0- 2.0 sec   104 MBytes   868 Mbits/sec
[  3]  2.0- 3.0 sec   104 MBytes   869 Mbits/sec
[  3]  3.0- 4.0 sec   104 MBytes   869 Mbits/sec
[  3]  4.0- 5.0 sec   104 MBytes   870 Mbits/sec
[  3]  5.0- 6.0 sec   104 MBytes   869 Mbits/sec
[  3]  6.0- 7.0 sec   104 MBytes   869 Mbits/sec
[  3]  7.0- 8.0 sec   104 MBytes   870 Mbits/sec
[  3]  8.0- 9.0 sec   104 MBytes   871 Mbits/sec
[  3]  0.0-10.0 sec  1.01 GBytes   869 Mbits/sec
[  3] Sent 738834 datagrams


After patch:
# iperf -c 192.168.1.102 -i 1 -t 10 -w 300K -u -b 1000M
------------------------------------------------------------
Client connecting to 192.168.1.102, UDP port 5001
Sending 1470 byte datagrams, IPG target: 11.76 us (kalman adjust)
UDP buffer size:  600 KByte (WARNING: requested  300 KByte)
------------------------------------------------------------
[  3] local 192.168.1.103 port 35654 connected with 192.168.1.102 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec   114 MBytes   953 Mbits/sec
[  3]  1.0- 2.0 sec   114 MBytes   956 Mbits/sec
[  3]  2.0- 3.0 sec   115 MBytes   962 Mbits/sec
[  3]  3.0- 4.0 sec   114 MBytes   955 Mbits/sec
[  3]  4.0- 5.0 sec   114 MBytes   957 Mbits/sec
[  3]  5.0- 6.0 sec   114 MBytes   957 Mbits/sec
[  3]  6.0- 7.0 sec   114 MBytes   955 Mbits/sec
[  3]  7.0- 8.0 sec   114 MBytes   956 Mbits/sec
[  3]  8.0- 9.0 sec   114 MBytes   955 Mbits/sec
[  3]  0.0- 9.9 sec  1.10 GBytes   957 Mbits/sec
[  3] Sent 804442 datagrams


ÔÚ 2020/4/13 ÏÂÎç10:31, Jose Abreu Ð´µÀ:
> From: David Wu <david.wu@rock-chips.com>
> Date: Mar/24/2020, 09:38:28 (UTC+00:00)
> 
>> At tx clean, use a frozen queue instead of blocking
>> the current queue, could still queue skb, which improve
>> performance.
> 
> Please provide performance improvement numbers.
> 
> ---
> Thanks,
> Jose Miguel Abreu
> 
> 
> 
> 


