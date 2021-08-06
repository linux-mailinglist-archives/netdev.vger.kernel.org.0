Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32F83E320A
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245670AbhHFXKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhHFXKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 19:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA0DA61181;
        Fri,  6 Aug 2021 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628291405;
        bh=zpAvAegheNbvidt1OlQCsnlSHqMtKXL7j1rVL2Usmw0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bz7SOizxksh/T177p6ds9j8/6Da2OREyVOrPyJwIAZPupZwH3je1RnhjMkJQ8XJ17
         zw5q3XmVnlrHsV9l/2Po0zkm6Hu6bV2wWi9WfLOl2kvmhfvtrLExu+zFadfDB+85u3
         qajtF45kq9/ZOF+HeUQVEqoj+WLznmbuUWWiGHAG99c9UapAMLGDd1qVaV1Do3pSJe
         iqI3DaTS3ok628o3bXOEuVrH2rYMwSdyXO8FXl0qVRD+aL7n4WeZKcLfH5xJiYk8sT
         qT9nwXvbH43zpFiKhM6n8H/QOnH9Yh1rXAsQq/evcMSIbwIpj9+PqcoYcuzDFXeD95
         qIX92dQ6qeK3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEBC560A7C;
        Fri,  6 Aug 2021 23:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] bpf: Fix integer overflow involving bucket_size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162829140571.10198.14853046999783152739.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 23:10:05 +0000
References: <20210806150419.109658-1-th.yasumatsu@gmail.com>
In-Reply-To: <20210806150419.109658-1-th.yasumatsu@gmail.com>
To:     Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Sat,  7 Aug 2021 00:04:18 +0900 you wrote:
> In __htab_map_lookup_and_delete_batch(), hash buckets are iterated over
> to count the number of elements in each bucket (bucket_size).
> If bucket_size is large enough, the multiplication to calculate
> kvmalloc() size could overflow, resulting in out-of-bounds write
> as reported by KASAN.
> 
> [...]
> [  104.986052] BUG: KASAN: vmalloc-out-of-bounds in __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.986489] Write of size 4194224 at addr ffffc9010503be70 by task crash/112
> [  104.986889]
> [  104.987193] CPU: 0 PID: 112 Comm: crash Not tainted 5.14.0-rc4 #13
> [  104.987552] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [  104.988104] Call Trace:
> [  104.988410]  dump_stack_lvl+0x34/0x44
> [  104.988706]  print_address_description.constprop.0+0x21/0x140
> [  104.988991]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.989327]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.989622]  kasan_report.cold+0x7f/0x11b
> [  104.989881]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.990239]  kasan_check_range+0x17c/0x1e0
> [  104.990467]  memcpy+0x39/0x60
> [  104.990670]  __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.990982]  ? __wake_up_common+0x4d/0x230
> [  104.991256]  ? htab_of_map_free+0x130/0x130
> [  104.991541]  bpf_map_do_batch+0x1fb/0x220
> [...]
> 
> [...]

Here is the summary with links:
  - [v2] bpf: Fix integer overflow involving bucket_size
    https://git.kernel.org/bpf/bpf/c/ccd37ad9ef0a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


