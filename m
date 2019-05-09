Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1496718844
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 12:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfEIKX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 06:23:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40026 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIKXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 06:23:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3995A608BA; Thu,  9 May 2019 10:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557397434;
        bh=fOCCasTFcPN4u+bCRo8X34nAQlb0SNSv6Pk9TNTsCxc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XttZHTbmnbc+l7SpnzSxuo8uiPIK1OgjYDd8jwJlym9Zf9jU8ojy69mNH/9Z1tJhD
         2pkyJCGSOG+XRDt9NoAGY+OUg2eDn1EahF+Utnpo7zWtqEKVXLL8c5GqsAZN/2wYu+
         mccsL0qUFnhTgRcgYsFj7Ei/mT6LQfb8j6+/X12M=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from [10.206.25.51] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aneela@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 987A3601D4;
        Thu,  9 May 2019 10:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557397433;
        bh=fOCCasTFcPN4u+bCRo8X34nAQlb0SNSv6Pk9TNTsCxc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lXXXfurD19F0/J7tJrNEdOgoqpm2H83bjeEx7WikRgHbOeJ/7RomUAOzzD+uWwZRX
         Afxm01Flp0rUQWplqGaRQFLhlTjEHuOoA9lT++tniGCMzmSml+wdoHjGciJKrR9MvR
         e8mV5B+gU3nHjtW06svCn+/6HMsnhEafaLcqV5rk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 987A3601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aneela@codeaurora.org
Subject: Re: [PATCH 1/5] net: qrtr: Move resume-tx transmission to recvmsg
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Lew <clew@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20190508060643.30936-1-bjorn.andersson@linaro.org>
 <20190508060643.30936-2-bjorn.andersson@linaro.org>
From:   Arun Kumar Neelakantam <aneela@codeaurora.org>
Message-ID: <07d0f972-ce8b-1938-579f-733b1547e745@codeaurora.org>
Date:   Thu, 9 May 2019 15:53:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190508060643.30936-2-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/8/2019 11:36 AM, Bjorn Andersson wrote:
> The confirm-rx bit is used to implement a per port flow control, in
> order to make sure that no messages are dropped due to resource
> exhaustion. Move the resume-tx transmission to recvmsg to only confirm
> messages as they are consumed by the application.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>   net/qrtr/qrtr.c | 60 +++++++++++++++++++++++++++----------------------
>   1 file changed, 33 insertions(+), 27 deletions(-)
>
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index dd0e97f4f6c0..07a35362fba2 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -369,22 +369,11 @@ static void qrtr_port_put(struct qrtr_sock *ipc);
>   static void qrtr_node_rx_work(struct work_struct *work)
>   {
>   	struct qrtr_node *node = container_of(work, struct qrtr_node, work);
> -	struct qrtr_ctrl_pkt *pkt;
> -	struct sockaddr_qrtr dst;
> -	struct sockaddr_qrtr src;
>   	struct sk_buff *skb;
>   
>   	while ((skb = skb_dequeue(&node->rx_queue)) != NULL) {
>   		struct qrtr_sock *ipc;
> -		struct qrtr_cb *cb;
> -		int confirm;
> -
> -		cb = (struct qrtr_cb *)skb->cb;
> -		src.sq_node = cb->src_node;
> -		src.sq_port = cb->src_port;
> -		dst.sq_node = cb->dst_node;
> -		dst.sq_port = cb->dst_port;
> -		confirm = !!cb->confirm_rx;
> +		struct qrtr_cb *cb = (struct qrtr_cb *)skb->cb;
>   
>   		qrtr_node_assign(node, cb->src_node);
>   
> @@ -397,20 +386,6 @@ static void qrtr_node_rx_work(struct work_struct *work)
>   
>   			qrtr_port_put(ipc);
>   		}
> -
> -		if (confirm) {
> -			skb = qrtr_alloc_ctrl_packet(&pkt);
> -			if (!skb)
> -				break;
> -
> -			pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
> -			pkt->client.node = cpu_to_le32(dst.sq_node);
> -			pkt->client.port = cpu_to_le32(dst.sq_port);
> -
> -			if (qrtr_node_enqueue(node, skb, QRTR_TYPE_RESUME_TX,
> -					      &dst, &src))
> -				break;
> -		}
>   	}
>   }
>   
> @@ -822,6 +797,34 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>   	return rc;
>   }
>   
> +static int qrtr_resume_tx(struct qrtr_cb *cb)
This function name is adding some confusion with qrtr_tx_resume() in 
next patch. can you please rename this function to qrtr_send_resume_tx().
> +{
> +	struct sockaddr_qrtr remote = { AF_QIPCRTR, cb->src_node, cb->src_port };
> +	struct sockaddr_qrtr local = { AF_QIPCRTR, cb->dst_node, cb->dst_port };
> +	struct qrtr_ctrl_pkt *pkt;
> +	struct qrtr_node *node;
> +	struct sk_buff *skb;
> +	int ret;
> +
> +	node = qrtr_node_lookup(remote.sq_node);
> +	if (!node)
> +		return -EINVAL;
> +
> +	skb = qrtr_alloc_ctrl_packet(&pkt);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
> +	pkt->client.node = cpu_to_le32(cb->dst_node);
> +	pkt->client.port = cpu_to_le32(cb->dst_port);
> +
> +	ret = qrtr_node_enqueue(node, skb, QRTR_TYPE_RESUME_TX, &local, &remote);
> +
> +	qrtr_node_release(node);
> +
> +	return ret;
> +}
> +
>   static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
>   			size_t size, int flags)
>   {
> @@ -844,6 +847,7 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
>   		release_sock(sk);
>   		return rc;
>   	}
> +	cb = (struct qrtr_cb *)skb->cb;
>   
>   	copied = skb->len;
>   	if (copied > size) {
> @@ -857,7 +861,6 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
>   	rc = copied;
>   
>   	if (addr) {
> -		cb = (struct qrtr_cb *)skb->cb;
>   		addr->sq_family = AF_QIPCRTR;
>   		addr->sq_node = cb->src_node;
>   		addr->sq_port = cb->src_port;
> @@ -865,6 +868,9 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
>   	}
>   
>   out:
> +	if (cb->confirm_rx)
> +		qrtr_resume_tx(cb);
> +
>   	skb_free_datagram(sk, skb);
>   	release_sock(sk);
>   
