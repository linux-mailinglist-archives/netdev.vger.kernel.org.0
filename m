Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F96257376C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 15:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiGMNbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 09:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiGMNbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 09:31:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5939D28A
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 06:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657719096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sgNHH7BFb0s4RwPxS2Qx5icxf3D9jQ1/BExnQlyRDHc=;
        b=T4im+tJu3TZEWOEX131rgBz+P6Qgu7ibeo7bzmBqvdnLNHi2PlGh8vwaIXtS/rCDJYNoCa
        BJO6+uEXP5x9De/40wsRR4lqG3lk8h/AZUxU5o4UMdZohm26PHWAdattr/OH2ZjMjPalr9
        G59JNE9nwzIiOIxlpci6Dv9MPKqAe3U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-m6BergIANhONx7akHrV2ng-1; Wed, 13 Jul 2022 09:31:32 -0400
X-MC-Unique: m6BergIANhONx7akHrV2ng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC6EE801231;
        Wed, 13 Jul 2022 13:31:31 +0000 (UTC)
Received: from wtfbox.lan (unknown [10.40.192.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 375F8400DFA6;
        Wed, 13 Jul 2022 13:31:30 +0000 (UTC)
Date:   Wed, 13 Jul 2022 15:31:27 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, dvacek@redhat.com
Subject: Re: [RFC PATCH bpf-next 3/4] bpf: add bpf_panic() helper
Message-ID: <Ys7JL9Ih3546Eynf@wtfbox.lan>
References: <20220711083220.2175036-1-asavkov@redhat.com>
 <20220711083220.2175036-4-asavkov@redhat.com>
 <CAPhsuW7xTRpLf1kyj5ejH0fV_aHCMQjUwn-uhWeNytXedh4+TQ@mail.gmail.com>
 <CAADnVQ+ju04JAqyEbA_7oVj9uBAuL-fUP1FBr_OTygGf915RfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQ+ju04JAqyEbA_7oVj9uBAuL-fUP1FBr_OTygGf915RfQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 11:08:54AM -0700, Alexei Starovoitov wrote:
> On Tue, Jul 12, 2022 at 10:53 AM Song Liu <song@kernel.org> wrote:
> >
> > >
> > > +BPF_CALL_1(bpf_panic, const char *, msg)
> > > +{
> > > +       panic(msg);
> >
> > I think we should also check
> >
> >    capable(CAP_SYS_BOOT) && destructive_ebpf_enabled()
> >
> > here. Or at least, destructive_ebpf_enabled(). Otherwise, we
> > may trigger panic after the sysctl is disabled.
> >
> > In general, I don't think sysctl is a good API, as it is global, and
> > the user can easily forget to turn it back off. If possible, I would
> > rather avoid adding new BPF related sysctls.
> 
> +1. New syscal isn't warranted here.
> Just CAP_SYS_BOOT would be enough here.

Point taken, I'll remove sysctl knob in any further versions.

> Also full blown panic() seems unnecessary.
> If the motivation is to get a memory dump then crash_kexec() helper
> would be more suitable.
> If the goal is to reboot the system then the wrapper of sys_reboot()
> is better.
> Unfortunately the cover letter lacks these details.

The main goal is to get the memory dump, so crash_kexec() should be enough.
However panic() is a bit more versatile and it's consequences are configurable
to some extent. Are there any downsides to using it?

> Why this destructive action cannot be delegated to user space?

Going through userspace adds delays and makes it impossible to hit "exactly
the right moment" thus making it unusable in most cases.

I'll add this to the cover letter.

> btw, we should avoid adding new uapi helpers in most cases.
> Ideally all of them should be added as new kfunc-s, because they're
> unstable and we can rip them out later if our judgement call
> turns out to be problematic for whatever reason.

Ok, I'll look into doing it this way.

-- 
Regards,
  Artem

