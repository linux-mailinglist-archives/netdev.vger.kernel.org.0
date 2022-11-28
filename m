Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526D963B2DE
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiK1URk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiK1URg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:17:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BCC27CEB
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669666599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/vxuWycgxhs4B4hXKEVHWapGna4khbto9eLKu/wcG74=;
        b=DLycO/QA7n8+lUBAMLZtHcIn0cm+6A0wFMujd37Jm65Acy2JuuY4G1Y5GBjf5eALmtjNJo
        8jJQupiT8weR7aIOas3gL5RgpMoyyhKV6IVtbqrDArMYr/VGDl6y9q0VKXIKmeeabGMhOH
        aewWBB9XqnKi4chWD4eIJ838Eqx9vHc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-hZNQgtIYPb6B-U2mb9KebQ-1; Mon, 28 Nov 2022 15:16:38 -0500
X-MC-Unique: hZNQgtIYPb6B-U2mb9KebQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0425B1C08780;
        Mon, 28 Nov 2022 20:16:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 415A517582;
        Mon, 28 Nov 2022 20:16:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20221128104853.25665813@kernel.org>
References: <20221128104853.25665813@kernel.org> <20221123192335.119335ac@kernel.org> <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk> <1869061.1669273688@warthog.procyon.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/13] rxrpc: Increasing SACK size and moving away from softirq, part 2
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3477286.1669666594.1@warthog.procyon.org.uk>
Date:   Mon, 28 Nov 2022 20:16:34 +0000
Message-ID: <3477287.1669666594@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 24 Nov 2022 07:08:08 +0000 David Howells wrote:
> > What's the best way to base on a fix commit that's in net for patches in
> > net-next?  Here I tried basing on a merge between them.  Should I include
> > the fix patch on my net-next branch instead? Or will net be merged into
> > net-next at some point and I should wait for that?
> 
> We merge net -> net-next each Thursday afternoon (LT / Linus Time)
> so if the wait is for something in net then we generally ask for folks
> to just hold off posting until the merge. If the dependency is the
> other way then just post based on what's in tree and provide the
> conflict resolution in the cover letter.

Ok.  I guess last Thursday was skipped because of Thanksgiving.

David

