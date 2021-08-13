Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA63EBDDE
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhHMVcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 17:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbhHMVca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 17:32:30 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D756C061756;
        Fri, 13 Aug 2021 14:32:03 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id d4so22292705lfk.9;
        Fri, 13 Aug 2021 14:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZroxT+1zrcdLvkSmpj3NhUUaHoy8N2LACzKCDfGFUis=;
        b=gpL0cZMuWVgE9dHkvVJLTs6Jp0EWLgRzxijbpo5n4SBeyBl1b5YC3D+zMLlgRCv0pd
         6xJ2yW912DE5Aao3QEByetim+FBja+79WeCq5txY+cy5SocBiu9YZYS9rEKuP03JNH+E
         F55UONr7x/ONSdTa0pu+bT22mIRMDIGlcuJ71Mxv4YI9y3gJj2Hfo+B1S8bzi/zpMHze
         400l0M5eBbH1l8KESWs9GNbWTQ6eR7v2IdC8AAdShFM197ixgL0RsKCaUvy6aHg7lG24
         SL74aPMKCX+WsdVHvH3ENJw4EvdUsFdXs/dUMOG/qMXGaOBbeNJqU5SVV6DqvTRpY/3U
         NKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZroxT+1zrcdLvkSmpj3NhUUaHoy8N2LACzKCDfGFUis=;
        b=pObibJPNC89aFGtNBD3mxT4a7W4c4gAoE3LCoFijSJmL5AlOEUPaPUhVjnDe5SPHu5
         mk9n0supGQq5spp5T1m5/wb7U+L1KfvTTDVAMTGz0MsGV1t+DtdxmELcD1KCtCH+r5Em
         Dpm1Ld3575qG8yF1pJSKR2p8XVkKkYs6hYB5hz359IjBKWKbvLDOhkY+p9LAAnrONqPl
         udu9584JfaAamd5g9nemcdaDqWKU3yJPyZvChKDW6dHycMZwFqfxYOJsakGKLOBNZT/e
         YgcYNo/W5ybvu+wd3KOVDzDqe4Rc4/Gcx8O1QM0uFSOKadqRJI4SejD8X3gy129lskaQ
         LGQw==
X-Gm-Message-State: AOAM5335XS21FS/qwms2L9Q3ne2tsDxUp0o2exTavy2fe6WLA/rEYh2e
        UvzJaQJRIfQny769Y1/8eYM=
X-Google-Smtp-Source: ABdhPJx6VKPmLmGHdIjy05Qo863cCikrMMbYuGEYbE0TM3ktNrOHESaYoar8bz2YcwTfrnUTvMRsGA==
X-Received: by 2002:a05:6512:2293:: with SMTP id f19mr2927036lfu.379.1628890321785;
        Fri, 13 Aug 2021 14:32:01 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id u12sm252065lfq.173.2021.08.13.14.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 14:32:01 -0700 (PDT)
Subject: Re: [PATCH v2] net: 6pack: fix slab-out-of-bounds in decode_data
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
References: <20210813145834.GC1931@kadam>
 <20210813151433.22493-1-paskripkin@gmail.com> <20210813210922.GD1931@kadam>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <dfe66a37-e152-8eb7-58f5-1a76b468188d@gmail.com>
Date:   Sat, 14 Aug 2021 00:32:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210813210922.GD1931@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/21 12:09 AM, Dan Carpenter wrote:
> Great!
> 
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Thank you, Dan!


With regards,
Pavel Skripkin
