Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA7C14F4FE
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 23:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgAaWxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 17:53:49 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36453 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgAaWxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 17:53:49 -0500
Received: by mail-pj1-f66.google.com with SMTP id gv17so3595545pjb.1;
        Fri, 31 Jan 2020 14:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O64ZrPgfOSQfg7giHCwyJ23cxOCbiT2C1hToXNCQpWY=;
        b=BOOJ0Umnh+z2fup1+C6AYpqK8dw/9bii6hztTW4wh+y+LkZJF2CKGz/18Fm825U1Dj
         WFyhP237naoFQ8e+VIMnumKLEHmoRKvvUnjzMygt+DKP+p0Ql+p/TsTjByl0yYiI3iQ4
         DovBBDFVI/DC0AnHmJt89Ggra1beaiBH2OUbG5RWTesrXGFIBv5hNfGfLYXHCZ9ZgS+l
         UxgknH2OodFR0xNk4NuQ7EfqLQMHtagYyh9tFB8XW0oTD5tcyb9liWUlAnzjA461jneW
         vHcUaDPVeYRkXyBlMlxkMnNNSxU+eBROYVgjmDAEvm6zTTGS3aJ5giXxxI7DxrUM0Xq1
         PvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O64ZrPgfOSQfg7giHCwyJ23cxOCbiT2C1hToXNCQpWY=;
        b=CY/el1qbIBCzWAGYK34Cw0kidcfUp2ChqxjBUYaeq6NjFcImMv9acjDzDGvtqrzDHK
         fawjS/HcDsbbbnC74YCIdpAuZc9Vpp8Y423w/PdmpTO5Qbq+p8QWUuqqLi3b94aJS0jq
         e9y8jQxUNaQOSbscKzpmCLcoIYvkv3uMWRoaJmrZva03RrJrJNHrK3tPPKU0xofkrN4H
         KMQipqIzVeD1Z/99KtlFAVZ3dbk7ie5egd95lep3XE0zbikXxin5VE1BTdu1Vkw8ja41
         YKhzONIybnGAtpd96e6x10R89zcnQuGqe06yyySJ2Kn4foLyfs7krMbvMsK1mvlhHJvp
         d0sw==
X-Gm-Message-State: APjAAAXvJ04Va4Ggn80cTCLZW06ddjI/j3jTWvpeEuzfh6xKnyBN+m+n
        o3c1eIoiXE+k181CXvHvCCo=
X-Google-Smtp-Source: APXvYqzToYKFMEvzvWEdWk6mTmkSMmNSEEJM3PIkpoZY38eIfpy8Ev8fJPhmwggC6n+nHu4XY3wsyA==
X-Received: by 2002:a17:902:8d94:: with SMTP id v20mr2737008plo.259.1580511227385;
        Fri, 31 Jan 2020 14:53:47 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id r26sm10876261pga.55.2020.01.31.14.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 14:53:46 -0800 (PST)
Subject: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is
 received
To:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     sjpark@amazon.com, Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, shuah@kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, sj38.park@gmail.com,
        aams@amazon.com, SeongJae Park <sjpark@amazon.de>,
        Yuchung Cheng <ycheng@google.com>
References: <20200131122421.23286-1-sjpark@amazon.com>
 <20200131122421.23286-3-sjpark@amazon.com>
 <CADVnQyk9xevY0kA9Sm9S9MOBNvcuiY+7YGBtGuoue+r+eizyOA@mail.gmail.com>
 <dd146bac-4e8a-4119-2d2b-ce6bf2daf7ce@gmail.com>
 <CADVnQy=Z0YRPY_0bxBpsZvECgamigESNKx6_-meNW5-6_N4kww@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7d36a817-5519-8496-17cf-00eda5ed4ec7@gmail.com>
Date:   Fri, 31 Jan 2020 14:53:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CADVnQy=Z0YRPY_0bxBpsZvECgamigESNKx6_-meNW5-6_N4kww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/20 2:11 PM, Neal Cardwell wrote:

> I looked into fixing this, but my quick reading of the Linux
> tcp_rcv_state_process() code is that it should behave correctly and
> that a connection in FIN_WAIT_1 that receives a FIN/ACK should move to
> TIME_WAIT.
> 
> SeongJae, do you happen to have a tcpdump trace of the problematic
> sequence where the "process A" ends up in FIN_WAIT_2 when it should be
> in TIME_WAIT?
> 
> If I have time I will try to construct a packetdrill case to verify
> the behavior in this case.

Unfortunately you wont be able to reproduce the issue with packetdrill,
since it involved packets being processed at the same time (race window)

