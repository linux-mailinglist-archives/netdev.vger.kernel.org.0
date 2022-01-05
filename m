Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D6D484C36
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 02:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbiAEBrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 20:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbiAEBrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 20:47:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5648EC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 17:47:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6EB861615
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 01:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05C7C36AED;
        Wed,  5 Jan 2022 01:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641347254;
        bh=44oiDdb5OwZBQpc1fbhS9kmpGk6olRCv1Jpg9hACf4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mVWoMKiP1ZEoe5x/FXEGTgb27c/TxRKmyVnIlLw4Bia8eWtRkcLzW6L9d6X2CtuHi
         pRi5yXjROdSST30RaOMT8xLYJ0WU+M4twJ4sgDlpTxICMDEkjbV6ruICagX+5kziYg
         YR8q7PbokJrf4MIgeviY6el/T6jPYJTK7OA/X9pQmIzbN5Mdvur8sCgmWVZEgbe6NA
         QtItnIoP3nZpTYtW4Pme1WE81JiMMLnY+GGa6CT4Ql9BE/qWAZzEwrjW4xLWqVryNo
         0u6kCRtS0qAAqI4MDood+YlZeX7bLQ/xh4cBZLhQCl5RqQzCuuFz3ClXfbcPSPbRYr
         5fraDSUtW2gUg==
Date:   Tue, 4 Jan 2022 17:47:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v4 2/8] net/fungible: Add service module for
 Fungible drivers
Message-ID: <20220104174732.276286f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220104064657.2095041-3-dmichail@fungible.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
        <20220104064657.2095041-3-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Jan 2022 22:46:51 -0800 Dimitris Michailidis wrote:
> Fungible cards have a number of different PCI functions and thus
> different drivers, all of which use a common method to initialize and
> interact with the device. This commit adds a library module that
> collects these common mechanisms. They mainly deal with device
> initialization, setting up and destroying queues, and operating an admin
> queue. A subset of the FW interface is also included here.
> 
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>

> +/* Destroy a funq's component queues on the device. */
> +int fun_destroy_queue(struct fun_queue *funq)
> +{
> +	struct fun_dev *fdev = funq->fdev;
> +	int rc1, rc2 = 0, rc3;
> +
> +	rc1 = fun_destroy_sq(fdev, funq->sqid);
> +	if (funq->rq_depth)
> +		rc2 = fun_destroy_sq(fdev, funq->rqid);
> +	rc3 = fun_destroy_cq(fdev, funq->cqid);
> +
> +	fun_free_irq(funq);
> +
> +	if (rc1)
> +		return rc1;
> +	return rc2 ? rc2 : rc3;

What's the caller going to do with that error code?
Destroy functions are best kept void.

Actually I don't see any callers of this function at all.
Please make sure to remove all dead code.

> +}
> +
> +void fun_free_irq(struct fun_queue *funq)
> +{
> +	if (funq->irq_handler) {
> +		unsigned int vector = funq_irq(funq);
> +
> +		synchronize_irq(vector);

free_irq() will synchronize, why is this needed?

> +		free_irq(vector, funq->irq_data);
> +		funq->irq_handler = NULL;
> +		funq->irq_data = NULL;
> +	}
> +}
