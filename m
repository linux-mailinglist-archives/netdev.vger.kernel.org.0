Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F4C39CB9A
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 01:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFEXDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 19:03:48 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:41487 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhFEXDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 19:03:45 -0400
Received: by mail-ot1-f49.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so12919310oth.8
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 16:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/PU/oGXL8JrYmO+Y7A9zhyMMAj5Wc8J1xy8bpC0r4vs=;
        b=g3dQh466HhzccuK7PJ/116EYq9ypoCWQpryDUKeDR0Rp6/Gpp672XMHej9BEnQJwb4
         aLHmCVrEauxcsuELjwop2eg7XLmIwhrTp8x/sOwcyo1uiLdFzXUKW+1/zcee5BrjOJHM
         PFsKc50ihElWIGfF8xyPQk6StH1jcoOO3PLJA5JyMDikoBhJloQqGqz450E6sj2Qg5Gd
         hJ6N5qZHWjpjylOKsaHTyvcoizgvpqoFhdK4QbTfSygsr7Rs7b7lNN7lr/DX2A9jsWGe
         a+5QHdsCbk/BieBO0eI0avfaLRrUEVo3aVYM+yFV1KG+DZo7T6IPpFphW0Lg8PfBpR3p
         vmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/PU/oGXL8JrYmO+Y7A9zhyMMAj5Wc8J1xy8bpC0r4vs=;
        b=WDdiBsHq7kFHTr7VtZMEMZCHekDrXxAvY3IDFryKX6zwsNzmXwj8UE9ZqqQY6xvX63
         p5eXyI+KSCgnxGn1D99kqBUY+bGvikIzWP/BmZYreRg+ptA3QRiZIUlUFRPWP3cF7Zxy
         03Lh2hEhC2tYLxeMLC/ZhYBakHVkNqKGIJPthuEUgS8AuKWVbEM1ITsVtveLzNVU4ppH
         T1YNEoHWwDTTSzCgmoQW0XnxV172yc6KTvetAocB9AfAMVR7PG6vZWHCFMuAtMxEC/cf
         dWitgWpAPTronhcpkvwKPXv+sPwzNRfF4pu44RPzhL6IXm2GEVR9kNyVhqru4459yh3J
         q/JQ==
X-Gm-Message-State: AOAM533vr4LSXnP4e+Z+UD0zUu0RRxAXx5zUxCUj5dpe1CkrSz1cjloC
        OTZsLlG14JtVBS7USi5nP+rHmd2+TEEU6A==
X-Google-Smtp-Source: ABdhPJxaJLsr09lRfAEprvorDWINXgPsxO6vQfiMmePMlxokpNjcJotbQtmeKZw+DAMX+z7ZA9o8xg==
X-Received: by 2002:a05:6830:11ce:: with SMTP id v14mr338040otq.216.1622934057114;
        Sat, 05 Jun 2021 16:00:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id o14sm1368121oik.29.2021.06.05.16.00.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 16:00:56 -0700 (PDT)
Subject: Re: VRF/IPv4/ARP: unregister_netdevice waiting for dev to become free
 -> Who's responsible for releasing dst_entry created by ip_route_input_noref?
To:     Oliver Herms <oliver.peter.herms@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>
References: <20cd265b-d52d-fd1f-c47e-bfa7ea15518f@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <354f3931-1a9a-fff2-182c-d470fe46776a@gmail.com>
Date:   Sat, 5 Jun 2021 17:00:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20cd265b-d52d-fd1f-c47e-bfa7ea15518f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/5/21 11:16 AM, Oliver Herms wrote:
> Processing the incoming ARP request causes a call to ip_route_input_noref => ip_route_input_rcu => ip_route_input_slow => rt_dst_alloc => dst_alloc => dev_hold.
> In a non VRF use-case the dst->dev would be the loopback interface that is never deleted. In the VRF use-case dst->dev is the VRF interface. And that one I would like to delete.
> 
> I've tracked down that dst_release() would call dev_put() but it seems dst_release is not called here (but should be I guess?). Thus, causing a dst_entry leak that causes the VRF device to be unremovable.
> At least that's what it looks like to me.
> 

I see what the problem is -- rtable is on cached on the l3mdev port
device. I have an idea how to fix it; I will send a patch within a few
days. Thanks for the detailed analysis and report.
