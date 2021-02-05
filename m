Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D195311A01
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhBFD0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhBFCbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:31:08 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE428C061A29
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:09:59 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id p21so12009718lfu.11
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=jmGXHQUmQpAWVkJNjCjHIBvNfS+bVsNdamwSZyWJ9hQ=;
        b=UYNp5O2uhSo8+t5FUschnhV7fdDEnITHjDKEU0qx5toTh1batiQEbthkcmsfQoRdWG
         lpTcFXWdfBXYZOuc7HdorpWfNVrAbz1+oTgy/uiGCmPmlwkM1yPgBLCXM9RuWVvmcWoA
         0HKR6D3fz6wqKE6F3vsdKwBaGLQyVh3IV1LLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=jmGXHQUmQpAWVkJNjCjHIBvNfS+bVsNdamwSZyWJ9hQ=;
        b=RiCMdB32VKt9NGwL56H1lFrADafl0R2MmXIRiHkN2gLU6T7ZWvMhBeksfoZyOB2TPk
         UucF42zouAjua5IJM4emQiqcrrukF1SvDuqf714lBfv35hK1a3z0w3o0Nk4IYnAMVORH
         F6HfSNCPnxujG4PfMH8RHuSKGSpag45cQ2jnn1xkG2XQz82V1unsLf9jB1H8ixaujPyY
         c5cZ98dUp+szdmmZ4oWA73+03PaD1r4vRD2TZuJMxP8UbauZYfFrGbd6jLUkRJk3/KE5
         K1OQuTBRjmzVzRuA3ppzvTw9brMyHxcGdXrYFecfM0RzpPfUBwXkEIVuBTGW9KJpV/cM
         4T4g==
X-Gm-Message-State: AOAM531yhdD+rR2GI7qlE7qP8l+dFttYa4G0OGi+RDc2cCen3bVfiQmV
        bHUWT+Ne2KWKSsdQOIJRuHMF8wEpsy4cLOlk
X-Google-Smtp-Source: ABdhPJyvlv2XAUi5Zf5ph+86/M4hTEfki19S/ShaItnk7uD+cnn23Pcy3syVC70j86UecKAgi2BFSg==
X-Received: by 2002:ac2:4ade:: with SMTP id m30mr3838822lfp.231.1612562998326;
        Fri, 05 Feb 2021 14:09:58 -0800 (PST)
Received: from cloudflare.com (83.24.202.200.ipv4.supernova.orange.pl. [83.24.202.200])
        by smtp.gmail.com with ESMTPSA id k19sm1109424lfm.204.2021.02.05.14.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:09:57 -0800 (PST)
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-4-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next 03/19] skmsg: use skb ext instead of TCP_SKB_CB
In-reply-to: <20210203041636.38555-4-xiyou.wangcong@gmail.com>
Date:   Fri, 05 Feb 2021 23:09:56 +0100
Message-ID: <87eehu4157.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 05:16 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> won't work for any other non-TCP protocols. We can move them to
> skb ext instead of playing with skb cb, which is harder to make
> correct.
>
> Of course, except ->data_end, which is used by
> sk_skb_convert_ctx_access() to adjust compile-time constant offset.
> Fortunately, we can reuse the anonymous union where the field
> 'tcp_tsorted_anchor' is and save/restore the overwritten part
> before/after a brief use.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skbuff.h |  4 ++++
>  include/linux/skmsg.h  | 45 ++++++++++++++++++++++++++++++++++++++++++
>  include/net/tcp.h      | 25 -----------------------
>  net/Kconfig            |  1 +
>  net/core/filter.c      |  3 +--
>  net/core/skbuff.c      |  7 +++++++
>  net/core/skmsg.c       | 44 ++++++++++++++++++++++++++++-------------
>  net/core/sock_map.c    | 12 +++++------
>  8 files changed, 94 insertions(+), 47 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 46f901adf1a8..12a28268233a 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -755,6 +755,7 @@ struct sk_buff {
>  			void		(*destructor)(struct sk_buff *skb);
>  		};
>  		struct list_head	tcp_tsorted_anchor;
> +		void			*data_end;
>  	};

I think we can avoid `data_end` by computing it in BPF with the help of
a scratch register. Similar to how we compute skb_shinfo(skb) in
bpf_convert_shinfo_access(). Something like:

static struct bpf_insn *bpf_convert_data_end_access(const struct bpf_insn *si,
						    struct bpf_insn *insn)
{
	/* dst_reg = skb->data */
	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data),
			      si->dst_reg, si->src_reg,
			      offsetof(struct sk_buff, data));
	/* AX = skb->len */
	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
			      BPF_REG_AX, si->src_reg,
			      offsetof(struct sk_buff, len));
	/* dst_reg = skb->data + skb->len */
	*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
	/* AX = skb->data_len */
	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data_len),
			      BPF_REG_AX, si->src_reg,
			      offsetof(struct sk_buff, data_len));
	/* dst_reg = skb->data + skb->len - skb->data_len */
	*insn++ = BPF_ALU64_REG(BPF_SUB, si->dst_reg, BPF_REG_AX);

	return insn;
}

[...]
