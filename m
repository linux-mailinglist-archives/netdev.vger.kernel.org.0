Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D0BD2AA
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 21:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410100AbfIXTas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 15:30:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:32369 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410069AbfIXTar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 15:30:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 12:30:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,545,1559545200"; 
   d="scan'208";a="218741009"
Received: from msuckert-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.38.73])
  by fmsmga002.fm.intel.com with ESMTP; 24 Sep 2019 12:30:44 -0700
Subject: Re: [PATCH net] bpf/xskmap: Return ERR_PTR for failure case instead
 of NULL.
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, daniel@iogearbox.net,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@fb.com, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        syzkaller-bugs@googlegroups.com,
        syzbot+491c1b7565ba9069ecae@syzkaller.appspotmail.com
References: <20190924162521.1630419-1-jonathan.lemon@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <5f85df65-0f2e-3533-9734-147b0734e254@intel.com>
Date:   Tue, 24 Sep 2019 21:30:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924162521.1630419-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-24 18:25, Jonathan Lemon wrote:
> When kzalloc() failed, NULL was returned to the caller, which
> tested the pointer with IS_ERR(), which didn't match, so the
> pointer was used later, resulting in a NULL dereference.
> 
> Return ERR_PTR(-ENOMEM) instead of NULL.
> 
> Reported-by: syzbot+491c1b7565ba9069ecae@syzkaller.appspotmail.com
> Fixes: 0402acd683c6 ("xsk: remove AF_XDP socket from map when the socket is released")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Thanks Jonathan! You beat me to it! :-P

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> ---
>   kernel/bpf/xskmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index 942c662e2eed..82a1ffe15dfa 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -37,7 +37,7 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
>   
>   	node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
>   	if (!node)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>   
>   	err = xsk_map_inc(map);
>   	if (err) {
> 
