Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092C3127F2C
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfLTPU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:20:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35884 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfLTPU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576855255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5I6Mo1rns1ToCq0SkNqbF8w7rLLG4V0mr4RcA7ck6Yc=;
        b=VnQLobe9iN88WjXmkAQTeut79z2yNRakwUGAjNAO1eWBlMBjMuBptrfNJfjrFT4ak9DywD
        VZ8QRd1iyAyzVZTiu26jfkyNvZj4kJhLWj5uivr5mVPsx/Nzc2gOtgZ5nqXyyr3zWiuikF
        q2R+hEMVHxnCCpvztRAwFDn+Qhl5TpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-OJfE5lOCPB2Rhho_dHr9Hg-1; Fri, 20 Dec 2019 10:20:52 -0500
X-MC-Unique: OJfE5lOCPB2Rhho_dHr9Hg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACF7B8FD560;
        Fri, 20 Dec 2019 15:20:50 +0000 (UTC)
Received: from ovpn-204-204.brq.redhat.com (ovpn-204-204.brq.redhat.com [10.40.204.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 625B45DA60;
        Fri, 20 Dec 2019 15:20:48 +0000 (UTC)
Message-ID: <9a2cd9ea1abdd43d19f07aeb3f66765df74953d5.camel@redhat.com>
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Roman Mashak <mrv@mojatatu.com>
In-Reply-To: <02026181-9a29-2325-b906-7b4b2af883a2@mojatatu.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
         <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
         <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
         <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
         <vbfr2102swb.fsf@mellanox.com>
         <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
         <vbfpngk2r9a.fsf@mellanox.com> <vbfo8w42qt2.fsf@mellanox.com>
         <b9b2261a-5a35-fdf7-79b5-9d644e3ed097@mojatatu.com>
         <548e3ae8-6db8-a45c-2d9c-0e4a09dc737b@mojatatu.com>
         <cc0a3849-48c0-384d-6dd5-29a6763695f2@mojatatu.com>
         <vbfa77n2iv8.fsf@mellanox.com>
         <02026181-9a29-2325-b906-7b4b2af883a2@mojatatu.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 20 Dec 2019 16:20:47 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-12-20 at 09:57 -0500, Jamal Hadi Salim wrote:
> On 2019-12-20 9:04 a.m., Vlad Buslov wrote:
> > Hi Jamal,
> > 
> > Yes, I think the patch would work. However, we don't really need the
> > flags check, if we are going to implement the new ops->delete_empty()
> > callback because it can work like this:
> > 
> > if (!tp->ops->delete_empty) {
> >     tp->deleting = true;
> >     return tp->deleting;
> > } else {
> >    return tp->ops->delete_empty(tp);
> > }
> > 
> > WDYT?
> 
> Looks reasonable - we kill two birds with one stone.
> We'd need to revert the patch David took in.
> 
> cheers,
> jamal

... ok, I can try to do a series that reverts the fix on cls_u32 and
implements the check_delete_empty for cls_flower. You might find it above
the christmas tree (*)?

-- 
davide 

(*) above, not under, because the tree is reversed.

