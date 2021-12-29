Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D21048162A
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhL2TNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:13:54 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34498 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhL2TNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 14:13:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C860CE1A14
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 19:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7935BC36AE9;
        Wed, 29 Dec 2021 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640805230;
        bh=0xokU4hs4lavhz61rzr3CnV8pLNCBIAS1epk3E8BnFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=egRJxdflgbi2I6JUYs0BiKIA41f6DEVt/MQYWcF7tgw6mOtesvToS91A6wA4fO6bt
         PGMW5GxgkjLSIHr2twSVTEkWYBPQpszZeaj/geqLtcHS8czzMc/Lc+BR3ZZxxItNEe
         hUmWBWQlk31slIvkJjyCQ0zIvYuMzBvOERp8/jgQwWVIwVB1FTc8GpLR6sCBjE/0Sa
         ybHIc6hZ7xnkumg/rJCQZ+vegCCLuhZ7hngPnzFIlO1Dy4xQBF2wYADLAy3t4My7Xe
         jWvPUImn6o+T6GW0GoNd3Y7nzkgqgO3GfS3lOk/NBqNfbjLBcl4sxhpQH5IDAI2QJk
         i1aJzNkoCd23g==
Date:   Wed, 29 Dec 2021 11:13:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
Cc:     <andrew@lunn.ch>, <aelior@marvell.com>, <netdev@vger.kernel.org>,
        <palok@marvell.com>
Subject: Re: [PATCH net-next v2 1/1] qed: add prints if request_firmware()
 failed
Message-ID: <20211229111349.15f28b34@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211229110232.336845-1-vbhavaraju@marvell.com>
References: <YcrmpvMAD5zKHqTE@lunn.ch>
        <20211229110232.336845-1-vbhavaraju@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021 03:02:32 -0800 Venkata Sudheer Kumar Bhavaraju
wrote:
> > Hi Venkata
> > 
> > When you decide to do something different to what has been requested,
> > it is a good idea to say why. There might be a very good reason for
> > this, but unless you explain it, i have no idea what it is.
> 
> I moved the FW_REPO macro to qed_if.h under include/linux since I didn't
> want to bloat something like include/linux/firmware.h. It's really used
> (exact URL in a print after request_firmware() fails) at two other places.
> 
> If you think it's more useful in include/linux/firmware.h so that other
> drivers can make use of it in future, I can move it there.

If printing this information made sense it should have been done by the
core, not each driver. In fact your existing print:

 			DP_NOTICE(cdev,
 				  "Failed to find fw file - /lib/firmware/%s\n",
 				  QED_FW_FILE_NAME);

is redundant and potentially incorrect. Firmware path is configurable,
it does not have to be /lib/firmware. request_firmware() does not set
FW_OPT_NO_WARN, so core will already print the warning.

As for your current patch vast majority of users will get the firmware
from distro packages. I don't know why you're trying to print the repo
link.
