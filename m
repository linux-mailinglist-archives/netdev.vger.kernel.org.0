Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6A41365AB
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 04:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgAJDIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 22:08:02 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:13522 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731010AbgAJDIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 22:08:02 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578625681; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=P0NQryuolWhLcxUxrB8PahMJZlJeZOWPFaqgfJz6DdE=; b=L5ObsAH/IvdQFQ1MKbArp5fOwFmzUSZMpMf9E3laECYVfk8bO5fDlUIHkdT5tuGtOw0xVfKn
 AHF2RUk5sdkokODJFISYb1uLT9atu7VQQygUojaXpaSmipvFPBMd87KMBAE0HYpWRxURbFRs
 Zr96Jx3Qg8VGh7JP3ri2pjhqQyQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e17ea91.7f0774f7a378-smtp-out-n02;
 Fri, 10 Jan 2020 03:08:01 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46670C433A2; Fri, 10 Jan 2020 03:08:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.142.6] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: clew)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A97F6C433CB;
        Fri, 10 Jan 2020 03:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A97F6C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=clew@codeaurora.org
Subject: Re: [PATCH v3 2/5] net: qrtr: Implement outgoing flow control
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20200107054713.3909260-1-bjorn.andersson@linaro.org>
 <20200107054713.3909260-3-bjorn.andersson@linaro.org>
From:   Chris Lew <clew@codeaurora.org>
Message-ID: <18c9b140-61d4-13b1-f10e-af3321dfca38@codeaurora.org>
Date:   Thu, 9 Jan 2020 19:07:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107054713.3909260-3-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Bjorn,

Some minor comments.

On 1/6/2020 9:47 PM, Bjorn Andersson wrote:
> +/**
> + * qrtr_tx_flow_failed() - flag that tx of confirm_rx flagged messages failed
> + * @node:	qrtr_node that the packet is to be send to
> + * @dest_node:	node id of the destination
> + * @dest_port:	port number of the destination
> + *
> + * Signal that the transmission of a message with confirm_rx flag failed. The
> + * flow's "pending" counter will keep incrementing towards QRTR_TX_FLOW_HIGH,
> + * at which point transmission would stall forever waiting for the resume TX
> + * message associated with the dropped confirm_rx message.
> + * Work around this by marking the flow as having a failed transmission and
> + * cause the next transmission attempt to be sent with the confirm_rx.
> + */
> +static void qrtr_tx_flow_failed(struct qrtr_node *node, int dest_node,
> +				int dest_port)
> +{
> +	unsigned long key = (u64)dest_node << 32 | dest_port;
> +	struct qrtr_tx_flow *flow;
> +
> +	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
> +	if (flow) {
> +		spin_lock_irq(&flow->resume_tx.lock);
> +		flow->tx_failed = 1;
> +		spin_unlock_irq(&flow->resume_tx.lock);
> +	}

Might be good to take qrtr_tx_lock when accessing the qrtr_tx_flow radix 
tree here.

> @@ -408,6 +570,8 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
>   	node->nid = QRTR_EP_NID_AUTO;
>   	node->ep = ep;
>   
> +	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
> +

mutex_init(&node->qrtr_tx_lock);

>   	qrtr_node_assign(node, nid);
>   
>   	mutex_lock(&qrtr_node_lock);

Thanks,

Chris

--
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
