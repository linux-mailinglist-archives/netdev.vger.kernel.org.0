Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C641458D7B
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 12:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbhKVLfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 06:35:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234460AbhKVLfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 06:35:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637580753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/pufuvQskF86JYzssHCod6YRuNZuBqOlpULETTw23vY=;
        b=BbO8iKH04M6gvaEhA8k69olPrwe5Zu6fPO92r4A2FSPvsU9CV+5WvW/nj6KAq8RrEwvrGG
        SRdwMH+puMfhjbHn5Nd2LhWQ6g0O3AoxwS9GfABnL8IBNv8tVVLMbVKN3N7apNlyY9fQ9A
        gtnQSXXhM23lIQ9HogXx+Z3pLwMeLxY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-IQHwqYpXP4uKmCKRfm4W4Q-1; Mon, 22 Nov 2021 06:32:32 -0500
X-MC-Unique: IQHwqYpXP4uKmCKRfm4W4Q-1
Received: by mail-ed1-f70.google.com with SMTP id m12-20020a056402430c00b003e9f10bbb7dso7107073edc.18
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 03:32:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/pufuvQskF86JYzssHCod6YRuNZuBqOlpULETTw23vY=;
        b=hZVAl3b08syQ9vN/xMj6Ow6vxrbXwqXs/x4gfIL401vZeOC6VvGBz8kCOoDdXl9Bev
         c88DotZOM0dPXff3lyahLhFEBjU5v494I38vgTBCtvMJX/JKF2u1g3VW/V4otIJjFrKN
         0/zv9Sirg7lZ8N49gZpvFH+1+xM7F9Ofa6WtVa3v9uUUFR3vX1g6uHGliPorZkdT5fec
         txEn0ynLBD25y9tLsMKk/lpT3oyEOO2D6uIt89kLrIKXarNMm/kuTc+c6CEpZ31FT6+L
         Eb5lV/300/AEm3m9glyLv9CNAzlUzObHY0/TM8SHaHIhBjGliFxdRgfPsm8X1aqjWDnr
         r6wA==
X-Gm-Message-State: AOAM531KnKBcZGuAP0zDy/LFUe4vKemV33Sgu2gQcHV0S2kmdgaz9dlB
        v5uAnQ+4w91AvV+yuDa+CRKMwH1Z2bLWznmKq6vnT+ubOJR41P4PbWL1+YrAnLfDloG0lJJ+8Ed
        8TeSOpMmAKfrbd00H
X-Received: by 2002:a17:906:7954:: with SMTP id l20mr38134958ejo.143.1637580751392;
        Mon, 22 Nov 2021 03:32:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwIKLScWKAjQMXV19k9+SN1VMh0eLEA874Q0zRJn7WySvpxfQ9SzSHT5daY7nWzCjPTl8vMrw==
X-Received: by 2002:a17:906:7954:: with SMTP id l20mr38134895ejo.143.1637580751010;
        Mon, 22 Nov 2021 03:32:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id qf9sm3703046ejc.18.2021.11.22.03.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 03:32:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D0EE6180270; Mon, 22 Nov 2021 12:32:29 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
In-Reply-To: <2d7cdef73ce22021ee8ce40feeb9f084af066cea.1637339774.git.pabeni@redhat.com>
References: <cover.1637339774.git.pabeni@redhat.com>
 <2d7cdef73ce22021ee8ce40feeb9f084af066cea.1637339774.git.pabeni@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 22 Nov 2021 12:32:29 +0100
Message-ID: <87tug4cto2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You still have:

> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 585b2b77ccc4..f7359bcb8fa3 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -195,7 +195,7 @@ static void cpu_map_bpf_prog_run_skb(struct bpf_cpu_map_entry *rcpu,
>  			}
>  			return;
>  		default:
> -			bpf_warn_invalid_xdp_action(act);
> +			bpf_warn_invalid_xdp_action(skb->dev, rcpu->prog, act);
>  			fallthrough;
>  		case XDP_ABORTED:
>  			trace_xdp_exception(skb->dev, rcpu->prog, act);
> @@ -254,7 +254,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
>  			}
>  			break;
>  		default:
> -			bpf_warn_invalid_xdp_action(act);
> +			bpf_warn_invalid_xdp_action(xdpf->dev_rx, rcpu->prog, act);
>  			fallthrough;
>  		case XDP_DROP:
>  			xdp_return_frame(xdpf);
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f02d04540c0c..79bcf2169881 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -348,7 +348,7 @@ static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
>  				frames[nframes++] = xdpf;
>  			break;
>  		default:
> -			bpf_warn_invalid_xdp_action(act);
> +			bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
>  			fallthrough;
>  		case XDP_ABORTED:
>  			trace_xdp_exception(dev, xdp_prog, act);
> @@ -507,7 +507,7 @@ static u32 dev_map_bpf_prog_run_skb(struct sk_buff *skb, struct bpf_dtab_netdev
>  		__skb_push(skb, skb->mac_len);
>  		break;
>  	default:
> -		bpf_warn_invalid_xdp_action(act);
> +		bpf_warn_invalid_xdp_action(dst->dev, dst->xdp_prog, act);
>  		fallthrough;
>  	case XDP_ABORTED:
>  		trace_xdp_exception(dst->dev, dst->xdp_prog, act);

... and ...

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 3ba584bb23f8..658f7a84d9bc 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8179,13 +8179,13 @@ static bool xdp_is_valid_access(int off, int size,
>  	return __is_valid_xdp_access(off, size);
>  }
>  
> -void bpf_warn_invalid_xdp_action(u32 act)
> +void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
>  {
>  	const u32 act_max = XDP_REDIRECT;
>  
> -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
> +	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
>  		     act > act_max ? "Illegal" : "Driver unsupported",
> -		     act);
> +		     act, prog->aux->name, prog->aux->id, dev->name);
>  }
>  EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);

This will still print the dev name for cpumap and devmap programs, which
is misleading - it will have people looking at the drivers when the
problem is somewhere else.

I pointed this out multiple times in comments on your last revision so
I'm a bit puzzled as to why you're still doing this? :/

Just pass NULL as the dev from cpumap/devmap and don't print the dev
name in this case...

-Toke

