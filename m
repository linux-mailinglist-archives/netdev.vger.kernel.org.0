Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47386215FA5
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGFTtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFTtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:49:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BBBC061755;
        Mon,  6 Jul 2020 12:49:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FFC5127F6640;
        Mon,  6 Jul 2020 12:49:48 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:49:47 -0700 (PDT)
Message-Id: <20200706.124947.1335511480336755384.davem@davemloft.net>
To:     ayal@mellanox.com
Cc:     kuba@kernel.org, saeedm@mellanox.com, mkubecek@suse.cz,
        linux-pci@vger.kernel.org, helgaas@kernel.org,
        netdev@vger.kernel.org, tariqt@mellanox.com,
        alexander.h.duyck@linux.intel.com
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed
 ordering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7b79eead-ceab-5d95-fd91-cabeeef82d6a@mellanox.com>
References: <19a722952a2b91cc3b26076b8fd74afdfbfaa7a4.camel@mellanox.com>
        <20200624133018.5a4d238b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7b79eead-ceab-5d95-fd91-cabeeef82d6a@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:49:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>
Date: Mon, 6 Jul 2020 16:00:59 +0300

> Assuming the discussions with Bjorn will conclude in a well-trusted
> API that ensures relaxed ordering in enabled, I'd still like a method
> to turn off relaxed ordering for performance debugging sake.
> Bjorn highlighted the fact that the PCIe sub system can only offer a
> query method. Even if theoretically a set API will be provided, this
> will not fit a netdev debugging - I wonder if CPU vendors even support
> relaxed ordering set/unset...
> On the driver's side relaxed ordering is an attribute of the mkey and
> should be available for configuration (similar to number of CPU
> vs. number of channels).
> Based on the above, and binding the driver's default relaxed ordering
> to the return value from pcie_relaxed_ordering_enabled(), may I
> continue with previous direction of a private-flag to control the
> client side (my driver) ?

I don't like this situation at all.

If RO is so dodgy that it potentially needs to be disabled, that is
going to be an issue not just with networking devices but also with
storage and other device types as well.

Will every device type have a custom way to disable RO, thus
inconsistently, in order to accomodate this?

That makes no sense and is a terrible user experience.

That's why the knob belongs generically in PCI or similar.
