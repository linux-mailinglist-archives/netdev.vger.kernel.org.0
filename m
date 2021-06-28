Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEE73B68A7
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 20:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhF1Srd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 14:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbhF1Src (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 14:47:32 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51C3C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 11:45:05 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so19841506oti.2
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 11:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CaSXwSZ9lOhJ7Vg7wjpsjinwug5Z8Ow4GjREVcbjcLQ=;
        b=HSLHEwwioiFdRLJuC9r/CJMHEdJhNpfb0oYGTKbExzJXvjKnzwz4RT3cpE8SUFK2Bk
         mrCG80POlBZPyio+ybF3rQaUjUvEArcZPJYlnfMbef9SbEudiPMBDT47Bt1f5dx6CU7a
         cX626t63fnZQ0S/3SIr2Akza9ggvo5HQYdU8zGk7Il5zrdEFBFzlVBFhtGZnyUiOY9If
         F85b6Zbr+ryaR/Sbn38gfEnRANMfeUUO2kRe+cC0yzY9E8/PJ4oj4xOCDgCc82OTcQ2J
         8SsX/o9v9guWdgHvDFi8lrLvkBWxf+3zQX7EvUjlkVRNWmGhVLdyYwIiJbUHkr4cO9eY
         X6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CaSXwSZ9lOhJ7Vg7wjpsjinwug5Z8Ow4GjREVcbjcLQ=;
        b=OSYjYhZ2MSvyr3pgQCTPT0EP6WJ5Tb/mjQCe/fiLMG0mmJVuPnMAGP8OlsBjLStT3p
         op044Chr+1SDh3gRPY5mb2Ojto3Ek6pY5jH8xSGYpl8TzJVkEXaloW36GHgsJqmRMgVI
         gj+kCenfBnGPr8k7tnrP/u5H5nSB4WR39LXB8lfcQaAZlziSmW/y+wuw8cbQtJ77OkF6
         WtK8G51NR+ssKjeIIWJv7MYOLkDwedwRZDn2KSOUcdmhuM51ODdIvT91rJhRfQBT+4+g
         h2wI8U9UhVq75PNNLTS+jbztsaey8a6GZrkTFKyU/usUu5rxCP2PcbOCkE6lhMbYVzNC
         tNFw==
X-Gm-Message-State: AOAM531NfOFLiqJCGv16g8T22SYORgMnuWeiwiG+KMOD1dZ9VwpXHdPi
        tThNOqm0rFZhglg31QLXS24=
X-Google-Smtp-Source: ABdhPJwSNVRkhoDvTkmGnhBwARbFiM8TX6anY+PcQCRzDghQ9f0H4JxHfXrKEWqeY1w6++CzWQTtDw==
X-Received: by 2002:a05:6830:1f51:: with SMTP id u17mr879574oth.25.1624905905315;
        Mon, 28 Jun 2021 11:45:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id 35sm3531147oti.65.2021.06.28.11.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 11:45:05 -0700 (PDT)
Subject: Re: [PATCH net v2] net: lwtunnel: handle MTU calculation in forwading
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210625162139.9067-1-vfedorenko@novek.ru>
 <afc66439-d288-c2ea-f129-c9833d8a4d89@gmail.com>
 <65961d37-9f7f-631c-2293-aa1193aca83b@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ffa948d1-3a19-ba02-26fb-c7f186d0e86c@gmail.com>
Date:   Mon, 28 Jun 2021 12:45:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <65961d37-9f7f-631c-2293-aa1193aca83b@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/21 3:41 PM, Vadim Fedorenko wrote:
>>
>> I think this is the right approach - tunnel overhead should always be
>> considered for the mtu. Did you run the pmtu.sh selftests to make sure
>> those still work?
>>
> 
> Actually not, I was running my own tests of routing configurations with
> different types of tunnels like GRE, GUE and FOU with mpls lwtunnels to
> check consistency of calculated mtus.
> 
> Will re-run pmtu.sh but I my installation doesn't support OVS right now.
> 
> Also, I was thinking about this RTAX_MTU and I'm really in doubt. Do we
> actually want the situation when
>   ip route A.B.C.D/32 encap mpls 100 dev ip6tnl1 mtu 1400
> will actually require mtu=1396? Because this looks like not clear for
> users I suppose.

It is simpler and cleaner to me for the stack to always subtract known
tunnel overhead from the MTU and not expect users to do the math which
is why I responded as this is the right approach.
