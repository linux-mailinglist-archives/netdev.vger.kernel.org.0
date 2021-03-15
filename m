Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C133B02D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 11:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCOKo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 06:44:27 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37716 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhCOKoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 06:44:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B384B201CA;
        Mon, 15 Mar 2021 11:43:59 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LVqiXdF67BZg; Mon, 15 Mar 2021 11:43:52 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 31BB420491;
        Mon, 15 Mar 2021 11:43:51 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 11:43:50 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 15 Mar
 2021 11:43:50 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 50CBC31803BF; Mon, 15 Mar 2021 11:43:50 +0100 (CET)
Date:   Mon, 15 Mar 2021 11:43:50 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Guy Shapiro <guysh@mellanox.com>, <netdev@vger.kernel.org>,
        <antony@phenome.org>
Subject: Re: [PATCH] xfrm: return error when esp offload is requested and not
 supported
Message-ID: <20210315104350.GY62598@gauss3.secunet.de>
References: <20210310093611.GA5406@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210310093611.GA5406@moon.secunet.de>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:36:11AM +0100, Antony Antony wrote:
> When ESP offload is not supported by the device return an error,
> -EINVAL, instead of silently ignoring it, creating a SA without offload,
> and returning success.
> 
> with this fix ip x s a would return
> RTNETLINK answers: Invalid argument
> 
> Also, return an error, -EINVAL, when CONFIG_XFRM_OFFLOAD is
> not defined and the user is trying to create an SA with the offload.
> 
> Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

I feal a bit unease about this one. When we designed the offloading
API, we decided to fallback to software if HW offload is not available.
Not sure if that was a good idea, but changing this would also change
the userspace ABI. So if we change this, we should at least not
consider it as a fix because it would be backported to -stable
in that case. Thoughts?

