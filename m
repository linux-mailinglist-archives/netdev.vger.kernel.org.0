Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F6B1C99C9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgEGSuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgEGSuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 14:50:04 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8571C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 11:50:03 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id u4so5369369lfm.7
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 11:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9+nO6ZEmApWAsoC8i6mMVVzQ6ZYdxQXskyH9PvsUp4M=;
        b=SMJU3C05jSHBg9KjQF4pJwEc2Z34KSC1LDa7NaIYia+k4eFz3godYMYxsdEhX9t3dr
         xYe+vqlJ64hqM5htzIoH+gB1O6a5M0Y7pfJotfrGz9OYKT56lqQrlFZxyPCckZOudIhd
         E3oRRp86dJ79PtC7+XpFBpgKedlSikOIxjGuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9+nO6ZEmApWAsoC8i6mMVVzQ6ZYdxQXskyH9PvsUp4M=;
        b=W1AWQC2xD9AJPCNLYJlphXV06xzANXV3KAjVbclOqHFkgg/m1PX+ltxAdh+/tSkIq5
         bsKbtjyWMcKd/kUao+5K8ae90LS5m/AtwX1JGuyMuAFt6+v3N+U3EzNc3p+WEMAZ3bsl
         PBG7xAtdOZADVJKecsB3dKHJ5POt+CBQfokv5EbeSw7Rzr13MFs4BZ2bVeR9hWtVmlre
         sf+eJezJDC2Dyct4+lkmMs/5wGtRcZTMZax4F2rtsHLlzMa64S/vjOTWNsUHo/VcB8/B
         yiDNuwus2BqiOXayXD6Z9VsD+3Cx+d8go+yuyn5bKIkhAv6s48koGR9V+fRG6su2lSzV
         EqiQ==
X-Gm-Message-State: AGi0PubUPNf8Ye/fp/fNAAvUK8JHaL1ivnUmecBmminMzuOLTZsCaZv/
        pX0x0X6TrPgnLzuWn3kfsrzXwQ==
X-Google-Smtp-Source: APiQypLObk/R6SLqNQolhhlWfHKDr5nwzejD56Lga2clsE2LI6YVhLNRYOJJrD7t9WQZTI9shHp4+w==
X-Received: by 2002:ac2:4c3b:: with SMTP id u27mr9554725lfq.212.1588877402426;
        Thu, 07 May 2020 11:50:02 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c2sm4485184lfb.43.2020.05.07.11.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 11:50:01 -0700 (PDT)
Subject: Re: [Patch net v2] net: fix a potential recursive NETDEV_FEAT_CHANGE
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
References: <20200506194613.18342-1-xiyou.wangcong@gmail.com>
 <aa811b5e-9408-a078-59ea-2a20c9bff98f@cumulusnetworks.com>
 <CAM_iQpXMZ1u+a+c1eNFThYar4eDFVs2G2F7otHHPK-zye+vzww@mail.gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <65667dcb-5678-2744-8d05-b66bff325f05@cumulusnetworks.com>
Date:   Thu, 7 May 2020 21:50:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXMZ1u+a+c1eNFThYar4eDFVs2G2F7otHHPK-zye+vzww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2020 21:45, Cong Wang wrote:
> On Wed, May 6, 2020 at 1:31 PM Nikolay Aleksandrov
> <nikolay@cumulusnetworks.com> wrote:
>> The patch looks good, but note that __netdev_update_features() used to return -1
>> before the commit in the Fixes tag above (between 6cb6a27c45ce and 00ee59271777).
>> It only restored that behaviour.
> 
> Good point! But commit fd867d51f889 is the one which started
> using netdev_update_features() in netdev_sync_lower_features(),
> your commits 00ee59271777 and 17b85d29e82c are both after it,
> and returning whatever doesn't matter before commit fd867d51f889,
> therefore, commit fd867d51f889 is the right one to blame?
> 

Right, that should be the one.

> I will send V3 to just update this Fixes tag.
> 
> Thanks!
> 

Cheers,
 Nik
