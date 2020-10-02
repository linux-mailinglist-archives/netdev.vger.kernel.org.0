Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D9280E58
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 09:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJBH5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 03:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJBH5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 03:57:45 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285AFC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 00:57:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so709839wrm.2
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 00:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=SRXGveSCqcIeGlRzNGJhQXuj5KPhJ5J8Tl3gn8pO5XU=;
        b=OHf/uw7nhtq61usCjWrXEONblxOLb7hLXIJzlgIH/RfojmGBjxnt3QZp2frJpqz9m3
         rzNBuI50zn/KKpo0r9Lg9PLHyB+F+WLiN2qcvBIVyhhKDp8XWy06zSEOgf0QimzaOh1T
         OlMXxd33+eZlS0bBXTLmc4uihu5rDZVg7uYy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=SRXGveSCqcIeGlRzNGJhQXuj5KPhJ5J8Tl3gn8pO5XU=;
        b=PgUwf3bWxM458QETsQnR1QuQMTyfDCIF5e0PKQvD0ELKK6GPtO3lpuziUAVsGbxBCF
         afToAB+biS7lB4OXlkfFoGGB59f087i5pahCNL80HB4NzsAY6LFF70Wsi7zzfDv++xio
         0ikGj1AWHiB9oeOi4WpuNFjHMFm9ACWh1LDK7D1LZSqO6bh6yGBzEGgic0g/Dm/WxXBe
         JhS7t8XVAbO9zH42AXJy54vaTzi90pkhVSEyp4o1Lo0jeM+U+hm2KWsgjPdbh3QhkKo2
         Jw3ifpjt/ZIrMR5ECThpdvoVkSg/gbjWTA1Tc5Zbvs16pdg7R0aNDivPUVVY/LPqsDNO
         hIsw==
X-Gm-Message-State: AOAM531fBnDecP4ED/qMGHzTitman9A/tVjKmkZNwzjHDLR5dISNc3Va
        xgxrRN4LKYDn8Dp05uv+jdW1ppLElp2gQw==
X-Google-Smtp-Source: ABdhPJwihr141xxhZe64KJqeSnXWF9tE4xOJHDrR/b1Jzfw+yXXFFjYDYU5qeKKP/cZuONUCbvX4Jg==
X-Received: by 2002:a5d:530f:: with SMTP id e15mr1479556wrv.51.1601625463839;
        Fri, 02 Oct 2020 00:57:43 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id c16sm863567wrx.31.2020.10.02.00.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 00:57:43 -0700 (PDT)
Date:   Fri, 2 Oct 2020 10:57:42 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: Proper error handing when setting
 pegasus' MAC address
Message-ID: <20201002075742.GA1197@carbon>
Mail-Followup-To: David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
References: <20200929114039.26866-1-petko.manolov@konsulko.com>
 <20201001.184218.21920326424555147.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001.184218.21920326424555147.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-10-01 18:42:18, David Miller wrote:
> From: Petko Manolov <petko.manolov@konsulko.com>
> Date: Tue, 29 Sep 2020 14:40:39 +0300
> 
> > -static void set_ethernet_addr(pegasus_t *pegasus)
> > +static int set_ethernet_addr(pegasus_t *pegasus)
> >  {
> 
> You change this to return an 'int' but no callers were updated to check it.
> 
> Furthermore, failure to probe a MAC address can be resolved by choosing a 
> random MAC address.  This handling is preferrable because it allows the 
> interface to still come up successfully.

Thanks for looking into this.  V2 already sent.
