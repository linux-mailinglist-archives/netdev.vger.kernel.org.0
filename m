Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1932542F41C
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhJONrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:47:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236140AbhJONrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 09:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634305497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XiqkKErJTyLhV4pOARnkz/OcSHl9NgZqjk9FUGyq53Y=;
        b=AbOR5CBtyMw5YOWIWjwkM8DDQmln3uV0hU43ydbCdsqIqlTljPDudLjLuXa2UbD95oRmdu
        Tru/KVSwvKIk51kSqfOJztsyNicJEaC9PEuJ7e5Lf0q+pRA7I4YUAwFJT3ymQHne/JkciQ
        m9x1uOKhNU6hS8Q24YQoKf8B5pd8JzI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-SNqBwgGrOheUKqr5gb1Pxg-1; Fri, 15 Oct 2021 09:44:54 -0400
X-MC-Unique: SNqBwgGrOheUKqr5gb1Pxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 118A6802575;
        Fri, 15 Oct 2021 13:44:53 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6117360FDD;
        Fri, 15 Oct 2021 13:44:51 +0000 (UTC)
Date:   Fri, 15 Oct 2021 15:44:48 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3] mctp: Implement extended addressing
Message-ID: <20211015134448.GA16157@asgard.redhat.com>
References: <20211014083420.2050417-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014083420.2050417-1-jk@codeconstruct.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 04:34:20PM +0800, Jeremy Kerr wrote:
> This change allows an extended address struct - struct sockaddr_mctp_ext
> - to be passed to sendmsg/recvmsg. This allows userspace to specify
> output ifindex and physical address information (for sendmsg) or receive
> the input ifindex/physaddr for incoming messages (for recvmsg). This is
> typically used by userspace for MCTP address discovery and assignment
> operations.
> 
> The extended addressing facility is conditional on a new sockopt:
> MCTP_OPT_ADDR_EXT; userspace must explicitly enable addressing before
> the kernel will consume/populate the extended address data.

[...]

> +/* setsockopt(2) level & options */
> +#define SOL_MCTP		0

Socket option levels tend to be globally unique and additionally defined
in include/linux/socket.h (which led to them not being exposed to UAPI
in many cases, but that is another, entirely avoiadable, problem), with
Bluetooth socket option levels being most notable exception (and IEEE 802.15.4
and mISDN being less notable).  So, unless there is existing code that relies
on this socket level definition, it is probably worth re-defining it to 284
and put a copy of SOL_MCTP definition after SOL_XDP in include/linux/socket.h.

