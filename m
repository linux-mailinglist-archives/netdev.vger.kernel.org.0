Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C085254DC44
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 09:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359186AbiFPH5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 03:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiFPH5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 03:57:10 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CD45D5FB;
        Thu, 16 Jun 2022 00:57:09 -0700 (PDT)
Received: from [IPV6:2003:e9:d74a:356f:526e:76c5:79f4:ad31] (p200300e9d74a356f526e76c579f4ad31.dip0.t-ipconnect.de [IPv6:2003:e9:d74a:356f:526e:76c5:79f4:ad31])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0BA6BC03F6;
        Thu, 16 Jun 2022 09:57:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1655366228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wnCmQfsGbDJxNGzQYcv47WQM0mnY0aODpCEzh7cafPY=;
        b=B8CMh4FsrcqfTc/dahG+Ch/NcYIWRor+NygafJcd49THF3UZr4xCHtKbtcwrDm6x/13Wzg
        8c32+oPToox9/pWb8PsOf0l4+B3VfxEcu3XBYNqbENPwV2pEompigqilqyfpw8SYhTBPjh
        unDxN0mC+JpA5QmRjtcB3A4vUM3Ob4yjWs3z2WACGkbAAsu54+dtzsHqhYS7WoVedxW6iB
        IeJBoBemBuCQl3cID8tLDkJVnxOa1FcXlGXhvhqXAoVqFHCfKEAwFn44N8AM2P0PpkFPbn
        RHzzIHGnxICdQGXGTVL/9QbUbmbsWIDt0TK6lBlih3HavdY92yY7PkmhdxcEYQ==
Message-ID: <3b7a9363-1fea-d4a3-360d-a2e60b1038c7@datenfreihafen.org>
Date:   Thu, 16 Jun 2022 09:57:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH wpan-next 2/2] 6lowpan: nhc: drop EEXIST limitation
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220613032922.1030739-1-aahringo@redhat.com>
 <20220613032922.1030739-2-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220613032922.1030739-2-aahringo@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Alex.

On 13.06.22 05:29, Alexander Aring wrote:
> In nhc we have compression() and uncompression(). Currently we have a
> limitation that we return -EEXIST when it's the nhc is already
> registered according the nexthdr. But on receiving handling and the
> nhcid we can indeed support both at the same time. 

The sentence above is not really clear to me. Do you want to say that on 
rx we can support more than one nhcid? I am a bit confused why you write 
both here. Where does the limit to two come from?

We remove the current
> static array implementation and replace it by a dynamic list handling to
> get rid of this limitation.
> 
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   net/6lowpan/nhc.c | 69 ++++++++++++++++++++++++++++++-----------------
>   1 file changed, 44 insertions(+), 25 deletions(-)
> 
> diff --git a/net/6lowpan/nhc.c b/net/6lowpan/nhc.c
> index 7b374595328d..3d7c50139142 100644
> --- a/net/6lowpan/nhc.c
> +++ b/net/6lowpan/nhc.c
> @@ -12,13 +12,30 @@
>   
>   #include "nhc.h"
>   
> -static const struct lowpan_nhc *lowpan_nexthdr_nhcs[NEXTHDR_MAX + 1];
> +struct lowpan_nhc_entry {
> +	const struct lowpan_nhc *nhc;
> +	struct list_head list;
> +};
> +
>   static DEFINE_SPINLOCK(lowpan_nhc_lock);
> +static LIST_HEAD(lowpan_nexthdr_nhcs);
> +
> +const struct lowpan_nhc *lowpan_nhc_by_nexthdr(u8 nexthdr)
> +{
> +	const struct lowpan_nhc_entry *e;
> +
> +	list_for_each_entry(e, &lowpan_nexthdr_nhcs, list) {
> +		if (e->nhc->nexthdr == nexthdr &&
> +		    e->nhc->compress)
> +			return e->nhc;

We will always go with the first one we find? Do I miss something or 
does that mean the one registered as seond and above will never be taken 
into acount?

regards
Stefan Schmidt
