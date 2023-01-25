Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B998E67B944
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbjAYS0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbjAYS0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:26:06 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1C8CDE9;
        Wed, 25 Jan 2023 10:26:05 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o13so19425021pjg.2;
        Wed, 25 Jan 2023 10:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rr6V/M4y82KYnqVb2+nWqEf2dFIrFBb+hUJP0WC6mp8=;
        b=HY5bjfzY6d3afM7FtQcGjXS+RVZA4xVbTE4BU8YipeBLwjnm6tf+FBll3v3M2DnEJu
         ZWP0fpI8usn9/hwQU2xl+DBcGpXGVj8M/HQH4+nbGJ5YtSJnE/lqrwovGCXSTSbgDAUg
         wOY4z0UQE85D5/n+1t9ViTLvOUopu2LVMWkz0L1y2FRNQb80+ZVEkISY19ov660VxMm1
         n2s5TB5p4EtJoloO8UmGZXQYMA2IFm7TEDOcrYT9yQJhaR/pqH68bF1zDLKXSs1XTALN
         75Rrt+okjibMdolqEiGLhwCVFeDlwWSinVMdG+RMRx7pIBiFG03j3vhJPzuDPLrqTlJI
         T81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rr6V/M4y82KYnqVb2+nWqEf2dFIrFBb+hUJP0WC6mp8=;
        b=W7W481r3LhW087wX7hp8+/vVt8R1bSPQ76GUnEcihfOCKeJtmTsGGdTrbn05qQNOEp
         Ys3jF6UKMGllo10a1/aTmC/4PaDtGUFdlNEh2pbHuPe+oERfCVxf+5j6OHz/aX+i5f+L
         2+n/Pe05kjOKMi92G/v96JkYH/2isGNkhvT6pzqQOs8KOnbBaSDMP52n7SFYT1AkbH+y
         NkEFQ8WBoldN9Y8LeS+bS56o5caOpj/SCynmiINii8cir/G9TR/l3Qq+pF6xpTQw4iaf
         ylV1ne2YrVeoW1Uc904DvTzPZp3qxn+RnX+hZAcsQFzhe+F+RHW5kRAkV4q37ozhJeFi
         0LtA==
X-Gm-Message-State: AO0yUKUEogppOSwGoOTGo+qFma1H58FM1lZj7y7ngv0OVP3kXfVuj2yG
        wZ7XLMjvlhIyVt+6Ax08O8w=
X-Google-Smtp-Source: AK7set8ITUyv8I7rXxMg2+8jpqt1q9szFd0nCOrh4k7jndKMnAZdR+AWDGmxzQj/w2WsIH6gb5SYxw==
X-Received: by 2002:a17:90b:1e4e:b0:22b:f84e:5f9a with SMTP id pi14-20020a17090b1e4e00b0022bf84e5f9amr6005990pjb.43.1674671164613;
        Wed, 25 Jan 2023 10:26:04 -0800 (PST)
Received: from [192.168.0.128] ([98.97.116.5])
        by smtp.googlemail.com with ESMTPSA id q95-20020a17090a1b6800b0022698aa22d9sm92406pjq.31.2023.01.25.10.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 10:26:04 -0800 (PST)
Message-ID: <595c5e36b0260ba16833c2a8d9418fd978ca9300.camel@gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Date:   Wed, 25 Jan 2023 10:26:02 -0800
In-Reply-To: <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name>
References: <20230124124300.94886-1-nbd@nbd.name>
         <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
         <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
         <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
         <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name>
         <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
         <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-25 at 18:32 +0100, Felix Fietkau wrote:
> On 25.01.23 18:11, Alexander H Duyck wrote:
> > On Tue, 2023-01-24 at 22:30 +0100, Felix Fietkau wrote:
> > > On 24.01.23 22:10, Alexander H Duyck wrote:
> > > > On Tue, 2023-01-24 at 18:22 +0100, Felix Fietkau wrote:
> > > > > On 24.01.23 15:11, Ilias Apalodimas wrote:
> > > > > > Hi Felix,
> > > > > >=20
> > > > > > ++cc Alexander and Yunsheng.
> > > > > >=20
> > > > > > Thanks for the report
> > > > > >=20
> > > > > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrot=
e:
> > > > > > >=20
> > > > > > > While testing fragmented page_pool allocation in the mt76 dri=
ver, I was able
> > > > > > > to reliably trigger page refcount underflow issues, which did=
 not occur with
