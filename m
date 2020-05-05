Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2874B1C5065
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgEEIdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:33:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50748 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727784AbgEEIdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588667624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EDl2xSBu90NOC3GloHnCYuVKjBJW46RKbcO5wJkv4Sk=;
        b=NUMVuEfWPSSrApOOG1/N+m/kShi8n/g9vSzdFx1Ihs2FosP9MS2eBg8i5oOv87D5m2nf9R
        Vzwzy2A0mKETkpzrD0FJLdoyBPbSZauDuIKRiEbt7pvDMNlcxbrummD9T2o9O/NH3Mq8Xq
        0Ldz3ut2osg9vGsj3DY6jO2/npvEXRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-_2xvOWEuM060uXxyTzrBXQ-1; Tue, 05 May 2020 04:33:41 -0400
X-MC-Unique: _2xvOWEuM060uXxyTzrBXQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B39E100A8E9;
        Tue,  5 May 2020 08:33:40 +0000 (UTC)
Received: from carbon (unknown [10.40.208.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28B66627D9;
        Tue,  5 May 2020 08:33:35 +0000 (UTC)
Date:   Tue, 5 May 2020 10:33:33 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v7 1/2] xen networking: add basic XDP support
 for xen-netfront
Message-ID: <20200505103320.11d24a14@carbon>
In-Reply-To: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org>
References: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 May 2020 11:37:53 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> +static int xennet_create_page_pool(struct netfront_queue *queue)
> +{
> +	int err;
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.flags = 0,
> +		.pool_size = NET_RX_RING_SIZE,
> +		.nid = NUMA_NO_NODE,
> +		.dev = &queue->info->netdev->dev,
> +		.offset = XDP_PACKET_HEADROOM,
> +		.max_len = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
> +	};
> +
> +	queue->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(queue->page_pool)) {
> +		 err = PTR_ERR(queue->page_pool);
> +		 queue->page_pool = NULL;
> +		 return err;
> +	}
> +
> +	err = xdp_rxq_info_reg(&queue->xdp_rxq, queue->info->netdev,
> +			       queue->id);
> +	if (err) {
> +		netdev_err(queue->info->netdev, "xdp_rxq_info_reg failed\n");
> +		goto err_free_pp;
> +	}
> +
> +	err = xdp_rxq_info_reg_mem_model(&queue->xdp_rxq,
> +					 MEM_TYPE_PAGE_ORDER0, NULL);

What!?! - You are creating a page_pool, but registering a MEM_TYPE_PAGE_ORDER0.

Have you even tested this?  The page_pool in-flight accounting will be
completely off.  This should show up when removing the page_pool again.

For driver developers do diagnose and catch stuff like this, we have
some bpftrace scripts that can help troubleshoot, here[1]:

[1] https://github.com/xdp-project/xdp-project/tree/master/areas/mem/bpftrace

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

