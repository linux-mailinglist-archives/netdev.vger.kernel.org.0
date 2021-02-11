Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6056D318452
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 05:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhBKEXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 23:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhBKEXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 23:23:11 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D4DC061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 20:22:31 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id a24so706928plm.11
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 20:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GGFHtm8rSxmupJIyD0hKSnbgWpoKngKPVGpCtg7kAT4=;
        b=owBUS+qfj8XTsyuDKIQAvo17jQCKunq03AsFyIMQ2qVSDfdPUmMIuzGYlj62Wm/6K/
         Nbhjc4Hby9QD59UhKrjzfge/5mdwVQ8E3xeO9ZLFhSi1DrhbT205FYQ1JL2eVSaML8nZ
         mHobSy4an53Lk74tZxE5DM7TQx/hdNVNKtRrLBi4IRQgYbFf2r6qptc6d0JIgU6vVqlP
         tKueyoR/gxlwwZ0qicZY/2PbZWbIafM2maO7KMYQoiAnbfu8bMjsIA2/36KCSY7LS/XE
         1V+FQ7zgxvN0pQC9hr1S45i7sG4RYuN9CdLcsEeQTwXdjPh0Ldiw/pg+OhgIaW3sxtcU
         aeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GGFHtm8rSxmupJIyD0hKSnbgWpoKngKPVGpCtg7kAT4=;
        b=bg4MVkrahh8zq4nd18VBI4piiCzxcyj7z58JCSi9DAcekFavHc2eO93RtD0n8Y5H9q
         yzOlNBZr8KjCYxmNDeqiriU2KjP/MmRO8bu/2pKKfx0Vgi82WI5PLeHc2MDtNYOielZ4
         aiOUBBVW7szJ4E4v0P6/1LHSYWCydMEEsdPbQHKP0Jnyouch2U+m/Pq8pt6PFpsFG3/b
         Yi1mB29zvNPRpvVF/5upSXhOmYVBOr+Tq0Yp9yYiC1QiXfMOBxPOtsDMOc7RnPSelVct
         VQc63LHI17eHdIHEewq3dme6xWiq+IxABLPdu3lX9Q3TZUpRjvdWz3S+9sdMJzmzj5Y7
         3OIw==
X-Gm-Message-State: AOAM530fwIjvkSg3CRJywvMjQffJW9/ui4UmpyMc4YtosjJBcfW5j8WN
        /ZnlMigUQwKt6+927vgqcvk=
X-Google-Smtp-Source: ABdhPJy/vXMJY/82zCkJf7gL+BubdGe/6urGRPstYpwo0LPI/7Cf0Ma3XI9LCquEYwKSmXw1O0W4Fw==
X-Received: by 2002:a17:90a:fd8e:: with SMTP id cx14mr2208058pjb.101.1613017350716;
        Wed, 10 Feb 2021 20:22:30 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o14sm770147pgh.48.2021.02.10.20.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 20:22:30 -0800 (PST)
Subject: Re: [PATCH net-next] net: ipconfig: avoid use-after-free in
 ic_close_devs
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20210210235703.1882205-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <05f04d4d-7c76-979b-852e-0437dd438248@gmail.com>
Date:   Wed, 10 Feb 2021 20:22:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210235703.1882205-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2021 3:57 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Due to the fact that ic_dev->dev is kept open in ic_close_dev, I had
> thought that ic_dev will not be freed either. But that is not the case,
> but instead "everybody dies" when ipconfig cleans up, and just the
> net_device behind ic_dev->dev remains allocated but not ic_dev itself.
> 
> This is a problem because in ic_close_devs, for every net device that
> we're about to close, we compare it against the list of lower interfaces
> of ic_dev, to figure out whether we should close it or not. But since
> ic_dev itself is subject to freeing, this means that at some point in
> the middle of the list of ipconfig interfaces, ic_dev will have been
> freed, and we would be still attempting to iterate through its list of
> lower interfaces while checking whether to bring down the remaining
> ipconfig interfaces.
> 
> There are multiple ways to avoid the use-after-free: we could delay
> freeing ic_dev until the very end (outside the while loop). Or an even
> simpler one: we can observe that we don't need ic_dev when iterating
> through its lowers, only ic_dev->dev, structure which isn't ever freed.
> So, by keeping ic_dev->dev in a variable assigned prior to freeing
> ic_dev, we can avoid all use-after-free issues.
> 
> Fixes: 46acf7bdbc72 ("Revert "net: ipv4: handle DSA enabled master network devices"")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
