Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4F5696AF5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbjBNRMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjBNRLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:11:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D278B2E0FB
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676394628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0DJXN9Zb39FhiQZf73JvN0gT+bxqzwusS/lWbuaFLXw=;
        b=apLbHDgzmsmqx/vPs+PgIjx9XchHTiHc70TuOwnZcB0S3uweri7hxN3yKocdOopbm0Oz/p
        ES333jLWj2L3hADMm6mTfbyLf5kAr+ULZXtzNkHNY51NtNKI9I+Rhqchc5gpxNbGjESBoo
        D4Lt5e7m6+AYM/3oJFKcmHopBbfY6Gk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-49-AdK6bXUcMEa43Zbixm6ZKg-1; Tue, 14 Feb 2023 12:09:38 -0500
X-MC-Unique: AdK6bXUcMEa43Zbixm6ZKg-1
Received: by mail-qk1-f199.google.com with SMTP id u11-20020a05620a0c4b00b0073b328e7d17so4258967qki.9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:09:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0DJXN9Zb39FhiQZf73JvN0gT+bxqzwusS/lWbuaFLXw=;
        b=zlTcSk+/Wdl8FsTJd7OTd+THqvQzGHCMirTQBFt1LRkKSo+ey/XhjtbuLPKCq3lkLf
         Lmkb3UmCJrvR6IvofoQAe9lq41ipqIMw5M5CML7kGFTjevwTKjMAMXVrZTfCK3vTbvhu
         7wVfSNIeGCf8fz6hhc8sz8nT5PkAbW9jN8wNWImvjUCb0+Z/lorfP3Pd2jwfBqijqAj4
         Dri177Akygk2XBRs9JUixGdSsxTn9Nssqe7ol8WjFBmMCsAsFc6kXtnNQbhs55hXyh/E
         hP+G2cIG0Zb2+7EynPXPbzFPPvQW6AuvdquaSFicrTwPuB6zYieY2VKki66L+7A+H9XT
         qSgA==
X-Gm-Message-State: AO0yUKWb4Jt9dcGExHBerxbtMbfxXtxErZVhwiPLhrh5v3wdAIcbcFkq
        Dmg59trBrVQBHj60ef4MX0jCGsUZrXrthEdbh4lMbJJW2HRy8yjiU1krOM8tXJ8aIE8yfp7Bp/a
        1MJQBV24rowOvDj3Q
X-Received: by 2002:a05:622a:13ce:b0:3b9:b9b4:cb8d with SMTP id p14-20020a05622a13ce00b003b9b9b4cb8dmr5606820qtk.11.1676394577591;
        Tue, 14 Feb 2023 09:09:37 -0800 (PST)
X-Google-Smtp-Source: AK7set9nrBuxI7vKhnbD9jG+rn0Zx5mXmYMbBddcbNffn3VsQz+QYI3PTcTYhZP5fvn0d8bv3bzoJg==
X-Received: by 2002:a05:622a:13ce:b0:3b9:b9b4:cb8d with SMTP id p14-20020a05622a13ce00b003b9b9b4cb8dmr5606794qtk.11.1676394577365;
        Tue, 14 Feb 2023 09:09:37 -0800 (PST)
Received: from debian (2a01cb058918ce00ffc7d132b72de2cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:ffc7:d132:b72d:e2cb])
        by smtp.gmail.com with ESMTPSA id m126-20020a378a84000000b0073b587194d0sm2059470qkd.104.2023.02.14.09.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 09:09:36 -0800 (PST)
Date:   Tue, 14 Feb 2023 18:09:33 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
Message-ID: <Y+vATfTKLogXw+Ki@debian>
References: <20230212162623.2301597-1-syoshida@redhat.com>
 <Y+pPXOqfrYkXPg1K@debian>
 <Y+u7hGIAxhvyDG/2@kernel-devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+u7hGIAxhvyDG/2@kernel-devel>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 01:49:08AM +0900, Shigeru Yoshida wrote:
> Just one more thing.  I created this patch based on the mainline linux
> tree, but networking subsystem has own tree, net.  Is it preferable to
> create a patch based on net tree for networking patches?

Yes. Networking fixes should be based on the "net" tree:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

For more details about posting patches to netdev, you can check
Documentation/process/maintainer-netdev.rst

Or the online version:
https://kernel.org/doc/html/latest/process/maintainer-netdev.html

> Thanks,
> Shigeru
> 
> > 
> 

