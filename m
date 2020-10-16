Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D535C290C2E
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 21:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393100AbgJPTV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 15:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393095AbgJPTV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 15:21:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD86A20EDD;
        Fri, 16 Oct 2020 19:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602876089;
        bh=P+ivZQj1Yqwh0eMrFuoEe9IMBcx15gCBiKv4vonI4dw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U6ELHr8aNe6X5y8IN03MaGd83m4ZLTdJE7oEepvo0C+a6dOF7YoaLZT34mmMIC0/C
         2yxIK+hEYivvhyXjKi9hfh8K3GXKXXB6tQ5iuCos+oPkj1egTXOrDA+UAcaXm7Kbh5
         jYsnFANl+CX5Sisf5Z5fXYN7iC9uI44LwoW09Ie8=
Date:   Fri, 16 Oct 2020 12:21:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     jeffrey.t.kirsher@intel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: ixgbe - only presenting one out of four interfaces on 5.9
Message-ID: <20201016122122.0a70f5a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAA85sZs9wswn06hd7ien2B_fyqFM9kEWL_-vXQN-sjhqisizaQ@mail.gmail.com>
References: <CAA85sZv=13q8NXbjdf7+R=wu0Q5=Vj9covZ24e9Ew2DCd7S==A@mail.gmail.com>
        <CAA85sZs9wswn06hd7ien2B_fyqFM9kEWL_-vXQN-sjhqisizaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 11:35:15 +0200 Ian Kumlien wrote:
> Adding netdev, someone might have a clue of what to look at...
> 
> On Mon, Oct 12, 2020 at 9:20 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> >
> > Hi,
> >
> > I was really surprised when i rebooted my firewall and there was
> > network issues, I was even more surprised when
> > only one of the four ports of my ixbe (x553) nic was available when booted.

Just to be sure you mean that the 3 devices are not present in ip link
show?

> > You can actually see it dmesg... And i tried some basic looking at
> > changes to see if it was obvious.... but..

Showing a full dmesg may be helpful, but looking at what you posted it
seems like the driver gets past the point where netdev gets registered,
so the only thing that could fail after that point AFIACT is
mdiobus_register(). Could be some breakage in MDIO.

Any chance you could fire up perf, bpftrace and install a kretprobe to
see what mdiobus_register() returns? You can rebind the device to the
driver through sysfs.
