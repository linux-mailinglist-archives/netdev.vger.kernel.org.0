Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B83B6126728
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfLSQdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:33:19 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35470 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfLSQdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:33:19 -0500
Received: by mail-io1-f67.google.com with SMTP id v18so6400102iol.2
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 08:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2yQbD3cXPyFndLAFxqJM3tJ/8SIBtGHA3XQ9BtgSc/k=;
        b=FAMNUF0TvvO17omX4sWaZKQ8p4ylndUjnwrL4G6AFS3eBZwXeuGlPuvNpT0pdcs84S
         9YEkz6x3UlXSwxq0nQzBhDsMAPSEZFyTFp8PSIVc6StMJ/fqxjck6IQU3e35mjx6Rji3
         lzyYJjXVP7TzEkRmvQFWNAhGi55BdjzBBc91/YSSRcONjeX2CNPS7R09UG4TOLhlp9qy
         wTIVrlVEFJ5DhHLZLVpnnzxo4tmDFum2fb5ZvS5EO0BSQDTmGKosFncggHpRHwCwI0d4
         mNiDu6SN7Y5MxsJQd+LmfOFF7Rxuoai3/s6r2IFQe3D6jnX57ECfdvc5Zl0/PICXva8u
         DlxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2yQbD3cXPyFndLAFxqJM3tJ/8SIBtGHA3XQ9BtgSc/k=;
        b=JqumOwAliwtrsElBg9qpLv+T0PGrGAgXAG7jj46obCXKvYYNb/7p0u3TM0BnrOm74e
         0moe+p4SbAUeLBRjj756qRPYzYN7tpRvqptWvvWFphNce25HepXJy8cHYfemARQqZvcs
         RB0sBdzdmT2UmCTtvySOB2I42382kMqifSJ9qi175dawAniFmf5kL0so2zyN8E9fzprj
         DwZoKWMlHwGUaM+tXKvagGiZMU1eLCuhSZ4dkn+qT+SRDloQXyfgaEauNnS1qIMYu53/
         oRywEGtiCSGeFmpmpS0ZVq/0HZlX9rrj63NcUwAiREukV2xEkLdZlgIlxZ3wtZnkpFAc
         UY6w==
X-Gm-Message-State: APjAAAUGLM5SNuB57TV9ShBmQHuzIoGt09ofuvcOMwE/iEK2FC0Tynb4
        Abw/1V2+orVEXv9GcPsGz8n4rWdD7vI=
X-Google-Smtp-Source: APXvYqzM3RHD1Y8c9u+mvq+hl8vmblThSOTStFv14vkMtNiZVRnsEq0NZyyoLfJ8rlhl4NOkdoc7cg==
X-Received: by 2002:a6b:7515:: with SMTP id l21mr6660862ioh.42.1576773198886;
        Thu, 19 Dec 2019 08:33:18 -0800 (PST)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id b1sm2624294ilc.33.2019.12.19.08.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 08:33:18 -0800 (PST)
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Roman Mashak <mrv@mojatatu.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
 <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
 <vbfr2102swb.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
Date:   Thu, 19 Dec 2019 11:33:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <vbfr2102swb.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-19 11:15 a.m., Vlad Buslov wrote:


> Hi Jamal,
> 
> Just destroying tp unconditionally will break unlocked case (flower)
> because of possibility of concurrent insertion of new filters to the
> same tp instance.
> 

I was worried about that. So rtnlheld doesnt help?

> The root cause here is precisely described by Davide in cover letter -
> to accommodate concurrent insertions cls API verifies that tp instance
> is empty before deleting it and since there is no cls ops to do it
> directly, it relies on checking that walk() stopped without accessing
> any filters instead. Unfortunately, somw classifier implementations
> assumed that there is always at least one filter on classifier (I fixed
> several of these) and now Davide also uncovered this leak in u32.
> 
> As a simpler solution to fix such issues once and for all I can propose
> not to perform the walk() check at all and assume that any classifier
> implementation that doesn't have TCF_PROTO_OPS_DOIT_UNLOCKED flag set is
> empty in tcf_chain_tp_delete_empty() (there is no possibility of
> concurrent insertion when synchronizing with rtnl).
> 
> WDYT?

IMO that would be a cleaner fix give walk() is used for other
operations and this is a core cls issue.
Also: documenting what it takes for a classifier to support
TCF_PROTO_OPS_DOIT_UNLOCKED is useful (you may have done this
in some commit already).

cheers,
jamal
