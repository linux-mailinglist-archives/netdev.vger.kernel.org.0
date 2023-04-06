Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447D16D9266
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbjDFJNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbjDFJN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:13:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0D47A87
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680772345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sv2PpChimMYumCFtZaOaAxih1ECUzoRlTNbMO8Dqb/8=;
        b=CMx9dd82lwO2xDRwp8QSHHckYfDPR322XeRMy3dsjzyOQIVbdfuRSeVI2RlPZzMsl5lu2q
        lJ1d44w9NIU3Q0DT+9FtuAjV8RWJ+bUBLO9nYXvvGRuNlplT0GG74Q3IHeTVHkRT2jILar
        npgtSMN8YqeRSJK7G+6FUDrWb7K31so=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-bbJHhxB2MTulRR-9lYLWOw-1; Thu, 06 Apr 2023 05:12:22 -0400
X-MC-Unique: bbJHhxB2MTulRR-9lYLWOw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FBCA38123B9;
        Thu,  6 Apr 2023 09:12:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84D22492C14;
        Thu,  6 Apr 2023 09:12:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230405191915.041c2834@kernel.org>
References: <20230405191915.041c2834@kernel.org> <20230405165339.3468808-1-dhowells@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH net-next v4 00/20] splice, net: Replace sendpage with sendmsg(MSG_SPLICE_PAGES), part 1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3629143.1680772339.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 06 Apr 2023 10:12:19 +0100
Message-ID: <3629144.1680772339@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> Thanks for splitting off a smaller series!
> My day is out of hours so just a trivial comment, in case kbuild bot
> hasn't pinged you - this appears to break the build on the relatively
> recently added page_frag_cache in google's vNIC (gve).

Yep.  I've just been fixing that up.

I'll also break off the samples patch and that can go by itself.  Is there=
 a
problem with the 32-bit userspace build environment that patchwork is usin=
g?
The sample programs that patch adds are all userspace helpers.  It seems t=
hat
<features.h> is referencing a file that doesn't exist:

In file included from /usr/include/features.h:514,
                 from /usr/include/bits/libc-header-start.h:33,
                 from /usr/include/stdio.h:27,
                 from ../samples/net/alg-hash.c:9:
/usr/include/gnu/stubs.h:7:11: fatal error: gnu/stubs-32.h: No such file o=
r directory
    7 | # include <gnu/stubs-32.h>
      |           ^~~~~~~~~~~~~~~~
compilation terminated.

Excerpt from:

https://patchwork.hopto.org/static/nipa/737278/13202278/build_32bit/

https://patchwork.kernel.org/project/netdevbpf/patch/20230405165339.346880=
8-2-dhowells@redhat.com/

David

