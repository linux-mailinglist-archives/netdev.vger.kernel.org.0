Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BD62D60F9
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403935AbgLJQEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:04:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:36774 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403916AbgLJQDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 11:03:49 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1knOPF-000CU5-Ju; Thu, 10 Dec 2020 17:03:01 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1knOPF-000FHo-Cc; Thu, 10 Dec 2020 17:03:01 +0100
Subject: Re: [PATCH bpf-next] samples/bpf: fix possible hang in xdpsock with
 multiple threads
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com
References: <20201210153645.21286-1-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a41f3859-e541-3fba-9b8b-874da86de92d@iogearbox.net>
Date:   Thu, 10 Dec 2020 17:03:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201210153645.21286-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26014/Thu Dec 10 15:21:42 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/20 4:36 PM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a possible hang in xdpsock that can occur when using multiple
> threads. In this case, one or more of the threads might get stuck in
> the while-loop in tx_only after the user has signaled the main thread
> to stop execution. In this case, no more Tx packets will be sent, so a
> thread might get stuck in the aforementioned while-loop. Fix this by
> introducing a test inside the while-loop to check if the benchmark has
> been terminated. If so, exit the loop.
> 
> Fixes: cd9e72b6f210 ("samples/bpf: xdpsock: Add option to specify batch size")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

With the patch applied, I'm getting a new warning:

   CC  /home/darkstar/trees/bpf-next/samples/bpf/xdpsock_user.o
/home/darkstar/trees/bpf-next/samples/bpf/xdpsock_user.c: In function ‘main’:
/home/darkstar/trees/bpf-next/samples/bpf/xdpsock_user.c:1272:6: warning: ‘idx’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  1272 |  u32 idx;
       |      ^~~

Previously compiling w/o issues:

  [...]
   CC  /home/darkstar/trees/bpf-next/samples/bpf/xdpsock_ctrl_proc.o
   CC  /home/darkstar/trees/bpf-next/samples/bpf/xdpsock_user.o
   CC  /home/darkstar/trees/bpf-next/samples/bpf/xsk_fwd.o
   LD  /home/darkstar/trees/bpf-next/samples/bpf/fds_example
  [...]

For testing, I used:

   gcc --version
   gcc (GCC) 9.0.1 20190312 (Red Hat 9.0.1-0.10)

Ptal, thx!
