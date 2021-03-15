Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192C533BFBC
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCOPaj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Mar 2021 11:30:39 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:33841 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhCOPaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:30:13 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-Qgg4fzyhMJSrm0CnYQuAAQ-1; Mon, 15 Mar 2021 11:30:06 -0400
X-MC-Unique: Qgg4fzyhMJSrm0CnYQuAAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04F7C84BA57;
        Mon, 15 Mar 2021 15:30:04 +0000 (UTC)
Received: from hog (unknown [10.40.194.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F4BC17B80;
        Mon, 15 Mar 2021 15:30:00 +0000 (UTC)
Date:   Mon, 15 Mar 2021 16:29:59 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Antony Antony <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Guy Shapiro <guysh@mellanox.com>, netdev@vger.kernel.org,
        antony@phenome.org
Subject: Re: [PATCH] xfrm: return error when esp offload is requested and not
 supported
Message-ID: <YE99dz85HaajKX4w@hog>
References: <20210310093611.GA5406@moon.secunet.de>
 <20210315104350.GY62598@gauss3.secunet.de>
MIME-Version: 1.0
In-Reply-To: <20210315104350.GY62598@gauss3.secunet.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-03-15, 11:43:50 +0100, Steffen Klassert wrote:
> On Wed, Mar 10, 2021 at 10:36:11AM +0100, Antony Antony wrote:
> > When ESP offload is not supported by the device return an error,
> > -EINVAL, instead of silently ignoring it, creating a SA without offload,
> > and returning success.
> > 
> > with this fix ip x s a would return
> > RTNETLINK answers: Invalid argument
> > 
> > Also, return an error, -EINVAL, when CONFIG_XFRM_OFFLOAD is
> > not defined and the user is trying to create an SA with the offload.
> > 
> > Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
> > Signed-off-by: Antony Antony <antony.antony@secunet.com>
> 
> I feal a bit unease about this one. When we designed the offloading
> API, we decided to fallback to software if HW offload is not available.

Right, but it's a little bit inconsistent. If HW offload is not
available, we get silent fallback. This is great for compatibility
(old kernels will completely ignore the XFRMA_OFFLOAD_DEV attribute,
new kernels try to emulate this), and because routes can change and
suddenly the packets that should have been going through some device
go through another, which may have different capabilities.

On the other hand, if HW offload is available but doesn't support the
exact features we're trying to enable (UDP encap, wrong algorithm, etc
(*)), then we can fail in a visible way.

(*) I know there's an "if (err != -EOPNOTSUPP)" on the result of
->xdo_dev_state_add(), but for example mlx5 seems to return EINVAL
instead of EOPNOTSUPP.

> Not sure if that was a good idea, but changing this would also change
> the userspace ABI. So if we change this, we should at least not
> consider it as a fix because it would be backported to -stable
> in that case. Thoughts?

Agree, but I don't think we could even change this at all.

At best we could introduce a flag to force offloading, and fail if we
can't offload. But then what should we do if the traffic for that
state is rerouted through a different interface, or if offloading is
temporarily disabled with ethtool? Also, should a kernel with
!CONFIG_XFRM_OFFLOAD ignore that flag or not?

Antony, what prompted you to write this patch? Do you have a use case
for requiring offloading instead of falling back to software?


Thanks,

-- 
Sabrina

