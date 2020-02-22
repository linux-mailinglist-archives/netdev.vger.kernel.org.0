Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960FB168D3A
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 08:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgBVHcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 02:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgBVHco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 02:32:44 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65ECE2071E;
        Sat, 22 Feb 2020 07:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582356764;
        bh=L/jvcTZBRjqDoBnzeDmLUIsHlvPZeu/vCb6oPctl9Fk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Exu4zKkHiaWt8HWIgzPXZ4qQDtQn/chs+Tl0/7xYo09VP8fJV6Vy5qlEKGRk2MNx7
         bVsAckOsQmN9szB+zvSO3ocMJnGAEF2HbA/AqcPgkaiCeoTa5DRvqBCNlnDY6rXR8X
         8Nx/0235hsIFparQaY+0yr86nkL98GZIlgT367VE=
Date:   Sat, 22 Feb 2020 09:32:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hans Wippel <ndev@hwipl.net>
Cc:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [RFC net-next] net/smc: improve peer ID in CLC decline for SMC-R
Message-ID: <20200222073241.GH209126@unreal>
References: <20200221130805.5988-1-ndev@hwipl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221130805.5988-1-ndev@hwipl.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 02:08:05PM +0100, Hans Wippel wrote:
> According to RFC 7609, all CLC messages contain a peer ID that consists
> of a unique instance ID and the MAC address of one of the host's RoCE
> devices. But if a SMC-R connection cannot be established, e.g., because
> no matching pnet table entry is found, the current implementation uses a
> zero value in the CLC decline message although the host's peer ID is set
> to a proper value.
>
> This patch changes the peer ID handling in two ways:
>
> (1) If no RoCE and no ISM device is usable for a connection, there is no
> LGR and the LGR check in smc_clc_send_decline() prevents that the peer
> ID is copied into the CLC decline message for both SMC-D and SMC-R. So,
> this patch modifies the check to also accept the case of no LGR. Also,
> only a valid peer ID is copied into the decline message.
>
> (2) The patch initializes the peer ID to a random instance ID and a zero
> MAC address. If a RoCE device is in the host, the MAC address part of
> the peer ID is overwritten with the respective address. Also, a function
> for checking if the peer ID is valid is added. A peer ID is considered
> valid if the MAC address part contains a non-zero MAC address.
>
> Signed-off-by: Hans Wippel <ndev@hwipl.net>
> ---
>  net/smc/smc_clc.c |  9 ++++++---
>  net/smc/smc_ib.c  | 19 ++++++++++++-------
>  net/smc/smc_ib.h  |  1 +
>  3 files changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
> index 3e16b887cfcf..e2d3b5b95632 100644
> --- a/net/smc/smc_clc.c
> +++ b/net/smc/smc_clc.c
> @@ -372,9 +372,12 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
>  	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
>  	dclc.hdr.version = SMC_CLC_V1;
>  	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
> -	if (smc->conn.lgr && !smc->conn.lgr->is_smcd)
> -		memcpy(dclc.id_for_peer, local_systemid,
> -		       sizeof(local_systemid));
> +	if (!smc->conn.lgr || !smc->conn.lgr->is_smcd) {
> +		if (smc_ib_is_valid_local_systemid()) {
> +			memcpy(dclc.id_for_peer, local_systemid,
> +			       sizeof(local_systemid));
> +		}
> +	}
>  	dclc.peer_diagnosis = htonl(peer_diag_info);
>  	memcpy(dclc.trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
>
> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index 6756bd5a3fe4..203dd05d7113 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -37,11 +37,7 @@ struct smc_ib_devices smc_ib_devices = {	/* smc-registered ib devices */
>  	.list = LIST_HEAD_INIT(smc_ib_devices.list),
>  };
>
> -#define SMC_LOCAL_SYSTEMID_RESET	"%%%%%%%"
> -
> -u8 local_systemid[SMC_SYSTEMID_LEN] = SMC_LOCAL_SYSTEMID_RESET;	/* unique system
> -								 * identifier
> -								 */
> +u8 local_systemid[SMC_SYSTEMID_LEN] = {0};	/* unique system identifier */

There is no need to assign 0 for global variables, they are initialized
to zero by default.

Thanks
