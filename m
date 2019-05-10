Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598FD1A531
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 00:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfEJWUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 18:20:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58812 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbfEJWUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 18:20:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 619BA133E975E;
        Fri, 10 May 2019 15:20:09 -0700 (PDT)
Date:   Fri, 10 May 2019 15:20:08 -0700 (PDT)
Message-Id: <20190510.152008.1902268386064871188.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH v2 2/8] vsock/virtio: free packets during the socket
 release
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190510125843.95587-3-sgarzare@redhat.com>
References: <20190510125843.95587-1-sgarzare@redhat.com>
        <20190510125843.95587-3-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 May 2019 15:20:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Fri, 10 May 2019 14:58:37 +0200

> @@ -827,12 +827,20 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
>  
>  void virtio_transport_release(struct vsock_sock *vsk)
>  {
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	struct virtio_vsock_buf *buf;
>  	struct sock *sk = &vsk->sk;
>  	bool remove_sock = true;
>  
>  	lock_sock(sk);
>  	if (sk->sk_type == SOCK_STREAM)
>  		remove_sock = virtio_transport_close(vsk);
> +	while (!list_empty(&vvs->rx_queue)) {
> +		buf = list_first_entry(&vvs->rx_queue,
> +				       struct virtio_vsock_buf, list);

Please use list_for_each_entry_safe().
