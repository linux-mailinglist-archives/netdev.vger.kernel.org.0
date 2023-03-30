Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1D96D091C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjC3PJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjC3PI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497F6C64D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680188853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=flEdophtYQM+tpSiaQIdRAJlRLOhJGfz1jgwJJ1BJnE=;
        b=RdwF3eRYjCT1dUzk77t5/ZIl0VitEAHhjGWCmNE2gk96EmOp6GWMzqf49hFEaMKrMS7zjG
        hzhtEaUTvfHRdF9AmjjpX74bTgvNkJh7Ad6jWaiS8ZRle+Tb0tWK45ayNG6ZKBYj55LuF3
        cjvm2a8fuG6kZyuGLqlsZ40q8cxXmTQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-dFQTAMfoPD2U4QyvYcJNIw-1; Thu, 30 Mar 2023 11:07:28 -0400
X-MC-Unique: dFQTAMfoPD2U4QyvYcJNIw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D419858297;
        Thu, 30 Mar 2023 15:07:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 938B4C15BA0;
        Thu, 30 Mar 2023 15:07:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <64259c7b2b327_21883920818@willemb.c.googlers.com.notmuch>
References: <64259c7b2b327_21883920818@willemb.c.googlers.com.notmuch> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-5-dhowells@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 04/48] net: Declare MSG_SPLICE_PAGES internal sendmsg() flag
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <854581.1680188845.1@warthog.procyon.org.uk>
Date:   Thu, 30 Mar 2023 16:07:25 +0100
Message-ID: <854582.1680188845@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> No need to modify __sys_sendmmsg explicitly, as it ends up calling
> __sys_sendmsg?
> 
> Also, sendpage does this flags masking in the internal sock_FUNC
> helpers rather than __sys_FUNC. Might be preferable.

I was wondering whether other flags, such as MSG_BATCH should be added to the
list.  Is it bad if userspace sets that in sendmsg()?  AF_KCM, at least, looks
at it.

David

