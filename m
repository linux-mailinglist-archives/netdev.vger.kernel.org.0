Return-Path: <netdev+bounces-252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D146F665F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CF141C20FBC
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 07:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F31F4A28;
	Thu,  4 May 2023 07:57:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF11A2D
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 07:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FED7C433EF;
	Thu,  4 May 2023 07:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683187034;
	bh=BD+fImah7ymy/XPLoxovcxIHeqcAUrR7ThJMZGqhmUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VMHxVyXZq7ct+QcEYLotgmRTbNBd5yimQJFWEju0LmqS+/NJuq7PfQIXnuCnqiGTp
	 5sY39fh68shTCdPyuY90UGqnoBypLT/0OCdQsyv51DE4GdjfPD6LSDFTfcI5yDb5BM
	 OVj6y8h2zCcYPXNjHQCMd8dEZlkVBQmeOr8lYAXW0B5iZLrmPVWgjsps1DepNFoFcr
	 atcpa0nlFVIKoiiQEm06sVCvwO6xncK28bFXPWJVsEKJYkRxnyYHpN5AsxYzuKU6jb
	 wrq9VM7Ule78SRjOnSNJGraAXSjbkfTTgOveVa1Pz4vW+J/jtUb5BAGHvPImEE0Vjd
	 hAyiW2J4mZBpA==
Date: Thu, 4 May 2023 10:57:09 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Chittim, Madhu" <madhu.chittim@intel.com>
Cc: Ding Hui <dinghui@sangfor.com.cn>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, keescook@chromium.org,
	grzegorzx.szczurek@intel.com, mateusz.palczewski@intel.com,
	mitch.a.williams@intel.com, gregory.v.rose@intel.com,
	jeffrey.t.kirsher@intel.com, michal.kubiak@intel.com,
	simon.horman@corigine.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [PATCH net v4 2/2] iavf: Fix out-of-bounds when setting channels
 on remove
Message-ID: <20230504075709.GS525452@unreal>
References: <20230503031541.27855-1-dinghui@sangfor.com.cn>
 <20230503031541.27855-3-dinghui@sangfor.com.cn>
 <20230503082458.GH525452@unreal>
 <d2351c0f-0bfe-9422-f6f3-f0a0db58c729@sangfor.com.cn>
 <20230503162932.GN525452@unreal>
 <941ad3cc-22d6-3459-dfbc-36bc47a8a22a@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <941ad3cc-22d6-3459-dfbc-36bc47a8a22a@intel.com>

On Wed, May 03, 2023 at 12:22:00PM -0700, Chittim, Madhu wrote:
> 
> 
> On 5/3/2023 9:29 AM, Leon Romanovsky wrote:
> > On Wed, May 03, 2023 at 10:00:49PM +0800, Ding Hui wrote:
> > > On 2023/5/3 4:24 下午, Leon Romanovsky wrote:
> > > > On Wed, May 03, 2023 at 11:15:41AM +0800, Ding Hui wrote:
> > > 
> > > > > 
> > > > > If we detected removing is in processing, we can avoid unnecessary
> > > > > waiting and return error faster.
> > > > > 
> > > > > On the other hand in timeout handling, we should keep the original
> > > > > num_active_queues and reset num_req_queues to 0.
> > > > > 
> > > > > Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
> > > > > Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> > > > > Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> > > > > Cc: Huang Cun <huangcun@sangfor.com.cn>
> > > > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > > > > Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> > > > > ---
> > > > > v3 to v4:
> > > > >     - nothing changed
> > > > > 
> > > > > v2 to v3:
> > > > >     - fix review tag
> > > > > 
> > > > > v1 to v2:
> > > > >     - add reproduction script
> > > > > 
> > > > > ---
> > > > >    drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
> > > > >    1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> > > > > index 6f171d1d85b7..d8a3c0cfedd0 100644
> > > > > --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> > > > > +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> > > > > @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
> > > > >    	/* wait for the reset is done */
> > > > >    	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
> > > > >    		msleep(IAVF_RESET_WAIT_MS);
> > > > > +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
> > > > > +			return -EOPNOTSUPP;
> > > > 
> > > > This makes no sense without locking as change to __IAVF_IN_REMOVE_TASK
> > > > can happen any time.
> > > > 
> > > 
> > > The state doesn't need to be that precise here, it is optimized only for
> > > the fast path. During the lifecycle of the adapter, the __IAVF_IN_REMOVE_TASK
> > > state will only be set and not cleared.
> > > 
> > > If we didn't detect the "removing" state, we also can fallback to timeout
> > > handling.
> > > 
> > > So I don't think the locking is necessary here, what do the maintainers
> > > at Intel think?
> > 
> > I'm not Intel maintainer, but your change, explanation and the following
> > line from your commit message aren't really aligned.
> > 
> > [ 3510.400799] ==================================================================
> > [ 3510.400820] BUG: KASAN: slab-out-of-bounds in iavf_free_all_tx_resources+0x156/0x160 [iavf]
> > 
> > 
> 
> __IAVF_IN_REMOVE_TASK is being set only in iavf_remove() and the above
> change is ok in terms of coming out of setting channels early enough while
> remove is in progress.

It is not, __IAVF_IN_REMOVE_TASK, set bit can be changed any time during
iavf_set_channels() and if it is not, I would expect test_bit(..) placed
at the beginning of iavf_set_channels() or even earlier.

Thanks

