Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7F0680BE4
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbjA3L0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbjA3LZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:25:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53401C312
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 03:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675077865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w9A1bVyZb4er6cTd4zzjsltmhyvgIyU7DAJ3a6jVt6A=;
        b=dn/5Nv8e5/rCMrnoD+N+nCxODDGHVMfPpYqPsw+JwYKRpkJ4QarRmOSA/l23xkQop/u4Sn
        0m67DS+wgHHazRxqr0/sLu7PyXp3xWXJC83g3UIq+G+t6LuCGiHOrwOfmIaCQGx+XjYsmI
        SqpzEFSMdfhs4LKpFuxtVS/P3F7iNwc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-JYIlhA5gM_SRvbpUiBK1og-1; Mon, 30 Jan 2023 06:24:18 -0500
X-MC-Unique: JYIlhA5gM_SRvbpUiBK1og-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15A29382C965;
        Mon, 30 Jan 2023 11:24:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27FB8492B05;
        Mon, 30 Jan 2023 11:24:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230130103343.GA11663@lst.de>
References: <20230130103343.GA11663@lst.de> <20230130092157.1759539-21-hch@lst.de> <20230130092157.1759539-1-hch@lst.de> <3347459.1675074683@warthog.procyon.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dhowells@redhat.com, linux-block@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 20/23] rxrpc: use bvec_set_page to initialize a bvec
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3351917.1675077855.1@warthog.procyon.org.uk>
Date:   Mon, 30 Jan 2023 11:24:15 +0000
Message-ID: <3351918.1675077855@warthog.procyon.org.uk>
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

Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Jan 30, 2023 at 10:31:23AM +0000, David Howells wrote:
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > +		bvec_set_page(&bv, ZERO_PAGE(0), len, 0);
> > 
> > Maybe bvec_set_zero_page()?
> 
> Why?

Seems to be something people want to do quite a lot and don't know about.
I've seen places where someone allocates a buffer and clears it just to use as
a source of zeros.  There's at least one place in cifs, for example.  I know
about it from wrangling arch code, but most people working on Linux haven't
done that.

David

