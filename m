Return-Path: <netdev+bounces-10124-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D73372C5A0
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B07D1C20A11
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF5D1992D;
	Mon, 12 Jun 2023 13:17:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1819D18B03
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18A1C4339B;
	Mon, 12 Jun 2023 13:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686575832;
	bh=2pVdc/LHwHQ3+w4Y5ikInQEjcbewKRZwPIQfkYw4p3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T/qGCSwkW3KoU/JUvMngAmEc/AHf7iyXCsFJZUe1eXjPxA/7l5Y6opSBDT7Su1v4i
	 uqVn+Ey20SMmERwzBC+ImUBIgKeic6DsH3yYqYbD8AllwZ6OEc9O7UZFKkivsWoiSI
	 /gyux/zX1wyRQQ/pMEKpe7hH/kZc4nfc1Rwx1tYYajXdbo2RdScyz2Iju21ctOXZ4r
	 xIl7qfNo8e9oEWDgBxj8lv3wsJfXJPZj8rYMigKdFeeuZ6/8YystfT/jRE9xp22zPz
	 UC7T3XiojZXQjBZWiabllsz27lRap0XpgxyDK+AFWdV6vnZhkgRfcQuCvlLYdsnm2e
	 xak2YerFI3rtw==
Date: Mon, 12 Jun 2023 16:17:07 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230612131707.GS12152@unreal>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612123718.u6cfggybbtx4owbq@skbuf>

On Mon, Jun 12, 2023 at 03:37:18PM +0300, Vladimir Oltean wrote:
> On Mon, Jun 12, 2023 at 02:59:25PM +0300, Leon Romanovsky wrote:
> > As far as I can tell, the calls to .shutdown() and .remove() are
> > mutually exclusive.
> 
> In this particular case, or in general?
> 
> In general they aren't. If the owning bus driver also implements its .shutdown()
> as .remove(), then it will call the .remove() method of all devices on that bus.
> That, after .shutdown() had already been called for those same children.

Can you please help me to see how? What is the call chain?

From what I see callback to ->shutdown() iterates over all devices in
that bus and relevant bus will check that driver is bound prior to call
to driver callback. In both cases, the driver is removed and bus won't
call to already removed device.

If it does, it is arguably bug in bus logic, which needs to prevent such
scenario.

Thanks

