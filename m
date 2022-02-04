Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960DC4A9ED7
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377495AbiBDSTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351766AbiBDSTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:19:45 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CC7C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:19:44 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id q204so8404617iod.8
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BhArQkxbtN0pvvjCBG0OYL1pBDNdr/svZIAn025HybE=;
        b=AHG7JqXHFg1WzW9OKdp+766xUIWPFbqNWGbrGAAE28jVoghvIysHSbP0hxh6cX4CkK
         0cP/lUMizivvyPybQPZT3d/ehIPuWhOheYV+dNMmUa/QjuyEW5LYdYTmbu4upcDqMrNK
         JD71+zYd6vUAB3OhQZaRTJqT/7VB50czYVJxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BhArQkxbtN0pvvjCBG0OYL1pBDNdr/svZIAn025HybE=;
        b=LS4OxV2yF1bri5F+ndDuAslDZMSXvPV2husTwo3azt3L1UQ/ThavQraJodeFbxwVQd
         6fggqH3nIuH+tWyBPsOKlyEOyyJXJu0O4hGzUD2RYrWvN4zLNtkdDGwRmsBdZn4O75DJ
         d+CZx3oQZ8JG+jwxxJwZJpFhGtAPcpg8MtZsTyq6KUwPmEh57HHxUA3fYdQq98a3MpuO
         yJX4FwuYH0CcgaKgcw5/MDpJlG7eyo1EkwVudcgTVTpMAKCAtSvH1mOH+gxq+Q4g/BvU
         kJ0OkxkSY7PDO4A1KmNLq8gIib4l3OKS7WJbMERh3EcTDsXCcUglezYTwvcmPqSuCpKY
         2H1g==
X-Gm-Message-State: AOAM530bSONxRVuFo4wLhBypDxmabeA79/6KPX8S5w31GvRl8gbfsEKG
        EnTry3HZmoeb8Ba1KwXdCj0V7g==
X-Google-Smtp-Source: ABdhPJzTFIthmhWE16ytzf8DU+RjpHZFziYmvkFxyOqMMkX3YZK8OsBmjThsALoz+nyAsAMrY5MdaQ==
X-Received: by 2002:a05:6602:2a49:: with SMTP id k9mr172607iov.83.1643998784351;
        Fri, 04 Feb 2022 10:19:44 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id a2sm1355546ilj.35.2022.02.04.10.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 10:19:44 -0800 (PST)
Subject: Re: [PATCH net-next 3/4] ipv4: Reject routes specifying ECN bits in
 rtm_tos
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Russell Strong <russell@strong.id.au>,
        Dave Taht <dave.taht@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1643981839.git.gnault@redhat.com>
 <e59d6861e3c230c9fd1f24f116de38a73fa27773.1643981839.git.gnault@redhat.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d45370df-f752-bbcf-1fd1-ee52769c45c2@linuxfoundation.org>
Date:   Fri, 4 Feb 2022 11:19:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <e59d6861e3c230c9fd1f24f116de38a73fa27773.1643981839.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/22 6:58 AM, Guillaume Nault wrote:
> Use the new dscp_t type to replace the fc_tos field of fib_config, to
> ensure IPv4 routes aren't influenced by ECN bits when configured with
> non-zero rtm_tos.
> 
> Before this patch, IPv4 routes specifying an rtm_tos with some of the
> ECN bits set were accepted. However they wouldn't work (never match) as
> IPv4 normally clears the ECN bits with IPTOS_RT_MASK before doing a FIB
> lookup (although a few buggy code paths don't).
> 
> After this patch, IPv4 routes specifying an rtm_tos with any ECN bit
> set is rejected.
> 
> Note: IPv6 routes ignore rtm_tos altogether, any rtm_tos is accepted,
> but treated as if it were 0.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
> Shuah, FYI, this is the patch I was refering to in our discussion about
> testing invalid tos values:
> https://lore.kernel.org/netdev/20220202232555.GC15826@pc-4.home/
> 

This give me context. Thank you.

thanks,
-- Shuah
