Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98DE6BCC30
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjCPKMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjCPKMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:12:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79572BCBBB;
        Thu, 16 Mar 2023 03:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678961534; x=1710497534;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1ch8yAEoqDaUdQ3sRi+e/B4vAYC/6RjGdOIhFQNejgo=;
  b=BpNEsMIJzAI7WzLL3bKzFpaMLvPDYwFK4WIzvfqLEnWyrF1zqg1fw0W1
   9IDv0u7I55oO4eEEnvFoq5RepEbf+OhyOxZnfQuGGXiYWWGyDEj+4V+ln
   /vrUUk4EArT9YYOMkOK8c9Lfw80LCBb1Q0S+YHNCm9xIFnbsK9LFpLe6D
   PhMGbKVywO5RqAcJUWRQLEHZrSjEIYWwetBOgAz552O7xXLq8ybI7S84O
   gZ1774jzLDFFXz2u1TC76McY2IJ5SBtnwuoOBrdoRmfR8rxsXpDXxzGnt
   VJusVPOLwyjnTTHqVASzpAdaCLITdCGOS0pzlw9PYhKyXEyIMmcyxpuYC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="337965227"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="337965227"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:12:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="748797466"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="748797466"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:12:11 -0700
Date:   Thu, 16 Mar 2023 11:12:04 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qed/qed_sriov: avoid a possible NULL deref in
 configure_min_tx_rate
Message-ID: <ZBLrb6C1mEjgAGHr@localhost.localdomain>
References: <20230315194809.579756-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315194809.579756-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 10:48:09PM +0300, Daniil Tatianin wrote:
> We have to make sure that the info returned by qed_iov_get_vf_info is
> valid before using it.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: 733def6a04bf ("qed*: IOV link control")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_sriov.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
> index 2bf18748581d..cd43f1b23eb1 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
> @@ -4404,6 +4404,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
>  	}
>  
>  	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
> +	if (!vf)
> +		return -EINVAL;
> +
>  	vport_id = vf->vport_id;
>  
>  	return qed_configure_vport_wfq(cdev, vport_id, rate);
> -- 
> 2.25.1
> 

There is also potential NULL pointer dereference in:
qed_iov_handle_trust_change()
Should be:
if (!vf || !vf->vf->vport_instance)

I think it can be a part of this fix.

Thanks,
Michal
