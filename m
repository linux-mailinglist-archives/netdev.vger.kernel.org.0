Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1454A3B2EBD
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFXMTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhFXMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:19:16 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBAFC061756
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:16:56 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id n20so8186977edv.8
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yru6qO3uNfoV6ZaOmQ8qR3DaA3zrVIIYTFs9OwyJkqg=;
        b=sPebBxDfKas2SvIim9TRmv7FIZM+qmir94ue78Zc7CB7oSdkyqsixvTNhHh0o9DB9o
         4tvZaawZCW47kAo+3E0qTEDvD9g8naeQORdcQHd4g1u99DYgHDsESxZz9uHjYmYTifTd
         yXmKlLgSf0zMrF4hY4wcL3JwY7uNmQa9sz9AxMnrHVUPTP4VBlRsmON9gJ6FH6/ocxqP
         3ui39XwOgtXraIh4/jPtAt4oMsda6fRIXCRLLgWk+b8ef1CVxAGe6TNm4rQLCI9yYc+i
         QO0WwsTLP7Ne2nZJdVvOLq+x/vwG08zDIzBm4LPQpisCAFVn2oCFGp8XOypR5dCm9jLH
         5XGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yru6qO3uNfoV6ZaOmQ8qR3DaA3zrVIIYTFs9OwyJkqg=;
        b=d5p4pJe3s3h50KZ5OP6KrxBnsMp2geR2RrG6nJXLkgGwsvSI5vlE6Tvi2khIbivnNX
         93/STPETUEe9PLuxF+FK9UqxaGI5Qh7vBJOO93kbLwdRaCRNoZUpG1f2jRQDV4tRh0ja
         QM4aWgp1WV0ajPxftPEwH14+lPvuVP4JU8lZAWQyMKXEaVvpZ9yAujZvhpZZbDOaSe1l
         iWaG5VGO8SuiwahnfQLawSINsl7mQsrauRuV0hLLuOMQ/fcvC1DBvn7GbMVaH5+Y6ut3
         8IGkYTgQ8f6WZASLPOH9D7N2DEGytVLm6Fm1/uyYA5/CLrUiPDsL89NHsPW8IjS3xlZw
         Isyw==
X-Gm-Message-State: AOAM5333lyvOMnDSmm/nt6LTzFJzyj+Fjo1JUyYUd3RXsg73CelFoUTI
        OaawWt3auWAP4eE6oeYaM+8=
X-Google-Smtp-Source: ABdhPJyjx7olX4jRhg79JH6cqEaPqxshbrG6apIcllEC2r2X8sl0SxceAx2lhgGuCNT1cPq8SjEtzA==
X-Received: by 2002:a50:fb81:: with SMTP id e1mr6494358edq.108.1624537015353;
        Thu, 24 Jun 2021 05:16:55 -0700 (PDT)
Received: from [192.168.1.24] ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id gv20sm1142977ejc.23.2021.06.24.05.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 05:16:54 -0700 (PDT)
Subject: Re: [PATCH net] dev_forward_skb: do not scrub skb mark within the
 same name space
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        liran.alon@oracle.com, shmulik.ladkani@gmail.com,
        daniel@iogearbox.net
References: <20210624080505.21628-1-nicolas.dichtel@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Message-ID: <ad019c34-6b18-9bd8-047f-6688cc4a3b8b@gmail.com>
Date:   Thu, 24 Jun 2021 15:16:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210624080505.21628-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicholas,

On 24/06/2021 11:05, Nicolas Dichtel wrote:
> The goal is to keep the mark during a bpf_redirect(), like it is done for
> legacy encapsulation / decapsulation, when there is no x-netns.
> This was initially done in commit 213dd74aee76 ("skbuff: Do not scrub skb
> mark within the same name space").
> 
> When the call to skb_scrub_packet() was added in dev_forward_skb() (commit
> 8b27f27797ca ("skb: allow skb_scrub_packet() to be used by tunnels")), the
> second argument (xnet) was set to true to force a call to skb_orphan(). At
> this time, the mark was always cleanned up by skb_scrub_packet(), whatever
> xnet value was.
> This call to skb_orphan() was removed later in commit
> 9c4c325252c5 ("skbuff: preserve sock reference when scrubbing the skb.").
> But this 'true' stayed here without any real reason.
> 
> Let's correctly set xnet in ____dev_forward_skb(), this function has access
> to the previous interface and to the new interface.

This change was suggested in the past [1] and I think one of the main 
concerns was breaking existing callers which assume the mark would be 
cleared [2].

Personally, I think the suggestion made in [3] adding a flag to 
bpf_redirect() makes a lot of sense for this use case.

Eyal.

[1] 
https://lore.kernel.org/netdev/1520953642-8145-1-git-send-email-liran.alon@oracle.com/

[2] https://lore.kernel.org/netdev/20180315112150.58586758@halley/

[3] 
https://lore.kernel.org/netdev/cd0b73e3-2cde-1442-4312-566c69571e8a@iogearbox.net/


> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>   include/linux/netdevice.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5cbc950b34df..5ab2d1917ca1 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4114,7 +4114,7 @@ static __always_inline int ____dev_forward_skb(struct net_device *dev,
>   		return NET_RX_DROP;
>   	}
>   
> -	skb_scrub_packet(skb, true);
> +	skb_scrub_packet(skb, !net_eq(dev_net(dev), dev_net(skb->dev)));
>   	skb->priority = 0;
>   	return 0;
>   }
> 
