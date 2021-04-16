Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F979362A01
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344177AbhDPVNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:13:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344171AbhDPVNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 17:13:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3706C613C3;
        Fri, 16 Apr 2021 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618607568;
        bh=X1rZsXC0I4ILuuRFTt+c6VKe9FyajAqjFZP6aHsKuqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QJO8HpDV1/Ak9gUEpgzZc+ILUR9KW+N1+EHssZHn1yA9Mn9R4fdW9KgD9PXI9pFgx
         1x5GIUcCAZVhzIgIRYVO6P4Qkd0IKGGOeWsL+1J1PtBbpHN1ryKeQgZdztcIP4DcwS
         J78lwbt6UI2tIUtxo1N9exiNI0iHMbUWlu0WUqhEy7iydQccvd/QFn9NBOpGmoNarw
         DdGRJ4hBgVPEGSMkLUTZHk9G36S033Pu1XPpOjSNJVczGqBDshmB8U3TPefdRFZvGn
         JJJZfY1nqpMzn+VUc18MmjLSMu9NqWgja/TcoCdcQsgxxAilKTrMsaCAg/TstUam7X
         OqK8d+ieTJ8jg==
Date:   Fri, 16 Apr 2021 14:12:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Grzegorz Siwik <grzegorz.siwik@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Dave Switzer <david.switzer@intel.com>
Subject: Re: [PATCH net-next 2/6] igb: Add double-check MTA_REGISTER for
 i210 and i211
Message-ID: <20210416141247.7a8048ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416204500.2012073-3-anthony.l.nguyen@intel.com>
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
        <20210416204500.2012073-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 13:44:56 -0700 Tony Nguyen wrote:
> +	bool is_failed;
> +	int i;
> +
> +	do {
> +		is_failed = false;
> +		for (i = hw->mac.mta_reg_count - 1; i >= 0; i--) {
> +			if (array_rd32(E1000_MTA, i) != hw->mac.mta_shadow[i]) {
> +				is_failed = true;
> +				array_wr32(E1000_MTA, i, hw->mac.mta_shadow[i]);
> +				wrfl();
> +				break;
> +			}
> +		}
> +	} while (is_failed);

Looks like a potential infinite loop on persistent failure.
Also you don't need "is_failed", you can use while (i >= 0), or
assign i = hw->mac.mta_reg_count, or consider using a goto. 
