Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C44E4B08BE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbiBJIqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:46:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbiBJIq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:46:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2AE1C1;
        Thu, 10 Feb 2022 00:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0591A617F1;
        Thu, 10 Feb 2022 08:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE55C004E1;
        Thu, 10 Feb 2022 08:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644482790;
        bh=LkOh0QGvyjsjeEIF7CUQ+X1+naxIIQ20CmoHRtgLEeQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QZyLnt+6z/HTcbZMPg9TOTUJ8m0yJPXay+JxS943BVokIbhEjgX3nHkdJxNfJ+Lxg
         RDxenvRaUEyxbFjjh2J3ceCY4k+qBiB3qRq+cy9BcPvqXrAg1/SsgQ6w5RR5pPWXCQ
         TPdGvmshXgKCJtJcPtKr6/4Xtb+3UjiBovlKcZWMJ7+B0p4xxtrM7xQkN6OPS9mBYJ
         MIzvCBwF1D65RE5nJKYpE20xOgFsP2Phj5qLukrxljKy8P+1URgm9TRFgWncxlW3LQ
         LeVV3piWgbGRp6SEuE41WuZjageRYk/p8ijPvAym1fEhAa4wyWrhn81UdyrDUN2xhO
         og/2wKCzmvUZg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] brcmfmac: p2p: Replace one-element arrays with
 flexible-array members
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220204232228.GA442895@embeddedor>
References: <20220204232228.GA442895@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164448278512.15541.969673068406323256.kvalo@kernel.org>
Date:   Thu, 10 Feb 2022 08:46:26 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Patch applied to wireless-next.git, thanks.

f3c04fffe271 brcmfmac: p2p: Replace one-element arrays with flexible-array members

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220204232228.GA442895@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

