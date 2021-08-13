Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8E33EB752
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbhHMPCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbhHMPCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:02:03 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1383C061756;
        Fri, 13 Aug 2021 08:01:36 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id h2so16054244lji.6;
        Fri, 13 Aug 2021 08:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y6YYsoW3o43TzZv2ct50vUJfqFlF+SIH/P40e9oxhyA=;
        b=XZZhtKyCe9oudkuOpiydMs5XjPD2Tj1CTL3C1vqOg2oc8RHyMoN9G6PPVYo7fNtDS0
         LJAiFStstYR4QM/RbfSln2cwbSRWqmprEgVVRDWZh1CUmZqkAGVphw942l3CYoMn4bw9
         8xEtlKl+YSOfHvH5KBbXmD2txWDpmrRHVdKq/hvESZHSw9YMfiTsKWyVZ4+xQRonQOiH
         pIHUecySSUN5GbrRu1+0Jc9irrUrQrAeIHODwfzQQjXXCIY4+2UQT3YMkd3VyYKW5RG4
         bCCviRHAJUZLNIMR0Ly35ImEa3uk74fUAfbxE8WUPFiWpDKXKMayRxJFG2TPP+FRlGM+
         J7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y6YYsoW3o43TzZv2ct50vUJfqFlF+SIH/P40e9oxhyA=;
        b=TfEfL2VqPhccglo4uzOqyB1Y6azxlm9avVO+rKFy+a1J8/svELJy8Qmfom4JJjWVUB
         TSXQvjxZra39oZ2L4U/YOzbh6FdWyFoKzOTifknY5yTY8zxU6hK48v/8Nboy56/4cBC4
         Z783qpDwq+IXx9RfU9CvovGB/V/GKlP78A1GU8scieSkjxm3zkCMeiDSDrYKiJvfMp6k
         +ouceyncbcT4KGafvAyw/jZYSlYw/nVSZPgNb3cqjxCXclaqV5qTKI4jxS9Sv7ue9ydF
         zjOc9Ylxwq5JNk+3Na+yfjCZvfo6z53EXkjhWgiXsN6uposEG6oLe2kFWdqM8SfiCHVU
         1riw==
X-Gm-Message-State: AOAM530Jv3ztkegR6khIIZgCdgcL5jFD64+ffXbZ1o8/99VWHC8R0NoQ
        mUnVHLUxRLF5K2TRjxrUHgWxZ6wNlGIvGQ==
X-Google-Smtp-Source: ABdhPJwNBJVKQlqNyDXJP8slHW7YmYyK15Vl7lUVpajvtB0GPJptVtoGk+uabRRZG2nuhuFHQQYCdg==
X-Received: by 2002:a05:651c:1785:: with SMTP id bn5mr2258040ljb.18.1628866893518;
        Fri, 13 Aug 2021 08:01:33 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id u6sm177762lfs.79.2021.08.13.08.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 08:01:33 -0700 (PDT)
Subject: Re: [PATCH] net: ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, vasanth@atheros.com, senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org
References: <20210804194841.14544-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <9e14d6b7-50d0-db97-f6d9-3b84e188e8bd@gmail.com>
Date:   Fri, 13 Aug 2021 18:01:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804194841.14544-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 10:48 PM, Pavel Skripkin wrote:
> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
> problem was in incorrect htc_handle->drv_priv initialization.
> 
> Probable call trace which can trigger use-after-free:
> 
> ath9k_htc_probe_device()
>    /* htc_handle->drv_priv = priv; */
>    ath9k_htc_wait_for_target()      <--- Failed
>    ieee80211_free_hw()		   <--- priv pointer is freed
> 
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>    ath9k_hif_usb_rx_stream()
>     RX_STAT_INC()		<--- htc_handle->drv_priv access
> 
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL save.
> 
> Also, I made whitespaces clean ups in *_STAT_* macros definitions
> to make checkpatch.pl happy.
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Hi, ath9k maintainer/developers!
> 
> I know, that you do not like changes, that wasn't tested on real
> hardware. I really don't access to this one, so I'd like you to test it on
> real hardware piece, if you have one. At least, this patch was tested by
> syzbot [1]
> 
> [1] https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60
> 
> ---

Btw, this patch also passes this syzbot test

https://syzkaller.appspot.com/bug?id=b8101ffcec107c0567a0cd8acbbacec91e9ee8de


With regards,
Pavel Skripkin
