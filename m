Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A40A20EB
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfH2Qbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 12:31:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43471 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfH2Qbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 12:31:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8so4072487wrn.10;
        Thu, 29 Aug 2019 09:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jqnYRSvKeOuSAixyDcusNx1M9DoZEp8erc5mVI5qWgE=;
        b=NBoWW2mhp51kNEP89n9VLK6HuCjPukG9v6gCPWmFDa0JLB2s6ZZV+D2N0S0vh9Xtx1
         LgX3CuZ1VrmNNo1977am3s5BpdP6KO8S3mtDjOZtxLo+PZFs8pAT0FaGle7YXikiZSIM
         YFzJECKKDh+V/pAzemsR/cgft2Qijab8ECQ7pxHKPSEfV2WaSn0fwrjkw2KzB1KJ06d+
         ycY+BmG2T6tmJ/psfSuFK3u72FPAp7ri+UzVU6YdPJiddtAPlkKS/p063uN7Qn4Qk77C
         wPGStOcWZ3G0gqtnpoqMW5nUMhhoUJVChAAUX8N2wY07QEcORkWnZZdczNNX12RsovJZ
         jGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jqnYRSvKeOuSAixyDcusNx1M9DoZEp8erc5mVI5qWgE=;
        b=EdREqwGJ3JmrTMGdAch9lTfbJDBwaNeyDrKsXE05TO14b17ARMr0q1TqHSMSRB2PeV
         K4C2weDzjF6Xiu0YFplk0QNOJQ5+NTG4mHxO0+294HUDCDDVKp8rk0fHNHAoNJXnJp5Y
         grnN6BM5tyPzAriFUyeQ6jwJ0hclubybk02aSEyR5WMgXvTcd33vInyn39w4w52zldpR
         GCe7d3Tx4sHKVqBQfHDlxnWFAe9LoFIU3U+XmtpMHn+tu0cQTLZbE25f0iA1Fvo/v/MO
         FEW9IHUdXwGY4KWrDuf3O0GXVV3WbkEQTDvrQqN+mCz56iwAcI0pHVCH5Jedb7+CnG9d
         RxqQ==
X-Gm-Message-State: APjAAAWDg+dkmITdCM9cWNaXAphePbBVbDyGQC34xB6HQkpVlMQC+mBI
        GT5xu6Ghvj9efHmqqVPG5WrTdZRE
X-Google-Smtp-Source: APXvYqy0OlmPcJKtuOcWVyz0aHf1x9iWwllcFS6mSV06J1X33SGzK8vEubBEhl/Bt6ruxSbLeqHwUw==
X-Received: by 2002:a5d:4bc1:: with SMTP id l1mr13182866wrt.259.1567096303963;
        Thu, 29 Aug 2019 09:31:43 -0700 (PDT)
Received: from [192.168.8.147] (33.169.185.81.rev.sfr.net. [81.185.169.33])
        by smtp.gmail.com with ESMTPSA id l62sm4911638wml.13.2019.08.29.09.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2019 09:31:43 -0700 (PDT)
Subject: Re: [PATCH net-next] r8152: fix accessing skb after napi_gro_receive
To:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org
References: <1394712342-15778-299-albertk@realtek.com>
 <1394712342-15778-302-Taiwan-albertk@realtek.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b39bc8a1-54c7-42d4-00ed-d48aa1bac734@gmail.com>
Date:   Thu, 29 Aug 2019 18:31:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-302-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/19 5:15 AM, Hayes Wang wrote:
> Fix accessing skb after napi_gro_receive which is caused by
> commit 47922fcde536 ("r8152: support skb_add_rx_frag").
> 
> Fixes: 47922fcde536 ("r8152: support skb_add_rx_frag")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---

It is customary to add a tag to credit the reporter...

Something like :

Reported-by: ....

Thanks.
