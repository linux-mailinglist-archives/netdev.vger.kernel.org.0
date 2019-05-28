Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3BFE2C351
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfE1Jbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:31:44 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:33550 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfE1Jbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:31:44 -0400
Received: by mail-ed1-f53.google.com with SMTP id n17so30807704edb.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 02:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FH/R6gNvM8817hAr70N1Gzf78GTZQUDZAlgnxXzC57M=;
        b=lNgIQIMbr97xVB6StNZtkfSMircOpwU/dYKnYxQ1/oti/ZdQyuuSB3e2i4STaj/LDJ
         sL54SzjG6Bgc0ZwalM4/HSqZdXJevkNCYLbI9fh7n/uVzsDY3aUrNokZT4yW0nvJt4kL
         vsvPhdGg3Ukx8nz4YmfiGsck4doTGVvJn73ksprjyXRptc04IXGBzezuvyk2/TCb/KOC
         wDJOFX6Q/NoPtkxgnCtLotw2do3moEmOK5ROvZ+Ek6f7NGb+UJV36MjzFNt644vrV0Nc
         ow+qQ8DYIIO2T1BUCBfMshvoqSOcADuJ38B60DZKHFfb1+vkj6BfVb3XWFf1T84Hm3KW
         mr6A==
X-Gm-Message-State: APjAAAWrHiMVo/nnwvAxofUfbdLrq4zShyjPALakwHHTKGlYY0dWmAzP
        gGOSXONWAlysC9lf37TsWmTn+CPBjN4=
X-Google-Smtp-Source: APXvYqxWuiQzBw14jLn30t2EZeWF+Nb6O72AV5Xzm4E9SXD5K7r1AdAzgPZShqUb/RW4aAjq51Ff4w==
X-Received: by 2002:a17:906:34da:: with SMTP id h26mr5334314ejb.247.1559035902687;
        Tue, 28 May 2019 02:31:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id f44sm4133104eda.73.2019.05.28.02.31.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 02:31:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DF4BB18031E; Tue, 28 May 2019 11:31:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Akshat Kakkar <akshat.1984@gmail.com>,
        netdev <netdev@vger.kernel.org>, lartc <lartc@vger.kernel.org>
Cc:     cake@lists.bufferbloat.net
Subject: Re: Cake not doing rate limiting in a way it is expected to do
In-Reply-To: <CAA5aLPgz2Pzi5qNZkHwtN=fEXEwRpCQYFUkEzRWkdT39+YNWFA@mail.gmail.com>
References: <CAA5aLPgz2Pzi5qNZkHwtN=fEXEwRpCQYFUkEzRWkdT39+YNWFA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 May 2019 11:31:40 +0200
Message-ID: <875zpvvsar.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ adding cake list ]

Akshat Kakkar <akshat.1984@gmail.com> writes:

> Cake is expected to handle traffic in 2 steps :
> First is on the basis of host
> Second is within every host, on the basis of flow
>
> So, if I limit traffic to 20Mbps shared across 2 host A & B,
> Following are various scenarios, expectation and observations
> 1. If either A or B is downloading, they will be getting speed of 20Mbps
> Observation: Meeting with expectation
>
> 2. If both A & B downloads (single download each), each will be
> getting speed of 20Mbps
> Observation: Meeting with expecation but its very jittery (around
> 20%), i.e. speed varies from 8Mbps to 12 Mbps. If I use fq_codel speed
> is same BUT jitter is very less (around 1%).
>
> 3. Now if A starts 3 downloads, and B is still having single download,
> A each download should be around 3.3 Mbps and B should be around
> 10Mbps
> Observation: Around 5 Mbps for each download with lot of jitter, i.e.
> no advantage of having CAKE!!!
>
> Linux Kernel 4.20
> For case 3, output of command : tc -s class show dev eno2
>
> class htb 1:1 root leaf 8003: prio 1 rate 20000Kbit ceil 20000Kbit
> burst 200Kb cburst 1600b
>  Sent 688474645 bytes 455058 pkt (dropped 0, overlimits 381196 requeues 0)
>  rate 19874Kbit 1641pps backlog 21196b 14p requeues 0
>  lended: 382532 borrowed: 0 giants: 0
>  tokens: 1260573 ctokens: -9427
>
> class cake 8003:44f parent 8003:
>  (dropped 3404, overlimits 0 requeues 0)
>  backlog 9084b 6p requeues 0
> class cake 8003:516 parent 8003:
>  (dropped 3565, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
> class cake 8003:590 parent 8003:
>  (dropped 3023, overlimits 0 requeues 0)
>  backlog 4542b 3p requeues 0
> class cake 8003:605 parent 8003:
>  (dropped 1772, overlimits 0 requeues 0)
>  backlog 7570b 5p requeues 0

Could you please share some more details of your setup? The output of
`tc -s qdisc show dev eno2`?

How are you running the download tests? Is this over the internet, or in
a controlled setup? What's your actual line rate? Are you using ingress
shaping as well?

It looks like you are using HTB for rate limiting on top of CAKE? Why?

-Toke
