Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7378FFABCD
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 09:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfKMIKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 03:10:25 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:34888 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfKMIKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 03:10:25 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 734C4200A7;
        Wed, 13 Nov 2019 09:10:24 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HD8klcpCHdRG; Wed, 13 Nov 2019 09:10:24 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 057FE200A3;
        Wed, 13 Nov 2019 09:10:24 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 09:10:23 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C137A3180095;
 Wed, 13 Nov 2019 09:10:21 +0100 (CET)
Date:   Wed, 13 Nov 2019 09:10:21 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xiaodong Xu <stid.smth@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <chenborfc@163.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] xfrm: release device reference for invalid state
Message-ID: <20191113081021.GV13225@gauss3.secunet.de>
References: <20191111230546.17105-1-stid.smth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191111230546.17105-1-stid.smth@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 03:05:46PM -0800, Xiaodong Xu wrote:
> An ESP packet could be decrypted in async mode if the input handler for
> this packet returns -EINPROGRESS in xfrm_input(). At this moment the device
> reference in skb is held. Later xfrm_input() will be invoked again to
> resume the processing.
> If the transform state is still valid it would continue to release the
> device reference and there won't be a problem; however if the transform
> state is not valid when async resumption happens, the packet will be
> dropped while the device reference is still being held.
> When the device is deleted for some reason and the reference to this
> device is not properly released, the kernel will keep logging like:
> 
> unregister_netdevice: waiting for ppp2 to become free. Usage count = 1
> 
> The issue is observed when running IPsec traffic over a PPPoE device based
> on a bridge interface. By terminating the PPPoE connection on the server
> end for multiple times, the PPPoE device on the client side will eventually
> get stuck on the above warning message.
> 
> This patch will check the async mode first and continue to release device
> reference in async resumption, before it is dropped due to invalid state.
> 
> v2: Do not assign address family from outer_mode in the transform if the
> state is invalid
> 
> v3: Release device reference in the error path instead of jumping to resume
> 
> Fixes: 4ce3dbe397d7b ("xfrm: Fix xfrm_input() to verify state is valid when (encap_type < 0)")
> Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>
> Reported-by: Bo Chen <chenborfc@163.com>
> Tested-by: Bo Chen <chenborfc@163.com>

Patch applied, thanks a lot!
