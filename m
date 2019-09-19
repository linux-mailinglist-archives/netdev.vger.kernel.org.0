Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E17B879A
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 00:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405507AbfISWtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 18:49:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41356 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393807AbfISWtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 18:49:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so3218089pfh.8
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 15:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mkRfhk4kogjc5mixE4IKVRJwLntrCBrUYtEKBXpZRRQ=;
        b=OjU70/g+vU9pRpMt4otXVXgpAQSF1q5grQPhY+xI0Oie1wySrexapNx/36pnFOBYmx
         2mlLkffngtmer8aFvf3cKI+dNbZrJ6V1IJk0bnXftr0fb+QRTDlNg4scHfzE2+ebzPjv
         OSaFwG5pQr/NCuPrLiPgFfDfjZBnsjcZCfS4rGUo/9eaIGrry/opK92yIC/Dnf6Lv6Wz
         9qbbEC6VtWv5tiHuOXxH5wBHFqXzbJDTuYenpihzD4400qETo40TA+iH6XpGKhpRMpOl
         I77eXy7Ipq/N/9S2d88mgEOr37hgVE+1s9BNHje1/BLFMZjufBH0LYprbHoNIM8zFqWy
         ag5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mkRfhk4kogjc5mixE4IKVRJwLntrCBrUYtEKBXpZRRQ=;
        b=h9LH6EaSS5j92cRETn4RfqwYUUCVMCAhk+5j+0gFKECiUJgmS6JZxfV1cBRf5+K4Hh
         S1c47pNzM1mLPQBygU+ZpXc8EWEZItSq3M0DzL7gRmheVKx0vz4T1VfQIL0uWjLf4Ym6
         xtUMv5I8EWvBtxqM3Xvaf92hlDBlBZXjHU/OzEUvB1nM6RC0EAKf3h7Z/+hZRQlbLJ6G
         VI8BdbviJ27bHLauUUUc4/rpXXMPbZZQ0yqzpeWrglF1iLHZaQMEO7w1nZ1sQRQhTJAP
         Mj1g5iAQfLRP0Dgnd9DmYVY2pv2Dnm9byV7Dua862KzbSzLq+Umy1BNLCqAP2kx9uF0S
         QpsQ==
X-Gm-Message-State: APjAAAXtG/iPTiNcH5+LQzJ+BlxPk/uB4PwHWTLZLdgI+XWdigpLh6mE
        bsCPcYe/umnYUBFAFVVjcsQ=
X-Google-Smtp-Source: APXvYqyd7M4HG2QehODhYGm6h58avGnx3P+LYnTuaAXx/RugSbLdVb6Pcp+gDeksuqOSJmSe+rdESQ==
X-Received: by 2002:a65:5543:: with SMTP id t3mr11478866pgr.242.1568933385990;
        Thu, 19 Sep 2019 15:49:45 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 30sm31138pjk.25.2019.09.19.15.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 15:49:45 -0700 (PDT)
Subject: Re: [PATCH net v2 1/3] net: sched: sch_htb: don't call qdisc_put()
 while holding tree lock
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net
References: <20190919201438.2383-1-vladbu@mellanox.com>
 <20190919201438.2383-2-vladbu@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <66e68933-a553-e078-b92b-6f629c740328@gmail.com>
Date:   Thu, 19 Sep 2019 15:49:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919201438.2383-2-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/19 1:14 PM, Vlad Buslov wrote:
> Recent changes that removed rtnl dependency from rules update path of tc
> also made tcf_block_put() function sleeping. This function is called from
> ops->destroy() of several Qdisc implementations, which in turn is called by
> qdisc_put(). Some Qdiscs call qdisc_put() while holding sch tree spinlock,
> which results sleeping-while-atomic BUG.
> 


Note that calling qdisc_put() while holding sch tree lock can also
trigger deadlocks.

For example sch_pie.c has a del_timer_sync() in pie_destroy(),
while the pie_timer() timer handler acquires the root_lock.

(there are other cases like that, SFQ for example)

