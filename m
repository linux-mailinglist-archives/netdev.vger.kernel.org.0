Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37023BA82A
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 11:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhGCJtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 05:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhGCJtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 05:49:52 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9FEC061762;
        Sat,  3 Jul 2021 02:47:18 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id d12so12459869pgd.9;
        Sat, 03 Jul 2021 02:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cKjvdxPILk0jm57SrpZOSRJWB+g7msED20iGZuVWYfc=;
        b=UM3nM1mnsIkJk3aZU+U6uaD+DpDJAJ1EAA6rVOej4EoXVRpl6BHnuRXSCGHqrkDUCR
         tkrH6s5iGqK4qbD+uKvTfvaqgXT8uaVy1WA8oZo6tA4H3ciuhOfsBVGZb3y629yEQcGa
         glZko7THKT4ILDRLHFiILlNIylLaqoYji6U+WgYdqbpqDNiEUnsWrXpWyOwT4OlHCJRQ
         jZGF+xYh0rR81Y8kPpmk63C5I6uy5VoAuSBmwNJqQ0OYCMNEvxWJbPDwJX56Ooud3SSW
         JqOvkWleiEJ1gMTA+vwK2hxDR1JogF5REKENFCEfrEiEuYuBdcBaY+JUGVm7jgrhTMjR
         2FSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cKjvdxPILk0jm57SrpZOSRJWB+g7msED20iGZuVWYfc=;
        b=AvwW12za2IaH+U5eGSH2Hff3dWdiOCy/IlMC/ftFAXL9FuAHwlBrg1PTWe/gclmDhm
         jk1LaWxU+QWhSXnxlI1FNsUskiX7Y2OzXtdAywjGwKptRJQo+JbiWlWIK65JrGQP0iqk
         5YbqcwMS+gNL/8pgwy+UqogC5DgugHJ7HZUgRAKHT2gfL4OUkBnEPXzDENFbQH+TT4Cs
         rGl081PD+QVKlVrTa2Ca69Xz9cCu7nicu3V5TfzAnkT6ru648xMGG6QZYkPZUraNh668
         MvepWrWKIt2EHkKWoDmwTBZ6gwntyxP1JsSJqXDkx6yHcXC/Jdv5wBsKFVniXiaZ+e5L
         xJmA==
X-Gm-Message-State: AOAM530w7rE4VFd2fFfQzEE0X1YCluI4vnRDJblvYV7c1FdAdZPPWOEI
        cEoTGsFjf8Qxo3TnIY8oBug=
X-Google-Smtp-Source: ABdhPJzWZbc3QJSxF/3cevQCljirbSVhS6jQWHBao++lq80I+jwWyNr+3KOTtvMS7jzQlPj6QLT7Ew==
X-Received: by 2002:a62:34c7:0:b029:28e:addf:f17a with SMTP id b190-20020a6234c70000b029028eaddff17amr3976240pfa.62.1625305638150;
        Sat, 03 Jul 2021 02:47:18 -0700 (PDT)
Received: from [192.168.93.106] (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id 199sm5100275pfy.203.2021.07.03.02.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Jul 2021 02:47:17 -0700 (PDT)
Subject: Re: [PATCH v2] tcp: fix tcp_init_transfer() to not reset
 icsk_ca_initialized
To:     Neal Cardwell <ncardwell@google.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
References: <20210702194033.1370634-1-phind.uet@gmail.com>
 <CADVnQynvWsD2qWfw4qJsNhyyPXbFGfhZmhMzaggfJ8JtUUt9VA@mail.gmail.com>
From:   Phi Nguyen <phind.uet@gmail.com>
Message-ID: <f3d57ece-8fc7-f0b1-a675-32cfcd64bdda@gmail.com>
Date:   Sat, 3 Jul 2021 17:47:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CADVnQynvWsD2qWfw4qJsNhyyPXbFGfhZmhMzaggfJ8JtUUt9VA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/2021 4:31 AM, Neal Cardwell wrote:
> Please note that the patchwork tools have found a style/formatting
> issue with your Fixes tag:
> 
> You can find them at:
> https://patchwork.kernel.org/project/netdevbpf/list/
>   ->
>   https://patchwork.kernel.org/project/netdevbpf/patch/20210702194033.1370634-1-phind.uet@gmail.com/
>    ->
>     https://patchwork.hopto.org/static/nipa/510221/12356435/verify_fixes/stdout
> 
> The error is:
> ---
> Fixes tag: Fixes: commit 8919a9b31eb4 ("tcp: Only init congestion control if not
> Has these problem(s):
> - leading word 'commit' unexpected
> - Subject has leading but no trailing parentheses
> - Subject has leading but no trailing quotes
> ---
> 
> Basically, please omit the "commit" and don't wrap the text (it's OK
> if it's longer than 80 or 100 characters).
> 
> thanks,
> neal
> 
Hi,

I didn't even know there are patchwork tools for checking formatting. 
Thank you for pointing out, I have just submitted a new version.

Best regards,
Phi.
