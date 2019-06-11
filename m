Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D893CAE7
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 14:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfFKMRL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Jun 2019 08:17:11 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46700 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfFKMRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 08:17:11 -0400
Received: by mail-ed1-f66.google.com with SMTP id h10so19683417edi.13
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 05:17:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=U8VY/A+wnj+SF3sW6j7SiDJfywoPLecdIrzZ7ypp15k=;
        b=gXBex2YR3aMwYPl8fbNTQ7cXxedldWKgJrUV4JVF/bnclK1q8jo4Gg/zr9YCQ9QCX8
         xjBxJm/b8YQHE8kAX6CuXAFcH0WlS4WJulKIztSH/LqF66vMyXgXaUvLC+VO7dd+mNPH
         vm4cevBgXmo2K6hgDj2sBrdW0qoSMQLrP4IHTiaUNKvbwnMaEyLGoW1k21/DVjTt1E4W
         ay3u5gT1D35GlSWv/QdwHnwr6BFE8zF06lhyrn1NI47RWcIFWO7bImcB1fSN04pjJPb9
         rpG/ieV0cp2mbMvRJYRzAk+QiyhFK5YaRMR6DxGe5IcDNBxrg75mDwvzUhZrhqFhEtJ/
         jFIQ==
X-Gm-Message-State: APjAAAUGzzKO2rXMoa0k4613CYOQyE+0rAHZYqL2RQ7KG2Pjg22ge3cS
        zvyKzptyWp3aKS3mZmvj9pvSgA==
X-Google-Smtp-Source: APXvYqyUV72kpi/fsmyIFOPBpWcZrl3YJx/kIYdSUNHlAo+2gBSIivUkoQVLD8G3mqqHvc232mijpQ==
X-Received: by 2002:a50:b3d0:: with SMTP id t16mr11639931edd.158.1560255429776;
        Tue, 11 Jun 2019 05:17:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id w50sm3649955edb.60.2019.06.11.05.17.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 05:17:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3BCF318037E; Tue, 11 Jun 2019 14:17:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, brouer@redhat.com, bpf@vger.kernel.org,
        saeedm@mellanox.com
Subject: Re: [PATCH bpf-next v3 0/5] net: xdp: refactor XDP program queries
In-Reply-To: <980c54f7-e270-f6cf-089d-969cebad8f38@intel.com>
References: <20190610160234.4070-1-bjorn.topel@gmail.com> <20190610152433.6e265d6c@cakuba.netronome.com> <980c54f7-e270-f6cf-089d-969cebad8f38@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 11 Jun 2019 14:17:08 +0200
Message-ID: <87v9xcgvuj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Björn Töpel <bjorn.topel@intel.com> writes:

> On 2019-06-11 00:24, Jakub Kicinski wrote:
>> On Mon, 10 Jun 2019 18:02:29 +0200, Björn Töpel wrote:
>>> Jakub, what's your thoughts on the special handling of XDP offloading?
>>> Maybe it's just overkill? Just allocate space for the offloaded
>>> program regardless support or not? Also, please review the
>>> dev_xdp_support_offload() addition into the nfp code.
>> 
>> I'm not a huge fan of the new approach - it adds a conditional move,
>> dereference and a cache line reference to the fast path :(
>> 
>> I think it'd be fine to allocate entries for all 3 types, but the
>> potential of slowing down DRV may not be a good thing in a refactoring
>> series.
>> 
>
> Note, that currently it's "only" the XDP_SKB path that's affected, but
> yeah, I agree with out. And going forward, I'd like to use the netdev
> xdp_prog from the Intel drivers, instead of spreading/caching it all over.
>
> I'll go back to the drawing board. Any suggestions on a how/where the
> program should be stored in the netdev are welcome! :-) ...or maybe just
> simply store the netdev_xdp flat (w/o the additional allocation step) in
> net_device. Three programs and the boolean (remove the num_progs).

This seems reasonable to me (and thanks for keeping at this!).

-Toke
