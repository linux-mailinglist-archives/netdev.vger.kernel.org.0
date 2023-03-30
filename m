Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6966CFBE5
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjC3GtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjC3GtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:49:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D9219F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680158910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DALHbgeFEf+za91SMnDqIHwqs2Pkttr/jtZwkTUdNi4=;
        b=JiiXzCpi6rVVNIrodSWlB4xabesLQHrw/NSaMNaPl5EivWP8QBriGs2vyjtkdqRgy3kyds
        5GxQ4ZO7krEqA3ix4aVjK981yAN0TSQ1utsIlRsusNuPv0YStkTWAgoJS8PyuojKlLgAOL
        z7ST7ifovnYXuWwbMkh/qUH0eEBaLqc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-tJaJ6MZVMQmBqT7ETyJKHQ-1; Thu, 30 Mar 2023 02:48:26 -0400
X-MC-Unique: tJaJ6MZVMQmBqT7ETyJKHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43EC83C0ED71;
        Thu, 30 Mar 2023 06:48:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0F2B14171BB;
        Thu, 30 Mar 2023 06:48:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <7f7947d6-2a03-688b-dc5e-3887553f0106@redhat.com>
References: <7f7947d6-2a03-688b-dc5e-3887553f0106@redhat.com> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-38-dhowells@redhat.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [RFC PATCH v2 37/48] ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <709551.1680158901.1@warthog.procyon.org.uk>
Date:   Thu, 30 Mar 2023 07:48:21 +0100
Message-ID: <709552.1680158901@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiubo Li <xiubli@redhat.com> wrote:

> BTW, will this two patch depend on the others in this patch series ?

Yes.  You'll need patches that affect TCP at least so that TCP supports
MSG_SPLICE_PAGES, so 04-08 and perhaps 09.  It's also on top of the patches
that remove ITER_PIPE on my iov-extract branch, but I don't think that should
affect you.

David

