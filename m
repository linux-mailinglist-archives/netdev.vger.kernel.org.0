Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE60236E96
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfFFI1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:27:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFFI1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:27:18 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD2B431628F6;
        Thu,  6 Jun 2019 08:27:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB5F02E16C;
        Thu,  6 Jun 2019 08:27:10 +0000 (UTC)
Message-ID: <ded588b08ae052fcb47b78642720f900a7f66c9e.camel@redhat.com>
Subject: Re: [PATCH net] pktgen: do not sleep with the thread lock held.
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, mcroce@redhat.com
Date:   Thu, 06 Jun 2019 10:27:10 +0200
In-Reply-To: <20190605.120559.1335640243691845984.davem@davemloft.net>
References: <7fed17636f7a9d51b0603c8a4cfdd2111cd946e1.1559737968.git.pabeni@redhat.com>
         <20190605.120559.1335640243691845984.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 06 Jun 2019 08:27:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the feedback.

On Wed, 2019-06-05 at 12:05 -0700, David Miller wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Wed,  5 Jun 2019 14:34:46 +0200
> 
> > @@ -3062,20 +3062,49 @@ static int thread_is_running(const struct pktgen_thread *t)
> >       return 0;
> >  }
> >  
> > -static int pktgen_wait_thread_run(struct pktgen_thread *t)
> > +static bool pktgen_lookup_thread(struct pktgen_net *pn, struct pktgen_thread *t)
> > +{
> > +     struct pktgen_thread *tmp;
> > +
> > +     list_for_each_entry(tmp, &pn->pktgen_threads, th_list)
> > +             if (tmp == t)
> > +                     return true;
> > +     return false;
> > +}
> 
> Pointer equality is not object equality.

Indeed. The trick is that pktgen threads are allocated only at net
creation time.

Actaully they are also freed only net exit, so the extra care is not
needed: the current process held a reference to net via fs proxy.

I'll send a v2 cleaning up the unneeded parts and some documenting
comments.

Cheers,

Paolo

