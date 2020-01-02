Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49AA12E66E
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 14:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgABNR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 08:17:57 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54600 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgABNR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 08:17:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id b19so5524771wmj.4
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 05:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hawhjNiJ/P79hKzWcmaJdlHIUC7w8b7FnaJnaYV/IhQ=;
        b=m0qtGKkAxiESycxU4uEA7li79m43xdWtygX/F5YbPk24ASPP9lPctyyh4ZxdZFpBcP
         P8eBvIgnUIdHrhuSxjGeEVAU94G+CEQtWzgGGNUueYWefeoqVExOVKzrX4VY2JOrnrAw
         Uu/C5wUrU+bxUjORl16n5tCoKx+dbmtyMketmTlINCWqTFy7yx02cgWFsZGY4A4zZUY5
         WYhyvgNePq9Mw+mfCF4dwQte3I0fC/f6HPWepEisp5GhgJpf/aOO0zl3bXAsg5AiNyjI
         Iv18tMiBoOrlCICiivyj3BHKtRDCSJMRZ6gNNiKE6XD4KW5MVQH7LLNnVG9q2/m6CIcx
         LN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hawhjNiJ/P79hKzWcmaJdlHIUC7w8b7FnaJnaYV/IhQ=;
        b=j+KH8lBUDc5X82or5pQNvDeFFRYnhbzAhZD1y9TvcMDC5Oya9iUekDbGqz5OokQN+x
         +Dn9s8L5FjdpHSdTzU04Y63CeiiBDMzPQZm8ejibLN1eH3j8qv5C491nGTgk/IXdum/A
         i7dJKL6uDk7oNtMH3BpQNKmYoOCRgN0UapXB9gh+ULKlDQQfa+ATHtzajuK2Gku09Pll
         G7ix7y7BtBt3HoUJwMiA6ykdD+WMaiH69Y+XaajBihtpwJK1aYfmfrEhLPezjo6v7509
         iY4Sr4aQGkPpcWZC0DuyHsr/1QSmtbpeRJPO4S2/b5dha63KX9m7iGn78M4NumQK8EEo
         PkFQ==
X-Gm-Message-State: APjAAAWMUtJyLFar6poVVLEAUp8sZqnqxE8lTjsCy7yjIN7lWjL7T+wI
        Le7zEikcxk+v6D+mzPblzikjJvJ8
X-Google-Smtp-Source: APXvYqz9qQ7WqTgXpv7Y44lYkfznkB2S2ySi/g8b6qFS9jwrgik9umMgcjltJgz+SdYLqoTYGajLqw==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr14608753wmg.20.1577971074905;
        Thu, 02 Jan 2020 05:17:54 -0800 (PST)
Received: from [192.168.8.147] (195.171.185.81.rev.sfr.net. [81.185.171.195])
        by smtp.gmail.com with ESMTPSA id z8sm55261828wrq.22.2020.01.02.05.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 05:17:54 -0800 (PST)
Subject: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as
 D-SACK
To:     Pengcheng Yang <yangpc@wangsu.com>, edumazet@google.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <1577699681-14748-1-git-send-email-yangpc@wangsu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <99e34a60-96f9-2984-ab66-6671aa9f654b@gmail.com>
Date:   Thu, 2 Jan 2020 05:17:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1577699681-14748-1-git-send-email-yangpc@wangsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/30/19 1:54 AM, Pengcheng Yang wrote:
> When we receive a D-SACK, where the sequence number satisfies:
> 	undo_marker <= start_seq < end_seq <= prior_snd_una
> we consider this is a valid D-SACK and tcp_is_sackblock_valid()
> returns true, then this D-SACK is discarded as "old stuff",
> but the variable first_sack_index is not marked as negative
> in tcp_sacktag_write_queue().
> 
> If this D-SACK also carries a SACK that needs to be processed
> (for example, the previous SACK segment was lost), this SACK
> will be treated as a D-SACK in the following processing of
> tcp_sacktag_write_queue(), which will eventually lead to
> incorrect updates of undo_retrans and reordering.
> 
> Fixes: fd6dad616d4f ("[TCP]: Earlier SACK block verification & simplify access to them")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_input.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 88b987c..0238b55 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1727,8 +1727,11 @@ static int tcp_sack_cache_ok(const struct tcp_sock *tp, const struct tcp_sack_bl
>  		}
>  
>  		/* Ignore very old stuff early */
> -		if (!after(sp[used_sacks].end_seq, prior_snd_una))
> +		if (!after(sp[used_sacks].end_seq, prior_snd_una)) {
> +			if (i == 0)
> +				first_sack_index = -1;
>  			continue;
> +		}
>  
>  		used_sacks++;
>  	}
> 

Thanks for fixing this.

Signed-off-by: Eric Dumazet <edumazet@google.com>

