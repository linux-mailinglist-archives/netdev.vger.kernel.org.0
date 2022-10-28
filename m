Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB46D6119DD
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJ1SFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiJ1SFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:05:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B7E78217;
        Fri, 28 Oct 2022 11:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 719A1B82C0C;
        Fri, 28 Oct 2022 18:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70644C433D6;
        Fri, 28 Oct 2022 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666980299;
        bh=/LKUWu2e7jT40ZDk4GTWkD659giq+VNMOVEzdHsDBrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=scjCkeAZeUa5GtTqab773Jlj4mT4u/mMP/SX7Z43SsoGQ0nhSvGAHlK8rZV1VdlAK
         ZEM1rpB0/JagPZL+ApadDWvp2k8NfOGvfkozA+If70bdVAvDUoRo6BawMxHo5GQktY
         7U5HX85v7tATm8RK5rXBdoGsW+/NkEpWjFFGwHhPJ+ob+Xj0ARiwXvXl3wRFeQDhaf
         0hXyyUh7aHC4Mt8s2YjWfkZeY74YWX1R8u5O93CMpo4ryRF/rBD+ulAWeJt9MX0/Mo
         DHj49EykUP53Gk1X80/7EqpKbwhVeOgxdbFZCEuOzxgs+LsrTSGstHT/ApoJBS6FYR
         Imfvsh1Md7ppA==
Date:   Fri, 28 Oct 2022 11:04:57 -0700
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
Message-ID: <20221028110457.0ba53d8b@kernel.org>
In-Reply-To: <635bfc1a7c351_256e2082f@john.notmuch>
References: <20221027200019.4106375-1-sdf@google.com>
        <635bfc1a7c351_256e2082f@john.notmuch>
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

On Fri, 28 Oct 2022 08:58:18 -0700 John Fastabend wrote:
> A bit of extra commentary. By exposing the raw kptr to the rx
> descriptor we don't need driver writers to do anything.
> And can easily support all the drivers out the gate with simple
> one or two line changes. This pushes the interesting parts
> into userspace and then BPF writers get to do the work without
> bother driver folks and also if its not done today it doesn't
> matter because user space can come along and make it work
> later. So no scattered kernel dependencies which I really
> would like to avoid here. Its actually very painful to have
> to support clusters with N kernels and M devices if they
> have different features. Doable but annoying and much nicer
> if we just say 6.2 has support for kptr rx descriptor reading
> and all XDP drivers support it. So timestamp, rxhash work
> across the board.

IMHO that's a bit of wishful thinking. Driver support is just a small
piece, you'll have different HW and FW versions, feature conflicts etc.
In the end kernel version is just one variable and there are many others
you'll already have to track.

And it's actually harder to abstract away inter HW generation
differences if the user space code has to handle all of it.

> To find the offset of fields (rxhash, timestamp) you can use
> standard BTF relocations we have all this machinery built up
> already for all the other structs we read, net_devices, task
> structs, inodes, ... so its not a big hurdle at all IMO. We
> can add userspace libs if folks really care, but its just a read so
> I'm not even sure that is helpful.
> 
> I think its nicer than having kfuncs that need to be written
> everywhere. My $.02 although I'll poke around with below
> some as well. Feel free to just hang tight until I have some
> code at the moment I have intel, mellanox drivers that I
> would want to support.

I'd prefer if we left the door open for new vendors. Punting descriptor
parsing to user space will indeed result in what you just said - major
vendors are supported and that's it.
