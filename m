Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B7613727C
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgAJQIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:08:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42934 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728594AbgAJQIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 11:08:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578672518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vDJkiqYoLVts1s0YKct62CR2aPtFmE+HM3i87sBNnmw=;
        b=R2pJ02sJDfD4e0S39Bas7qkBbHwqlJ1WJUy8rPBurPQ4E2/XnOoBEph3kI/DjXGAsBLi/P
        Dk/ZS0mBZ1iW+6MdW4i1lEAjC/wkzhjmZdBlApKZd09ciygBMFWBUo0POqmbgn30cx9zTK
        R2QGc9BfuqYYe263ynmwmMTdys7HrDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-O3a4WS5-PrWDgLpJZYMgUw-1; Fri, 10 Jan 2020 11:08:36 -0500
X-MC-Unique: O3a4WS5-PrWDgLpJZYMgUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55409477;
        Fri, 10 Jan 2020 16:08:34 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ADBD7C382;
        Fri, 10 Jan 2020 16:08:25 +0000 (UTC)
Date:   Fri, 10 Jan 2020 17:08:24 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next 1/2] xdp: Move devmap bulk queue into struct
 net_device
Message-ID: <20200110170824.7379adbf@carbon>
In-Reply-To: <157866612285.432695.6722430952732620313.stgit@toke.dk>
References: <157866612174.432695.5077671447287539053.stgit@toke.dk>
        <157866612285.432695.6722430952732620313.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 15:22:02 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 2741aa35bec6..1b2bc2a7522e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
[...]
> @@ -1993,6 +1994,8 @@ struct net_device {
>  	spinlock_t		tx_global_lock;
>  	int			watchdog_timeo;
> =20
> +	struct xdp_dev_bulk_queue __percpu *xdp_bulkq;
> +
>  #ifdef CONFIG_XPS
>  	struct xps_dev_maps __rcu *xps_cpus_map;
>  	struct xps_dev_maps __rcu *xps_rxqs_map;

We need to check that the cache-line for this location in struct
net_device is not getting updated (write operation) from different CPUs.

The test you ran was a single queue single CPU test, which will not
show any regression for that case.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

