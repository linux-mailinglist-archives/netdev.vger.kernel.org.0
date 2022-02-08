Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDB04ACF0B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345469AbiBHCkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346016AbiBHCkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:40:20 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A83DC061355;
        Mon,  7 Feb 2022 18:40:06 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id om7so1658145pjb.5;
        Mon, 07 Feb 2022 18:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=86PbrZKbZvLla8kmVYV+8hVSLQZGTzn/6xh5EbYOAj4=;
        b=fcR2K65BIaGAKiryhCoJh/eGKykysyx/7VBsPrAt9DVxhQqqgUizS4IL/QxjqQuY53
         XYdv3YMOccCLt8wImkU5xPlHfo/++sQvdAufd/A6RFnjURFxxp7mFvzp5ry9atiLrsRK
         BdXSWB6IxNsx/XUA0Cy8PqHfZMOimpIVQgw4BarMS/HZ/wIohaD/usv0jZP2WmlNym/b
         PCrZw50zAXxEFEGIwBoO/OkYHjbLCqYn83XxhQTcgnLDUZCq9GrzKsBD3B7W3NHFN55d
         SzRVhpz+xLNzOwPMtOaa5grGp7LrDC6oEsUQ7Zcn2wxVsTmq3+9WE21hxQtt56Ux+dsy
         99fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=86PbrZKbZvLla8kmVYV+8hVSLQZGTzn/6xh5EbYOAj4=;
        b=PT+FPLUGl7EiTPK1RDZ3lnvoOftCsVeECIcwOLKRpFNwAoYw0hwpBMnGyNvGK3PGpL
         2puJWWOyJHKv+3t7VoZV7UOhRk/pXM/A4MNPAAkPrkYE/Ogu59QxefHqF6EdjBr3EJND
         7iMuzwPgpdUg89532AbNBxPdOQT/+t185FD0rSrVBBeOv+U+k68glWu8+DsxjYraTvDQ
         cdacjm4QqrL5Zmnjgm7YM9l9t1z+W0VvFxebD8vTwzoZOT65L68hfRJcIVmJm31Ll6cV
         j4omW1OaDv4632SNz2hdYNr8BW+P4OQyusGL8mvLoFb7G0HdWy/Hy3ZGk4tjt1XSbTXM
         cwdg==
X-Gm-Message-State: AOAM533S3PDivWDMzjQsFn9ZLg/l+NNYAgjd/OnzMOQ4GtLKpUu76H8L
        ylOstTECEtJL3vyXDWWAxrknX3bQ9cYZuGRx+r8=
X-Google-Smtp-Source: ABdhPJyV012NbxVh/J9M5daJXHmHwJBOHf9FFPsYK2o7fmjuwGkJzXawQ44kZCYOWDBLeUkqHfA6woRW8D0ouQFdz78=
X-Received: by 2002:a17:902:ced1:: with SMTP id d17mr2360713plg.78.1644288005882;
 Mon, 07 Feb 2022 18:40:05 -0800 (PST)
MIME-Version: 1.0
References: <705a05194508bc0c1b0c1a5de081bbb60f2693a5.1643712078.git.lorenzo@kernel.org>
In-Reply-To: <705a05194508bc0c1b0c1a5de081bbb60f2693a5.1643712078.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Feb 2022 18:39:54 -0800
Message-ID: <CAADnVQJoWF8co=9YNdvQkziwsOAoqw=p134aHTL9YZ82=QJcRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net: veth: account total xdp_frame len running ndo_xdp_xmit
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 2:46 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce xdp_get_frame_len utility routine to get the xdp_frame full
> length and account total frame size running XDP_REDIRECT of a
> non-linear xdp frame into a veth device.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c |  4 ++--
>  include/net/xdp.h  | 14 ++++++++++++++
>  2 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 354a963075c5..22ecaf8b8f98 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -493,7 +493,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>                 struct xdp_frame *frame = frames[i];
>                 void *ptr = veth_xdp_to_ptr(frame);
>
> -               if (unlikely(frame->len > max_len ||
> +               if (unlikely(xdp_get_frame_len(frame) > max_len ||
>                              __ptr_ring_produce(&rq->xdp_ring, ptr)))
>                         break;

Looks correct, but could you explain what happens without this fix?

Any other drivers might have the same issue?
