Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E94B765B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388794AbfISJdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:33:20 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51472 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387767AbfISJdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 05:33:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D758D205CF;
        Thu, 19 Sep 2019 11:33:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dK-Q5YuIPyAu; Thu, 19 Sep 2019 11:33:17 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 73564200A7;
        Thu, 19 Sep 2019 11:33:17 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 11:33:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2DC75318022F;
 Thu, 19 Sep 2019 11:33:17 +0200 (CEST)
Date:   Thu, 19 Sep 2019 11:33:17 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 5/5] udp: Support UDP fraglist GRO/GSO.
Message-ID: <20190919093317.GL2879@gauss3.secunet.de>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <20190918072517.16037-6-steffen.klassert@secunet.com>
 <CA+FuTSfSpzHCCpDRD2s0fP3u2oyKVKQPOVAp0LLPMPV+W3kFtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSfSpzHCCpDRD2s0fP3u2oyKVKQPOVAp0LLPMPV+W3kFtw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 12:13:26PM -0400, Willem de Bruijn wrote:
> On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > This patch extends UDP GRO to support fraglist GRO/GSO
> > by using the previously introduced infrastructure.
> > All UDP packets that are not targeted to a GRO capable
> > UDP sockets are going to fraglist GRO now (local input
> > and forward).
> >
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> 
> > @@ -419,7 +460,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> >             (skb->ip_summed != CHECKSUM_PARTIAL &&
> >              NAPI_GRO_CB(skb)->csum_cnt == 0 &&
> >              !NAPI_GRO_CB(skb)->csum_valid))
> > -               goto out_unlock;
> > +               goto out;
> >
> >         /* mark that this skb passed once through the tunnel gro layer */
> >         NAPI_GRO_CB(skb)->encap_mark = 1;
> > @@ -446,8 +487,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> >         skb_gro_postpull_rcsum(skb, uh, sizeof(struct udphdr));
> >         pp = call_gro_receive_sk(udp_sk(sk)->gro_receive, sk, head, skb);
> >
> > -out_unlock:
> > -       rcu_read_unlock();
> > +out:
> >         skb_gro_flush_final(skb, pp, flush);
> >         return pp;
> >  }
> 
> This probably belongs in patch 1?

Yes, apparently :)
