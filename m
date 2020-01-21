Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE93144125
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgAUQAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:00:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729274AbgAUQAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 11:00:31 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C54F2217F4;
        Tue, 21 Jan 2020 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579622430;
        bh=KmRr1BmiJ18A3rOOV2pfCrBDpSWuANxZsj8qZqxbuoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dGFyfkFmZ6pOqdD+WkouiJUm0XRYGoMDJ/O447c6LCCFhV1yVXtdF5QCcwJbHZYV+
         uZlj7vW2B1JzrpCzZgF0nrsjA4DIY/2uoHkN4OLSXKBDG3DApyzvZAEo5Q2olkZPQk
         BT58OLW5s0zQ92HN9aY0KQJAZbRozjFfkJVrf8xQ=
Date:   Tue, 21 Jan 2020 08:00:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Subject: Re: [PATCH v4 02/17] octeontx2-pf: Mailbox communication with AF
Message-ID: <20200121080029.42b6ea7d@cakuba>
In-Reply-To: <1579612911-24497-3-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-3-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 18:51:36 +0530, sunil.kovvuri@gmail.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> In the resource virtualization unit (RVU) each of the PF and AF
> (admin function) share a 64KB of reserved memory region for
> communication. This patch initializes PF <=> AF mailbox IRQs,
> registers handlers for processing these communication messages.
> Also adds support to process these messages in both directions
> ie responses to PF initiated DOWN (PF => AF) messages and AF
> initiated UP messages (AF => PF).
> 
> Mbox communication APIs and message formats are defined in AF driver
> (drivers/net/ethernet/marvell/octeontx2/af), mbox.h from AF driver is
> included here to avoid duplication.
> 
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

> +struct  mbox {
         ^^
> +	struct otx2_mbox	mbox;
> +	struct work_struct	mbox_wrk;
> +	struct otx2_mbox	mbox_up;
> +	struct work_struct	mbox_up_wrk;
> +	struct otx2_nic		*pfvf;
> +	void			*bbuf_base; /* Bounce buffer for mbox memory */
> +	struct mutex		lock;	/* serialize mailbox access */
> +	int			num_msgs; /*mbox number of messages*/
                                           ^                       ^
> +	int			up_num_msgs;/* mbox_up number of messages*/
                                            ^                            ^
> +};
>  
>  struct otx2_hw {
>  	struct pci_dev		*pdev;
>  	u16                     rx_queues;
>  	u16                     tx_queues;
>  	u16			max_queues;
> +
> +	/* MSI-X*/
                ^

The white space here is fairly loose 

> +	char			*irq_name;
> +	cpumask_var_t           *affinity_mask;
>  };
>  

> +static inline void otx2_sync_mbox_bbuf(struct otx2_mbox *mbox, int devid)
> +{
> +	u16 msgs_offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
> +	void *hw_mbase = mbox->hwbase + (devid * MBOX_SIZE);
> +	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
> +	struct mbox_hdr *hdr;
> +	u64 msg_size;
> +
> +	if (mdev->mbase == hw_mbase)
> +		return;
> +
> +	hdr = hw_mbase + mbox->rx_start;
> +	msg_size = hdr->msg_size;
> +
> +	if (msg_size > mbox->rx_size - msgs_offset)
> +		msg_size = mbox->rx_size - msgs_offset;
> +
> +	/* Copy mbox messages from mbox memory to bounce buffer */
> +	memcpy(mdev->mbase + mbox->rx_start,
> +	       hw_mbase + mbox->rx_start, msg_size + msgs_offset);

I'm slightly concerned about the use of non-iomem helpers like memset
and memcpy on what I understand to be IOMEM, and the lack of memory
barriers. But then again, I don't know much about iomem_wc(), is this
code definitely correct from memory ordering perspective?
(The memory barrier in otx2_mbox_msg_send() should probably be just
wmb(), syncing with HW is unrelated with SMP.)
