Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9967140CDB7
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 22:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhIOUHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 16:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhIOUHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 16:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E71936105A;
        Wed, 15 Sep 2021 20:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631736362;
        bh=8SclDOmEAsuCPQ73+HLpv4VnpVbI6YbjsONFU4p1ccA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGe9nnPPxyelBecpDHTZMZZ15laqi6E1iO0HE62/hhloDo5zwAFhKUKolzhg690lz
         etne0Wg0D+HZLoJDyp1hdVfV1gkOHIuXWIO3EaKSuMyhX2W0gC3mVlliHjzZiBC8Sl
         clH52ZplmUDI1jZTxvalqUmMqsG/CYpWJw4jbYBDJkMdzK/lFuUiN2B1z2LyloJY4c
         UuHnaxR4gZLTxeprhr6VoFBmnuH/Mxq63nBQZwzWR6CsBsZ75Tycvzp6vo/G1Bp0A5
         R1l8C5YlPGt/YUNVfrI5FOYzeQOdogPDNNUiYNvMn57LC96kBQoGVJqML1mnUpn6G+
         HYMPUdlDeU98w==
Date:   Wed, 15 Sep 2021 13:06:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Subject: Re: [PATCH] net/tls: support SM4 GCM/CCM algorithm
Message-ID: <20210915130600.66ce8b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210915111242.32413-1-tianjia.zhang@linux.alibaba.com>
References: <20210915111242.32413-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Sep 2021 19:12:42 +0800 Tianjia Zhang wrote:
> +		memcpy(sm4_gcm_info->iv,
> +		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
> +		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
> +		memcpy(sm4_gcm_info->rec_seq, cctx->rec_seq,
> +		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
> +		release_sock(sk);
> +		if (copy_to_user(optval, sm4_gcm_info, sizeof(*sm4_gcm_info)))
> +			rc = -EFAULT;
> +		break;
> +	}
> +	case TLS_CIPHER_SM4_CCM: {
> +		struct tls12_crypto_info_sm4_ccm *sm4_ccm_info =
> +			container_of(crypto_info,
> +				struct tls12_crypto_info_sm4_ccm, info);
> +
> +		if (len != sizeof(*sm4_ccm_info)) {
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +		lock_sock(sk);
> +		memcpy(sm4_ccm_info->iv,
> +		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
> +		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
> +		memcpy(sm4_ccm_info->rec_seq, cctx->rec_seq,
> +		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);

Doesn't matter from the functional perspective but perhaps use the SM4
defines rather than the AES ones, since they exist, anyway?

With that fixed feel free to add my ack.
