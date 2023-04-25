Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECEE6EDE75
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjDYIr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbjDYIrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FF56589
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682412246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZJYULa21bRSiosmoi3/4DldsRTvT4wpxgitPcs2X3GU=;
        b=iFIFN1/sjnIVgSIS3i1s55tv+70d6zL2AHgtMGE/VootSIOo0KlrhOoCERLk5onZ9acnHY
        JgWV2hjEbt9bw0vMus0zsGrBTlay0pscAR+ZDvlLe3MvvnGHWb3fZI4I0dCvUBHjCk5zTP
        5Y2QOZ20BfHJTM13cUo0LO8+wfxjgSg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-fxzR9FbANCSO0wONI3r1UA-1; Tue, 25 Apr 2023 04:30:36 -0400
X-MC-Unique: fxzR9FbANCSO0wONI3r1UA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61D97887402;
        Tue, 25 Apr 2023 08:30:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 185AC44007;
        Tue, 25 Apr 2023 08:30:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1957131.PYKUYFuaPT@suse>
References: <1957131.PYKUYFuaPT@suse> <20230331160914.1608208-1-dhowells@redhat.com> <20230331160914.1608208-42-dhowells@redhat.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
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
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v3 41/55] iscsi: Assume "sendpage" is okay in iscsi_tcp_segment_map()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <494036.1682411430.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 25 Apr 2023 09:30:30 +0100
Message-ID: <494037.1682411430@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fabio M. De Francesco <fmdefrancesco@gmail.com> wrote:

> > -	if (recv) {
> > -		segment->atomic_mapped =3D true;
> > -		segment->sg_mapped =3D kmap_atomic(sg_page(sg));
> > -	} else {
> > -		segment->atomic_mapped =3D false;
> > -		/* the xmit path can sleep with the page mapped so use =

> kmap */
> > -		segment->sg_mapped =3D kmap(sg_page(sg));
> > -	}
> > -
> > +	segment->atomic_mapped =3D true;
> > +	segment->sg_mapped =3D kmap_atomic(sg_page(sg));
> =

> As you probably know, kmap_atomic() is deprecated.
> =

> I must admit that I'm not an expert of this code, however, it looks like=
 the =

> mapping has no need to rely on the side effects of kmap_atomic() (i.e., =

> pagefault_disable() and preempt_disable() - but I'm not entirely sure ab=
out =

> the possibility that preemption should be explicitly disabled along with=
 the =

> replacement with kmap_local_page()). =

> =

> Last year I've been working on several conversions from kmap{,_atomic}()=
 to =

> kmap_local_page(), however I'm still not sure to understand what's happe=
ning =

> here...
> =

> Am I missing any important details? Can you please explain why we still =
need =

> that kmap_atomic() instead of kmap_local_page()? =


Actually, it might be worth dropping segment->sg_mapped and segment->data =
and
only doing the kmap_local when necessary.

And this:

			struct msghdr msg =3D { .msg_flags =3D flags };
			struct kvec iov =3D {
				.iov_base =3D segment->data + offset,
				.iov_len =3D copy
			};

			r =3D kernel_sendmsg(sk, &msg, &iov, 1, copy);

should really be using struct bvec, not struct kvec - then the mapping isn=
't
necessary.  It looks like this might be the only place the mapping is used=
,
but I'm not 100% certain.

David

