Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584F8313E04
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhBHStk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234129AbhBHSsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 13:48:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E70764E73;
        Mon,  8 Feb 2021 18:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612810080;
        bh=61CCMFssdAMQvf8RcbtzaPbzokzik4DuhFO16o8WIQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oraOYJbxkAStRu2KZFA51YLnWMixUw8WeP8AjZmSv14Fwd9ZMc9tBtFgNaBfMGzR9
         u2MCGhHwEoL5cEz6kR6va3zbslUB0enS1HHq/ES1wG3CFpdGsVHv9ND0141hRodinv
         9D69bIFFXevR/9Lxun4nBNawJA8rxR4jaCAUuoa8vBJi/BNj7XsMlQD3WDw4SItx8a
         CMLOphVrnc+KT4Vm0ygQ/WKiqhhUmPvQwO/uSBLpTY4IF57GATE8DX//exAe8bRwNu
         +c3kW5HLZxFUw4GLjBKUsa0SxPLr32ZEVHfTqsng+sAWAKUw0DYCKMpQMk70jN3kgr
         2fBEX8C6FRjCA==
Date:   Mon, 8 Feb 2021 10:47:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>, Jamal Hadi Salim <jhs@mojatatu.com>,
        mleitner@redhat.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net v4] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210208104759.77c247c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpXojFaYogRu76=jGr6cp74YcUyR_ZovRnSmKp9KaugBOw@mail.gmail.com>
References: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
        <CAM_iQpXojFaYogRu76=jGr6cp74YcUyR_ZovRnSmKp9KaugBOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 10:41:35 -0800 Cong Wang wrote:
> On Sat, Feb 6, 2021 at 9:26 PM <wenxu@ucloud.cn> wrote:
> > +       if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
> > +               NL_SET_ERR_MSG_ATTR(extack, tb,
> > +                                   "ct_state no trk, no other flag are set");
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> > +           state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
> > +               NL_SET_ERR_MSG_ATTR(extack, tb,
> > +                                   "ct_state new and est are exclusive");  
> 
> Please spell out the full words, "trk" and "est" are not good abbreviations.

It does match user space naming in OvS as well as iproute2:

        { "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
        { "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
        { "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
        { "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID },
        { "rpl", TCA_FLOWER_KEY_CT_FLAGS_REPLY },

IDK about netfilter itself.
