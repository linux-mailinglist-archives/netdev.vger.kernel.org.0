Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644DB32CFD4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 10:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbhCDJik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 04:38:40 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:47362 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237727AbhCDJiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 04:38:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4BCF42049A;
        Thu,  4 Mar 2021 10:37:32 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G-SxGznd7oZb; Thu,  4 Mar 2021 10:37:31 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F3CE320491;
        Thu,  4 Mar 2021 10:37:30 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Mar 2021 10:37:30 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 4 Mar 2021
 10:37:30 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2863C318049F; Thu,  4 Mar 2021 10:37:30 +0100 (CET)
Date:   Thu, 4 Mar 2021 10:37:30 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] xfrm: Use actual socket sk instead of skb socket
 for xfrm_output_resume
Message-ID: <20210304093730.GK2966489@gauss3.secunet.de>
References: <20210301190004.9586-1-evan.nimmo@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210301190004.9586-1-evan.nimmo@alliedtelesis.co.nz>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 08:00:04AM +1300, Evan Nimmo wrote:
> A situation can occur where the interface bound to the sk is different
> to the interface bound to the sk attached to the skb. The interface
> bound to the sk is the correct one however this information is lost inside
> xfrm_output2 and instead the sk on the skb is used in xfrm_output_resume
> instead. This assumes that the sk bound interface and the bound interface
> attached to the sk within the skb are the same which can lead to lookup
> failures inside ip_route_me_harder resulting in the packet being dropped.
> 
> We have an l2tp v3 tunnel with ipsec protection. The tunnel is in the
> global VRF however we have an encapsulated dot1q tunnel interface that
> is within a different VRF. We also have a mangle rule that marks the 
> packets causing them to be processed inside ip_route_me_harder.
> 
> Prior to commit 31c70d5956fc ("l2tp: keep original skb ownership") this
> worked fine as the sk attached to the skb was changed from the dot1q
> encapsulated interface to the sk for the tunnel which meant the interface
> bound to the sk and the interface bound to the skb were identical.
> Commit 46d6c5ae953c ("netfilter: use actual socket sk rather than skb sk
> when routing harder") fixed some of these issues however a similar
> problem existed in the xfrm code.
> 
> Fixes: 31c70d5956fc ("l2tp: keep original skb ownership")
> 
> Signed-off-by: Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>

Applied, thanks Evan!
