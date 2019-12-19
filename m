Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A082C12614B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfLSLxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:53:42 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:55873 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfLSLxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:53:42 -0500
Received: by mail-wm1-f53.google.com with SMTP id q9so5142495wmj.5;
        Thu, 19 Dec 2019 03:53:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=37gQpcAQV0uGXWF2P6lDcl72vbYLnQ1on9sxAjdCGgo=;
        b=aNAYg7aZM20rsnIN7TURKRv9DX6ydpxddfTgmAwI31VI5kYP538U9L2CEUyMTC3Zal
         w/V3zNhk8yvxwACTBKwGgbo0Q59TRvcaF/L0C0xK+Z8gxtCCE4Yj+O3KnltUy+iQ5RHB
         tyZxfkbW1xigfBBW4uy4rziNkk6YnyS/G6kKyERFwgFZFM8N0XMuGF1wN3xyY9xFBk87
         4UtB02THYgnDEKKul81zUtw6r7HLUdBXPnGKiHuxoxOyMGM4StLJBeCLyhIUoNaI2C2A
         Z3ycpXYsqmNZCG0G1KMf0qALLyfvoDAzEeUb5RpkOiY09EHjBwLdEeMjkLXqjkK07hd2
         zfjw==
X-Gm-Message-State: APjAAAW1hx2mahTaZL+0Je2RCyTAdEN7KK4pAYRT0NembDCsqiRZ7380
        5mrZuJLmRvDfYnnl88wAVRc=
X-Google-Smtp-Source: APXvYqwTLTJA64/+wydnYynZTE1/u09huIDMynf4a+WZKA6CpZpX8ZFLt9ZQDomwuOG39LFDdf/EaQ==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr9672502wml.43.1576756420927;
        Thu, 19 Dec 2019 03:53:40 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id x17sm6041804wrt.74.2019.12.19.03.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 03:53:40 -0800 (PST)
Date:   Thu, 19 Dec 2019 12:53:38 +0100
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
Message-ID: <20191219115338.GC26945@dhcp22.suse.cz>
References: <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191216121557.GE30281@dhcp22.suse.cz>
 <20191216123426.GA18663@apalos.home>
 <20191216130845.GF30281@dhcp22.suse.cz>
 <20191216132128.GA19355@apalos.home>
 <9041ea7f-0ca6-d0fe-9942-8907222ead5e@huawei.com>
 <20191217091131.GB31063@dhcp22.suse.cz>
 <ff280412-bb31-5ffb-99f0-6d49bb470855@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff280412-bb31-5ffb-99f0-6d49bb470855@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 19-12-19 10:09:33, Yunsheng Lin wrote:
[...]
> > There is not real guarantee that NUMA_NO_NODE is going to imply local
> > node and we do not want to grow any subtle dependency on that behavior.
> 
> Strictly speaking, using numa_mem_id() also does not have real guarantee
> that it will allocate local memory when local memory is used up, right?
> Because alloc_pages_node() is basically turning the node to numa_mem_id()
> when it is NUMA_NO_NODE.

yes, both allocations are allowed to fallback to other nodes unless
there is an explicit nodemask specified.

> Unless we do not allow passing NUMA_NO_NODE to alloc_pages_node(), otherwise
> I can not see difference between NUMA_NO_NODE and numa_mem_id().

The difference is in the presented intention. NUMA_NO_NODE means no node
preference. We turn it into an implicit local node preference because
this is the best assumption we can in general. If you provide numa_mem_id
then you explicitly ask for the local node preference because you know
that this is the best for your specific code. See the difference?

The NUMA_NO_NODE -> local node is a heuristic which might change
(albeit unlikely).
 
> >> And for those drivers, locality is decided by rx interrupt affinity, not
> >> dev_to_node(). So when rx interrupt affinity changes, the old page from old
> >> node will not be recycled(by checking page_to_nid(page) == numa_mem_id()),
> >> new pages will be allocated to replace the old pages and the new pages will
> >> be recycled because allocation and recycling happens in the same context,
> >> which means numa_mem_id() returns the same node of new page allocated, see
> >> [2].
> > 
> > Well, but my understanding is that the generic page pool implementation
> > has a clear means to change the affinity (namely page_pool_update_nid()).
> > So my primary question is, why does NUMA_NO_NODE should be use as a
> > bypass for that?
> 
> In that case, page_pool_update_nid() need to be called explicitly, which
> may not be the reality, because for drivers using page pool now, mlx5 seems
> to be the only one to call page_pool_update_nid(), which may lead to
> copy & paste problem when not careful enough.

The API is quite new AFAIU and I think it would be better to use it in
the intended way. Relying on implicit and undocumented behavior is just
going to bend that API in the future and it will impose an additional
burden to any future changes.
-- 
Michal Hocko
SUSE Labs
