Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF46F1EADE1
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgFAStX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:49:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47187 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728672AbgFAStW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591037359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DLZgw+ZsP7Cc1u7MGhzEC2WFl4vVS+fpc9IF9Kt6vZQ=;
        b=VT/3iSpl9EE7pqDmkOU7FBJamVXslqHmWR/55F2ABPcraR5jIjB7woGSRhb7HZbOpuQ19N
        sDzsbXNiPZFlXi+ob+TLH2a6Rb896NmA1uo3Rfan7sYEIlRPyHGPfFAQrI1X/pv+Ga+IUt
        TsKGA/eL5NMyu1NLouNTr49yeU6wu/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-i6UptJP9OjG0Y7oLaCkBUQ-1; Mon, 01 Jun 2020 14:49:18 -0400
X-MC-Unique: i6UptJP9OjG0Y7oLaCkBUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD7DB107ACCD;
        Mon,  1 Jun 2020 18:49:16 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.194.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3352A19C79;
        Mon,  1 Jun 2020 18:49:15 +0000 (UTC)
Message-ID: <d0c9367d71860bf7c5439511e5f45bd05286d40a.camel@redhat.com>
Subject: Re: [PATCH net-next] net/sched: fix a couple of splats in the
 error path of tfc_gate_init()
From:   Davide Caratti <dcaratti@redhat.com>
To:     David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com
Cc:     jhs@mojatatu.com, Po.Liu@nxp.com, netdev@vger.kernel.org,
        ivecera@redhat.com
In-Reply-To: <20200601.113714.711382126517958012.davem@davemloft.net>
References: <c0284a5f2d361658f90a9cada05426051e3c490d.1590703192.git.dcaratti@redhat.com>
         <20200601.113714.711382126517958012.davem@davemloft.net>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 01 Jun 2020 20:49:14 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-06-01 at 11:37 -0700, David Miller wrote:
> From: Davide Caratti <dcaratti@redhat.com>
> Date: Fri, 29 May 2020 00:05:32 +0200
> 
> > trying to configure TC 'act_gate' rules with invalid control actions, the
> > following splat can be observed:
> > 
> >  general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
> >  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> >  CPU: 1 PID: 2143 Comm: tc Not tainted 5.7.0-rc6+ #168
> >  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
> >  RIP: 0010:hrtimer_active+0x56/0x290
> >  [...]
> >   Call Trace:
> >   hrtimer_try_to_cancel+0x6d/0x330
>  ...
> > this is caused by hrtimer_cancel(), running before hrtimer_init(). Fix it
> > ensuring to call hrtimer_cancel() only if clockid is valid, and the timer
> > has been initialized. After fixing this splat, the same error path causes
> > another problem:
[...]

> Applied, thanks.

hello Dave,

for this patch I will probably need to send a follow-up, because
the TC action overwrite case probably has still some issues [1] [2].
I can do that targeting the 'net' tree, unless Po or Cong have some
objections.

Ok?

thank you in advance,
-- 
davide


[1] https://lore.kernel.org/netdev/CAM_iQpVesOZ0kQ2OWHss1kG3O5tvYUYETK4A3LW9doH5ZFQjmw@mail.gmail.com/ 
[2] https://lore.kernel.org/netdev/696c630f8c72f2a6a0674b69921fd500f1d5d4d1.camel@redhat.com/

