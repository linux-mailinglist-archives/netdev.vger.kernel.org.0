Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A533141DB6B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348765AbhI3NtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhI3NtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:49:11 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A01C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 06:47:28 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id b15so25434234lfe.7
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 06:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SuBK9MUTG4Xpa0dK+QeeyPt2uzx3nmKZP0e8zjqmNrE=;
        b=AJL+fQPyKJ67K7JUkrV9mxUPJ3cfjiYzMByMQijf4eRAQF4acHIwwVm4SKxOPGCYRG
         +DMjbRv8Z1wbGIORffYJQunTqrpvsGu5BxF2H8419GRZ7q71hp1/HihemWZPa9Mwi93A
         XJHkQ2Mab5gbob08pXcmx2H7No/EECq1yEm2nhsmOS/vomdyiMhY8dkEEokVBxwWm/Ew
         Kx/VRhjHR+KMd/6TgkWq4PoUmRQwhc9VknibjRJCam34wnSNpAcoyM1F8wRyzJaFBEjp
         JOoU3db/uk2xKn1zvNskaze6p3EOwDRL16yUJvDNwlzcBg3BGkl8nmw8mmd1Fp7Xbk74
         vXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SuBK9MUTG4Xpa0dK+QeeyPt2uzx3nmKZP0e8zjqmNrE=;
        b=4huG/zckw0UK23JbyHev7eXjpVNurVmUSGp0uIiyIWZXDPUjoEJG78oA7Oob46uwqY
         3ElweN+XEbQsOxMA0bt8pK9814apalhIqLjcebfhTUEyVuaYlCI7lQMfi1Jy5if/jqWL
         NA/yWFajZwovs+8UDJ4FFpFH1OZ+Bn8uDA2hLHP3/DetjMs9C8sBmgaDZKUIXJsQfYu+
         q7KeNTktaSQsEQ8A5HfuWrwr2LBdyjf6g51viNL+7XoEDBvRlrjowtCYEBRerJSS3aS6
         5UvnjgHUmzA5aaLqIZEF8GBTe1NBJ4p0v4i2eEzhczRC9w74KbKGWiDGLyS+nRkHrI5s
         agNQ==
X-Gm-Message-State: AOAM532Buwhmu09Dza+QX3bupeutuYNv+cQodC3/LhZ1UFCS6BGyvf1j
        4bggP9Sz55EAMD7TP4Cdu7Y=
X-Google-Smtp-Source: ABdhPJxe/0uRhEexqCkl72g73QrgRrAbk2V42zOuZaHv/fgTkapcAzLHno5R/GBy21tlNPZfhW1Lqw==
X-Received: by 2002:a05:651c:b28:: with SMTP id b40mr6229706ljr.334.1633009646604;
        Thu, 30 Sep 2021 06:47:26 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id h4sm378739lft.184.2021.09.30.06.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 06:47:26 -0700 (PDT)
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
References: <YVWOp/2Nj/E1dpe3@shell.armlinux.org.uk>
 <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
 <YVWUKwEXrd39t8iw@shell.armlinux.org.uk>
 <1e4e40ba-23b8-65b4-0b53-1c8393d9a834@gmail.com>
 <YVWjEQzJisT0HgHB@shell.armlinux.org.uk>
 <f51658fb-0844-93fc-46d0-6b3a7ef36123@gmail.com>
 <YVWt2B7c9YKLlmgT@shell.armlinux.org.uk>
 <955416fe-4da4-b1ec-aadb-9b816f02d7f2@gmail.com>
 <YVW2oN3vBoP3tNNn@shell.armlinux.org.uk>
 <YVW59e2iItl5S4Qh@shell.armlinux.org.uk> <YVW8WM5yxP7sW7Ph@lunn.ch>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <7f328778-fab7-79de-6adf-57d650bc3e2f@gmail.com>
Date:   Thu, 30 Sep 2021 15:47:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YVW8WM5yxP7sW7Ph@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 15:32, Andrew Lunn wrote:
>> I should also point out that as this b53 driver that is causing the
>> problem only exists in OpenWRT, this is really a matter for OpenWRT
>> developers rather than mainline which does not suffer this problem.
>> I suspect that OpenWRT developers will not be happy with either of
>> the two patches I've posted above - I suspect they are trying to
>> support both DSA and swconfig approaches with a single DT. That can
>> be made to work, but not with a PHYLIB driver being a wrapper around
>> the swconfig stuff (precisely because there's no phy_device in this
>> scenario.)
>>
>> The only reason to patch mainline kernels would be to make them more
>> robust, and maybe to also make an explicit statement about what isn't
>> supported (having a phy_driver with its of_match_table member set.)
> 
> I agree with you here. This is an OpenWRT problem. We would hopefully
> catch such a driver at review time and reject it. We could make it
> more robust in mainline, but as you said, OpenWRT developers might not
> actually like it more robust.
I was thinking about patching mdio_bus_match() / phy_driver_register()
to prevent other developers from doing the same mistake as OpenWrt &
b53. Also saving your time from reports similar to mine.

I understand it's an issue that OpenWrt has to handle downstream.

Thank you a lot for helping me investigate this problem.
