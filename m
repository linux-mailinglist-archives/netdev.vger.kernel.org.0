Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58A3611EF1
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 03:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJ2BOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 21:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJ2BOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 21:14:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B733A11447;
        Fri, 28 Oct 2022 18:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8DF362B3F;
        Sat, 29 Oct 2022 01:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDB4C433D6;
        Sat, 29 Oct 2022 01:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667006073;
        bh=fdjIfuGygB6OtejkD2M5HFPCwm4w2KiWqIqiN9qPzFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JyPyedyNIuYnxXMdf0zQyWOErT9gfyCsMzYcRBsDA46B/4qh/Rnf0/VsMotEWg4Ac
         aYiDx1+iTtqT8Z7orGcadiqaWPq68xgOqJPatv2jZWzGocOF6+Sv6GrJNh6Lubsjes
         v18UrCFuS7I9PcFTDcjQlzm4gEWHAmf8P9WgibK54Ok8+8w2BgXbNjQi4X9tRz1Hdc
         +WWOFsz73t9CsUXvQztqdtuk6fYjEy5eNZlqWY12R8L44jJM4ijQKK2SElAwp2ffbG
         wPqvsIlquicn5lVr+rwYP3Xc46c2Ve/WUfve807WXsSpC77e8SnM2wtybiV653UIWM
         fC7iaQATNqFeg==
Date:   Fri, 28 Oct 2022 18:14:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Message-ID: <20221028181431.05173968@kernel.org>
In-Reply-To: <635c62c12652d_b1ba208d0@john.notmuch>
References: <20221027200019.4106375-1-sdf@google.com>
        <635bfc1a7c351_256e2082f@john.notmuch>
        <20221028110457.0ba53d8b@kernel.org>
        <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
        <635c62c12652d_b1ba208d0@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 16:16:17 -0700 John Fastabend wrote:
> > > And it's actually harder to abstract away inter HW generation
> > > differences if the user space code has to handle all of it.  
> 
> I don't see how its any harder in practice though?

You need to find out what HW/FW/config you're running, right?
And all you have is a pointer to a blob of unknown type.

Take timestamps for example, some NICs support adjusting the PHC 
or doing SW corrections (with different versions of hw/fw/server
platforms being capable of both/one/neither).

Sure you can extract all this info with tracing and careful
inspection via uAPI. But I don't think that's _easier_.
And the vendors can't run the results thru their validation 
(for whatever that's worth).

> > I've had the same concern:
> > 
> > Until we have some userspace library that abstracts all these details,
> > it's not really convenient to use. IIUC, with a kptr, I'd get a blob
> > of data and I need to go through the code and see what particular type
> > it represents for my particular device and how the data I need is
> > represented there. There are also these "if this is device v1 -> use
> > v1 descriptor format; if it's a v2->use this another struct; etc"
> > complexities that we'll be pushing onto the users. With kfuncs, we put
> > this burden on the driver developers, but I agree that the drawback
> > here is that we actually have to wait for the implementations to catch
> > up.  
> 
> I agree with everything there, you will get a blob of data and then
> will need to know what field you want to read using BTF. But, we
> already do this for BPF programs all over the place so its not a big
> lift for us. All other BPF tracing/observability requires the same
> logic. I think users of BPF in general perhaps XDP/tc are the only
> place left to write BPF programs without thinking about BTF and
> kernel data structures.
> 
> But, with proposed kptr the complexity lives in userspace and can be
> fixed, added, updated without having to bother with kernel updates, etc.
> From my point of view of supporting Cilium its a win and much preferred
> to having to deal with driver owners on all cloud vendors, distributions,
> and so on.
> 
> If vendor updates firmware with new fields I get those immediately.

Conversely it's a valid concern that those who *do* actually update
their kernel regularly will have more things to worry about.

> > Jakub mentions FW and I haven't even thought about that; so yeah, bpf
> > programs might have to take a lot of other state into consideration
> > when parsing the descriptors; all those details do seem like they
> > belong to the driver code.  
> 
> I would prefer to avoid being stuck on requiring driver writers to
> be involved. With just a kptr I can support the device and any
> firwmare versions without requiring help.

1) where are you getting all those HW / FW specs :S
2) maybe *you* can but you're not exactly not an ex-driver developer :S

> > Feel free to send it early with just a handful of drivers implemented;
> > I'm more interested about bpf/af_xdp/user api story; if we have some
> > nice sample/test case that shows how the metadata can be used, that
> > might push us closer to the agreement on the best way to proceed.  
> 
> I'll try to do a intel and mlx implementation to get a cross section.
> I have a good collection of nics here so should be able to show a
> couple firmware versions. It could be fine I think to have the raw
> kptr access and then also kfuncs for some things perhaps.
> 
> > > I'd prefer if we left the door open for new vendors. Punting descriptor
> > > parsing to user space will indeed result in what you just said - major
> > > vendors are supported and that's it.  
> 
> I'm not sure about why it would make it harder for new vendors? I think
> the opposite, 

TBH I'm only replying to the email because of the above part :)
I thought this would be self evident, but I guess our perspectives 
are different.

Perhaps you look at it from the perspective of SW running on someone
else's cloud, an being able to move to another cloud, without having 
to worry if feature X is available in xdp or just skb.

I look at it from the perspective of maintaining a cloud, with people
writing random XDP applications. If I swap a NIC from an incumbent to a
(superior) startup, and cloud users are messing with raw descriptor -
I'd need to go find every XDP program out there and make sure it
understands the new descriptors.

There is a BPF foundation or whatnot now - what about starting a
certification program for cloud providers and making it clear what
features must be supported to be compatible with XDP 1.0, XDP 2.0 etc?

> it would be easier because I don't need vendor support at all.

Can you support the enfabrica NIC on day 1? :) To an extent, its just
shifting the responsibility from the HW vendor to the middleware vendor.

> Thinking it over seems there could be room for both.

Are you thinking more or less Stan's proposal but with one of 
the callbacks being "give me the raw thing"? Probably as a ro dynptr?
Possible, but I don't think we need to hold off Stan's work.
