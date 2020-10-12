Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD8828AED6
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgJLHMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgJLHMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:12:30 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864D8C0613CE;
        Mon, 12 Oct 2020 00:12:30 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kRs0E-003ynD-Pd; Mon, 12 Oct 2020 09:12:14 +0200
Message-ID: <c310818ecec06fe34d535bb61f3a50a1cf669f40.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aleksandr Nogikh <a.nogikh@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Date:   Mon, 12 Oct 2020 09:12:13 +0200
In-Reply-To: <20201007101726.3149375-2-a.nogikh@gmail.com> (sfid-20201007_121758_030318_946D6CEB)
References: <20201007101726.3149375-1-a.nogikh@gmail.com>
         <20201007101726.3149375-2-a.nogikh@gmail.com>
         (sfid-20201007_121758_030318_946D6CEB)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-07 at 10:17 +0000, Aleksandr Nogikh wrote:
> 
> @@ -904,6 +905,10 @@ struct sk_buff {
>  	__u16			network_header;
>  	__u16			mac_header;
>  
> +#ifdef CONFIG_KCOV
> +	u64			kcov_handle;
> +#endif
[...] 

> @@ -233,6 +233,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  	skb->end = skb->tail + size;
>  	skb->mac_header = (typeof(skb->mac_header))~0U;
>  	skb->transport_header = (typeof(skb->transport_header))~0U;
> +	skb_set_kcov_handle(skb, kcov_common_handle());

Btw, you're only setting this here. It seems to me it would make sense
to copy it when the skb is copied, rather than then having it set to the
kcov handle of the (interrupted) task that was copying the skb?

johannes

