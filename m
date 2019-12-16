Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9135E1205D5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfLPMec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:34:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39487 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbfLPMec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 07:34:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id b72so4471843wme.4
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 04:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LjylN+xwqpiOEYUIAODHdEfp1RhameawFOEhG12zND4=;
        b=jFRSyWF7g1/v+4v//G0uoZDanZOM2kJxBdkXAujWQvGnkoP7v3ZjK4EpK2FMC6rNQ5
         vp1ei7epaGKOmRpyWvuOUafQzaywC6xwVDScrZp9rPr6BMNDqZFgNr0RGCfvnsWvfS42
         ryHFmNhyMAR8uYYN5oopDB0Uf+ICk5Qh+YIKRfHsX5TeJP+pMXWClTWK5tatrLRV9tXX
         VmG+atszLRnaImUy8ORIT75JrIBTittbvgtwSlNcsK0vgE/zpw2ZEH/35L2Wnarh4Dmb
         vymkSlc5XqbZ6GBrvXwJklUtyioHhpaMChwE2B8WVt9ky5mjJuCgYOQZ40T75mGIUfPH
         MENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LjylN+xwqpiOEYUIAODHdEfp1RhameawFOEhG12zND4=;
        b=pqPVEYdxasHPcwgMDMeDMIX2c3pbq3W5ZnVf5JgzP+ng/DPnMrBYD/84QttMtrv6eA
         bhso6Hlk7OupSdTSaeE/TDdjV8Fx8SJiwMz8aTV1hItnHbF2qTf99Q14GB3xdIw/1Mut
         Tbp0aTzW6S8Lb/nx0gKYKX9pjQictjMtSxabKqLzjbb+oX0tRtTt0lQYRbWLG1yoJ1bI
         czYw6wwD5Der4WfgBg3lOMJPwRh23Nc01WPtk7kSj12pf+iutSc3uAvFftXaagn0qRwD
         gGNQdb1wzbOiNALKhbLJ45I7A9S5UP35D2NcTEnWk1AmWz7qvfDhePsu1phDNOb5CYVi
         zXjA==
X-Gm-Message-State: APjAAAUOYA6BkH7PQwAYJCLS7u2dhqjT6/tZSwpGgfTnuwAvFz1ouLaY
        ciRxq5hntyjlOYhlWFsVroeTgkcyxpE=
X-Google-Smtp-Source: APXvYqzIJepKT6pt/cHMDxWVpvUc6YXMm8GATaacHLho3xvEAB4sBIZqdQ0fdQu01iS0K+YFibon+g==
X-Received: by 2002:a7b:c957:: with SMTP id i23mr10195380wml.49.1576499670297;
        Mon, 16 Dec 2019 04:34:30 -0800 (PST)
Received: from apalos.home (ppp-94-66-130-5.home.otenet.gr. [94.66.130.5])
        by smtp.gmail.com with ESMTPSA id k4sm21382343wmk.26.2019.12.16.04.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 04:34:29 -0800 (PST)
Date:   Mon, 16 Dec 2019 14:34:26 +0200
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
Message-ID: <20191216123426.GA18663@apalos.home>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191216121557.GE30281@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216121557.GE30281@dhcp22.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal, 
On Mon, Dec 16, 2019 at 01:15:57PM +0100, Michal Hocko wrote:
> On Thu 12-12-19 09:34:14, Yunsheng Lin wrote:
> > +CC Michal, Peter, Greg and Bjorn
> > Because there has been disscusion about where and how the NUMA_NO_NODE
> > should be handled before.
> 
> I do not have a full context. What is the question here?

When we allocate pages for the page_pool API, during the init, the driver writer
decides which NUMA node to use. The API can,  in some cases recycle the memory,
instead of freeing it and re-allocating it. If the NUMA node has changed (irq
affinity for example), we forbid recycling and free the memory, since recycling
and using memory on far NUMA nodes is more expensive (more expensive than
recycling, at least on the architectures we tried anyway).
Since this would be expensive to do it per packet, the burden falls on the 
driver writer for that. Drivers *have* to call page_pool_update_nid() or 
page_pool_nid_changed() if they want to check for that which runs once
per NAPI cycle.

The current code in the API though does not account for NUMA_NO_NODE. That's
what this is trying to fix.
If the page_pool params are initialized with that, we *never* recycle
the memory. This is happening because the API is allocating memory with 
'nid = numa_mem_id()' if NUMA_NO_NODE is configured so the current if statement
'page_to_nid(page) == pool->p.nid' will never trigger.

The initial proposal was to check:
pool->p.nid == NUMA_NO_NODE && page_to_nid(page) == numa_mem_id()));

After that the thread span out of control :)
My question is do we *really* have to check for 
page_to_nid(page) == numa_mem_id()? if the architecture is not NUMA aware
wouldn't pool->p.nid == NUMA_NO_NODE be enough?

Thanks
/Ilias
> -- 
> Michal Hocko
> SUSE Labs
