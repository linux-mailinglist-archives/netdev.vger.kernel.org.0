Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78813923C2
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhE0A3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232903AbhE0A3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E09F613AC;
        Thu, 27 May 2021 00:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622075289;
        bh=PduCCVn5AFW0KcmT1yUIe3lj/Pe67Kz7lMRrSWku/qM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GQofW0ZhYHm4dy6gKnCwe4987GCIaIjmTWyM9Z8QdiuNYER6hVE7PurH8GIiJ9Gns
         jS8bj53K5XnPz/eBDcRxKWSomCVx6ZOiwyqyJC+v0R1qznyoQc9G+wfE5t8BNYQmRj
         8PnKX9qvF5s8EZSXTVUvtC/X6CcClahI5BHxrFwqEzLHQcseehBOftpEcpUMFVrrCE
         sQQZtF3fdnfPweU0I4aCRFGHKBn+fPCFYbb+VIjqGTBUdibGwMrIswCYBpgtOF37FU
         GusWQZ/Ff5Bz61yAAK4mEQ/s94K9DblzSi2YqsUVHX7MRyjX8e773irbebwagYAdMM
         +BW/bb3U1LbGA==
Date:   Wed, 26 May 2021 17:28:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <mst@redhat.com>,
        <jasowang@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <dingxiaoxiong@huawei.com>
Subject: Re: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
Message-ID: <20210526172808.485ff268@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
References: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 19:39:51 +0800 wangyunjian wrote:
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		if (virtqueue_is_broken(vi->rq[i].vq) || virtqueue_is_broken(vi->sq[i].vq)) {
> +			netif_carrier_off(netdev);
> +			netif_tx_stop_all_queues(netdev);
> +			vi->broken = true;

Can't comment on the virtio specifics but the lack of locking between
this and the code in virtnet_config_changed_work() seems surprising.
