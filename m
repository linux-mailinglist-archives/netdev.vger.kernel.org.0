Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340343942E0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhE1Mpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:45:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33350 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbhE1Mp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:45:27 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 83ED7218B0;
        Fri, 28 May 2021 12:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622205831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9149hCgfbgoOSRiZegk8lB/vSzOp0MQZkv6jiH0Plw=;
        b=ODCx2CkGHdfINdzSRdKAW5OI7cYyaUoWdu8QkEX7F7IK4J7fTbqKE5ZyDZFfbRvbEHF2jV
        4m0YUq6/bW3prYp1A2x/SdIOTtjIZfweurmJqQx1aKawMi6DdpNiXEEJqJ8pw4/0C/Hs0l
        NZQqcp/uMJj7n1EgXJa+Re9I77so714=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622205831;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9149hCgfbgoOSRiZegk8lB/vSzOp0MQZkv6jiH0Plw=;
        b=h+0kGL7+sh5bdN7sRbT8rPI2I7p55aNv8ABwbRA2+CxD8I79XopWQ1ryKtZt/cduxUSe/M
        EHyDxFuRLNWygPDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 464AF11A98;
        Fri, 28 May 2021 12:43:51 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 0PF5EIflsGCfMAAALh3uQQ
        (envelope-from <hare@suse.de>); Fri, 28 May 2021 12:43:51 +0000
Subject: Re: [RFC PATCH v6 14/27] qed: Add NVMeTCP Offload IO Level FW
 Initializations
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-15-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <7591803b-63b5-5e40-d4fe-4cc0b9ce9c10@suse.de>
Date:   Fri, 28 May 2021 14:43:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-15-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> This patch introduces the NVMeTCP FW initializations which is used
> to initialize the IO level configuration into a per IO HW
> resource ("task") as part of the IO path flow.
> 
> This includes:
> - Write IO FW initialization
> - Read IO FW initialization.
> - IC-Req and IC-Resp FW exchange.
> - FW Cleanup flow (Flush IO).
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/Makefile      |   5 +-
>  drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c |   7 +-
>  .../qlogic/qed/qed_nvmetcp_fw_funcs.c         | 379 ++++++++++++++++++
>  .../qlogic/qed/qed_nvmetcp_fw_funcs.h         |  43 ++
>  include/linux/qed/nvmetcp_common.h            |   1 +
>  include/linux/qed/qed_nvmetcp_if.h            |  20 +
>  6 files changed, 453 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c
>  create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
