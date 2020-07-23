Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85C522B3CE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGWQmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWQmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 12:42:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6815120714;
        Thu, 23 Jul 2020 16:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595522558;
        bh=lcKz/REf2sXjrKHkM+LLrKL/Ao4IRSYfvziQUWZKI7A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cw4dnIomW5Yk8XUxXxMv/C+YcEbafzCsNsju27Xep1ERnkZIgsp9jPPnL+5NuI5c4
         VrPZpn7q060e7DUu+1wWY4sQIP5Ahw5wsFNzq8CTNZndkhYMV8P8g0oPl/dRb10PYl
         cDHYLrXI+0cmBrIz0fAkKHMijrRss+V0KrYplsoA=
Date:   Thu, 23 Jul 2020 09:42:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pabeni@redhat.com, pshelar@ovn.org, fw@strlen.de
Subject: Re: [PATCH net-next v2 2/2] net: openvswitch: make masks cache size
 configurable
Message-ID: <20200723094236.04d82921@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <159550911106.849915.7304995736710705589.stgit@ebuild>
References: <159550903978.849915.17042128332582130595.stgit@ebuild>
        <159550911106.849915.7304995736710705589.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jul 2020 14:58:31 +0200 Eelco Chaudron wrote:
> +	if ((size & (size - 1)) != 0 ||

is_power_of_2() ?

> +	    (size * sizeof(struct mask_cache_entry)) > PCPU_MIN_UNIT_SIZE)
> +		return NULL;

> +	new->cache_size = size;
> +	if (new->cache_size > 0) {
> +		cache = __alloc_percpu(sizeof(struct mask_cache_entry) *
> +				       new->cache_size,

array_size() ?

> +				       __alignof__(struct mask_cache_entry));
> +

No need for the new line here

> +		if (!cache) {
> +			kfree(new);
> +			return NULL;
> +		}
> +	}

> +	if (size == mc->cache_size || (size & (size - 1)) != 0)

why check "is power of 2" twice?

> @@ -454,7 +516,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
>  	struct table_instance *ti = rcu_dereference_raw(table->ti);
>  	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
>  
> -	free_percpu(table->mask_cache);
> +	call_rcu(&table->mask_cache->rcu, mask_cache_rcu_cb);
>  	call_rcu(&table->mask_array->rcu, mask_array_rcu_cb);
>  	table_instance_destroy(table, ti, ufid_ti, false);
>  }

This adds a new warning :(

net/openvswitch/flow_table.c:519:24: warning: incorrect type in argument 1 (different address spaces)
net/openvswitch/flow_table.c:519:24:    expected struct callback_head *head
net/openvswitch/flow_table.c:519:24:    got struct callback_head [noderef] __rcu *
