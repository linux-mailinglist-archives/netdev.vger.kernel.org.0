Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E036D26C9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjCaRiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjCaRh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:37:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA4D1EA16
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 10:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680284231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3uCQVEhe2fnq86iop6kxjBqus9BAmkIKRjZkI+ygfw=;
        b=QK5JKjNwt8YDw3kCc5rv9wdnqnuQf2nyq5FWOMuS4bWowWK8VFQaKRdqKhll9JcLtWR2L9
        Ox8sDvpqIi/+A5m+h82HVdaCT4ou7GazhJOFbarZSzpb14GGn1jdPlvlKV+fRbC2SehDWH
        z38YdO9qjyK/98YQuAVYIP35lYl61YM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-n8tWhk8bPYmGASeLJerjFw-1; Fri, 31 Mar 2023 13:37:07 -0400
X-MC-Unique: n8tWhk8bPYmGASeLJerjFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1D4F101A531;
        Fri, 31 Mar 2023 17:37:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B79C22166B33;
        Fri, 31 Mar 2023 17:37:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-34-dhowells@redhat.com>
References: <20230331160914.1608208-34-dhowells@redhat.com> <20230331160914.1608208-1-dhowells@redhat.com>
To:     Tom Herbert <tom@herbertland.com>, Tom Herbert <tom@quantonium.net>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
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
Subject: Test program for AF_KCM
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1614622.1680284224.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 31 Mar 2023 18:37:04 +0100
Message-ID: <1614623.1680284224@warthog.procyon.org.uk>
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

Hi Tom,

I found a test program for AF_KCM:

	https://gist.githubusercontent.com/peo3/fd0e266a3852d3422c08854aba96bff5/=
raw/98e02e120bd4b4bc5d499c4510e5879bb3a023d7/kcm-sample.c

I don't suppose you have a version that compiles?  It seems that the userl=
and
BPF API has changed.

Thanks,
David

