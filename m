Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CFC278D0A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgIYPpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbgIYPpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:45:41 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E70C0613CE;
        Fri, 25 Sep 2020 08:45:41 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so4135009wrm.2;
        Fri, 25 Sep 2020 08:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BvkZ3u069LXTTvpatriU/ectTjzDb+6EutCCzwbP+Lo=;
        b=O1e50yxYQHZm0fC2+ENNL1jFvaO0OPNbI9DgkROEt8MYbiUDMioK/oOYlru/S9DHju
         kqykW1Esv7EWOU+OAaWu4Z5x21oHaeqKOP9nQpQrBNSzwMroAKXzLxI7G4ZeiFe6UeN3
         9iqtFddaS3HumsQUY33guIhobhZeha8txP4vGM1S4swHWyL5fVXXYRkA+TVtvVltSia5
         Tgq/AeAcL+OsR/cheC6btoLv9jpEFwuAQliUuII2TM9XW5gG3kfPHc1ZhBkTF+GIMOwz
         X2mG6cooEPulIOe24c1+CY3vOj8B5dYyaPEfM0bQ+kMNml+4YBnZeBF6lZdMD4PCj25T
         7VVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BvkZ3u069LXTTvpatriU/ectTjzDb+6EutCCzwbP+Lo=;
        b=CpPQ7DO4Jk7ViCFFtlvRGMAvIQsesZ50Nq11Bi38uRs6pUhiE1vbZ3Dknx+CFKQ7pk
         BJQWSA40bOhj8v/+LUDwsTLZCBNXNyBFed170xgD4b8zl6Q6JNKMXHTj+WtGQRvce96B
         zCEPSquNI8QUXqQFPVzMniORRhUn5SDSXSHCZsYQvJdVC3NMy8lkqUUzTCwchUNqG6yG
         lh2WJDB4fivDOxr7icinX1Jre7Wj0H+otgtbegqwjlkxTQuIPjY8M65JYrE4HxqTb9Zr
         yvm1ip6oR1geUb4XIoJR0+yCocKyFm84DhQxPwBvZD/e1FTYjGD97mIJIcLKAOZKziOK
         PA8A==
X-Gm-Message-State: AOAM530oBE8rsRGiErH1btsFF0O3emgPJ+tVJSDjWdnOMpCKhT6Ax3Ls
        YKhH3YHsdCWZ4TW5Lr8it44Pzv8bRsYk3L8giuw=
X-Google-Smtp-Source: ABdhPJwWBBcgsFIcg/t7xtb/qyl0s/i4zFC7G1Z50ynCFVPk9mIqxEP+iWcu1ukkGe7fUCq7uqv+aA==
X-Received: by 2002:a5d:5702:: with SMTP id a2mr5062483wrv.284.1601048739759;
        Fri, 25 Sep 2020 08:45:39 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.173.126])
        by smtp.gmail.com with ESMTPSA id a10sm3363378wmb.23.2020.09.25.08.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 08:45:38 -0700 (PDT)
Subject: Re: [PATCH bpf-next 2/6] bpf, net: rework cookie generator as per-cpu
 one
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <d4150caecdbef4205178753772e3bc301e908355.1600967205.git.daniel@iogearbox.net>
 <e854149f-f3a6-a736-9d33-08b2f60eb3a2@gmail.com>
 <dc5dd027-256d-598a-2f89-a45bb30208f8@iogearbox.net>
 <20200925080020.013165a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c9fee768-4f35-e596-001b-2e2a0e4f48a1@gmail.com>
 <20200925083157.21df654d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <95dc174c-2ab9-b82c-0102-abba9b1c177a@gmail.com>
Date:   Fri, 25 Sep 2020 17:45:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925083157.21df654d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/20 5:31 PM, Jakub Kicinski wrote:
> On Fri, 25 Sep 2020 17:15:17 +0200 Eric Dumazet wrote:
>> On 9/25/20 5:00 PM, Jakub Kicinski wrote:
>>> Is this_cpu_inc() in itself atomic?
> 
> To answer my own question - it is :)
> 
>>>                     unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0))
>>>
>>> Can we reasonably assume we won't have more than 4k CPUs and just
>>> statically divide this space by encoding CPU id in top bits?  
>>
>> This might give some food to side channel attacks, since this would
>> give an indication of cpu that allocated the id.
>>
>> Also, I hear that some distros enabled 8K cpus.
> 
> Ok :(
> 

I was not really serious about the side channel attacks, just some
thought about possible implications :)

Even with 8192 max cpus, splitting space into 2^(64-13) blocks would be fine I think.
