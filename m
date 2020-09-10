Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3FB264E25
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgIJTCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgIJTBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:01:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64405C061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:01:25 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so4777039pgl.2
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gASvPRH8Hlq0SAuLbtwd+/9z0Q4zZroUGWXUYK5Ywtk=;
        b=D34M06lx9ZFb+ZGRj8XZFgC/GKFnkzL89fYllXd/c8OfRJTE+KnWNqY++esV9fX39d
         3Dc8hkiC4vGjq/F1+Sd5qyHIfwq26ns42ZD9Sp+BFMUKInBXbnHWwh9zMJ8GaVD238I+
         wYIkOqVGPmaiolakOJ7vn8WmjR/CMOYf2ILhNSRlm4Ishrc0REYmuIlApyk/bPya7Mj8
         hUMguQyZnCjwKRtQmCsAgqmMlkoZ9iWbevjL4FJeLvfEPoZ6o9fUBGwNSPSmRk8QPPTi
         HE2Ett9ioiBOHycag9Ngoqro4c3kvdr6fdGGPEaG+p2YBAGNBbJsYAw5ZXYZ4YOu52ah
         gHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gASvPRH8Hlq0SAuLbtwd+/9z0Q4zZroUGWXUYK5Ywtk=;
        b=FiKUlgXgSd0gfKSumiX15xFlFk0xWW3GVLgTiGMG1ZfveQLgbFOV1oEoU76BeqedaH
         EFtIHPexhwBesZkIrfwZ7MUSA1J9UdOoCibPtmuBOZ1ImUSeWWbVV0SMM7OVII8nnsr+
         Qwai6Ounh28RnZiJDSeBtYlu2hVNG9yat9UGMiSPYNBSghMK2XgUtCDRYU19D31uE/WG
         3j0ME+dMqPghBMl2EiFfFnTEp1HKivxXJNnXJtJaSxzDWRYYxfxocKF2NUW/iEXTpl7Q
         Tbb8pXNMo4U9d+gC3AWs0i3ir91fo/Ft3cTGcXBwn2MSfrfAZerlmK4eQUapzXt8lSQT
         1vZg==
X-Gm-Message-State: AOAM531VQq8sAihDglSu1BTP6gFyBj6FcXdZz72u8/XwshPA8nQotOoG
        /Asmdwpg7O6NAwVoVgbzued02+SpVKk=
X-Google-Smtp-Source: ABdhPJy1AN/6Q3Lthg9z5NLfaveqcBdSSxOaF68Bu76FqwZZqUR8mCVA8DQZzVsjtAWLHln97aqhMw==
X-Received: by 2002:a62:dd01:0:b029:13c:f607:5fff with SMTP id w1-20020a62dd010000b029013cf6075fffmr6712526pff.3.1599764484718;
        Thu, 10 Sep 2020 12:01:24 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v6sm6815444pfi.38.2020.09.10.12.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 12:01:24 -0700 (PDT)
Subject: Re: [RFC PATCH] __netif_receive_skb_core: don't untag vlan from skb
 on DSA master
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        andrew@lunn.ch, willemdebruijn.kernel@gmail.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org
References: <20200910162218.1216347-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4475ca4c-1894-b168-84d2-679763135c43@gmail.com>
Date:   Thu, 10 Sep 2020 12:01:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910162218.1216347-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 9:22 AM, Vladimir Oltean wrote:
> A DSA master interface has upper network devices, each representing an
> Ethernet switch port attached to it. Demultiplexing the source ports and
> setting skb->dev accordingly is done through the catch-all ETH_P_XDSA
> packet_type handler. Catch-all because DSA vendors have various header
> implementations, which can be placed anywhere in the frame: before the
> DMAC, before the EtherType, before the FCS, etc. So, the ETH_P_XDSA
> handler acts like an rx_handler more than anything.
> 
> It is unlikely for the DSA master interface to have any other upper than
> the DSA switch interfaces themselves. Only maybe a bridge upper*, but it
> is very likely that the DSA master will have no 8021q upper. So
> __netif_receive_skb_core() will try to untag the VLAN, despite the fact
> that the DSA switch interface might have an 8021q upper. So the skb will
> never reach that.
> 
> So far, this hasn't been a problem because most of the possible
> placements of the DSA switch header mentioned in the first paragraph
> will displace the VLAN header when the DSA master receives the frame, so
> __netif_receive_skb_core() will not actually execute any VLAN-specific
> code for it. This only becomes a problem when the DSA switch header does
> not displace the VLAN header (for example with a tail tag).
> 
> What the patch does is it bypasses the untagging of the skb when there
> is a DSA switch attached to this net device. So, DSA is the only
> packet_type handler which requires seeing the VLAN header. Once skb->dev
> will be changed, __netif_receive_skb_core() will be invoked again and
> untagging, or delivery to an 8021q upper, will happen in the RX of the
> DSA switch interface itself.
> 
> *see commit 9eb8eff0cf2f ("net: bridge: allow enslaving some DSA master
> network devices". This is actually the reason why I prefer keeping DSA
> as a packet_type handler of ETH_P_XDSA rather than converting to an
> rx_handler. Currently the rx_handler code doesn't support chaining, and
> this is a problem because a DSA master might be bridged.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Resent, sorry, I forgot to copy the list.

This looks fine to me, and the rationale makes sense, if you do 
resubmit, feel free to add:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
