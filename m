Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9C0432327
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhJRPoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232417AbhJRPoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:44:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6BC260F44;
        Mon, 18 Oct 2021 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634571723;
        bh=plY9CKiofGs0QkpzTRLAqZRAXAqM+ZcTVwgNz5Yezcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WM3Hf3LHiusCJPBU/HQJNTjhrs191xBECi1QayARE6FS7QAendKd3BPH+JOE0xiOj
         5hJMbAiw2M6wNO9tKuoP1ul/15KKA1rYRlbxGz9E7RhsIxW1zGlBGp71nwkQSZi/tj
         tSeSTQEL+Q189zUNWZY8CXXsP9ScklRYgYxHOpwP5YMq+OAMXkVQxbcp54RHXHvQ3f
         irnk+DTuRfLod6y7HpMS4iZ2XC8R7dwCTgebwIdxjmKY6mE05d4b9Dwen0WgfD5MTm
         Xxp9pEfgO1OP23jJ/ta83mUiottAJF7VPN6f9vPNKlkmwpuksmNDgg4MFBZ8ErJMkC
         qf4rP9wltmw4A==
Date:   Mon, 18 Oct 2021 08:42:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>,
        <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <kafai@fb.com>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>,
        <yhs@fb.com>, <toke@toke.dk>, <joamaki@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
Message-ID: <20211018084201.4c7e5be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ygnh5ytubfa4.fsf@nvidia.com>
References: <0000000000005639cd05ce3a6d4d@google.com>
        <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
        <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
        <ygnh5ytubfa4.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 17:04:19 +0300 Vlad Buslov wrote:
> We got a use-after-free with very similar trace [0] during nightly
> regression. The issue happens when ip link up/down state is flipped
> several times in loop and doesn't reproduce for me manually. The fact
> that it didn't reproduce for me after running test ten times suggests
> that it is either very hard to reproduce or that it is a result of some
> interaction between several tests in our suite.
> 
> [0]:
> 
> [ 3187.779569] mlx5_core 0000:08:00.0 enp8s0f0: Link up
>  [ 3187.890694] ==================================================================
>  [ 3187.892518] BUG: KASAN: use-after-free in __list_add_valid+0xc3/0xf0
>  [ 3187.894132] Read of size 8 at addr ffff8881150b3fb8 by task ip/119618

Hm, not sure how similar it is. This one looks like channel was freed
without deleting NAPI. Do you have list debug enabled?
