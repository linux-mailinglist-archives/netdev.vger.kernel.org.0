Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E831E4FF3
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgE0VRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:17:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgE0VRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 17:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e7tiZMIiYuTbb+03A1KtQnZH+j3s8ttBBXpLw45dAS0=; b=6LlhV+r1K7qAycippK72vCEiPn
        c0NM4ZjQCpKRVzGcyTa9buhlm2plrnI2+LoPj8rGLnzkAaEhBdDOH6GhSkIyt4RSrRmo2k/KhZwHP
        m6wfFs/dCwrLP9yBfZx7nVTzQ9gsQi2SPB1cmp4AI3lsnCf4AM+6SZ+A19c0HtPu+LYk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1je3QV-003SEI-M8; Wed, 27 May 2020 23:17:27 +0200
Date:   Wed, 27 May 2020 23:17:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Jonathan Adams <jwadams@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 0/7] Statsfs: a new ram-based file system for Linux
 kernel statistics
Message-ID: <20200527211727.GB818296@lunn.ch>
References: <20200526110318.69006-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526110318.69006-1-eesposit@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 01:03:10PM +0200, Emanuele Giuseppe Esposito wrote:
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
> 
> Statsfs offers a generic and stable API, allowing any kind of
> directory/file organization and supporting multiple kind of aggregations
> (not only sum, but also average, max, min and count_zero) and data types
> (boolean, unsigned/signed and custom types). The implementation, which is
> a generalization of KVM’s debugfs statistics code, takes care of gathering
> and displaying information at run time; users only need to specify the
> values to be included in each source.
> 
> Statsfs would also be a different mountpoint from debugfs, and would not
> suffer from limited access due to the security lock down patches. Its main
> function is to display each statistics as a file in the desired folder
> hierarchy defined through the API. Statsfs files can be read, and possibly
> cleared if their file mode allows it.
> 
> Statsfs has two main components: the public API defined by
> include/linux/statsfs.h, and the virtual file system which should end up in
> /sys/kernel/stats.
> 

Hi Emanuele

> The API has two main elements, values and sources. Kernel subsystems like
> KVM can use the API to create a source, add child sources/values/aggregates
> and register it to the root source (that on the virtual fs would be
> /sys/kernel/statsfs).

Another issue i see with networking is that statistic counters can be
dynamic. They can come and go. One of the drivers i work on has extra
statistics available when a fibre interface is used, compared to a
copper interface. And this happens at run time. The netlink API has no
problems with this. It is a snapshot of what counters are currently
available. There is no state in the API.

In my humble opinion, networking is unlikely to adopt your approach.
You probably want to look around for other subsystems which have
statistics, and see if you can cover their requirements, and get them
on board.

   Andrew
