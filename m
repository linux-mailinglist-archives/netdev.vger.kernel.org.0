Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4BA413C6EB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAOPFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:05:50 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53652 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgAOPFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:05:50 -0500
Received: by mail-wm1-f68.google.com with SMTP id m24so212763wmc.3;
        Wed, 15 Jan 2020 07:05:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l+nye/BYJZe7Bw5ayLtgP5rQcdwwOtxIDTaqQZhLPlA=;
        b=fxPwCbf7o6eRSxDsdLOZOY2y1q4AzpyRri/fv5lTTVSF+o/dMqz8jWR9BRrEOfH1eu
         DO+zVbUv0FXYN0GuzqZmKGt3jgHKEqs7Pown8WpH07MATd3YDUiqe02Y755WyFmsz1gD
         SJc3nPEE33yYSf1JGN/jn/WARmyRwW5au9E2Dr3eTBXspQnsumpFY3WaCuYs1YAxmwOw
         956D3IxoBt28Prux3NFBnhStwQxcqXdsUQaO4Jdl9WClw3r++aSwaiGl9XvZYa+/j1OP
         8HHPucwk8h50qNM6UNGlGQ0r8BvKTDQW/Z5zeoBliGb1qR4KDCmMX1XTzKjZ+kTpRJcG
         wMMg==
X-Gm-Message-State: APjAAAVpp5a3QpLbo46knyJvDTUQFTKV/oOLuU31jbB1sti7GYIAW5DF
        hRexBjJRezOxiLcvP1zo4AI=
X-Google-Smtp-Source: APXvYqztGYFP1LUF57lEbPErN/f7VP1qI9rU2yAcdmhylE8alEK9YH4yvGaqdMcNcSqYuH4XY8iHQg==
X-Received: by 2002:a1c:dc08:: with SMTP id t8mr173641wmg.139.1579100748472;
        Wed, 15 Jan 2020 07:05:48 -0800 (PST)
Received: from debian (41.142.6.51.dyn.plus.net. [51.6.142.41])
        by smtp.gmail.com with ESMTPSA id r62sm148422wma.32.2020.01.15.07.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 07:05:47 -0800 (PST)
Date:   Wed, 15 Jan 2020 15:05:45 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     madhuparnabhowmik04@gmail.com
Cc:     wei.liu@kernel.org, paul@xen.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@kernel.org, joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: xen-netback: hash.c: Use built-in RCU list checking
Message-ID: <20200115150545.j5gu7lm3l3ouv7l4@debian>
References: <20200115141840.10553-1-madhuparnabhowmik04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115141840.10553-1-madhuparnabhowmik04@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 07:48:40PM +0530, madhuparnabhowmik04@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
> 
> list_for_each_entry_rcu has built-in RCU and lock checking.
> Pass cond argument to list_for_each_entry_rcu.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>

You seem to have dropped the second hunk which modified
xenvif_flush_hash, is that a mistake?

Wei.

> ---
>  drivers/net/xen-netback/hash.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/xen-netback/hash.c b/drivers/net/xen-netback/hash.c
> index 10d580c3dea3..3f9783f70a75 100644
> --- a/drivers/net/xen-netback/hash.c
> +++ b/drivers/net/xen-netback/hash.c
> @@ -51,7 +51,8 @@ static void xenvif_add_hash(struct xenvif *vif, const u8 *tag,
>  
>  	found = false;
>  	oldest = NULL;
> -	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
> +	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
> +				lockdep_is_held(&vif->hash.cache.lock)) {
>  		/* Make sure we don't add duplicate entries */
>  		if (entry->len == len &&
>  		    memcmp(entry->tag, tag, len) == 0)
> -- 
> 2.17.1
> 
