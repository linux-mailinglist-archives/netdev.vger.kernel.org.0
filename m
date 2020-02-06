Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD50154A0C
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 18:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgBFRKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 12:10:37 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:56067 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgBFRKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 12:10:37 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so235870pjz.5;
        Thu, 06 Feb 2020 09:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7+lAwSYC8iTX7zrUHCptKd74zLe4G6IoJxg7yC+WSMw=;
        b=IlZd8Ec2CeQUIMo7JKROxECgERL2W7KqbQy9dwxtSVyxmj93wckSPexLQn8vAZfnxu
         J7/RGwzUnnmkGEhvN1mxMbYEd1f+Frd39o+YPP5MeafHniRmjuqpp6FsfEkijzMMvAZR
         l+jyyy0UUcVjpLktAWrHKC0uPiVJ7wnZfnXOaFaTgXlUhgBEWCCEbwF+Lob5Tt7aclu2
         T8pu+TsX/ciwqv78yDab1ogSeoRSYgDgleCDxEUTu+ASdaOnoUQxURCA10PrV1Xkn9Uu
         gaarc6K9R3nMu3GsPseBdYC8NQxpW5saqmouwXb7FfCIFWUJ7e4JwEpduQ2kvPYMjwax
         J85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7+lAwSYC8iTX7zrUHCptKd74zLe4G6IoJxg7yC+WSMw=;
        b=nkcvPTRKUE8mAL419gJCPXRcAc2PnTrtQVY6b84QJdy5q3seHO1piMStjGRB2X9kR/
         rxF1fbFxow96+FQIK9fSyWx9xBwhomRd+ut+/E2UNXO3WB3RNFBPbMX2R5qoei7vU+d5
         A2QS0dWPXP2ys/mbQR9cWXs4sCA+6ESUVazhFBvGIgL1Jz0KqnKpqVBJLIVa4bbyqH9O
         fTBZ5WKYoKBDx1jEGsLFG0wqUUJmXVuJdtwEhixpqeilDL16jCOdHKFZvHU+V9PovCWT
         Nm6exgx5h2u/z+lStBybWnzYF+HZkee74gGUzkbXQN5Zib9Zxd8pn1JIZASNVJIPXaU/
         6YJQ==
X-Gm-Message-State: APjAAAVi2nAQhKQBaXemSiPSubmcENP3Zv9qOQxvAv5KUx6wBS/mWjTa
        5vA4QYvvyop3odksDQOp1O0=
X-Google-Smtp-Source: APXvYqwp6YfS5qUU3b7hVaaDpvcsi7uYY+1y8VNhzJSn4CjyUw2P62KTa/pOo0hsVTWBAqMoXCS/gw==
X-Received: by 2002:a17:90a:7307:: with SMTP id m7mr5699761pjk.75.1581009036305;
        Thu, 06 Feb 2020 09:10:36 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id d4sm4131894pjg.19.2020.02.06.09.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 09:10:35 -0800 (PST)
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, eric.dumazet@gmail.com
Cc:     cai@lca.pw, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marco Elver <elver@google.com>
References: <1580841629-7102-1-git-send-email-cai@lca.pw>
 <20200206163844.GA432041@zx2c4.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com>
Date:   Thu, 6 Feb 2020 09:10:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200206163844.GA432041@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/6/20 8:38 AM, Jason A. Donenfeld wrote:
> Hi Eric,
> 
> On Tue, Feb 04, 2020 at 01:40:29PM -0500, Qian Cai wrote:
>> -	list->qlen--;
>> +	WRITE_ONCE(list->qlen, list->qlen - 1);
> 
> Sorry I'm a bit late to the party here, but this immediately jumped out.
> This generates worse code with a bigger race in some sense:
> 
> list->qlen-- is:
> 
>    0:   83 6f 10 01             subl   $0x1,0x10(%rdi)
> 
> whereas WRITE_ONCE(list->qlen, list->qlen - 1) is:
> 
>    0:   8b 47 10                mov    0x10(%rdi),%eax
>    3:   83 e8 01                sub    $0x1,%eax
>    6:   89 47 10                mov    %eax,0x10(%rdi)
> 
> Are you sure that's what we want?
> 
> Jason
> 


Unfortunately we do not have ADD_ONCE() or something like that.

Sure, on x86 we could get much better code generation.

If we agree a READ_ONCE() was needed at the read side,
then a WRITE_ONCE() is needed as well on write sides.

If we believe load-tearing and/or write-tearing must not ever happen,
then we must document this.
