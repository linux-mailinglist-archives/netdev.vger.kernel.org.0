Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FB2F3CD3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfKHAZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:25:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50698 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHAZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:25:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E847915385D74;
        Thu,  7 Nov 2019 16:25:50 -0800 (PST)
Date:   Thu, 07 Nov 2019 16:25:50 -0800 (PST)
Message-Id: <20191107.162550.125702977926999669.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     anirudh.venkataramanan@intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, andrewx.bowers@intel.com
Subject: Re: [net-next 01/15] ice: Use ice_ena_vsi and ice_dis_vsi in DCB
 configuration flow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107221438.17994-2-jeffrey.t.kirsher@intel.com>
References: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
        <20191107221438.17994-2-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 16:25:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu,  7 Nov 2019 14:14:24 -0800

> @@ -169,15 +170,23 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
>  	}
>  
>  	/* Store old config in case FW config fails */
> -	old_cfg = devm_kzalloc(&pf->pdev->dev, sizeof(*old_cfg), GFP_KERNEL);
> -	memcpy(old_cfg, curr_cfg, sizeof(*old_cfg));
> +	old_cfg = kmemdup(curr_cfg, sizeof(*old_cfg), GFP_KERNEL);

Why not use devm_kmemdup()?  Then you don't have to add the kfree() code paths.
