Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671F51D5436
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgEOPUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:20:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56378 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727825AbgEOPUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589556017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GvjsS3e29gHaCC17oqlDDJSWYTuyGY6h8lvDFd/vxIw=;
        b=JQx63mMpD2UnUZ9uOSqFpHYK2G53z8u6YEsAcii/QnRVCv0jsjcm1lkPH+sIY6MoDN+0hv
        F9v/rrwFfe83LDsS2IGcjyb8Z6QG6OuKHUL7no1/qhqsKcjFs1W2WCP/ol5MSGDFiddQzj
        684KlY3ca5DRx9DsOb7tCYZ1jwtn39w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-r5WCTqEIO1eiQ3eNdBeffQ-1; Fri, 15 May 2020 11:20:15 -0400
X-MC-Unique: r5WCTqEIO1eiQ3eNdBeffQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5FB6189952E;
        Fri, 15 May 2020 15:20:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-95.rdu2.redhat.com [10.10.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05F396AD10;
        Fri, 15 May 2020 15:20:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200514062820.GC8564@lst.de>
References: <20200514062820.GC8564@lst.de> <20200513062649.2100053-1-hch@lst.de> <20200513062649.2100053-28-hch@lst.de> <20200513180058.GB2491@localhost.localdomain>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dhowells@redhat.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        linux-block@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 27/33] sctp: export sctp_setsockopt_bindx
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <129069.1589556002.1@warthog.procyon.org.uk>
Date:   Fri, 15 May 2020 16:20:02 +0100
Message-ID: <129070.1589556002@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> > The advantage on using kernel_setsockopt here is that sctp module will
> > only be loaded if dlm actually creates a SCTP socket.  With this
> > change, sctp will be loaded on setups that may not be actually using
> > it. It's a quite big module and might expose the system.
> 
> True.  Not that the intent is to kill kernel space callers of setsockopt,
> as I plan to remove the set_fs address space override used for it.

For getsockopt, does it make sense to have the core kernel load optval/optlen
into a buffer before calling the protocol driver?  Then the driver need not
see the userspace pointer at all.

Similar could be done for setsockopt - allocate a buffer of the size requested
by the user inside the kernel and pass it into the driver, then copy the data
back afterwards.

David

