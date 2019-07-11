Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7555665466
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 12:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfGKKSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 06:18:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39232 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbfGKKSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 06:18:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so926687wma.4
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 03:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M/uZee31+cHAFk1gSq+aHFn4EaVxUbqEZxjMETaQntY=;
        b=OlVNs1c7TlGSNJnlZa4d3dZeomiSGBKLz60z+mWL1qIHko4o1Qzd+4wQnYdtLMb2UJ
         0URhYVfBPJpZyPbRzZD/j1Vbo3hFbvb3aqj0mKo7xKGgjfOXXELK5PWRzhcLBJ4QgjxT
         zwxMmWGovIjV/89WEUK0NOKY7GDuD/t9+bER/0Jny98WTVpphJ6gLBJSqUsdw2nadsgB
         Vz5Q1IYLDCL2jUWt0rwaKtNOattkiOJ+StE2w4b7mZDcK+nYJqbxAuop6CYUr2btU3lz
         jVzHTyJGyy33FEsmfDdpVBsLxFqHHC3YpGERvZympZoDP21y4YhDxFQWPWJI9vOjKanI
         po0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M/uZee31+cHAFk1gSq+aHFn4EaVxUbqEZxjMETaQntY=;
        b=MISYvftxd7tqO1zhsKuZDvmzZ2cYKxT6nTg1xgTYb1ImW/BaMSskiZlfk75XjFBP+v
         Y/dcC7BB2SpZuafok5ErMJpea9sTcg74i0SfnRUnAPmmFfs2KE/GfJhKUud0Jowo5FCc
         tLFxkZQSDah5MH9jxXY4vwDIppbDiw37rf9dp/Qy81IgGw8hDCD28DEM3q1mPfobmSIX
         25PPQZrsZCP6sQAF/peABsArRKq6J00S2T0hCVZTHAQWDVGL4lqh+2lDNe2H9RgaC0u4
         6H8KKqM55iURZvwKjeobPBtsEpy4jHciIBLyHtFdxywYLKkpvDT+YgACS3YcoAQA3v8u
         sf8g==
X-Gm-Message-State: APjAAAWgC8x347M3ls+CBjAJbbdPpWyh755IqRS1ZbvsYQkr8IO3m6Pp
        juEuI0FX2bxohTnVg6u5ikk=
X-Google-Smtp-Source: APXvYqw+owaCYNESZBznl8Qv0W52VQIFOaN4rJkDoMbtN4+Ofxw81s8GAPw3j4ge2siMCe0flQizJw==
X-Received: by 2002:a7b:cf32:: with SMTP id m18mr3519735wmg.27.1562840328610;
        Thu, 11 Jul 2019 03:18:48 -0700 (PDT)
Received: from [192.168.8.147] (143.160.185.81.rev.sfr.net. [81.185.160.143])
        by smtp.gmail.com with ESMTPSA id v15sm5252455wrt.25.2019.07.11.03.18.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 03:18:47 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
 <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
 <B600B3AB-559E-44C1-869C-7309DB28850E@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b83b7aa4-9b0d-f9ad-6148-03e9828392c8@gmail.com>
Date:   Thu, 11 Jul 2019 12:18:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <B600B3AB-559E-44C1-869C-7309DB28850E@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/11/19 9:28 AM, Christoph Paasch wrote:
> 

> Would it make sense to always allow the alloc in tcp_fragment when coming from __tcp_retransmit_skb() through the retransmit-timer ?
> 
> AFAICS, the crasher was when an attacker sends "fake" SACK-blocks. Thus, we would still be protected from too much fragmentation, but at least would always allow the retransmission to go out.
> 
> 
I guess this could be done and hopefully something that can be backported without too much pain,
but I am sure some people will complain because reverting to timeouts might still
show regressions :/

