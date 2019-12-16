Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCCD1206A0
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 14:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfLPNIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 08:08:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40471 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfLPNIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 08:08:49 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so6612504wmi.5;
        Mon, 16 Dec 2019 05:08:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R9aFaAcGCVcst6+88KA41zQjrKH9qVtbZfnVDJrAXeA=;
        b=fcwdeodEtXF1FVw8+hw4TY+lh7I6pV2jDU2l06kwenUTWL0zjSM7eSaNed0VM/ULR2
         lTFQV8pU6AHnYRX1qE70Rv6bgrfdzHohKrhaUvu8FNDjrpoetwYnBI+FOSii1y8/Z4K2
         COgEPQCrqCradG4Ri3rp1kPnXNHe9O+WIWzBBS98Eg7eL3PFvYrfDZ3e/O8CDysTQ6mW
         eS+tCaNfDJRtS5yCf1kfVCcPa0ybyu3HuwLlhz+6TiDApH8kOBJdZV7GOtieWVyuYLYc
         RF1BWm//rQQvi/CWFs6UNCvHqUWZS+ZgW+qR/KnFfwGkx5961LMWhr9q84Ie1YgUUHm2
         1M5w==
X-Gm-Message-State: APjAAAUjHNa0oIItvlc500fyCEuUBmZHjWCPvQ4whndD2cgk454KYnIa
        rSvTbOAiIxfPufskW18joJA=
X-Google-Smtp-Source: APXvYqy8gtSuQntZrQPzWn5lxIMk8mNr9xbOxQPZlJfg1nVxsqUCeU6NgB9SUAeVSAMe7A+IQxynug==
X-Received: by 2002:a7b:cf26:: with SMTP id m6mr28538441wmg.17.1576501727108;
        Mon, 16 Dec 2019 05:08:47 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id q3sm21924045wrn.33.2019.12.16.05.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 05:08:46 -0800 (PST)
Date:   Mon, 16 Dec 2019 14:08:45 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        peterz@infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bhelgaas@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Message-ID: <20191216130845.GF30281@dhcp22.suse.cz>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191216121557.GE30281@dhcp22.suse.cz>
 <20191216123426.GA18663@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216123426.GA18663@apalos.home>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 16-12-19 14:34:26, Ilias Apalodimas wrote:
> Hi Michal, 
> On Mon, Dec 16, 2019 at 01:15:57PM +0100, Michal Hocko wrote:
> > On Thu 12-12-19 09:34:14, Yunsheng Lin wrote:
> > > +CC Michal, Peter, Greg and Bjorn
> > > Because there has been disscusion about where and how the NUMA_NO_NODE
> > > should be handled before.
> > 
> > I do not have a full context. What is the question here?
> 
> When we allocate pages for the page_pool API, during the init, the driver writer
> decides which NUMA node to use. The API can,  in some cases recycle the memory,
> instead of freeing it and re-allocating it. If the NUMA node has changed (irq
> affinity for example), we forbid recycling and free the memory, since recycling
> and using memory on far NUMA nodes is more expensive (more expensive than
> recycling, at least on the architectures we tried anyway).
> Since this would be expensive to do it per packet, the burden falls on the 
> driver writer for that. Drivers *have* to call page_pool_update_nid() or 
> page_pool_nid_changed() if they want to check for that which runs once
> per NAPI cycle.

Thanks for the clarification.

> The current code in the API though does not account for NUMA_NO_NODE. That's
> what this is trying to fix.
> If the page_pool params are initialized with that, we *never* recycle
> the memory. This is happening because the API is allocating memory with 
> 'nid = numa_mem_id()' if NUMA_NO_NODE is configured so the current if statement
> 'page_to_nid(page) == pool->p.nid' will never trigger.

OK. There is no explicit mention of the expected behavior for
NUMA_NO_NODE. The semantic is usually that there is no NUMA placement
requirement and the MM code simply starts the allocate from a local node
in that case. But the memory might come from any node so there is no
"local node" guarantee.

So the main question is what is the expected semantic? Do people expect
that NUMA_NO_NODE implies locality? Why don't you simply always reuse
when there was no explicit numa requirement?

> The initial proposal was to check:
> pool->p.nid == NUMA_NO_NODE && page_to_nid(page) == numa_mem_id()));

> After that the thread span out of control :)
> My question is do we *really* have to check for 
> page_to_nid(page) == numa_mem_id()? if the architecture is not NUMA aware
> wouldn't pool->p.nid == NUMA_NO_NODE be enough?

If the architecture is !NUMA then numa_mem_id and page_to_nid should
always equal and be both zero.

-- 
Michal Hocko
SUSE Labs
