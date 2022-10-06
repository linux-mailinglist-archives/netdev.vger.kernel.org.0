Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333985F6FCA
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiJFUy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiJFUy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:54:57 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EE91AF19;
        Thu,  6 Oct 2022 13:54:54 -0700 (PDT)
Message-ID: <460e032d-2fac-6afb-bc4b-30c97f2e31e2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665089692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98abMbiKy+fpQWvpcc6vpK2JTxE1CDoK7QLRY8INep0=;
        b=txEv8OOu45UcEab5MCcH3cbOSIXf9CgHeDpqP20f6ierKiTPEF2Ar2I31j/k5Im1m54OYk
        EvheHUgdoZ+HNKXXX28nfkwKdastpCLr30y6aCz7wXIeOH5KhYVbMH9Quw5nA2OSWlThKv
        5/UD5uiqmqJchpHPhOMrP1kyrrbFH/s=
Date:   Thu, 6 Oct 2022 13:54:48 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        john.fastabend@gmail.com, joannelkoong@gmail.com, memxor@gmail.com,
        toke@redhat.com, joe@cilium.io, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221004231143.19190-2-daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 4:11 PM, Daniel Borkmann wrote:
> diff --git a/kernel/bpf/net.c b/kernel/bpf/net.c
> new file mode 100644
> index 000000000000..ab9a9dee615b
> --- /dev/null
> +++ b/kernel/bpf/net.c
> @@ -0,0 +1,274 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2022 Isovalent */
> +
> +#include <linux/bpf.h>
> +#include <linux/filter.h>
> +#include <linux/netdevice.h>
> +
> +#include <net/xtc.h>
> +
> +static int __xtc_prog_attach(struct net_device *dev, bool ingress, u32 limit,
> +			     struct bpf_prog *nprog, u32 prio, u32 flags)
> +{
> +	struct bpf_prog_array_item *item, *tmp;
> +	struct xtc_entry *entry, *peer;
> +	struct bpf_prog *oprog;
> +	bool created;
> +	int i, j;
> +
> +	ASSERT_RTNL();
> +
> +	entry = dev_xtc_entry_fetch(dev, ingress, &created);
> +	if (!entry)
> +		return -ENOMEM;
> +	for (i = 0; i < limit; i++) {
> +		item = &entry->items[i];
> +		oprog = item->prog;
> +		if (!oprog)
> +			break;
> +		if (item->bpf_priority == prio) {
> +			if (flags & BPF_F_REPLACE) {
> +				/* Pairs with READ_ONCE() in xtc_run_progs(). */
> +				WRITE_ONCE(item->prog, nprog);
> +				bpf_prog_put(oprog);
> +				dev_xtc_entry_prio_set(entry, prio, nprog);
> +				return prio;
> +			}
> +			return -EBUSY;
> +		}
> +	}
> +	if (dev_xtc_entry_total(entry) >= limit)
> +		return -ENOSPC;
> +	prio = dev_xtc_entry_prio_new(entry, prio, nprog);
> +	if (prio < 0) {
> +		if (created)
> +			dev_xtc_entry_free(entry);
> +		return -ENOMEM;
> +	}
> +	peer = dev_xtc_entry_peer(entry);
> +	dev_xtc_entry_clear(peer);
> +	for (i = 0, j = 0; i < limit; i++, j++) {
> +		item = &entry->items[i];
> +		tmp = &peer->items[j];
> +		oprog = item->prog;
> +		if (!oprog) {
> +			if (i == j) {
> +				tmp->prog = nprog;
> +				tmp->bpf_priority = prio;
> +			}
> +			break;
> +		} else if (item->bpf_priority < prio) {
> +			tmp->prog = oprog;
> +			tmp->bpf_priority = item->bpf_priority;
> +		} else if (item->bpf_priority > prio) {
> +			if (i == j) {
> +				tmp->prog = nprog;
> +				tmp->bpf_priority = prio;
> +				tmp = &peer->items[++j];
> +			}
> +			tmp->prog = oprog;
> +			tmp->bpf_priority = item->bpf_priority;
> +		}
> +	}
> +	dev_xtc_entry_update(dev, peer, ingress);
> +	if (ingress)
> +		net_inc_ingress_queue();
> +	else
> +		net_inc_egress_queue();
> +	xtc_inc();
> +	return prio;
> +}
> +
> +int xtc_prog_attach(const union bpf_attr *attr, struct bpf_prog *nprog)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	bool ingress = attr->attach_type == BPF_NET_INGRESS;
> +	struct net_device *dev;
> +	int ret;
> +
> +	if (attr->attach_flags & ~BPF_F_REPLACE)
> +		return -EINVAL;

After looking at patch 3, I think it needs to check the attach_priority is non 
zero when BPF_F_REPLACE is set.

Then the __xtc_prog_attach() should return -ENOENT for BPF_F_REPLACE when prio 
is not found instead of continuing to dev_xtc_entry_prio_new().

However, all these probably could go away if the decision on the prio discussion 
is to avoid it.


> +	rtnl_lock();
> +	dev = __dev_get_by_index(net, attr->target_ifindex);
> +	if (!dev) {
> +		rtnl_unlock();
> +		return -EINVAL;
> +	}
> +	ret = __xtc_prog_attach(dev, ingress, XTC_MAX_ENTRIES, nprog,
> +				attr->attach_priority, attr->attach_flags);
> +	rtnl_unlock();
> +	return ret;
> +}
> +

