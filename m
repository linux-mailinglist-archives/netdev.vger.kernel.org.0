Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E352EB424
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731203AbhAEUYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbhAEUYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 15:24:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 242C722D5A;
        Tue,  5 Jan 2021 20:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609878209;
        bh=qcVdtiVwLvxEkrc6bUZLiqOskvrds0MWzOJ4DpyhiP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8a5+c6Sn3+/ng1p+TTRJ7VnJusftedtknvyiOp8+2Ip9g0YkCDlTl4vQIzjp5HLZ
         WF7oKUZHsEdwduXSz1hwJAR2bMvbH8c7e0a2S5i7F5jcZgb/FIn+kRlBnpMvaiZy/f
         ksTSndMNELI8s5C8+kUxeClpjj/sv6xpdis84KpRV2VI4l66UFhFHtiHBD8ia/nllb
         7rrLn6U2kNNsGy2m5PacWVpnUlnKVajFalrv9HY7BIghTMXSUDmhJQTCaoGjkwcyyr
         /PLW2npiGQOexh6/JyyJ2DzcZyxJZEjkkh5UnzkNbILkpLv2FYDSS+uME1/Q8QQ3Tx
         IcujnTICPrdDg==
Date:   Tue, 5 Jan 2021 12:23:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: Missed schedule_napi()?
Message-ID: <20210105122328.3e5569a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <475bdc3b-d57f-eeef-3cdf-88c7b883d423@linaro.org>
References: <475bdc3b-d57f-eeef-3cdf-88c7b883d423@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jan 2021 10:46:09 -0600 Alex Elder wrote:
> I have a question about whether it's possible to effectively
> miss a schedule_napi() call when a disable_napi() is underway.
> 
> I'm going to try to represent the code in question here
> in an interleaved way to explain the scenario; I hope
> it's clear.
> 
> Suppose the SCHED flag is clear.  And suppose two
> concurrent threads do things in the sequence below.
> 
> Disabling thread	| Scheduling thread
> ------------------------+----------------------
> void napi_disable(struct napi_struct *n)
> {			| bool napi_schedule_prep(struct napi_struct *n)
>    might_sleep();	| {
>                          |   unsigned long val, new;
>                          |
>                          |   do {
>    set_bit(NAPI_STATE_DISABLE, &n->state);
>                          |     val = READ_ONCE(n->state);
>                          |     if (unlikely(val & NAPIF_STATE_DISABLE))
>                          |       return false;
> 			|	. . .
>    while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
>       msleep(1);		|
>         . . .		|
> 
> We start with the SCHED bit clear.  The disabling thread
> sets the DISABLE bit as it begins.  The scheduling thread
> checks the state and finds that it is disabled, so it
> simply returns false, and the napi_schedule() caller will
> *not* call __napi_schedule().
> 
> But even though NAPI is getting disabled, the scheduling thread
> wants it recorded that a NAPI poll should be scheduled, even
> if it happens later.  In other words, it seems like this
> case is essentially a MISSED schedule.
> 
> The disabling thread sets the SCHED bit, having found it was
> not set previously, and thereby disables NAPI processing until
> it is re-enabled.
> 
> Later, napi_enable() will clear the SCHED bit, allowing NAPI
> processing to continue, but there is no record that the
> scheduling thread indicated that a poll was needed,
> 
> Am I misunderstanding this?  If so, can someone please explain?
> It seems to me that the napi_schedule() call is "lost".

AFAICT your analysis is correct. At the same time the NAPI API does 
not (to the best of my knowledge) give any guarantees about NAPI
invocations matching the number of __napi_schedule() calls.

The expectation is that the communication channel will be "reset" 
after the napi_disable() call, processing or dropping all the events
which were outstanding after napi_disable().
