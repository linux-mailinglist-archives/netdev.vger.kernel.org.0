Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054582B886F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgKRXeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgKRXeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:34:01 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015AAC0613D4;
        Wed, 18 Nov 2020 15:34:01 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f20so5223400ejz.4;
        Wed, 18 Nov 2020 15:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1xsMrKCOLxV9P6mZP+3GBaf95z88hZLl0UpnSDVLBMg=;
        b=H1s+/DzsM/5rYDrY6z3rNfusQOKMDUdgB88vGqvzIucm2I6BgUAMlll98LTx0h0TPw
         9EiQEfkxSiDIZwbHU/UUBzbop99zbjCrnrNvF55EL8bG3gecj3aytBx93yKZRCJYrT8h
         t4i8QL2qtA0furiT+xE8xCFNatnVHfjAd6nRhbnO0roPvE6GH2VnzJMQQar6rRRkx6+/
         jt5BDSuDz6Lr+HqXTwZqW5PPYF0sSdePUQ09uBRq9XUIOtPMsC8hpWpNy4Vg6isY5b9j
         RrFVygq8fAHMmDOu4iN7MQRaQekfNFJQDz8NUAf2/YkBcq+eK6wk69P00+9o+dGNEn2F
         WAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1xsMrKCOLxV9P6mZP+3GBaf95z88hZLl0UpnSDVLBMg=;
        b=dDWjBi2vtYq0y7ivE1KDbAEi2hedaIKT0X3RdG42hrvAJ7DgzsX3kyaRZbdayteSCd
         whVB6ELSKjP/WK06cJJx4u62KwDVdeMmL0dZwp+fiTtOnKvq0nOW/UPHWMS2l+DDyvgE
         dvJR+gMjsfVSA3KWYC29iymVXXxlX6rIkaQ1aILwuNn0Vcv8QXxJ9TkigInTgUNfEpeX
         jIPxr3cXT++t9KPyOb76XZSp7JKwtrTmAJgif68lrij+DyRnZeEo4kre1m5YfEL52DAy
         +nu30T6crqk3EXVnO2FlEYwmAH0BRuS6gVUpiOeUJ/ajBHVsUfFNuPKlIEfKAu1BS1ZX
         P04g==
X-Gm-Message-State: AOAM530mCiCm7vzI/hJ+BmA3Cyfidg5Pf2jGG/9WGE5zWMN1XWQIEvc3
        WalrU2gn5k0fydv9NVXsUCI=
X-Google-Smtp-Source: ABdhPJyYJchJaBRorDVBw19T6dAIC1vEnTHXGhykS9X7YaDZfmFWKNVZ/11PKDCeJJ0E/+vmZGU7nw==
X-Received: by 2002:a17:906:c084:: with SMTP id f4mr12013899ejz.4.1605742439706;
        Wed, 18 Nov 2020 15:33:59 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q19sm13753113ejz.90.2020.11.18.15.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 15:33:58 -0800 (PST)
Date:   Thu, 19 Nov 2020 01:33:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: avoid potential use-after-free error
Message-ID: <20201118233357.ihifojr62ly4pas3@skbuf>
References: <20201118154335.1189-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118154335.1189-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 04:43:35PM +0100, Christian Eggers wrote:
> If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
> immediately. Storing the pointer in DSA_SKB_CB(skb)->clone anyway,
> supports annoying use-after-free bugs.

Like what?

> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Fixes 146d442c2357 ("net: dsa: Keep a pointer to the skb clone for TX timestamping")

Not the right format for a Fixes: tag, please try to set up your
.gitconfig to automate the creation of this tag.
