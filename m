Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970B019E648
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 17:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDDPww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 11:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgDDPww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Apr 2020 11:52:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1464B206E6;
        Sat,  4 Apr 2020 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586015571;
        bh=4H9E3gSuaSn9uvkor1QWgps9xa/Z1XpQlQv7xa0Zgvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P2KHYR5dHl0VliFsumjMid349+Sxr5PqUgBgdbfynunDxuc7rZVIYrDV8i/wSX0En
         YtZCD9pdP5pQ1s8EF6w+I2qvd1oXzgRwryuq0ak3hCFVFPxPaAqCPFAjAJcXP5r2nx
         D4qdNGjUMrlsunYcL3wH6kX1tm4IQY/cnmqh7gk8=
Date:   Sat, 4 Apr 2020 17:52:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mitch.a.williams@intel.com
Subject: Re: [PATCH net v2 3/3] net: core: avoid warning in
 dev_change_net_namespace()
Message-ID: <20200404155247.GE1476305@kroah.com>
References: <20200404141922.26492-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404141922.26492-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 04, 2020 at 02:19:22PM +0000, Taehee Yoo wrote:
> When interface's namespace is being changed, dev_change_net_namespace()
> is called. This removes and re-allocates many resources that include
> sysfs files. The "/net/class/net/<interface name>" is one of them.
> If the sysfs creation routine(device_rename()) found duplicate sysfs
> file name, it warns about it and fails. But unfortunately, at that point,
> dev_change_net_namespace() doesn't return fail because rollback cost
> is too high.
> So, the interface can't have a sysfs file.

Why don't you check for a duplicate namespace before you do anything
like mess with sysfs?  Wouldn't that be the correct thing instead of
trying to paper over the issue by having sysfs be the thing to tell you
not to do this or not?

> The approach of this patch is to find the duplicate sysfs file as
> fast as possible. If it found that, dev_change_net_namespace() returns
> fail immediately with zero rollback cost.

Don't rely on sysfs to save you from this race condition, it's not the
way to do it at all.

greg k-h
