Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E94827B535
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgI1TZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:25:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:46420 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgI1TZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:25:13 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kMylm-0000bz-3J; Mon, 28 Sep 2020 21:25:06 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kMyll-000Ji3-Qu; Mon, 28 Sep 2020 21:25:05 +0200
Subject: Re: [PATCH bpf-next] xsk: fix possible crash in socket_release when
 out-of-memory
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
References: <1601112373-10595-1-git-send-email-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c43d8022-362c-3d6f-89dc-a1ef183f77fb@iogearbox.net>
Date:   Mon, 28 Sep 2020 21:25:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1601112373-10595-1-git-send-email-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25941/Mon Sep 28 15:55:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/20 11:26 AM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix possible crash in socket_release when an out-of-memory error has
> occurred in the bind call. If a socket using the XDP_SHARED_UMEM flag
> encountered an error in xp_create_and_assign_umem, the bind code
> jumped to the exit routine but erroneously forgot to set the err value
> before jumping. This meant that the exit routine thought the setup
> went well and set the state of the socket to XSK_BOUND. The xsk socket
> release code will then, at application exit, think that this is a
> properly setup socket, when it is not, leading to a crash when all
> fields in the socket have in fact not been initialized properly. Fix
> this by setting the err variable in xsk_bind so that the socket is not
> set to XSK_BOUND which leads to the clean-up in xsk_release not being
> triggered.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: syzbot+ddc7b4944bc61da19b81@syzkaller.appspotmail.com
> Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")

Looks good either way, applied, thanks!

> I have not been able to reproduce this issue using the syzkaller
> config and reproducer, so I cannot guarantee it fixes it. But this bug
> is real and it is triggered by an out-of-memory in
> xp_create_and_assign_umem, just like syzcaller injects, and would lead
> to the same crash in dev_hold in xsk_release.

You can just asked syzbot (which I just did on the original report) via:

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master

Thanks,
Daniel
