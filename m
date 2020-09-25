Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB36278CC1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgIYPcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgIYPb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 11:31:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61AB420878;
        Fri, 25 Sep 2020 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601047919;
        bh=NYSTQANqTefZwIlOLqABGURL8HFhAnFbZz2Qk4IxoLg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2f1Ca98HqvPxja+Pqr4Ft6TrZIya6UACxQSKL776YaJY1lwVQkykTdiAmXUMbpMwW
         qQzhgb6sUGXSBeys+3tfG8stkOdsOzU6QAlQdGfs1y+sPwfFd0dwmzCKcJfU9krpoa
         WxRT5i5D3Z/7g0z2UDGqau0y41iVHpptH+wv8SGY=
Date:   Fri, 25 Sep 2020 08:31:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/6] bpf, net: rework cookie generator as
 per-cpu one
Message-ID: <20200925083157.21df654d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c9fee768-4f35-e596-001b-2e2a0e4f48a1@gmail.com>
References: <cover.1600967205.git.daniel@iogearbox.net>
        <d4150caecdbef4205178753772e3bc301e908355.1600967205.git.daniel@iogearbox.net>
        <e854149f-f3a6-a736-9d33-08b2f60eb3a2@gmail.com>
        <dc5dd027-256d-598a-2f89-a45bb30208f8@iogearbox.net>
        <20200925080020.013165a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c9fee768-4f35-e596-001b-2e2a0e4f48a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 17:15:17 +0200 Eric Dumazet wrote:
> On 9/25/20 5:00 PM, Jakub Kicinski wrote:
> > Is this_cpu_inc() in itself atomic?

To answer my own question - it is :)

> >                     unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0))
> > 
> > Can we reasonably assume we won't have more than 4k CPUs and just
> > statically divide this space by encoding CPU id in top bits?  
> 
> This might give some food to side channel attacks, since this would
> give an indication of cpu that allocated the id.
> 
> Also, I hear that some distros enabled 8K cpus.

Ok :(
