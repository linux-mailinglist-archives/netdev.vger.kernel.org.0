Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1F11E3297
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392120AbgEZWbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389482AbgEZWbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:31:33 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9454F20899;
        Tue, 26 May 2020 22:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590532292;
        bh=i/LsJ/7HDxl1uraGohIpTv1UEEpLZgqDBmcvFSkYrRs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L1hQtRDvn7ylGIClnE51U8xDbKeptk9RRRcxjD8KvV0vnGtqXOx6okqH3wGQU2F4s
         AMxHim9tkh3trTRi+/Dihhe2jPHiIQ7YHpjVMePw/F7mtxQxe5ipm41gvPbE0O1/f+
         WqWQhzzVJGfznE1VeNIwnVlo+h9/gVYBJXg1JpOk=
Date:   Tue, 26 May 2020 15:31:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Statsfs: a new ram-based file system for Linux
 kernel statistics
Message-ID: <20200526153128.448bfb43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200526110318.69006-1-eesposit@redhat.com>
References: <20200526110318.69006-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 13:03:10 +0200 Emanuele Giuseppe Esposito wrote:
> There is currently no common way for Linux kernel subsystems to expose
> statistics to userspace shared throughout the Linux kernel; subsystems have
> to take care of gathering and displaying statistics by themselves, for
> example in the form of files in debugfs. For example KVM has its own code
> section that takes care of this in virt/kvm/kvm_main.c, where it sets up
> debugfs handlers for displaying values and aggregating them from various
> subfolders to obtain information about the system state (i.e. displaying
> the total number of exits, calculated by summing all exits of all cpus of
> all running virtual machines).
> 
> Allowing each section of the kernel to do so has two disadvantages. First,
> it will introduce redundant code. Second, debugfs is anyway not the right
> place for statistics (for example it is affected by lockdown)
> 
> In this patch series I introduce statsfs, a synthetic ram-based virtual
> filesystem that takes care of gathering and displaying statistics for the
> Linux kernel subsystems.
> 
> The file system is mounted on /sys/kernel/stats and would be already used
> by kvm. Statsfs was initially introduced by Paolo Bonzini [1].

What's the direct motivation for this work? Moving KVM stats out of
debugfs?

In my experience stats belong in the API used for creating/enumerating
objects, statsfs sounds like going in the exact opposite direction -
creating a parallel structure / hierarchy for exposing stats. I know
nothing about KVM but are you sure all the info that has to be exposed
will be stats?

In case of networking we have the basic stats in sysfs, under the
netdevice's kobject. But since we're not using sysfs much any more 
for config, new stats are added in netlink APIs. Again - same APIs
used for enumeration and config.

