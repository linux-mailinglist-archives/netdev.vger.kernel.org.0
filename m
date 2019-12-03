Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC0511059C
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfLCT6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:58:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfLCT6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:58:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A599C1510CE14;
        Tue,  3 Dec 2019 11:58:30 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:58:30 -0800 (PST)
Message-Id: <20191203.115830.1630044375757536670.davem@davemloft.net>
To:     komachi.yoshiki@gmail.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] cls_flower: Fix the behavior using port ranges
 with hw-offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203104012.59113-1-komachi.yoshiki@gmail.com>
References: <20191203104012.59113-1-komachi.yoshiki@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:58:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshiki Komachi <komachi.yoshiki@gmail.com>
Date: Tue,  3 Dec 2019 19:40:12 +0900

> The recent commit 5c72299fba9d ("net: sched: cls_flower: Classify
> packets using port ranges") had added filtering based on port ranges
> to tc flower. However the commit missed necessary changes in hw-offload
> code, so the feature gave rise to generating incorrect offloaded flow
> keys in NIC.
> 
> One more detailed example is below:
> 
> $ tc qdisc add dev eth0 ingress
> $ tc filter add dev eth0 ingress protocol ip flower ip_proto tcp \
>   dst_port 100-200 action drop
> 
> With the setup above, an exact match filter with dst_port == 0 will be
> installed in NIC by hw-offload. IOW, the NIC will have a rule which is
> equivalent to the following one.
> 
> $ tc qdisc add dev eth0 ingress
> $ tc filter add dev eth0 ingress protocol ip flower ip_proto tcp \
>   dst_port 0 action drop
> 
> The behavior was caused by the flow dissector which extracts packet
> data into the flow key in the tc flower. More specifically, regardless
> of exact match or specified port ranges, fl_init_dissector() set the
> FLOW_DISSECTOR_KEY_PORTS flag in struct flow_dissector to extract port
> numbers from skb in skb_flow_dissect() called by fl_classify(). Note
> that device drivers received the same struct flow_dissector object as
> used in skb_flow_dissect(). Thus, offloaded drivers could not identify
> which of these is used because the FLOW_DISSECTOR_KEY_PORTS flag was
> set to struct flow_dissector in either case.
> 
> This patch adds the new FLOW_DISSECTOR_KEY_PORTS_RANGE flag and the new
> tp_range field in struct fl_flow_key to recognize which filters are applied
> to offloaded drivers. At this point, when filters based on port ranges
> passed to drivers, drivers return the EOPNOTSUPP error because they do
> not support the feature (the newly created FLOW_DISSECTOR_KEY_PORTS_RANGE
> flag).
> 
> Fixes: 5c72299fba9d ("net: sched: cls_flower: Classify packets using port ranges")
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>

Applied and queued up for -stable, thank you.
