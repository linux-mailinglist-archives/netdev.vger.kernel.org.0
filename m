Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4775AA6C2
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390227AbfIEPG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:06:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46625 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387659AbfIEPG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:06:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id h7so3187104wrt.13;
        Thu, 05 Sep 2019 08:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FUgWccw0woyG2e6M/7x469teGzAXAKjM5wym+f71oLU=;
        b=e+UAEUh5SHxW1D8bYZCGYrbModyU/OXU3yDAxz4voldJsEaZQEXtvsXWm7v+9pAkGF
         BJLTEX3dqNCBTw3qdGwjqLCbuLEUWwbYKZyfPDwt9GCwykySJwxjaUTa4ouNKatSzYd5
         rHct195PnDwraMfmIPVbFnRoRLla15Km3O20FqlIZSLWwLpKJr/IKyvy3WdIqGhtVVNp
         REu46XBQy4Ch90jVs9csNzj3+PiLgwZ6422f40CqfBdy7ZbucEcgsed1OYIi04xP7j3L
         Yu3b+6pcITEPKPoEHElO/hI8qe8GyIEit60LnC0rGRGmCOspPYitYB2bnsJpU8GryxgH
         YTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FUgWccw0woyG2e6M/7x469teGzAXAKjM5wym+f71oLU=;
        b=Sra2ZNGrg5XFY0GWSs4PzEVdLuNgXr6663g03K3mU3w0yqZEJCaIc3JAwVCR64bWz8
         bQ+NyizskAVxTn0pyBOebS1whZ9mOld+BT2p2JeXKPvonXE98Kt8TYpCqIzcgBjSgpeC
         lBKuWx/JimPiUSlDm5d9EzgKYGZYUJka8BaGwFwKFoR8CsPMfYqFqa1meq6KSDMV1w+y
         N/nPjWd8wHv0dMYWU6DxG/zCjthshiAR/Yn4H3xkIYLpzAGX3Bn0lR9VTPuKPLNIZ7qy
         vf99Lbmz6+BlYW96OJzWfzKFUuX/zWJeRRlTAN1UfzZWIc8sAZ18FoHHsSkZOLCtr42i
         wjxQ==
X-Gm-Message-State: APjAAAVrAKHQrrds9tUjEQRL+j7q0qhZN6eB3s1U/rsp/eIRtorgk3sL
        Lf5XKnUl3I+ZCmZMA2lVDCE=
X-Google-Smtp-Source: APXvYqzOItE1cvzLVy+eSPRwJEMTk3j5+XdfCLAUzFZEoTLNy6oDpYOIt9n+79BqphySIrPpLua5gg==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr2995539wrs.193.1567695986780;
        Thu, 05 Sep 2019 08:06:26 -0700 (PDT)
Received: from [192.168.8.147] (163.175.185.81.rev.sfr.net. [81.185.175.163])
        by smtp.gmail.com with ESMTPSA id z5sm2501262wrl.33.2019.09.05.08.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2019 08:06:25 -0700 (PDT)
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
To:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Michal Hocko <mhocko@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw> <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw> <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV> <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV> <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw> <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <165827b5-6783-f4f8-69d6-b088dd97eb45@gmail.com>
 <1567692555.5576.91.camel@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5b4b16b1-caf9-ceff-43a4-635489d6ac66@gmail.com>
Date:   Thu, 5 Sep 2019 17:06:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567692555.5576.91.camel@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/19 4:09 PM, Qian Cai wrote:
> 
> I feel like you may not follow the thread closely. There are more details
> uncovered in the last few days and narrowed down to the culprits.
> 

I have followed the thread closely, thank you very much.

I am happy that the problem is addressed as I suggested.
Ie not individual patches adding selected __GFP_NOWARN.

