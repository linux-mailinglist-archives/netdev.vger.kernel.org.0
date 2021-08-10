Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FD73E56B5
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhHJJW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238854AbhHJJWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:22:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE19C061798
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:22:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w14so1630365pjh.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E+P/f9V9pQqmo6vCnaDXZU4S9V8V/7mEQcRFWlKPQvM=;
        b=NnIO2PCikGCWBwRQXUyL9RXWjVnrqmboxcN6DPTQyHx7dEbeFpkIFFgz0hAiVSwHwW
         UloAKUKmcWROfYU3cCgF4Dduw1WNgXWrNT8QXznoB9LSPxb+eYf4agYQHYVTw+fqRcY8
         OFggrrln5ETxsrM3IULBc3RaKzif44eu3ArBFmv4NANSep0sMbehNs+cdnECQXTZreq7
         pwYXHP4cvmoAbUiQZgPPwERdyhpmHecRCHeK/ImJPF0CdSFDK2mT2jy6WCJpK5uhsPAW
         vspnET233NsmaAuyKEoHiWWdwjJG46JkoF5nGo7V7V0DvNjUjAntbcSVX/zybckUHQSy
         hYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+P/f9V9pQqmo6vCnaDXZU4S9V8V/7mEQcRFWlKPQvM=;
        b=HNxrRQqw3wVbudz3SQlXwkfYXH1CjteLH37bNFahezlfkgBVxiHRgnIpNNAB05wcvp
         d2uAP0aEqTQG6OHCMeUouhnNyDUe00l8YqUMdMtWe4aR/3sXGpDC8CZoEwfqs+LL2vIW
         jrdBxZ8heaY9ZlX0BZrFgFLFVNg6mTP8ZLK2R1O/sibb30h3V9tJak8OU9lOKFpIKmvg
         McXntQQ334zBO08jVLIBKWwL4H9ejdeIM7k9NQ1M0WQ6Z59c+b3yL4bioei7+ZlAh+ak
         sTFafAC9o9Fgwfrl6TfwJEcfVMUYiUXk8vwMqndmMP+JytIocOr4AHzP0KPHGzaPn5XR
         CQ7g==
X-Gm-Message-State: AOAM531WN2BUF7d+uiQWTwk9lpi3AMu/TShyBuaKHaqZREeol7N4CkSY
        9B1HHcoL1ItpO95l7pBYoSU=
X-Google-Smtp-Source: ABdhPJzGNt43wxNPu/btkar3gowNR/XWydXjrx8STFV0QyvHeUC6XoI17/lemgAfKz7KNESkWBO5CQ==
X-Received: by 2002:a17:90a:8b81:: with SMTP id z1mr29950161pjn.82.1628587329762;
        Tue, 10 Aug 2021 02:22:09 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id u3sm19797522pfn.76.2021.08.10.02.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:22:09 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 4/4] net: dsa: create a helper for locating
 EtherType DSA headers on TX
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
References: <20210809115722.351383-1-vladimir.oltean@nxp.com>
 <20210809115722.351383-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3da3ba17-d760-a888-2323-68fd46a96477@gmail.com>
Date:   Tue, 10 Aug 2021 02:22:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809115722.351383-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 4:57 AM, Vladimir Oltean wrote:
> Create a similar helper for locating the offset to the DSA header
> relative to skb->data, and make the existing EtherType header taggers to
> use it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
