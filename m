Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936AE6BD7B0
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 19:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCPSBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 14:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCPSBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 14:01:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26C65B41B
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 11:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678989653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qbEsnALNOSBxPiXGIwmunczWgV/dhcVYCQ7WT9nvyUY=;
        b=YDu/OlAZpA1JmxyjW6uhZfJcVDKBjBmi7KGFAV+3Srwn39HFP/R2Jc4QYDiH0/++vfkH2v
        uS8k1rnQFBvSXdTndixKHvQ5FWnk/sZoYvMWMsYQM8BmPnmOVtkG+yzXONMFNYSpV1ppeD
        /hVcR+Rk2uhTLYIX27agwiWBTbFDgMw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-kNgie8orP4CyP7VIozu2TQ-1; Thu, 16 Mar 2023 14:00:40 -0400
X-MC-Unique: kNgie8orP4CyP7VIozu2TQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 405F01C075B5;
        Thu, 16 Mar 2023 18:00:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AE75492B00;
        Thu, 16 Mar 2023 18:00:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZBNRysLdgZsfVaSj@casper.infradead.org>
References: <ZBNRysLdgZsfVaSj@casper.infradead.org> <20230316152618.711970-1-dhowells@redhat.com> <20230316152618.711970-3-dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH 02/28] Add a special allocator for staging netfs protocol to MSG_SPLICE_PAGES
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <809771.1678989636.1@warthog.procyon.org.uk>
Date:   Thu, 16 Mar 2023 18:00:36 +0000
Message-ID: <809772.1678989636@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> This feels a _lot_ like the page_frag allocator.  Can the two be
> unified?

Looks kind of similar.  I might well be able to use that instead.

David

