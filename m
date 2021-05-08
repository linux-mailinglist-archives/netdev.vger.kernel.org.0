Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC78D3770A6
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 10:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhEHIX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 04:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEHIX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 04:23:26 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69019C061574
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 01:22:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h7so6429488plt.1
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 01:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g7lWeE7H6m/IMVbyt8KzEUXqBeov4Q831N5Lj1QifIU=;
        b=CUrsAKxq4MEtAAgNw/DIqhIm12rXneu/Ol8jIPXQANf3b9PgfoIf/c31Pa7GZiCVK2
         Da/yPqqN0v/cg/snZhxaSG/3k5zbrYFMyT6883+fVTNN1CxATsrFB8iJ9dQL6mwjns3j
         WsZ/EM1Dy/K/xvnNPg7AxFVMiCfBJi5grmk4Tye1dSIq/saxy1cmbGb7JRlqtMeDATBX
         549jMuzxPJ4vb72R0wv9FyGnhd4D69bALIunevdKqonB1UsWJYRcNyIPVOGykjI20dS7
         SBzRbV1xKACWX5A3ElF1h6wQiOg3GL5NkuRm2QxOtoBbCuVfaOT2PqpMujLacz13BLGs
         q5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g7lWeE7H6m/IMVbyt8KzEUXqBeov4Q831N5Lj1QifIU=;
        b=RYcXnvf5kv5ZqmzwiFL9RPRz6Piy/cWiXRxRZsG1INkQ3biqMAuEJCb/ToCUMeVIpJ
         3UZkysjAgK7ibZZ/gAFR2so6DVWBqrqvn6O5DREozgatIXxl1/R30Lhr97nWL0afGlHW
         kT3a+bPsWemDkPPKz3gYRIWnj4fP6kPbAF8lNx/zx/Z574Mjn4cOkujbOevwrvNsstZi
         tCPAFn5i6Z8yJKDgwF8/3gYiYtf0lL9tTDMyVQ0MXOzCv5UQQDtOT/Fe9dVEvXQ9/UT5
         ejKb5oLQFJ9PYpkcPXFTrneSRpIjIK+HpBCs5Bn1mFx5GzG3IXWgLHdA4KYyVxiY35QV
         D0bw==
X-Gm-Message-State: AOAM531tAX2ZpZV31xUkYeqgOFLr5YXRsuKsXHTsfhqjA4vSzQ/sOOzW
        wL+XamKSZO2qEDd91eVP/h4=
X-Google-Smtp-Source: ABdhPJz18GQAts6UqiDTtmoh/cHYBl14gsz6PKGWGmVLEe7/0InBm1jBLXE58S6cn3xx3IQUCgeetw==
X-Received: by 2002:a17:90a:17c5:: with SMTP id q63mr670070pja.136.1620462144912;
        Sat, 08 May 2021 01:22:24 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id m19sm6276738pjq.41.2021.05.08.01.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 01:22:24 -0700 (PDT)
Subject: Re: [Patch net] rtnetlink: use rwsem to protect rtnl_af_ops list
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com>
References: <20210505233642.13661-1-xiyou.wangcong@gmail.com>
 <d7581cb6-a795-42a3-346a-07ccfa8fc8ce@gmail.com>
 <CAM_iQpX9N5UswtQPAe__baUm4hU3vKZ5tQFyAE61qHAQSfcbWQ@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <68687fbb-d433-0f7a-9a3b-59f497ce6563@gmail.com>
Date:   Sat, 8 May 2021 17:22:21 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX9N5UswtQPAe__baUm4hU3vKZ5tQFyAE61qHAQSfcbWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/21 6:30 AM, Cong Wang wrote:
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

Hi Cong,
I have tested the attached patch with the syzbot reproducer and my own 
reproducer.
I couldn't find any problems such as warnings and other splats.
Thanks a lot!
Taehee
