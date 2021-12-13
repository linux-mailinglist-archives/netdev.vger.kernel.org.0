Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23E9472A8B
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbhLMKqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:46:02 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34218 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhLMKqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:46:01 -0500
Date:   Mon, 13 Dec 2021 11:45:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639392360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K6xKHXuT0jTgpYpSJrr/NryPM1B5C0zvBOPhH74pSzA=;
        b=AEqOB/V3kc0fBWzLUfTTh+rtVD0xKWnBEGC0vhrnRf4aQdYABrQ3JRGGiCFAFmL4yqR0Xv
        Z41GdEk4Ja7XhSACoLhWOsY/kHusnfPppSFnXp9XTCKzPhkKXD1GPMfhuiX8/e5QtBCBKD
        QXoW+NypxukxjRC+IP1J+BkqjM2r5D7YWljCHg4ViZ4++Um/jDDiX3tGb71t2wJgMDOxaT
        ZsonmLdKeQaPUfIZ899nuLhXNDB8B7nZtdhvZPU9yXPRbBqpHGbcFu62MCb+tVqTk91m5p
        9o1BsycYubkkZ7td9AOxRm4cgUTWl38Cgjsshw981ecQtyEREir2LDitELCO5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639392360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K6xKHXuT0jTgpYpSJrr/NryPM1B5C0zvBOPhH74pSzA=;
        b=E5XXxKKn4Gs+wWxPqDehJg+obi/ANbWmaZDBZZLhsia7Ij++K8ysTpzYCuc1jD5KCGdbN9
        ZKGjHcq+r7KPxQCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <YbckZ8VxICTThXOn@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
 <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-10 20:32:56 [-0800], Jakub Kicinski wrote:
> On Fri, 10 Dec 2021 16:41:44 +0100 Sebastian Andrzej Siewior wrote:
> > -	contended = qdisc_is_running(q);
> > +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> > +		contended = qdisc_is_running(q);
> > +	else
> > +		contended = true;
> 
> Why not:
> 
> 	contended = qdisc_is_running(q) || IS_ENABLED(CONFIG_PREEMPT_RT);

I could do that. But I would swap the two arguments so that the
IS_ENABLED macro comes first and if true qdisc_is_running() is optimized
away.

Sebastian
