Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0A76CEBFC
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjC2Onq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjC2OnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:43:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF7265A6
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680100784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eOGvCBK3xTc7UhN8iQW8f99rBt5fCj0lar0/GGKSAUo=;
        b=aP124Yejpz1QELZiLro/EoDC2jD7s9HnnAl1GIOiy/RsOvZXFO3ybz5Yh6fxbW4ey+y2aZ
        6hq3Hr7dlkjMA08ujg0U2ONMJftq3Xwc57iics6EwU2G9xzSqwgZbHhlmzxxLfbsFWI7Y2
        6UIVQ8ic7CsDllaCdKrqKswv1UTDazo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-OX_M3mnhOyOLIjTwhOpgsw-1; Wed, 29 Mar 2023 10:39:40 -0400
X-MC-Unique: OX_M3mnhOyOLIjTwhOpgsw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52F783C10ED2;
        Wed, 29 Mar 2023 14:39:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 900FA2166B33;
        Wed, 29 Mar 2023 14:39:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <e128356a-f56f-4c02-7437-dfea38e4194b@suse.de>
References: <e128356a-f56f-4c02-7437-dfea38e4194b@suse.de> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-49-dhowells@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
cc:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, linux-afs@lists.infradead.org,
        rds-devel@oss.oracle.com, linux-x25@vger.kernel.org,
        dccp@vger.kernel.org, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        linux-wpan@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-hams@vger.kernel.org,
        mptcp@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
        Chuck Lever III <chuck.lever@oracle.com>,
        tipc-discussion@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bpf@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v2 48/48] sock: Remove ->sendpage*() in favour of sendmsg(MSG_SPLICE_PAGES)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <518630.1680100773.1@warthog.procyon.org.uk>
Date:   Wed, 29 Mar 2023 15:39:33 +0100
Message-ID: <518631.1680100773@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hannes Reinecke <hare@suse.de> wrote:

> > [!] Note: This is a work in progress.  At the moment, some things won't
> >      build if this patch is applied.  nvme, kcm, smc, tls.

Actually, that needs updating.  nvme and smc now build.

> Weelll ... what happens to consumers of kernel_sendpage()?
> (Let's call them nvme ...)
> Should they be moved over, too?

Patch 42 should address NVMe, I think.  I can't test it, though, as I don't
have hardware.

There should be no callers of kernel_sendmsg() by the end of this patchset,
and the only remaining implementors of sendpage are Chelsio-TLS, AF_TLS and
AF_KCM, which as stated in the cover, aren't yet converted and won't build.

> Or what is the general consensus here?
> 
> (And what do we do with TLS? It does have a ->sendpage() version, too ...)

I know.  There are three things left that I need to tackle, but I'd like to
get opinions on some of the other bits and I might need some help with AF_TLS
and AF_KCM.

That said, should I just remove tls_sw_do_sendpage() since presumably the data
is going to get copied(?) and encrypted and the source pages aren't going to
be held onto?

David

