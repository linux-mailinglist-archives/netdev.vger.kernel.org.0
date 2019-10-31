Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5D9EB7E1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbfJaTQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:16:43 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44870 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729347AbfJaTQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:16:43 -0400
Received: by mail-qk1-f193.google.com with SMTP id m16so7837858qki.11;
        Thu, 31 Oct 2019 12:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vanyUnjl7rLa98CaPgWAd6vjALctAE2zMH6j41yDlFQ=;
        b=iLFYaTnkUOtpGHzaH2Wm0L5zrV2aOAgeS5/3Q4axYp61/bfi0CIEbdMccfEqzrmxXS
         3pBLE7g1JtEniZyjzaM2FMSQsq5pPRAtDtOV/ynd4s6QTyVhMjNSgEHlXyTwz/jsqKYs
         JZCBm870phUbXQkNN3+123W0Mcelr5DYTVxdG0VOEF+wj99DyUvH1F7sYKqD3nk5Jp1v
         MQzDGEH7l3Pl53zKsyptEKqzqY7XsWlY8d5YIFJdmhQwDiPvms0WacXAiguL2NaJmRyK
         mGLXRYXMxRVS33UIU4vpO7T9IKxu8QJENbbXtsPqlHvZGxqQNLMZlz7dQRWLisj8rFf/
         Zfqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vanyUnjl7rLa98CaPgWAd6vjALctAE2zMH6j41yDlFQ=;
        b=ekTP8YeIIqmrzAKw2RtYzvZS0p75iGeWvFyUB77fY4axYD6jOrpB0y3bcD1QERHp3z
         7Uxfv60VZSDEYVM6Vx9LHa1UfhZTPoual+rf3JKxXKE8TdH49cUIEtuBHlu2TVe9bVhI
         vSsoDh2u5IHWVVnRpgIr/xSoNytow/oht7gY+sLoG3F34y6JEeB3+GzORpOnxd8baPxk
         deEHPvO1GeQgDJT4M3nc+NcKoCvN/V5uJI+Zt4vKRYQ5GceYZl/VyMDrqv/1Yj/TEhT3
         RdN0DTMo8fAbFtrCUbxwvhFHlKNRPHkDe7bMXFpYa+jf0SXf8nxbQ/9L9HoLGd4Der3b
         858w==
X-Gm-Message-State: APjAAAWnkisyFlSFCd8lI4DACNPMhHtAnpxydPIlDf9X8u2d+/1Adoyk
        ujzFOr6VjHDGdf9QCBtlIyg=
X-Google-Smtp-Source: APXvYqyJdgtpE/wKH1MsVvvRYKtVGcwDBzqNEpcWGYwXhmW4HvayXpTiJx5oZRzGUd/FQfgwlk9F8Q==
X-Received: by 2002:ae9:e215:: with SMTP id c21mr5182690qkc.476.1572549401615;
        Thu, 31 Oct 2019 12:16:41 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::e44c])
        by smtp.gmail.com with ESMTPSA id 76sm2815031qke.111.2019.10.31.12.16.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 12:16:38 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:16:37 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] net: fix sk_page_frag() recursion from memory reclaim
Message-ID: <20191031191637.GO3622521@devbig004.ftw2.facebook.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
 <20191024205027.GF3622521@devbig004.ftw2.facebook.com>
 <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
 <11f688a6-0288-0ec4-f925-7b8f16ec011b@gmail.com>
 <CALvZod6Sw-2Wh0KEBiMgGZ1c+2nFW0ueL_4TM4d=Z0JcbvSXrw@mail.gmail.com>
 <20191031184346.GM3622521@devbig004.ftw2.facebook.com>
 <CALvZod7Lm5d-84wWubTUOFWo4XU2cgqBpFw84QzFdiokX86COQ@mail.gmail.com>
 <20191031190053.GN3622521@devbig004.ftw2.facebook.com>
 <CALvZod5U5yEZPhURYffEtDto6sL8JG+3ZSRtv3uOait8yBn=EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod5U5yEZPhURYffEtDto6sL8JG+3ZSRtv3uOait8yBn=EQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 12:14:58PM -0700, Shakeel Butt wrote:
> Oh ok, I will send the incremental one once I have this patch in the mm tree.

It's in the networking tree already.

Thanks.

-- 
tejun
