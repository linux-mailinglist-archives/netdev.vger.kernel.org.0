Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2602287F1
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 20:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgGUSEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 14:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgGUSEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 14:04:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B28C720717;
        Tue, 21 Jul 2020 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595354684;
        bh=nVIywvQnxcC91mVVs3LqF4xYDeOmYrKYwhWlr4Akf38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TmIWvLfeYhmjpxU670x91Sx5Hgod8arwrFem04ZbU1OpTEj42wScdtMhD+Lor0hm7
         J6YBF0Oy0L0iV7+RxfsC+QJXZ9MKoUNk3Wk9SC77lcjlzR4OrTlZBrpL0jW1f2pfwU
         HvqS9ZZqFo0x11ltZQOP0QVlKaZhczEHgTElm13M=
Date:   Tue, 21 Jul 2020 11:04:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v4 06/15] iecm: Implement mailbox functionality
Message-ID: <20200721110441.50b5c43c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 17:38:01 -0700 Tony Nguyen wrote:
> +		(cq->next_to_use)++;
> +		if (cq->next_to_use == cq->ring_size)
> +			cq->next_to_use = 0;
> +	}
> +
> +	/* Force memory write to complete before letting hardware
> +	 * know that there are new descriptors to fetch.
> +	 */
> +	iecm_wmb();

dma_wmb() would probably be sufficient here?

> +	wr32(hw, cq->reg.tail, cq->next_to_use);
