Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB91140122B
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 01:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbhIEX4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 19:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhIEX4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 19:56:37 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB83BC061575;
        Sun,  5 Sep 2021 16:55:33 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630886132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=htNt0m9nOHGLJS+qiDTAK6Mcl3GNSWsAsqlDk5pIWKs=;
        b=ZJXLgiWpz+VGt31DxlSZe++i8KKC++HF9m4G3FH/T/6A2sCUjWn3aJs+vD53/fjjJqragO
        ZG8TcI6DvtiZA+MJPz1fTW+ReHyM2H5OdfFVrvG8WCcbI4eNPcP2W8sgQV9VseiZcocov5
        /wqMfBAWHQdK3HAlgszTKljhO05jxatal0rNcQE79mUpfJJD4WiEAHOsgDiIV2Qc9HL2Dk
        3vnHP9gw8DXZ79EqT4vgitX/80aeSx3qBwmlhxH+65Yh9ipeffGOGR0L0erjz+MJMkt5+m
        p0CFx36xhtYq8BDb1gCDvGtgkps8o+g3LeL3NOa2bKAsJOAyK22Z9M5ycjmJAg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630886132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=htNt0m9nOHGLJS+qiDTAK6Mcl3GNSWsAsqlDk5pIWKs=;
        b=Tc++YGUfuxCKx0MXvCKWxi6HEsU5Kceo6oXMeNF4ECU00N0iQ8K+JsA6MfvnfrAMQj1FgX
        Rlj6xebVNdu3hdCg==
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+a9b681dcbc06eb2bca04@syzkaller.appspotmail.com>
Cc:     eric.dumazet@gmail.com, hdanton@sina.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] INFO: task hung in __lru_add_drain_all
In-Reply-To: <20210904080739.3026-1-hdanton@sina.com>
References: <20210904005650.2914-1-hdanton@sina.com>
 <20210904080739.3026-1-hdanton@sina.com>
Date:   Mon, 06 Sep 2021 01:55:31 +0200
Message-ID: <87h7eya87g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 04 2021 at 16:07, Hillf Danton wrote:
>
> See if ieee80211_iface_work is burning more CPU cycles than thought, given the
> bound workqueue work blocked for more than 143 seconds.
>
> #syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1494,6 +1494,7 @@ static void ieee80211_iface_work(struct
>  
>  		kfree_skb(skb);
>  		kcov_remote_stop();
> +		cond_resched();
>  	}
>  
>  	/* process status queue */
> @@ -1504,6 +1505,7 @@ static void ieee80211_iface_work(struct
>  		kfree_skb(skb);
>  
>  		kcov_remote_stop();
> +		cond_resched();
>  	}
>  
>  	/* then other type-dependent work */
> --

Again. What are you trying to achieve here? 

ieee80211_iface_work() is a work function invoked from a worker thread
in preemptible task context.

The kernel config used for this has CONFIG_PREEMPT=y, which means that
the context in which you are sprinkling cond_resched() is already fully
preemtible and the only reason for this fail would be a fatal bug in the
scheduler core or in the preemption mechanism. Pretty unlikely to go
unnoticed for anything else than for this particular reproducer.

Can you please stop waisting precious compute power?

Thanks,

        tglx
