Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE9D380AA2
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 15:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhENNr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 09:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhENNr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 09:47:26 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337DCC061574;
        Fri, 14 May 2021 06:46:14 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a4so30114916wrr.2;
        Fri, 14 May 2021 06:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ymmwx+IZNZPtmksX0LXS0g42bC5sLEqQJ+dxtmdHYAA=;
        b=L1hlMocshLK/8w3hl4DzeGupCK4WzLVF0cSbeTtoaPnsXJDk+135j/93Y9dCVhM4hO
         zdyJXwNH2byhNXJIRIDSOmpFYaPUX2HHAz7eYkc02FCylvuwNVJgVHt/ok99/hAshpUI
         00WJofJl4eCM2gAJLOOcONh6tJL9+nxb89V8K2cB8g/YfV1CoPnFKXvNys/czaOzRVgN
         u9RnA5qiEjai6yNuTXp655zcwP1EHR2hBW/oup5mJ+oq5NkJ9V5H2KTFqZbu8Kkok6rw
         ZJal0ErO1X8YRJx8+hqvg9KRQpjreGgrEe12GNK6h3utAieKw7fCxPdZxojGp1MGNmBm
         tHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ymmwx+IZNZPtmksX0LXS0g42bC5sLEqQJ+dxtmdHYAA=;
        b=KV/COAIxw4jKIlIdx9U06PzJ2Edga0ouHs6hiN/gZ4xloZWMK2qVxrClDBN7+8BuMv
         xs0Z8SZ1ZXMO18x1QkSeQam6KjCENGTg20/+HCLZ+AKw0wd0p3Y5i+xRz3po5xi22/45
         d+xK5uqecuTorirvFvD/YB+NkvYcteAvZAShmWpvtkutIDBlPEhzhsdngIRoMNaSqLb9
         uqWWIs+maPS0Rl/wq2KukXy9zWhM33c/H7wksGvpE5IhbryYbxMcGo0eXFQKfp/KSmck
         o8GbveMG+cPq7wIdeBOy669pkJdMRygkwVImw/lQOFodr1pRB9bUmBaAYbzR6yWFXuNm
         30Hw==
X-Gm-Message-State: AOAM530W04q1MAa9rFtxG0klQJeFdUTpCc1Yqo29RLdW7anCmRCpeAmt
        wTFMzhXXddYtEloIVC+7d5w=
X-Google-Smtp-Source: ABdhPJw3flR6Q8XtcnS7uEUlO2rb16YVbcmlkDfIxQUCIWFEz+R8GpKG3A679HYO9Kz5vKY7yn8uXg==
X-Received: by 2002:adf:ebc4:: with SMTP id v4mr259508wrn.217.1620999973011;
        Fri, 14 May 2021 06:46:13 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a369.dip0.t-ipconnect.de. [217.229.163.105])
        by smtp.gmail.com with ESMTPSA id q12sm6626954wrx.17.2021.05.14.06.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 06:46:12 -0700 (PDT)
Subject: Re: [BUG] Deadlock in _cfg80211_unregister_wdev()
From:   Maximilian Luz <luzmaximilian@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, dave@bewaar.me
References: <98392296-40ee-6300-369c-32e16cff3725@gmail.com>
Message-ID: <da9f48e0-42fe-1f27-6ed8-ea796f95f894@gmail.com>
Date:   Fri, 14 May 2021 15:46:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <98392296-40ee-6300-369c-32e16cff3725@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/21 1:07 AM, Maximilian Luz wrote:
> Following commit a05829a7222e ("cfg80211: avoid holding the RTNL when
> calling the driver"), the mwifiex_pcie module fails to unload. This also
> prevents the device from rebooting / shutting down.
> 
> Attempting to unload the module produces the log pasted below. Upon
> further investigation, this looks like a deadlock inside
> _cfg80211_unregister_wdev():
> 
> - According to [1], this function expects the rdev->wiphy.mtx to be
>    held.
> - Down the line, this function (through some indirections, see third
>    trace in log below) calls call_netdevice_notifiers(NETDEV_GOING_DOWN,
>    ...) [2].
> - One of the registered notifiers seems to be
>    cfg80211_netdev_notifier_call(), which attempts to lock
>    rdev->wiphy.mtx again [3], completing the deadlock.

Looks like the underlying issue also leads to

   https://lore.kernel.org/linux-wireless/ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me/

Regards,
Max
