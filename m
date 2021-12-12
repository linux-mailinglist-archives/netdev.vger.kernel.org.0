Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3394747183B
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 05:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhLLEYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 23:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhLLEYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 23:24:08 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A462C061714;
        Sat, 11 Dec 2021 20:24:08 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id x7so9588664pjn.0;
        Sat, 11 Dec 2021 20:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9eKLMxGzXIfcHWf1QjPBVmmB3DekQGkFDoFfupbxils=;
        b=GbO7ejJN7LvScL86icP03UwcS3lKLccSwp/sprKRtcCn99jXIgjEQvnyWMcEdV6gVu
         d4vW4mbHNxHhpWg3/Kbc4j7PfrnZNcdxpei4omgx9m5mu8bDVBBS8v9R1QVcvW5EuEif
         tlnKpb+wiUm801ydHEaRSz3MHgQREFbORJ2Elt+XfJSf+dV3MUTwKn/2+aQsCt4E3gAG
         z+/m0Jwslp9F/yPB+ymYb+GiydnnQOTGJG6GgW/El1T79rbEuNv1UslqNEDz6vkpxTL4
         29p25dgqUAMF6RupfMmdWf4bXmN5UF5l0ZH2dQjjX8+U45KRdOvQlcLMzaka1VQ2qgX6
         0TSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9eKLMxGzXIfcHWf1QjPBVmmB3DekQGkFDoFfupbxils=;
        b=xhZ4+qcec9ryl9/NQOZbZ1I4wdxMwta067CFsmSed+ZlpX7un+uJClxkKlDcfUS9Lt
         jIPyolMMm7UvMu5nx9EJ0UpU3JkkXM8HuRIsge0vm1ztkg3n3MKGTm0tN1FxYNuBIt6J
         tnvisgfKFhQcM3M2dUJdyvKwdnJIMKngKOTBBw8xPKnyhVe18FrIH4sIU/I+EaAVjzwc
         0C0vMA/qFdnccll0/Ppa5LkxE5b6da8WLqqioPfC6ZHPVXfrvP9j43BaJkrnlpP5EM3Z
         whnJnY94GARnaDR6Iq+U5Ax/2HCqUC6w3XXHlRjg5wT95QPi2n0MvmZJz1hkFeMZuXZB
         7aGg==
X-Gm-Message-State: AOAM530EEu3jx6MjY/Eg/VVfmOD2hpv4wkilZVNa0A7W9mYu9momw45y
        r0idBxquqlJx2YpGWC9KR3Q=
X-Google-Smtp-Source: ABdhPJw48ZAxaAbe3g1AuD5Q17F7mfKdFlV9T3W5wsyBrt1jolyBje+drUKg7OauFPmIFbAxucUuzg==
X-Received: by 2002:a17:90a:c58f:: with SMTP id l15mr35908856pjt.75.1639283048114;
        Sat, 11 Dec 2021 20:24:08 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:4964:df1f:902d:8530? ([2600:8802:b00:4a48:4964:df1f:902d:8530])
        by smtp.gmail.com with ESMTPSA id u36sm6591826pfg.21.2021.12.11.20.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 20:24:07 -0800 (PST)
Message-ID: <4522144b-18c2-13db-b97b-df0bf5c923ea@gmail.com>
Date:   Sat, 11 Dec 2021 20:24:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [net-next RFC PATCH v4 03/15] net: dsa: hold rtnl_mutex when
 calling dsa_master_{setup,teardown}
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-4-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211211195758.28962-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2021 11:57 AM, Ansuel Smith wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA needs to simulate master tracking events when a binding is first
> with a DSA master established and torn down, in order to give drivers
> the simplifying guarantee that ->master_state_change calls are made
> only when the master's readiness state to pass traffic changes.
> master_state_change() provide a operational bool that DSA driver can use
> to understand if DSA master is operational or not.
> To avoid races, we need to block the reception of
> NETDEV_UP/NETDEV_CHANGE/NETDEV_GOING_DOWN events in the netdev notifier
> chain while we are changing the master's dev->dsa_ptr (this changes what
> netdev_uses_dsa(dev) reports).
> 
> The dsa_master_setup() and dsa_master_teardown() functions optionally
> require the rtnl_mutex to be held, if the tagger needs the master to be
> promiscuous, these functions call dev_set_promiscuity(). Move the
> rtnl_lock() from that function and make it top-level.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