> > > > > > > full-page page_pool allocation.
> > > > > > > It appears to me, that handling refcounting in two separate c=
ounters
> > > > > > > (page->pp_frag_count and page refcount) is racy when page ref=
count gets
> > > > > > > incremented by code dealing with skb fragments directly, and
> > > > > > > page_pool_return_skb_page is called multiple times for the sa=
me fragment.
> > > > > > >=20
> > > > > > > Dropping page->pp_frag_count and relying entirely on the page=
 refcount makes
> > > > > > > these underflow issues and crashes go away.
> > > > > > >=20
> > > > > >=20
> > > > > > This has been discussed here [1].  TL;DR changing this to page
> > > > > > refcount might blow up in other colorful ways.  Can we look clo=
ser and
> > > > > > figure out why the underflow happens?
> > > > > I don't see how the approch taken in my patch would blow up. From=
 what I=20
> > > > > can tell, it should be fairly close to how refcount is handled in=
=20
> > > > > page_frag_alloc. The main improvement it adds is to prevent it fr=
om=20
> > > > > blowing up if pool-allocated fragments get shared across multiple=
 skbs=20
> > > > > with corresponding get_page and page_pool_return_skb_page calls.
> > > > >=20
> > > > > - Felix
> > > > >=20
> > > >=20
> > > > Do you have the patch available to review as an RFC? From what I am
> > > > seeing it looks like you are underrunning on the pp_frag_count itse=
lf.
> > > > I would suspect the issue to be something like starting with a bad
> > > > count in terms of the total number of references, or deducing the w=
rong
> > > > amount when you finally free the page assuming you are tracking you=
r
> > > > frag count using a non-atomic value in the driver.
> > > The driver patches for page pool are here:
> > > https://patchwork.kernel.org/project/linux-wireless/patch/64abb23f486=
7c075c19d704beaae5a0a2f8e8821.1673963374.git.lorenzo@kernel.org/
> > > https://patchwork.kernel.org/project/linux-wireless/patch/68081e02cbe=
2afa2d35c8aa93194f0adddbd0f05.1673963374.git.lorenzo@kernel.org/
> > >=20
> > > They are also applied in my mt76 tree at:
> > > https://github.com/nbd168/wireless
> > >=20
> > > - Felix
> >=20
> > So one thing I am thinking is that we may be seeing an issue where we
> > are somehow getting a mix of frag and non-frag based page pool pages.
> > That is the only case I can think of where we might be underflowing
> > negative. If you could add some additional debug info on the underflow
> > WARN_ON case in page_pool_defrag_page that might be useful.
> > Specifically I would be curious what the actual return value is. I'm
> > assuming we are only hitting negative 1, but I would want to verify we
> > aren't seeing something else.
> I'll try to run some more tests soon. However, I think I found the piece=
=20
> of code that is incompatible with using pp_frag_count.
> When receiving an A-MSDU packet (multiple MSDUs within a single 802.11=
=20
> packet), and it is not split by the hardware, a cfg80211 function=20
> extracts the individual MSDUs into separate skbs. In that case, a=20
> fragment can be shared across multiple skbs, and get_page is used to=20
> increase the refcount.
> You can find this in net/wireless/util.c: ieee80211_amsdu_to_8023s (and=
=20
> its helper functions).

I'm not sure if it is problematic or not. Basically it is trading off
by copying over the frags, calling get_page on each frag, and then
using dev_kfree_skb to disassemble and release the pp_frag references.
There should be other paths in the kernel that are doing something
similar.

> This code also has a bug where it doesn't set pp_recycle on the newly=20
> allocated skb if the previous one has it, but that's a separate matter=
=20
> and fixing it doesn't make the crash go away.

Adding the recycle would cause this bug. So one thing we might be
seeing is something like that triggering this error. Specifically if
the page is taken via get_page when assembling the new skb then we
cannot set the recycle flag in the new skb otherwise it will result in
the reference undercount we are seeing. What we are doing is shifting
the references away from the pp_frag_count to the page reference count
in this case. If we set the pp_recycle flag then it would cause us to
decrement pp_frag_count instead of the page reference count resulting
in the underrun.=20

> Is there any way I can make that part of the code work with the current=
=20
> page pool frag implementation?

The current code should work. Basically as long as the references are
taken w/ get_page and skb->pp_recycle is not set then we shouldn't run
into this issue because the pp_frag_count will be dropped when the
original skb is freed and the page reference count will be decremented
when the new one is freed.

For page pool page fragments the main thing to keep in mind is that if
pp_recycle is set it will update the pp_frag_count and if it is not
then it will just decrement the page reference count.
