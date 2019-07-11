Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E9C65F70
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfGKS3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:29:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44402 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbfGKS3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 14:29:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so7314034wrf.11
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 11:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h/h6b8oGyNXq3Gke5g9TT3p/XLPsLUUIgpj6GKZbRJw=;
        b=tz8FeD497u5PEdlWyjGOsT+RNrYPtDZaSkMuLMaE3gkNLVhCwieBHEN21KwVfsMK9i
         9BnrcDlehoiHUUP84n9+XP5lpSff+Ut5WUenIMDrhhGaoqeHBU4eIv6xgN9vqZqMS1sb
         JOF8Sk9wdM4piIdDYkqp3Ad7Gm/Cg+V1pWN+PeR5czdZzDCpXcDpt/j0R5Fh97RyZvkW
         /MpRBa6vsNKfsetOLhy7L/swAzB1+WdhE2AamZfdOVOUbBIK22Y7DkMq5zJQg71pDx/h
         eo41Y5X1RkScxtifYNGRNhRShhveAEswhxrQAt9ABnsU1yxH/xbdwJAaNHC0NbqNpltV
         7Tjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h/h6b8oGyNXq3Gke5g9TT3p/XLPsLUUIgpj6GKZbRJw=;
        b=pf8CpNylKXwKpUYcj3/FiMzaAIC4VAOulO5a2Yp83UYWozkcx731708OkbHXH39hA9
         q5L2wAk8Y7GDazbfRBYY8ZR0Bu/wO3NqCSKGZ55zlxOuQYxwrwCgxiMLItOIRdq4LN3J
         xbXcn148biFU9eoGVm4rQK0Hf6/yurT6GLd2O8wIOodpixy7pI4zuGbNfRB06QC3sNDm
         51OIgfzD8UAQQlbPautQfF96Mv/GaC+N6U7/Ohn9spcFeIyj88qmgdW2BMwqgxD4xwNb
         L/fOUYRI6UU0nX2FTRCuc5yhPWT9a9AlMXbgDSzOy6AzIrztEaql1BL18Y5bR528aEnw
         jI/g==
X-Gm-Message-State: APjAAAUZTHmONDKN0Ul0kGtvlHwVHis6Q7fBi5R3Aqb8lMPy3rrdzPNf
        1aVuvKWJb3valNLePpuXLjI=
X-Google-Smtp-Source: APXvYqyzakva52IvKukBgwa4oNowHM7jENJvh4zUKN6gBmPYEgloy4Zojb1omYSgMHuTtu4vGfS2Gw==
X-Received: by 2002:a5d:518f:: with SMTP id k15mr6302342wrv.321.1562869742837;
        Thu, 11 Jul 2019 11:29:02 -0700 (PDT)
Received: from [192.168.8.147] (143.160.185.81.rev.sfr.net. [81.185.160.143])
        by smtp.gmail.com with ESMTPSA id c12sm9614606wrd.21.2019.07.11.11.29.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 11:29:01 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
 <adec774ed16540c6b627c2f607f3e216@ll.mit.edu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d4b1ab65-c308-382a-2a0e-9042750335e0@gmail.com>
Date:   Thu, 11 Jul 2019 20:28:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <adec774ed16540c6b627c2f607f3e216@ll.mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/11/19 7:14 PM, Prout, Andrew - LLSC - MITLL wrote:
> 
> In my opinion, if a small SO_SNDBUF below a certain value is no longer supported, then SOCK_MIN_SNDBUF should be adjusted to reflect this. The RCVBUF/SNDBUF sizes are supposed to be hints, no error is returned if they are not honored. The kernel should continue to function regardless of what userspace requests for their values.
> 

It is supported to set whatever SO_SNDBUF value and get terrible performance.

It always has been.

The only difference is that we no longer allow an attacker to fool TCP stack
and consume up to 2 GB per socket while SO_SNDBUF was set to 128 KB.

The side effect is that in some cases, the workload can appear to have the signature of the attack.

The solution is to increase your SO_SNDBUF, or even better let TCP stack autotune it.
nobody forced you to set very small values for it.

