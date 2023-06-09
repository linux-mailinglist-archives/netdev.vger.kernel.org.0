Return-Path: <netdev+bounces-9631-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D42472A104
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC6E228194C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF6F1C76B;
	Fri,  9 Jun 2023 17:13:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC37171B4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA13C43443;
	Fri,  9 Jun 2023 17:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686330783;
	bh=QorKWSlUmR8VyfEQ12IGaZAZpaAnU+6xibyZrAzdmw8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=G/5uGXkLsR/0UUtACvbRyTHsCR3ib2vWon/j1uWF+myWZR+feZbfKXVJ38Jox51JR
	 rrtHokVF5qc59QtN9pm2Aid0mvukRBZvvJRPZnMbg2LXs3W7FKPZb9DOddPRChq+04
	 7JL179HQwrruYVCt5r+Vpovt+Sdk0LBPzRVwZ+XI4OxhpxXiK+RMYVBB6czMEHwqkY
	 9nvDxyvxeseP5A1dCBkDhN/eYc+RpV6LMY9wlppJzF1oM6crzwjxPq6bMGEFktgFeN
	 bzKdtfoMXdzWE3wfQVZbFK6g8hrEo/W1k4le2ij7WEnQVWWKb8u3T1oth+LITk7sME
	 fXE6BWmEgd5wA==
Date: Fri, 9 Jun 2023 10:13:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ding Hui <dinghui@sangfor.com.cn>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Andrew Lunn
 <andrew@lunn.ch>, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
Message-ID: <20230609101301.39fcb12b@kernel.org>
In-Reply-To: <9c1fecc1-7d17-c039-6bfa-c63be6fcf013@sangfor.com.cn>
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
	<135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
	<eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
	<6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
	<f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn>
	<6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
	<CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com>
	<ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch>
	<CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
	<44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn>
	<20230602225519.66c2c987@kernel.org>
	<5f0f2bab-ae36-8b13-2c6d-c69c6ff4a43f@sangfor.com.cn>
	<20230604104718.4bf45faf@kernel.org>
	<f6ad6281-df30-93cf-d057-5841b8c1e2e6@sangfor.com.cn>
	<20230605113915.4258af7f@kernel.org>
	<034f5393-e519-1e8d-af76-ae29677a1bf5@sangfor.com.cn>
	<CAKgT0UdX7cc-LVFowFrY7mSZMvN0xc+w+oH16GNrduLY-AddSA@mail.gmail.com>
	<9c1fecc1-7d17-c039-6bfa-c63be6fcf013@sangfor.com.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jun 2023 23:25:34 +0800 Ding Hui wrote:
> drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: .get_sset_count         = nfp_net_get_sset_count,
> drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: .get_sset_count         = nfp_port_get_sset_count,

Not sure if your research is accurate, NFP does not change the number
of stats. The number depends on the device and the FW loaded, but those
are constant during a lifetime of a netdevice.

