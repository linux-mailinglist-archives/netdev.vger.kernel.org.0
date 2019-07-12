Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4076676A
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 09:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfGLHFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 03:05:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52279 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfGLHFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 03:05:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so7831148wms.2
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 00:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4WVzx7NfYyKZfRHivTOMoWMwW7LfE1/XJK47R8mLMc8=;
        b=h+yoBxXMRuTmzR5u0kXhblKrczuUGvtKB8+2YDlvQo7121nvUvf8NNvg4aXHpay25M
         FKOOCQKc+MtQoeMm3mTyo36WfVYBg5S6Clp8718Gb5BRpT3W0w1If9g54kfZJTD1PyTG
         kH/qVmLU+/daPOoNixwFW7a88d3fKsXgEttgkgkufz7Ckb+fxBPY8OAJFwo27tlWxDw6
         Z3VcUH6EVkogewGMhU+2G7kRulV9zC6DkNOeNdt8noIv5bDpdIdf26b+K+HZR0HzdzHS
         wbWddWgm8iJ4WMgEukZVpsGuSO1g2c9PR27o8pZjmj5tGy9RRfTM9cS2NVd91cyhNeTa
         qw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4WVzx7NfYyKZfRHivTOMoWMwW7LfE1/XJK47R8mLMc8=;
        b=KGD7RDRKdcSKmBLFRn9qvwtTOeaDiSqIXJ+icfJyq2xCpZAgmyKG+twgZ4iIGmQK+G
         AAyXHE3ZO2lzguqvwaRueC3Cj0mS2xIKOvEi3umZ32j5Mv3OpxWHm6Mg/Sxsjo4CiE/A
         J0nXAgkaVQnVGHEhBf4npgyR6ulWMyp15X1ARCys/vIFFz1KJDBIqEB+wmxNKKx42N+W
         UWBlEM2FPbN92j1HdxQygYKLmAc9bBBHWQLPa+j9gLv9RNCakdQbMJfUpN+vqwO6Ok6Z
         kUmTYtURYsUBA+MHn0Q/DIde8vZmihRqyGqwHgxG5YIoxsJfdXnNvlEgYzXlyVweLwlM
         Adog==
X-Gm-Message-State: APjAAAV2rGhvqieHeTaFxcPkakhtdyRRXGo1Y8eArCXZcSx8AjX+0li+
        08gJbIU+hmpoRsdWBFy2O74=
X-Google-Smtp-Source: APXvYqzzNRBTFe/6QHlQEt60AsVg5m+NItvoGu7ALu9okOoaccGLeMEO+mQ3uZ1h/AAKScXlZbhm+g==
X-Received: by 2002:a1c:720e:: with SMTP id n14mr7977685wmc.53.1562915106248;
        Fri, 12 Jul 2019 00:05:06 -0700 (PDT)
Received: from [192.168.8.147] (106.174.185.81.rev.sfr.net. [81.185.174.106])
        by smtp.gmail.com with ESMTPSA id k124sm11158933wmk.47.2019.07.12.00.05.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 00:05:05 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
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
 <adec774ed16540c6b627c2f607f3e216@ll.mit.edu>
 <d4b1ab65-c308-382a-2a0e-9042750335e0@gmail.com>
 <4B9799E0-A736-4944-9BF3-FBACCFBDCCC5@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d045271a-7380-17c8-06a2-608ff65f52ee@gmail.com>
Date:   Fri, 12 Jul 2019 09:05:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <4B9799E0-A736-4944-9BF3-FBACCFBDCCC5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/11/19 9:04 PM, Jonathan Lemon wrote:
 
> I discovered we have some production services that set SO_SNDBUF to
> very small values (~4k), as they are essentially doing interactive
> communications, not bulk transfers.  But there's a difference between
> "terrible performance" and "TCP stops working".

You had a copy of these patches month ago, yet you discovered this issue today ?

I already said I was going to work on the issue,
no need to add pressure on me, I had enough of it already.
