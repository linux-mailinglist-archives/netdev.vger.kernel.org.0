Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574BA1F51CF
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 12:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgFJKEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 06:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgFJKEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 06:04:05 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE187C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 03:04:03 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id y13so1915115eju.2
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 03:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HwV7+fD5fSJvpU7GeH/W1qZ5yvl9sUH1i+x697MjOCs=;
        b=AsUSRXKe91CyWZkWsqdCl5zDdPA6tDcWuTdmv+j08nSB2ovRM1ANL+vyYSl8hqyh5E
         3ojBZx1t5OMjpVFWBiCKYuno+lEnd5E0MGsu41cR1NLOLqQnBbZraLTyniUg3aCc5BI8
         McNwnB603lj1oyuVn8sh6IoThyJ+svoK2REt7UVRL4JyUZ3j4fixiQJJ8cr85w2k2nLG
         sBus7sH653gF04NP1vOsMHm11AD5KNsofmpc9sy6WF2fUmNM1zEctZc5kcDmYu57NnA2
         oPSlhw4SxHtJDXIVBncvh+v+Fi0tBviwpeQGiDmdFAQBD0WUjjePzHhNcrMtvBcPqLQl
         IVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HwV7+fD5fSJvpU7GeH/W1qZ5yvl9sUH1i+x697MjOCs=;
        b=sstnikrk75bUQ+BcQtrJjbafYVn9OEx/NRnT+Ae7ngKUMx9BIg8nV3A2fmhBQoFYoa
         nI0RRLfxg6Awmy7VG/NVojH5utFSJW2WnrEqzAWTsv8sLIjz84d7LtBiNgab4jRoUtNB
         XgdgwEekcSc/qLsGxTaLGa2lIAr49gRjjJWjp3EwLRAW2fEJAuuU5Y7xjTABl5mV8b3m
         r0FR3doF5PffqouC4c3wioOZrbGkjM3WhOv9AsyqDMecQA7+Is4cqgC3aqvL3h0ZmSyi
         NI5Cpi/w9k8+G7e+52iFx2x+YVGmFbOz868xkSGr9wHKCa7/sX+m5zOvEQQRPWZPso3q
         l30A==
X-Gm-Message-State: AOAM533vt/luioGHgWTio8K5YkF/598cHV6ov6Z2UYFTpbXzlni7f9pQ
        m25/JHok8BKMufc3NHMhoGMTJg==
X-Google-Smtp-Source: ABdhPJws3xcQfnTUlAfZOTGTSOKR9M9uZfeOP5ULYm1zR+uDwL7jYUtGzqvvFH+xVyVQ6EOaJWr5NQ==
X-Received: by 2002:a17:906:8401:: with SMTP id n1mr2525281ejx.479.1591783442379;
        Wed, 10 Jun 2020 03:04:02 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id p13sm16732291edq.50.2020.06.10.03.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 03:04:01 -0700 (PDT)
Subject: Re: [MPTCP] [PATCH net] mptcp: fix races between shutdown and recvmsg
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
References: <766c50ce4e7e0415adaf0c63e3f92e75abb8470c.1591778786.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <f9ae8422-583f-24d3-c5f4-776f24e788dc@tessares.net>
Date:   Wed, 10 Jun 2020 12:04:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <766c50ce4e7e0415adaf0c63e3f92e75abb8470c.1591778786.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 10/06/2020 10:47, Paolo Abeni wrote:
> The msk sk_shutdown flag is set by a workqueue, possibly
> introducing some delay in user-space notification. If the last
> subflow carries some data with the fin packet, the user space
> can wake-up before RCV_SHUTDOWN is set. If it executes unblocking
> recvmsg(), it may return with an error instead of eof.
> 
> Address the issue explicitly checking for eof in recvmsg(), when
> no data is found.
> 
> Fixes: 59832e246515 ("mptcp: subflow: check parent mptcp socket on subflow state change")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Thank you for the patch, it looks good to me!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Matthieu Baerts | R&D Engineer
matthieu.baerts@tessares.net
Tessares SA | Hybrid Access Solutions
www.tessares.net
1 Avenue Jean Monnet, 1348 Louvain-la-Neuve, Belgium
