Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C8C3AC7F9
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhFRJtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:49:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:21270 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhFRJtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 05:49:51 -0400
IronPort-SDR: ermsy+8dmuKh+Jmbxh8A9R0kHNThhZf+9Vr8ptQJcyfTujx6AvJspIfUu1taP7k1ApO4S/IbUh
 UTtAxONPvxmA==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="203504333"
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="203504333"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 02:47:42 -0700
IronPort-SDR: wDpi506e2+6bBIzg+IqFUWlKeNjb6pkMACbup5ULUb/Gfa1QA4njDeGcXUhReThghW666231ix
 Lje+T26pE2wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="554687643"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2021 02:47:41 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id CD492580689;
        Fri, 18 Jun 2021 02:47:38 -0700 (PDT)
Date:   Fri, 18 Jun 2021 17:47:35 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Song Yoong Siang <Yoong.Siang.Song@intel.com>
Subject: Re: [PATCH bpf-next v3 15/16] stmmac: remove rcu_read_lock() around
 XDP program invocation
Message-ID: <20210618094735.GA20711@linux.intel.com>
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-16-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210617212748.32456-16-toke@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 11:27:47PM +0200, Toke Høiland-Jørgensen wrote:
> The stmmac driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
> program invocations. However, the actual lifetime of the objects referred
> by the XDP program invocation is longer, all the way through to the call to
> xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
> turns out to be harmless because it all happens in a single NAPI poll
> cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
> misleading.
> 
> Rather than extend the scope of the rcu_read_lock(), just get rid of it
> entirely. With the addition of RCU annotations to the XDP_REDIRECT map
> types that take bh execution into account, lockdep even understands this to
> be safe, so there's really no reason to keep it around.
> 
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Acked-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Tested-by: Song, Yoong Siang <yoong.siang.song@intel.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
