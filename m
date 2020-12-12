Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5742D8A86
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439902AbgLLXGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408185AbgLLXG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 18:06:28 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C26CC0613D3;
        Sat, 12 Dec 2020 15:05:48 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id j20so7494627otq.5;
        Sat, 12 Dec 2020 15:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+q6U6UCUrM5jbnp9XTwm1qDH+3i0bFDgW5miwx9+vmA=;
        b=W6OlItuz7iV6E4+7t5bQznD9aSFGQljft39TAWPzproKoPSIcQ5YYWvUjwiZ6Bwzo/
         PPSMtuNN/eaSmtUww7Vb8FJD36Y77sSnGGL2QRTbRKxvHG7TQhKZxPsqIHhHr6E9EoKR
         Le9zmiDrdhb2x1EgvGZRbIhUtXA6tEspaxWRZ1j5paDkxh8KUHpA/Ya0qXrZun0CRkVT
         sQ7eCoGu2pjbVNtCXHzl81dSach+4yzti2T17+sQk7c0yMwvr34eiccd2A66wRu4MmQi
         tuiQh6XC1jcpbtM5jmFUXzAIEkafx7YBo5XvpHwqsamGSb/dEvFsq5GmALlkSTYrbGeY
         utRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+q6U6UCUrM5jbnp9XTwm1qDH+3i0bFDgW5miwx9+vmA=;
        b=elDBJAL59hOM9EkyAaOqIJGKudUJXdfOY3Mi8/kHfzkEuR8YT85hFJMyn+aIuuztds
         eyndK7216rh+XjYOkUFoAG0SsxLbczO6gQQk+eyKnsiGduQikIuCk3N3GW7ZU/r5Gr9o
         o744OepXfe2dMJUgvECruFtd/6vpk/c01y9nSYzV/fcFscD95czVxWVUpiBuE/rnY86q
         2IbJIComBmVcUmBHyq3xHjvPqnoesmr3otjp413XTv0bzRKd/SOITFubxK6+PlgxmW+B
         8sKvApKrDh6zMXNkVab3bVZx0/7h32jcVX9JPvjTwSLfHmrz6s4cgAqs+VprDFM+V2BQ
         JrDw==
X-Gm-Message-State: AOAM533zaPP+tOzZaLxP13J1vWZM5iQJ8m+L653vo04trTa0fxAhRM75
        EjzUTq7noR2mvpOYO5xHxtnbBXaEWa0=
X-Google-Smtp-Source: ABdhPJxAYwMVQ51rSAKHxyAhtmoQTEN6p5+Hrvzny+stXyxggcyXV53mchrTTGaYjeBEvOR7uqiMxg==
X-Received: by 2002:a05:6830:cf:: with SMTP id x15mr14648278oto.55.1607814345461;
        Sat, 12 Dec 2020 15:05:45 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:6ca4:7725:699a:c338? ([2600:1700:dfe0:49f0:6ca4:7725:699a:c338])
        by smtp.gmail.com with ESMTPSA id v3sm2957945oth.80.2020.12.12.15.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 15:05:42 -0800 (PST)
Subject: Re: [PATCH] net: bcmgenet: Fix a resource leak in an error handling
 path in the probe functin
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        opendmb@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20201212182005.120437-1-christophe.jaillet@wanadoo.fr>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <454c848c-27d3-5683-1f11-7169200fec28@gmail.com>
Date:   Sat, 12 Dec 2020 15:05:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201212182005.120437-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 10:20 AM, Christophe JAILLET wrote:
> If the 'register_netdev()' call fails, we must undo a previous
> 'bcmgenet_mii_init()' call.
> 
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
> The missing 'bcmgenet_mii_exit()' call is added here, instead of in the
> error handling path in order to avoid some goto spaghetti code.

Yes that makes sense, thanks!
-- 
Florian
