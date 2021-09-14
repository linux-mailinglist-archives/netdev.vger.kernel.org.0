Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1738440B64B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhINR5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhINR5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 13:57:11 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEB5C061762
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 10:55:53 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f129so13488162pgc.1
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 10:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d+O3i0F+ceQIU0vBcZ3oD4mbrObHGn1BdI3/QLpSLSY=;
        b=Fp486M0oWZTol7zhBpsQ1noicP78FuOqOTf+Fqfd5QQNmrDED0+zBENqWNL3l+HwCT
         9U1KuPo5pjBWZorU5mCqLaLZ/hjwlu2vBfokc4TODQJwHWxDoE0InNViar0avaMwDb4O
         QY0/UtSigFbKsDTpdBllrR4b8jqefaIeGJUo2GzHmkrpPPkWK1m+zoPVu7nh5L2qE5cz
         z+y0QjfIw2U3qxRk8MOZVSjTysbOL8mWNong8mncn8/jqgztG6clVfreLo+llpuMzjXt
         cGNzWChHZkXxPQu5r4U1sULweUOEPFcofS8A+o/ApUrXzDh1WxdX5UEcMVN17hff9C3N
         pGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d+O3i0F+ceQIU0vBcZ3oD4mbrObHGn1BdI3/QLpSLSY=;
        b=y/T73IIvC5yUxlh4TUDjwqJaW3uXjl+VOmSkf1MCpcgfLIKuxphX/qYD/MVVdLHu+p
         Zi1uQ/9+Gcex/gR9l3aWell8Ahpj6w159OHppjnQ0Mf8LFvch95V0NA12saoUytoJWzQ
         qbCWZ4Pyq8CivhYFpZ/DixGFEhzUGV4wJvRRyzH39+YvPTO/LYnULiJKX3Gm3M/sP4aa
         vLwFeyvIAUWs27wnWOSvJrT4jWCDDF2xcOVGhsnGoPk85VcCVFBRKr2AjkNnXe85v7JI
         HNEWVBXq7ds0KJO1OoUPHSqrrBOCtlvfj4iicJ7bZLLbuqMtr7ZabrYCyNF60fA/QmXv
         JxYQ==
X-Gm-Message-State: AOAM5312f8S81Q3JHdV6yFtnG1m+xqpWXL0AVLJmo0Z/pdTADAd+kgt+
        Hqlx7SRkc3+JDDrfNCVQcxAJVpNLX48=
X-Google-Smtp-Source: ABdhPJxthceZKGLpGqEqzTZCegWqY3gw6jU4IWD2V82UAh2iTc9wXc3GNujoiOC9UwDo+M1AT/hH5Q==
X-Received: by 2002:a62:645:0:b0:3f2:23bd:5fc0 with SMTP id 66-20020a620645000000b003f223bd5fc0mr6027222pfg.35.1631642152721;
        Tue, 14 Sep 2021 10:55:52 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u10sm10440618pfh.105.2021.09.14.10.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 10:55:51 -0700 (PDT)
Subject: Re: [RFC net] net: stream: don't purge sk_error_queue without holding
 its lock
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     willemb@google.com, netdev@vger.kernel.org
References: <20210913223850.660578-1-kuba@kernel.org>
 <3b5549a2-cb0e-0dc1-3cb3-00d15a74873b@gmail.com>
 <20210914071836.46813650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c945d4ee-591c-7c38-8322-3fb9db0f104f@gmail.com>
 <20210914095621.5fa08637@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8ce5b709-17bb-ea01-48b4-b80447fb5d3f@gmail.com>
Date:   Tue, 14 Sep 2021 10:55:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210914095621.5fa08637@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/21 9:56 AM, Jakub Kicinski wrote:

> Right, but then inet_sock_destruct() also purges the err queue, again.
> I was afraid of regressions but we could just remove the purging 
> from sk_stream_kill_queues(), and target net-next?
> 

Yes, this would be the safest thing.

>> If you think there is a bug, it must be fixed in another way.
>>
>> IMO, preventing err packets from a prior session being queued after a tcp_disconnect()
>> is rather hard. We should not even try (packets could be stuck for hours in a qdisc)
> 
> Indeed, we could rearrange the SOCK_DEAD check in sock_queue_err_skb()
> to skip queuing and put it under the err queue lock (provided we make
> sk_stream_kill_queues() take that lock as well). But seems like an
> overkill. I'd lean towards the existing patch or removing the purge from
> sk_stream_kill_queues(). LMK what you prefer, this is not urgent.
> 

The issue would really about the tcp_disconnect() case, 
followed by a reuse of the socket to establish another session.

In order to prevent polluting sk_error_queue with notifications
triggered by old packets (from prior flow), this would require
to record the socket cookie in skb, or something like that :/

