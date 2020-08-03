Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7C623AFAD
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 23:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgHCV3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 17:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbgHCV3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 17:29:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3448E2075A;
        Mon,  3 Aug 2020 21:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596490193;
        bh=q6aiSaIWy8X/Aq7/6j1OJ7mK0WKgLY9zreFEVDMEhz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c2QMLlOsjO/4rp/5NSmWu8tfRzrbzL0AFJjqa2BD/4hPZYR05yktLGP6o70U9anad
         Itavb2N4P3WjbDq11ezzhQqxVKllKdUx1+LK/0uUP2tQFqw+58H2p0OFzZY5dcA+3s
         NHrjTfhgSC+ADvgWiRzK3lVNiuppFcew62x+o2MI=
Date:   Mon, 3 Aug 2020 14:29:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v5 net-next 04/10] qed: implement devlink info request
Message-ID: <20200803142951.4c92f1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200802100834.383-5-irusskikh@marvell.com>
References: <20200802100834.383-1-irusskikh@marvell.com>
        <20200802100834.383-5-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Aug 2020 13:08:28 +0300 Igor Russkikh wrote:
> Here we return existing fw & mfw versions, we also fetch device's
> serial number:
> 
> ~$ sudo ~/iproute2/devlink/devlink  dev info
> pci/0000:01:00.0:
>   driver qed
>   serial_number REE1915E44552

Just to confirm - this is not:

   * - ``board.serial_number``
     - Board serial number of the device.

       This is usually the serial number of the board, often available in
       PCI *Vital Product Data*.

>   versions:
>       running:
>         fw 8.42.2.0
>       stored:
>         fw.mgmt 8.52.10.0
> pci/0000:01:00.1:
>   driver qed
>   serial_number REE1915E44552
>   versions:
>       running:
>         fw 8.42.2.0
>       stored:
>         fw.mgmt 8.52.10.0
> 
> MFW and FW are different firmwares on device.
> Management is a firmware responsible for link configuration and
> various control plane features. Its permanent and resides in NVM.
> 
> Running FW (or fastpath FW) is an embedded microprogram implementing
> all the packet processing, offloads, etc. This FW is being loaded
> on each start by the driver from FW binary blob.

Sounds like you should use:

fw.app - Data path microcode controlling high-speed packet processing.

Rather than:

fw - Overall firmware version, often representing the collection of fw.mgmt, fw.app, etc.

All quotes from devlink-info.rst in the kernel sources.
