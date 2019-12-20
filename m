Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95294127F37
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfLTPZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:25:50 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42599 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfLTPZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:25:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id q6so9763686wro.9
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8AlMHrnt5j2O7L0nLGMRj+HqWQpFgZlURgZ6FS/M2fI=;
        b=et6DfNEkjfMYotL/5O6TDVh8Q2NuWIWkWuDqybFSii1euBOlxmDpDIRiJ/TLstk9ot
         +2pFXp8n2rpMnnb3N4OcekYSkskalCy278K7Hz0Bv/u3RsAkR4jne3tCTr4lh6GU07kw
         jeHen/4OMYLfIMK1aW/LfZOYwZK1Ub6t2Vr7qePIdxFfzgmFddrMNKgNHeE3lZ4msHgz
         0+CUB+H22T4HkYSH6U3pDXogjkouwvetKtgbijxu/lonQQSLRKztD1eWR7gOrJBwRENk
         jZ6AYxIFMFACwgJ2vEpISAfCr65lFnauJlwmhvz0BFdrsekDZCrXGSboS2wBv7twvXeo
         /F5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8AlMHrnt5j2O7L0nLGMRj+HqWQpFgZlURgZ6FS/M2fI=;
        b=ocf4nmHciOZ/DiKIERIW1ggqiW0PhDN2bVLBYtmUvl84wlmQjmxXxRx1Qjas9MbPJ5
         mOKlFzbtOtHa3N6sfcJ3mzFlJLtZAJTlGe/2lyaQM5L3Fk+SwHZGl5vLbn210AWMd84G
         h+3Lxc75t20V+hSesuPge8mCoqyAer+R/ZmGDsaSZZ1HvCm8yVSKw1ZVMV5cRVyUAdlK
         CC0F4XNnzeBhpSdJU8r8G68uV8/pjmukpfzeAYkShqOPi/Sh8JnZB8sd/oE6hs1sy7O2
         vbBxKecoCviA9c1CJZ+hso/gk+NgHdqpLrWOKj/vMQFAO+0fiRKgfAranT6KCVS7qX8+
         7/aQ==
X-Gm-Message-State: APjAAAXILhbyicNsXoi2jIGoqxvQZp9FFyQRHH6OOYt5+pPV2X1TgFac
        fbiKjV9zk920nxzikCRLVK7oq45U
X-Google-Smtp-Source: APXvYqzcWwQZj2Eseai3HpTSrzi0Puo3lfG1V4ZrDVTymg3DaOVl5ujypu2Bueg+b6j9zzp8P6VS5A==
X-Received: by 2002:a5d:6886:: with SMTP id h6mr3706352wru.154.1576855548226;
        Fri, 20 Dec 2019 07:25:48 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id s1sm10136537wmc.23.2019.12.20.07.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:25:47 -0800 (PST)
Subject: Re: [PATCH net-next v5 07/11] tcp: coalesce/collapse must respect
 MPTCP extensions
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-8-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <90c0c531-45e4-4937-552a-898aff733756@gmail.com>
Date:   Fri, 20 Dec 2019 07:25:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-8-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> Coalesce and collapse of packets carrying MPTCP extensions is allowed
> when the newer packet has no extension or the extensions carried by both
> packets are equal.
> 
> This allows merging of TSO packet trains and even cross-TSO packets, and
> does not require any additional action when moving data into existing
> SKBs.
> 
> v3 -> v4:
>  - allow collapsing, under mptcp_skb_can_collapse() constraint
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  include/net/mptcp.h   | 54 +++++++++++++++++++++++++++++++++++++++++++
>  include/net/tcp.h     |  8 +++++++
>  net/ipv4/tcp_input.c  | 11 ++++++---
>  net/ipv4/tcp_output.c |  2 +-
>  4 files changed, 71 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> index f9f668ac4339..8e27e33861ab 100644
> --- a/include/net/mptcp.h
> +++ b/include/net/mptcp.h
> @@ -8,6 +8,7 @@
>  #ifndef __NET_MPTCP_H
>  #define __NET_MPTCP_H
>  
> +#include <linux/skbuff.h>
>  #include <linux/types.h>
>  
>  /* MPTCP sk_buff extension data */
> @@ -24,4 +25,57 @@ struct mptcp_ext {
>  			__unused:2;
>  };
>  
> +#ifdef CONFIG_MPTCP
> +
> +/* move the skb extension owership, with the assumption that 'to' is
> + * newly allocated
> + */
> +static inline void mptcp_skb_ext_move(struct sk_buff *to,
> +				      struct sk_buff *from)
> +{
> +	if (!skb_ext_exist(from, SKB_EXT_MPTCP))
> +		return;
> +
> +	if (WARN_ON_ONCE(to->active_extensions))
> +		skb_ext_put(to);
> +
> +	to->active_extensions = from->active_extensions;
> +	to->extensions = from->extensions;
> +	from->active_extensions = 0;
> +}
> +
> +static inline bool mptcp_ext_matches(const struct mptcp_ext *to_ext,
> +				     const struct mptcp_ext *from_ext)
> +{
> +	return !from_ext ||
> +	       (to_ext && from_ext &&
> +	        !memcmp(from_ext, to_ext, sizeof(struct mptcp_ext)));

There is a hole at the end of struct mptcp_ext

How is it properly cleared/initialized so that the memcmp() wont
spuriously fail ?

Thanks.
