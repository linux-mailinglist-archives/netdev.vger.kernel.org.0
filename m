Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32463355F38
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbhDFXGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbhDFXGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:06:19 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E50C06175F
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 16:06:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l123so10023353pfl.8
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 16:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=M9v/Usc+p6+MRicpD8hTWmhjFSrbNzS4rcqUrk8I+SY=;
        b=wmYrNLw8A7xo9IvBI/j9uVEBmXjGBSEDAE1kM1+4yo9UCy5+A9TI/R/yWj+DNT969S
         KER/JJILA/8HgGIB3c0shJMjPG31av1jkkOZYqejOiPjMOI1XDIQw98lStrRY9XH6dK7
         WZugjIwHaWNDB61w1lkPSwr9l+ZDj9z8bUCMtPAmANUcIKMxJyeylwaykNOgsRdKJmg0
         x5bW+raEFXbv20p1Lq/IqKPawLx4rexjttV7dMhMJ2f0fBaUyyxC2XcvJEiFyoH8dzLO
         X6+ZzFbzoW6bHBI063xSnyU8Is0wxUG9Nht3Kvz+cDUYgmEhrWg3wro5q1beceN7GwvD
         Pjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=M9v/Usc+p6+MRicpD8hTWmhjFSrbNzS4rcqUrk8I+SY=;
        b=P1RZBXCHKe9XGTEVJ5gJGoGmhQCmiXBVMyee5UM/WI88GNg788Y27V0MfOD4HYAokE
         zjgQolYCK3yjsGyrF5pleQuu0XFIx2bc9bgK9ZUftTbbopMqy2kxe77HG0RRw8m2M0vM
         iw9IUNb44Ut6XTEiQeaJqNq7CEVh4bKtvGcJ+nwl5yoFp54ZycEbrvQNV4lIuHCTH8e1
         okR8+UDBVQwVULEBfg2IlTKsxF1IJHeMuK7R2BrFyngMmM8wD15s/E+l+2OOfLExlSre
         8n9mHuEbzNj5Dcu2fNXZ1N3PzRIYRHuIsZEDj+W+PtDbTnaEnvvkjRUB5t7Of7PvF2vq
         aK4g==
X-Gm-Message-State: AOAM531grTrMhzbQ3RfsewR8y2rwG8Y1Y4l7DY2ZJ8DZHTEz3sS8Kvog
        iAfvUs5ecNKpUQBKmXTiIBU7jA==
X-Google-Smtp-Source: ABdhPJyHx51BdUnU+JKZNc/Aylk76PqRBrZQ6B7U5ZijwiPjTLL+z5ALRawigDXSzYamXm946V4EiQ==
X-Received: by 2002:a63:2214:: with SMTP id i20mr440085pgi.189.1617750370837;
        Tue, 06 Apr 2021 16:06:10 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x22sm19612303pfc.163.2021.04.06.16.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 16:06:10 -0700 (PDT)
Subject: Re: [PATCH net-next 09/12] ionic: add and enable tx and rx timestamp
 handling
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-10-snelson@pensando.io>
 <20210404234107.GD24720@hoboy.vegasvil.org>
 <6e0e4d73-f436-21c0-59fe-ee4f5c133f95@pensando.io>
 <20210405182042.GB29333@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d9f49805-e1da-23ab-110f-75e3e514f2a1@pensando.io>
Date:   Tue, 6 Apr 2021 16:06:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405182042.GB29333@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/21 11:20 AM, Richard Cochran wrote:
> On Mon, Apr 05, 2021 at 09:28:44AM -0700, Shannon Nelson wrote:
>> On 4/4/21 4:41 PM, Richard Cochran wrote:
>>> On Thu, Apr 01, 2021 at 10:56:07AM -0700, Shannon Nelson wrote:
>>>
>>>> @@ -1150,6 +1232,10 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
>>>>    		return NETDEV_TX_OK;
>>>>    	}
>>>> +	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
>>>> +		if (lif->hwstamp_txq)
>>>> +			return ionic_start_hwstamp_xmit(skb, netdev);
>>> The check for SKBTX_HW_TSTAMP and hwstamp_txq is good, but I didn't
>>> see hwstamp_txq getting cleared in ionic_lif_hwstamp_set() when the
>>> user turns off Tx time stamping via the SIOCSHWTSTAMP ioctl.
>> Once the hwstamp queues are up, we leave them there for future use until the
>> interface is stopped,
> Fine, but
>
>> assuming that the stack isn't going to send us
>> SKBTX_HW_STAMP after it has disabled the offload.
> you can't assume that.  This is an important point, especially
> considering the possibiliy of stacked HW time stamp providers.  I'm
> working on a patch set that will allow the user to switch between MAC
> and PHY time stamping at run time.
>
> Thanks,
> Richard

Interesting... I doubt that our particular MAC and PHY will ever be 
separate, but it makes sense to watch for this in the general case. I've 
got an update coming for this.

Thanks,
sln

