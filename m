Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1E634B781
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 15:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhC0OMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 10:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230015AbhC0OMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 10:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0953B619C9;
        Sat, 27 Mar 2021 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616854337;
        bh=8Chi3BIwfdsk/IyZQIa2RtvxKwuJA9S48J8qf5dSlag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vd7SZD4pgzWHvI/v8SLu51HAIeMRJA79PQFwU6WR50j8NvGjF/tuZdDH043g48Jxt
         DTFl5pqF0uZ4CJSgksaT1UahiBAMKay05Edjs0L0k8tRY+LDvTgJImo7oIocs+rtw+
         eFAVjzr6W0vWIOS/Ml1EydXWdEa6cNL/7OHFnPMQ=
Date:   Sat, 27 Mar 2021 15:12:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Du Cheng <ducheng2@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net:qrtr: fix atomic idr allocation in
 qrtr_port_assign()
Message-ID: <YF89PtWrs2N5XSgb@kroah.com>
References: <20210327140702.4916-1-ducheng2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210327140702.4916-1-ducheng2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the xarray maintainer...

On Sat, Mar 27, 2021 at 10:07:02PM +0800, Du Cheng wrote:
> add idr_preload() and idr_preload_end() around idr_alloc_u32(GFP_ATOMIC)
> due to internal use of per_cpu variables, which requires preemption
> disabling/enabling.
> 
> reported as "BUG: "using smp_processor_id() in preemptible" by syzkaller
> 
> Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> Signed-off-by: Du Cheng <ducheng2@gmail.com>
> ---
> changelog
> v1: change to GFP_KERNEL for idr_alloc_u32() but might sleep
> v2: revert to GFP_ATOMIC but add preemption disable/enable protection
> 
>  net/qrtr/qrtr.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index edb6ac17ceca..6361f169490e 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -722,17 +722,23 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
>  	mutex_lock(&qrtr_port_lock);
>  	if (!*port) {
>  		min_port = QRTR_MIN_EPH_SOCKET;
> +		idr_preload(GFP_ATOMIC);
>  		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> +		idr_preload_end();

This seems "odd" to me.  We are asking idr_alloc_u32() to abide by
GFP_ATOMIC, so why do we need to "preload" it with the same type of
allocation?

Is there something in the idr/radix/xarray code that can't really handle
GFP_ATOMIC during a "normal" idr allocation that is causing this warning
to be hit?  Why is this change the "correct" one?

thanks,

greg k-h
