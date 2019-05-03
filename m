Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6F212ED1
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 15:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfECNJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 09:09:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37622 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfECNJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 09:09:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id y5so6717773wma.2
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 06:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L7j18+RjsY3HzKf/ui/Th6lFbzr7ArOBrA+6iSTyXlw=;
        b=cQvDEV+y+GnqznqwA92X5ThG5IfVenurGHr6tEaCz69lw3LuciNqC2WsmUJ7ueJdPq
         ls+i50Z3GV2WaRaDK+frz1xvYheA+Den+r7T9H1ffWO2BYyd2R1hEo9KWbUmD4nCh8h+
         7qHlfF85chSzVO0C9y9wxRbf+yp8r05G8umOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L7j18+RjsY3HzKf/ui/Th6lFbzr7ArOBrA+6iSTyXlw=;
        b=rAu8doKOC94b9DfJR0BE6VQ29CkN5hz6MjiWdnkoeLcZvHrJue5DNcefV5hw92u2hT
         8hLoA1OtAKBNSNegPYkRZE6jpNwnB/NvPkV2MTHDa7NU0beqVMfkLpuFdIWR29DNm1KY
         Ghz3tkmOwQBoBF5ojJjawfjhDWWu4gQ+l3ZjBmvkvaaR3K+v42Pub74tiHaUHaf5XVBP
         hxpmyLVcmfCvbIhExZ24caLUSvIfqJeuCZhO4C7F+QBt+dFvObmW6fGnOp0uspB7zMPk
         7WkZO7R9z7RJvohFCMbMDqxLhlSLLLT5DgLl5+Q00y/IJDQTMzM+SbHZozUHUjeSEUcg
         uLog==
X-Gm-Message-State: APjAAAWL5ZN27j8plPjWf9wGx5fJRm7ZoZa43VrzZ1auMJ2WJ65RnROt
        gxrMxs4OT7UFEOx20I1vYnPM1w==
X-Google-Smtp-Source: APXvYqx+etDE4qv/7wWS7PnUDx3yYN2rpakijyDWd/6S+EfDzsP6a0VXF+TfsSd94BS9uoR4dzYGVQ==
X-Received: by 2002:a1c:1b08:: with SMTP id b8mr6501300wmb.35.1556888963769;
        Fri, 03 May 2019 06:09:23 -0700 (PDT)
Received: from [192.168.51.243] ([93.152.141.58])
        by smtp.gmail.com with ESMTPSA id z74sm12303851wmc.2.2019.05.03.06.09.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 06:09:22 -0700 (PDT)
Subject: Re: [PATCH net-next] ipmr: Do not define MAXVIFS twice
To:     David Ahern <dsahern@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
References: <20190502222326.2298-1-dsahern@kernel.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <74ff659e-45d5-3577-1288-6e3e37dd87c4@cumulusnetworks.com>
Date:   Fri, 3 May 2019 16:09:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502222326.2298-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/05/2019 01:23, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> b70432f7319eb refactored mroute code to make it common between ipv4
> and ipv6. In the process, MAXVIFS got defined a second time: the
> first is in the uapi file linux/mroute.h. A second one was created
> presumably for IPv6 but it is not needed. Remove it and have
> mroute_base.h include the uapi file directly since it is shared.
> 
> include/linux/mroute.h can not be included in mroute_base.h because
> it contains a reference to mr_mfc which is defined in mroute_base.h.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  include/linux/mroute_base.h | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
> index 34de06b426ef..c5a389f81e91 100644
> --- a/include/linux/mroute_base.h
> +++ b/include/linux/mroute_base.h
> @@ -4,6 +4,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/rhashtable-types.h>
>  #include <linux/spinlock.h>
> +#include <uapi/linux/mroute.h>
>  #include <net/net_namespace.h>
>  #include <net/sock.h>
>  #include <net/fib_notifier.h>
> @@ -90,13 +91,6 @@ static inline int mr_call_vif_notifiers(struct net *net,
>  	return call_fib_notifiers(net, event_type, &info.info);
>  }
>  
> -#ifndef MAXVIFS
> -/* This one is nasty; value is defined in uapi using different symbols for
> - * mroute and morute6 but both map into same 32.
> - */
> -#define MAXVIFS	32
> -#endif
> -
>  #define VIF_EXISTS(_mrt, _idx) (!!((_mrt)->vif_table[_idx].dev))
>  
>  /* mfc_flags:
> 

It's in fact a mess, ipv6 defines MAXMIFS (notice the *M*) which must match MAX*V*IFS
due to the MAXVIFS use in ipmr_base for one (possibly other places too).. Maybe this value should be
set on initialization per family in the future because if it gets out of sync between v4 and v6 bad
things will follow. :)

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
