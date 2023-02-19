Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C9E69BF5B
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjBSJRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjBSJRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:17:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3E311678;
        Sun, 19 Feb 2023 01:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 596ABCE0A14;
        Sun, 19 Feb 2023 09:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDC1C433EF;
        Sun, 19 Feb 2023 09:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676798257;
        bh=rfRG5g/Sadjlwo58DArmJUotiB6NB1Hm+td2sa4ZSuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pRpw0wdIbNXRbj/mSO3Wc9t8nVjaDC4siaHpq4DUJA0wx70iimlMIeCbmkWAfuaVG
         SJtiS6RPWZz4fhhWKRjhizyWc7QRMzTnO5Xb4NJEo7ISQBZgqBOsPlgori6X0mKn1i
         1jnDFUUiuQ5KDiYrt5yyJGmB3tto9nktYKXnAfh+3qp9WE7rHIkoMV5CwEXtX0hW9D
         XZ25EiRLWlY6ZYGQgxdlhCII54Ew9LmOFfjZF8KZVl+z1eCkcNxDrLsgoSe7uhtsRN
         2DhREmnpNZUa3dnaWjedWrBrhQxlNm4ju4X/bVMxs2u3/dIPSK1c6IbmZIqJYjt4WT
         fDi+j7kDdt99g==
Date:   Sun, 19 Feb 2023 11:17:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com
Subject: Re: [net-next PATCH] octeontx2-af: Add NIX Errata workaround on
 CN10K silicon
Message-ID: <Y/HpLEx3Ebh+IegK@unreal>
References: <20230217055112.1248842-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217055112.1248842-1-saikrishnag@marvell.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 11:21:12AM +0530, Sai Krishna wrote:
> From: Geetha sowjanya <gakula@marvell.com>
> 
> This patch adds workaround for below 2 HW erratas
> 
> 1. Due to improper clock gating, NIXRX may free the same
> NPA buffer multiple times.. to avoid this, always enable
> NIX RX conditional clock.
> 
> 2. NIX FIFO does not get initialized on reset, if the SMQ
> flush is triggered before the first packet is processed, it
> will lead to undefined state. The workaround to perform SMQ
> flush only if packet count is non-zero in MDQ.
> 
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/rvu.h    |  3 +++
>  .../ethernet/marvell/octeontx2/af/rvu_cn10k.c  | 18 ++++++++++++++++++
>  .../ethernet/marvell/octeontx2/af/rvu_nix.c    | 10 ++++++++++
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h    |  2 ++
>  4 files changed, 33 insertions(+)

Just curious, why aren't these erratas coded as PCI quirks?

Thanks
