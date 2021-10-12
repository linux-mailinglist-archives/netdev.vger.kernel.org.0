Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2E542A719
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhJLOZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhJLOZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:25:33 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90576C061570;
        Tue, 12 Oct 2021 07:23:31 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id k3so13349088ilu.2;
        Tue, 12 Oct 2021 07:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FstwrlylmXXyYAH/ZMfEawzvWOnoC9NN9YLbj2XpjB4=;
        b=NULrcCRC3Ys6hj09I/OKFtkg/ckR2GWcENc4WIZI2aHgG2zQitFDw2lmrGIgVkKsUC
         bmFW4vSUMKKKkVeK/QDQmulRQUAAyjDRbQ3M46cLuA3Fe8NW6oT2BICSdCFoYbk5PGay
         vaSQWwVkalh9oyRzgE4vIQKIU3mjPH4XtnDIHyAiRtUCuvRMVQ4JnvYI0+uQ6mjRCCEt
         Ofu1gikiSEBywdCZ/Q8c9whtuTYdLS51Pkdhx7AtqsaUSn8GMzoVZ4NTF22fuesJA8Fu
         KTMyS/NZ4OgNxEhSK7VrqoYz4BzK7RR54NDC652DlUOOWolm86xH+aRSoxbgK9GLd5kG
         vCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FstwrlylmXXyYAH/ZMfEawzvWOnoC9NN9YLbj2XpjB4=;
        b=qiSbg4VZcU6JKARZgtoUrJxjYwYqs/axwp1nKUGfvyt1rrszqRC6ECUIpgLJZVLo2e
         YSYSUc8YMABCpW/LQkk9BrU1XRc6aAkF+4CU7oHgVo4fGhc69MlWX0zX/okbo5xdWkUO
         Q9iKMWHEZLnGJcjkTUv2qqbWNGpDt2yJcLS0f3XI+AJDpmqKneaftQk9F/dSgmKMCPir
         BMcDwVbLcxe7pRY7LDUYJHfooeFOwbzfPUSDmaZ+L8puSu/S1soJerHVMndDxb2PAeYA
         f10nXTvhTiodeg2S651PKe1yGScMpV9Qbns9WiM5gJeF/C72KKMbkXBHFSVX9L6uetp0
         f/ag==
X-Gm-Message-State: AOAM532nwH3+aVnrvgdNjNLt7EzEOCIU/lcAB0VtWYrks3FWqKPkHQp0
        LwvArkiVf/Q48c4X0dFaTmxrLnCbhjLcSQ==
X-Google-Smtp-Source: ABdhPJyN8Wy3NDGDunuIC407yRvU3BacRlu9Sz27NAc4uTuKXVCjc25EWz1UqyywhXFjSx87dj8kXA==
X-Received: by 2002:a05:6e02:c2f:: with SMTP id q15mr24472745ilg.255.1634048610912;
        Tue, 12 Oct 2021 07:23:30 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id w11sm5612834ior.40.2021.10.12.07.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 07:23:29 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net, neigh: Fix NTF_EXT_LEARNED in
 combination with NTF_USE
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-2-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9771903e-3e7b-4391-dac8-bf7d0785e4c9@gmail.com>
Date:   Tue, 12 Oct 2021 08:23:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211011121238.25542-2-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/21 6:12 AM, Daniel Borkmann wrote:
> The NTF_EXT_LEARNED neigh flag is usually propagated back to user space
> upon dump of the neighbor table. However, when used in combination with
> NTF_USE flag this is not the case despite exempting the entry from the
> garbage collector. This results in inconsistent state since entries are
> typically marked in neigh->flags with NTF_EXT_LEARNED, but here they are
> not. Fix it by propagating the creation flag to ___neigh_create().
> 
> Before fix:
> 
>   # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
>   # ./ip/ip n
>   192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a REACHABLE
>   [...]
> 
> After fix:
> 
>   # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
>   # ./ip/ip n
>   192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a extern_learn REACHABLE
>   [...]
> 
> Fixes: 9ce33e46531d ("neighbour: support for NTF_EXT_LEARNED flag")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Roopa Prabhu <roopa@nvidia.com>
> ---
>  net/core/neighbour.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


