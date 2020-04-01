Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231EB19B8B4
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 00:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbgDAWxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 18:53:42 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55945 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389504AbgDAWxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 18:53:42 -0400
Received: by mail-pj1-f66.google.com with SMTP id fh8so713178pjb.5;
        Wed, 01 Apr 2020 15:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qukBrnnromGiSCTnyz4L9HyTen8DUq+f4oJWku7HGRc=;
        b=Wtlmw4dpm0UzBF2ljJcSpqIpYf97R9uDwQrPvVTbaSenQDwQi3zvynD1LIClNrkmgr
         v32L1eIqgqLy8+C0tdcrFx4NIBZ+wCN4R412gfu4QxRCwZ/sfOT+dVSTGIlEgQDGKtGc
         Mg2L1WUgME8bLCAaxIKdcIbhbxS3s9IFK/YwjeBMFT7Vb2xPaA7fb+x64nCK4sIPQ7xi
         OT9fFgOcgErtV+krCWbMjDBk81Ulu08eQ45eeJHeZI25BbvV06cZq4TegLtjkQiD05oj
         h5vYGZaD//05KrmpM84Jafe7Po1SM+DipPPAjmVtfyugjt6UBeOGQ0szs/M0DCyqRWvN
         8BtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qukBrnnromGiSCTnyz4L9HyTen8DUq+f4oJWku7HGRc=;
        b=fsnN4NEthXjtf5VOkHrGrqUOel+mbpR5CBdCVgoHLXzzdxhI/lcS7NKpcFjRx5a5V2
         WzYpkIVP33JDIrvVRdExZHX3eQfIfEvjvHiuLLuM5rCD1LHrcfx4dWqBRf16Cg69bQRN
         lp5fhRRFNnzFrSIW/AcCfyWFR3gKP28BWTnOm1yAtK+dw5rJMviEDO/aeUCeODipozUI
         6NpOktm862h6p+stVd9pTh+xM+dhzb4+lpWR30GI3YAZmeR0hp+MeRAqFD0cjIw6WqAf
         /KeB3mCfipY9G9INr4N5AoOFyexAViGZBIrBol1232UCVg0bfKNG9Hw4jp/fWtpNcAA1
         f2kA==
X-Gm-Message-State: AGi0PuYWyKksAV4lc2Ih5qIytaj+0kXmGkKsDfVGlTNJQA4zYMKHt9U0
        9xd5IhWPZXwBtOo/526O8juGoCir
X-Google-Smtp-Source: APiQypKdEp028ZPQjbmb21Al2LBskm5n5yoA6i/WOLkLRtbqs/InmFgJatpLUGky6jX9D+uBLxMQRg==
X-Received: by 2002:a17:902:242:: with SMTP id 60mr133733plc.245.1585781621214;
        Wed, 01 Apr 2020 15:53:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m68sm2554947pjb.0.2020.04.01.15.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 15:53:40 -0700 (PDT)
Subject: Re: [PATCH] iommu/vt-d: add NUMA awareness to intel_alloc_coherent()
To:     Eric Dumazet <edumazet@google.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Serebrin <serebrin@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>
References: <1517438756.3715.108.camel@gmail.com>
 <20180202185301.GA8232@infradead.org>
 <CANn89i+FBn3fttEyU_znAd-+8BgM7VZogFeeZPA7_zubChFpBA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <34c70805-44f5-6697-3ebf-2f4d56779454@gmail.com>
Date:   Wed, 1 Apr 2020 15:53:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+FBn3fttEyU_znAd-+8BgM7VZogFeeZPA7_zubChFpBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/18 10:59 AM, Eric Dumazet wrote:
> On Fri, Feb 2, 2018 at 10:53 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> I've got patches pending to replace all that code with
>> dma_direct_alloc, which will do the right thing.  They were
>> submitted for 4.16, and I will resend them after -rc1.
> 
> I see, thanks Christoph !
> 

Hi Christoph 

It seems 4.16 has shipped ( :) ) , and intel_alloc_coherent() still has no NUMA awareness.

Should I respin https://lore.kernel.org/patchwork/patch/884326/

Thanks !
