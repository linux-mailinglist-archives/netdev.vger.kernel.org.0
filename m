Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA6B2E6C6B
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgL1Wzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbgL1VGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:06:17 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0359EC0613D6;
        Mon, 28 Dec 2020 13:05:36 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id z12so285157pjn.1;
        Mon, 28 Dec 2020 13:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=caUK5bWQMn4p+E5nxU+Ce3Moy1Jc2Ri59w2uOeD1O9s=;
        b=RtBNEEVOMl18VdLGqSiwC78IE17t6k5ypI3praa5yNTu05lxPMNdV8DUVUhNBLLMe8
         FoUBSI028gDRDeL/8Zy/XFVIVEGBEegzXsGUZkPdS4VEjOho1RY9rzK4WfDsbrAW1O2r
         JdkLKyZUmKj5CsgFMxT9cH0A2zKbkfyaQNe07CfjyXlMZjiPk03b5fBN7sdyfvQOwS1/
         f0wQAS7sMFF82zkrFf1IzohorWSCbJe5trZI+Hn3N6zD0IOWCA0dhoN+trzu01Ibt0J+
         9ybe1sFFmrfpVM1MY0I2iQkLpUwbv7BLEmtnmmtqQQ4tiWWEh38wsArNIYSA4vgtR01N
         NMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=caUK5bWQMn4p+E5nxU+Ce3Moy1Jc2Ri59w2uOeD1O9s=;
        b=fV4a+V+/AV7weuJxVO5yHkMK2+zg8rdKFOpCFKlj6oo5CoRcgkw05BP7P9Rr73H6gy
         NfV4vH5uKtYCYiITFplacbY5fWn9T68vrfOS3oW8J87A6loZSZSIwFD+fuBKnQJ+rIjg
         SSBa1tJO6JV/PVPktrWB3dUPODsOLBaKSRu31kvP1lahiHQaJGvgDInhSfSEnA3NkEwq
         R7L+FOujJs8+BPyykdDx3bFLHFXCsT+oKc7CTnZGaWif4G0VdrPOKfMZHkXJeKKxLu9Q
         Wf0IflDz6Ibt4YFI1TT2sAsO7F/VtDj+Qw+b6YpziLxc5s6MbF5Rr9vld50M/tM6E8wI
         jpew==
X-Gm-Message-State: AOAM532oNvd8D5vO9yQCI51WYRrPWR7KjlK7tfi5oz5mM6uRk7efAJli
        9lai8+LwnvR4Z/PZ5I58ZD3jysYyeRM=
X-Google-Smtp-Source: ABdhPJzaZaRVJWxgwJNfKCeDohuo3+A7Yb29ocP72FubM/z4kBwl7cpo3eiysphzZOvHF+TJ3iQhJg==
X-Received: by 2002:a17:90a:31cb:: with SMTP id j11mr752176pjf.6.1609189535444;
        Mon, 28 Dec 2020 13:05:35 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n7sm37461127pfn.141.2020.12.28.13.05.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 13:05:34 -0800 (PST)
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
 <20201223153304.GD3198262@lunn.ch>
 <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201223210044.GA3253993@lunn.ch>
 <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
 <20201223174146.37e62326@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224180631.l4zieher54ncqvwl@chatter.i7.local>
 <fc7be127-648c-6b09-6f00-3542e0388197@gmail.com>
 <20201228202302.afkxtco27j4ahh6d@chatter.i7.local>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <08e2b663-c144-d1bb-3f90-5e4ef240d14b@gmail.com>
Date:   Mon, 28 Dec 2020 13:05:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201228202302.afkxtco27j4ahh6d@chatter.i7.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/28/2020 12:23 PM, Konstantin Ryabitsev wrote:
> On Thu, Dec 24, 2020 at 01:57:40PM -0800, Florian Fainelli wrote:
>>>> Konstantin, would you be willing to mod the kernel.org instance of
>>>> patchwork to populate Fixes tags in the generated mboxes?
>>>
>>> I'd really rather not -- we try not to diverge from project upstream if at all
>>> possible, as this dramatically complicates upgrades.
>>
>> Well that is really unfortunate then because the Linux developer
>> community settled on using the Fixes: tag for years now and having
>> patchwork automatically append those tags would greatly help maintainers.
> 
> I agree -- but this is something that needs to be implemented upstream.
> Picking up a one-off patch just for patchwork.kernel.org is not the right way
> to go about this.

You should be able to tune this from the patchwork administrative
interface and add new tags there, would not that be acceptable?
-- 
Florian
