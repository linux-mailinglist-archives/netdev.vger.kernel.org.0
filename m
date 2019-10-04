Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D217CBEE0
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389760AbfJDPR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:17:29 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57584 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389378AbfJDPR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:17:29 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C058B4C0059;
        Fri,  4 Oct 2019 15:17:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 4 Oct
 2019 08:17:23 -0700
Subject: Re: [PATCH net-next] net: ipv6: fix listify ip6_rcv_finish in case of
 forwarding
To:     David Miller <davem@davemloft.net>, <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-sctp@vger.kernel.org>,
        <marcelo.leitner@gmail.com>, <nhorman@tuxdriver.com>,
        <brouer@redhat.com>, <dvyukov@google.com>,
        <syzkaller-bugs@googlegroups.com>
References: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
 <20190823.144250.2063544404229146484.davem@davemloft.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <3bda6dee-7b8b-1f50-b4ea-47857ca97279@solarflare.com>
Date:   Fri, 4 Oct 2019 16:17:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190823.144250.2063544404229146484.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24952.005
X-TM-AS-Result: No-2.177000-4.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHmLzc6AOD8DfHkpkyUphL9V447DNvw38Yd0WOKRkwsh9KE
        CfhYwuaGqgI39lWBXGAUEDo1iEscxd4V9K8RueK0A9lly13c/gEmKH/Kj46+VRQ/lwYCtWexa2B
        yQZcfaSeez3LtmC83o9pBtcKWt1N2oqn18XUssBWPR2u912hYROq6JaIt1QeicPafKCoXYH+i9X
        HgDvVgUQ/A2snAmapTvAKx+JIfqjGCWMXx8ovaCefOVcxjDhcwPcCXjNqUmkXCttcwYNipX/VTw
        0XgOy3awCzXHDVFEl2B4AlVArCKt5tkF5V3GvR6cBtTaYZDTyEQaVht4wZdeap9+7rsHqGXKW7D
        b5HSK2/ZYleOlkWn56UgMC6A1KHaUdNvZjjOj9C63BPMcrcQuXeYWV2RaAfD8VsfdwUmMsnAvpL
        E+mvX8g==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.177000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24952.005
X-MDID: 1570202248-rlK6pP-ULooE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/08/2019 22:42, David Miller wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Fri, 23 Aug 2019 19:33:03 +0800
>
>> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
>> listify ip_rcv_finish in case of forwarding") does for ipv4.
>>
>> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
>> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
>> trace was:
>  ...
>> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
>> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
>> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
>> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Applied, thanks.
Just noticed that this only went to net-next (and 5.4-rc1), when actually
 it's needed on all kernels back to 4.19 (per the first Fixes: tag).  The
 second Fixes: reference, 323ebb61e32b, merely enables syzbot to hit it on
 whatever hardware it has, but the bug was already there, and hittable on
 sfc NICs.
David, can this go to stable please?
