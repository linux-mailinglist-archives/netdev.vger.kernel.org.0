Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A052F6C0C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 21:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbhANU2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 15:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbhANU2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 15:28:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0589823406;
        Thu, 14 Jan 2021 20:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610656080;
        bh=oMuuhSsaKqyT9ecoEE9uqkbQCish85u+4w/VmZzYLpk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FU0w9R//Xd4Ox6Z+oe69VMwKdOmMDXFbbpNxOH/ve0C3ssi7zluA3aceH1BDom111
         EAKzvHCILkTeVI6f87jsgxHRADzbQnAmUbSyCMDKze5lQ1FIBlQCstDPORZkdTo+2d
         +bpvvMKpIz1fowkKpTGDPUfQak65Fzez3yDdKNEAbgBBVPR7ZD9n3o6r7bg6IxdBOo
         fGkkkOSF6c58K4koSTXzsbW/hOHe4fI9CT8KaBXKnc2L9UlJ+XIdU4cEBHd7cChREf
         TuR2Gv4qqDsuz/K0loD69YcMiNvIjAJY7MHBshd0M4w6sxqapK4/rcbxQXHzuduklz
         DEP6SV1lh5Xpg==
Date:   Thu, 14 Jan 2021 12:27:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net v2] cls_flower: call nla_ok() before nla_next()
Message-ID: <20210114122759.36f64003@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpXHtGhUh7Ta+hNyzJa0SsOe_c=cAO7ObB6famnp6seuGA@mail.gmail.com>
References: <20210114163822.56306-1-xiyou.wangcong@gmail.com>
        <20210114103848.5153aa5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpUPzSfbQgDE+BBySFVUqYCqse0kKQ-htN81b9JRTGYfJA@mail.gmail.com>
        <20210114121614.7fb64be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpXHtGhUh7Ta+hNyzJa0SsOe_c=cAO7ObB6famnp6seuGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 12:24:19 -0800 Cong Wang wrote:
> > Fair, depth will but 0 so first check already fails, but nla_next()
> > would crash since it tries to access the length of the attribute
> > unconditionally.  
> 
> nla_next() is only called when nla_ok() returns true, which is not
> the case for msk_depth==0, therefore NULL won't crash here.
> 
> The only problem is we become too strict to reject optionally missing
> masks, we should not even call nla_ok() here, otherwise it would
> break user-space. So,
> 
> +               if (!nla_opt_msk)
> +                       continue;
> 
> Thanks.

You're right.
