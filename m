Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31096375ECD
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 04:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhEGC0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 22:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhEGC0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 22:26:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93EEC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 19:25:49 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id m12so6086505pgr.9
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 19:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uVfTFC0cQrSIdA142JNxuRijb7rQBZq9roivMB8HdeU=;
        b=BzzkWj2qchfEUUprcYt3Sab3JqHIv0xSl2uBfAeqCxn1yPAKlIIhHgSXg1keTvF7Dc
         QJujjxPMB7XFpQ+dqEexacSFiQ/mKxAkZgN7qsraiFUXHy9IY+QM9oXe4fvw2dlP3ZcN
         NZ9o/7r3AUa8AsINRjUbWlKghg49nID/gE6+0C3PkIAzlsnouya1iXXbpiGHXAd0MZvp
         f1sAVZ/ZmFkD46hGMxTVyIB2VXKZX/VnBGb7ciW9arFN/0F31wwTo7QGbh3rb26aVeoi
         LVaktLJvMATm2JZA5YpIMslyud5sPN+HCxayfPHNdapR+uyRbWgUZ9LkOVPXiu7t1dxX
         uavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uVfTFC0cQrSIdA142JNxuRijb7rQBZq9roivMB8HdeU=;
        b=qDixT5i2XerGMuKfZomJboOW/rMh50eM+Wdxy3LXARkvEcwJ4YoQUTwBZfk9732Igs
         zqrqyXPAAw5QcFQsSpVme0NXHAOal6ZHKBm8a3OOpZoWhJ0VshFPBcV9N/otpW+9nFaL
         lXlPggovJxQzouemKbV3wtD5uyGigYLBJxFyIgw5tpwHlW1JPiXBc+woZCyL/unz+Osx
         d/1qO9v/v2WchFgNJqbM39iHBXldc/E9b3M88e+xaaR2nHi1sKoxRxZUwaJqpGrGDP3R
         2G4B/QLOD+6bw9YK5qND2MThVTO4sO/BwlLnFmS7ATr9i8nG/rLFykx1HcEq/8BeCRk4
         Uxyg==
X-Gm-Message-State: AOAM5303eXiwYOiZzwU7oQ14xhf5wttYbJHHE03CVo7/ufUEtzW9DyNd
        HgTEHl/qMHqFynlfo6hNkyE=
X-Google-Smtp-Source: ABdhPJwn3dp6+M/qpZjO9rgCJWE4LBlY5JdCYlkC2JTWO6lp1apQTVYvP4sIEfMnyhJMRa98H4xlUg==
X-Received: by 2002:a63:cc57:: with SMTP id q23mr7363351pgi.357.1620354349122;
        Thu, 06 May 2021 19:25:49 -0700 (PDT)
Received: from kakao-entui-MacBookPro.local ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id l10sm3233489pfc.125.2021.05.06.19.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 19:25:48 -0700 (PDT)
Subject: Re: [Patch net] rtnetlink: use rwsem to protect rtnl_af_ops list
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com>
References: <20210505233642.13661-1-xiyou.wangcong@gmail.com>
 <d7581cb6-a795-42a3-346a-07ccfa8fc8ce@gmail.com>
 <CAM_iQpX9N5UswtQPAe__baUm4hU3vKZ5tQFyAE61qHAQSfcbWQ@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <0057c2a2-b132-b17c-0eb9-7bda47986e76@gmail.com>
Date:   Fri, 7 May 2021 11:25:45 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX9N5UswtQPAe__baUm4hU3vKZ5tQFyAE61qHAQSfcbWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ko
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021. 5. 7. 오전 6:30, Cong Wang wrote:
 > On Thu, May 6, 2021 at 5:26 AM Taehee Yoo <ap420073@gmail.com> wrote:
 >>
 >> On 5/6/21 8:36 AM, Cong Wang wrote:
 >>   > From: Cong Wang <cong.wang@bytedance.com>
 >>   >
 >>
 >> Hi Cong,
 >> Thank you so much for fixing it!
 >>
 >>   > We use RTNL lock and RCU read lock to protect the global
 >>   > list rtnl_af_ops, however, this forces the af_ops readers
 >>   > being in atomic context while iterating this list,
 >>   > particularly af_ops->set_link_af(). This was not a problem
 >>   > until we begin to take mutex lock down the path in
 >>   > __ipv6_dev_mc_dec().
 >>   >
 >>   > Convert RTNL+RCU to rwsemaphore, so that we can block on
 >>   > the reader side while still allowing parallel readers.
 >>   >
 >>   > Reported-and-tested-by:
 >> syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
 >>   > Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface
 >> mld data")
 >>   > Cc: Taehee Yoo <ap420073@gmail.com>
 >>   > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
 >>
 >> I have been testing this patch and I found a warning
 >
 > Ah, good catch! I clearly missed that code path.
 >
 > Can you help test the attached patch? syzbot is happy with it at least,
 > my CI bot is down so I can't run selftests for now.
 >

Yes, of course, I will test it.

Thanks!
