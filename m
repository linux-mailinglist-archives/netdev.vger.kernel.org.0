Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39503942EB
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhE1MsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:48:21 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41480 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhE1MsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:48:19 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 92C9F1FD2E;
        Fri, 28 May 2021 12:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622206003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P97HW2+GhwiADFe/qrdemvBBlPHYcnDV6EFPfZ/sS5Q=;
        b=s+R3BccLA4IaOt7J4VxZ2to2HYZHRFTJe10VOj2spBzsIpOZiR/E/7AxV/1Q1EuC0ViaG7
        nzttAmtwyEjfjPum7cOzfpbSmLe61j88A1azJgbQcx3cHr0rLguxY1PDhkCrlJ2Zta96DA
        mUvG46zDMnoWHaLLt6prvzABgewRoWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622206003;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P97HW2+GhwiADFe/qrdemvBBlPHYcnDV6EFPfZ/sS5Q=;
        b=/z3OAtfGglDBpR3VY7fCFljKp8+cI2Us0OgZfU0OIZ9y39NP4Sn7f12GCWgsFlJHdRuc5X
        2IAPluD/YR19KoDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 60C6A11A98;
        Fri, 28 May 2021 12:46:43 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id ZAThFjPmsGBaMgAALh3uQQ
        (envelope-from <hare@suse.de>); Fri, 28 May 2021 12:46:43 +0000
Subject: Re: [RFC PATCH v6 19/27] qedn: Add IRQ and fast-path resources
 initializations
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-20-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <8f198995-3994-fbca-e8e1-0f73d28f7a34@suse.de>
Date:   Fri, 28 May 2021 14:46:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-20-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> This patch will present the adding of qedn_fp_queue - this is a per cpu
> core element which handles all of the connections on that cpu core.
> The qedn_fp_queue will handle a group of connections (NVMeoF QPs) which
> are handled on the same cpu core, and will only use the same FW-driver
> resources with no need to be related to the same NVMeoF controller.
> 
> The per qedn_fq_queue resources are the FW CQ and FW status block:
> - The FW CQ will be used for the FW to notify the driver that the
>   the exchange has ended and the FW will pass the incoming NVMeoF CQE
>   (if exist) to the driver.
> - FW status block - which is used for the FW to notify the driver with
>   the producer update of the FW CQE chain.
> 
> The FW fast-path queues are based on qed_chain.h
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/nvme/hw/qedn/qedn.h      |  25 +++
>  drivers/nvme/hw/qedn/qedn_main.c | 289 ++++++++++++++++++++++++++++++-
>  2 files changed, 311 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
