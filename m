Return-Path: <netdev+bounces-4014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C756070A1C6
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08A2B281BFD
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0574E17FEE;
	Fri, 19 May 2023 21:32:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B110A12B9E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 21:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D660DC433D2;
	Fri, 19 May 2023 21:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684531920;
	bh=dDL7OJR/CI9TQ043kEA6VLH5kjIxZS2w0jIfkHXI37g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RiGAPC6g/n9slrZ4sB7JbewNC2i584Edw6KfcoN4xd/PUuh0eip0sJRWnaRxn7kyP
	 87Q67063vSCV+TwykT8/gq8trEXYtkeDbRgrWeJfjUsjilzV3GdbTX5y6VQYhePaG9
	 TvMRsjC8lA4JVNeUsUy4Ehqc1aap79imoH9cmMqNZeD+6F2UWw1b/PTcqt4DjYmI1b
	 TFoy5l0VSU35EOzPuJuESnF/C3X//+Tbjt4P5QqDC7PBytLlL2Am1L1OE7NvjjqSIa
	 t6FMA49At4NWac8ok9bDtq4i8uviT49HA+JE55o8Q/0QU5357j03s2OUYnuUQh2saW
	 nVZwfLV/0l+VA==
Date: Fri, 19 May 2023 14:31:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 jiri@resnulli.us, j.vosburgh@gmail.com, andy@greyhouse.net,
 netdev@vger.kernel.org, jarod@redhat.com, razor@blackwall.org,
 simon.horman@corigine.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] net: fix stack overflow when LRO is disabled for
 virtual interfaces
Message-ID: <20230519143158.2de37be3@kernel.org>
In-Reply-To: <2ea192a8-b437-86e4-59b3-b4d57117aee1@gmail.com>
References: <20230517143010.3596250-1-ap420073@gmail.com>
	<20230517091511.30cc0803@kernel.org>
	<6701e21c-a430-6309-bc13-dcff529d8ab5@gmail.com>
	<20230517114552.08c38d4c@kernel.org>
	<2ea192a8-b437-86e4-59b3-b4d57117aee1@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 15:25:12 +0900 Taehee Yoo wrote:
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6b12d8a9d463..f051c293ffaa 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9758,6 +9758,9 @@ int __netdev_update_features(struct net_device *dev)
>                  return -1;
>          }
> 
> +       if (netif_is_bond_master(dev) || netif_is_team_master(dev))
> +               dev->features = features;
> +
>          /* some features must be disabled on lower devices when disabled
>           * on an upper device (think: bonding master or bridge)
>           */
> 
> It fixes the stack overflow problem, but I'm not sure whether updating 
> it before netdev_sync_lower_features() is safe or not.

Indeed, I don't think we can do this, udp_tunnel_drop_rx_info()
will get confused for example. Let me just apply the patch as is..

