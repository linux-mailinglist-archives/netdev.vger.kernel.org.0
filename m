Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FED15BBC1
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgBMJeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:34:24 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43331 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbgBMJeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 04:34:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id r11so5719622wrq.10
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 01:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zjhr5rW1dJMZ/N+XBl5513kAULkwCi/USVcngZ0gpCM=;
        b=UsqN/j7PjDKfJHP2BgPaJvc2NnPcEaMikgZGr1DKZWqJnvsXYAkNRyrpZP6nZDzZ6P
         BqtxGGtU2vdyU4aY0yq+++h0i6gG6EZ9tH0SChHyGtDioKwo7g8391iLlq3cCTE+dswd
         rxF6XJCgOBnzBUl6sTxy4wbTid9rQ4mmwQp3qjPalEiNgsRKDJVRM5QSz58ejh0OOJvS
         Sblewd6QiEMa/UEt3tL4qw2kjtahvut15q32Z9PswHm9F5AB1Jp2pRom5yllXqkP4bVS
         6zdnIQvf+SsNWA3ahIyCF7Eq06ipx/5/I4S09nIQU8ZAI60spJI0dv46vltaWhdE0NQo
         MWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zjhr5rW1dJMZ/N+XBl5513kAULkwCi/USVcngZ0gpCM=;
        b=QPxpnn5esWkDIHdy+Qy7UnxGspGCbtB4hogIRpxD3e781zMLeNWzgi9a2Jl2e2JfiZ
         bR4/tMn2yrcjNxD+Ca4Z9k3Jjet6vfOK6HrWJLDtesJgFzjqEQI2zSBXq3ic+FLnNZIm
         wZ8OT1p3/9/EAkBH463+Yvm5u58zyf6SLzDiGZ6SzUtRgWLlaSd4tDVCbx0FNt1NvvB/
         5SY8Wed+xrjARu5z0z44/ey7IrTb3gEdtvH9SMFuHmyP49Cp8X01vRFn2RQyrWh6z/Gb
         1ijBLDoTQL3gKwLyw9VvW+GvZMt1BBTY02zWvx9/X52OWIagEcLrDKyFtNxaCJ8GuIXU
         Ivqg==
X-Gm-Message-State: APjAAAWu8M4gCCttvVjo50kllgHDYM0q9hmH+UMGboaSFKoznpi1nboM
        VzNg/RDS3+5SDQV5GIxifkOt3iHtKCM=
X-Google-Smtp-Source: APXvYqzUaprYw5flm0EiZCl5in52HjS3eNvgAxwbG6NUo6NXFGb4Vs5oV8ohJOlyaVjj4dN1yOiCWA==
X-Received: by 2002:a5d:4f0f:: with SMTP id c15mr21887649wru.251.1581586461205;
        Thu, 13 Feb 2020 01:34:21 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:69db:fab1:ccba:51cb? ([2a01:e0a:410:bb00:69db:fab1:ccba:51cb])
        by smtp.gmail.com with ESMTPSA id t13sm2111291wrw.19.2020.02.13.01.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 01:34:20 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v3 net] net, ip6_tunnel: enhance tunnel locate with link
 check
To:     William Dauchy <w.dauchy@criteo.com>
Cc:     netdev@vger.kernel.org
References: <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
 <20200212083036.134761-1-w.dauchy@criteo.com>
 <ce1f9fbe-a28a-d5c3-c792-ded028df52e5@6wind.com>
 <20200212210647.GB159357@dontpanic>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <cc378ec7-03ec-58ec-e3c9-158fb02b283e@6wind.com>
Date:   Thu, 13 Feb 2020 10:34:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200212210647.GB159357@dontpanic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/02/2020 à 22:06, William Dauchy a écrit :
> Hello Nicolas,
> 
> Thank you for your review.
> 
> On Wed, Feb 12, 2020 at 04:54:19PM +0100, Nicolas Dichtel wrote:
>> Hmm, I was expecting 'tdev->mtu - t_hlen'. Am I wrong?
>>
>> In fact, something like this:
>> dev->mtu = ETH_DATA_LEN - t_hlen;
>> if (t->parms.link) {
>> 	tdev = __dev_get_by_index(t->net, t->parms.link);
>> 	if (tdev)
>> 		dev->mtu = tdev->mtu - t_hlen;
>> }
> 
> true, I missed that one; I reworked to something like:
> 
> int mtu;
> 
> mtu = ETH_DATA_LEN;
> if (t->parms.link) {
> 	tdev = __dev_get_by_index(t->net, t->parms.link);
> 	if (tdev && tdev->mtu < mtu)
Why this second condition? Why not allowing more than ETH_DATA_LEN (1500)?
ip_tunnels do:
        if (tdev) {

                hlen = tdev->hard_header_len + tdev->needed_headroom;

                mtu = min(tdev->mtu, IP_MAX_MTU);

        }
which seems better.

Note also that you patch ip6_tnl_dev_init_gen(), but ip6_tnl_link_config() is
called later and may adjust the mtu. I would suggest to take care of link mtu in
ip6_tnl_link_config().

> 		mtu = tdev->mtu;
> }
> dev->mtu = mtu - t_hlen;
> 
> 
> However in ipip we do:
> 
> mtu -= (dev->hard_header_len + t_hlen);
> 
> Do I need to use hard_header_len as well?
hard_header_len is not set for ipv4 tunnels, but for ipv6 tunnels:
        dev->hard_header_len = LL_MAX_HEADER + t_hlen;

This is not the real value, I don't think you can calculate the real mtu based
on this.


Regards,
Nicolas
