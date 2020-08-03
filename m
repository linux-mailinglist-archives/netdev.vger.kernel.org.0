Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335B623AFEE
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgHCWFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgHCWFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 18:05:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 534B42076E;
        Mon,  3 Aug 2020 22:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596492346;
        bh=X6WdBPxf34CLsndAxzKDBKs7P4jjlUHINtNz27tQpYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cD0oNsHzMJYFlo7NJY+14b8LFsjnY/fabss2Dp6pWOzfk4L4t6V5PKdiwN3f5wb4D
         E5Llb/YTiPU6f1RjV4PFopEV0WWg+7XOre3O642Fo1q9zBS+BVmTy24Hepj/w0uegh
         s9+bHNL2C1dWHp205OZBvr3rXMPVhaRfow1CDYew=
Date:   Mon, 3 Aug 2020 15:05:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next v3 1/2] hinic: add generating mailbox random
 index support
Message-ID: <20200803150544.57dbe802@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200801024935.20819-2-luobin9@huawei.com>
References: <20200801024935.20819-1-luobin9@huawei.com>
        <20200801024935.20819-2-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Aug 2020 10:49:34 +0800 Luo bin wrote:
> add support to generate mailbox random id of VF to ensure that
> mailbox messages PF received are from the correct VF.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>
> ---
> V2~V3 fix review opinions pointed out by Jakub

In the future please specify what was changed, e.g.:

 - use get_random_u32()
 - remove unnecessary parenthesis

etc.

> +int hinic_vf_mbox_random_id_init(struct hinic_hwdev *hwdev)
> +{
> +	u8 vf_in_pf;
> +	int err = 0;
> +
> +	if (HINIC_IS_VF(hwdev->hwif))
> +		return 0;
> +
> +	for (vf_in_pf = 1; vf_in_pf <= hwdev->nic_cap.max_vf; vf_in_pf++) {
> +		err = set_vf_mbox_random_id(hwdev, hinic_glb_pf_vf_offset
> +					    (hwdev->hwif) + vf_in_pf);

I'm sorry but you must put the call to hinic_glb_pf_vf_offset() on a
separate line. Perhaps take this call out of the for loop entirely?

The way it's written with the parenthesis on the next line is hard to
read.

> +		if (err)
> +			break;
> +	}
