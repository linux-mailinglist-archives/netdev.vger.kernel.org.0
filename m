Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FAAEB774
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfJaSnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:43:50 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35972 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbfJaSnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:43:50 -0400
Received: by mail-qt1-f196.google.com with SMTP id y10so3111270qto.3;
        Thu, 31 Oct 2019 11:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Hfo2/9DpljbvAhB9xl0YdOSI7Py9wSatQChmRyBaX2Y=;
        b=peHYAPeXlBqrPFee2+Ck4DPkyTNSAkZMt4NL2IB8D3i6SnLsaxm94Z8WT/Pkw5KEmn
         XQGCo7nu0OykrB+FvY75HEtIXp5NbHuSrunM4BeNeexfSauFgmGxUac2SHFknPFaE+i1
         vgQykTq0ATqdXnzwYyjinkYHm4bQvCo0KweOcK7sssmUK0rdQPBeFyebfxchH516hZ4h
         mkwcw3jbcwKYtyE7sSGzNcfEGhx34OqVuepXFnzOgV4AJfHsdWfDE+y8la5+R9D0wD0H
         ETxkg/gZeIaGqkAPuzTN9tqQitF72e8cRAgYe0QnO//swqQLt5dWnEceAKrcGgXsvX1i
         8Ulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Hfo2/9DpljbvAhB9xl0YdOSI7Py9wSatQChmRyBaX2Y=;
        b=he2kzJvdQ8QTWV3K8RK9G2N/YFQar6mqKEDjOamCLZbtFTvC0wVasS4nLt5Cd/FpPu
         EV/ZMJjn8kL/Vz9CWKJ+YzOFOzk8Ps+nlSF+wJ1pDDtc2NWQJnkdFC3G+OynzbILx4Rh
         1lvj6qGAYSAnvE0v+OCIsMM9v2BUuGNHcjwuQ0g1PZwflAzVbQuk/M/Gkohdpiy2KYXr
         Z9kw4eyt6sHrIs7HDfZhxL+vMTDaN/XB318RASlh+UvabzIpDd2e1MpC7P26YLRFV2xU
         xV2qjDdUWn8kPntF5bPNJaUqkbYce9IUGMWPeXmkqFoVFarbq84/CqLnUvql3UU69lVe
         4S2Q==
X-Gm-Message-State: APjAAAXfa5oYzkuwgdgoSHn3ofiv28mZYUW8UQEAeGSUUu/qFGhsZXrr
        uMP0zJWC8we71V2ww1uN+Gs=
X-Google-Smtp-Source: APXvYqySb6tIznbjqfsQ8WMDhIHY8G3NjOyExytgE1RmUg4EJoBT2Wq/6z6BRRe1QvcVE4Trsj5QDw==
X-Received: by 2002:ac8:866:: with SMTP id x35mr6771728qth.90.1572547428789;
        Thu, 31 Oct 2019 11:43:48 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::e44c])
        by smtp.gmail.com with ESMTPSA id i75sm2451492qke.22.2019.10.31.11.43.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 11:43:48 -0700 (PDT)
Date:   Thu, 31 Oct 2019 11:43:46 -0700
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
Message-ID: <20191031184346.GM3622521@devbig004.ftw2.facebook.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
 <20191024205027.GF3622521@devbig004.ftw2.facebook.com>
 <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
 <11f688a6-0288-0ec4-f925-7b8f16ec011b@gmail.com>
 <CALvZod6Sw-2Wh0KEBiMgGZ1c+2nFW0ueL_4TM4d=Z0JcbvSXrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod6Sw-2Wh0KEBiMgGZ1c+2nFW0ueL_4TM4d=Z0JcbvSXrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Oct 31, 2019 at 11:30:57AM -0700, Shakeel Butt wrote:
> Basically what I wanted to say that MM treats PF_MEMALLOC as the
> reclaim context while __GFP_MEMALLOC just tells to give access to the
> reserves. As gfpflags_allow_blocking() can be used beyond net
> subsystem, my only concern is its potential usage under PF_MEMALLOC
> context but without __GFP_MEMALLOC.

Yeah, PF_MEMALLOC is likely the better condition to check here as we
primarily want to know whether %current might be recursing and that
should be indicated reliably with PF_MEMALLOC.  Wanna prep a patch for
it?

Thanks.

-- 
tejun
