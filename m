Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4452848957B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243126AbiAJJmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:42:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49608 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243074AbiAJJmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:42:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7A9961230;
        Mon, 10 Jan 2022 09:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D03DC36AED;
        Mon, 10 Jan 2022 09:42:00 +0000 (UTC)
Date:   Mon, 10 Jan 2022 10:41:58 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] bpf: fix mount source show for bpffs
Message-ID: <20220110094158.pjtc4adxoyujohcf@wittgenstein>
References: <20220108134623.32467-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220108134623.32467-1-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 08, 2022 at 01:46:23PM +0000, Yafang Shao wrote:
> We noticed our tc ebpf tools can't start after we upgrade our in-house
> kernel version from 4.19 to 5.10. That is because of the behaviour change
> in bpffs caused by commit
> d2935de7e4fd ("vfs: Convert bpf to use the new mount API").
> 
> In our tc ebpf tools, we do strict environment check. If the enrioment is
> not match, we won't allow to start the ebpf progs. One of the check is
> whether bpffs is properly mounted. The mount information of bpffs in
> kernel-4.19 and kernel-5.10 are as follows,
> 
> - kenrel 4.19
> $ mount -t bpf bpffs /sys/fs/bpf
> $ mount -t bpf
> bpffs on /sys/fs/bpf type bpf (rw,relatime)
> 
> - kernel 5.10
> $ mount -t bpf bpffs /sys/fs/bpf
> $ mount -t bpf
> none on /sys/fs/bpf type bpf (rw,relatime)
> 
> The device name in kernel-5.10 is displayed as none instead of bpffs,
> then our environment check fails. Currently we modify the tools to adopt to
> the kernel behaviour change, but I think we'd better change the kernel code
> to keep the behavior consistent.
> 
> After this change, the mount information will be displayed the same with
> the behavior in kernel-4.19, for example,
> 
> $ mount -t bpf bpffs /sys/fs/bpf
> $ mount -t bpf
> bpffs on /sys/fs/bpf type bpf (rw,relatime)
> 
> Fixes: d2935de7e4fd ("vfs: Convert bpf to use the new mount API")
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> 
> ---
> v1->v2:
> use the helper vfs_parse_fs_param_source() instead of open-coded (Daniel)
> ---

Looks good,
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
