Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D25311F9E
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBFTUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:20:31 -0500
Received: from mail.xenproject.org ([104.130.215.37]:55394 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhBFTUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 14:20:11 -0500
X-Greylist: delayed 1943 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Feb 2021 14:20:09 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=t6RLyrgrl+6icHjlUcT9RbYfFIeBzwHbjcRTiWQRm98=; b=43EaaP4+j2FIHADQ+iNmhrZtp0
        GLLA9A9bhzBLCUTEmZpoYo6oq6x56VWfSamlcEe/O4+HBPeu8pCDytu4q9Bzkgv7ilF9il4FX1NOD
        K7jLFGXa7skQOkAsb39MmrKdRzJI8/tOs0ZLz1rkmDtI72Y9XJ/WSlFNsht6iZoWXYVs=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l8SbJ-0006wh-UU; Sat, 06 Feb 2021 18:46:33 +0000
Received: from [54.239.6.185] (helo=a483e7b01a66.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l8SbJ-0001KW-JY; Sat, 06 Feb 2021 18:46:33 +0000
Subject: Re: [PATCH 0/7] xen/events: bug fixes and some diagnostic aids
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210206104932.29064-1-jgross@suse.com>
From:   Julien Grall <julien@xen.org>
Message-ID: <bd63694e-ac0c-7954-ec00-edad05f8da1c@xen.org>
Date:   Sat, 6 Feb 2021 18:46:30 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210206104932.29064-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Juergen,

On 06/02/2021 10:49, Juergen Gross wrote:
> The first three patches are fixes for XSA-332. The avoid WARN splats
> and a performance issue with interdomain events.

Thanks for helping to figure out the problem. Unfortunately, I still see 
reliably the WARN splat with the latest Linux master (1e0d27fce010) + 
your first 3 patches.

I am using Xen 4.11 (1c7d984645f9) and dom0 is forced to use the 2L 
events ABI.

After some debugging, I think I have an idea what's went wrong. The 
problem happens when the event is initially bound from vCPU0 to a 
different vCPU.

 From the comment in xen_rebind_evtchn_to_cpu(), we are masking the 
event to prevent it being delivered on an unexpected vCPU. However, I 
believe the following can happen:

vCPU0				| vCPU1
				|
				| Call xen_rebind_evtchn_to_cpu()
receive event X			|
				| mask event X
				| bind to vCPU1
<vCPU descheduled>		| unmask event X
				|
				| receive event X
				|
				| handle_edge_irq(X)
handle_edge_irq(X)		|  -> handle_irq_event()
				|   -> set IRQD_IN_PROGRESS
  -> set IRQS_PENDING		|
				|   -> evtchn_interrupt()
				|   -> clear IRQD_IN_PROGRESS
				|  -> IRQS_PENDING is set
				|  -> handle_irq_event()
				|   -> evtchn_interrupt()
				|     -> WARN()
				|

All the lateeoi handlers expect a ONESHOT semantic and 
evtchn_interrupt() is doesn't tolerate any deviation.

I think the problem was introduced by 7f874a0447a9 ("xen/events: fix 
lateeoi irq acknowledgment") because the interrupt was disabled 
previously. Therefore we wouldn't do another iteration in handle_edge_irq().

Aside the handlers, I think it may impact the defer EOI mitigation 
because in theory if a 3rd vCPU is joining the party (let say vCPU A 
migrate the event from vCPU B to vCPU C). So info->{eoi_cpu, irq_epoch, 
eoi_time} could possibly get mangled?

For a fix, we may want to consider to hold evtchn_rwlock with the write 
permission. Although, I am not 100% sure this is going to prevent 
everything.

Does my write-up make sense to you?

Cheers,

-- 
Julien Grall
