Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A81325A03
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhBYXBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhBYXBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 18:01:09 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFF4C061786
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:00:29 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id r17so11560291ejy.13
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9zey+LJfi/2FRo+ImE/FeTGyZYUKqRghbB3AG3wek6g=;
        b=gwubIks0rvk18cAQ/JcHFU8XbPEo6v2SN8Ud2XFb9vOY1cyQ/gT/wMKIA6MymYP6V7
         VOtaMmAa5BgSccN7xmJA9Z03R5wntlJbvec7SD6RmLEAEKcsDj1xFcGrz+YlmVWFZq8l
         dErznVyFypmNr0W5HYLl/3lQs/mE7SMlYek6wBTh5E7+OvcSzCWWGh2PjdfZZPSkqd3a
         pNvSBqwqW86aCf1RSZij/lZs7LJpZI9EpeQQ174inxELFQHcIY4atFpUQP5baUjIInYI
         Ic+DTd9QaJbOzRrYgJqF7JBAh0zBj7JqqM0dcLqO6rRHwXAFqi213zna76idPcEZXJE/
         hWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9zey+LJfi/2FRo+ImE/FeTGyZYUKqRghbB3AG3wek6g=;
        b=CS/jFQxQqfY3Oj+skm2XMFq6j335Iip42jXUI3mFq+4bo2L+NBQIAHS894BJVkqxKP
         6BXe6oghMWNokQSKgSkj9iJhtDHYufhN+nhf2ayneJukj9zwrDUCaFg86NLDMB4bdcFd
         1azoGKLpyHFTbaY0Pd+YL45nPzj7Kv/OCcfiHVA6OwK8mNbf6P9OUPlXYx9RJ/Q2WZYm
         Q833at3+vS7xM8FvrMxuPTpnlQK4QbHQo/wtsOLDAeid/sPQIxNNi5KsdJHcwzNBs03G
         jT2uDKWTxtcvUZjtHTp/BDV7SI3KZH4bZYadM95woQlOHSMmV5x3TrT1dN48Cb8eUiOE
         ckEQ==
X-Gm-Message-State: AOAM532HY8sFAKfVkL19L5H/zyWJ4NVr5naO5JYhjuJK+9sOeym/M4xB
        diAVNLeVNuMeZIMzS6OUQE8=
X-Google-Smtp-Source: ABdhPJyINgODOFm08ncqCTxjY/i5QMwIKy5r/aUW4pkagMpN2uJF1kHoae0+EszR0704AQFeWmWkmA==
X-Received: by 2002:a17:906:3e42:: with SMTP id t2mr4970862eji.554.1614294027836;
        Thu, 25 Feb 2021 15:00:27 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id s15sm3882165ejy.68.2021.02.25.15.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 15:00:27 -0800 (PST)
Date:   Fri, 26 Feb 2021 01:00:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 3/6] net: enetc: take the MDIO lock only once per
 NAPI poll cycle
Message-ID: <20210225230026.gvtm3esbmrfb5dk5@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-4-olteanv@gmail.com>
 <YDgqI8eGDpJKxiLY@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDgqI8eGDpJKxiLY@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 11:52:19PM +0100, Andrew Lunn wrote:
> On Thu, Feb 25, 2021 at 02:18:32PM +0200, Vladimir Oltean wrote:
> > @@ -327,8 +329,8 @@ static void enetc_get_tx_tstamp(struct enetc_hw *hw, union enetc_tx_bd *txbd,
> >  {
> >  	u32 lo, hi, tstamp_lo;
> >  
> > -	lo = enetc_rd(hw, ENETC_SICTR0);
> > -	hi = enetc_rd(hw, ENETC_SICTR1);
> > +	lo = enetc_rd_hot(hw, ENETC_SICTR0);
> > +	hi = enetc_rd_hot(hw, ENETC_SICTR1);
> >  	tstamp_lo = le32_to_cpu(txbd->wb.tstamp);
> >  	if (lo <= tstamp_lo)
> >  		hi -= 1;
> 
> Hi Vladimir
> 
> This change is not obvious, and there is no mention of it in the
> commit message. Please could you explain it. I guess it is to do with
> enetc_get_tx_tstamp() being called with the MDIO lock held now, when
> it was not before?

I realize this is an uncharacteristically short commit message and I'm
sorry for that, if needed I can resend.

Your assumption is correct, the new call path is:

enetc_msix
-> napi_schedule
   -> enetc_poll
      -> enetc_lock_mdio
      -> enetc_clean_tx_ring
         -> enetc_get_tx_tstamp
      -> enetc_clean_rx_ring
      -> enetc_unlock_mdio

The 'hot' accessors are for normal, 'unlocked' register reads and
writes, while enetc_rd contains enetc_lock_mdio, followed by the actual
read, followed by enetc_unlock_mdio.

The goal is to eventually get rid of all the _hot stuff and always take
the lock from the top level, this would allow us to do more register
read/write batching and that would amortize the cost of the locking
overall.
