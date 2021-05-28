Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EF53940DF
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhE1KaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:30:21 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40344 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbhE1KaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 06:30:19 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7C2A21FD2F;
        Fri, 28 May 2021 10:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622197724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LLLRnpJnwnC8lOZask4Sa9auCbouH/FcWbVFRXt2DYk=;
        b=FmYonH3hawVF0u4F4b7Mbul3DD8fU0bCXUrR8b8xd6trR/nRpMnsiNq6DM5E79SoSxM83L
        0PL3+C2WJWov6DOPoic2JX8sGO5VeO73mNH3FOmDvEjIzAQmVCt7V+esJIZ6OBAajc9KyD
        rk+Bd3+ULzglONNd6lPzK2T5E3j6Y9M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622197724;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LLLRnpJnwnC8lOZask4Sa9auCbouH/FcWbVFRXt2DYk=;
        b=cl5MuJyNjuopAISOmzWI78/p8GCtx9xLo/isHDmASKqSopCfc6ROuBratJkAeNr0de7vAa
        h6SifRoKJaNmZeAQ==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id 4682E11A98;
        Fri, 28 May 2021 10:28:44 +0000 (UTC)
Subject: Re: [RFC PATCH v6 04/27] nvme-tcp-offload: Add device scan
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-5-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <a2206752-973d-6d76-3d90-921388ac5a86@suse.de>
Date:   Fri, 28 May 2021 12:28:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-5-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> As part of create_ctrl(), it scans the registered devices and calls
> the claim_dev op on each of them, to find the first devices that matches
> the connection params. Once the correct devices is found (claim_dev
> returns true), we raise the refcnt of that device and return that device
> as the device to be used for ctrl currently being created.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>  drivers/nvme/host/tcp-offload.c | 77 +++++++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
I'm not entirely happy with the lookup mechanism; one should look at
converting it to a proper 'bus' like the mellanox driver did.
But that's something would could be done at a later stage.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
