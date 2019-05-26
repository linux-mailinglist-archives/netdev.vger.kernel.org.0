Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C21A2AA55
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 16:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfEZOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 10:50:13 -0400
Received: from mail-vk1-f179.google.com ([209.85.221.179]:45700 "EHLO
        mail-vk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbfEZOuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 10:50:13 -0400
Received: by mail-vk1-f179.google.com with SMTP id r23so3271800vkd.12
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 07:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vgHILZbbD5aADedVLk7a/d3AQ9sKsPK1/g7n34pvW3E=;
        b=RXXnIvDSkJIGsfHnL8s54TV5A6iLUGDzzEWuiBX6uDRE2i5xY8d7VpegSlhsR3u60v
         GcBrKMVULlJXZOg4auXADEJmOHkVfXKjFw3ysLhsgZvK+izFxXheeqIOIBO+LlWG6EAc
         3YpwLh0kS7pIunJ0DrydOAlIXb1/ycfTp4RgB3isW26/NltcxObUDA+iHYNeE71kfyED
         HNqbgL5lJxDIctUgZIx+5AT8E6YfDAVl+kthHKmBjCeScSZD5G2zGSsbBragQ8TAX/pd
         IG/SO56f4ure5RljLtfuJfAiJz7fJmPTHQ3mnvKiXpzs3X8XKzSn7Vx823yPIFCH5J2a
         NWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vgHILZbbD5aADedVLk7a/d3AQ9sKsPK1/g7n34pvW3E=;
        b=sDyRiA8FSkWlLyQRh6erV8nDKSQZ6uw29W8Gk3ykea/ZSrLtMc5lSmG/13tvpIQQok
         gO6ZuRafgZO3NT5a+PGgKNUWBVlx7LFVv7Untgm9Av3C+xySnY8KRLtvZ2aSjipcSreP
         +Hp2lm7vlUfcPlFETKBmC/XtD2CkXXoKUxRFZ0L2x5X+kr7o1cN+rzIN4UPq+txzSDj6
         Q4tZrm6w8LPFJRFiPCrl1giSnOlJk3MsrejtrqXpFTj4jGgyqiWA2Yl9AjVku+gLRgJZ
         2F2bYine94arU+O5rUl64GBCxnY8yH+GY0Ss5PL54vaGUNA5flHUk7+1EmpTm68rTMqi
         3cpA==
X-Gm-Message-State: APjAAAUg31ph7u1HpOqlqNvc+vha5nVP54ea8r1MdUY+fA9hI/f6me+q
        wFcpAjJqmagbZ//cBHhI7rQFmA==
X-Google-Smtp-Source: APXvYqzSoe09/FZWRacvvYGfCfF0AIK9fgmmfuSZ9u1d0Tqsl3rCcRn19ZyV4LOVQkProJfXmewv+A==
X-Received: by 2002:a1f:9390:: with SMTP id v138mr14242906vkd.48.1558882212339;
        Sun, 26 May 2019 07:50:12 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id 69sm9823166uas.0.2019.05.26.07.50.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 07:50:11 -0700 (PDT)
Subject: Re: [RFC net-next 1/1] net: sched: protect against loops in TC filter
 hooks
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Hurley <john.hurley@netronome.com>,
        netdev@vger.kernel.org, jiri@mellanox.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, alexei.starovoitov@gmail.com
References: <1558713946-25314-1-git-send-email-john.hurley@netronome.com>
 <531c9565-5e42-3c87-891e-1cae13ae89bf@iogearbox.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <8713ca0b-81e5-ed11-bf14-11b80db38153@mojatatu.com>
Date:   Sun, 26 May 2019 10:50:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <531c9565-5e42-3c87-891e-1cae13ae89bf@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-24 2:32 p.m., Daniel Borkmann wrote:
> On 05/24/2019 06:05 PM, John Hurley wrote:
>> TC hooks allow the application of filters and actions to packets at both
>> ingress and egress of the network stack. It is possible, with poor
>> configuration, that this can produce loops whereby an ingress hook calls
>> a mirred egress action that has an egress hook that redirects back to
>> the first ingress etc. The TC core classifier protects against loops when
>> doing reclassifies but, as yet, there is no protection against a packet
>> looping between multiple hooks. This can lead to stack overflow panics.
>>
>> Add a per cpu counter that tracks recursion of packets through TC hooks.
>> The packet will be dropped if a recursive limit is passed and the counter
>> reset for the next packet.
> 
> NAK. This is quite a hack in the middle of the fast path. Such redirection
> usually has a rescheduling point, like in cls_bpf case. If this is not the
> case for mirred action as I read your commit message above, then fix mirred
> instead if it's such broken.
> 

Actually a per-cpu approach will *never* work. This has to be per-skb
(since the skb is looping).
Take a look at the (new) skb metadata encoding approach from Florian;
you should be able to encode the counters in the skb.

cheers,
jamal
