Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D91C9570A3
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfFZSee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:34:34 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33699 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfFZSee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:34:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so2551446qkc.0
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 11:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bUsYiNyoZNoL9lby/1FtByidZxf9m7iN70pAJQ8cHC0=;
        b=r5VP+hiPFDl1KT2oQBakfOd9mxdQI719XRPTQTYuuG50ZfGHKYHwHjMUsKt7nA5WaF
         Ml3W+oex9LoGShtNebp+J8L3h3magpWY/DRmg1RCloe8suDVfKtVUzyNNZlNq473kJHC
         28/KogVtHOP+FFbELPKWmrtSdx7SmbT6FKEtEsaqXVGH167iyJ73yvx8Wy9Hl585WwpP
         DvFfZtVg8v/Wqd9rGYl1mN55dTe/HeWcIcawx0FeA3GTlmyNBEjPYjMkZfyuznbFHM/O
         e59KtZnF3mQHBm9Ytx+AZb8EzpmC3YGuRJhGqQYl3uobg4plf1R6FzAO0DuczDGM1B2b
         fR2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bUsYiNyoZNoL9lby/1FtByidZxf9m7iN70pAJQ8cHC0=;
        b=ltwdl4NGhDQxZEK0JSZdn1/X7WeBdY8oPJWeAZcz616BV2w5Ss3zHc7qz9w4ymP5oG
         bn7ZHh/KvguIm2wgvshVr/RO8YtVD9OYyg0WCwofIBUsNfb56RToJ78qmAXTaoly0RbG
         8OgqhBywIXDaGmkigvwf37PmenfBWLtI2SPJxn4+AimvWhOz8JVflS7s8R+D0aFlj6Ce
         i0553yYKSYD7USos46r546zVjRalOESo4uwSZm1qP2GOdkSE8ZRqbzYin7OgFQ7nu9d3
         nawGNzuREDrNDcoSUYI6xDfGVR7jHTVSbw0MVLpX8JkCb6NvC/M7IAReld7/34W73Mb4
         1HRw==
X-Gm-Message-State: APjAAAWSTaVRLQC4RYk8TNzNnChT83UABr3sye4wq/UFf4Zkoayk4CeW
        ZEmTR+VvbIt2ZKsLawTRpxxnHA==
X-Google-Smtp-Source: APXvYqwIjRK9ufTFUbOfPl6WKlxXXjYaqCKV8dx/pdoLrLKTUftM+rSEze3dcL/V4SGGMeFv9RhVsQ==
X-Received: by 2002:a05:620a:1497:: with SMTP id w23mr5125682qkj.49.1561574072737;
        Wed, 26 Jun 2019 11:34:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d17sm8220627qtp.84.2019.06.26.11.34.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 11:34:32 -0700 (PDT)
Date:   Wed, 26 Jun 2019 11:34:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v4 2/2] xdp: fix hang while unregistering device
 bound to xdp socket
Message-ID: <20190626113427.761cc845@cakuba.netronome.com>
In-Reply-To: <20190626181515.1640-3-i.maximets@samsung.com>
References: <20190626181515.1640-1-i.maximets@samsung.com>
        <CGME20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826@eucas1p1.samsung.com>
        <20190626181515.1640-3-i.maximets@samsung.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 21:15:15 +0300, Ilya Maximets wrote:
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 267b82a4cbcf..56729e74cbea 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -140,34 +140,38 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
>  	return err;
>  }
>  
> -static void xdp_umem_clear_dev(struct xdp_umem *umem)
> +void xdp_umem_clear_dev(struct xdp_umem *umem)
>  {
> +	bool lock = rtnl_is_locked();

How do you know it's not just locked by someone else?  You need to pass
the locked state in if this is called from different paths, some of
which already hold rtnl.

Preferably factor the code which needs the lock out into a separate
function like this:

void __function()
{
	do();
	the();
	things();
	under();
	the();
	lock();
}

void function()
{
	rtnl_lock();
	__function();
	rtnl_unlock();
}

>  	struct netdev_bpf bpf;
>  	int err;
>  
> +	if (!lock)
> +		rtnl_lock();

