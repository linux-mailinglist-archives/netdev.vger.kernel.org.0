Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100CB63C4E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfGIT6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:58:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfGIT6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:58:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E1D3140CFF37;
        Tue,  9 Jul 2019 12:58:53 -0700 (PDT)
Date:   Tue, 09 Jul 2019 12:58:50 -0700 (PDT)
Message-Id: <20190709.125850.2133620086434576103.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] vhost: fix null pointer dereference in
 vhost_del_umem_range
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709114251.24662-1-dkirjanov@suse.com>
References: <20190709114251.24662-1-dkirjanov@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 12:58:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Tue,  9 Jul 2019 13:42:51 +0200

> @@ -962,7 +962,8 @@ static void vhost_del_umem_range(struct vhost_umem *umem,
>  
>  	while ((node = vhost_umem_interval_tree_iter_first(&umem->umem_tree,
>  							   start, end)))
> -		vhost_umem_free(umem, node);
> +		if (node)
> +			vhost_umem_free(umem, node);

If 'node' is NULL we will not be in the body of the loop as per
the while() condition.

How did you test this?
