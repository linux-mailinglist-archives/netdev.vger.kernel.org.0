Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B117B1410E6
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgAQSiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:38:04 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44774 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQSiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:38:04 -0500
Received: by mail-qt1-f195.google.com with SMTP id w8so8096439qts.11;
        Fri, 17 Jan 2020 10:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=B2QYMnKFf/fcxzGZsqSaFpUv68BVpaJGzVeEGxBvjew=;
        b=fruG0QB/ncmSEH66MAEoRQM52PMTvjKnk6RXGZ7atnpIlt/W6g29QWbRrU28pNEsrm
         c6vyrI32CHHNcmpd0PfCMMLGP9CDhhLtYtXQyhEVNMYomd8ruht4aFaKkDbk5F5LLEwF
         KJXWHcvd3Jk4MSeTXK0xg5bz2NgNErf/edGu3in8Kpk+aNZ5Cm85Mq1bcMOiYnBglJS+
         JW8OHsXYwMXrnJGIgMCod0qVZdXtXqVKhnSdVXwhcJueEw49FrmRgB3ZrZvVTPxyYMxG
         jv5q4qAqYG0HCganCx2oic9mAlX8HUL0BsT6ldOGr6v/QimQ1Svg3jzNMNcmTcrXaNi4
         xZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=B2QYMnKFf/fcxzGZsqSaFpUv68BVpaJGzVeEGxBvjew=;
        b=GLygpWP1faEIoTefG+n2rsf9rRpWRUSpeivRwnjwZBc5TAt63GFSX9Ayo24wDcwyNo
         VbQd9wJXNR9hpPEuQOAhDDWMqV8z33YDqJ9SAen2xvKpylvWOavJLd4csneGnBMY5ZRm
         6Cpm4jaKajYPbC4yhSZSzSeVKcGRT4eqDkhxbGFI+Wyew6eXmcR07OqK1c+7TN23+a27
         tnbrevda2+yEVl10XO99aasmJ5Iw/EYq3FZ/NjJr+kdmmx0UoamTFAox5j46dj/igtG4
         2o0ruDYQaqJFPSwjHxithHWL9A0Cp8HPwknZD5gyPA/giFxE7EsZFUkCGLOuCY3C4c5N
         tG/Q==
X-Gm-Message-State: APjAAAWdXwEDP5vyBC2syjGuzW8cxTptGLh5e2ofJmTKeYwfdEy3Y3wV
        ViSwpcf+ZhB8VMQr7+78kaI=
X-Google-Smtp-Source: APXvYqxfcPbp81Ww7YtN4cnsDMKrKyQXnFvzj6wQg2OY4pren+17ftRh6bVyOrgBFTZl9q0wjaW8OQ==
X-Received: by 2002:ac8:124a:: with SMTP id g10mr9031376qtj.303.1579286283330;
        Fri, 17 Jan 2020 10:38:03 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m21sm12151734qka.117.2020.01.17.10.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 10:38:02 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 17 Jan 2020 13:38:01 -0500
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinyuqi@huawei.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
Message-ID: <20200117183800.GA2649345@rani.riverdale.lan>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
 <7e6c6202-24bb-a532-adde-d53dd6fb14c3@gmail.com>
 <20200117180324.GA2623847@rani.riverdale.lan>
 <94573cea-a833-9b48-6581-8cc5cdd19b89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94573cea-a833-9b48-6581-8cc5cdd19b89@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 10:16:45AM -0800, Eric Dumazet wrote:
> Wasńt it the case back in 2016 already for linux-4.8 ?
> 
> What will prevent someone to send another report to netdev/lkml ?
> 
>  -fno-strict-overflow support is not a prereq for CONFIG_UBSAN.
> 
> Fact that we kept in lib/ubsan.c and lib/test_ubsan.c code for 
> test_ubsan_add_overflow() and test_ubsan_sub_overflow() is disturbing.
> 

No, it was bumped in 2018 in commit cafa0010cd51 ("Raise the minimum
required gcc version to 4.6"). That raised it from 3.2 -> 4.6.
