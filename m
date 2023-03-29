Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238116CED10
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjC2Pec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjC2PeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:34:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E363559D0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680104003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NeCkkPoa7tXS33oTjWiTv3O34+xg2iZRZ8XP3QkDkJA=;
        b=PKrR2yA88fI1a299seFCGzDpRjtJTtcu1ObWfILUqnwOm44NmFcJFMvzCWNeh01Q25y+SO
        iwTbzW+bIhC0rKMeg5ZEoo5V0AUDxEGqqh1FPM1oKVUXUdhZzOsDNPkdYEZ1HbtSmOi4qC
        RHOVaZUlqkvPoLnsQXwd5FfXNhjZ610=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-EMw0FyvuP6ivsPNFD8FRkA-1; Wed, 29 Mar 2023 11:33:20 -0400
X-MC-Unique: EMw0FyvuP6ivsPNFD8FRkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C594438149D4;
        Wed, 29 Mar 2023 15:32:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB1F41121330;
        Wed, 29 Mar 2023 15:32:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <SA0PR15MB391946EE72BC969337CF695299899@SA0PR15MB3919.namprd15.prod.outlook.com>
References: <SA0PR15MB391946EE72BC969337CF695299899@SA0PR15MB3919.namprd15.prod.outlook.com> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-31-dhowells@redhat.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Tom Talpey <tom@talpey.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH v2 30/48] siw: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage to transmit
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <522641.1680103968.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 29 Mar 2023 16:32:48 +0100
Message-ID: <522642.1680103968@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bernard Metzler <BMT@zurich.ibm.com> wrote:

> > When transmitting data, call down into TCP using a single sendmsg with
> > MSG_SPLICE_PAGES to indicate that content should be spliced rather tha=
n
> > performing several sendmsg and sendpage calls to transmit header, data
> > pages and trailer.
> > =

> > To make this work, the data is assembled in a bio_vec array and attach=
ed to
> > a BVEC-type iterator.  The header and trailer (if present) are copied =
into
> > page fragments that can be freed with put_page().
> =

> I like it a lot if it still keeps zero copy sendpage() semantics for
> the cases the driver can make use of data transfers w/o copy. =

> Is 'msg.msg_flags |=3D MSG_SPLICE_PAGES' doing that magic?

Yes.  MSG_SPLICE_PAGES indicates that you want the socket to retain your
buffer and pass it directly to the device.  Note that it's just a hint,
however, pages that are unspliceable (eg. they belong to the slab) will ge=
t
copied into a page fragment instead.  Further, if the device cannot suppor=
t a
vector, then the hint can be ignored and all the data can be copied as nor=
mal.

> 'splicing' suggest just merging pages to me.

'splicing' as in what the splice system call does.

Unfortunately, MSG_ZEROCOPY is already a (different) thing.

> It would simplify the transmit code path substantially, also getting
> rid of kmap_local_page()/kunmap_local() sequences for multi-fragment
> sendmsg()'s.

If the ITER_ITERLIST iterator is accepted, then siw would be able to do mi=
x
KVEC and BVEC iterators, e.g. what I did for sunrpc here:

	https://lore.kernel.org/linux-fsdevel/20230329141354.516864-42-dhowells@r=
edhat.com/T/#u

This means that in siw_tx_hdt() where I made it copy data into page fragme=
nts
using page_frag_memdup() and attach that to a bvec:

	hdr_len =3D c_tx->ctrl_len - c_tx->ctrl_sent;
	h =3D page_frag_memdup(NULL, hdr, hdr_len, GFP_NOFS, ULONG_MAX);
	if (!h)
		goto done;
	bvec_set_virt(&bvec[0], h, hdr_len);
	seg =3D 1;

it can just set up a kvec instead.

Unfortunately, it's not so easy to get rid of all of the kmap'ing as we ne=
ed
to do some of it to do the hashing.

David

