Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D770583680
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiG1BtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiG1BtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:49:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F3F56B99;
        Wed, 27 Jul 2022 18:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93F91CE241D;
        Thu, 28 Jul 2022 01:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD6BC433D6;
        Thu, 28 Jul 2022 01:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658972944;
        bh=kqJ7Up1AG9Xmd3Cy2OO0yg7W2hC6LWNyn0GIY6GiW/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bFuYAMuYqYShYxH1P6tj7IU52gNJurgNdhWUnb2awTUfr3UMDkFIqB4YHRc4MN1sd
         9EpJq6ZGywvmsHVOAo3qS2pcm73uOpvI0UhzR9RsKMwa5HhZOkWZQqjtd6XWLbaz2C
         FXDp14iJHEOGs8ZujuI0BljRfMT49VySzT8M4gxjxv4/9uZEChff+VwN77iTovBfhg
         4rzG8dGqG6pXTCu+XLr8b9fJ3uFlSFlaIU8KcyCbWMawyktQ6tm5lJjiFoXSjClHO1
         Ez5svDCpkc76j+x3q/vcXEkJewJy/DQOJ05CMjeyrBVLDQqJ0czwvMRM+iftu+BFZw
         kD/OAlOU6FHww==
Date:   Wed, 27 Jul 2022 18:49:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220727184903.4d24a00a@kernel.org>
In-Reply-To: <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
        <20220727060909.2371812-1-kafai@fb.com>
        <YuFsHaTIu7dTzotG@google.com>
        <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
        <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
        <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
        <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
        <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 17:45:46 -0700 Martin KaFai Lau wrote:
> > bool setsockopt_capable(struct user_namespace *ns, int cap)
> > {
> >        if (!in_task()) {
> >              /* Running in irq/softirq -> setsockopt invoked by bpf program.
> >               * [not sure, is it safe to assume no regular path leads
> > to setsockopt from sirq?]
> >               */
> >              return true;
> >        }
> > 
> >        /* Running in process context, task has bpf_ctx set -> invoked
> > by bpf program. */
> >        if (current->bpf_ctx != NULL)
> >              return true;
> > 
> >        return ns_capable(ns, cap);
> > }
> > 
> > And then do /ns_capable/setsockopt_capable/ in net/core/sock.c
> > 
> > But that might be more fragile than passing the flag, idk.  
> I think it should work.  From a quick look, all bpf_setsockopt usage has
> bpf_ctx.  The one from bpf_tcp_ca (struct_ops) and bpf_iter is trampoline
> which also has bpf_ctx.  Not sure about the future use cases.
> 
> To be honest, I am not sure if I have missed cases and also have similar questions
> your have in the above sample code.  This may deserve a separate patch
> set for discussion.  Using a bit in sockptr is mostly free now.
> WDYT ?

Sorry to chime in but I vote against @in_bpf. I had to search the git
history recently to figure out what SK_USER_DATA_BPF means. It's not
going to be obvious to a networking person what semantics to attribute
to "in bpf".
