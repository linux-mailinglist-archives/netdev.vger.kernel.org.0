Return-Path: <netdev+bounces-4856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0959F70EC5B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16A601C2082D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 04:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F91F15C6;
	Wed, 24 May 2023 04:07:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0400F15B8
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87791C433D2;
	Wed, 24 May 2023 04:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684901220;
	bh=/XAedTGYqXqTdcRK1LAmkTGEbv0FADFApbjfU6HBHIQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uDPOTSDJ2YAIcKA4n9nuy7TkwiHJxNPc/Bhc8yhnf8H9oLzSdS2xereWaAkCGE7ug
	 uk7h7Ogk+1BsT4BseOHBLy+V9OepNEkWNZuy+hnyBfJqPR1jlHBzVjjRFeobQOVMyp
	 4cy4l3Sdg4H+UM3LCD4bWpLAv+wK2dZPblK1A4FsDK2AAdjgtPEe/nG+gFBioULt3k
	 sG9pVKP1p1ReDACT6dFuMjfgrzYYqBpVEMdO+f3fOpd4+76RwULzHlz/zBbvLeNAAp
	 k1+uYlbqRMr1ChL1k/T5TISLlgBFEU/T8v6lIW+6QL9parL7EZURPtg6b8On8P7ALr
	 SVP12xD2NO3kQ==
Date: Tue, 23 May 2023 21:06:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v6 1/8] net: wangxun: libwx add tx offload
 functions
Message-ID: <20230523210659.11304cce@kernel.org>
In-Reply-To: <20230523030658.17738-2-mengyuanlou@net-swift.com>
References: <20230523030658.17738-1-mengyuanlou@net-swift.com>
	<20230523030658.17738-2-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 11:06:51 +0800 Mengyuan Lou wrote:
> +	if (skb->encapsulation) {
> +		union network_header hdr;
> +
> +		switch (first->protocol) {
> +		case htons(ETH_P_IP):
> +			tun_prot = ip_hdr(skb)->protocol;
> +			if (ip_is_fragment(ip_hdr(skb)))
> +				return WX_PTYPE_PKT_IP | WX_PTYPE_TYP_IPFRAG;
> +			ptype = WX_PTYPE_TUN_IPV4;
> +			break;
> +		case htons(ETH_P_IPV6):
> +			wx_get_ipv6_proto(skb, skb_network_offset(skb), &tun_prot);
> +			if (tun_prot == NEXTHDR_FRAGMENT)
> +				return WX_PTYPE_PKT_IP | WX_PTYPE_PKT_IPV6 |
> +				       WX_PTYPE_TYP_IPFRAG;
> +			ptype = WX_PTYPE_TUN_IPV6;

Why does the HW care about fragmented packets?
AFAIU fragmented packets won't have any offloads enabled.

