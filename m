Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5926E2F00
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409160AbfJXKbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:31:38 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43424 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389949AbfJXKbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 06:31:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 04D892052E;
        Thu, 24 Oct 2019 12:31:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DZEo1hkksutq; Thu, 24 Oct 2019 12:31:35 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4828E20189;
        Thu, 24 Oct 2019 12:31:35 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 24 Oct 2019
 12:31:35 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id CB32731801C0;
 Thu, 24 Oct 2019 12:31:34 +0200 (CEST)
Date:   Thu, 24 Oct 2019 12:31:34 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Tom Rix <trix@redhat.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Vehlow <lkml@jv-coder.de>
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
Message-ID: <20191024103134.GD13225@gauss3.secunet.de>
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 05:22:04PM -0700, Tom Rix wrote:
> On PREEMPT_RT_FULL while running netperf, a corruption
> of the skb queue causes an oops.
> 
> This appears to be caused by a race condition here
>         __skb_queue_tail(&trans->queue, skb);
>         tasklet_schedule(&trans->tasklet);
> Where the queue is changed before the tasklet is locked by
> tasklet_schedule.
> 
> The fix is to use the skb queue lock.
> 
> This is the original work of Joerg Vehlow <joerg.vehlow@aox-tech.de>
> https://lkml.org/lkml/2019/9/9/111
>   xfrm_input: Protect queue with lock
> 
>   During the skb_queue_splice_init the tasklet could have been preempted
>   and __skb_queue_tail called, which led to an inconsistent queue.
> 
> ifdefs for CONFIG_PREEMPT_RT_FULL added to reduce runtime effects
> on the normal kernel.

Has Herbert commented on your initial patch, please
fix PREEMPT_RT_FULL instead. There are certainly many
more codepaths that take such assumptions. You can not
fix this by distributing a spin_lock_irqsave here
and there.

