Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC5D23B138
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgHCXsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgHCXsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:48:51 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A3EC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 16:48:51 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h21so23258080qtp.11
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1lUy/6vJmc3fh7Wag0sGATdOkMr0aq4lbqrwiN9zESI=;
        b=ja+uE237rPewIY+yrZ3Qs1PyEHgPkMIdymaFQt0IsjryPL99OrP6/sz94y4drTu98w
         5PMre3BMkX8e1ho40A/OOTx/Q6bzcJGn/n/+xMrZhodmN/uLpjNVqtWNEFR6yYBfGQ2V
         UFqV5Ra70MbCcWMV99cSDF9+AoJvKirSIvpgaUyd0z2pzEyRn8q2EUBRB4BEYcng6KMn
         Oquw/2J7vRu0BAw2lXa7B8NkB/7XEsAnPiq+5WnhAGTjAvayQzzDpfGtZi5ASHkW8Tq0
         3r5ShUUOG2pyHxHmk+FaMtDu47SdcS1gYd2JrzAbKcSJhxvGDhlYkc9G5Enem21ZEI+c
         n8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1lUy/6vJmc3fh7Wag0sGATdOkMr0aq4lbqrwiN9zESI=;
        b=TTd0/MD3xlZUb+SvKRnXb0TlHk2c09HoyOg3npQxv3W4eIZeKuNQtsRgVuzNkyF7Nc
         iZs8WUZ28cWELc84lszm/Rl379l1fPGaaj1iNC1vvgqMtusIjlkir9CYf0/zs5QdM4xk
         pp+TFzlkacRnpbYDOyk5spbl0N9E/0eWaKApxOLxUbnsDjky86xl2EpO6vEJ6hdUk5G+
         l0I89KvWuThxFf53dI86zSSkNK4fwhroKCWagE2RPPCyWYnQI/UuzdgIjA4jUABWQjPz
         S/7DkOU17JDqTKq3lQD4jC+0kR//UPWsjHKyYgT2J+dTycFsXSMZkd531eraiftgPbBG
         utsg==
X-Gm-Message-State: AOAM53253rwYYHZeoenZlTPtPZXSuBGfvnelyvbPs91GOtOhquRItsBL
        D66NMWaIdv4tNZKoY6XINlTsZZCu
X-Google-Smtp-Source: ABdhPJzasJTF4uNVMJt1WD9XOzpEbYCwg5TB352th5iUrPpgZCK/x3wdExzxPgMO30WDLW+qRPmxlA==
X-Received: by 2002:ac8:4815:: with SMTP id g21mr19635505qtq.148.1596498530145;
        Mon, 03 Aug 2020 16:48:50 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c16b:8bf3:e3ba:8c79? ([2601:282:803:7700:c16b:8bf3:e3ba:8c79])
        by smtp.googlemail.com with ESMTPSA id u42sm28002758qtu.48.2020.08.03.16.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:48:49 -0700 (PDT)
Subject: Re: [PATCH net-next 3/6] vxlan: Support for PMTU discovery on
 directly bridged links
To:     Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
References: <cover.1596487323.git.sbrivio@redhat.com>
 <9c5e81621d9fc94cc1d1f77e177986434ca9564f.1596487323.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2a4836b6-e435-953e-16b2-4dd8177ffeeb@gmail.com>
Date:   Mon, 3 Aug 2020 17:48:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <9c5e81621d9fc94cc1d1f77e177986434ca9564f.1596487323.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 2:52 PM, Stefano Brivio wrote:
> +		err = skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM,
> +					    netif_is_bridge_port(dev) ||
> +					    netif_is_ovs_port(dev));

you have this check in a few places. Maybe a new helper like
netif_is_any_bridge_port that can check both IFF flags in 1 go.
