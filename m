Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA0EB7AD
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfJaTA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:00:57 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34568 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbfJaTA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:00:57 -0400
Received: by mail-qk1-f196.google.com with SMTP id 205so6818770qkk.1;
        Thu, 31 Oct 2019 12:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cq1LIrgzLt4D7jFix/b6ZOBgh+rodo6WWUZzQKJRHmc=;
        b=IrUoh5ZgVpBMUuwxVqPjfKMiNgJtqVbF3ZXamEE6kM2xo7Y6J0t4t3ChmgUz5N4+Hp
         vRSwNL0Kyeer3+YkSYZPBXldJJBnZ6XEv0hbP+znWVu+JMrCsRqPtvn6OPAHksIEP3Du
         PEzjOQDQdzd8vSpYjXEKUJz65bRhbDJZwf/VxbDV4af85roIwaturU+z5LfBfMSjBUMM
         tY/jywbAabeMrRSmbo0ptq3HOki5Kh3kfRG2Sbh5aS1PHG86/+dFh+jImmSjf4kw7Db+
         R5Q8VAWM5ovSWINfYRf3rm6mpcfRwIbZwfyEzH2Db6LIMxrKwC57mRKKYP8T17PthsXR
         rAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cq1LIrgzLt4D7jFix/b6ZOBgh+rodo6WWUZzQKJRHmc=;
        b=Vgiyd1A/04qTwpANAK0VCQDKxGKmNjGK1oRDrueggCcl69qilzjMaL5ZRa7dTZv9Ui
         wYget1OKRzBUP+90XTg6YpuLCUeOd6sAEX47SVub2afR1bGi7P46yNiaBaS0G8VB7qPV
         h7fu2CM5+ui0bb3OLEbUc7kPMMporOUOmErzxzONk0d1t0F+wS/QZ3uJlMsx4GF/8RCx
         j6y/SRQYQfr7L6x7493rotWRFYlDahhI4T609Q3t69lYNeag8oNqMzDbcooB9popNtt0
         F0eFpU+0dmgyiTYFrtE/W2qbCk87jhGyr8HwH/n6qeGAJ/MhoP09quwbqJbm6BqbqrHL
         SAHw==
X-Gm-Message-State: APjAAAU0T3xHMRXeY/qaO+zLAyni4aXM+QLpCULZJECK16qaQrciuunm
        qqevh1+n5RNp+rbe9/5vm7E=
X-Google-Smtp-Source: APXvYqzSjc1OryLoue6gWdyUUvcRnC5Roo0oxmkOJM6ulFr7ntxKe+KWBN7gg1UnFGoUFFGm2wXXWg==
X-Received: by 2002:a37:5dc4:: with SMTP id r187mr6839078qkb.173.1572548455831;
        Thu, 31 Oct 2019 12:00:55 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::e44c])
        by smtp.gmail.com with ESMTPSA id k3sm2222682qkj.119.2019.10.31.12.00.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 12:00:55 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:00:53 -0700
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
Message-ID: <20191031190053.GN3622521@devbig004.ftw2.facebook.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
 <20191024205027.GF3622521@devbig004.ftw2.facebook.com>
 <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
 <11f688a6-0288-0ec4-f925-7b8f16ec011b@gmail.com>
 <CALvZod6Sw-2Wh0KEBiMgGZ1c+2nFW0ueL_4TM4d=Z0JcbvSXrw@mail.gmail.com>
 <20191031184346.GM3622521@devbig004.ftw2.facebook.com>
 <CALvZod7Lm5d-84wWubTUOFWo4XU2cgqBpFw84QzFdiokX86COQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod7Lm5d-84wWubTUOFWo4XU2cgqBpFw84QzFdiokX86COQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 11:51:57AM -0700, Shakeel Butt wrote:
> > Yeah, PF_MEMALLOC is likely the better condition to check here as we
> > primarily want to know whether %current might be recursing and that
> > should be indicated reliably with PF_MEMALLOC.  Wanna prep a patch for
> > it?
> 
> Sure, I will keep your commit message and authorship (if you are ok with it).

I think the patch already got merged, so it may be easier to do an
incremental one.

Thanks.

-- 
tejun
