Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474F1434377
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 04:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhJTCUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 22:20:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhJTCU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 22:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634696293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D74GYl4Q75+oXj/aMCjO7YTPXeKQjd+IcbtXAGLf308=;
        b=Bs2r5YFJXMOX61pXNAEqEnnG1ilWnSguIV8DwERM8Ui4u6QEm0fbH07Fk03l2H7QT7Nz/L
        IwS8bh7OOFq4SF9eWN7qw3ae07Y1g4t35BUABs2g3RRgp1YRhz3dGLJCsb2x52krb6UV5l
        b/s2yWCaciS625SLcSsN74CSkvj0kSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-8Kxz5JYxMzONNvmCRHlvSQ-1; Tue, 19 Oct 2021 22:18:10 -0400
X-MC-Unique: 8Kxz5JYxMzONNvmCRHlvSQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F264108088A;
        Wed, 20 Oct 2021 02:18:07 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 22A5D103BAC7;
        Wed, 20 Oct 2021 02:17:46 +0000 (UTC)
Date:   Wed, 20 Oct 2021 10:17:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     Quanyang Wang <quanyang.wang@windriver.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Message-ID: <YW98RTBdzqin+9Ko@T590>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590>
 <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590>
 <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YW78AohHqgqM9Cuw@blackbook>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 07:10:26PM +0200, Michal Koutný wrote:
> Hi.
> 
> On Tue, Oct 19, 2021 at 06:41:14PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
> > So I add 2 "Fixes tags" here to indicate that 2 commits introduce two
> > different issues.
> 
> AFAIU, both the changes are needed to cause the leak, a single patch
> alone won't cause the issue. Is that correct? (Perhaps not as I realize,
> see below.)
> 
> But on second thought, the problem is the missing percpu_ref_exit() in
> the (root) cgroup release path and percpu counter would allocate the
> percpu_count_ptr anyway, so 4bfc0bb2c60e is only making the leak more
> visible. Is this correct?
> 
> I agree the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of
> percpu_ref in fast path") alone did nothing wrong.

If only precpu_ref data is leaked, it is fine to add "Fixes: 2b0d3d3e4fcf",
I thought cgroup_bpf_release() needs to release more for root cgroup, but
looks not true.


Thanks,
Ming

