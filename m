Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9585D11E971
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfLMRuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:50:00 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:42509 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbfLMRuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:50:00 -0500
Received: by mail-pj1-f67.google.com with SMTP id o11so25497pjp.9;
        Fri, 13 Dec 2019 09:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1rwygl2rLQ3dreKZy28Fvryy72/v/PQU1Hd1V0ORYkk=;
        b=K77Tq24sdUf65wcUZJEZoyjYxi9TRoAIHwlTo7OpNLrHsc9NaITCo3EgNnlzK0ikuW
         /Tm1ZsJky+byFE4X7CvL0zNWSO6xVAXC5RWGLJq2sGpSgqCgQ6TAL/prVwi26UfbL+S+
         kmuwCaX829n5zUkmtE1lRoyQ3E4R0R1FrxQuZOunIsf3uQwRuli1KGlf4xs2uZPNBRa3
         BkF8KlGeRWjBVjUXlKn2TEYifBu+ts4FyV77Ua8c5l4bj3YS7NtPnFlC93B4KdbWd8JT
         vTAJ3U4bm9AosxcM+xNtBdINh+70Xzfi3+Yn9BzK/6cuLxIIPhIW/UF8MxiIZADUzt7W
         YgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1rwygl2rLQ3dreKZy28Fvryy72/v/PQU1Hd1V0ORYkk=;
        b=Gj0TAOTJJInjeo5p9Yzeg2tZMkMyii/ptfr93c2XTySOEnY9C+GFj+FfRrlZR08s7y
         T1z+H/4ZoIS0SAYPc6mHr2vWB/+wzAi4lP39OiBPY7pZhtQfCB5BsAbhXweWkhyIwX90
         V8vHrpiGEYigrX6TWMR1shNBF+rX3P72+EeMMo8Z5U+JyixDTkslQ8rrroT1msnWto/0
         e2KA3JLFwUJQVDXMtpBuRD4RqNAQHTBeXaB21yyn8xhpiZL+EvMSzkYiEIrehYmeq2mj
         9fjFF0GbaPx7301D8dv1DhPcoryCZqB6mRAfivyg1FT6C2rudMufltvwhTz0ygr0bScf
         em0A==
X-Gm-Message-State: APjAAAVeDoWA8z/Mvtc98rHQJ6q2cw6f42lWay1piQ41dLvy1FNBub4D
        qZ6WawDav2dHAyO1BmHQa2o=
X-Google-Smtp-Source: APXvYqyoXWI8wUtsQ455GEBYepAv/eY9VpMUUX17jhDp6t2fSRmyjDHxj8mDKU5deoSW0YMB3TdcLw==
X-Received: by 2002:a17:90a:a004:: with SMTP id q4mr616872pjp.106.1576259399592;
        Fri, 13 Dec 2019 09:49:59 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id p38sm9748528pjp.27.2019.12.13.09.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 09:49:58 -0800 (PST)
Subject: Re: [PATCH bpf] bpf: clear skb->tstamp in bpf_redirect when necessary
To:     Lorenz Bauer <lmb@cloudflare.com>, ast@kernel.org,
        daniel@iogearbox.net, "David S. Miller" <davem@davemloft.net>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Richard Cochran <rcochran@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com
References: <20191213154634.27338-1-lmb@cloudflare.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <523d7946-bb5f-39a3-8969-addb564fd73c@gmail.com>
Date:   Fri, 13 Dec 2019 09:49:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213154634.27338-1-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/19 7:46 AM, Lorenz Bauer wrote:
> Redirecting a packet from ingress to egress by using bpf_redirect
> breaks if the egress interface has an fq qdisc installed. This is the same
> problem as fixed in 8203e2d8 ("net: clear skb->tstamp in forwarding paths").
> 
> Clear skb->tstamp when redirecting into the egress path.
> 
> Fixes: 80b14de ("net: Add a new socket option for a future transmit time.")

Please use 12 digits sha1


> Fixes: fb420d5 ("tcp/fq: move back to CLOCK_MONOTONIC")
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Thanks for fixing this !

