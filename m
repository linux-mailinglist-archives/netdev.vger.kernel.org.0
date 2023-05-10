Return-Path: <netdev+bounces-1312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 752DD6FD40A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C8C0281155
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420A0373;
	Wed, 10 May 2023 03:09:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AEC634
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB822C433D2;
	Wed, 10 May 2023 03:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683688152;
	bh=1I4u03yGE+hqbz1SUcvnC+KySb8tKtiNCYLXEU2VmGs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V6RYqOjEPaTf+Ig/0MuDfizhRFYmnI89n3x8REE5Vxzh8yvymFB5ff6oQHBDxU8zZ
	 7iqZpZDoJh+otHK+5bwMTvCV1fYO2AtqXRGPoTD3OsNWKnsrsiMI5hU6LVyXOvoO1H
	 yESX/RecsMg4WZdNlxYDfbuvP2SqsW1rxYbZERaFCpc2TdgJQLYs0YZTa/z5xz55Lm
	 d6WQibPSgh7d+lcY6XTnuoVT5Bmvs2y3L+8lxXcE3oSRvRXCLbcoBzYrjInNloSlBc
	 Q3FzYtTdkxt8/a+QEfv5vDhbIt2x/Za/vHoVJ0BHT/iZFsb9GC3Jfl1p/ajFdCavyx
	 7ec7MEagWArjA==
Date: Tue, 9 May 2023 20:09:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Jan Sokolowski <jan.sokolowski@intel.com>,
 maciej.fijalkowski@intel.com, daniel@iogearbox.net, Alexander Lobakin
 <aleksander.lobakin@intel.com>, Michal Schmidt <mschmidt@redhat.com>, Pucha
 Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net] ice: Fix undersized tx_flags variable
Message-ID: <20230509200910.2a149f24@kernel.org>
In-Reply-To: <20230508174225.1707403-1-anthony.l.nguyen@intel.com>
References: <20230508174225.1707403-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  8 May 2023 10:42:25 -0700 Tony Nguyen wrote:
> From: Jan Sokolowski <jan.sokolowski@intel.com>
> 
> As not all ICE_TX_FLAGS_* fit in current 16-bit limited
> tx_flags field, some VLAN-related flags would not properly apply.

nit: this is a bit of a understatement. The vlan info is gone
completely, right? Maybe say something along the lines of:

"VLAN ID was stored on upper 16 bits of tx_flags, the commit under
Fixes reduced the size of tx_flags to 16 bits discarding vlan
information completely."

> Fix that by refactoring tx_flags variable into flags only and
> a separate variable that holds VLAN ID.

This sentence just describes what the patch does, it's not necessary.

> As there is some space left,
> type variable can fit between those two. Pahole reports no size
> change to ice_tx_buf struct.

You need to also describe user-visible misbehavior.

> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> index fff0efe28373..76a34d435025 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -127,10 +127,9 @@ static inline int ice_skb_pad(void)
>  #define ICE_TX_FLAGS_IPV6	BIT(6)
>  #define ICE_TX_FLAGS_TUNNEL	BIT(7)
>  #define ICE_TX_FLAGS_HW_OUTER_SINGLE_VLAN	BIT(8)
> -#define ICE_TX_FLAGS_VLAN_M	0xffff0000
> -#define ICE_TX_FLAGS_VLAN_PR_M	0xe0000000
> -#define ICE_TX_FLAGS_VLAN_PR_S	29
> -#define ICE_TX_FLAGS_VLAN_S	16
> +
> +#define ICE_TX_VLAN_PR_M	0xe000
> +#define ICE_TX_VLAN_PR_S	13

You can use VLAN_PRIO_MASK and VLAN_PRIO_SHIFT if you're storing
it in a normal-ish 16b field.
-- 
pw-bot: cr

