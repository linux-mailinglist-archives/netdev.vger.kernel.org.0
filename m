Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4186462988
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhK3BUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 20:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhK3BUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 20:20:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05234C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:17:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8155B80CB6
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 01:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7A4C53FC7;
        Tue, 30 Nov 2021 01:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638235033;
        bh=3FpRATIqkQnI08xkdsG6mZocNgBRuVbPjj2eIgizOD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RrgFhP0d/1aboXk5eCR4pKRYKm/U7RBwHslyp3yosIdZxOixjwcSCe24rD4Fs+IRA
         pIsPBuXSALLgSBiRpxCdvnXEoXBaQwMhLM5LDoaFYdQqrRwT4mBNLWhcHklNPBvYBv
         4tySe+GWYiM7tV4E87G+haIJ9ZrgWWbqrDuWdh1sjaFvebx5VNDrVRm16cvBPoqrlX
         BOeOKB+ZuIkKUn4Nn1via0SrObs5jkmTqgXDsqfswFn5fvgdwmM4fYVlwyOoNI13cb
         GA3a3valen88n0e8QcCGUBKq7Lnr09gbURs2bLvdckcmqyF+dK+kk1Lptihy+sKNLQ
         w+sHc0HX6cwvw==
Date:   Mon, 29 Nov 2021 17:17:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM
 resume path
Message-ID: <20211129171712.500e37cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 22:14:06 +0100 Heiner Kallweit wrote:
> -	rtnl_lock();
> +	if (!rpm)
> +		rtnl_lock();

Is there an ASSERT_RTNL() hidden in any of the below? Can we add one?
Unless we're 100% confident nobody will RPM resume without rtnl held..

>  	if (!err && netif_running(netdev))
>  		err = __igb_open(netdev, true);
>  
>  	if (!err)
>  		netif_device_attach(netdev);
> -	rtnl_unlock();
> +	if (!rpm)
> +		rtnl_unlock();
