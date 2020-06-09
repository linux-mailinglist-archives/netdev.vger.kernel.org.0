Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3591F4188
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 18:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbgFIQ5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 12:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731061AbgFIQ5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 12:57:07 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB69C05BD1E;
        Tue,  9 Jun 2020 09:57:07 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m81so23586783ioa.1;
        Tue, 09 Jun 2020 09:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5gvAS0s0tNpovI3i50BhHwoc6p3AStdG8TOtuxWup4w=;
        b=tMvNXNJopze0GqB5+EV+ftXRCWZBeAN6qu2GK8i13KXAnv+Byi7F93Bd+iVyKjBUNo
         hO9yhQtuT1sdzfHnZpuAfXsSNp+c2JhctcoXr5c2mXRhl8+CBg7Jx8OWxFccaBI9KnxL
         n2zqtjPDI5jwAFxNGB+OAWeU37COAvNIPl1jgVqy8mCiYJ1WIGtOBZIzQtOFBKDnY+Ah
         LCoH04OVGWmsD1y+/oKEc4h5p65ORFlJfEnUghZAySAR8HtYygyTr/+mqjzSeFClHedW
         wPAfikhEOotImnatbJaqQxq83Lf0sPc2zTERq0g1Dn//WhxPvQxFdGuY1T4cz2GBOwpr
         UM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5gvAS0s0tNpovI3i50BhHwoc6p3AStdG8TOtuxWup4w=;
        b=JJ9118HRxq49XaFOzBSaLzdvW5wuKw7rkjw/L5ajSATmr/FsWJiXq/p8RgJWJvbZVA
         YW4jqh1zNXOU0SXRvq5K0m0VGqJvlVIDSiRWUHNYb2Hcoceg1WgBZ4X8TXHHPTthpSjQ
         kxhsv19NZtafnpr8lE0N5QhYMRw2WOs4yRx/Rb/jGQKI2XhZmSCNHSAhY1tnaCRL2WDH
         mc6Gza0e8JmiTDjQgRDtUdc1homko5Jhc43ZshmVY0vc8T2fIIe3xGnJcHT+XDrmV6+/
         0jB9zBfWxDOfCCO/6ppKTyxWeD9gXUhsRorHKkP7JjeZUn8ShSF/VzZjhmccBDdqQb12
         WDQg==
X-Gm-Message-State: AOAM532Pikm+PT2FhTtSlMoJAX6hiKftLvIdRZ6OCO0pPs8bAPWpE3eF
        XdN3on/nzIm+RXEjWjnAyUQ=
X-Google-Smtp-Source: ABdhPJxzfFNX5iPi6sdKo+Si6me8KJa4LoBVF4M8+UTrToEsXFwUCXTJ4+2Cezd7q2X79o0KK+1RsQ==
X-Received: by 2002:a02:84c6:: with SMTP id f64mr27190470jai.25.1591721826490;
        Tue, 09 Jun 2020 09:57:06 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n7sm6721682ile.76.2020.06.09.09.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 09:57:05 -0700 (PDT)
Date:   Tue, 09 Jun 2020 09:56:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Message-ID: <5edfbf58f0ff1_5cca2af6a27f45b8fc@john-XPS-13-9370.notmuch>
In-Reply-To: <20200607205229.2389672-2-jakub@cloudflare.com>
References: <20200607205229.2389672-1-jakub@cloudflare.com>
 <20200607205229.2389672-2-jakub@cloudflare.com>
Subject: RE: [PATCH bpf 1/2] bpf, sockhash: Fix memory leak when unlinking
 sockets in sock_hash_free
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> When sockhash gets destroyed while sockets are still linked to it, we will
> walk the bucket lists and delete the links. However, we are not freeing the
> list elements after processing them, leaking the memory.
> 
> The leak can be triggered by close()'ing a sockhash map when it still
> contains sockets, and observed with kmemleak:
> 
>   unreferenced object 0xffff888116e86f00 (size 64):
>     comm "race_sock_unlin", pid 223, jiffies 4294731063 (age 217.404s)
>     hex dump (first 32 bytes):
>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>       81 de e8 41 00 00 00 00 c0 69 2f 15 81 88 ff ff  ...A.....i/.....
>     backtrace:
>       [<00000000dd089ebb>] sock_hash_update_common+0x4ca/0x760
>       [<00000000b8219bd5>] sock_hash_update_elem+0x1d2/0x200
>       [<000000005e2c23de>] __do_sys_bpf+0x2046/0x2990
>       [<00000000d0084618>] do_syscall_64+0xad/0x9a0
>       [<000000000d96f263>] entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Fix it by freeing the list element when we're done with it.
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 00a26cf2cfe9..ea46f07a22d8 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1031,6 +1031,7 @@ static void sock_hash_free(struct bpf_map *map)
>  			sock_map_unref(elem->sk, elem);
>  			rcu_read_unlock();
>  			release_sock(elem->sk);
> +			sock_hash_free_elem(htab, elem);
>  		}
>  	}
>  
> -- 
> 2.25.4
> 

In Cilium we pin the map and never release it thanks for catching this.

Acked-by: John Fastabend <john.fastabend@gmail.com>
