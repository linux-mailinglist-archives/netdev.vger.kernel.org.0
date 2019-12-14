Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62B711EFD3
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLNB50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:57:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44756 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfLNB5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:57:25 -0500
Received: by mail-pl1-f195.google.com with SMTP id az3so1963446plb.11
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lMH7xUqtZCPXwneHZwHDbsgWzl5H28cAZLL9bupyDdc=;
        b=rcs8JlQl6fJDxCpdauUNVr2CkNBY9BUQGtgEZfhE1OVBWCIZ8uyZGtwIyL+O1fzYr4
         +rRH68vbzm34RIpButT2gUsAGndpLoPQaeMR9nftUZYh1vtNdaxzpGmSAsRG6vuuKUMI
         GgRsJazkVlabtRBbZJA4unGkAo8P/t+k6eAbkYv9+JgeXDY/Wpujzk0CBNtmYzVZyHWM
         5OKOqaV3jLpsJXKqw7wnWL9vxtHNNqtUUJmf00lH1tUx2lx7WT4+76wZyhXKLHlQQE7R
         tWARWkXW5pI3AyB3FkbrOCVDsrIipQPZM3YvzUtQmRgdaQhsNSeau9UbwXtrniT8NgWh
         GNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lMH7xUqtZCPXwneHZwHDbsgWzl5H28cAZLL9bupyDdc=;
        b=R2TkTaI84PbJjgw0S4AHgCph88CVAgCPGRo0/mxamWi89jwy1IgT8dRCQzTfo0w3yp
         s1E7NPVxqB113oyJf4KRYlMpRP1hjN8AP6xMIlHLCsui/UolDcL8rqTeWtF65/aXUXrm
         oywbjD5c7hFvzPIMpHhGD+n8P9Z656wRmu5ttOiIJfT8IkhZGLDPbuRg1FPV/LGQasyI
         meArWvauJH0OEmb5Vu6YVxTJuura8rX74blrIQbOhTEukmcIgVwcxWHCquCUQ7vIMoUw
         qazNM0ue+/VZdwk+OozEDFLjwIuIb/mGE1UpSLsyc5BDUrPUrPaH/weJS3s9IqwVolNm
         Zv7A==
X-Gm-Message-State: APjAAAUBallnMa1HepJRjXBISJ29KHVRauDe7xvSflCikGNBqoL6ol17
        UNOtd+1VcERmuQZJjKzNLjiRGj7+
X-Google-Smtp-Source: APXvYqw17azxx9Lk0ctfuHnL6HxJTCis0A61Hw0V6GyGbRYowNQCg9ZFDurjwWeNKT56XzIH5eQ4VA==
X-Received: by 2002:a17:902:aa90:: with SMTP id d16mr2818712plr.279.1576288645184;
        Fri, 13 Dec 2019 17:57:25 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q3sm13267154pfc.114.2019.12.13.17.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 17:57:24 -0800 (PST)
Subject: Re: [PATCH net] tcp/dccp: fix possible race
 __inet_lookup_established()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Firo Yang <firo.yang@suse.com>
References: <20191211170943.134769-1-edumazet@google.com>
 <20191212173156.GA21497@unicorn.suse.cz>
 <CANn89i+16zwKepVcHX8a0pz6GrxS+B9y6RiYHL0M-Sn_+Gv1zg@mail.gmail.com>
 <20191212184737.GB21497@unicorn.suse.cz>
 <20191213175219.35353421@cakuba.netronome.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <457a933e-9168-2ad4-ca3d-4aaf7040a67d@gmail.com>
Date:   Fri, 13 Dec 2019 17:57:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213175219.35353421@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/19 5:52 PM, Jakub Kicinski wrote:

> 
> I need to remove a whitespace here:
> 
> WARNING: Block comments should align the * on each line
> #98: FILE: include/net/inet_hashtables.h:111:
> + * reallocated/inserted into established hash table
> +  */
> 
> So last chance to adjust the comment as well - perhaps we can
> s/into/from/ on the last line? 
> 
> Or say "or we might find an established socket that was closed and
> reallocated/inserted into different hash table" ?
> 
> IMHO confusing comment is worse than no comment at all :S
> 

Sure, I will send a V2.
