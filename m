Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1403ADF04
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 16:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhFTO0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 10:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbhFTO0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 10:26:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9D8C061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:23:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i4so3433723plt.12
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OOVK0BASsZ2veVA9APW2K1BKekXiwflPVEz/kYHMY1k=;
        b=BP7AX2R8WBcqHbMvhvI8eyAZ5jlVTORAO//6UVlWjt8N3JtssrNCuxGzJbOCYGGZbl
         AIy3EiB26LpMvgeTTUOwJV5+lwCoN0TylkHoQfqjiJoYxLUI1POVVV0Hh9pVlPxEU37U
         J/Y0tHw2oPf3CwQQosE7Dmj/4C+iZ6sZNSu2lQpjnSRIaTy1jV0/5sWiugmgY6v0piO8
         uravQ0sVhc9mUE0/ayIvlo9Bfwi3bqaNjxacAFVFi2+Pa5RaBqDrPF6VYt8ly5+6iWqU
         OuWI9u04GX5M+Xd/ZulXaIhX0fbtMs12QznhD+4uHlB+YHUJqOAJRRU4GQMLmqeaJVxW
         f9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OOVK0BASsZ2veVA9APW2K1BKekXiwflPVEz/kYHMY1k=;
        b=mqVI+h8qoHGvUGye/AwZkuDKVVKH1a2Zm9yJ8PeMARodTIaF14u4Bolhay5tSwt/90
         UvyAvKEKeQsntf7iNeKPnTHkG2/LS+aYOsz6OoHbJVTcK6Nt7gLmGf8EYzry+FdEHorB
         HNp9V2TBbZ+GdjuMEYt2BzmTBmHufklM7Yf7M5ZfyZmySPeGfhLY4Nx/l6LYIJ2oJoRy
         RdlyO3guP8USEk7Cvfh+uEtAQ1BcuJXUA/8XjRur+haLExBTUE5tJIGAR7HzsRQ0fpZ+
         +jp2ag7k+onerekVtuT6/FqLbaxADO2eXJWxYrQEVMJRvIQV5vuf3frwfuxZ18xBEIQV
         ukpA==
X-Gm-Message-State: AOAM531iCice5w8pvxVSEkW7ER9fcKEA+3BK7FTccLn6goyR6vnAZcIn
        Kk9vgj/Mfi3vaItQaPgApEY=
X-Google-Smtp-Source: ABdhPJzzKUkRHTbOqrYHqG+6vGTbXmpf8HtEIirs/Njccnw0IMoMvZDNGpMnYEgEYJp07Wl2PZd2uA==
X-Received: by 2002:a17:90a:c8b:: with SMTP id v11mr32140419pja.114.1624199025391;
        Sun, 20 Jun 2021 07:23:45 -0700 (PDT)
Received: from [10.230.24.159] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id q23sm13931037pgm.31.2021.06.20.07.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 07:23:44 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] net: dsa: calculate the largest_mtu across
 all ports in the tree
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
 <20210618183017.3340769-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c10dcd29-c601-93ed-e844-6c75ca3a74b4@gmail.com>
Date:   Sun, 20 Jun 2021 07:23:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618183017.3340769-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2021 11:30 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> If we have a cross-chip topology like this:
> 
>    sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
> [  cpu  ] [  user ] [  user ] [  dsa  ] [  user ]
>                                   |
>                                   +---------+
>                                             |
>    sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
> [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
> 
> and we issue the following commands:
> 
> 1. ip link set sw0p1 mtu 1700
> 2. ip link set sw1p1 mtu 1600
> 
> we notice the following happening:
> 
> Command 1. emits a non-targeted MTU notifier for the CPU port (sw0p0)
> with the largest_mtu calculated across switch 0, of 1700. This matches
> sw0p0, sw0p3 and sw1p4 (all CPU ports and DSA links).
> Then, it emits a targeted MTU notifier for the user port (sw0p1), again
> with MTU 1700 (this doesn't matter).
> 
> Command 2. emits a non-targeted MTU notifier for the CPU port (sw0p0)
> with the largest_mtu calculated across switch 1, of 1600. This matches
> the same group of ports as above, and decreases the MTU for the CPU port
> and the DSA links from 1700 to 1600.
> 
> As a result, the sw0p1 user port can no longer communicate with its CPU
> port at MTU 1700.
> 
> To address this, we should calculate the largest_mtu across all switches
> that may share a CPU port, and only emit MTU notifiers with that value.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
