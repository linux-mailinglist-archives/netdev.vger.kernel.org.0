Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEEA18DC1B
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 00:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCTXfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 19:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTXfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 19:35:17 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0335320714;
        Fri, 20 Mar 2020 23:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584747316;
        bh=rhwn6qeTqAe225E+kLoz/+4Ql4VI3OGBbm8jRVxHZDY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=saJBFcmjrpm5m5RSTNjxDpbEgRDHcUYXF9OLIuCQtJvmxJV4JjjSHJPe1PQESuBuw
         Tk4xSOISYaaqD0cyJQUYg2WrdYwF8wIDRAoVuC6xGgP2eHq7VNWVah2An+g3t1+Yf7
         Zh5jHoxt3kxBCdDaUzrRsGmdbWPtLIViSHulVfs0=
Date:   Fri, 20 Mar 2020 16:35:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200320163514.5f26d547@kicinski-fedora-PC1C0HJN>
In-Reply-To: <3aca04e2-4034-f41a-8e98-f40471601dff@iogearbox.net>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
        <ad09e018-377f-9864-60eb-cf4291f49d41@iogearbox.net>
        <80235a44-8f01-6733-0638-c70c51cd1b90@iogearbox.net>
        <20200320143014.4dde2868@kicinski-fedora-PC1C0HJN>
        <3aca04e2-4034-f41a-8e98-f40471601dff@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 22:55:43 +0100 Daniel Borkmann wrote:
> >> Another aspect that falls into this atomic replacement is also that the programs can
> >> actually be atomically replaced at runtime. Last time I looked, some drivers still do
> >> a down/up cycle on replacement and hence traffic would be interrupted. I would argue
> >> that such /atomic/ swap operation on bpf_link would cover a guarantee of not having to
> >> perform this as well (workaround today would be a simple tail call map as entry point).  
> > 
> > I don't think that's the case. Drivers generally have a fast path
> > for the active-active replace.
> > 
> > Up/Down is only done to remap DMA buffers and change RX buffer
> > allocation scheme. That's when program is installed or removed,
> > not replaced.  
> 
> I know; though it seems not all adhere to that scheme sadly. I don't have that HW so can
> only judge on the code, but one example that looked suspicious enough to me is qede_xdp().
> It calls qede_xdp_set(), which does a qede_reload() for /every/ prog update. The latter
> basically does ...
> 
>      if (edev->state == QEDE_STATE_OPEN) {
>          qede_unload(edev, QEDE_UNLOAD_NORMAL, true);
>          if (args)
>              args->func(edev, args);               <-- prog replace here
>          qede_load(edev, QEDE_LOAD_RELOAD, true);
>          [...]
>      }

Ack, one day maybe we can restructure things enough so that drivers
don't have to copy/paste this dance :(

> ... now that is one driver. I haven't checked all the others (aside from i40e/ixgbe/mlx4/
> mlx5/nfp), but in any case it's also fixable in the driver w/o the extra need for bpf_link.

Agreed
