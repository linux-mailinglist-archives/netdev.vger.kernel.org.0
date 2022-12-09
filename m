Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBD3647B78
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLIBbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiLIBbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:31:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF90E82F9D;
        Thu,  8 Dec 2022 17:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DFBA6210A;
        Fri,  9 Dec 2022 01:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFD6C433EF;
        Fri,  9 Dec 2022 01:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670549454;
        bh=O3gqpaHAaVJ+VQYk3KlcocWeL7MxNJI9S3vqrlnG0Bw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OsALoXsh10Da1s1AEPa+oFbbLFFzlOlm3vbQRcHkv91I2trG2iMe4JzhVO8Qp64mB
         z9zUQeJpAPGw+0KrcE6Jw6QkUY3+E56pypWi62g8tG7lq2tdJQYqXxQDkR2MNU0/ph
         5gIBzClnT4IXgy/EqP+bVXi+F4Gho1/46Luu/sgR4tsfbSsOhtp1tFblWTrQ6b39lO
         COyjWGkRmuK9+nbOaGdUDc33gFd43RLvTQGHlU/vL9Oon1mosxK3HluuqRpO3e/9go
         iWjwArPMPMiQd4f2tzXPK+qhRgdgKmDDEP0YDOosXGHp3xodsdFyp5UUv7xJgY+SbC
         OohIvtjrzj5iw==
Date:   Thu, 8 Dec 2022 17:30:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
Message-ID: <20221208173053.1145a8cb@kernel.org>
In-Reply-To: <CAKH8qBtAQe=b1BLR5RKu7mBynQf0arp4G9+DtvcWVNKNK_27vA@mail.gmail.com>
References: <20221206024554.3826186-1-sdf@google.com>
        <20221206024554.3826186-4-sdf@google.com>
        <20221207210019.41dc9b6b@kernel.org>
        <CAKH8qBtAQe=b1BLR5RKu7mBynQf0arp4G9+DtvcWVNKNK_27vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Dec 2022 11:07:43 -0800 Stanislav Fomichev wrote:
> > >       bpf_free_used_maps(aux);
> > >       bpf_free_used_btfs(aux);
> > > -     if (bpf_prog_is_offloaded(aux))
> > > +     if (bpf_prog_is_dev_bound(aux))
> > >               bpf_prog_offload_destroy(aux->prog);  
> >
> > This also looks a touch like a mix of terms (condition vs function
> > called).  
> 
> Here, not sure, open to suggestions. These
> bpf_prog_offload_init/bpf_prog_offload_destroy are generic enough
> (now) that I'm calling them for both dev_bound/offloaded.
> 
> The following paths trigger for both offloaded/dev_bound cases:
> 
> if (bpf_prog_is_dev_bound()) bpf_prog_offload_init();
> if (bpf_prog_is_dev_bound()) bpf_prog_offload_destroy();
> 
> Do you think it's worth it having completely separate
> dev_bound/offloaded paths? Or, alternatively, can rename to
> bpf_prog_dev_bound_{init,destroy} but still handle both cases?

Any offload should be bound, right? So I think functions which handle
both can use the bound naming scheme, only the offload-specific ones 
should explicitly use offload?
