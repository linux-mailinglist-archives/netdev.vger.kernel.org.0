Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBADB29525D
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410722AbgJUShd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410699AbgJUShc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 14:37:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D07208C3;
        Wed, 21 Oct 2020 18:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603305451;
        bh=xJUD+N/tMikuaabrYU4MCYK1lt5BudWt4GBs7R0omgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DFIpbQTzU+NA/cLExEQ4xQ19/2BsD7Ng5TZZsOvhmIZZ6W6YyzDrKEdDeThgjiirt
         WTyqDmcgGQW3YipgxjIaj8tmimxKO1M0D5p3DBWzwWtmLt3OPh98tkv6dpE/BljN5r
         akyyX2DjkoBCI8ByHHQrW9UHA5x2QZwS7tUTH7bg=
Date:   Wed, 21 Oct 2020 11:37:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Jarod Wilson <jarod@redhat.com>
Subject: Re: [Bug 209767] New: Bonding 802.3ad layer2+3 transmits on both
 slaves within single connection
Message-ID: <20201021113729.4d4eeffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020075429.291c34bb@hermes.local>
References: <20201020075429.291c34bb@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC some bonding folks

On Tue, 20 Oct 2020 07:54:29 -0700 Stephen Hemminger wrote:
> Begin forwarded message:
> 
> Date: Tue, 20 Oct 2020 10:42:34 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 209767] New: Bonding 802.3ad layer2+3 transmits on both slaves within single connection
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=209767
> 
>             Bug ID: 209767
>            Summary: Bonding 802.3ad layer2+3 transmits on both slaves
>                     within single connection
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.8.11-1.el8.elrepo.x86_64 and
>                     3.10.0-1127.19.1.el7.x86_64
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: onno.zweers@surf.nl
>         Regression: No
> 
> Dear people,
> 
> I'm seeing bonding behavior I don't understand and neither do several network
> experts I've consulted.
> 
> We have two servers, both with two 25 Gbit interfaces in a bond (802.3ad with
> layer2+3 hashing). We tuned the systems according to
> https://fasterdata.es.net/host-tuning/linux/. I run `iperf3 --server` on server
> 1 and connect to it with `iperf3 --client server1` from server 2. We notice
> that sometimes the connection is good (24.7 Gbit/s, no retransmits) and
> sometimes there are many retransmits (sometimes as many as >30,000 in a 10
> second run) and then the bandwidth may drop to 15 Gbit/s or even lower. The
> servers are idle except for the iperf3 runs. When we bring down one slave on
> server 1, the result is always perfect; no retransmits and good throughput.
> 
> We have captured traffic with tcpdump on server 1 at the slave level (I'll try
> to add the pcap files). To our surprise, we see that the data channel ACK
> packets are sometimes sent over one slave and sometimes over the other. We
> think this causes packet misordering in the network switches, and thus
> retransmits and loss of bandwidth.
> 
> Our understanding of layer2+3 hashing is that for a single connection, all
> traffic should go over the same slave. Therefore, we don't understand why
> server 1 sends ACK packets out over both slaves.
> 
> I've read the documentation at
> https://www.kernel.org/doc/Documentation/networking/bonding.txt but I couldn't
> find the observed behaviour explained there.
> 
> We have tested several Centos 7 and Centos 8 kernels, including recent elrepo
> kernels, but all show this behaviour. We have tried teaming instead of bonding
> but it has the same behaviour. We have tried other hashing algorithms like
> layer3+4 but they seem to have the same issue. It occurs with both IPv4 and
> IPv6.
> 
> Is this behaviour to be expected? If yes, is it documented anywhere? Will it
> degrade throughput in real life traffic (with multiple concurrent data
> streams)?
> If the behaviour is not expected, are we doing something wrong, or might it be
> a bug?
> 
> Thanks,
> Onno
> 

