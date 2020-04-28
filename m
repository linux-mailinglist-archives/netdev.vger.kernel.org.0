Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09251BBACB
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 12:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgD1KIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 06:08:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35110 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgD1KIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 06:08:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id x18so23919443wrq.2;
        Tue, 28 Apr 2020 03:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wYqrGMV+EWFYnxIHszXLpHDlpZ5ax2djYBoiPCdGZtM=;
        b=FOMkBhjc+5vrsgWg9fhi5Dv5RuAa37x1j2mwA+nnb9CPpeBZ4Mdps+M4OjTPmilIOj
         uFUdrMTZ4FUbagGDIYGq+Zubw8Eqt96HWfmmX5uka9YkO5knZaiVcfWMYDW/AxCqOyn8
         4sFt8xMXxzt0VryUw5XGJ+GsA3CZyLxCzKkfcV24zEZOBIGawfndeAL0hoMAW8OpGmcJ
         uuLwKIhBfwbtnySTT+ucl4IVGbLBaGBJEWv0BZColnfJOphPjevlnz1aeoPgqbAV6UMN
         +qYQ+0LqXFRVpDXTx/1kI0vLsFxwTzBxaIrMw5a8xs1cx65bBz3DrX9AyXQ/uos/CVl9
         INeQ==
X-Gm-Message-State: AGi0PuaS5btYfaCzKH8Og0eXKNdIswcV1ghh48k5tl4ELrkkjwLWwLCl
        TTNrG8zAazVnuCI2tDDTSDgKEJMH
X-Google-Smtp-Source: APiQypJ4xBgFV3si14qsdmuXSYJOafatBduuvUuwZF2JwDOEJMghZx1A4ojKnwlMtXWN0req9V5K6g==
X-Received: by 2002:a5d:498d:: with SMTP id r13mr33647675wrq.374.1588068510619;
        Tue, 28 Apr 2020 03:08:30 -0700 (PDT)
Received: from liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id x6sm27382925wrg.58.2020.04.28.03.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 03:08:29 -0700 (PDT)
Date:   Tue, 28 Apr 2020 10:08:28 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] hv_netvsc: Fix netvsc_start_xmit's return type
Message-ID: <20200428100828.aslw3pn5nhwtlsnt@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
References: <20200428033042.44561-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428033042.44561-1-natechancellor@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 08:30:43PM -0700, Nathan Chancellor wrote:
> netvsc_start_xmit is used as a callback function for the ndo_start_xmit
> function pointer. ndo_start_xmit's return type is netdev_tx_t but
> netvsc_start_xmit's return type is int.
> 
> This causes a failure with Control Flow Integrity (CFI), which requires
> function pointer prototypes and callback function definitions to match
> exactly. When CFI is in enforcing, the kernel panics. When booting a
> CFI kernel with WSL 2, the VM is immediately terminated because of this:
> 
> $ wsl.exe -d ubuntu
> The Windows Subsystem for Linux instance has terminated.
> 
> Avoid this by using the right return type for netvsc_start_xmit.
> 
> Fixes: fceaf24a943d8 ("Staging: hv: add the Hyper-V virtual network driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1009

Please consider pulling in the panic log from #1009 to the commit
message. It is much better than the one line message above.

> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
> 
> Do note that netvsc_xmit still returns int because netvsc_xmit has a
> potential return from netvsc_vf_xmit, which does not return netdev_tx_t
> because of the call to dev_queue_xmit.
> 
> I am not sure if that is an oversight that was introduced by
> commit 0c195567a8f6e ("netvsc: transparent VF management") or if
> everything works properly as it is now.
> 
> My patch is purely concerned with making the definition match the
> prototype so it should be NFC aside from avoiding the CFI panic.
> 
>  drivers/net/hyperv/netvsc_drv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index d8e86bdbfba1e..ebcfbae056900 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -707,7 +707,8 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
>  	goto drop;
>  }
>  
> -static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> +static netdev_tx_t netvsc_start_xmit(struct sk_buff *skb,
> +				     struct net_device *ndev)
>  {
>  	return netvsc_xmit(skb, ndev, false);
>  }
> 
> base-commit: 51184ae37e0518fd90cb437a2fbc953ae558cd0d
> -- 
> 2.26.2
> 
