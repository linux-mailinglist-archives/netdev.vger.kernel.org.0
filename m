Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F15122761
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfLQJLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:11:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38882 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLQJLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 04:11:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so2185420wmc.3;
        Tue, 17 Dec 2019 01:11:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bUxN0DbIGQAyK1eBD/kJQgdq835Qm3W2PNDPzzO+BVA=;
        b=C0H1lEU0A1o3RzNib7GPt4UMOEdFceR8gb3usAdCJwFIAcjJVu+fE1kcfkh2eCEWq4
         PoKtsBgx8HiaGw+227y50wtFe0Oomc1Bxp+8Gd93yPqkpKhQITf6WGnmuQoyvCsGPoLH
         L0e35fmfUeN74Wg36BRj+fxSjy8XIMoVv6grDmvr5uLHa6hUjONd4Xb7qdjVe+qc7QH3
         WOloQh5196T/4lsiWVhah1/Eh1YapoqdtwYhmD6Rh/bolie7k4LsXBKnI+rRMaU1AVWW
         ON5zG67ZcXY/fPyCztpphvqy3cYE4cn9VZ8UuYKOENMr7B246x8olLppvtz5aQN83j/i
         Ipfg==
X-Gm-Message-State: APjAAAU/43Jhuol8plSm+Ld5bttO3BP2OdJCD1+xpAsKqeB5uubjMIDE
        YriE81bKpqV0bnBw8kAneME=
X-Google-Smtp-Source: APXvYqzzhAkbP/5eE19KZmO3eJO64DHUtHxCKjzvw8h8+3cwIlDLw5WKoV8hETLZPptFw0bkk//9BA==
X-Received: by 2002:a05:600c:2c2:: with SMTP id 2mr4155963wmn.155.1576573892971;
        Tue, 17 Dec 2019 01:11:32 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id g17sm2171311wmc.37.2019.12.17.01.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 01:11:32 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:11:31 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
Message-ID: <20191217091131.GB31063@dhcp22.suse.cz>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191216121557.GE30281@dhcp22.suse.cz>
 <20191216123426.GA18663@apalos.home>
 <20191216130845.GF30281@dhcp22.suse.cz>
 <20191216132128.GA19355@apalos.home>
 <9041ea7f-0ca6-d0fe-9942-8907222ead5e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9041ea7f-0ca6-d0fe-9942-8907222ead5e@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 17-12-19 10:11:12, Yunsheng Lin wrote:
> On 2019/12/16 21:21, Ilias Apalodimas wrote:
> > On Mon, Dec 16, 2019 at 02:08:45PM +0100, Michal Hocko wrote:
> >> On Mon 16-12-19 14:34:26, Ilias Apalodimas wrote:
> >>> Hi Michal, 
> >>> On Mon, Dec 16, 2019 at 01:15:57PM +0100, Michal Hocko wrote:
> >>>> On Thu 12-12-19 09:34:14, Yunsheng Lin wrote:
> >>>>> +CC Michal, Peter, Greg and Bjorn
> >>>>> Because there has been disscusion about where and how the NUMA_NO_NODE
> >>>>> should be handled before.
> >>>>
> >>>> I do not have a full context. What is the question here?
> >>>
> >>> When we allocate pages for the page_pool API, during the init, the driver writer
> >>> decides which NUMA node to use. The API can,  in some cases recycle the memory,
> >>> instead of freeing it and re-allocating it. If the NUMA node has changed (irq
> >>> affinity for example), we forbid recycling and free the memory, since recycling
> >>> and using memory on far NUMA nodes is more expensive (more expensive than
> >>> recycling, at least on the architectures we tried anyway).
> >>> Since this would be expensive to do it per packet, the burden falls on the 
> >>> driver writer for that. Drivers *have* to call page_pool_update_nid() or 
> >>> page_pool_nid_changed() if they want to check for that which runs once
> >>> per NAPI cycle.
> >>
> >> Thanks for the clarification.
> >>
> >>> The current code in the API though does not account for NUMA_NO_NODE. That's
> >>> what this is trying to fix.
> >>> If the page_pool params are initialized with that, we *never* recycle
> >>> the memory. This is happening because the API is allocating memory with 
> >>> 'nid = numa_mem_id()' if NUMA_NO_NODE is configured so the current if statement
> >>> 'page_to_nid(page) == pool->p.nid' will never trigger.
> >>
> >> OK. There is no explicit mention of the expected behavior for
> >> NUMA_NO_NODE. The semantic is usually that there is no NUMA placement
> >> requirement and the MM code simply starts the allocate from a local node
> >> in that case. But the memory might come from any node so there is no
> >> "local node" guarantee.
> >>
> >> So the main question is what is the expected semantic? Do people expect
> >> that NUMA_NO_NODE implies locality? Why don't you simply always reuse
> >> when there was no explicit numa requirement?
> 
> For driver that has not supported page pool yet, NUMA_NO_NODE seems to
> imply locality, see [1].

Which is kinda awkward, no? Is there any reason for __dev_alloc_pages to
not use numa_mem_id explicitly when the local node affinity is required?
There is not real guarantee that NUMA_NO_NODE is going to imply local
node and we do not want to grow any subtle dependency on that behavior.

> And for those drivers, locality is decided by rx interrupt affinity, not
> dev_to_node(). So when rx interrupt affinity changes, the old page from old
> node will not be recycled(by checking page_to_nid(page) == numa_mem_id()),
> new pages will be allocated to replace the old pages and the new pages will
> be recycled because allocation and recycling happens in the same context,
> which means numa_mem_id() returns the same node of new page allocated, see
> [2].

Well, but my understanding is that the generic page pool implementation
has a clear means to change the affinity (namely page_pool_update_nid()).
So my primary question is, why does NUMA_NO_NODE should be use as a
bypass for that?
-- 
Michal Hocko
SUSE Labs
