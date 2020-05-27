Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B961E5083
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387696AbgE0V1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgE0V1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 17:27:45 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BB422078C;
        Wed, 27 May 2020 21:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590614864;
        bh=HUaCb3PCCc2Pw/hRjP9hPvQCIfIdC6bqDipqt+IXdOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e27RQsyjYiPcLJYK/eWYlxTA6Bn/y9CgNn3E+9GG9h7m/a5G1frb/+wAOfPx/3NE5
         gAW7R0FZcXgWATLm2Kr9E7RUabkNwvrP/VCkwQjepQzJGb/QKMmOyRYKTiSGdUTuRr
         2S31ZwxZjPaH1lEr34iVlwoqokOeCs+hilL79l5o=
Date:   Wed, 27 May 2020 14:27:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 0/7] Statsfs: a new ram-based file system for Linux
 kernel statistics
Message-ID: <20200527142741.77e7de37@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <af2ba926-73bc-26c3-7ce7-bd45f657fd85@redhat.com>
References: <20200526110318.69006-1-eesposit@redhat.com>
        <20200526153128.448bfb43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <6a754b40-b148-867d-071d-8f31c5c0d172@redhat.com>
        <20200527132321.54bcdf04@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <af2ba926-73bc-26c3-7ce7-bd45f657fd85@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 23:07:53 +0200 Paolo Bonzini wrote:
> > Again, I have little KVM knowledge, but BPF also uses a fd-based API,
> > and carries stats over the same syscall interface.  
> 
> Can BPF stats (for BPF scripts created by whatever process is running in
> the system) be collected by an external daemon that does not have access
> to the file descriptor?  For KVM it's of secondary importance to gather
> stats in the program; it can be nice to have and we are thinking of a
> way to export the stats over the fd-based API, but it's less useful than
> system-wide monitoring.  Perhaps this is a difference between the two.

Yes, check out bpftool prog list (bpftool code is under tools/bpf/ in
the kernel tree). BPF statistics are under a static key, so you may not
see any on your system. My system shows e.g.:

81: kprobe  name abc  tag cefaa9376bdaae75  gpl run_time_ns 80941 run_cnt 152
	loaded_at 2020-05-26T13:00:24-0700  uid 0
	xlated 512B  jited 307B  memlock 4096B  map_ids 66,64
	btf_id 16

In this example run_time_ns and run_cnt are stats.

The first number on the left is the program ID. BPF has an IDA, and
each object gets an integer id. So admin (or CAP_BPF, I think) can
iterate over the ids and open fds to objects of interest.

> Another case where stats and configuration are separate is CPUs, where
> CPU enumeration is done in sysfs but statistics are exposed in various
> procfs files such as /proc/interrupts and /proc/stats.

True, but I'm guessing everyone is just okay living with the legacy
procfs format there. Otherwise I'd guess the stats would had been added
to sysfs. I'd be curious to hear the full story there.
