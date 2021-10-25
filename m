Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A6C4395D5
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhJYMTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbhJYMTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:19:12 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8995EC061745;
        Mon, 25 Oct 2021 05:16:50 -0700 (PDT)
Received: from mail.denx.de (unknown [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: festevam@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id B29E383458;
        Mon, 25 Oct 2021 14:16:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1635164208;
        bh=/bi2Lna2q3if+ZR8iIXkezIgXIztKk7HdQozvn7cW8A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EVsSpL665IR13w58rNPUH6aO7jhthC4qeNUpwba0EGXliRXEsWCkgg0uHUwl815qu
         vr/pv9yHWpidrFqUciY3NRcJdrwVrLYMZLFdhLomYEmQFJaLFkgHc+ZS59PvhJUYm+
         +iR42X3rh2uxGTkAc/Kax+F/Vm6qO0+tb5w/a2AtKn6uYLSWgBeuhpPxQ/jjPY8oDn
         DPsNFi7bni1784DUKT5LPHxdKYEmtTI29TCrROIgLWugDrYSR66wkVLw8PL+zMGHW0
         bQkcy46BN+Taa61NF/tCljl0bU4RJG+S/jS0elJnsl2MgEp8FIEaXCOvOSqc29YNpB
         dgFPZyR64MB/w==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 Oct 2021 09:16:47 -0300
From:   Fabio Estevam <festevam@denx.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Alagu Sankar <alagusankar@silex-india.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Wen Gong <wgong@codeaurora.org>,
        Tamizh Chelvam <tamizhr@codeaurora.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        Ben Greear <greearb@candelatech.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix invalid dma_addr_t token assignment
In-Reply-To: <20211014075153.3655910-1-arnd@kernel.org>
References: <20211014075153.3655910-1-arnd@kernel.org>
Message-ID: <82b2d5d74674379c3346c00ffb352c8b@denx.de>
X-Sender: festevam@denx.de
User-Agent: Roundcube Webmail/1.3.6
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/2021 04:51, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Using a kernel pointer in place of a dma_addr_t token can
> lead to undefined behavior if that makes it into cache
> management functions. The compiler caught one such attempt
> in a cast:
> 
> drivers/net/wireless/ath/ath10k/mac.c: In function 
> 'ath10k_add_interface':
> drivers/net/wireless/ath/ath10k/mac.c:5586:47: error: cast from
> pointer to integer of different size [-Werror=pointer-to-int-cast]
>  5586 |                         arvif->beacon_paddr =
> (dma_addr_t)arvif->beacon_buf;
>       |                                               ^
> 
> Looking through how this gets used down the way, I'm fairly
> sure that beacon_paddr is never accessed again for ATH10K_DEV_TYPE_HL
> devices, and if it was accessed, that would be a bug.
> 
> Change the assignment to use a known-invalid address token
> instead, which avoids the warning and makes it easier to catch
> bugs if it does end up getting used.
> 
> Fixes: e263bdab9c0e ("ath10k: high latency fixes for beacon buffer")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Fabio Estevam <festevam@denx.de>
