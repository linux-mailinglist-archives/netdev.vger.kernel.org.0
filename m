Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9169F2DF45
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfE2OIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:08:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:56682 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfE2OIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:08:35 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVzFo-0004yF-Tt; Wed, 29 May 2019 16:08:32 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVzFo-0002sC-K4; Wed, 29 May 2019 16:08:32 +0200
Subject: Re: [PATCH bpf-next v4 1/4] bpf: remove __rcu annotations from
 bpf_prog_array
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, Roman Gushchin <guro@fb.com>
References: <20190528211444.166437-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ee0ed53-dcbd-ca24-94c9-54fb303f1b4c@iogearbox.net>
Date:   Wed, 29 May 2019 16:08:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190528211444.166437-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25464/Wed May 29 09:59:09 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/28/2019 11:14 PM, Stanislav Fomichev wrote:
> Drop __rcu annotations and rcu read sections from bpf_prog_array
> helper functions. They are not needed since all existing callers
> call those helpers from the rcu update side while holding a mutex.
> This guarantees that use-after-free could not happen.
> 
> In the next patches I'll fix the callers with missing
> rcu_dereference_protected to make sparse/lockdep happy, the proper
> way to use these helpers is:
> 
> 	struct bpf_prog_array __rcu *progs = ...;
> 	struct bpf_prog_array *p;
> 
> 	mutex_lock(&mtx);
> 	p = rcu_dereference_protected(progs, lockdep_is_held(&mtx));
> 	bpf_prog_array_length(p);
> 	bpf_prog_array_copy_to_user(p, ...);
> 	bpf_prog_array_delete_safe(p, ...);
> 	bpf_prog_array_copy_info(p, ...);
> 	bpf_prog_array_copy(p, ...);
> 	bpf_prog_array_free(p);
> 	mutex_unlock(&mtx);
> 
> No functional changes! rcu_dereference_protected with lockdep_is_held
> should catch any cases where we update prog array without a mutex
> (I've looked at existing call sites and I think we hold a mutex
> everywhere).
> 
> Motivation is to fix sparse warnings:
> kernel/bpf/core.c:1803:9: warning: incorrect type in argument 1 (different address spaces)
> kernel/bpf/core.c:1803:9:    expected struct callback_head *head
> kernel/bpf/core.c:1803:9:    got struct callback_head [noderef] <asn:4> *
> kernel/bpf/core.c:1877:44: warning: incorrect type in initializer (different address spaces)
> kernel/bpf/core.c:1877:44:    expected struct bpf_prog_array_item *item
> kernel/bpf/core.c:1877:44:    got struct bpf_prog_array_item [noderef] <asn:4> *
> kernel/bpf/core.c:1901:26: warning: incorrect type in assignment (different address spaces)
> kernel/bpf/core.c:1901:26:    expected struct bpf_prog_array_item *existing
> kernel/bpf/core.c:1901:26:    got struct bpf_prog_array_item [noderef] <asn:4> *
> kernel/bpf/core.c:1935:26: warning: incorrect type in assignment (different address spaces)
> kernel/bpf/core.c:1935:26:    expected struct bpf_prog_array_item *[assigned] existing
> kernel/bpf/core.c:1935:26:    got struct bpf_prog_array_item [noderef] <asn:4> *
> 
> v2:
> * remove comment about potential race; that can't happen
>   because all callers are in rcu-update section
> 
> Cc: Roman Gushchin <guro@fb.com>
> Acked-by: Roman Gushchin <guro@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Series applied, thanks!
