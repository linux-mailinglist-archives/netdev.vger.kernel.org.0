Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0104334E0
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhJSLlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:41:44 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:45422
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230129AbhJSLlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 07:41:39 -0400
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0417F3F4BA
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 11:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634643566;
        bh=nX+hgZuu9fE6BhknlkkEZCMXVcIn2J/gsqHaBdOU6g0=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=KegxTO01XyXg5ktc6Scv/x72tjEP9P1n5XL0+Q7AvS3G8wXjYAYecGUmYOscCdNs5
         CjFzMXNg6NYoz+o/QcMkFXuaqYt8dwCIbYXqQK7OuE4G5vYapzNezod8zU3CbLaD0W
         yqDtdwTheXtuheJhuti7dOmRY99lvKIXcnuYcJeVfAYGbS+C43S7cCkDwYee8vNA5+
         xGVAfarmbm62pD0HhTJDWBHxrMx8vbCDzeytq2p0n9p8EnROsM91EgnlWMIcMvzeHb
         5m2hV7sqo6SfZnHwhkqwE4ixMGCCci0kqrYmXBFMmvgMircmDw0+0oaq4cRaUJWiIX
         u/P69PKR15Agg==
Received: by mail-pg1-f197.google.com with SMTP id e6-20020a637446000000b002993ba24bbaso11491347pgn.12
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 04:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nX+hgZuu9fE6BhknlkkEZCMXVcIn2J/gsqHaBdOU6g0=;
        b=yjsuJ4XQ21GdOsoS+nmkFw0UIemlAKkxVbdQhcYJG9xirD8Q4/VgOFzxA8E2bTS1Px
         Dt10Y3QSSuaWoqwABJuZ09AXQbsUco0nW3rFKseHMnov9/tvXSmuHVvMWVR1BWW059iO
         BEAbKWIZXgdr41uS4w/Oya+X+8n+GHyReGE2Qj1l/a1pxLN5Ssp3yv4FOIgGAvDqeRDd
         2CaBg5w9Pf9LC+66HRCSidmavo4pdKKIsePyn/KtcOuGZxyRpW/roDSv4n4wmLEIj7Wl
         8wH1idIr1vGBkNAPWx7tYR+lWcL8ksxk8NZjKY4M3y0uV9jf7SBkyKQ5Ma6nuWhcF4/z
         uBjw==
X-Gm-Message-State: AOAM531YowDWK4gYusi1vQ24r+iVujsJvXv+1sGT0qc5fia9+XIk3QNa
        xJckfZ1S9i1fyzkEykEgfIBmwggrpI8tOGlAGlIdiiSo/vDLZ3Pkfo3JnB5GsWxVKaUD2YzY6Xo
        LM/nJl0j5mtX0WATsiZzUlEM7o9wGrHUm9w==
X-Received: by 2002:a17:902:e282:b0:13f:62b1:9a06 with SMTP id o2-20020a170902e28200b0013f62b19a06mr32926767plc.1.1634643564632;
        Tue, 19 Oct 2021 04:39:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyXR2OsgUdzLBM3eT6ViBbK3B7Gx8dj2DyWABV4UYbeu2DDl1H4b7QR4zEJNVXlKGlLVsziw==
X-Received: by 2002:a17:902:e282:b0:13f:62b1:9a06 with SMTP id o2-20020a170902e28200b0013f62b19a06mr32926746plc.1.1634643564357;
        Tue, 19 Oct 2021 04:39:24 -0700 (PDT)
Received: from [192.168.1.124] ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id y18sm15951322pff.184.2021.10.19.04.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 04:39:23 -0700 (PDT)
Subject: Re: [PATCH][linux-next] net/smc: prevent NULL dereference in
 smc_find_rdma_v2_device_serv()
To:     Karsten Graul <kgraul@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211018183128.17743-1-tim.gardner@canonical.com>
 <ceb1a1ce-b4a4-7908-7d18-832cca1bfbe2@linux.ibm.com>
From:   Tim Gardner <tim.gardner@canonical.com>
Message-ID: <00975c56-da9a-2583-ac42-ae6a83e40050@canonical.com>
Date:   Tue, 19 Oct 2021 05:39:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ceb1a1ce-b4a4-7908-7d18-832cca1bfbe2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/21 12:33 AM, Karsten Graul wrote:
> On 18/10/2021 20:31, Tim Gardner wrote:
>> Coverity complains of a possible NULL dereference in smc_find_rdma_v2_device_serv().
>>
>> 1782        smc_v2_ext = smc_get_clc_v2_ext(pclc);
>> CID 121151 (#1 of 1): Dereference null return value (NULL_RETURNS)
>> 5. dereference: Dereferencing a pointer that might be NULL smc_v2_ext when calling smc_clc_match_eid. [show details]
>> 1783        if (!smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
>> 1784                goto not_found;
>>
>> Fix this by checking for NULL.
> 
> Hmm that's a fundamental question for me: do we want to make the code checkers happy?
> While I understand that those warnings give an uneasy feeling I am not sure
> if the code should have additional (unneeded) checks only to avoid them.
> 

Coverity produces a lot of false positives. I thought this one might be 
legitimate, but if you're comfortable that its not an issue then I'm OK 
with that.

> In this case all NULL checks are initially done in smc_listen_v2_check(),
> afterwards no more NULL checks are needed. When we would like to add them
> then a lot more checks are needed, e.g. 3 times in smc_find_ism_v2_device_serv()
> (not sure why coverity does not complain about them, too).
> 
> Thoughts?
> 

Coverity probably has produced a report from the other call sites if 
you've used a similar pattern, I just hadn't gotten to them yet.

I'll just mark them all as false positives.

rtg
-- 
-----------
Tim Gardner
Canonical, Inc
