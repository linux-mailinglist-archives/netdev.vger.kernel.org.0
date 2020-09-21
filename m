Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08862733A3
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 22:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgIUUhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 16:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgIUUhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 16:37:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CDE8218AC;
        Mon, 21 Sep 2020 20:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600720626;
        bh=mYgL/JQmjG7CQaT2e4ziHwAF4I39s/w2BqoCXpVlhGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HNxWEPVr9sSMbnoiye67XR9UePRETi/1637vol9JbB0xFjUwIdArkwgqCaY7ZCkNR
         HtfyBKZ06780GnW2IdgM6R9edaG+bm5qP26KpNoVkQb7L3ePTOMfpLGKmZHlt0vgXl
         xCe+PYNJJkGqFCL7BRZirs5Zaos3ykJQp18Ps+i0=
Date:   Mon, 21 Sep 2020 13:37:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org,
        jiri@nvidia.com
Subject: Re: Exposing device ACL setting through devlink
Message-ID: <20200921133704.5ad64b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200920152136.GB2323@nanopsycho.orion>
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
        <20200904083141.GE2997@nanopsycho.orion>
        <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
        <20200910070016.GT2997@nanopsycho.orion>
        <f4d3923c-958c-c0b4-6aa3-f2500d4967e9@linux.ibm.com>
        <20200918072054.GA2323@nanopsycho.orion>
        <0bdb48e1-171b-3ec6-c993-0499639d0fc4@linux.ibm.com>
        <20200920152136.GB2323@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Sep 2020 17:21:36 +0200 Jiri Pirko wrote:
> >Yes, this the filtering is done on a virtual switch in Power firmware. I am
> >really just trying to report the ACL list's configured at the firmware level
> >to users on the guest OS.  
> 
> We have means to model switches properly in linux and offload to them.
> I advise you to do that.

I think it may have gotten lost in the conversation, but Tom is after
exposing the information to the client side of the switch. AFAIU we
don't have anything like that right now, perhaps the way to go is to
expose enum devlink_port_function_attr on the client side?

Still - it feels hacky when I think about it. 

IMHO kernel device APIs are not the place to expose network config.
It's not like MVRP results pop up as a netdev attribute. 

Tomorrow Amazon, Google, and all other cloud providers will want to
expose some other info, and we'll have to worry about how to make it
common, drawing the lines, reviewing etc.

Tom, is there no way higher layer (cloud) APIs can be used to
communicate this information to the guest?
