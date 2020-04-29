Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DF91BE3F4
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgD2QfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2QfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 12:35:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13626208FE;
        Wed, 29 Apr 2020 16:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588178122;
        bh=PLK/xJE+T+VKqaVgo00E1thrQcDEKSG8CwZuddgyaa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v0sN7F4QCLZ6OdWwFOFaRlBuGxT95yWXHX0P+dckWE/CUdkYdR2jOMoMqJOD3T9iw
         DpJ50f3E1vuI04wwZ6JwLbP+POc75N1c/mHVJn27TB7ELyA7kTxHXwF8ZZP4sio3kX
         0OLMCyL1heqmfB9NaMVRlDB4yWIIYZYdD9SKWzp0=
Date:   Wed, 29 Apr 2020 09:35:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] devlink: let kernel allocate region snapshot
 id
Message-ID: <20200429093518.531a5ed9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200429054552.GB6581@nanopsycho.orion>
References: <20200429014248.893731-1-kuba@kernel.org>
        <20200429054552.GB6581@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Apr 2020 07:45:52 +0200 Jiri Pirko wrote:
> Wed, Apr 29, 2020 at 03:42:48AM CEST, kuba@kernel.org wrote:
> >Jiri, this is what I had in mind of snapshots and the same
> >thing will come back for slice allocation.  
> 
> Okay. Could you please send the userspace patch too in order to see the
> full picture?

You got it, I didn't do anything fancy there.

> >+static int
> >+devlink_nl_alloc_snapshot_id(struct devlink *devlink, struct genl_info *info,
> >+			     struct devlink_region *region, u32 *snapshot_id)
> >+{
> >+	struct sk_buff *msg;
> >+	void *hdr;
> >+	int err;
> >+
> >+	err = __devlink_region_snapshot_id_get(devlink, snapshot_id);
> >+	if (err) {
> >+		NL_SET_ERR_MSG_MOD(info->extack,  
> 
> No need to wrap here.

Ok.

> >+				   "Failed to allocate a new snapshot id");
> >+		return err;
> >+	}

> >-	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
> >-	if (err)
> >-		return err;
> >+		err = __devlink_snapshot_id_insert(devlink, snapshot_id);
> >+		if (err)
> >+			return err;
> >+	} else {
> >+		err = devlink_nl_alloc_snapshot_id(devlink, info,
> >+						   region, &snapshot_id);
> >+		if (err)
> >+			return err;
> >+	}
> > 
> > 	err = region->ops->snapshot(devlink, info->extack, &data);  
> 
> How the output is going to looks like it this or any of the follow-up
> calls in this function are going to fail?
> 
> I guess it is going to be handled gracefully in the userspace app,
> right?

The output is the same, just the return code is non-zero.

I can change that not to print the snapshot info until we are sure the
operation succeeded if you prefer.

Initially I had the kernel not sent the message until it's done with
the operation, but that seems unnecessarily complex. The send operation
itself may fail, and if we ever have an operation that requires more
than one notification we'll have to struggle with atomic sends.

Better have the user space treat the failure like an exception, and
ignore all the notifications that came earlier.

That said the iproute2 patch can be improved with extra 20 lines so
that it holds off printing the snapshot info until success.
