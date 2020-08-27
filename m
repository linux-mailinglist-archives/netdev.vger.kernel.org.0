Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10236253AD2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0ADV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgH0ADV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:03:21 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA7CC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:03:20 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k18so2049271pfp.7
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=myexRlO81et0ByGU+F0y88g9ljXYqJ4TswqruWi/IO4=;
        b=P5A47w1Q14yFPhOgyh3malQnahlgdgdvfD9RilmC1qhxRXJM4HkuXvOmKGBpTy3Fgl
         kSM4GcKFoDxpsCjVMevXhF526Qu907Q+We8TaLkOmRlvyr2Q7RadFU7+DDXbi2N/V8c3
         l/N4VWij9V5bOBMhVT+dfSS/p7SpHHPIK6OLsopWGrYbR0SbA+h2mWTFidcMWNqs7heV
         tDcJZ8NbQFRRmamIn40W1ET8vY/SgUuObhqOa9ySr1JmN5x+wPeI/+f+1HyK4XVZN2Be
         gJS4qruCuOiQUtFMHqe/i9K3TJg3MaWrw/Bc299aBkQuFENc2KIEH7zdu7h4Mb/o8nJb
         BywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=myexRlO81et0ByGU+F0y88g9ljXYqJ4TswqruWi/IO4=;
        b=VAnJ92po4X09YqX50KuJn3+ZHMJKuYxJgglikXzEMuktM2DdAgsidlZuvpDywMxviW
         Sg+bQ7PMxS6eSOwo1G6RKQPTECIyFZv/djQ2/PNyJhGp2PU2NhRS1WDNI3o+VY9KBSME
         HL5AtHqzA/ark0gJLWjK5zRqBB6lzRjpRjZwa0GKyKBnJj8TUuffD47uGIl/7SNNuU1I
         +tdME1rrSu6PrQ832iFqtTgoIQos8B9IIMSzg5/lW3fXq4t5en3aH2vuUpIQPUGcOgEG
         XSHsQCRaj8YIB6SLI+rJMDzYW7txZ4lc8ky+VhXjWkETjaFrki+nP0mUSxkmqD4nl6mx
         X1DQ==
X-Gm-Message-State: AOAM530RmiUjeGf0QCJvxWTaRrCVRGD1TaAvmzrhIvVKqLSleFBEVnco
        EY3iLlZNIcKGJOuVWH0/WLqOBw==
X-Google-Smtp-Source: ABdhPJyPAc/LFd4iD+BsA/Houngi2JelMkFFEnIBTVTiLiGhTcZsLBLoK4X8B2tvsraGqnRLaCNWzA==
X-Received: by 2002:a62:8015:: with SMTP id j21mr14014657pfd.235.1598486600098;
        Wed, 26 Aug 2020 17:03:20 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id ce8sm206380pjb.24.2020.08.26.17.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 17:03:19 -0700 (PDT)
Subject: Re: [PATCH net-next 07/12] ionic: reduce contiguous memory allocation
 requirement
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200826164214.31792-1-snelson@pensando.io>
 <20200826164214.31792-8-snelson@pensando.io>
 <20200826140119.3a241b0b@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d9d6142a-4fc9-ed0d-c685-2a7f0dbdb490@pensando.io>
Date:   Wed, 26 Aug 2020 17:03:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826140119.3a241b0b@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 2:01 PM, Jakub Kicinski wrote:
> On Wed, 26 Aug 2020 09:42:09 -0700 Shannon Nelson wrote:
>> +	q_base = (void *)ALIGN((uintptr_t)new->q_base, PAGE_SIZE);
> PTR_ALIGN()

Sure,
sln
