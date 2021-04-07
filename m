Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FB83575C8
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356053AbhDGUUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:20:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346258AbhDGUUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617826820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLJvdPFUIJ5ny5ARwp+JcVCf2mi3H4Cm9mgG+8OeioY=;
        b=Y1HUqiWNikdqNJprpoaJYPb60asaD9zirQ1O8P8CRuySgwGEchN7XELom7ZEVdjuOUV4jE
        3TWG5UrVqEm9yuKwJfI6a78DB/ha9FiW+rN8Uj9UQwd9YnjAc0FooUoVBWLFkdaCmbeZZa
        e/q0Zcp+tX7q91KzqjB31PQcwj3w1u0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-DsyDga9MN9a9jyUCfVov6Q-1; Wed, 07 Apr 2021 16:20:16 -0400
X-MC-Unique: DsyDga9MN9a9jyUCfVov6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54A0E91272;
        Wed,  7 Apr 2021 20:20:14 +0000 (UTC)
Received: from [10.40.193.103] (unknown [10.40.193.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F7B519CAD;
        Wed,  7 Apr 2021 20:20:09 +0000 (UTC)
Message-ID: <4396d0b86d66afa1d3211403b48a15a4d0a03e55.camel@redhat.com>
Subject: Re: [PATCH] net: sched: Fix potential infinite loop
From:   Davide Caratti <dcaratti@redhat.com>
To:     Colin King <colin.king@canonical.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210407163808.499027-1-colin.king@canonical.com>
References: <20210407163808.499027-1-colin.king@canonical.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 07 Apr 2021 22:20:08 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Colin, and thanks for your patch!

On Wed, 2021-04-07 at 17:38 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The for-loop iterates with a u16 loop counter idx and compares this
> with the loop upper limit of q->flows_cnt that is a u32 type.

the value of 'flows_cnt' has 65535 as an upper bound in the ->init()
function, so it should be safe to use an u16 for 'idx'. (BTW, the
infinite loop loop was a real thing, see [1] :) ).

> There is a potential infinite loop if q->flows_cnt is larger than
> the u8 loop counter.

(u16 loop counter, IIUC)

>  Fix this by making the loop counter the same
> type as q->flows_cnt.

the same 'for' loop is in fq_pie_init() and fq_pie_reset(): so, in my
opinion just changing fq_pie_timer() to fix an infinite loop is not very
useful: 'idx' is also used as an index for q->flows[], that's allocated
in [2]. Maybe (but I might be wrong) just allowing bigger values might
potentially cause other covscan warnings. WDYT?

> Addresses-Coverity: ("Infinite loop")
> Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

thanks!
-- 
davide


[1] https://lore.kernel.org/netdev/416eb03a8ca70b5dfb5e882e2752b7fc13c42f92.1590537338.git.dcaratti@redhat.com/
[2] https://elixir.bootlin.com/linux/latest/source/net/sched/sch_fq_pie.c#L417


