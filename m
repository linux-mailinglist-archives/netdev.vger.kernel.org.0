Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C33ED9B16
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388648AbfJPUJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:09:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59718 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbfJPUJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:09:44 -0400
Received: from fsav305.sakura.ne.jp (fsav305.sakura.ne.jp [153.120.85.136])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x9GK9FuP069596;
        Thu, 17 Oct 2019 05:09:15 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav305.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav305.sakura.ne.jp);
 Thu, 17 Oct 2019 05:09:15 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav305.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x9GK991E069577
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Thu, 17 Oct 2019 05:09:15 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH bpf] xdp: Handle device unregister for devmap_hash map
 type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20191016132802.2760149-1-toke@redhat.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <2d516208-8c46-707c-4484-4547e66fc128@i-love.sakura.ne.jp>
Date:   Thu, 17 Oct 2019 05:09:07 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016132802.2760149-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/16 22:28, Toke Høiland-Jørgensen wrote:
> It seems I forgot to add handling of devmap_hash type maps to the device
> unregister hook for devmaps. This omission causes devices to not be
> properly released, which causes hangs.
> 
> Fix this by adding the missing handler.
> 
> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Well, regarding 6f9d451ab1a3, I think that we want explicit "(u64)" cast

@@ -97,6 +123,14 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
        cost = (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
        cost += sizeof(struct list_head) * num_possible_cpus();

+       if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
+               dtab->n_buckets = roundup_pow_of_two(dtab->map.max_entries);
+
+               if (!dtab->n_buckets) /* Overflow check */
+                       return -EINVAL;
+               cost += sizeof(struct hlist_head) * dtab->n_buckets;

                                                    ^here

+       }
+
        /* if map size is larger than memlock limit, reject it */
        err = bpf_map_charge_init(&dtab->map.memory, cost);
        if (err)

like "(u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *)" does.
Otherwise, on 32bits build, "sizeof(struct hlist_head) * dtab->n_buckets" can become 0.

----------
#include <stdio.h>
#include <linux/types.h>

int main(int argc, char *argv[])
{
        volatile __u32 i = 4294967296ULL / sizeof(unsigned long *);
        volatile __u64 cost = sizeof(unsigned long *) * i;

        printf("cost=%llu\n", (unsigned long long) cost);
        return 0;
}
----------
