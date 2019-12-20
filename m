Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6D9127B9A
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 14:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfLTNWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 08:22:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727346AbfLTNWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 08:22:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576848128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XWOEMJRzHfCoOIjxfnwctEtzCgKyxPBwqnh864FSDEA=;
        b=BA3HaOJLZjbX2DN7gUb1Lx56UOc9G3NHadEKuCJPS2dWMuDhxlaPkr77rpxCGum8q5SoAd
        kZ+xJH0piff64mWJFch7SNNpc11k55KHPlGprDup36fl0r979h5Wpz7HC0xIIOv+fuCi5l
        W+C0kdWOqbxRsAH6umKZ/YC4IR0eV1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-CJDCsvXrOAGJ_LhbdTzg4Q-1; Fri, 20 Dec 2019 08:22:04 -0500
X-MC-Unique: CJDCsvXrOAGJ_LhbdTzg4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A0A28005BA;
        Fri, 20 Dec 2019 13:22:02 +0000 (UTC)
Received: from ovpn-204-204.brq.redhat.com (ovpn-204-204.brq.redhat.com [10.40.204.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A3B860BF3;
        Fri, 20 Dec 2019 13:21:59 +0000 (UTC)
Message-ID: <3bbe208c56d4b6cf3526f4957b19f87d695d5d0a.camel@redhat.com>
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Roman Mashak <mrv@mojatatu.com>
In-Reply-To: <vbfo8w42qt2.fsf@mellanox.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
         <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
         <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
         <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
         <vbfr2102swb.fsf@mellanox.com>
         <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
         <vbfpngk2r9a.fsf@mellanox.com> <vbfo8w42qt2.fsf@mellanox.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 20 Dec 2019 14:21:58 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Jamal and Vlad,

thanks a lot for sharing your thoughts.

On Thu, 2019-12-19 at 17:01 +0000, Vlad Buslov wrote:
> > > IMO that would be a cleaner fix give walk() is used for other
> > > operations and this is a core cls issue.
> > > 

[...]

> > So I guess the requirement now is for unlocked classifier to have sane
> > implementation of ops->walk() that doesn't assume >1 filters and
> > correctly handles the case when insertion of first filter after
> > classifier instance is created fails.

I tried forcing an error in matchall, and didn't observe this problem:

[root@f31 ~]# perf record -e probe:mall_change__return -agR -- tc filter add dev dam0 parent root matchall skip_sw action drop
RTNETLINK answers: Operation not supported
We have an error talking to the kernel
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 1.225 MB perf.data (1 samples) ]
[root@f31 ~]# perf script
tc 115241 [002] 19665.372130: probe:mall_change__return: (ffffffffc115f930 <- ffffffffb98a7266) ret=0xffffffa1
        ffffffffb9066790 kretprobe_trampoline+0x0 (vmlinux)
            7fa64c16cb77 __libc_sendmsg+0x17 (/usr/lib64/libc-2.30.so)

[root@f31 ~]# tc filter show dev dam0 
[root@f31 ~]#

and similar test can be also carried for the other classifiers
(on unpatched kernel), so it should be easy to understand if there are
other filter that show the same problem. 

> BTW another approach would be to extend ops with new callback
> delete_empty(), require unlocked implementation to define it and move
> functionality of tcf_proto_check_delete() there. Such approach would
> remove the need for (ab)using ops->walk() for this since internally
> in classifier implementation there is always a way to correctly verify
> that classifier instance is empty. Don't know which approach is better
> in this case.

I like the idea of using walk() only when filters are dumped, and handling
the check for empty filters on deletion with a separate callback. That
would allow de-refcounting the filter in the error path unconditionally
for   all classifiers, like old kernel was doing, unless the classifier
implements its own "check empty" function.

how does it sound?
thanks!
-- 
davide



