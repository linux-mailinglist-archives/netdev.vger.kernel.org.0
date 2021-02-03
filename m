Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAA230D19D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhBCCef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhBCCee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 21:34:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFFF64F68;
        Wed,  3 Feb 2021 02:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612319634;
        bh=aP1o7R/p6ZJBEMYpQoeeYZf4JRTa4LuznljLFxdQ4BY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lfKaTN3Hp0Kq92ARbBd5VVAdG213etWaEeEELL9zL7oxTSXfanQfKen2iXOKA2PmX
         PQmwRYknXK44vWawYOxgU1nzPiDwfBMgfS7lUIvEA/IXKvPqacM+5YPKt6FIpOJq88
         4Owfux69vwlqXcWzhPN9WxxX6lCh0v0zJjt035ez/E6F1lSYHeA0N4SNBx2doyDWX+
         Dl0jSOrjPoEIdc7fh29nN1c9xXhLKbtuJR+kpLP1ajdCHiC6lzkEgKnxLbfyvc7Upg
         AIVcAw00/wRnyEom4g0dEPahVUffdllpAtZ29toM61S4Bjy8ExEe6Zv3S03f6VhRb2
         /VGlLSP6BwGVw==
Date:   Tue, 2 Feb 2021 18:33:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net-next 5/6] i40e: Add info trace at loading XDP
 program
Message-ID: <20210202183352.52c456ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202022420.1328397-6-anthony.l.nguyen@intel.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
        <20210202022420.1328397-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Feb 2021 18:24:19 -0800 Tony Nguyen wrote:
> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> 
> New trace indicates that the XDP program was loaded.
> The trace has a note that in case of using XDP_REDIRECT,
> number of queues on both interfaces shall be the same.
> This is required for optimal performance of XDP_REDIRECT,
> if interface used for TX has lower number of queues than
> a RX interface, the packets may be dropped (depending on
> RSS queue assignment).

By RSS queue assignment you mean interrupt mapping?

> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 521ea9df38d5..f35bd9164106 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -12489,11 +12489,14 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
>  	/* Kick start the NAPI context if there is an AF_XDP socket open
>  	 * on that queue id. This so that receiving will start.
>  	 */
> -	if (need_reset && prog)
> +	if (need_reset && prog) {
> +		dev_info(&pf->pdev->dev,
> +			 "Loading XDP program, please note: XDP_REDIRECT action requires the same number of queues on both interfaces\n");

We try to avoid spamming logs. This message will be helpful to users
only the first time, if at all.
