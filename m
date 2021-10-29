Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2AF4400ED
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhJ2RJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhJ2RJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7FEA60C4D;
        Fri, 29 Oct 2021 17:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635527212;
        bh=TlRXvllfMLm/nE6gS7TH9SQhp8NM6Zj+Zn07BjBdoKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jySZTyzcCsGvpe0K7/n9GQ82g72V4GrYc063gmWQJMy3PkL3AWf4osMQJ+zfAuehm
         veccqFXqIFQhc2xzzJMXiM72DpQv12CMaHG3DucXa+CqmfcNq74k0UXT9J7L7QKUkx
         +Bdkao+iVczLZ+5cjnwYLYuhu6+69Oh+1K910qgMjhwrbOqFDVJa6dnYqBYhRDRY4D
         AhjkfGxWNbMlKFLnuHO4teWvCWW6EN7QmyMdLqGDoPAdHAKtxUfGUEeYmRZsuQUQ/+
         TaXWPn3xdybw/5ln6spVGgIYgX6cT9PKkxXe4lhITAjq9iBrNzMi2btwgHqfr0fGc4
         d4p+J5Au/zfJg==
Date:   Fri, 29 Oct 2021 20:06:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com, jiri@nvidia.com
Subject: Re: [PATCH net-next v2 03/19] bnxt_en: implement devlink dev reload
 driver_reinit
Message-ID: <YXwqKCJkDOfvUce8@unreal>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
 <1635493676-10767-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635493676-10767-4-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 03:47:40AM -0400, Michael Chan wrote:
> From: Edwin Peer <edwin.peer@broadcom.com>
> 
> The RTNL lock must be held between down and up to prevent interleaving
> state changes, especially since external state changes might release
> and allocate different driver resource subsets that would otherwise
> need to be tracked and carefully handled. If the down function fails,
> then devlink will not call the corresponding up function, thus the
> lock is released in the down error paths.
> 
> v2: Don't use devlink_reload_disable() and devlink_reload_enable().
> Instead, check that the netdev is not in unregistered state before
> proceeding with reload.
> 
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-Off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 14 +--
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  5 +
>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 97 +++++++++++++++++++
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c |  2 -
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  3 +
>  5 files changed, 110 insertions(+), 11 deletions(-)

<...>

> +static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
> +			       enum devlink_reload_action action,
> +			       enum devlink_reload_limit limit,
> +			       struct netlink_ext_ack *extack)
> +{
> +	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
> +	int rc = 0;
> +
> +	switch (action) {
> +	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT: {
> +		if (BNXT_PF(bp) && bp->pf.active_vfs) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "reload is unsupported when VFs are allocated\n");
> +			return -EOPNOTSUPP;
> +		}

This is racy against bnxt_sriov_enable and bnxt_sriov_configure

Thanks
