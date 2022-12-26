Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320DC655FAB
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 05:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiLZEPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 23:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLZEPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 23:15:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1E9272A
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 20:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672028086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Keq1uYKXntFo0IcFGgDhmwnqZ2BFgk2kC5ZO19H78Lg=;
        b=A29iT0ckx1qrZ+RsQRgU5fnvII7kG4vP4fZVTsyKNPJvNKOLIY9dVA45QrQd+1D5WMuWyr
        qg3nmSozvRFEcw7EuZLQNlCvAx59xInivWRSFC7QL6j8KvkgCnTkI6xbUzkzQ/dTQuxzCP
        a5mNx9ofl4vPXRRwR6JpovBSKTRGT4U=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-73-QtbFiE8nNQ6szFVAm1lqGg-1; Sun, 25 Dec 2022 23:14:45 -0500
X-MC-Unique: QtbFiE8nNQ6szFVAm1lqGg-1
Received: by mail-oo1-f70.google.com with SMTP id z18-20020a4a6552000000b004ce83a068c0so2167948oog.8
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 20:14:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Keq1uYKXntFo0IcFGgDhmwnqZ2BFgk2kC5ZO19H78Lg=;
        b=XW5sgr6DenwPSqIVKGZaRX1kfo03UX2SscoLCnc2TOj+K+wVfK99f7vG2beEb+81hu
         k0afWCqHflfexwNl9amZodlxaiEkSfX4QhBtINBHIOj4NKUs7vxaHFyWmfDoFGTSO/h8
         eAIG9dW+q5AZskc5lBJwsMHqEp+TJF/A+joXnm8H9Wxpk5j5tnV4HSiCAvyDSww4Mzxw
         jjqne1vUPfzBam146tr+sRRbWRsKBTu9OGHveOUzqUyBK5lhSZJTPvwmj7l/D4+bE5yF
         wi1te6eGpjv8WFt2YyUT70+Sijhxn9kGi35cbbgOqR52uJgONEs+p6brNQlscpHwyMZb
         /4GA==
X-Gm-Message-State: AFqh2krGYS0oDdI3JZI9BJ5EHRUSlTfC3Zr+R1wI/+75qmzHu0+HZjKn
        jsWLPV4bkelDTVtvVxKZkz6Tx9Dl7W/dQOS4q3MKaOqcm8fwVVWD6982k0RHuBHALAIIwO7Okth
        lx/nR1OvR8EsZ5pr1z8ZAHFMe5z5AVmgd
X-Received: by 2002:a05:6870:3d97:b0:144:b22a:38d3 with SMTP id lm23-20020a0568703d9700b00144b22a38d3mr1116886oab.280.1672028084939;
        Sun, 25 Dec 2022 20:14:44 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv4I8HLM3NWCoAm8B00GNYeHXABaGViRb/z/HiJYr7yvPs3uL9MLXZo4ssD4R6RFNQ510cLp2JsdQXBx94V71s=
X-Received: by 2002:a05:6870:3d97:b0:144:b22a:38d3 with SMTP id
 lm23-20020a0568703d9700b00144b22a38d3mr1116878oab.280.1672028084771; Sun, 25
 Dec 2022 20:14:44 -0800 (PST)
MIME-Version: 1.0
References: <20221220141449.115918-1-hengqi@linux.alibaba.com> <daf585da-ea19-c06f-efba-ec706e9478ff@linux.alibaba.com>
In-Reply-To: <daf585da-ea19-c06f-efba-ec706e9478ff@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 26 Dec 2022 12:14:33 +0800
Message-ID: <CACGkMEu0revrfCL3STA8LPeXxvHtF2AffnEutxBxWqam4qi01g@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] virtio_net: support multi buffer xdp
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 10:33 AM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
>
> Hi Jason, do you have any comments on this?

I will review this no later than the end of this week.

Thanks

>
> Thanks.
>
> =E5=9C=A8 2022/12/20 =E4=B8=8B=E5=8D=8810:14, Heng Qi =E5=86=99=E9=81=93:
> > Changes since RFC:
> > - Using headroom instead of vi->xdp_enabled to avoid re-reading
> >    in add_recvbuf_mergeable();
> > - Disable GRO_HW and keep linearization for single buffer xdp;
> > - Renamed to virtnet_build_xdp_buff_mrg();
> > - pr_debug() to netdev_dbg();
> > - Adjusted the order of the patch series.
> >
> > Currently, virtio net only supports xdp for single-buffer packets
> > or linearized multi-buffer packets. This patchset supports xdp for
> > multi-buffer packets, then larger MTU can be used if xdp sets the
> > xdp.frags. This does not affect single buffer handling.
> >
> > In order to build multi-buffer xdp neatly, we integrated the code
> > into virtnet_build_xdp_buff_mrg() for xdp. The first buffer is used
> > for prepared xdp buff, and the rest of the buffers are added to
> > its skb_shared_info structure. This structure can also be
> > conveniently converted during XDP_PASS to get the corresponding skb.
> >
> > Since virtio net uses comp pages, and bpf_xdp_frags_increase_tail()
> > is based on the assumption of the page pool,
> > (rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag))
> > is negative in most cases. So we didn't set xdp_rxq->frag_size in
> > virtnet_open() to disable the tail increase.
> >
> > Heng Qi (9):
> >    virtio_net: disable the hole mechanism for xdp
> >    virtio_net: set up xdp for multi buffer packets
> >    virtio_net: update bytes calculation for xdp_frame
> >    virtio_net: build xdp_buff with multi buffers
> >    virtio_net: construct multi-buffer xdp in mergeable
> >    virtio_net: transmit the multi-buffer xdp
> >    virtio_net: build skb from multi-buffer xdp
> >    virtio_net: remove xdp related info from page_to_skb()
> >    virtio_net: support multi-buffer xdp
> >
> >   drivers/net/virtio_net.c | 332 ++++++++++++++++++++++++++------------=
-
> >   1 file changed, 219 insertions(+), 113 deletions(-)
> >
>

