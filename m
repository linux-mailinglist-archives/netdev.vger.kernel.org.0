Return-Path: <netdev+bounces-1218-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B6A6FCBA1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:48:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8356B1C20C1C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F96F9E8;
	Tue,  9 May 2023 16:48:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAF717FE0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C37CC433D2;
	Tue,  9 May 2023 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683650908;
	bh=LmjYrDWXMZE+8F8WkMaybmS9iZ4N0nimi6u9xcjFLKw=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=tt6jpfyiENoz5vf/hNM2dFYrXBE3rwqEm5YlxpWgmSbjpWgSb0HlsDwfQEGWzW/U8
	 khDffhNuS0gK3J0c4VBdGPx+SL0VHUDQGL3Hax0enSTzgyJhvA2/XcmIq67TL4OsZF
	 yVRuho1lTp0XgQDdn2b4wRBYCklmWQtMu+dsxAjkGux5E0U0S+Q4D0vLhyhUuMKyKj
	 o4NdE5m+rfNOicFPmRWj3/O945/d0l+axShBhrO7VMgwCyKmzRxg8GpdROAAvRNW4v
	 YF/aZCKw8fZ8CXR0DAH/+t7UocW91MxFFt8v+AegAhRpvoBpZi9VF999DtPpqhPQh8
	 aTzX2VBX17Ikw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: ath: work around false-positive
 stringop-overread
 warning
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230417205447.1800912-1-arnd@kernel.org>
References: <20230417205447.1800912-1-arnd@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Johannes Berg <johannes.berg@intel.com>,
 Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
 Wen Gong <quic_wgong@quicinc.com>, Baochen Qiang <quic_bqiang@quicinc.com>,
 Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
 ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 ath12k@lists.infradead.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168365090000.15706.12307969406639304142.kvalo@kernel.org>
Date: Tue,  9 May 2023 16:48:25 +0000 (UTC)

Arnd Bergmann <arnd@kernel.org> wrote:

> In a rare arm64 randconfig build, I got multiple warnings for ath11k
> and ath12k:
> 
> In function 'ath11k_peer_assoc_h_ht',
>     inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:2665:2:
> drivers/net/wireless/ath/ath11k/mac.c:1709:13: error: 'ath11k_peer_assoc_h_ht_masked' reading 10 bytes from a region of size 0 [-Werror=stringop-overread]
>  1709 |         if (ath11k_peer_assoc_h_ht_masked(ht_mcs_mask))
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This happens whenever gcc-13 fails to inline one of the functions
> that take a fixed-length array argument but gets passed a pointer.
> 
> Change these functions to all take a regular pointer argument
> instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

695df2f417d2 wifi: ath: work around false-positive stringop-overread warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230417205447.1800912-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


