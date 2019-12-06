Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEB9114B7C
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 04:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfLFDpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 22:45:50 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44676 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLFDpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 22:45:50 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so2579494pgl.11
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 19:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ur4KnnYJ0yU+4DjjGCvcvzWXhKbPRugUgOebRpcWe4=;
        b=rJs7BvzrlyeG1DQatisVAwI01N2nJ9yqq3ctS8bXqRFsa/PokgcufH7tlE0gdxRxUn
         +q/ALg8GxxePdYYjR2f5Nko/YisKe7gSjmTEnb9XReJCV4IjwWEETMlj6OjfCYYLdS/k
         B0G6Zj3sb2pCbay5No7w20RLGz3Xji5rMfkupz1OWWft+Jyi69GTXDIBnFgcHpyv1eEh
         Qx7W010wtgZrqaWcpANqp1vkNehWEB+gKW9vnmu/q2V/Pz71jmSr4yc6Ixlfaf/9Xia7
         cPnmpyKTHlSsYtow6Q/yq8BtiXKGiBgOdI51Qn/2YV50qCoYY4p+Xx/tcOIFGiLyTIMN
         SdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ur4KnnYJ0yU+4DjjGCvcvzWXhKbPRugUgOebRpcWe4=;
        b=eYsoU5C+PLcIDC56NBuHpdu4iLJRYmwUr8fJY07o0HuC/vUAlyYnuunVNGBuaTFhG1
         fXNwrxbE6xQ9JaxFFaj6Ey1f7u6o/hcAaBhkEkMlMVNf7Nywt62uZ1osSbOg/Ernf6OL
         TXD4AW2FtPAUt6CrjVV1YXArOjd2oNyKHtU7LPGplwnBsC4KHmjnicdV7BgKAP8UULQc
         mtmSzmgU/5To23waii0boHoduNvJ4Ns5w1FbFQPebDA8+I6YV0nNpVPpsDFiZytAC9Yi
         5kSG4K2gyMkfMSyYwC8Dd/3hrxS25cxTZ5DrURQSeqbvb4EVEjURGEA4EBtjkLv0Va51
         yTaw==
X-Gm-Message-State: APjAAAVP/CbyIY22zGrfuZLCyeiC+fY6kkT+4Lglk4hB7UFp0jhWP2s8
        uJ3vWw8+84rECYeYGJN0t4g=
X-Google-Smtp-Source: APXvYqyTSrIHuqXAYkLjh9NuqvkcbYlBy1HmzLTyqiVXmMaTLfp5AFpsLoPsxn5mPk6INENCX3FY1g==
X-Received: by 2002:a62:2687:: with SMTP id m129mr319557pfm.173.1575603949746;
        Thu, 05 Dec 2019 19:45:49 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b16sm13175996pfo.64.2019.12.05.19.45.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 19:45:49 -0800 (PST)
Subject: Re: [PATCH net v3 2/3] tcp: tighten acceptance of ACKs not matching a
 child socket
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
References: <cover.1575595670.git.gnault@redhat.com>
 <05f412281ffe11a603260c849851df39c0e8c952.1575595670.git.gnault@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f68c51a4-6c25-dcf8-3bb3-7d8511164f67@gmail.com>
Date:   Thu, 5 Dec 2019 19:45:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <05f412281ffe11a603260c849851df39c0e8c952.1575595670.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/19 5:49 PM, Guillaume Nault wrote:
> When no synflood occurs, the synflood timestamp isn't updated.
> Therefore it can be so old that time_after32() can consider it to be
> in the future.
> 
> That's a problem for tcp_synq_no_recent_overflow() as it may report
> that a recent overflow occurred while, in fact, it's just that jiffies
> has grown past 'last_overflow' + TCP_SYNCOOKIE_VALID + 2^31.
> 
> Spurious detection of recent overflows lead to extra syncookie
> verification in cookie_v[46]_check(). At that point, the verification
> should fail and the packet dropped. But we should have dropped the
> packet earlier as we didn't even send a syncookie.
> 
> Let's refine tcp_synq_no_recent_overflow() to report a recent overflow
> only if jiffies is within the
> [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval. This
> way, no spurious recent overflow is reported when jiffies wraps and
> 'last_overflow' becomes in the future from the point of view of
> time_after32().
> 
> However, if jiffies wraps and enters the
> [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval (with
> 'last_overflow' being a stale synflood timestamp), then
> tcp_synq_no_recent_overflow() still erroneously reports an
> overflow. In such cases, we have to rely on syncookie verification
> to drop the packet. We unfortunately have no way to differentiate
> between a fresh and a stale syncookie timestamp.
> 
> In practice, using last_overflow as lower bound is problematic.
> If the synflood timestamp is concurrently updated between the time
> we read jiffies and the moment we store the timestamp in
> 'last_overflow', then 'now' becomes smaller than 'last_overflow' and
> tcp_synq_no_recent_overflow() returns true, potentially dropping a
> valid syncookie.
> 
> Reading jiffies after loading the timestamp could fix the problem,
> but that'd require a memory barrier. Let's just accommodate for
> potential timestamp growth instead and extend the interval using
> 'last_overflow - HZ' as lower bound.
> 
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>

