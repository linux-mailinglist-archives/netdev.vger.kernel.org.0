Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27ADD20B91C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgFZTKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgFZTKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 15:10:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1891C2053B;
        Fri, 26 Jun 2020 19:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593198606;
        bh=bGIb4SrpptDuv4sh91TPMeqb+dnvHN1p3gav+iysFlY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qD2+YhsUC0c8GHqJgkYGWnexD0yDWsCOgYr13pnx44b1yUUCOpsZPHkwXpZW7wMGN
         I54h4Jtw/nn6oN2HNV+RpoUA6wdks505JA5LBiW+yxJO2Pv6eHHcrdD7zOqZWJoLFt
         uiM59j2OQ9lQfuUbbSunu1s11kTrh1e5oEbfQjvg=
Date:   Fri, 26 Jun 2020 12:10:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v3 06/15] iecm: Implement mailbox functionality
Message-ID: <20200626121004.506bfa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626020737.775377-7-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-7-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 19:07:28 -0700 Jeff Kirsher wrote:
> +	err = register_netdev(netdev);
> +	if (err)
> +		return err;

So the unregister_netdevice() call is in the previous patch, but
registering it is apparetnly in the "implement mbox" patch...

> +	/* carrier off on init to avoid Tx hangs */
> +	netif_carrier_off(netdev);
> +
> +	/* make sure transmit queues start off as stopped */
> +	netif_tx_stop_all_queues(netdev);

Seems like a bad idea to turn the carrier off and stop queues _after_
the netdev is registered. That's a very basic thing to pass 6 authors
and 3 reviewers. What am I missing?
