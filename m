Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E343942B8
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhE1MnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:43:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33326 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbhE1MnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:19 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D2CFC218B0;
        Fri, 28 May 2021 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622205703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psICT56KcHw2VZjNUFvNu+cUaaBZPwU0GchRi03lC/k=;
        b=ByQlowES0N0uVLrXiOthXGwdqBaVNdRRH3olzbCYKb3puJ1lwx4drdLARCgWg7F9UlE0gC
        iHbDR8HZChiifKW8fzM+3i/pJ3sc+dn6xAfs4EhVgHTn0l+fWY+kDm5k6BvH8d45jHHAxl
        HSR3QUCIKlUDmjHcdNmAKHZVpUht1IU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622205703;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psICT56KcHw2VZjNUFvNu+cUaaBZPwU0GchRi03lC/k=;
        b=koRsLBSKI9oQ7xfgXP/4OoYjP7O8YmooJF2Y1fLNmZ+40O2KxverL/DLzorSM4IBDp3HFu
        mThKx+V7C+PeeFDg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A168711A98;
        Fri, 28 May 2021 12:41:43 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id SfS6JgflsGCoLwAALh3uQQ
        (envelope-from <hare@suse.de>); Fri, 28 May 2021 12:41:43 +0000
Subject: Re: [RFC PATCH v6 13/27] qed: Add NVMeTCP Offload IO Level FW and HW
 HSI
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-14-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <02fd8ffa-db79-1b19-7faf-e3d2f153c510@suse.de>
Date:   Fri, 28 May 2021 14:41:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-14-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> This patch introduces the NVMeTCP Offload FW and HW  HSI in order
> to initialize the IO level configuration into a per IO HW
> resource ("task") as part of the IO path flow.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
>  include/linux/qed/nvmetcp_common.h | 335 ++++++++++++++++++++++++++++-
>  include/linux/qed/qed_nvmetcp_if.h |  31 +++
>  2 files changed, 365 insertions(+), 1 deletion(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
