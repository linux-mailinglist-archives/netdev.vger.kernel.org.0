Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126773C5DC
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404633AbfFKIYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:24:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:60938 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404559AbfFKIYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:24:35 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hac50-0006aU-0V; Tue, 11 Jun 2019 10:24:30 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hac4z-000AaS-Qg; Tue, 11 Jun 2019 10:24:29 +0200
Subject: Re: [PATCH v2 bpf] bpf: lpm_trie: check left child of last leftmost
 node for NULL
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, yhs@fb.com,
        ast@kernel.org
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
References: <20190608195419.1137313-1-jonathan.lemon@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c739d394-0267-d032-a1d7-a85aa57d9274@iogearbox.net>
Date:   Tue, 11 Jun 2019 10:24:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190608195419.1137313-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25476/Mon Jun 10 09:55:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/08/2019 09:54 PM, Jonathan Lemon wrote:
> If the leftmost parent node of the tree has does not have a child
> on the left side, then trie_get_next_key (and bpftool map dump) will
> not look at the child on the right.  This leads to the traversal
> missing elements.
> 
> Lookup is not affected.
> 
> Update selftest to handle this case.
> 
> Reproducer:
> 
>  bpftool map create /sys/fs/bpf/lpm type lpm_trie key 6 \
>      value 1 entries 256 name test_lpm flags 1
>  bpftool map update pinned /sys/fs/bpf/lpm key  8 0 0 0  0   0 value 1
>  bpftool map update pinned /sys/fs/bpf/lpm key 16 0 0 0  0 128 value 2
>  bpftool map dump   pinned /sys/fs/bpf/lpm
> 
> Returns only 1 element. (2 expected)
> 
> Fixes: b471f2f1de8 ("bpf: implement MAP_GET_NEXT_KEY command for LPM_TRIE")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied, thanks!
