Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CAE6CFFFD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjC3Jmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjC3Jm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:42:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3266D7D87
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680169297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mdeKPljJ04L5Zu/e3M2HbmrNI2/PIT36ixWTFqAG+bc=;
        b=d6scwfFDJm0FY377uZW/GE5YQUCslEKL56TfB7BKmfhFgPfqB/XxpJ4iumrmqH/brr4qPa
        7wbzQZNlRlENJ70mhAuhExOj5Oni8VP3j0iCV74th5R8WWkA17yA7Bhm1bdPyuIk++Ig8m
        3Q9rFGaxdzhrA279KvLEqm3Gm2Ede2k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-iTWDHOayP72Oh1RXlrE68w-1; Thu, 30 Mar 2023 05:41:21 -0400
X-MC-Unique: iTWDHOayP72Oh1RXlrE68w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3986185A792;
        Thu, 30 Mar 2023 09:41:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4032492C3E;
        Thu, 30 Mar 2023 09:41:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com>
References: <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-41-dhowells@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <778589.1680169277.1@warthog.procyon.org.uk>
Date:   Thu, 30 Mar 2023 10:41:17 +0100
Message-ID: <778590.1680169277@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuck Lever III <chuck.lever@oracle.com> wrote:

> > +	if (ret > 0)
> > +		*sentp = ret;

Should that be:

		*sentp = ret - sizeof(marker);

David

