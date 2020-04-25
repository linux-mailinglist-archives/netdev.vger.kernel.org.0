Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740901B82ED
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgDYA6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDYA6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 20:58:53 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBE5C09B049;
        Fri, 24 Apr 2020 17:58:52 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a21so11829718ljb.9;
        Fri, 24 Apr 2020 17:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B5m3h4KSPmhQXvUHT8BFSFk4K0ftCc1eyBumHMrZhDM=;
        b=cnaNtjQsoKEdIYptmkHf3NT1Jo4oslEE00nlcAQ3qiGGG3OneqnnUtYaSPh7CiFEEC
         hRKfi+GodE8c47D+iWjT1srRE8pdqw2id9HciMJgZgerSwU5FlOob9iuX8np9HylQakI
         Cy4MaPM4FQh6br4giHliCkx28JJa0oQSjCdhQDO30ne3KTbFUrSYOFhia3CMRCBxUK6S
         /zcAdNzqtwhlh1d/nUbpIV3k9cH18BUWATojpoeGLW/+BVWJgudhnvS2Ci3AiqMR9sgU
         /X3X8UJ0psL7x+SMcGUFIlEI2I1fdr7WCFww5XOP+Xs8e8y5wgz2X+MNR6+3+ycik4WP
         OPTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B5m3h4KSPmhQXvUHT8BFSFk4K0ftCc1eyBumHMrZhDM=;
        b=Bv+6qqhBNVqB+rSX0WurQbUrbuwNwQ4aKV+5xrsGekVT5xU0J7egRxUPQEY5dKWool
         wDn7FAOLPc3/2rqIoaLOQqea7l94f0MhmckLHEWIBJT34BfgatmOAwhqnO9/aGhiGxBn
         wr4WnqgQkhi3BWqJLLs8GrX75wvfM0znW0849PmopmugGUvTRuKniojOlNPYxOom7uyi
         iqUrWwPSoyDrmskQNzkFeC8gw0dk9NDNt0Z7LdKYrCH4vMFcBGX3ZIY0CsyIjDhUpGe7
         ikN0qUvV8mxwj96nDwx9LL+rSamW1bgvOdUWWzuoZ2fLTsdOsO4//uZDeV8ueKFdj4zC
         1kYg==
X-Gm-Message-State: AGi0PuYsFvBcfwOQqTmo+i8fCfin9fH5PIqiLR1EfDj73uLlXEotvCph
        2h43PbRvckAtEe732wZesI8+kKOc7JiuwSjbiIk=
X-Google-Smtp-Source: APiQypI0rxzJ6V3IXhVd3v1ud91CKuA1ei522eCjmo8Y6A6BiDakTJDtB0cBObTdy5oPYDCeeUlSiDRKuY8/sWbgHpc=
X-Received: by 2002:a2e:990f:: with SMTP id v15mr6553322lji.7.1587776331161;
 Fri, 24 Apr 2020 17:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <158757160439.1370371.13213378122947426220.stgit@firesoul> <158757178332.1370371.3518949026344543513.stgit@firesoul>
In-Reply-To: <158757178332.1370371.3518949026344543513.stgit@firesoul>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Apr 2020 17:58:39 -0700
Message-ID: <CAADnVQ+hmYAJP9W_nwY+21OODxNpbxb8W-6CZaro8eL-fG4mog@mail.gmail.com>
Subject: Re: [PATCH net-next 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, zorik@amazon.com,
        Arthur Kiyanovski <akiyano@amazon.com>, gtzalik@amazon.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 9:09 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> The mlx5 driver have multiple memory models, which are also changed
> according to whether a XDP bpf_prog is attached.
>
> The 'rx_striding_rq' setting is adjusted via ethtool priv-flags e.g.:
>  # ethtool --set-priv-flags mlx5p2 rx_striding_rq off
>
> On the general case with 4K page_size and regular MTU packet, then
> the frame_sz is 2048 and 4096 when XDP is enabled, in both modes.
>
> The info on the given frame size is stored differently depending on the
> RQ-mode and encoded in a union in struct mlx5e_rq union wqe/mpwqe.
> In rx striding mode rq->mpwqe.log_stride_sz is either 11 or 12, which
> corresponds to 2048 or 4096 (MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ).
> In non-striding mode (MLX5_WQ_TYPE_CYCLIC) the frag_stride is stored
> in rq->wqe.info.arr[0].frag_stride, for the first fragment, which is
> what the XDP case cares about.
>
> To reduce effect on fast-path, this patch determine the frame_sz at
> setup time, to avoid determining the memory model runtime. Variable
> is named first_frame_sz to make it clear that this is only the frame
> size of the first fragment.
>
> This mlx5 driver does a DMA-sync on XDP_TX action, but grow is safe
> as it have done a DMA-map on the entire PAGE_SIZE. The driver also
> already does a XDP length check against sq->hw_mtu on the possible
> XDP xmit paths mlx5e_xmit_xdp_frame() + mlx5e_xmit_xdp_frame_mpwqe().
>
> Cc: Tariq Toukan <tariqt@mellanox.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    6 ++++++
>  3 files changed, 8 insertions(+)


Hey mellanox folks,

you had an active discussion regarding mlx5 changes earlier.
Were your concerns resolved ?
If so, could you please ack.
