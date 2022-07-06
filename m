Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C276E56920E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 20:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiGFSom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 14:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiGFSok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 14:44:40 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40DD10E9;
        Wed,  6 Jul 2022 11:44:39 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id z14so14738892pgh.0;
        Wed, 06 Jul 2022 11:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QBWnTGtWCIRK/R2Rxz0hgC6/YznGaVDZLzOauaR/k/s=;
        b=WOD/8yZgRdtFPzBVVcE5rYoZy5KfnhmXEnQS9Et8gKO8Zjs/YhpFh73qtgXUM5Fo0e
         2nP6Shv/maiRuRPdGqfhf1tQWKbyOxBv13hOOzskoSviImgwzmvoLtGtDuuvj74hZRNY
         eM3aDa/Pt38iPYHyQVAGXrlW20nwRKnCB6lXDRJuwHeYRXBe+oz1HoLOFs6Zhz00QTkl
         TQyR0ax+kc526qC40A356K4ZO3axf6B7To/HUu8bgflGITLsDc99asZxEgT1ZV96OTM7
         pH24yvN/IAaGgjBAg4ArBqwYhX9pUOCzk13RTMvqtAdixZq5sDT8SAAbie3GUHTYSO2P
         DSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QBWnTGtWCIRK/R2Rxz0hgC6/YznGaVDZLzOauaR/k/s=;
        b=bhPt+2zUPm5dZvD9nlKorTKn3ux+DgIjdb4WIGuPQyIevoRMkCuIEx8Kag59V0xAxh
         EROBzM0oKPcvCCz3xATP1ccNMPMn3PrVQ7dFbqgV2k5yD2L9ErdF5LxJt6evbKMmsXbI
         E4gp7s2D8tgBfSbKik0oKfkyHIv9ewjf1lie2NqISV3ZWsiclZXExrkFIsSr+3LjaIAe
         RzZilLHvoA9HHzk7GRNad86LfzeiIpHEThtKjgqNd9dTiXw2kNUvu8QRfOKM/poYzeVn
         2aGZPZwRSet/hT4O0I4RDkPio7W+hgO7VpDaROpscBdY7nLU6ebGllT5cwuelqITdJIc
         rGyw==
X-Gm-Message-State: AJIora9BCt4Jj5Kq8LeDgkKhw3C0vx4cyT6sjM227TirkmFZEObbuymZ
        QLEz3tnbQ2fUvRJneXioyGI=
X-Google-Smtp-Source: AGRyM1v8v1EviJzZooNw3rpihssTxo2CaorRno8GIJ+dHmIaf7vPw7fxAXRcaU4DCCNya66oFF1IvQ==
X-Received: by 2002:a65:684a:0:b0:412:78ef:7f87 with SMTP id q10-20020a65684a000000b0041278ef7f87mr7820901pgt.61.1657133079430;
        Wed, 06 Jul 2022 11:44:39 -0700 (PDT)
Received: from MacBook-Pro-3.local ([2620:10d:c090:500::2:8597])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b0052531985e3esm25240083pfo.22.2022.07.06.11.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 11:44:38 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:44:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
Message-ID: <20220706184436.mf7oeexxfwswgdqf@MacBook-Pro-3.local>
References: <20220623192637.3866852-1-memxor@gmail.com>
 <20220623192637.3866852-2-memxor@gmail.com>
 <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
 <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
 <CAP01T75cVLehQbkE3LLwSG5wVecNz0FH9QZpmzoqs-e8YKpGtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T75cVLehQbkE3LLwSG5wVecNz0FH9QZpmzoqs-e8YKpGtg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 03, 2022 at 11:04:22AM +0530, Kumar Kartikeya Dwivedi wrote:
> On Sun, 3 Jul 2022 at 10:54, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > On Wed, 29 Jun 2022 at 08:53, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Jun 24, 2022 at 12:56:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > Similar to how we detect mem, size pairs in kfunc, teach verifier to
> > > > treat __ref suffix on argument name to imply that it must be a
> > > > referenced pointer when passed to kfunc. This is required to ensure that
> > > > kfunc that operate on some object only work on acquired pointers and not
> > > > normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> > > > walking. Release functions need not specify such suffix on release
> > > > arguments as they are already expected to receive one referenced
> > > > argument.
> > > >
> > > > Note that we use strict type matching when a __ref suffix is present on
> > > > the argument.
> > > ...
> > > > +             /* Check if argument must be a referenced pointer, args + i has
> > > > +              * been verified to be a pointer (after skipping modifiers).
> > > > +              */
> > > > +             arg_ref = is_kfunc_arg_ref(btf, args + i);
> > > > +             if (is_kfunc && arg_ref && !reg->ref_obj_id) {
> > > > +                     bpf_log(log, "R%d must be referenced\n", regno);
> > > > +                     return -EINVAL;
> > > > +             }
> > > > +
> > >
> > > imo this suffix will be confusing to use.
> > > If I understand the intent the __ref should only be used
> > > in acquire (and other) kfuncs that also do release.
> > > Adding __ref to actual release kfunc will be a nop.
> > > It will be checked, but it's not necessary.
> > >
> > > At the end
> > > +struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
> > > will behave like kptr_xchg with exception that kptr_xchg takes any btf_id
> > > while here it's fixed.
> > >
> > > The code:
> > >  if (rel && reg->ref_obj_id)
> > >         arg_type |= OBJ_RELEASE;
> > > should probably be updated with '|| arg_ref'
> > > to make sure reg->off == 0 ?
> > > That looks like a small bug.
> > >
> >
> > Indeed, I missed that. Thanks for catching it.
> >
> > > But stepping back... why __ref is needed ?
> > > We can add bpf_ct_insert_entry to acq and rel sets and it should work?
> > > I'm assuming you're doing the orthogonal cleanup of resolve_btfid,
> > > so we will have a single kfunc set where bpf_ct_insert_entry will
> > > have both acq and rel flags.
> > > I'm surely missing something.
> >
> > It is needed to prevent the case where someone might do:
> > ct = bpf_xdp_ct_alloc(...);
> > bpf_ct_set_timeout(ct->master, ...);
> >
> 
> A better illustration is probably bpf_xdp_ct_lookup and
> bpf_ct_change_timeout, since here the type for ct->master won't match
> with bpf_ct_set_timeout, but the point is the same.

Sorry, I'm still not following.
Didn't we make pointer walking 'untrusted' so ct->master cannot be
passed into any kfunc?

> > Or just obtain PTR_TO_BTF_ID by pointer walking and try to pass it in
> > to bpf_ct_set_timeout.
> >
> > __ref allows an argument on a non-release kfunc to have checks like a
> > release argument, i.e. refcounted, reg->off == 0 (var_off is already
> > checked to be 0), so use the original pointer that was obtained from
> > an acquire kfunc. As you noted, it isn't strictly needed on release
> > kfunc (like bpf_ct_insert_entry) because the same checks happen for it
> > anyway. But both timeout and status helpers should use it if they
> > "operate" on the acquired ct (from alloc, insert, or lookup).
