Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7537431A374
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhBLRVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhBLRVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 12:21:10 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3736C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:20:29 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id g9so8844853ilc.3
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n9DaPQNZ9ApDhbjk3lpcweLqgl0plvUaf017MPEDmY4=;
        b=bH7T+IP0hxSM4qnABSsyIGH8bQIX8SeAq5MeI+UJbArLYzuYwzj4s+w0R6hYaioIv3
         5l8j7hmD5TJxLVvpuP9gkfBDhs+RBXF6Esk6LyXnY2p0jkIUh3NI6cZMM2GEBxLC7yHF
         wWvueSO5T3GxMWuJGZN82vxNXh9J8KLIu3LUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n9DaPQNZ9ApDhbjk3lpcweLqgl0plvUaf017MPEDmY4=;
        b=T8CIjTy8IlWa8xC8wDtmVYJLuftNqXdqar7CDVQ7OoUV0aPB+R8fLtibChdf6dNHVA
         P/xVTTkscBdz1EGFeWn1dA/FsUbwHtFHFbuFaTFnaBPIoLbVJXt8YuZpboh8QqE4wcPf
         mwN3rLzlVzCdbmmTNfSXniiBCk+/TJlsNufKbR9nOcJ7cXncYfOAbpA+k78eJo7BSjhu
         AOzQim1YunYIYkL0k6OrVroBGMZE4LcMMD/hM2lTG3HGxW6O4yHXC/VYmKbCVdZOA9xa
         WB4SQWxLx6sfmD6RsC1HoIFFq3DfH/rRxYJBx58Ur2pXVozCHJWvEDlHYGV2lOM/9gip
         uttA==
X-Gm-Message-State: AOAM532NFF3bTsj3ra/JmfsMxgrLG/xR+XqhVz2pvcVjLM2LkfPHbmiv
        ipBrF2PqUQd+vVpboE83+p3ubA==
X-Google-Smtp-Source: ABdhPJy5u1pyxefeNefBUn+dDMHhvH9gQ1EoCBGDLyeSaQPbgvcoJetHzEOChfwu19Om76iN6cmLzQ==
X-Received: by 2002:a92:b749:: with SMTP id c9mr2906435ilm.199.1613150429332;
        Fri, 12 Feb 2021 09:20:29 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o131sm4632861ila.5.2021.02.12.09.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 09:20:28 -0800 (PST)
Subject: Re: [PATCH] mt76: hold RCU lock when calling
 ieee80211_find_sta_by_ifaddr()
To:     Felix Fietkau <nbd@nbd.name>, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, matthias.bgg@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1613090339.git.skhan@linuxfoundation.org>
 <1cfa036227cfa9fdd04316c01e1d754f13a70d9e.1613090339.git.skhan@linuxfoundation.org>
 <20210212021312.40486-1-skhan@linuxfoundation.org>
 <3949e1fc-c050-73e0-d02f-63a25c4821ef@nbd.name>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <61994394-0d95-39eb-2a11-487ca7c6c37b@linuxfoundation.org>
Date:   Fri, 12 Feb 2021 10:20:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <3949e1fc-c050-73e0-d02f-63a25c4821ef@nbd.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 10:36 PM, Felix Fietkau wrote:
> 
> On 2021-02-12 03:13, Shuah Khan wrote:
>> ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
>> the resulting pointer is only valid under RCU lock as well.
>>
>> Fix mt76_check_sta() to hold RCU read lock before it calls
>> ieee80211_find_sta_by_ifaddr() and release it when the resulting
>> pointer is no longer needed.
>>
>> This problem was found while reviewing code to debug RCU warn from
>> ath10k_wmi_tlv_parse_peer_stats_info() and a subsequent manual audit
>> of other callers of ieee80211_find_sta_by_ifaddr() that don't hold
>> RCU read lock.
>>
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> If I'm not mistaken, this patch is unnecessary. mt76_check_sta is only
> called from mt76_rx_poll_complete, which itself is only called under RCU
> lock.
> 

Yes. You are right. I checked the caller of this routine and didn't
go further up. :)

thanks,
-- Shuah

