Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33CB2F66CB
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbhANRHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:07:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbhANRHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 12:07:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9055323B1C;
        Thu, 14 Jan 2021 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610644013;
        bh=GhBnu3rYeTTZ55P9yeASt3XVdyjfb6jCgyQMgNyhgvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=roIjGKK+6yuHxJy61IR8Ou8ogRblf2jZQQS9TzLI0WG/u5Cm0QZYjquBxwKUgFh2P
         4AYrryJq5CWDhpuc5A09v33yuplTNudzTunf5q+40UtIpMfkPUyjEZVuntxFJVjAlw
         wby7JOuHrq5+zsepZzdLIn40iaJld1t18m4zOvDlqmJqiTTsm7TnI2oPTJu3yMVZfg
         zGkB40l/wfwcdUIPGttXU7cDSw6XmV9zUAwlsH6OmDpIoK1H0m0y38YfPbDqFn2rhx
         EYcIgRI9e3daGHWhRfso3M1XGhDssUMwsJRBDqH93oQccUUXUWR2rZoCGZC4v9jwBA
         LoTt80Uc7mGIg==
Date:   Thu, 14 Jan 2021 09:06:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] cls_flower: call nla_ok() before nla_next()
Message-ID: <20210114090652.4053e6ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpUuwpm_uQ76SY+Vz=FN+xq_bhUTScn8NcRNfcn8xehQgQ@mail.gmail.com>
References: <20210112025548.19107-1-xiyou.wangcong@gmail.com>
        <20210112173813.17861ae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpUuwpm_uQ76SY+Vz=FN+xq_bhUTScn8NcRNfcn8xehQgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 23:20:24 -0800 Cong Wang wrote:
> On Tue, Jan 12, 2021 at 5:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 11 Jan 2021 18:55:48 -0800 Cong Wang wrote:  
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > fl_set_enc_opt() simply checks if there are still bytes left to parse,
> > > but this is not sufficent as syzbot seems to be able to generate
> > > malformatted netlink messages. nla_ok() is more strict so should be
> > > used to validate the next nlattr here.
> > >
> > > And nla_validate_nested_deprecated() has less strict check too, it is
> > > probably too late to switch to the strict version, but we can just
> > > call nla_ok() too after it.
> > >
> > > Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
> > > Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> > > Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
> > > Cc: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Cc: Xin Long <lucien.xin@gmail.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>  
> >
> > Thanks for keeping up with the syzbot bugs!
> >  
> > > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > > index 1319986693fc..e265c443536e 100644
> > > --- a/net/sched/cls_flower.c
> > > +++ b/net/sched/cls_flower.c
> > > @@ -1272,6 +1272,8 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> > >
> > >               nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> > >               msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> > > +             if (!nla_ok(nla_opt_msk, msk_depth))
> > > +                     return -EINVAL;  
> >
> > Can we just add another call to nla_validate_nested_deprecated()
> > here instead of having to worry about each attr individually?  
> 
> No, we can not parse the nested attr here because different key types
> have different attributes.

Not parse, just validate. Policy can be NULL, then nla_validate
basically only checks nla_ok(). But my previous suggestion to call 
nla_validate_nested_deprecated() would not work, we'd need 
__nla_validate(NL_VALIDATE_TRAILING), so yeah, maybe that's more
complex for a read to understand than just calling nla_ok()...
