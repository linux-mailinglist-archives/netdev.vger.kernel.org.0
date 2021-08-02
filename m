Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76F93DE144
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 23:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhHBVLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 17:11:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:43924 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbhHBVLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 17:11:20 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mAfDB-000GxW-Na; Mon, 02 Aug 2021 23:11:04 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mAfDB-000IKM-7H; Mon, 02 Aug 2021 23:11:01 +0200
Subject: Re: [PATCH net-next 1/2] net/sched: sch_ingress: Support clsact
 egress mini-Qdisc option
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>, ast@kernel.org,
        john.fastabend@gmail.com
References: <1931ca440b47344fe357d5438aeab4b439943d10.1627936393.git.peilin.ye@bytedance.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <672e6f13-bf58-d542-6712-e6f803286373@iogearbox.net>
Date:   Mon, 2 Aug 2021 23:10:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1931ca440b47344fe357d5438aeab4b439943d10.1627936393.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26251/Mon Aug  2 10:18:34 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 10:49 PM, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> If the ingress Qdisc is in use, currently it is not possible to add
> another clsact egress mini-Qdisc to the same device without taking down
> the ingress Qdisc, since both sch_ingress and sch_clsact use the same
> handle (0xFFFF0000).
> 
> Add a "change" option for sch_ingress, so that users can enable or disable
> a clsact egress mini-Qdisc, without suffering from downtime:
> 
>      $ tc qdisc add dev eth0 ingress
>      $ tc qdisc change dev eth0 ingress clsact-on
> 
> Then users can add filters to the egress mini-Qdisc as usual:
> 
>      $ tc filter add dev eth0 egress protocol ip prio 10 \
> 	    matchall action skbmod swap mac
> 
> Deleting the ingress Qdisc removes the egress mini-Qdisc as well.  To
> remove egress mini-Qdisc only, use:
> 
>      $ tc qdisc change dev eth0 ingress clsact-off
> 
> Finally, if the egress mini-Qdisc is enabled, the "show" command will
> print out a "clsact" flag to indicate it:
> 
>      $ tc qdisc show ingress
>      qdisc ingress ffff: dev eth0 parent ffff:fff1 ----------------
>      $ tc qdisc change dev eth0 ingress clsact-on
>      $ tc qdisc show ingress
>      qdisc ingress ffff: dev eth0 parent ffff:fff1 ---------------- clsact
> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

NAK, just use clsact qdisc in the first place which has both ingress and egress
support instead of adding such hack. You already need to change your scripts for
clsact-on, so just swap 'tc qdisc add dev eth0 ingress' to 'tc qdisc add dev eth0
clsact' w/o needing to change kernel.

Thanks,
Daniel
