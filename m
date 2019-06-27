Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32F157D34
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 09:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfF0Hfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 03:35:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37893 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0Hfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 03:35:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id z75so608829pgz.5
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 00:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=isaddB2dV/danigkEPRlGFl03+dV2SB22i5ULSWOieo=;
        b=Malj30vGtmw1NQgwxG/5EGgLF8vDYEKIVVM+rYLfb7s7I86ZxgGHmPqreVcuyO3MP5
         dCpFpWzBGEllUfvbn+4KKZNFvrQMquz1SqfCwR74RfwZVRKZpxa+V+sYYtQprPvAhUFk
         o9MLIC+BDX+zpR/97z1IPQK0M1aOwpbG8Za3MUGY/qIXiQ76ZAAVoSq8Z3+OzmnLTHWg
         ukw8VE0pxmEiD9fKlhWcgF2XwvFpnpvQ30AM0EMuUflcB24s7Ln6j620oV8loRYzqkki
         /TapMQbX4wYvkKUDn6EZo9fErAOUOvEXRe3LNDZorsRsAtptPftHr1sQ0v3Dh6F/WsMO
         payw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=isaddB2dV/danigkEPRlGFl03+dV2SB22i5ULSWOieo=;
        b=HwCbGvZfDeHPAFJXyokzPPiVcBghjhJ/A5JzmnpczjKuWO3xqRzGsKOZ7qjkdhC+Re
         fQkrLGHMAkMvRCBLid1FrEcMtKo544KBATeBb7xtO1pmTB9zroRBlktyQqcWQLRmeBPA
         rG6gmwJevLmGepmWzFMsRby93GzNzOvQNvLasjHobaVMUuy3zIOf7w2eej1oXXQsqRHr
         Tu087OGRI7e7X4npWcYjL38vdeG7HeHyLQtItDiRciGAo19h1B9BArcJ1pM9aEsfEfNU
         kWyQskQZCoKbze6wWerwzwVEeK+EnPoxzLCEdlRacS/qE77PNvhVAseyF4O/KyqorXr+
         4SaA==
X-Gm-Message-State: APjAAAUp+Pb1xJ65RrI9BgErmq0ujgXTHqm3xSq3dIrTi23ShJKYeYdv
        nYrTRIe0WQNQFT4C2VJXm80=
X-Google-Smtp-Source: APXvYqwFqOnErREfwpj9uLiLig43n/qxRcongdw4MrRT4mg/QdnaDepv+A4Hbjf147Sn/bwFzzCqvw==
X-Received: by 2002:a17:90a:3724:: with SMTP id u33mr4252899pjb.19.1561620935651;
        Thu, 27 Jun 2019 00:35:35 -0700 (PDT)
Received: from localhost.localdomain (osnfw.sakura.ad.jp. [210.224.179.167])
        by smtp.gmail.com with ESMTPSA id g14sm1864447pgn.8.2019.06.27.00.35.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 00:35:34 -0700 (PDT)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     jasowang@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, mst@redhat.com
Subject: Re: [PATCH bpf-next] virtio_net: add XDP meta data support in receive_small()
Date:   Thu, 27 Jun 2019 16:35:29 +0900
Message-Id: <20190627073529.25341-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <74dc4919-cf27-b058-5996-5af4d9acbd77@redhat.com>
References: <74dc4919-cf27-b058-5996-5af4d9acbd77@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> This adds XDP meta data support to the code path receive_small().
>>
>> mrg_rxbuf=off is required on qemu, because receive_mergeable() still
>> doesn't support XDP meta data.
>
>
>What's the reason for this?

I didn't have enough time to add support XDP meta data to
receive_mergeable(). But I'll try it a little more. Please wait for the
next patch.

>>
>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
>
>
>Could you please cc virtio maintainer through get_maintainer.pl?
>
>Thanks

Sorry. I added them.

Thanks.

> ---
>   drivers/net/virtio_net.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4f3de0ac8b0b..14165c5edb7d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -644,6 +644,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	unsigned int delta = 0;
>   	struct page *xdp_page;
>   	int err;
> +	unsigned int metasize = 0;
>   
>   	len -= vi->hdr_len;
>   	stats->bytes += len;
> @@ -683,8 +684,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   
>   		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>   		xdp.data = xdp.data_hard_start + xdp_headroom;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end = xdp.data + len;
> +		xdp.data_meta = xdp.data;
>   		xdp.rxq = &rq->xdp_rxq;
>   		orig_data = xdp.data;
>   		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -695,9 +696,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   			/* Recalculate length in case bpf program changed it */
>   			delta = orig_data - xdp.data;
>   			len = xdp.data_end - xdp.data;
> +			metasize = xdp.data - xdp.data_meta;
>   			break;
>   		case XDP_TX:
>   			stats->xdp_tx++;
> +			xdp.data_meta = xdp.data;
>   			xdpf = convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
>   				goto err_xdp;
> @@ -735,11 +738,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	}
>   	skb_reserve(skb, headroom - delta);
>   	skb_put(skb, len);
> -	if (!delta) {
> +	if (!delta && !metasize) {
>   		buf += header_offset;
>   		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>   	} /* keep zeroed vnet hdr since packet was changed by bpf */
>   
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);
> +
>   err:
>   	return skb;
>   

