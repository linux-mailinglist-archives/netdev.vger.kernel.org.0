Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAA545AFC
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfFNKzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:55:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53235 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfFNKzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 06:55:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so1872574wms.2
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 03:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0oPzPYtTaFOuHYWhgj8M4VnnyQ7SlA1m5MUyLxHdfOs=;
        b=KuhL19EbUVXWrWNPLyDQP7NuhE22ksX02ygpGm4t0ySiaXCn0RzU1C7+TjOL4InEmV
         y4Q2b2sM3YNEM5exQG+p8JrN8sR53sMnbF80jw6abIs7/sdD+h83Ky07YNNN/CHNkTMT
         dL4kCpj13qCEk+eLVKb895/vR5mqCwdV2pXXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0oPzPYtTaFOuHYWhgj8M4VnnyQ7SlA1m5MUyLxHdfOs=;
        b=GKzGNtbflFKKVQzB27AXIV0iaJl9vIkmsn4AaH+StiMYLcZH5Z2bSIDZzyCtX5xDTU
         stQllsQmy9VOgQj7HgrIDMIlD2dPCNne5oib5y9zXTIWx7zyfR8LoCc2wWcNZ9rJeg7r
         Z6I8SrgRSLulnQiPz82qL6O2AQuh7StC3ejhBxHdhQiQfV+AHSQnByLvxvjKUk/kwowV
         FRkvbttyy8/x1f5ES4lCI4i13IHte2l63SLNrwdI/h0V7eVz8HED/5oCBO5Alm2764Qz
         BoHT+VSzlckmcxrSdKlQDzykZurMD5PuU24lNbIwTXmnB6tKj21G5oy4GLn3/Lnwwvkr
         CRLA==
X-Gm-Message-State: APjAAAXfKCfJZWavahipG7/uM1OUmiiXazx2J+khZRFifwLQCiSfQW67
        hHuQacrp0X9mkbU+BhrIqA3/a/fxIdQ=
X-Google-Smtp-Source: APXvYqwA13eK3hZMJphS71g7jxDQUeGJCR8rzitQf76ypXYx0LE/YtRHk6ujkc8Qmahy4TndBxFqdQ==
X-Received: by 2002:a1c:a002:: with SMTP id j2mr7387319wme.131.1560509711329;
        Fri, 14 Jun 2019 03:55:11 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v204sm4302701wma.20.2019.06.14.03.55.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 03:55:10 -0700 (PDT)
Subject: Re: [PATCH net-next v3] ipv4: Support multipath hashing on inner IP
 pkts for GRE tunnel
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190613183858.9892-1-ssuryaextr@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <0bd371a1-ac51-ebfd-31f9-e897247c4184@cumulusnetworks.com>
Date:   Fri, 14 Jun 2019 13:55:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190613183858.9892-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/06/2019 21:38, Stephen Suryaputra wrote:
> Multipath hash policy value of 0 isn't distributing since the outer IP
> dest and src aren't varied eventhough the inner ones are. Since the flow
> is on the inner ones in the case of tunneled traffic, hashing on them is
> desired.
> 
> This is done mainly for IP over GRE, hence only tested for that. But
> anything else supported by flow dissection should work.
> 
> v2: Use skb_flow_dissect_flow_keys() directly so that other tunneling
>     can be supported through flow dissection (per Nikolay Aleksandrov).
> v3: Remove accidental inclusion of ports in the hash keys and clarify
>     the documentation (Nikolay Alexandrov).
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.txt |  1 +
>  net/ipv4/route.c                       | 17 +++++++++++++++++
>  net/ipv4/sysctl_net_ipv4.c             |  2 +-
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 

Looks good to me,
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


