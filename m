Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228EB3FA3C9
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 07:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhH1FNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 01:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhH1FNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 01:13:31 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB67C0613D9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 22:12:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q21so5379916plq.3
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 22:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rVvxeEVCsXFicSfJIRLpRFG3vekhRsrTn7arSwLaap4=;
        b=laB32cGX0y8P1u6lIMAlAWtHD57bo02TorPJ4ZhT8eNGfxR8riSrayFSgj/lJlhYTx
         yG98MrKGPRotHRvVTpxLjzayFmijlAuD5roAqaKEyOL+GJn09JRXiRAV8mtuSpAKhPKT
         jzRqgdAjYHQhi+ahyUe4niB/CGqL72B3/eBI+eenz1Z4yu4w2oIiyersb93mor8H5lL9
         VY8ai0ULBQTzInfzoPZb3hnET6/jQ8Re3FShCHjOjZxPu+L7FqoQ3vOsG3kzRpGiPkwp
         EjpV0rlEck4TBedfjZFUndgA47SUpyGJ3H82rlBTHCTn0HKSWZuxj494wZLKTA4Rs3FA
         O64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rVvxeEVCsXFicSfJIRLpRFG3vekhRsrTn7arSwLaap4=;
        b=Z2a4oSRFW0FCWrHgafYftfLRLo8qMCtAAZGVU+l4fY+UlQPrJiNcf7FtjatwYrRYra
         UxeKu8OWOM7WeFsX5cXR+/5IMJTv1Wa17hfGYEq8lCuKQpBwSP0oKTzY49mMTXZGEJIK
         iAgXbRhZ/yAVpqSaISa3+zTYpoNRXxLpKORVoAHQL4tuk7o7PK11Q2sicfBoAvFs8Tl2
         SP0Da0hhf0H+Ng/MPqkDVsxdOLY1I/gJo9hbI6/peM1rgLYQ0I8GmBx+N4xXIzp5MISO
         bFnownQIQmEogPK6X0stZHfZAMKxFtNYQfWJ0UYo/UIG4FzRkrn9XYCTNW1nWWC8Zq9L
         0oyw==
X-Gm-Message-State: AOAM533lcn+l4xapKCd1cA3f73tJ5XV+LpKNPFgjOX9WB2fxmNdWQO6R
        V0VSta9eOjwVcJUw4y5MzoOJ0g==
X-Google-Smtp-Source: ABdhPJyOnykS0HU/yFI/wiU556fV84vFwc60DbMJx83ARcdZW6RHWQjfccHRQo+666q++O6mz6MKWg==
X-Received: by 2002:a17:90a:5405:: with SMTP id z5mr14610136pjh.229.1630127560896;
        Fri, 27 Aug 2021 22:12:40 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([137.118.203.204])
        by smtp.gmail.com with ESMTPSA id i11sm7815402pjj.19.2021.08.27.22.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 22:12:40 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] ionic: add queue lock around open and stop
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jtoppins@redhat.com
References: <20210827185512.50206-1-snelson@pensando.io>
 <20210827185512.50206-5-snelson@pensando.io>
 <20210827173906.1aa14274@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3a9d6011-7199-69b1-0365-6bec38d1dae6@pensando.io>
Date:   Fri, 27 Aug 2021 22:12:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827173906.1aa14274@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/21 5:39 PM, Jakub Kicinski wrote:
> On Fri, 27 Aug 2021 11:55:10 -0700 Shannon Nelson wrote:
>> Add the queue configuration lock to ionic_open() and
>> ionic_stop() so that they don't collide with other in parallel
>> queue configuration actions such as MTU changes as can be
>> demonstrated with a tight loop of ifup/change-mtu/ifdown.
> Say more? how are up/down/change mtu not under rtnl_lock?
Sorry, that commit message didn't get updated as it should have. The MTU 
change played with the timing of actions just right, but wasn't the 
culprit.  The actual issue was that the watchdog and the ionic_stop 
collided: ionic_stop had started taking the queues down but without 
grabbing the mutex, and the watchdog timer went off and ran the 
link_check which grabbed the mutex and tried to bring them back up 
again.  This didn't break anything in the driver, but confused the NIC 
firmware and left the interface non-operational. This was cleared with 
another ifdown/ifup cycle.

I can repost with a better commit description.

sln

