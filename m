Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5E654D89
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbfFYLZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:25:01 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45644 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfFYLYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:24:40 -0400
Received: by mail-qk1-f195.google.com with SMTP id s22so12203113qkj.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 04:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q67GX7ogcyNGHOVFbGOWKsdPM61okAiYlmyIGQtFKqI=;
        b=iBj3bF+KsBwev9IcArvxqrzoQjGeBjdhXnBOgDq8JX3sYlyLYLDkF83tYYcDAyP5R7
         tWe8KMKoU3TE1zPz9Yg883Fpv8bCHNXN/sadcNZziLMV2uG8YTN+eWR8MShqY/nvj+8F
         /eDvdwlkQXRVHQSjHijDrhYCge3g5rM977DYG+hKYfek41rRBT2EiafV0mxUuM8Ey6L5
         3J9Bsv+QNn5gBm8V+8bbjmdG5o0+QjMEYwpIUFn+Mos2FmblP8XwfRg0L8BZJIBVhBZk
         zhGsgn8sGbvIbgf+2wzG7SVjI7AgZbHxe4h5QHIYc8iCgKl8VIafsWwy5vufhXb9aiyz
         /4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q67GX7ogcyNGHOVFbGOWKsdPM61okAiYlmyIGQtFKqI=;
        b=sKmpQqdnkFCLdYXHw+FAc7dIE1z9gMaKo7zTWc0SyFFxRikbpQCfXeCnsyERS3F0+P
         QQjtyr7M/Re61VnenTTBfl+hg/XJO2Y2Rp15nTaHPtblpx7iW0y1f0QiGiQzXuq6I0Up
         Lg09cChCtNQHmNIl4eG5dvd8O50/j17NcCu9FGm640WNhSEe/gVzOto6ODflUfm3KSSJ
         tZoHj0HFXw0+tDotybGkuQRi/2PvL2XWWIujwPb2Zgs1VzKf9jdVISrlEYo28qAUUfF8
         Oay8+UlIkAgnKwN9HxdcxCIECSh8hh/P1FPFmvpMUiWGZ2CSNAa3jADo9ANNp8XLDcpt
         4ZoQ==
X-Gm-Message-State: APjAAAW0KHsJTNnCCtAbmpyCg43I6DiM3boTT2/cAOA/pof0aur83/5+
        Lued0A9Bog3Iab7opJjrk9pagQ==
X-Google-Smtp-Source: APXvYqzEaMHhL1QE5xJCqAQ+MI97DkXvZF66AOX+XAdOUa4SriFcfuaguT5yBFSvr7aRKpQ3bZH8Fw==
X-Received: by 2002:a37:9c16:: with SMTP id f22mr124589476qke.261.1561461879107;
        Tue, 25 Jun 2019 04:24:39 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id j79sm8036529qke.112.2019.06.25.04.24.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 04:24:38 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: sched: protect against stack overflow
 in TC act_mirred
To:     John Hurley <john.hurley@netronome.com>,
        Eyal Birger <eyal.birger@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com, shmulik@metanetworks.com
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
 <1561414416-29732-3-git-send-email-john.hurley@netronome.com>
 <20190625113010.7da5dbcb@jimi>
 <CAK+XE=mOjtp16tdz83RZ-x_jEp3nPRY3smxbG=OfCmGi9_DnXg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <4a4f2f81-d87a-2a45-36b9-ac101d937219@mojatatu.com>
Date:   Tue, 25 Jun 2019 07:24:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAK+XE=mOjtp16tdz83RZ-x_jEp3nPRY3smxbG=OfCmGi9_DnXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-25 5:06 a.m., John Hurley wrote:
> On Tue, Jun 25, 2019 at 9:30 AM Eyal Birger <eyal.birger@gmail.com> wrote:

> I'm not sure on the history of why a value of 4 was selected here but
> it seems to fall into line with my findings.

Back then we could only loop in one direction (as opposed to two right
now) - so seeing something twice would have been suspect enough,
so 4 seems to be a good number. I still think 4 is a good number.

> Is there a hard requirement for >4 recursive calls here?

I think this is where testcases help (which then get permanently
added in tdc repository). Eyal - if you have a test scenario where
this could be demonstrated it would help.

cheers,
jamal
