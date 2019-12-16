Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC71120705
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 14:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfLPNVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 08:21:35 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42922 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfLPNVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 08:21:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so7198076wro.9
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 05:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d/LHMaAxVPEbY5/XVTEijX35yHOsi0P88zlbTMxdDLo=;
        b=HJ9L2xMJC5zbsATjEZ90u9BrD58wOqaqlbhyNrRaIqYRSpBl9qC/ZO63gHO+42bu1+
         aQPH61j8ny1iTNoP6m0C0zRGuwsXnkQ2AOeyiq5K7oQ5Xg1vsSpQv4UXiez06oNkoa3F
         8G7zrDOKxBe3CTQJDO/LB/9tWVtF1wH5K+ZN5VVIEuP4tmAvO+YQb+iKPqo6/PeTv3lj
         n9bhGQb7VJadfJcsFId8GHmT73sOrfg1zPjp01b4YTCUNGr/2Ma1nAnn+kX8BpAFxXFT
         eYwV0dDwzfJY6jdedyL2OPPuxRzCPTZoZU1jyNU+2ZKn6wlchTu8H8qddNglFl8P25gZ
         qXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d/LHMaAxVPEbY5/XVTEijX35yHOsi0P88zlbTMxdDLo=;
        b=tQu7+mrjCJY84+N0q916f4fDezOTrTUii2za/TKT/yyk8xs2zzUdjznEAJrKWCecqa
         SbzCWkxl8R78L9I0LU7LVUMJXasDl1r+gf9SDkvu030kptAjPQc9ldE8RUBW5djG/L27
         gG63xHCNGJiwfiPBIoLMgK8F90DAj8Ngp5cBgJaDGtBBcmniz+trSXGTiF+8AnbvWhoA
         uZ7eEu9CwGgVhD8DvIewWtI1RsNW6OonT29SbuPssHxTYE8sv37epC2sBGbAgMGWk4JD
         W+Z9o6U/5+nPpk4H+g4JkKw8iO/a6dUSaEof7uwJBVXf1ZhVn2LYLpjQs/HVm23rqNyM
         O89w==
X-Gm-Message-State: APjAAAU2xZoxYvzc/KfG4JB60s6DZjmoTGYIVkXM0zUy6f8XsO0oDSXd
        dnIaW6CUn7bEQuNknXMic46rCA==
X-Google-Smtp-Source: APXvYqz9c0SD2h/Oa3hCkS5w+CzJ/oA2GvNbqe9iPQcISdFzrbYvldpHdkDH2E8dMieBLBWbAlm7lQ==
X-Received: by 2002:adf:edd0:: with SMTP id v16mr29965178wro.310.1576502492368;
        Mon, 16 Dec 2019 05:21:32 -0800 (PST)
Received: from apalos.home (ppp-94-66-130-5.home.otenet.gr. [94.66.130.5])
        by smtp.gmail.com with ESMTPSA id j12sm21903092wrt.55.2019.12.16.05.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 05:21:31 -0800 (PST)
Date:   Mon, 16 Dec 2019 15:21:28 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Michal Hocko <mhocko@kernel.org>
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
Message-ID: <20191216132128.GA19355@apalos.home>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191216121557.GE30281@dhcp22.suse.cz>
 <20191216123426.GA18663@apalos.home>
 <20191216130845.GF30281@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216130845.GF30281@dhcp22.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 02:08:45PM +0100, Michal Hocko wrote:
> On Mon 16-12-19 14:34:26, Ilias Apalodimas wrote:
> > Hi Michal, 
> > On Mon, Dec 16, 2019 at 01:15:57PM +0100, Michal Hocko wrote:
> > > On Thu 12-12-19 09:34:14, Yunsheng Lin wrote:
> > > > +CC Michal, Peter, Greg and Bjorn
> > > > Because there has been disscusion about where and how the NUMA_NO_NODE
> > > > should be handled before.
> > > 
> > > I do not have a full context. What is the question here?
> > 
> > When we allocate pages for the page_pool API, during the init, the driver writer
> > decides which NUMA node to use. The API can,  in some cases recycle the memory,
> > instead of freeing it and re-allocating it. If the NUMA node has changed (irq
> > affinity for example), we forbid recycling and free the memory, since recycling
> > and using memory on far NUMA nodes is more expensive (more expensive than
> > recycling, at least on the architectures we tried anyway).
> > Since this would be expensive to do it per packet, the burden falls on the 
> > driver writer for that. Drivers *have* to call page_pool_update_nid() or 
> > page_pool_nid_changed() if they want to check for that which runs once
> > per NAPI cycle.
> 
> Thanks for the clarification.
> 
> > The current code in the API though does not account for NUMA_NO_NODE. That's
> > what this is trying to fix.
> > If the page_pool params are initialized with that, we *never* recycle
> > the memory. This is happening because the API is allocating memory with 
> > 'nid = numa_mem_id()' if NUMA_NO_NODE is configured so the current if statement
> > 'page_to_nid(page) == pool->p.nid' will never trigger.
> 
> OK. There is no explicit mention of the expected behavior for
> NUMA_NO_NODE. The semantic is usually that there is no NUMA placement
> requirement and the MM code simply starts the allocate from a local node
> in that case. But the memory might come from any node so there is no
> "local node" guarantee.
> 
> So the main question is what is the expected semantic? Do people expect
> that NUMA_NO_NODE implies locality? Why don't you simply always reuse
> when there was no explicit numa requirement?
> 

Well they shouldn't. Hence my next proposal. I think we are pretty much saying
the same thing here. 
If the driver defines NUMA_NO_NODE, just blindly recycle memory.

> > The initial proposal was to check:
> > pool->p.nid == NUMA_NO_NODE && page_to_nid(page) == numa_mem_id()));
> 
> > After that the thread span out of control :)
> > My question is do we *really* have to check for 
> > page_to_nid(page) == numa_mem_id()? if the architecture is not NUMA aware
> > wouldn't pool->p.nid == NUMA_NO_NODE be enough?
> 
> If the architecture is !NUMA then numa_mem_id and page_to_nid should
> always equal and be both zero.
> 

Ditto

> -- 
> Michal Hocko
> SUSE Labs


Thanks
/Ilias
