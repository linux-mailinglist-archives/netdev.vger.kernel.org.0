Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAD833AA27
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 04:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhCODw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 23:52:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhCODwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 23:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615780343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iaINR4+J/WQmMj/Rt87A6ow5gujrBEiTkrmO56nKbXg=;
        b=eWKHsEZF5zIFu0PcZrfAJNRRpjO0xCmZWdM2m8+fFOX9oUkF9DfoCnSib30Zo9Doa0Z//g
        IFEqDda5zIC4gt6nZMFsA73G7lpPekucGe1fCmrgwLXeTAJpehSHG1nkomLPwztjfeRPV9
        DyJlz0BRPKk1vHoboh/L61hSG5HB1aI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-n3qRxgpVPRGE2zuO94Et_w-1; Sun, 14 Mar 2021 23:52:19 -0400
X-MC-Unique: n3qRxgpVPRGE2zuO94Et_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 075EF19200C0;
        Mon, 15 Mar 2021 03:52:15 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-199.pek2.redhat.com [10.72.13.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 831B41F07C;
        Mon, 15 Mar 2021 03:52:02 +0000 (UTC)
Subject: Re: [net-next PATCH 07/10] virtio_net: Update driver to use
 ethtool_sprintf
To:     Alexander Duyck <alexander.duyck@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        pv-drivers@vmware.com, doshir@vmware.com, alexanderduyck@fb.com,
        Kernel-team@fb.com
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
 <161557132651.10304.9382850626606060019.stgit@localhost.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <67ac83a4-10e8-602c-84a7-78ce8cbb5483@redhat.com>
Date:   Mon, 15 Mar 2021 11:52:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <161557132651.10304.9382850626606060019.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/3/13 上午1:48, Alexander Duyck 写道:
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> Update the code to replace instances of snprintf and a pointer update with
> just calling ethtool_sprintf.
>
> Also replace the char pointer with a u8 pointer to avoid having to recast
> the pointer type.
>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>   drivers/net/virtio_net.c |   18 +++++++-----------
>   1 file changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e97288dd6e5a..77ba8e2fc11c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2138,25 +2138,21 @@ static int virtnet_set_channels(struct net_device *dev,
>   static void virtnet_get_strings(struct net_device *dev, u32 stringset, u8 *data)
>   {
>   	struct virtnet_info *vi = netdev_priv(dev);
> -	char *p = (char *)data;
>   	unsigned int i, j;
> +	u8 *p = data;
>   
>   	switch (stringset) {
>   	case ETH_SS_STATS:
>   		for (i = 0; i < vi->curr_queue_pairs; i++) {
> -			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++) {
> -				snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_%s",
> -					 i, virtnet_rq_stats_desc[j].desc);
> -				p += ETH_GSTRING_LEN;
> -			}
> +			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++)
> +				ethtool_sprintf(&p, "rx_queue_%u_%s", i,
> +						virtnet_rq_stats_desc[j].desc);
>   		}
>   
>   		for (i = 0; i < vi->curr_queue_pairs; i++) {
> -			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++) {
> -				snprintf(p, ETH_GSTRING_LEN, "tx_queue_%u_%s",
> -					 i, virtnet_sq_stats_desc[j].desc);
> -				p += ETH_GSTRING_LEN;
> -			}
> +			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++)
> +				ethtool_sprintf(&p, "tx_queue_%u_%s", i,
> +						virtnet_sq_stats_desc[j].desc);
>   		}
>   		break;
>   	}


Acked-by: Jason Wang <jasowang@redhat.com>



>
>

