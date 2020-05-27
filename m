Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F038B1E3EEC
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgE0K0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:26:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726965AbgE0K0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:26:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590575194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLmHecdMXvzJxUF6krYcms0wLtfzvsnSY2nAlLf6I9s=;
        b=H7XWsds0hIosyOGYhZeHzv/kR4mqrJrQv1TLXT09Kk9NELzFaJF4jp/kUGB05vt6ROYL8P
        y/FrK5KECF+nGAZWDRH0b5pIthYvxrXcNFc0BYTUPFTU83HHpaHgBUDxhUYv3sXFj40UjT
        2fZK/De2yZgYyznXTItyCnryTa5fd/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-auok90AMMGePEQSRSHP-Kw-1; Wed, 27 May 2020 06:26:30 -0400
X-MC-Unique: auok90AMMGePEQSRSHP-Kw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00024835BC2;
        Wed, 27 May 2020 10:26:28 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FA325C1B0;
        Wed, 27 May 2020 10:26:14 +0000 (UTC)
Date:   Wed, 27 May 2020 12:26:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next 1/5] bpf: Handle 8-byte values in DEVMAP and
 DEVMAP_HASH
Message-ID: <20200527122612.579fbb25@carbon>
In-Reply-To: <20200527010905.48135-2-dsahern@kernel.org>
References: <20200527010905.48135-1-dsahern@kernel.org>
        <20200527010905.48135-2-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 19:09:01 -0600
David Ahern <dsahern@kernel.org> wrote:

> Add support to DEVMAP and DEVMAP_HASH to support 8-byte values as a
> <device index, program id> pair. To do this, a new struct is needed in
> bpf_dtab_netdev to hold the values to return on lookup.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  kernel/bpf/devmap.c | 56 ++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 43 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index a51d9fb7a359..95db6d8beebc 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -60,12 +60,22 @@ struct xdp_dev_bulk_queue {
>  	unsigned int count;
>  };
>  
> +/* devmap value can be dev index or dev index + prog fd/id */
> +struct dev_map_ext_val {
> +	u32 ifindex;	/* must be first for compat with 4-byte values */
> +	union {
> +		int prog_fd;  /* prog fd on write */
> +		u32 prog_id;  /* prog id on read */
> +	};
> +};

This smells like a BTF structure.
Andrii BTF does support union's right?


>  struct bpf_dtab_netdev {
>  	struct net_device *dev; /* must be first member, due to tracepoint */
>  	struct hlist_node index_hlist;
>  	struct bpf_dtab *dtab;
>  	struct rcu_head rcu;
>  	unsigned int idx;
> +	struct dev_map_ext_val val;
>  };
>  
>  struct bpf_dtab {
> @@ -108,9 +118,13 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>  	u64 cost = 0;
>  	int err;
>  
> -	/* check sanity of attributes */
> +	/* check sanity of attributes. 2 value sizes supported:
> +	 * 4 bytes: ifindex
> +	 * 8 bytes: ifindex + prog fd
> +	 */
>  	if (attr->max_entries == 0 || attr->key_size != 4 ||
> -	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
> +	    (attr->value_size != 4 && attr->value_size != 8) ||

IMHO we really need to leverage BTF here, as I'm sure we need to do more
extensions, and this size matching will get more and more unmaintainable.

With BTF in place, dumping the map via bpftool, will also make the
fields "self-documenting".

I will try to implement something that uses BTF for this case (and cpumap).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

