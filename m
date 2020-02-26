Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882801703CB
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgBZQJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:09:04 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38613 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgBZQJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 11:09:03 -0500
Received: by mail-qt1-f195.google.com with SMTP id i23so2623347qtr.5
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 08:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ftwUbeiQjjA+uamd2rvO++0qY3JPTze6du9QkFhLrCo=;
        b=URMtC783jmPNCkaFpOpEOnli9GiML/X8MjPLNarGo0khS3C/LGjLfeuq5mg5bW4Csi
         3/IT3Ean+GBwMjHeGVncM9KJn7rcoa9wu4HXth3+b/f3lP0I/rn78wVipaB1bkQ2DqET
         hX6LEiZb29q6M0J3ICOl2OCiY0wxhYkJpuzOM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ftwUbeiQjjA+uamd2rvO++0qY3JPTze6du9QkFhLrCo=;
        b=o+bE8yaG8/z0icHYfVC9HdDtgcUL1PuJ/cDLBiyabY0/pgXvWmyTIQtt3kgl7Rlo8g
         EaLAcTlTEwD/pySowqtE2FoaEeEeWcNHna1CeaUNcd362g2/x+cJCPIpDurNZ5vwI8lh
         7Pg3AutaoUhsPq6GwpqQwgSBV22LHNywQlPJ+jTM9EVeS+tGzFXWqAqwVU9mhyzRdEGT
         VPP4oCQlSSNO1h5RvQ5IgkXA9r3IJ6d35byVmVu8SoZqBM+pJyXDi2gptmqNziNK4Jgx
         pY97rcnfgbBo/FawDSQxWss8TUB6G2HdIf9yo0RJgVvXUF4SlDB9+DCiaSvIxcEIiDwA
         /viQ==
X-Gm-Message-State: APjAAAUvnkqmRI7nA+tAXuT9+57I6CWxlu+nAnOvggf5phUmxAjdH6Te
        wleYbGK0aZktufA0mADtoXMwz+xOBor2+ZC9
X-Google-Smtp-Source: APXvYqwldWSTNwA1xnaS9ZClyenmi3PPAlkGo6cGY0vj+bS0x87W5TuFEZYsv0pxZwzW99a+ygmi+A==
X-Received: by 2002:aed:2169:: with SMTP id 96mr5763286qtc.124.1582733340977;
        Wed, 26 Feb 2020 08:09:00 -0800 (PST)
Received: from [10.0.45.36] ([65.158.212.130])
        by smtp.gmail.com with ESMTPSA id 89sm1330497qth.3.2020.02.26.08.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 08:08:59 -0800 (PST)
Subject: Re: virtio_net: can change MTU after installing program
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
 <20200226015113-mutt-send-email-mst@kernel.org>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <c8f874c6-3271-6bd1-f3b9-4d0b0786cd52@digitalocean.com>
Date:   Wed, 26 Feb 2020 09:08:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200226015113-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 12:07 AM, Michael S. Tsirkin wrote:
> 
> Well the reason XDP wants to limit MTU is this:
>     the MTU must be less than a page
>     size to avoid having to handle XDP across multiple pages
> 
> however device mtu basically comes from dhcp.

Not necessarily.

> it is assumed that whoever configured it knew
> what he's doing and configured mtu to match
> what's going on on the underlying backend.
> So we are trusting the user already.
> 
> But yes, one can configure mtu later and then it's too late
> as xdp was attached.
> 
> 
>>
>>
>> The simple solution is:
>>
>> @@ -2489,6 +2495,8 @@ static int virtnet_xdp_set(struct net_device *dev,
>> struct bpf_prog *prog,
>>                 }
>>         }
>>
>> +       dev->max_mtu = prog ? max_sz : MAX_MTU;
>> +
>>         return 0;
>>
>>  err:
> 
> 
> Well max MTU comes from the device ATM and supplies the limit
> of the underlying backend. Why is it OK to set it to MAX_MTU?
> That's just asking for trouble IMHO, traffic will not
> be packetized properly.

I grabbed that from virtnet_probe() for sake of this discussion:

        /* MTU range: 68 - 65535 */
        dev->min_mtu = MIN_MTU;
        dev->max_mtu = MAX_MTU;

but yes I see the MTU probe now, so I guess that could be used instead
of MAX_MTU.

> 
> 
>> The complicated solution is to implement ndo_change_mtu.
>>
>> The simple solution causes a user visible change with 'ip -d li sh' by
>> showing a changing max mtu, but the ndo has a poor user experience in
>> that it just fails EINVAL (their is no extack) which is confusing since,
>> for example, 8192 is a totally legit MTU. Changing the max does return a
>> nice extack message.
> 
> Just fail with EBUSY instead?
> 

consistency. If other change_mtu functions fail EINVAL, then virtio net
needs to follow suit.
