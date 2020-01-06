Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0603A131AC7
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgAFVzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:55:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42687 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726695AbgAFVz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:55:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578347727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vmmECI1BArQVwUDJptXcPvRtU+ySdyFJRPuvbFtEwis=;
        b=LjCtEYgppRW2Uw0WHIadd4vNzmJNVA6glK9u4Jfge/eQFyEn9TzPdU5gAHOTbOVa67KolJ
        kDTULtjNdZ2Z7jDK0+WZoNxr+psMH7TVZ0DM49eDfd5R9Ylz9cRUK5kTuDnMV3RexfN3Ub
        ryPxEaBj/L/s4092rLUt07aLxHzWVv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-RrKuuhBfPFKSJHwusUSmsQ-1; Mon, 06 Jan 2020 16:55:23 -0500
X-MC-Unique: RrKuuhBfPFKSJHwusUSmsQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DAF7800D48;
        Mon,  6 Jan 2020 21:55:21 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28C537BA28;
        Mon,  6 Jan 2020 21:55:17 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:55:16 -0800 (PST)
Message-Id: <20200106.135516.1925975914161500836.davem@redhat.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        romieu@fr.zoreil.com, linux-kernel@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2 0/3] ethtool: allow nesting of begin() and
 complete() callbacks
From:   David Miller <davem@redhat.com>
In-Reply-To: <cover.1578292157.git.mkubecek@suse.cz>
References: <cover.1578292157.git.mkubecek@suse.cz>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Mon,  6 Jan 2020 07:39:26 +0100 (CET)

> The ethtool ioctl interface used to guarantee that ethtool_ops callbacks
> were always called in a block between calls to ->begin() and ->complete()
> (if these are defined) and that this whole block was executed with RTNL
> lock held:
> 
> 	rtnl_lock();
> 	ops->begin();
> 	/* other ethtool_ops calls */
> 	ops->complete();
> 	rtnl_unlock();
> 
> This prevented any nesting or crossing of the begin-complete blocks.
> However, this is no longer guaranteed even for ioctl interface as at least
> ethtool_phys_id() releases RTNL lock while waiting for a timer. With the
> introduction of netlink ethtool interface, the begin-complete pairs are
> naturally nested e.g. when a request triggers a netlink notification.
> 
> Fortunately, only minority of networking drivers implements begin() and
> complete() callbacks and most of those that do, fall into three groups:
> 
>   - wrappers for pm_runtime_get_sync() and pm_runtime_put()
>   - wrappers for clk_prepare_enable() and clk_disable_unprepare()
>   - begin() checks netif_running() (fails if false), no complete()
> 
> First two have their own refcounting, third is safe w.r.t. nesting of the
> blocks.
> 
> Only three in-tree networking drivers need an update to deal with nesting
> of begin() and complete() calls: via-velocity and epic100 perform resume
> and suspend on their own and wil6210 completely serializes the calls using
> its own mutex (which would lead to a deadlock if a request request
> triggered a netlink notification). The series addresses these problems.
> 
> changes between v1 and v2:
>   - fix inverted condition in epic100 ethtool_begin() (thanks to Andrew
>     Lunn)

Series applied, thanks.

