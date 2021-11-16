Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79402452B4F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhKPHKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:10:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230011AbhKPHKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 02:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637046442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C811XINw0azGSYZr4e9uGjtRSsNVX1ggzR+WyjDIEls=;
        b=OveeVYdSfXDTaSds1FndS5xKd7jo030RMLUybgfWLwU4Q73xlLtAQhP/KCyobBNo2/yijE
        3JUzpLhxypW8hoMzCdo8/ZpM4xO0qx8qMtnMpWJ4EVP+M1+7FlAQcYt+4u1xL545FPOnn/
        6FnPH/qgBpbaa3hqVpB/KcuVHifFI8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-tAhl6f8SPT6BnKSsQJwUXw-1; Tue, 16 Nov 2021 02:07:18 -0500
X-MC-Unique: tAhl6f8SPT6BnKSsQJwUXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6754180197B;
        Tue, 16 Nov 2021 07:07:16 +0000 (UTC)
Received: from p1 (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 825FB5D6D5;
        Tue, 16 Nov 2021 07:07:14 +0000 (UTC)
Date:   Tue, 16 Nov 2021 08:07:12 +0100
From:   Stefan Assmann <sassmann@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 01/10] iavf: Fix return of set the new channel count
Message-ID: <20211116070712.nijmfavryimbpzdn@p1>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
 <20211115235934.880882-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115235934.880882-2-anthony.l.nguyen@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-15 15:59, Tony Nguyen wrote:
> From: Mateusz Palczewski <mateusz.palczewski@intel.com>
> 
> Fixed return correct code from set the new channel count.
> Implemented by check if reset is done in appropriate time.
> This solution give a extra time to pf for reset vf in case
> when user want set new channel count for all vfs.
> Without this patch it is possible to return misleading output
> code to user and vf reset not to be correctly performed by pf.
> 
> Fixes: 5520deb15326 ("iavf: Enable support for up to 16 queues")
> Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> index 5a359a0a20ec..136c801f5584 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> @@ -1776,6 +1776,7 @@ static int iavf_set_channels(struct net_device *netdev,
>  {
>  	struct iavf_adapter *adapter = netdev_priv(netdev);
>  	u32 num_req = ch->combined_count;
> +	int i;
>  
>  	if ((adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ) &&
>  	    adapter->num_tc) {
> @@ -1798,6 +1799,20 @@ static int iavf_set_channels(struct net_device *netdev,
>  	adapter->num_req_queues = num_req;
>  	adapter->flags |= IAVF_FLAG_REINIT_ITR_NEEDED;
>  	iavf_schedule_reset(adapter);
> +
> +	/* wait for the reset is done */
> +	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
> +		msleep(IAVF_RESET_WAIT_MS);
> +		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
> +			continue;
> +		break;
> +	}
> +	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
> +		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
> +		adapter->num_active_queues = num_req;

Hi Mateusz,

I'm not sure I understand why you touch flags and num_active_queues here
even though the reset is still in progress? Shouldn't we just bail out
and report the error?

> +		return -EOPNOTSUPP;

Is this really the correct thing to report? Setting the queue count is
supported, the device is just busy, so isn't EAGAIN a better way to
express this?

  Stefan

> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.31.1
> 

