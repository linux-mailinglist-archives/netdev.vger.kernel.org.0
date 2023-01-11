Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09D2665DA3
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbjAKOWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjAKOWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:22:45 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836DD5F44
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:22:44 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id a25so6672940qto.10
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VVjhSFOKYk8lj7tH/HeB64jnnMWr5QkaCoMuZrz43To=;
        b=g2QzgZz/DzKGQ8EI25LuA0BU5rCetVPOHMJ1+wt2gas6RLGcthahZbNTFmAxpkP4SA
         0xSIAoapI2uDD9sbW3DwBwiHsmPBBCVDX565OyMkT6WDjbB09ESfYamD9VtQevwx5OTz
         H+mO8lfAKJHwZU4HJWpduCZab2S0CzMafLFfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VVjhSFOKYk8lj7tH/HeB64jnnMWr5QkaCoMuZrz43To=;
        b=1KraPSn7d+zXsLhn+rFpaCG5FpYwC6EVjqBCKZX8Z2QnyZIt697ig3vBv+Fjz2TV1r
         bUkZR2o3K+dJtUjctbOfTLSWQC7RT0MhOUW0eSxHEmmCg/URVhmvrxLbRAtoWak6o5w1
         8pTsnL8FEjb4WryZSypCEU/I4tXdq3+8uoZ5CUNsDuFna5nDBqAsjiVDwoTcqdSL8W0o
         t0QEa0HvpAb6wowvH2P6y330PPg1RdaWq/QLukXkRRX/brK9cC11l7yOaHwEgBhhm8ce
         0kj3c9FcH1U3dWb2nYSk1fx/RFpRKvVJqCxi87j2ItGygHfzgLjoP3SSLHP3GFsniba5
         YScg==
X-Gm-Message-State: AFqh2kpjmiRdbl/f8XOY9CShzt/KntonQitTVPMsSQakL0lS302og1FS
        RcVMNlhTs3i+jhwpudNSL87Nyg==
X-Google-Smtp-Source: AMrXdXsLgjfrxzET0DaHvCzLcqKkpiPl9UVmjTQSwnf794+HqY5p1b7IUSMTWfuwFbAREiWSyytYSA==
X-Received: by 2002:a05:622a:229f:b0:3a7:f552:fd5f with SMTP id ay31-20020a05622a229f00b003a7f552fd5fmr98034520qtb.50.1673446963580;
        Wed, 11 Jan 2023 06:22:43 -0800 (PST)
Received: from C02YVCJELVCG ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id r3-20020ac84243000000b003a5430ee366sm7580243qtm.60.2023.01.11.06.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 06:22:43 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Wed, 11 Jan 2023 09:22:40 -0500
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, somnath.kotur@broadcom.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com
Subject: Re: [PATCH net] bnxt: make sure we return pages to the pool
Message-ID: <Y77GMD58O1CktpI+@C02YVCJELVCG>
References: <20230111042547.987749-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111042547.987749-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 08:25:47PM -0800, Jakub Kicinski wrote:
> Before the commit under Fixes the page would have been released
> from the pool before the napi_alloc_skb() call, so normal page
> freeing was fine (released page == no longer in the pool).
> 
> After the change we just mark the page for recycling so it's still
> in the pool if the skb alloc fails, we need to recycle.
> 
> Same commit added the same bug in the new bnxt_rx_multi_page_skb().

Good catch, thank you.

> Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>

> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 16ce7a90610c..240a7e8a7652 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -993,7 +993,7 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
>  			     DMA_ATTR_WEAK_ORDERING);
>  	skb = build_skb(page_address(page), PAGE_SIZE);
>  	if (!skb) {
> -		__free_page(page);
> +		page_pool_recycle_direct(rxr->page_pool, page);
>  		return NULL;
>  	}
>  	skb_mark_for_recycle(skb);
> @@ -1031,7 +1031,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
>  
>  	skb = napi_alloc_skb(&rxr->bnapi->napi, payload);
>  	if (!skb) {
> -		__free_page(page);
> +		page_pool_recycle_direct(rxr->page_pool, page);
>  		return NULL;
>  	}
>  
> -- 
> 2.38.1
> 
