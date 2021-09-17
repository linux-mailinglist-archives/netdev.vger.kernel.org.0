Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FF8410019
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbhIQTz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhIQTzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 15:55:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3CED60F6E;
        Fri, 17 Sep 2021 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631908443;
        bh=bBmW58MRsiVKQ/aNEGD6nPY56z7goiloecWOPspBt6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kci3I5P8PXMhQuhvlanGsLu1iOxvoyZyQU0LZYDB0Sj6Rn/APFbGMyc5cAmWTAE7O
         OFBjZVdSJWRxBeWCgrjQCYZgSEm1k6TE1o1HBEhwMDxms/pKbchsU2cfE0ZtsgCee0
         r6i4MiyMXDQks5dpF5W8IOjOxb57h8aWQya5k6GXXug/rtjZP8w28McrTaR1Baisn/
         0msbRqvSCHB96NxBDdAvDhgTTdbNiDl0LEJaw5wc/JDltWHyBC5XwNcRsc8tNKHd1V
         g3cwB8OkundD5ikEPEr0NVGRCsmLY5ReQ/P4EdAOoN5PUxOF0zwwdiYur2sOUovywu
         lFSJVahlI8tDA==
Date:   Fri, 17 Sep 2021 12:54:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Message-ID: <20210917125401.6e22ae13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1631889589-26941-2-git-send-email-min.li.xe@renesas.com>
References: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
        <1631889589-26941-2-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 10:39:49 -0400 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Current adjtime is not accurate when delta is smaller than 10000ns. So
> for small time correction, we will switch to DCO mode to pull phase
> more precisely in one second duration.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Please fix the checkpatch issues.

> @@ -29,6 +29,14 @@ module_param(phase_snap_threshold, uint, 0);
>  MODULE_PARM_DESC(phase_snap_threshold,
>  "threshold (1000ns by default) below which adjtime would ignore");
>  
> +static bool delayed_accurate_adjtime = false;
> +module_param(delayed_accurate_adjtime, bool, false);
> +MODULE_PARM_DESC(delayed_accurate_adjtime,
> +"set to true to use more accurate adjtime that is delayed to next 1PPS signal");

Module parameters are discouraged. If you have multiple devices on the
system module parameters don't allow setting different options
depending on device. Unless Richard or someone else suggests a better
API for this please use something like devlink params instead
(and remember to document them).

> +static char *firmware;
> +module_param(firmware, charp, 0);

What's the point of this? Just rename the file in the filesystem.
