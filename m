Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5BE2045A8
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgFWAfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731804AbgFWAfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 20:35:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2A420738;
        Tue, 23 Jun 2020 00:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592872513;
        bh=R77uYdiArYgWzfb+aKZUD9TQZSdSaQU6/pKeXtLZjQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UxFqokM7yO9c9ycA4bFxM/TGdtVNXiiXjWWAMBs/4HI1u5Vh2lD5GkPm70RzTDwbT
         A4/UoKhASnqQwMpxdtHV/+UujF6O1X6NOo7bkUaPCQedII99BLcUSFZi9GCVAq/OBZ
         IU+fmDPVqLjjIFaj/AZjRymLoEF93WXdKLIb+NZ0=
Date:   Mon, 22 Jun 2020 17:35:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Qian Cai <cai@lca.pw>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 9/9] i40e: silence an UBSAN false positive
Message-ID: <20200622173510.04ee7bf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200622221817.2287549-10-jeffrey.t.kirsher@intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
        <20200622221817.2287549-10-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 15:18:17 -0700 Jeff Kirsher wrote:
> From: Qian Cai <cai@lca.pw>
> 
> virtchnl_rss_lut.lut is used for the RSS lookup table, but in
> i40e_vc_config_rss_lut(), it is indexed by subscript results in a false
> positive.

This is commit message is not great either. The point is that we have a
pad[1] after the lut[1], and supposedly indexing second element of
lut[] is expected? Not sure why accessing pad is okay...

>  UBSAN: array-index-out-of-bounds in drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:2983:15
>  index 1 is out of range for type 'u8 [1]'
>  CPU: 34 PID: 871 Comm: kworker/34:2 Not tainted 5.7.0-next-20200605+ #5
>  Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 03/09/2018
>  Workqueue: i40e i40e_service_task [i40e]
>  Call Trace:
>   dump_stack+0xa7/0xea
>   ubsan_epilogue+0x9/0x45
>   __ubsan_handle_out_of_bounds+0x6f/0x80
>   i40e_vc_process_vf_msg+0x457c/0x4660 [i40e]
>   i40e_service_task+0x96c/0x1ab0 [i40e]
>   process_one_work+0x57d/0xbd0
>   worker_thread+0x63/0x5b0
>   kthread+0x20c/0x230
>   ret_from_fork+0x22/0x30
> 
> Fixes: d510497b8397 ("i40e: add input validation for virtchnl handlers")
> Signed-off-by: Qian Cai <cai@lca.pw>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> index 62132df0527e..5070b3a4b026 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -3018,6 +3018,7 @@ static int i40e_vc_config_rss_lut(struct i40e_vf *vf, u8 *msg)
>  	struct i40e_vsi *vsi = NULL;
>  	i40e_status aq_ret = 0;
>  	u16 i;
> +	u8 *lut = vrl->lut;

reverse xmas tree

>  	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
>  	    !i40e_vc_isvalid_vsi_id(vf, vrl->vsi_id) ||

