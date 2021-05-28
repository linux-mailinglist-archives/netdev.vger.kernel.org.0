Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8D0394338
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhE1NJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 09:09:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33604 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbhE1NJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 09:09:20 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2982D218B3;
        Fri, 28 May 2021 13:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622207265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ERRtxFJvp5L1bfUoMh6rT6SEqUZr++CR0IsW9hus3JQ=;
        b=ko9X3K9IjL4c/gboFx0SUj0+HIFiamVCOv8SIj9fKUbsQ4WrZw/232H4VH8kZ95iAf4fRi
        PQ2OVUbxDw8Sw/pLFUPOQxMVQnRg3NOkqTinxuuTqDhYEuGKeK1o6/BszuTO6C/GjfnFXX
        a6r+M9lVVFqAV1+XqbkwMupQ2hrFiG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622207265;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ERRtxFJvp5L1bfUoMh6rT6SEqUZr++CR0IsW9hus3JQ=;
        b=cbai/uYTpRu5BtW9Q6vXuMQWzwqN0LkKnrC9K3wNq09s42g57Tn3z/FJBVqNZr3Hrs5LYl
        +MLDxUdVaV1LloAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id EB65511A98;
        Fri, 28 May 2021 13:07:44 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id YnjFOCDrsGDoPQAALh3uQQ
        (envelope-from <hare@suse.de>); Fri, 28 May 2021 13:07:44 +0000
Subject: Re: [RFC PATCH v6 24/27] qedn: Add support of NVME ICReq & ICResp
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-25-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <3718cc2f-2d4b-97bf-bead-99021f138acf@suse.de>
Date:   Fri, 28 May 2021 15:07:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-25-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> 
> Once a TCP connection established, the host sends an Initialize
> Connection Request (ICReq) PDU to the controller.
> Further Initialize Connection Response (ICResp) PDU received from
> controller is processed by host to establish a connection and
> exchange connection configuration parameters.
> 
> This patch present support of generation of ICReq and processing of
> ICResp. It also update host configuration based on exchanged parameters.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/nvme/hw/qedn/qedn.h      |  37 ++++
>  drivers/nvme/hw/qedn/qedn_conn.c | 323 ++++++++++++++++++++++++++++++-
>  drivers/nvme/hw/qedn/qedn_main.c |  14 ++
>  drivers/nvme/hw/qedn/qedn_task.c |   8 +-
>  4 files changed, 378 insertions(+), 4 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
