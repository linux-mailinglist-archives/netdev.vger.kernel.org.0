Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE40358504
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhDHNnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhDHNnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 09:43:40 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07394C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 06:43:28 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q26so2161857qkm.6
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 06:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Yjf1Zg11Qg54blA/eFQI8A3y3BgYDcMxe6bbo03brc=;
        b=SvsCllA3+Bxyp4Jk/uGBfq9xEg7BN04oCF8G6KNLqccoUi5aDkLAhDjji+QdT6xguu
         sEXnrF8EBtqogEQlA8fUa+Ek/zDj6M0nvnsDhPHdz5e0rr2horGWrsNFzG7PcxE9cgSK
         Q/ux1oSqZBLuv3mbF6qgjXqdkKg9jMa5gVWSqcXN4S6rMF/tviHrfL+Er73gl/eG+7yF
         vWGuBXzoY/5VWjDepfnRDTsAqTOgJ4kAj8byIDH3iOs9B+Q19iMeROc//aGa8iKz0DBw
         jI9Gyx+j3Cty/9rJkE/FfnpaNnIU/xiGTlrafpru9OnM1JH6IMHfeG40APmflQXafiXN
         agRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Yjf1Zg11Qg54blA/eFQI8A3y3BgYDcMxe6bbo03brc=;
        b=K7le24eEnCkY2rw80/DaqTbbSg+vYCU12qMvnbhWglTfr/zfQcTzqR88oVlVBjpez9
         Kt+zjcC5v7d3ZT8bKTOp5BqzXNp2ppQs6XFnDLijH6tX9pIi95UtVvw5NKWH4oAWQJd+
         DHO5V2Z0JSTV0ooNHrwIDmV4CfQPsjBFPJUWEDBqEGbegmGSJ3/ktc65oTOJ+HS+Plr2
         LKwJFqzqHi1Ph09M5de1Slbw150yCFKQukQlWnmo94IRTbivSuydjI8Gei1nIHN8sM5B
         4Yc247LuuMeeznoYqIx80+cd+wpPCkgxhp3l9g8uhOmZvbIdd/j1pbEdsuDIph4Nl8Zv
         OyWg==
X-Gm-Message-State: AOAM532c4sTayfq3p+ODBO8j1aKV3YVbNgUXAKQ/mrqcKVca6DSIjsVm
        zIsgJyvg4F0AHud2aRHKWTYE9A==
X-Google-Smtp-Source: ABdhPJz1tUntW5Rlvw+YCXZAgFh8XNpzVdjjYfOfl5nbnEcMPoCasIT1s7ENqOls2k6EPvhs02Jeww==
X-Received: by 2002:a05:620a:22b5:: with SMTP id p21mr8811999qkh.196.1617889407347;
        Thu, 08 Apr 2021 06:43:27 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-22-184-144-36-31.dsl.bell.ca. [184.144.36.31])
        by smtp.googlemail.com with ESMTPSA id m25sm18821050qtq.59.2021.04.08.06.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 06:43:26 -0700 (PDT)
Subject: Re: [PATCH net v2 2/3] net: sched: fix action overwrite reference
 counting
To:     Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
References: <20210407153604.1680079-1-vladbu@nvidia.com>
 <20210407153604.1680079-3-vladbu@nvidia.com>
 <CAM_iQpXEGs-Sq-SjNrewEyQJ7p2-KUxL5-eUvWs0XTKGoh7BsQ@mail.gmail.com>
 <ygnhsg419pw7.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <c84d6349-ec97-9ee7-12d7-544677c4ec8f@mojatatu.com>
Date:   Thu, 8 Apr 2021 09:43:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <ygnhsg419pw7.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-08 3:50 a.m., Vlad Buslov wrote:
> 
> On Thu 08 Apr 2021 at 02:50, Cong Wang <xiyou.wangcong@gmail.com> wrote:

> Origins of setting ovr based on NLM_F_REPLACE are lost since this code
> goes back to Linus' Linux-2.6.12-rc2 commit. Jamal, do you know if this
> is the expected behavior or just something unintended?

Seems our emails crossed path. The problem with ovr is the ambiguity
of whether we are saying both CREATE and REPLACE or just one or the
other. We could improve the kernel side by just passing the flags
to each action. Note it is too late to fix iproute2 without some
backward compat flag; but it may not be too late for someone writting
a new application in user space.

cheers,
jamal
