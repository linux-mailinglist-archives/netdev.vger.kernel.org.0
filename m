Return-Path: <netdev+bounces-189-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BAF6F5C01
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 843DE1C20F65
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E9727709;
	Wed,  3 May 2023 16:29:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23F0D30C
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 16:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC06CC433D2;
	Wed,  3 May 2023 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683131376;
	bh=+Fa8lWXq+eKn54nxvLtDWjF14FF8nVDjXsR+6SPokpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ala5bqNF4QzuhsDsLBzQ1IP0XdwwIbDJ3GLns3f6uzPfhcI7QGlMw2tqwy04hpTRt
	 0oHMxsoxfOKIkGu+X4P62VCbNbGiKnb86a3Onb/lBvNbHpJjlMzk060TTdista/eVW
	 RGq0xAj4h2Gi86TTggpW7vmEqbXglXHX8Bz18ffQ9hzgIrWaKg2Ka+YUsfIgHy6RQd
	 oFIzyqUPYoo4Mbd2gW0oaMTZJaBlZJINKgaxGy5x0npQkSQRL6vIu8JBhiWvwvWTj5
	 heLSJohzf2nBNT9CbXpER2fku1XcLUmA/cFnyLs2j0Fio0ZNCOopL0DdHQglz7JyqF
	 20zuTnRxMm08g==
Date: Wed, 3 May 2023 19:29:32 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Ding Hui <dinghui@sangfor.com.cn>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
	jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
	keescook@chromium.org, grzegorzx.szczurek@intel.com,
	mateusz.palczewski@intel.com, mitch.a.williams@intel.com,
	gregory.v.rose@intel.com, jeffrey.t.kirsher@intel.com,
	michal.kubiak@intel.com, simon.horman@corigine.com,
	madhu.chittim@intel.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [PATCH net v4 2/2] iavf: Fix out-of-bounds when setting channels
 on remove
Message-ID: <20230503162932.GN525452@unreal>
References: <20230503031541.27855-1-dinghui@sangfor.com.cn>
 <20230503031541.27855-3-dinghui@sangfor.com.cn>
 <20230503082458.GH525452@unreal>
 <d2351c0f-0bfe-9422-f6f3-f0a0db58c729@sangfor.com.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2351c0f-0bfe-9422-f6f3-f0a0db58c729@sangfor.com.cn>

On Wed, May 03, 2023 at 10:00:49PM +0800, Ding Hui wrote:
> On 2023/5/3 4:24 下午, Leon Romanovsky wrote:
> > On Wed, May 03, 2023 at 11:15:41AM +0800, Ding Hui wrote:
> 
> > > 
> > > If we detected removing is in processing, we can avoid unnecessary
> > > waiting and return error faster.
> > > 
> > > On the other hand in timeout handling, we should keep the original
> > > num_active_queues and reset num_req_queues to 0.
> > > 
> > > Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
> > > Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> > > Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> > > Cc: Huang Cun <huangcun@sangfor.com.cn>
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > > Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> > > ---
> > > v3 to v4:
> > >    - nothing changed
> > > 
> > > v2 to v3:
> > >    - fix review tag
> > > 
> > > v1 to v2:
> > >    - add reproduction script
> > > 
> > > ---
> > >   drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> > > index 6f171d1d85b7..d8a3c0cfedd0 100644
> > > --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> > > +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> > > @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
> > >   	/* wait for the reset is done */
> > >   	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
> > >   		msleep(IAVF_RESET_WAIT_MS);
> > > +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
> > > +			return -EOPNOTSUPP;
> > 
> > This makes no sense without locking as change to __IAVF_IN_REMOVE_TASK
> > can happen any time.
> > 
> 
> The state doesn't need to be that precise here, it is optimized only for
> the fast path. During the lifecycle of the adapter, the __IAVF_IN_REMOVE_TASK
> state will only be set and not cleared.
> 
> If we didn't detect the "removing" state, we also can fallback to timeout
> handling.
> 
> So I don't think the locking is necessary here, what do the maintainers
> at Intel think?

I'm not Intel maintainer, but your change, explanation and the following
line from your commit message aren't really aligned.

[ 3510.400799] ==================================================================
[ 3510.400820] BUG: KASAN: slab-out-of-bounds in iavf_free_all_tx_resources+0x156/0x160 [iavf]


> 
> > Thanks
> > 
> > >   		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
> > >   			continue;
> > >   		break;
> > >   	}
> > >   	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
> > >   		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
> > > -		adapter->num_active_queues = num_req;
> > > +		adapter->num_req_queues = 0;
> > >   		return -EOPNOTSUPP;
> > >   	}
> > > -- 
> > > 2.17.1
> > > 
> > > 
> > 
> 
> -- 
> Thanks,
> -dinghui
> 
> 

