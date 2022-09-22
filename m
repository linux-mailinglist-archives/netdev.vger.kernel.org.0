Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364715E64E9
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIVOQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiIVOQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:16:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9230BF3122
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663856155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=csaDTRy6D0rgazJxGh5NAOOWkO2ONFlpEf7iu8qiadM=;
        b=QdPNQ9i9/uRH+vGxOf9LUBVyGLuR19i028Fi2YN+MBCrmZjVgYUEVdfPqSKPlF1N5ff/VQ
        Vwxen50Og0VlSrqH4b5JGYM5V+WCoVz+aS1FiOhglcjHd27g0uX9NY1ghJl4YWzhYofkuM
        XL78C/pbCouhtPHzCvPuxyP7bhPSqBI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-UTAZqnfgN-u33fNF4J6Dbg-1; Thu, 22 Sep 2022 10:15:54 -0400
X-MC-Unique: UTAZqnfgN-u33fNF4J6Dbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4D56185A7A3;
        Thu, 22 Sep 2022 14:15:53 +0000 (UTC)
Received: from [172.16.176.1] (unknown [10.22.48.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 414422028CE4;
        Thu, 22 Sep 2022 14:15:52 +0000 (UTC)
From:   "Benjamin Coddington" <bcodding@redhat.com>
To:     "Guillaume Nault" <gnault@redhat.com>
Cc:     "David Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>, netdev@vger.kernel.org,
        "Chuck Lever" <chuck.lever@oracle.com>,
        "Jeff Layton" <jlayton@kernel.org>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>,
        "Anna Schumaker" <anna@kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [PATCH net] sunrpc: Use GFP_NOFS to prevent use of
 current->task_frag.
Date:   Thu, 22 Sep 2022 10:15:51 -0400
Message-ID: <A2C1BE91-AB0E-4671-93EC-B07E38DA1D99@redhat.com>
In-Reply-To: <96a18bd00cbc6cb554603cc0d6ef1c551965b078.1663762494.git.gnault@redhat.com>
References: <96a18bd00cbc6cb554603cc0d6ef1c551965b078.1663762494.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21 Sep 2022, at 8:16, Guillaume Nault wrote:

> Commit a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save() on all
> rpciod/xprtiod jobs") stopped setting sk->sk_allocation explicitly in
> favor of using memalloc_nofs_save()/memalloc_nofs_restore() critical
> sections.
>
> However, ->sk_allocation isn't used just by the memory allocator.
> In particular, sk_page_frag() uses it to figure out if it can return
> the page_frag from current or if it has to use the socket one.
> With ->sk_allocation set to the default GFP_KERNEL, sk_page_frag() now
> returns current->page_frag, which might already be in use in the
> current context if the call happens during memory reclaim.
>
> Fix this by setting ->sk_allocation to GFP_NOFS.
> Note that we can't just instruct sk_page_frag() to look at
> current->flags, because it could generate a cache miss, thus slowing
> down the TCP fast path.
>
> This is similar to the problems fixed by the following two commits:
>   * cifs: commit dacb5d8875cc ("tcp: fix page frag corruption on page
>     fault").
>   * nbd: commit 20eb4f29b602 ("net: fix sk_page_frag() recursion from
>     memory reclaim").
>
> Link: =

> https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6=
=2E1656699567.git.gnault@redhat.com/
> Fixes: a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save() on all =

> rpciod/xprtiod jobs")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Looks good, and thanks for looking through all the options.

Reviewed-by: Benjamin Coddington <bcodding@redhat.com>

Ben

