Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554652E28E6
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 23:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgLXV6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 16:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgLXV6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 16:58:25 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3B9C061573;
        Thu, 24 Dec 2020 13:57:44 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id s2so3491216oij.2;
        Thu, 24 Dec 2020 13:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EoDIzX5nkvMiIjiZfgPNXlv6Yg7EoQgCmDAGr9BKiyk=;
        b=dr2AHammJK502Y2s46w7sU0J1ZMlxGju0xHTDrf6yZd/d2jOoWIROdZLNOldHJVLxI
         XCCNv1dyWTPpvyQns66w+qTye6xqgMzXcxtdMLPZpwz5ppp/0VJZp1TvE1OqK85eQKsN
         RAQDgha6eUY1VueYpQbxhKq5gFM0SF+sbQrtLJdLeswN3GVVu7MtliJCE4BSIODP3iK3
         9AnUqrEIRpKM61zHVmq5DjikFJwx9XNBKYBPjv0YNtGq/jwlgaJlJDaSWOHeof8o4N5/
         SB+gew8vFfa06knq+Ety5o89//Tt3bjj3D5PGUgbwObnerU7PwewkLcXWqKuR4ZCQMTB
         Ri3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EoDIzX5nkvMiIjiZfgPNXlv6Yg7EoQgCmDAGr9BKiyk=;
        b=G5AYH3hfpMZHW0zDVsdPIK4C3FY8SL2DKpqBQXDDx1ZxXfPaeto/CAIH7k37KJX6kB
         4NiGEWFCpAkHjTsJ43K4QCGQyZKtk2p5sOsYjOCo35Hp49VpPDxhtGM2Xdc4zcku8J0U
         GHzi9iEE7S9dXyLQYnY9cO9zrkagS7DL+QlxZzw4Wr9gRIkpSMgoVy34dbwedduwaZhx
         qdAptfCOXLZKZSRWn0jhEdjG9nH+kfNvOowGIqDAURxVvR1IHh37ezi6Y7KUOPM3rzsH
         ISaVcQd5vdYoMmHVy6b2VS7bNc3lW2OkKqmlHIxy9Ps9BbfQbTHxq8yDK+hbe7ZeDYNi
         BawA==
X-Gm-Message-State: AOAM532Dxfi2TteMsfX7ZPuGdrUyekrG4X9aQ72mo3+tyWr5GJr1jD4u
        EIoaHGd/PG2ANUQ8T1abGAepg2tTOuo=
X-Google-Smtp-Source: ABdhPJxVgR+X1nezut+74UKPCZLKdo9otCqzRIgwldNnedvF+SySphbJSKCK2PdyxfMoIgA1OgiP2g==
X-Received: by 2002:aca:ad89:: with SMTP id w131mr3852591oie.112.1608847063524;
        Thu, 24 Dec 2020 13:57:43 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:70e0:6ead:3b51:c034? ([2600:1700:dfe0:49f0:70e0:6ead:3b51:c034])
        by smtp.gmail.com with ESMTPSA id f201sm6783572oig.21.2020.12.24.13.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Dec 2020 13:57:42 -0800 (PST)
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fc7be127-648c-6b09-6f00-3542e0388197@gmail.com>
Date:   Thu, 24 Dec 2020 13:57:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224180631.l4zieher54ncqvwl@chatter.i7.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/24/2020 10:06 AM, Konstantin Ryabitsev wrote:
> On Wed, Dec 23, 2020 at 05:41:46PM -0800, Jakub Kicinski wrote:
>>>>> Does patchwork not automagically add Fixes: lines from full up emails?
>>>>> That seems like a reasonable automation.  
>>>>
>>>> Looks like it's been a TODO for 3 years now:
>>>>
>>>> https://github.com/getpatchwork/patchwork/issues/151  
>>>
>>> It was proposed before, but rejected. You can have your local patchwork
>>> admin take care of that for you though and add custom tags:
>>>
>>> https://lists.ozlabs.org/pipermail/patchwork/2017-January/003910.html
>>
>> Konstantin, would you be willing to mod the kernel.org instance of
>> patchwork to populate Fixes tags in the generated mboxes?
> 
> I'd really rather not -- we try not to diverge from project upstream if at all
> possible, as this dramatically complicates upgrades.

Well that is really unfortunate then because the Linux developer
community settled on using the Fixes: tag for years now and having
patchwork automatically append those tags would greatly help maintainers.
-- 
Florian
