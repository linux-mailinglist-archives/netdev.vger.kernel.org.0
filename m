Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60ECEB7655
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388705AbfISJcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:32:15 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51408 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388575AbfISJcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 05:32:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6B43C20615;
        Thu, 19 Sep 2019 11:32:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id u4C9GANr3ejl; Thu, 19 Sep 2019 11:32:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 00ABD205CD;
        Thu, 19 Sep 2019 11:32:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 11:32:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A3E2C318022F;
 Thu, 19 Sep 2019 11:32:13 +0200 (CEST)
Date:   Thu, 19 Sep 2019 11:32:13 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 2/5] net: Add NETIF_F_GRO_LIST feature
Message-ID: <20190919093213.GK2879@gauss3.secunet.de>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <20190918072517.16037-3-steffen.klassert@secunet.com>
 <CA+FuTSeBmGY4_2X3Ydhf60G=An9g9iikDBQMDji=XptN_jBqiw@mail.gmail.com>
 <8bc2e1658e74963d6c3ff297acdcbce6@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8bc2e1658e74963d6c3ff297acdcbce6@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 08:04:18PM -0600, Subash Abhinov Kasiviswanathan wrote:
> On 2019-09-18 10:10, Willem de Bruijn wrote:
> > On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > > 
> > > This adds a new NETIF_F_GRO_LIST feature flag. I will be used
> > > to configure listfyed GRO what will be implemented with some
> > > followup paches.
> > 
> > This should probably simultaneously introduce SKB_GSO_FRAGLIST as well
> > as a BUILD_BUG_ON in net_gso_ok.
> > 
> > Please also in the commit describe the constraints of skbs that have
> > this type. If I'm not mistaken, an skb with either gso_size linear
> > data or one gso_sized frag, followed by a frag_list of the same. With
> > the exception of the last frag_list member, whose mss may be less than
> > gso_size. This will help when reasoning about all the types of skbs we
> > may see at segmentation, as we recently had to do [1]
> > 
> 
> Would it be preferrable to allow any size skbs for the listification.

We currently require a single gso_size because we adjust uh->len
on the head skb to the full size to do correct memory accounting
on the local input path. That is going to be restored with the
gso_size on segmentation.

> Since the original skbs are being restored, single gso_size shoudln't
> be a constraint here.

It might be possible to allow any sized skbs with some extra work, though.
