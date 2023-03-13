Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7232C6B7988
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjCMNyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjCMNyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:54:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE89F76A;
        Mon, 13 Mar 2023 06:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678715671; x=1710251671;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8EoYPm5xEQrXeCcnAVT/F8N4W4AYyn4iKdyRBjBLcKg=;
  b=mT+zcruT5mIvsV+t9a7JdyApd0bOAmjS9BlvSQ9RKYQZA33h/CljfPqr
   dPBAynEe+gMbsy9FA8ws0Obho8aiZkxNh/fRtfvW8ececdbHAFhDh5E0i
   jZnHz2QA+/+8j5obKxUEmdGrjNYrPgQD6J457CkZPLdo9lkSflhnEa6LW
   WeSjjjNn1t5az1E7Klw5ZWoHsXs2jRfeoyFa+12lWbwYEsMXukh44bpsF
   mYJZKHpRwiiMOTewo+EZ7IuZP6TYZr7EEaRnzSNbBt4VjSdqShoDNal2u
   SBk46pcd4aevivl/ivrIuxiMJJrhOx/W2PXmsuDZ7b9th6wwpL32QnZ9w
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364813311"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="364813311"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 06:54:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="788939110"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="788939110"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 06:54:28 -0700
Date:   Mon, 13 Mar 2023 14:54:20 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH net v2] 9p/xen : Fix use after free bug in
 xen_9pfs_front_remove due  to race condition
Message-ID: <ZA8rDCw+mJmyETEx@localhost.localdomain>
References: <20230313090002.3308025-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313090002.3308025-1-zyytlz.wz@163.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 05:00:02PM +0800, Zheng Wang wrote:
> In xen_9pfs_front_probe, it calls xen_9pfs_front_alloc_dataring
> to init priv->rings and bound &ring->work with p9_xen_response.
> 
> When it calls xen_9pfs_front_event_handler to handle IRQ requests,
> it will finally call schedule_work to start the work.
> 
> When we call xen_9pfs_front_remove to remove the driver, there
> may be a sequence as follows:
> 
> Fix it by finishing the work before cleanup in xen_9pfs_front_free.
> 
> Note that, this bug is found by static analysis, which might be
> false positive.
> 
> CPU0                  CPU1
> 
>                      |p9_xen_response
> xen_9pfs_front_remove|
>   xen_9pfs_front_free|
> kfree(priv)          |
> //free priv          |
>                      |p9_tag_lookup
>                      |//use priv->client
> 
> Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
> v2:
> - fix type error of ring found by kernel test robot
> ---
>  net/9p/trans_xen.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
> index c64050e839ac..83764431c066 100644
> --- a/net/9p/trans_xen.c
> +++ b/net/9p/trans_xen.c
> @@ -274,12 +274,17 @@ static const struct xenbus_device_id xen_9pfs_front_ids[] = {
>  static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
>  {
>  	int i, j;
> +	struct xen_9pfs_dataring *ring = NULL;
Move it before int i, j to have RCT.

>  
>  	write_lock(&xen_9pfs_lock);
>  	list_del(&priv->list);
>  	write_unlock(&xen_9pfs_lock);
>  
>  	for (i = 0; i < priv->num_rings; i++) {
> +		/*cancel work*/
It isn't needed I think, the function cancel_work_sync() tells everything
here.

> +		ring = &priv->rings[i];
> +		cancel_work_sync(&ring->work);
> +
>  		if (!priv->rings[i].intf)
>  			break;
>  		if (priv->rings[i].irq > 0)
> -- 
> 2.25.1
