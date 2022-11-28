Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFD263B0AF
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiK1SGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiK1SGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:06:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CB653EDF
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 09:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669657814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SxbH4Nrlog2pQb6TdXdY2/MWDaz1GjxfE4q3b/hB6nI=;
        b=G/L2r6WG1m0i0GcOirFWC0PZ05LQ+SKX0dLzmZyEUWI+wnKR8ojT5kT+RFbX0Be7ozzXb2
        JMNyHyrjsR/iwekaizAHP2nqMBqXA4jgXHNZe1qU8SWQqRMHvijvImG7+jVZflQDwvlQ6i
        LhNLpHk8Vs2MpiL8EDoJvHdWr/8cKqY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-47-ZZMDewt_PKesGZ_9UtERwg-1; Mon, 28 Nov 2022 12:50:13 -0500
X-MC-Unique: ZZMDewt_PKesGZ_9UtERwg-1
Received: by mail-qk1-f197.google.com with SMTP id o13-20020a05620a2a0d00b006cf9085682dso21526486qkp.7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 09:50:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SxbH4Nrlog2pQb6TdXdY2/MWDaz1GjxfE4q3b/hB6nI=;
        b=BLCa2cStzqrVNoDsqNBveISafjNLHjna0SQ1fOOhKynkiyF88urdJ/mLfT/oYfs+t3
         8/Ma+mHK/HxINoMrnaB9EoqMvb7rEt11615VsyUTiTSfSNf2kojS1EdiE7zEhO+gGbIF
         uQhhi80fvX62ZUlljLaUWRa1YZf6NyOxYzCgArCoESgGwUl5QyhGx0xCiSWW8d9UVVM2
         Wt4jbjPFIqm+VxWUhxEQP2Fusl9ozCZSrCt1F0NxJ3910FAjUtuanxHHl9UNreAhWWoH
         SHCo97SSXQuD155CFQ6gXRth6fi9hd/P1bnrhfiDJXymhCs4wVIfg/YOXHLp2IETxPK6
         RfHQ==
X-Gm-Message-State: ANoB5pkdqpL56x4eADTqHfeYJxeSL9j8ZydmIZi6HNSXP4lcNDJt1Afa
        EiEEnfmp/wlWFmGwx17oELK9WvgeLx6DxNOrQenCZjlohKYkhHjhDBRnVmRWHtsLX5OAeeOb1Ng
        qpokb4PchzUQn26VK
X-Received: by 2002:a05:620a:26a1:b0:6fc:22e6:3899 with SMTP id c33-20020a05620a26a100b006fc22e63899mr26810536qkp.283.1669657812822;
        Mon, 28 Nov 2022 09:50:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf511NM5amUws9dde7jOXdsWKNNiwaxEDKsALTlpjFlZdb1oKfbElFPfCA4Gok8oojMI3cGhrw==
X-Received: by 2002:a05:620a:26a1:b0:6fc:22e6:3899 with SMTP id c33-20020a05620a26a100b006fc22e63899mr26810508qkp.283.1669657812553;
        Mon, 28 Nov 2022 09:50:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id c26-20020ac8661a000000b003a606428a59sm7249888qtp.91.2022.11.28.09.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 09:50:12 -0800 (PST)
Message-ID: <3309d2b568c55642a2100ce51fcdbfc3d0bee072.camel@redhat.com>
Subject: Re: [PATCH v2] epoll: use refcount to reduce ep_mutex contention
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        Roman Penyaev <rpenyaev@suse.de>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Date:   Mon, 28 Nov 2022 18:50:09 +0100
In-Reply-To: <Y3/4FW4mqY3fWRfU@sol.localdomain>
References: <f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com>
         <Y3/4FW4mqY3fWRfU@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-11-24 at 15:02 -0800, Eric Biggers wrote:
[...]
> The behavior after this patch is that the resources aren't freed until the epoll
> file *and* all files that were added to it have been closed.
> 
> Is that okay? 

[...]

> But probably some users do things the other way around.  I.e., they have a
> long-lived file descriptor that is repeatedly polled using different epoll
> instances that have a shorter lifetime.
> 
> In that case, the number of 'struct eventpoll' and 'struct epitem' in kernel
> memory will keep growing until 'max_user_watches' is hit, at which point
> EPOLL_CTL_ADD will start failing with ENOSPC.
> 
> Are you sure that is fine?

I have a new version of this patch which hopefully should address both
concerns. I'll share it soon.

Thanks!

Paolo

