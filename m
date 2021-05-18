Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D701938808C
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 21:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345403AbhERTeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 15:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhERTeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 15:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DECA60FE7;
        Tue, 18 May 2021 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621366398;
        bh=AHzoPmo37P5/vAIqetbwkl87edFt+q67UVfHjhCMRRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fxKrwN6GCppThCi1TmW8xF3YaBoIwHH0Fuyz/VJ88EgYKYcYYE5abV/CtEneLDOJ8
         6fbEpQFof1QN3LWYN9LIHQG3M3vEyaSqlXP9DrFLe3a5DFk/F1efs1rwGbts8UrsbX
         oKWtinU4ZvLTeQwrB0hslXmKMs+l6X/bDpdhwvBhQih/SJ1rhmtCgCAfXQsnd1kUhX
         rWK7s62STAZCXindlkTkaB54rUXeOQql5egQqclUVY1ieXXnPpKs2GRm4Zfi4sHRyY
         AQmUTySufkczywEwiWsA3ous6TDWeAAvw494xaL8j5VlbJy02zAANU0axl3gs3nHzf
         r4BJc/sxqVwrA==
Date:   Tue, 18 May 2021 12:33:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] mlx5e: add add missing BH locking around
 napi_schdule()
Message-ID: <20210518123317.38f6657f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <040bc4de947fc4cca74dcad89464c5b714c5949d.camel@kernel.org>
References: <20210505202026.778635-1-kuba@kernel.org>
        <040bc4de947fc4cca74dcad89464c5b714c5949d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 May 2021 12:23:54 -0700 Saeed Mahameed wrote:
> On Wed, 2021-05-05 at 13:20 -0700, Jakub Kicinski wrote:
> > It's not correct to call napi_schedule() in pure process
> > context. Because we use __raise_softirq_irqoff() we require
> > callers to be in a context which will eventually lead to
> > softirq handling (hardirq, bh disabled, etc.).
> >=20
> > With code as is users will see:
> >=20
> > =C2=A0NOHZ tick-stop error: Non-RCU local softirq work is pending, hand=
ler
> > #08!!!
> >=20
> > Fixes: a8dd7ac12fc3 ("net/mlx5e: Generalize RQ activation")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > We may want to patch net-next once it opens to switch
> > from __raise_softirq_irqoff() to raise_softirq_irqoff().
> > The irq_count() check is probably negligable and we'd need
> > to split the hardirq / non-hardirq paths completely to
> > keep the current behaviour. Plus what's hardirq is murky
> > with RT enabled..
> >=20
> > Eric WDYT?
>=20
> I was waiting for Eric to reply, Anyway i think this patch is correct
> as is,=20
>=20
> Jakub do you want me to submit to net  via net-mlx5 branch?=20

Yes, please. FWIW we had a short exchange with RT folks last Friday,
and it doesn't seem like RT is an issue, so tglx will likely take
care of just adding a lockdep check and maybe a helper for scheduling
from process ctx.

> Another valid solution is that driver will avoid calling
> napi_schedule() altogether from  process context,  we have the
> mechanism of mlx5e_trigger_irq(), which can be utilized here, but needs
> some re-factoring to move the icosq object from the main rx rq to the
> containing channel object.

Yea.. someone on your side would probably need to take care of that
kind of surgery. Apart from that no preference on which fix gets
applied.
