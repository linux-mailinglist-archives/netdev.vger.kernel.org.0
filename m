Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D72E432955
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhJRV4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhJRV4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:56:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EFFC60E78;
        Mon, 18 Oct 2021 21:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634594044;
        bh=guCARVySqwCJZT5ZkTzkfBsy7YHlyNBrOFj19+oPouU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i9WV+sETDEhFbs0dI9M5awwTTArvYOIynxt+7hzRlTujLWZnPelzWRnDnFUC3d5zQ
         hu+tXWjWI3icrRsC9EtkoovNeeE0bjXmvfwmF65z/xxtgGa4Tt3+XvptQz97nvvdu7
         WMu++VqdCo82pPmAiCPGmsCQ6T0rQ5ishE0uHQQGilTBqndfVMtRoVwSHs0PnWcZ0R
         31PcOVqPORUkOkPOuZzYgXKrvP6YhF2QReDXC16/s66xAQa4CwtQ6/QPSAdSaVVnKx
         iEc7WMM3Z6FNJvje05/En7pJypOyxJ8XGRBZxlZLq9H5cw8m9Tc1+SOxUt56sreyqN
         QFkrtJ7FnNSHg==
Date:   Mon, 18 Oct 2021 14:54:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] nfp: bpf: Fix bitwise vs. logical OR warning
Message-ID: <20211018145403.5eb2807d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211018193101.2340261-1-nathan@kernel.org>
References: <20211018193101.2340261-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 12:31:01 -0700 Nathan Chancellor wrote:
> A new warning in clang points out two places in this driver where
> boolean expressions are being used with a bitwise OR instead of a
> logical one:
> 
> drivers/net/ethernet/netronome/nfp/nfp_asm.c:199:20: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>         reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
>                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                              ||
> drivers/net/ethernet/netronome/nfp/nfp_asm.c:199:20: note: cast one or both operands to int to silence this warning
> drivers/net/ethernet/netronome/nfp/nfp_asm.c:280:20: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>         reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
>                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                              ||
> drivers/net/ethernet/netronome/nfp/nfp_asm.c:280:20: note: cast one or both operands to int to silence this warning
> 2 errors generated.
> 
> The motivation for the warning is that logical operations short circuit
> while bitwise operations do not. In this case, it does not seem like
> short circuiting is harmful so implement the suggested fix of changing
> to a logical operation to fix the warning.

Warning seems generally useful, although in this case it is a little
out of place (swreg_lmextn() is a field extractor after all).

Applied to net, but without the Fixes tag, thanks!
