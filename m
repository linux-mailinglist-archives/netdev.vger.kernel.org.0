Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84F527AFE0
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI1OSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgI1OSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:18:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250D8C061755;
        Mon, 28 Sep 2020 07:18:02 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601302680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U5bkdTo3qfMxqz9E4aGkNYdyKLOXYzCS8HQXr2RKStE=;
        b=ExasjWq4h2gDllgRfnyPTkaDVrVzD1oLJxkV4bUsRA2lUua9elkbWevGuV8cdmY+7ugmcY
        tQ8pFcewqxjfAYKw3rx+t47CYiIXuDHPmwwyvcTRbft+FMaleEkmkEyQJXh2C+MWmttvel
        D1O+dkTCvCKMeiDP7XyU9Dy/LqjKt1Zm9Io35hzAhOeqxGPL3Y4YNtf2UEvLfJON9JK5Tx
        IeJeX4npSpHCBP0EhiPmvj0ptSiw1HhTv5ZYj+ZAmORIES+Yfd6jQUtEqg12QmfkVYA5nA
        u3lU9WeHWsfl2iD4ZZ6+diK59M8p7x+gOX/UUxr9s7wxh5D9m28V76yVFfE4UQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601302680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U5bkdTo3qfMxqz9E4aGkNYdyKLOXYzCS8HQXr2RKStE=;
        b=N1Q/Yh7hk73jLMAIEVMnDGwSH6q0SM2PClokTnM3HGRMBOjRuhcPhyD+OThX9sRm1KMMJg
        XMT+o67ZRCFzFZBA==
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Hillf Danton <hdanton@sina.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in hrtimer_forward
In-Reply-To: <20200927080452.18340-1-hdanton@sina.com>
References: <000000000000bd9ee505b01f60e2@google.com> <20200927080452.18340-1-hdanton@sina.com>
Date:   Mon, 28 Sep 2020 16:18:00 +0200
Message-ID: <87y2kuj887.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27 2020 at 16:04, Hillf Danton wrote:
> Sat, 26 Sep 2020 17:38:16 -0700
>
> Dunno if it's down to memory barrier.
>
> --- a/kernel/time/hrtimer.c
> +++ b/kernel/time/hrtimer.c
> @@ -929,7 +929,7 @@ u64 hrtimer_forward(struct hrtimer *time
>  	if (delta < 0)
>  		return 0;
>  
> -	if (WARN_ON(timer->state & HRTIMER_STATE_ENQUEUED))
> +	if (WARN_ON(hrtimer_is_queued(timer)))
>  		return 0;

The point of that exercise is?
