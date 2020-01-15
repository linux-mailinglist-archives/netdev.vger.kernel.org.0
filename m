Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C877613BC2E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 10:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgAOJO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 04:14:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36333 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729067AbgAOJOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 04:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579079664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S/TQNTrlWJoEcVej5gvUo106Sug5eqRN3gxypFSR12I=;
        b=LbcTOpLPrzx2jY450NIO6yVdTSqVBlkRr181saxiVdxpyDH+yYfLGGjBqKJe4L9Nozb8YU
        /L9SRnlF3du+HHe8pgwV2MdomzUb92Nw0h1RcIKAounbfYTv1gqYvoZKJZ64K5wnC1jqS3
        Ra0nBi7KQIB+ylXV4Ow7MiNzwJKKcKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-62grvez_Owyt1U87IrV5iA-1; Wed, 15 Jan 2020 04:14:22 -0500
X-MC-Unique: 62grvez_Owyt1U87IrV5iA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 922898024CF;
        Wed, 15 Jan 2020 09:14:21 +0000 (UTC)
Received: from ovpn-205-91.brq.redhat.com (ovpn-205-91.brq.redhat.com [10.40.205.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F0F65D9C9;
        Wed, 15 Jan 2020 09:14:19 +0000 (UTC)
Message-ID: <7b6aad5de9b62323f0a8b24ce2d5c7d5adcd89b4.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: act_ife: initalize ife->metalist earlier
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
In-Reply-To: <20200114215128.87537-1-edumazet@google.com>
References: <20200114215128.87537-1-edumazet@google.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 15 Jan 2020 10:14:19 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-01-14 at 13:51 -0800, Eric Dumazet wrote:
> It seems better to init ife->metalist earlier in tcf_ife_init()
> to avoid the following crash :

hello Eric, and thanks for the patch.

If I well understand the problem, we have

_tcf_ife_cleanup()

that does dereference of NULL ife->metalist,
because it has not yet initialized by tcf_ife_init(). This happened
probably because the control action was not valid (hence the Fixes:tag):
so, tcf_ife_init() jumped to the error path before doing INIT_LIST_HEAD().

I applied your patch to my tree, and I see this:

net/sched/act_ife.c: In function 'tcf_ife_init':
net/sched/act_ife.c:533:3: warning: 'ife' may be used uninitialized in
this function [-Wmaybe-uninitialized]
   INIT_LIST_HEAD(&ife->metalist);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

And I think the warning is telling us a real problem, because

        ife = to_ife(*a);

is done below the if (!exists) { } statement where you are dereferencing
'ife'.

I think the proper fix should do one of these two things:
1) ensure that 'ife' is a valid pointer in the INIT_LIST_HEAD()
2) leave tcf_ife_init() as is, and fix the priblem in _tcf_ife_clenup() by
proper checking the value of ife->metalist  (which should be NULL in the
error path, because tcf_idr_create() does kzalloc() [1].
WDYT?

thanks!
-- 
davide

[1] https://elixir.bootlin.com/linux/latest/source/net/sched/act_api.c#L404


