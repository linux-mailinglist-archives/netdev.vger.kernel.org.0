Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC04146940
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgAWNhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:37:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29074 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726240AbgAWNhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579786662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/mKKFH0Pgl6eS/j/YSBbgLp/TGqqZwcT4ZYT6DqoVE=;
        b=ehfZwprk0j1lEJz4juilZedVKzN146EAVxRRqQehD2Tfb3OGMGmCjXJr0I+IFQEgHMe5Eg
        heFKqpzhXGXdwfl9gpIzMK/fGtyRaY5En8B++uub1ZJforNmrPBNbkFzDMEip4/9122x7t
        UPLbJaxwgdjdw/J1mmOePcAlON23t7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-RmPa_-kPPlyz1GZ6KM_CTA-1; Thu, 23 Jan 2020 08:37:37 -0500
X-MC-Unique: RmPa_-kPPlyz1GZ6KM_CTA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96BAE800D48;
        Thu, 23 Jan 2020 13:37:34 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40B737C42C;
        Thu, 23 Jan 2020 13:37:26 +0000 (UTC)
Date:   Thu, 23 Jan 2020 14:37:25 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Amol Grover <frextrite@gmail.com>
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] bpf: devmap: Pass lockdep expression to RCU lists
Message-ID: <20200123143725.036140e7@carbon>
In-Reply-To: <20200123120437.26506-1-frextrite@gmail.com>
References: <20200123120437.26506-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 17:34:38 +0530
Amol Grover <frextrite@gmail.com> wrote:

> head is traversed using hlist_for_each_entry_rcu outside an
> RCU read-side critical section but under the protection
> of dtab->index_lock.

We do hold the lock in update and delete cases, but not in the lookup
cases.  Is it then still okay to add the lockdep_is_held() annotation?

If it is then it looks fine to me:

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
 
> Hence, add corresponding lockdep expression to silence false-positive
> lockdep warnings, and harden RCU lists.
> 
> Signed-off-by: Amol Grover <frextrite@gmail.com>
> ---
>  kernel/bpf/devmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 3d3d61b5985b..b4b6b77f309c 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -293,7 +293,8 @@ struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
>  	struct hlist_head *head = dev_map_index_hash(dtab, key);
>  	struct bpf_dtab_netdev *dev;
>  
> -	hlist_for_each_entry_rcu(dev, head, index_hlist)
> +	hlist_for_each_entry_rcu(dev, head, index_hlist,
> +				 lockdep_is_held(&dtab->index_lock))
>  		if (dev->idx == key)
>  			return dev;
>  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

