Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB16112A53
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfLDLim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:38:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31420 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727268AbfLDLim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 06:38:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575459521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=76Eat5h9hj7twLSmI7D+BtbdtTI6olcMmFKdFbpmaf4=;
        b=BxxIs+FACYidgAczg2HyixwXM0rYufonkFmriyEvBRYNilDoCXYwhPIeDSip+LU5013Jpq
        aXXx86nHxjI9HmZ41664dKv/Z19C+yXq9zn5Rxi7CWNmSzoy0+AlPkclRP0LTUlhX57mo+
        X5/w/0SBKVeKudUSEUvDkL9PSq2fvxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-6gLLU8wFOaOcBmt7TsbTwQ-1; Wed, 04 Dec 2019 06:38:36 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA48B91253;
        Wed,  4 Dec 2019 11:38:35 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B35DE1D1;
        Wed,  4 Dec 2019 11:38:30 +0000 (UTC)
Date:   Wed, 4 Dec 2019 12:38:29 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [net PATCH] xdp: obtain the mem_id mutex before trying to
 remove an entry.
Message-ID: <20191204123829.2af45813@carbon>
In-Reply-To: <64b28372-e203-92db-bc67-1c308334042f@ti.com>
References: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
        <20191204093240.581543f3@carbon>
        <64b28372-e203-92db-bc67-1c308334042f@ti.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 6gLLU8wFOaOcBmt7TsbTwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Dec 2019 12:07:22 +0200
Grygorii Strashko <grygorii.strashko@ti.com> wrote:

> On 04/12/2019 10:32, Jesper Dangaard Brouer wrote:
> > On Tue, 3 Dec 2019 14:01:14 -0800
> > Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >   
> >> A lockdep splat was observed when trying to remove an xdp memory
> >> model from the table since the mutex was obtained when trying to
> >> remove the entry, but not before the table walk started:
> >>
> >> Fix the splat by obtaining the lock before starting the table walk.
> >>
> >> Fixes: c3f812cea0d7 ("page_pool: do not release pool until inflight == 0.")
> >> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>  
> > 
> > Have you tested if this patch fix the problem reported by Grygorii?
> > 
> > Link: https://lore.kernel.org/netdev/c2de8927-7bca-612f-cdfd-e9112fee412a@ti.com
> > 
> > Grygorii can you test this?  
> 
> Thanks.
> I do not see this trace any more and networking is working after if down/up
> 
> Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 

Well if it fixes you issue, then I guess its okay.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

I just though it was related to the rcu_read_lock() around the
page_pool_destroy() call. Guess, I was wrong.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

