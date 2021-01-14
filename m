Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B4F2F6BF1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 21:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhANUQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 15:16:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbhANUQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 15:16:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B58A23976;
        Thu, 14 Jan 2021 20:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610655375;
        bh=7w4JdqkoKw5fMD3FYgMKu9OTbUMSdDqoaKxIuZNhweQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WoaDe0JeJcTuQefkyLhyJDD7NauXaFU+d6gywoqbjIzS07Eff9r4ZT76WAewct3ib
         OPJaJABbwSuGl2jKY8HT/RHJYtAAwlFXd8kqNxBcuKesEheRFxQHObSpGujwen0EXY
         6fTKMTh6eVjiDVdUFnBWUJOIV8g7fbYlVUVAFA6+tMxo0ozmX6iLBPRVrlsX76EK+Y
         BU77QMJ53Lig7Qxb3GyxaTBpbUwys2+2Y7dETL8yKoa7dpoCYWr8RSV+MZtei3KXlC
         5ENgFSVw6R+cRgOhwtSRKpcn7rj40MknsbnD82iCloCUwhhTnxAHIivvGEVfzIOWQl
         T0NjlMOkZY6Mw==
Date:   Thu, 14 Jan 2021 12:16:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net v2] cls_flower: call nla_ok() before nla_next()
Message-ID: <20210114121614.7fb64be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpUPzSfbQgDE+BBySFVUqYCqse0kKQ-htN81b9JRTGYfJA@mail.gmail.com>
References: <20210114163822.56306-1-xiyou.wangcong@gmail.com>
        <20210114103848.5153aa5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpUPzSfbQgDE+BBySFVUqYCqse0kKQ-htN81b9JRTGYfJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 12:03:16 -0800 Cong Wang wrote:
> On Thu, Jan 14, 2021 at 10:38 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 14 Jan 2021 08:38:22 -0800 Cong Wang wrote:  
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
> >  
> > > @@ -1340,9 +1341,6 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> > >                               NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
> > >                               return -EINVAL;
> > >                       }
> > > -
> > > -                     if (msk_depth)
> > > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> > >                       break;
> > >               case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
> > >                       if (key->enc_opts.dst_opt_type) {
> > > @@ -1373,14 +1371,17 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> > >                               NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
> > >                               return -EINVAL;
> > >                       }
> > > -
> > > -                     if (msk_depth)
> > > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> > >                       break;
> > >               default:
> > >                       NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
> > >                       return -EINVAL;
> > >               }
> > > +
> > > +             if (!nla_ok(nla_opt_msk, msk_depth)) {
> > > +                     NL_SET_ERR_MSG(extack, "Mask attribute is invalid");
> > > +                     return -EINVAL;
> > > +             }
> > > +             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);  
> >
> > we lost the if (msk_depth) now, nla_opt_msk may be NULL -
> > neither nla_ok() nor nla_next() take NULL  
> 
> How is "if (msk_depth)" lost when nla_ok() has a stricter one?
> 
> 1156 static inline int nla_ok(const struct nlattr *nla, int remaining)
> 1157 {
> 1158         return remaining >= (int) sizeof(*nla) &&
> 1159                nla->nla_len >= sizeof(*nla) &&
> 1160                nla->nla_len <= remaining;
> 1161 }
> 
> Line 1156 assures msk_depth is not only non-zero but also larger
> than the nla struct size, and clearly nla won't be dereferenced unless
> this check is passed.

Fair, depth will but 0 so first check already fails, but nla_next()
would crash since it tries to access the length of the attribute
unconditionally.

> I guess you mean we should not error out for nla_opt_msk==NULL
> case as masks are optional?

Yup.
