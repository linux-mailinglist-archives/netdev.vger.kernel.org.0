Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB592A9FC5
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbgKFWPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbgKFWPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:15:36 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C441F206F9;
        Fri,  6 Nov 2020 22:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604700935;
        bh=UP+8rgY4i9tm/nAHJCDhNq40B/ZxohNdGNwVhE25CRo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RcgDz53skk1FQzig+pXQUZ4yJTfFg9GggA+RZdYUiuwrcX3sU66kMJMNq0biEjapJ
         V6JbDjsvaZs72FVnERxbX/dNJ9O003T+W4Cexghvc5n1dy5CbTyzkrzTwBAM5GGbN6
         3cFihHKxtuJam+Aen2QpmVangYyf8YZgUeNRE0do=
Message-ID: <df7273e41c72d0b9ac3e7df2773417069169a29f.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 06/13] octeontx2-pf: Add support for unicast
 MAC address filtering
From:   Saeed Mahameed <saeed@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Date:   Fri, 06 Nov 2020 14:15:33 -0800
In-Reply-To: <20201105092816.819-7-naveenm@marvell.com>
References: <20201105092816.819-1-naveenm@marvell.com>
         <20201105092816.819-7-naveenm@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 14:58 +0530, Naveen Mamindlapalli wrote:
> From: Hariprasad Kelam <hkelam@marvell.com>
> 
> Add unicast MAC address filtering support using install flow
> message. Total of 8 MCAM entries are allocated for adding
> unicast mac filtering rules. If the MCAM allocation fails,
> the unicast filtering support will not be advertised.
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  10 ++
>  .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 138
> +++++++++++++++++++--
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   5 +
>  3 files changed, 146 insertions(+), 7 deletions(-)
> 

> +int otx2_add_macfilter(struct net_device *netdev, const u8 *mac)
> +{
> +	struct otx2_nic *pf = netdev_priv(netdev);
> +	int err;
> +
> +	err = otx2_do_add_macfilter(pf, mac);
> +	if (err) {
> +		netdev->flags |= IFF_PROMISC;

I don't think you are allowed to change netdev->flags inside the driver
like this, this can easily conflict with other users of this netdev;
netdev promiscuity is managed by the stack via refcount Please see:
__dev_set_promiscuity() and dev_set_promiscuity()

And you will need to notify stack and userspace of flags changes.

