Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC14265FBE
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfGKSuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:50:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40726 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGKSuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 14:50:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so7381936wrl.7
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 11:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/SB0a1l/Aowjdg+cudPBQ5+bZEefq2USfsenvU+GhBM=;
        b=Wo6NlzavGXDUTvwckOnQhz74D3ijT8kEimOPii38F0U7+L9DtrxpzFPJaplnuS6+kz
         AwtIG5iJK8D66yeRv/o1pJEtZAT1n6yxTRmhF3fffpy6vRzN6I5bQhe84HFNhSE2zLIm
         Sw/LPBOUu/uecGTNlbm5L85Fr1GYMaSdrrjeySG7FyM/7I7lEPNqvkAh5zryS5BMfgJh
         9HlW/ToeCPh8ah4CHLCf5IQhV5QOvcErkjAGXZj8EfjLcvRYwspdP4v3SL6Sj/2+mW3w
         s7quDbL1JdoXSuvdTU5yRmJxqCLS1kS6k03n/UW2P7j+F1iiNWhJjxynanGBqjPo2I8h
         WlGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/SB0a1l/Aowjdg+cudPBQ5+bZEefq2USfsenvU+GhBM=;
        b=oSjdOK8YC6XY0h/tWXK+lQGG/0Y3yFz+rucrKZEmXs9qmbLcojmbUlavh91F43Omt0
         6oe2tJo3w8kuzF+xw6nKWbbnpjQZImEt9+3JGDOaEstrh3BGhaTx9nK19BACBlTnVoGi
         TOdi6SZ/pyUG9JxGlrv7wtQ5GkZRDs1jHL2Pw6x5D/TBiZN3TMru7ZTEgm/0u2vWfvsh
         1O0QHYeUkXVM1vpQfT8OA7RJ8J8enGKxCFRsHEIt94SiuvHUpDZ9QiNL6dfQKtU8zbPu
         U4K+ST89U/lPLlqE+O7KDtBTL0eqlo380u2QjZpEIL2EXDPBWmEXcrcTLs8Vpov+nYEP
         onmw==
X-Gm-Message-State: APjAAAUYEHBz2tLLr6JDMucPMxzsh4LEtbm8tA7238vtL9bxGnUgCYjf
        R44Icqptw6n05oN2UkXmSds=
X-Google-Smtp-Source: APXvYqwdr7CyF5+ycoWWTkkroUIfBWObKiX41G5aBltt37H++MhykaMFIKTNCINLKjP5lSXxOb0uxw==
X-Received: by 2002:a5d:430c:: with SMTP id h12mr6645890wrq.163.1562871017537;
        Thu, 11 Jul 2019 11:50:17 -0700 (PDT)
Received: from [192.168.8.147] (143.160.185.81.rev.sfr.net. [81.185.160.143])
        by smtp.gmail.com with ESMTPSA id j33sm11071843wre.42.2019.07.11.11.50.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 11:50:16 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
References: <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
 <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
 <B600B3AB-559E-44C1-869C-7309DB28850E@gmail.com>
 <eb6121ea-b02d-672e-25c9-2ad054d49fc7@gmail.com>
 <20190711182654.GG5700@unicorn.suse.cz>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <45fbbb23-2a23-47d0-0965-46b726832792@gmail.com>
Date:   Thu, 11 Jul 2019 20:50:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190711182654.GG5700@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/11/19 8:26 PM, Michal Kubecek wrote:

> 
> I'm aware it's not a realistic test. It was written as quick and simple
> check of the pre-4.19 patch, but it shows that even TLP may not get
> through.


Most of TLP probes send new data, not rtx.

But yes, I get your point.

SO_SNDBUF=15000 in your case is seriously wrong.

Lets code a safety feature over SO_SNDBUF to not allow pathological small values,
because I do not want to support a constrained TCP stack in 2019.

