Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183B9150F2B
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgBCSM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728923AbgBCSM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 13:12:27 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A13E20838;
        Mon,  3 Feb 2020 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580753546;
        bh=tH6dP23ZG3e+YLC5mCuex7PfxrZNkerudkAeVfo+pl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oE5qAGilLaW9mCzANqQgSJ3jBpU6l2B5z5t/ca7onBU+OrshiNGwRDwhJEEByv42z
         54+KEShdG/OzwcosnBauKyLCVxBgWufiyXvrTGj3sbX7YDuOoFUAA9BHUlLf1fiytH
         krWRFSQtXgsK36yDnRWnJE3jidGeQImbAbtUCVNU=
Date:   Mon, 3 Feb 2020 10:12:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     gregkh@linuxfoundation.org, arnd@arndb.de, smohanad@codeaurora.org,
        jhugo@codeaurora.org, kvalo@codeaurora.org,
        bjorn.andersson@linaro.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 14/16] net: qrtr: Add MHI transport layer
Message-ID: <20200203101225.43bd27bc@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200131135009.31477-15-manivannan.sadhasivam@linaro.org>
References: <20200131135009.31477-1-manivannan.sadhasivam@linaro.org>
        <20200131135009.31477-15-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 19:20:07 +0530, Manivannan Sadhasivam wrote:
> +/* From QRTR to MHI */
> +static void qcom_mhi_qrtr_ul_callback(struct mhi_device *mhi_dev,
> +				      struct mhi_result *mhi_res)
> +{
> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
> +	struct qrtr_mhi_pkt *pkt;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qdev->ul_lock, flags);
> +	pkt = list_first_entry(&qdev->ul_pkts, struct qrtr_mhi_pkt, node);
> +	list_del(&pkt->node);
> +	complete_all(&pkt->done);
> +
> +	kref_put(&pkt->refcount, qrtr_mhi_pkt_release);

Which kref_get() does this pair with?

Looks like qcom_mhi_qrtr_send() will release a reference after
completion, too.

> +	spin_unlock_irqrestore(&qdev->ul_lock, flags);
> +}
