Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0046823BFB3
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHDTZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHDTZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:25:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C51C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 12:25:48 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id d6so29871420ejr.5
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 12:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8ciizhpkgZjrqgLReN8S0O+3mw34AMxuyvwdnN206Uo=;
        b=NuloXBQnJnWWrA3ny5p4Owdb7xDL999ervGFN5O5zRmgs57a/v0rqfwLmxoCeSFU6V
         imPGN2V7OBNJ242hafsX/Etd2oBYH2iNqgqzBrgOYbJWRM6cnY1lJye+3usyDBbicDdW
         dAqIBRNSAwX7uskPkMo2mvhlAhlCGR3ybTwBbNmrpbqKYNDRgPhezOh1yuewoAF6VLXC
         IwlXaSA/EQs3BlAV3EzrZHT8rY9Mn9OARdrqPWxSVyrEm4neUwQU+jzoTRMOkzQumSH3
         udfjgbXv2W4ZrE7tqsi0/vMIxtVOhZWg9atE+duMeBJ1shnQ5vdwIzxdcdVu4E1+kAIU
         bjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ciizhpkgZjrqgLReN8S0O+3mw34AMxuyvwdnN206Uo=;
        b=ssYuX5AUs1VKlU6Rfrgno37BSo0BGNFhoWKE9eI+2JKb/NJhX+4qMQBs52P+z8Jdc2
         /lOnE6v9GgIVxpZjD8kd1TZr+nT+opWbMhxTShb9heI4QPijef1o4FowS4aGHfBHdOsH
         3X+Gg+jjhaDOQDGsLez6R552QkpVXBw4gw9/owwBINcywgo2rw0Q/P5WY+dUCIoDtOR9
         xUs26ocpEi3rP6tVVTEjNcg3o1ZNGdIzzn9Z6fjjjNiZrQyUcvY+YZypW6VkYTlvLfMx
         66xai0VGgiOriThcRUPH2WSYegGejzFqMlOypcTYdrO0afpzzc2aUMNRUFWcAEO80JRX
         R2Qw==
X-Gm-Message-State: AOAM531M9gRqWqr3QmyZk9JdpIYPFtMpgSdOfUTAy/d66akMcop/0k0P
        TVrnu6iUS2UEBV1Ubo5hwrnl8g==
X-Google-Smtp-Source: ABdhPJxHORElJUEseWRk0twtj9x1/8fjkpV0kNACk+e8Q9/EgeRvuI2aqWzgTl1K9eWlKC6OZ7sGCg==
X-Received: by 2002:a17:906:3c02:: with SMTP id h2mr23814534ejg.437.1596569147057;
        Tue, 04 Aug 2020 12:25:47 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id n11sm18858017edv.39.2020.08.04.12.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 12:25:45 -0700 (PDT)
Subject: Re: [PATCH net] mptcp: be careful on subflow creation
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>
References: <61e82de664dffde9ff445ed6f776d6809b198693.1596558566.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <4f2a74b9-d728-fa76-7b0f-f70c256077ee@tessares.net>
Date:   Tue, 4 Aug 2020 21:25:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <61e82de664dffde9ff445ed6f776d6809b198693.1596558566.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 04/08/2020 18:31, Paolo Abeni wrote:
> Nicolas reported the following oops:

(...)

> on some unconventional configuration.
> 
> The MPTCP protocol is trying to create a subflow for an
> unaccepted server socket. That is allowed by the RFC, even
> if subflow creation will likely fail.
> Unaccepted sockets have still a NULL sk_socket field,
> avoid the issue by failing earlier.
> 
> Reported-and-tested-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> Fixes: 7d14b0d2b9b3 ("mptcp: set correct vfs info for subflows")

Thank you for the patch, the addition in the code looks very good to me!

But are you sure the commit you mention introduces the issue you fix here?

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
