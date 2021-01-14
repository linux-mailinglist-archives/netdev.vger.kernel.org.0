Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62842F6E3B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbhANWam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729214AbhANWam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 17:30:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A80323A79;
        Thu, 14 Jan 2021 22:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610663401;
        bh=+c6DWlKSl5NkhNBwk1fJoSFOpmxUjZSXMYzfqFGpqt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SF6u978rh6xQ927v18VDN0Fg2Yy+kEfklRfZ1V5R6T+lscFw+Wc6Di7HSc6V+TzoN
         NAr/ZdeeWvLBLDWu65XyMaV3Jv8YglhDHI8YjicyFxJ/e2IGOZXoYnLXfErPS6a+fb
         t4k5lnXw7Kl6pQ1OBm5EVr4X+dM1xKMDmrTK4zFAq66MJqA/Sf4N9L0zAqixtIq6zx
         Nk1hpqMbp1ikvTf4/DGe8965sSPpYRZHrmlOA7dYZavsDpGaZQUlys/dKTtepkeHAZ
         cwjsZorxq32rHl+LFBZO0RKv/LUiJPCexsfMAfo/1fj/T6mvQUvg5U6ZicXC8In7MH
         4a2Vmjle2ihig==
Date:   Thu, 14 Jan 2021 14:30:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net v3] cls_flower: call nla_ok() before nla_next()
Message-ID: <20210114143000.4bfca23a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpVAer0tBocMXGa0G_8jqJVz5oJ--woPo+TrtzVemyz+rQ@mail.gmail.com>
References: <20210114210749.61642-1-xiyou.wangcong@gmail.com>
        <20210114133625.0d1ea5e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpVAer0tBocMXGa0G_8jqJVz5oJ--woPo+TrtzVemyz+rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 13:57:13 -0800 Cong Wang wrote:
> On Thu, Jan 14, 2021 at 1:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 14 Jan 2021 13:07:49 -0800 Cong Wang wrote:  
> > > -                     if (msk_depth)
> > > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> > >                       break;
> > >               default:
> > >                       NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
> > >                       return -EINVAL;
> > >               }
> > > +
> > > +             if (!nla_opt_msk)
> > > +                     continue;  
> >
> > Why the switch from !msk_depth to !nla_opt_msk?  
> 
> It is the same, when nla_opt_msk is NULL, msk_depth is 0.
> Checking nla_opt_msk is NULL is more readable to express that
> mask is not provided.
> 
> >
> > Seems like previously providing masks for only subset of options
> > would have worked.  
> 
> I don't think so, every type has this check:
> 
>                         if (key->enc_opts.len != mask->enc_opts.len) {
>                                 NL_SET_ERR_MSG(extack, "Key and mask
> miss aligned");
>                                 return -EINVAL;
>                         }
> 
> which guarantees the numbers are aligned.
> 
> Thanks.

static int fl_set_vxlan_opt(const struct nlattr *nla, struct fl_flow_key *key,
			    int depth, int option_len,
			    struct netlink_ext_ack *extack)
{
	struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1];
	struct vxlan_metadata *md;
	int err;

	md = (struct vxlan_metadata *)&key->enc_opts.data[key->enc_opts.len];
	memset(md, 0xff, sizeof(*md));

	if (!depth)
		return sizeof(*md);
		^^^^^^^^^^^^^^^^^^^

The mask is filled with all 1s if attribute is not provided.
