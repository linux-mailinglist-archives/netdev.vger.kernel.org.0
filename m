Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361BB126537
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfLSOwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:52:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34078 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfLSOwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 09:52:09 -0500
Received: by mail-wm1-f67.google.com with SMTP id f4so7214147wmj.1;
        Thu, 19 Dec 2019 06:52:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6a2uv8yUsIcld92k0bZWXnT9m14VpNvshEjzyMppfcI=;
        b=Y5xsgeFA8cv/mLuHZ0jf+dXTL+/obYi+FPWI1V7Ln7pQ6yW0+El6MbHHMIe3PyKjDD
         V2ter9Y2Kr7hYMnwHFbg/8pLwF8Cm0164gU/5+QS5Dyyu4Rv8k6Xo9aQJO7Txve7/Qwl
         Jkp/1cMk3OvQrL80j4WQVnyIE1zXX4SEKhpb368f1r18bs99mIEZCsvviMd68Cd3Odmu
         K2C5BOF5vATwlIbz5+DwkwOQPyvjg+D80YXx/OcCs4cYlPA7a01QaWmQmjKtQM930j4g
         lY10EvCBNZY98vKlIiBGLIb9wlz4GuzjngGEsDYRICoI9xv1e5tG93oQL+cOerFqSqO6
         YDuA==
X-Gm-Message-State: APjAAAU0jEbtmsL0B2eOMP73o4QdYNbEN1ZPn0qmnX4yQvA4VidoxUQg
        saMej3DygXQ7Vf86Ax5MLEQ=
X-Google-Smtp-Source: APXvYqwxXeasoFx/Mf1e5pfruwgNAsTmVPaOVqfgHL3Pl9myImdedJoXolvtkk+EpYAhczAcGz7y4w==
X-Received: by 2002:a1c:4d18:: with SMTP id o24mr10436735wmh.35.1576767127725;
        Thu, 19 Dec 2019 06:52:07 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id c4sm6450772wml.7.2019.12.19.06.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 06:52:06 -0800 (PST)
Date:   Thu, 19 Dec 2019 15:52:06 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v4 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191219145206.GE26945@dhcp22.suse.cz>
References: <20191218084437.6db92d32@carbon>
 <157665609556.170047.13435503155369210509.stgit@firesoul>
 <20191219120925.GD26945@dhcp22.suse.cz>
 <20191219143535.6c7bc880@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219143535.6c7bc880@carbon>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 19-12-19 14:35:35, Jesper Dangaard Brouer wrote:
> On Thu, 19 Dec 2019 13:09:25 +0100
> Michal Hocko <mhocko@kernel.org> wrote:
> 
> > On Wed 18-12-19 09:01:35, Jesper Dangaard Brouer wrote:
> > [...]
> > > For the NUMA_NO_NODE case, when a NIC IRQ is moved to another NUMA
> > > node, then ptr_ring will be emptied in 65 (PP_ALLOC_CACHE_REFILL+1)
> > > chunks per allocation and allocation fall-through to the real
> > > page-allocator with the new nid derived from numa_mem_id(). We accept
> > > that transitioning the alloc cache doesn't happen immediately.  
> 
> Oh, I just realized that the drivers usually refill several RX
> packet-pages at once, this means that this is called N times, meaning
> during a NUMA change this will result in N * 65 pages returned.
> 
> 
> > Could you explain what is the expected semantic of NUMA_NO_NODE in this
> > case? Does it imply always the preferred locality? See my other email[1] to
> > this matter.
> 
> I do think we want NUMA_NO_NODE to mean preferred locality.

I obviously have no saying here because I am not really familiar with
the users of this API but I would note that if there is such an implicit
assumption then you make it impossible to use the numa agnostic page
pool allocator (aka fast reallocation). This might be not important here
but future extension would be harder (you can still hack it around aka
NUMA_REALLY_NO_NODE). My experience tells me that people are quite
creative and usually require (or worse assume) semantics that you
thought were not useful.

That being said, if the NUMA_NO_NODE really should have a special
locality meaning then document it explicitly at least.
-- 
Michal Hocko
SUSE Labs
