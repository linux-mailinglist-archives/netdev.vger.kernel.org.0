Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8206B3942B7
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhE1Mmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:42:45 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41426 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhE1Mmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:42:42 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AA5F01FD2F;
        Fri, 28 May 2021 12:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622205666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCYs3KLtcTkBqDc35j13v5squ/iaUh751rzFGwJLIzk=;
        b=hbde3yeRGJNz3JjH6yOWWEjq8q+CbgMlQHzPxkB/Oo1huZ9B7iJSU/GbkdSH4l+pfGlbDz
        uEqmmlKeCyT9vvKtmq2fNw/D6AOhFzoOGhWGTTeW55ITP+LX7MDDJV2/jPQQJTMlWujbcS
        +huX6aRJW6lneI7v0sfX/ayrhPA0td8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622205666;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCYs3KLtcTkBqDc35j13v5squ/iaUh751rzFGwJLIzk=;
        b=i6REQ+u8iSVdfEsu/7dNwggEob/wnZor8YRXU9s0gONH9FJ4DS2sa2EP4HfyYbmD6OLfg6
        vVgOXhG6nF7i+oBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 680D111A98;
        Fri, 28 May 2021 12:41:06 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id MPA4GOLksGBXLwAALh3uQQ
        (envelope-from <hare@suse.de>); Fri, 28 May 2021 12:41:06 +0000
Subject: Re: [RFC PATCH v6 11/27] qed: Add NVMeTCP Offload Connection Level FW
 and HW HSI
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-12-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <8748f0e7-f2aa-f8bb-3756-5cbea9d5c7d5@suse.de>
Date:   Fri, 28 May 2021 14:41:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-12-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> This patch introduces the NVMeTCP HSI and HSI functionality in order to
> initialize and interact with the HW device as part of the connection level
> HSI.
> 
> This includes:
> - Connection offload: offload a TCP connection to the FW.
> - Connection update: update the ICReq-ICResp params
> - Connection clear SQ: outstanding IOs FW flush.
> - Connection termination: terminate the TCP connection and flush the FW.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c | 582 +++++++++++++++++-
>  drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h |  63 ++
>  drivers/net/ethernet/qlogic/qed/qed_sp.h      |   3 +
>  include/linux/qed/nvmetcp_common.h            | 143 +++++
>  include/linux/qed/qed_nvmetcp_if.h            |  94 +++
>  5 files changed, 883 insertions(+), 2 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
