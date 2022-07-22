Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D06957D964
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiGVETH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiGVETD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:19:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EBB397D44
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 21:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658463538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wK85Xq29MVxgOXn1JQxYSaRa292CjnMXvVLzF3E2ehs=;
        b=ECaI9A6nq7NTfmK0u9ypdsIL2W9VoD88CcecK2sirKfmFK6ZwzjOxupN6pY+h72LYFhZXU
        NVXb+TI8eOw3zjVnMvZ1+q49alOarWZ2RFNUBJA76SOGM9shkB4IJQVMPNEnJ7qaMmh6Cx
        fahc/cDNaT3LKFeo/2HEc+8jk2ZY+IA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-uUaWnyf5OmCIHZbOcQbvPw-1; Fri, 22 Jul 2022 00:18:51 -0400
X-MC-Unique: uUaWnyf5OmCIHZbOcQbvPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7548811E7A;
        Fri, 22 Jul 2022 04:18:50 +0000 (UTC)
Received: from sparkplug.usersys.redhat.com (unknown [10.40.192.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41D48404754B;
        Fri, 22 Jul 2022 04:18:48 +0000 (UTC)
Date:   Fri, 22 Jul 2022 06:18:45 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 1/4] bpf: add BPF_F_DESTRUCTIVE flag for
 BPF_PROG_LOAD
Message-ID: <YtolJfvSGjSSwbc3@sparkplug.usersys.redhat.com>
References: <20220720114652.3020467-1-asavkov@redhat.com>
 <20220720114652.3020467-2-asavkov@redhat.com>
 <CAADnVQ+mt1iEsXUGBeL-dgXRoRwPxoz+G=aRcZTkhx2AA10R-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQ+mt1iEsXUGBeL-dgXRoRwPxoz+G=aRcZTkhx2AA10R-A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 07:02:07AM -0700, Alexei Starovoitov wrote:
> On Wed, Jul 20, 2022 at 4:47 AM Artem Savkov <asavkov@redhat.com> wrote:
> >
> > +/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
> > + * will be able to perform destructive operations such as calling bpf_panic()
> > + * helper.
> > + */
> > +#define BPF_F_DESTRUCTIVE      (1U << 6)
> 
> I don't understand what value this flag provides.
> 
> bpf prog won't be using kexec accidentally.
> Requiring user space to also pass this flag seems pointless.

bpf program likely won't. But I think it is not uncommon for people to
run bpftrace scripts they fetched off the internet to run them without
fully reading the code. So the idea was to provide intermediate tools
like that with a common way to confirm user's intent without
implementing their own guards around dangerous calls.
If that is not a good enough of a reason to add the flag I can drop it.

-- 
 Artem

