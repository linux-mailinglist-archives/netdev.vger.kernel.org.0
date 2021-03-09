Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFFA33215E
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCIIyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:54:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhCIIxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:53:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615280026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cN+nXpGwHGDUEeHWvz6UYQPAvph7CIF9zvvGq9BwI0M=;
        b=d8EQ1tnTTPgSJZHqw7XqcrI2P9HqMVs4Giu/q7feTNkguybP/GtXmg2k38Ipxx+Tbo3LVL
        zIpx2tVqdV+TV90Qqoh+TdW53izaxaQIBwu6TOWyLS3kTDTJXxQHqCemFW7xf6su4Bmqi6
        ghldyI+65Of80WiQDcYLRMq+IFVsNxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-ADvZL0ZWP5OGJxoXBE2dqw-1; Tue, 09 Mar 2021 03:53:42 -0500
X-MC-Unique: ADvZL0ZWP5OGJxoXBE2dqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FAC526862;
        Tue,  9 Mar 2021 08:53:40 +0000 (UTC)
Received: from [10.40.192.32] (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B585161F55;
        Tue,  9 Mar 2021 08:53:38 +0000 (UTC)
Message-ID: <07afbd8d9a76f3c0f0a0eb01759118a0c9e966a3.camel@redhat.com>
Subject: Re: [PATCH] net/sched: act_pedit: fix a NULL pointer deref in
 tcf_pedit_init
From:   Davide Caratti <dcaratti@redhat.com>
To:     zhudi <zhudi21@huawei.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rose.chen@huawei.com
In-Reply-To: <20210309034736.8656-1-zhudi21@huawei.com>
References: <20210309034736.8656-1-zhudi21@huawei.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 09 Mar 2021 09:53:37 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello, thanks for the patch!

On Tue, 2021-03-09 at 11:47 +0800, zhudi wrote:
> From: Di Zhu <zhudi21@huawei.com>
> 
> when we use syzkaller to fuzz-test our kernel, one NULL pointer dereference
> BUG happened:
> 
> Write of size 96 at addr 0000000000000010 by task syz-executor.0/22376
> ==================================================================
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> PGD 80000001dc1a9067 P4D 80000001dc1a9067 PUD 1a32b5067 PMD 0
> [...]
> Call Trace
> memcpy  include/linux/string.h:345 [inline]
> tcf_pedit_init+0x7b4/0xa10 net/sched/act_pedit.c:232
> tcf_action_init_1+0x59b/0x730  net/sched/act_api.c:920
> tcf_action_init+0x1ef/0x320  net/sched/act_api.c:975
> tcf_action_add+0xd2/0x270  net/sched/act_api.c:1360
> tc_ctl_action+0x267/0x290  net/sched/act_api.c:1412
> [...]
> 
> The root cause is that we use kmalloc() to allocate mem space for
> keys without checking if the ksize is 0. 

actually Linux does this:

173         parm = nla_data(pattr);
174         if (!parm->nkeys) {
175                 NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
176                 return -EINVAL;
177         }
178         ksize = parm->nkeys * sizeof(struct tc_pedit_key);
179         if (nla_len(pattr) < sizeof(*parm) + ksize) {
180                 NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
181                 return -EINVAL;
182         }

maybe it's not sufficient? If so, we can add something here. I'd prefer
to disallow inserting pedit actions with p->tcfp_nkeys equal to zero,
because they are going to trigger a WARN(1) in the traffic path (see
tcf_pedit_act() at the bottom).

Then, we can also remove all the tests on the positiveness of tcfp_nkeys
and the one you removed with your patch. WDYT?

thanks,
-- 
davide

