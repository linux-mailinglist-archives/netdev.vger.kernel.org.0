Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA51EB684
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 09:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgFBHXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 03:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBHXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 03:23:13 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE9AC061A0E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 00:23:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f185so1993170wmf.3
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 00:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZHo1QuB0kAfaTwTp4RSd4mHS3YIQOmK6CEUo3780m3M=;
        b=VCzX7wADfccH6WdRDKjo2XpH5R6yQWUPDumdpTdeokAH9JR5oym803nnUlxjwjh3tG
         EUFPsHWr0DG/eUOJZy/h3sEJU57Dpy7zK5QnhUTF1RA2fVscezKmtKunGzb8oqCWO/MS
         HOwBSYlwXrQhitaFL+ZU138oUQ7lYi/PdzReU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZHo1QuB0kAfaTwTp4RSd4mHS3YIQOmK6CEUo3780m3M=;
        b=fg3KHNErL9LOenc5kDBFHXhzNXkwYCG9ErT7965kWiwSzjcGfJuY0b8m6vxoURL03B
         +lVPieVxWDQ8h8PGTDb+jymi/iS0plGB1GGhYHVwXCJ5S4oA2gqQvXFq+K1oddD9vjhY
         VGExKK+egWRllYS/ZqQxq3kqAZlb8HEQFXwJecuZVqpzPl6xMTmgh12QexZrPxiPv9CK
         uN0r8xrk6ffy6wspB9mR29PuxIAttKINJ9UnUi7nGZP+HGriJS4LzIDXjNEYTAy1wYm2
         ox3Lflhe7JE1HQ3C8Wr+j7P4w2ojj0suFftdFU8wXWt045rJ71GYxCWwPpd1RLiITBBV
         s4Kw==
X-Gm-Message-State: AOAM530DHMzWtJmpZ20mHWmdkUgM4uWWsE69tq6FsZW4ugdxTYbhsp8V
        kTOlrGDNS/2bXYe0olbcKhcA7Q==
X-Google-Smtp-Source: ABdhPJxnayMLHt4aiPZE6YU+Emu7SV6i6jun3yYCseigX+vwnCJ1IfR+v0MLRVFDu1up3bCG2vlEfQ==
X-Received: by 2002:a1c:49:: with SMTP id 70mr2663299wma.184.1591082591775;
        Tue, 02 Jun 2020 00:23:11 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v27sm2560033wrv.81.2020.06.02.00.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 00:23:11 -0700 (PDT)
Subject: Re: [PATCH] ipv4: nexthop: Fix deadcode issue by performing a proper
 NULL check
To:     David Miller <davem@davemloft.net>, patrickeigensatz@gmail.com
Cc:     dsahern@kernel.org, scan-admin@coverity.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
 <20200601.110654.1178868171436999333.davem@davemloft.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <4e6ba1a8-be3b-fd22-e0b8-485d33bb51eb@cumulusnetworks.com>
Date:   Tue, 2 Jun 2020 10:23:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200601.110654.1178868171436999333.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2020 21:06, David Miller wrote:
> From: patrickeigensatz@gmail.com
> Date: Mon,  1 Jun 2020 13:12:01 +0200
> 
>> From: Patrick Eigensatz <patrickeigensatz@gmail.com>
>>
>> After allocating the spare nexthop group it should be tested for kzalloc()
>> returning NULL, instead the already used nexthop group (which cannot be
>> NULL at this point) had been tested so far.
>>
>> Additionally, if kzalloc() fails, return ERR_PTR(-ENOMEM) instead of NULL.
>>
>> Coverity-id: 1463885
>> Reported-by: Coverity <scan-admin@coverity.com>
>> Signed-off-by: Patrick Eigensatz <patrickeigensatz@gmail.com>
> 
> Applied, thank you.
> 

Hi Dave,
I see this patch in -net-next but it should've been in -net as I wrote in my
review[1]. This patch should go along with the recent nexthop set that fixes
a few bugs, since it could result in a null ptr deref if the spare group cannot
be allocated.
How would you like to proceed? Should it be submitted for -net as well?

Thanks,
 Nik

[1] https://lkml.org/lkml/2020/6/1/391
