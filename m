Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81CD154AF9
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 19:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgBFSWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 13:22:06 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53417 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFSWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 13:22:06 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so324379pjc.3;
        Thu, 06 Feb 2020 10:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=54PTuSGsMZatUFJRggtY0ZPnRku13hgus2gUwpQbThU=;
        b=DJLL31cIptj/JwJcmnMQuxDCWzG2NMEB6d9KrNH6uxNCq67elwx9LgMDTuxpVwRbbk
         XwEOrvQvrCHraqAaw816Izx2l8FxTFAlH1kq1VvfyscsvOEZH7dqaZyoaZg5JzgQbHbk
         xcQqN98XAUYsu2rtjhS4TpFtiSDKxD1eyofrc5299fFy3rXmINeMHuogOsz5FsolJmJ8
         F6HgLdZEh5GkHzD4RrsqSRerTI7s1+YUUu73wDW409NSCyyLbMY78MJ5NxPmfUVRDCGL
         sO+9U4iMiVhcmLBDvShR+6d/bDHtpI15r1jti12JrNM60KxMeiQ8jpyITR8LBZnZV5FJ
         4zag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=54PTuSGsMZatUFJRggtY0ZPnRku13hgus2gUwpQbThU=;
        b=sxnwUBvbWTsfsRu4pBOC6kHzGCFeMom9CYJb0rm4/hLpPYytUNyczuo+kbdTRcEhva
         Ko2BdUohrx8p6ocbPFUvgxaezTQmWk0401cYKMPFRozrgjQXV39UQyU4Qn2ouO0agDg6
         iyWbUAbrnscCbOvaZ8f7WL4g5t+v1wcBzrojfW9wm1KgYmVNBPxjQurpbVC85GaSo6qB
         GnfwJ4biDhkEoIDw/XtvgytjrcOfZ2dTZWluzYY98aNysVPoB/Mspsx/LCiekfhi6HKL
         77CxUaejjAVgPhYVqYnpUXjGkDye+LbymbiVlLMuEW3HxACkvD1xuSMjUq+UlLu48Fg3
         5wBQ==
X-Gm-Message-State: APjAAAWcdIfla3B7byywFHw4XVqJ4i+wy5d0F0sUXZ+KGWHpfU4Mbo5B
        hfrlLaerEOEDPUVf1UqMPH4=
X-Google-Smtp-Source: APXvYqx9NC0lS1YLI/cu7N2wMO7HYmfx9BmQLUKvvEnN5VeJHLaRrQvN2FMNEpsoEBLSR6NhFv5h+w==
X-Received: by 2002:a17:902:a984:: with SMTP id bh4mr5291321plb.281.1581013325916;
        Thu, 06 Feb 2020 10:22:05 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id i6sm95146pgm.93.2020.02.06.10.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 10:22:05 -0800 (PST)
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     cai@lca.pw, Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <1580841629-7102-1-git-send-email-cai@lca.pw>
 <20200206163844.GA432041@zx2c4.com>
 <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com>
 <CAHmME9pGhQoY8MjR8uvEZpF66Y_DvReAjKBx8L4SRiqbL_9itw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <495f79f5-ae27-478a-2a1d-6d3fba2d4334@gmail.com>
Date:   Thu, 6 Feb 2020 10:22:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHmME9pGhQoY8MjR8uvEZpF66Y_DvReAjKBx8L4SRiqbL_9itw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/6/20 10:12 AM, Jason A. Donenfeld wrote:
> On Thu, Feb 6, 2020 at 6:10 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Unfortunately we do not have ADD_ONCE() or something like that.
> 
> I guess normally this is called "atomic_add", unless you're thinking
> instead about something like this, which generates the same
> inefficient code as WRITE_ONCE:
> 
> #define ADD_ONCE(d, s) *(volatile typeof(d) *)&(d) += (s)
> 

Dmitry Vyukov had a nice suggestion few months back how to implement this.

https://lkml.org/lkml/2019/10/5/6

