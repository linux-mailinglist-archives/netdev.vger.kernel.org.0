Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4CE433AD3
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhJSPls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJSPlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 11:41:47 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C326EC06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 08:39:34 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id z11so8435127lfj.4
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 08:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=0VpfFN+eClDHTCsrtIrkOfvztFLiCLmZKgP0eUDDWzA=;
        b=jnXyynF8MstVlmz/y/8VBFvR8ltAzMbJTV9n6gApK8VxImgwGLDb7Y4sFQdhdfqikz
         MtmH+Zm23LoTu4uvdOlViqlgVnNSaN/d2zZJLdvMOhQdKy+7nQBntJnFVW5ZMEr2N9me
         dpVtTnqp7MVClO3qKuqd3MbxptezGhZk/BJWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=0VpfFN+eClDHTCsrtIrkOfvztFLiCLmZKgP0eUDDWzA=;
        b=JlJpNIoruegusi8RrUE+OqU25TrZ994wlO17sLcUsTZX4oDAQ6yyM2phOGUpHapd38
         GSPQeNyEiTjLt0dTOjpfyWMZNeGWGB9E6iLBpC2NrGJsptQZ162h92U0Z4ApV0my3m5D
         RdPhjCBKffpimQF/OcP0qH2O6ZmYCxcnr+NOqaaXYjUwewZwfh0SkD1jIJDENI1+hNpl
         dtxnZDToN+vjBXgRssrDQdFFUqtDhu+P7duJ5V3yOW7pkDii2A8H7XIjz+iDfYsLCitW
         lEs56P6X5gTcLL56HwakLdZJp9ou/rQZ4/sEnkskvn1dRgoEr+8/rXoPGCOyG3nFfitT
         k5vg==
X-Gm-Message-State: AOAM530XZKSXQpvSw2mip4KSALjwzUWH1jJiEmgcLpYnuICsI0o0o+pc
        9DCkayDadFWWHHNygCZMYTLGPA==
X-Google-Smtp-Source: ABdhPJyXGlUj4iXGhOSh8+9ntzzCtyogpER73ImUnpNVm1Hp0xsvvSPN+awnVHbRXTEjs1jMOnk0/w==
X-Received: by 2002:a05:6512:e96:: with SMTP id bi22mr6654111lfb.156.1634657973073;
        Tue, 19 Oct 2021 08:39:33 -0700 (PDT)
Received: from cloudflare.com (2a01-110f-480d-6f00-ff34-bf12-0ef2-5071.aa.ipv6.supernova.orange.pl. [2a01:110f:480d:6f00:ff34:bf12:ef2:5071])
        by smtp.gmail.com with ESMTPSA id w16sm1699194lfl.189.2021.10.19.08.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:39:32 -0700 (PDT)
References: <20211011191647.418704-1-john.fastabend@gmail.com>
 <20211011191647.418704-4-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH bpf 3/4] bpf: sockmap, strparser, and tls are reusing
 qdisc_skb_cb and colliding
In-reply-to: <20211011191647.418704-4-john.fastabend@gmail.com>
Date:   Tue, 19 Oct 2021 17:39:32 +0200
Message-ID: <87r1chf2h7.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 09:16 PM CEST, John Fastabend wrote:
> Strparser is reusing the qdisc_skb_cb struct to stash the skb message
> handling progress, e.g. offset and length of the skb. First this is
> poorly named and inherits a struct from qdisc that doesn't reflect the
> actual usage of cb[] at this layer.
>
> But, more importantly strparser is using the following to access its
> metadata.
>
> (struct _strp_msg *)((void *)skb->cb + offsetof(struct qdisc_skb_cb, data))
>
> Where _strp_msg is defined as,
>
>  struct _strp_msg {
>         struct strp_msg            strp;                 /*     0     8 */
>         int                        accum_len;            /*     8     4 */
>
>         /* size: 12, cachelines: 1, members: 2 */
>         /* last cacheline: 12 bytes */
>  };
>
> So we use 12 bytes of ->data[] in struct. However in BPF code running
> parser and verdict the user has read capabilities into the data[]
> array as well. Its not too problematic, but we should not be
> exposing internal state to BPF program. If its really needed then we can
> use the probe_read() APIs which allow reading kernel memory. And I don't
> believe cb[] layer poses any API breakage by moving this around because
> programs can't depend on cb[] across layers.
>
> In order to fix another issue with a ctx rewrite we need to stash a temp
> variable somewhere. To make this work cleanly this patch builds a cb
> struct for sk_skb types called sk_skb_cb struct. Then we can use this
> consistently in the strparser, sockmap space. Additionally we can
> start allowing ->cb[] write access after this.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface"
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/net/strparser.h   | 16 +++++++++++++++-
>  net/core/filter.c         | 22 ++++++++++++++++++++++
>  net/strparser/strparser.c | 10 +---------
>  3 files changed, 38 insertions(+), 10 deletions(-)
>
> diff --git a/include/net/strparser.h b/include/net/strparser.h
> index 1d20b98493a1..bec1439bd3be 100644
> --- a/include/net/strparser.h
> +++ b/include/net/strparser.h
> @@ -54,10 +54,24 @@ struct strp_msg {
>  	int offset;
>  };
>
> +struct _strp_msg {
> +	/* Internal cb structure. struct strp_msg must be first for passing
> +	 * to upper layer.
> +	 */
> +	struct strp_msg strp;
> +	int accum_len;
> +};
> +
> +struct sk_skb_cb {
> +#define SK_SKB_CB_PRIV_LEN 20

Nit: Would consider reusing BPF_SKB_CB_LEN from linux/filter.h.
net/bpf/test_run.c should probably use it too, instead of
QDISC_CB_PRIV_LEN.

> +	unsigned char data[SK_SKB_CB_PRIV_LEN];
> +	struct _strp_msg strp;
> +};
> +
>  static inline struct strp_msg *strp_msg(struct sk_buff *skb)
>  {
>  	return (struct strp_msg *)((void *)skb->cb +
> -		offsetof(struct qdisc_skb_cb, data));
> +		offsetof(struct sk_skb_cb, strp));
>  }
>
>  /* Structure for an attached lower socket */

[...]

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
