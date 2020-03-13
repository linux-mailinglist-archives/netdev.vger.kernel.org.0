Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25DF51840EA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCMGpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:45:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38003 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgCMGpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:45:05 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so9290716ljh.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 23:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=MBjltrpzVuy71coDrjqZ/jRZcEj3O4VWUM3lq7hMfBA=;
        b=IfE9P4GCCEyEBb0VtXp2eqPnj81jkJKGcVbYkuZ6a41UaSBz8OoXExltNo0LdxU1jP
         7R43kUh1VVDaLJFvEfQUgqiTMOjwhG3RzH7DbOdF7SlhATVmtKrr07xO4q+giUIdQ768
         g8R+rUKOQCsm0A9FpsZz1Xmi3JR7OjVnugcnL6lMGlQwJbPW2ivDZDFbCioRsoZlNPC/
         WmGdYADnzFOZ2v5uQM476FjXn804xCh6jmd8PDpgnYGiIsjrxHp4XyB7ROoYZwJ7ochr
         VmLPtPfhQ6aGfeaJ8UuMLGeHBJZ9eiN8XX4SA3Oh7H3eQnZ7NK2MaW5CIKVj/ajd19FI
         5oBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=MBjltrpzVuy71coDrjqZ/jRZcEj3O4VWUM3lq7hMfBA=;
        b=HuQAEaBE8jdjjt6jTdqCSSRmFuBya47Md2A+5I0PMDIAI/WWaX6LyBmRcnFG5wOxrP
         omu3J9k5MZpF3GvW1E8YNuXEVr8mWiE1puYBaPaUTkPX4LajoeBMAi8tCZ+HOXdMwHnO
         P7IVdrPi6z50tUY+PzTHre1pTs6uvMsKzhACrWTJcgp4xSQuuRgl4EPtLiAwcDt1OISr
         hwm4EvXp9xfeSQFBrpA3FF4ysWeCTJ5TexPDSbzjt51PlyqV+iK8A8cJRuNGyz49Ripu
         DNIOMApWuP0vdVJNRZSTXHe+AZU1C7uRvM0U7V+7uqt1LJ9G4GMAio98nmMbvPI1e2JE
         Widw==
X-Gm-Message-State: ANhLgQ1ILlwCgLChuYv+QxQSOKMhvW2ZpIlB1a/zIPPP7XgPsvgJ4aTE
        yx0Ah37czadbnjM7NYjkBF/ms2XJ4MpAeqfGA5E=
X-Google-Smtp-Source: ADFU+vu4IfqqFhuMy3ZcP3/XpIFYBbbiWPMWBT7kR6cskKhU5b0JehzD7vqzp5hwzmW8ExJm5B5674PPkTb6t6hPdaw=
X-Received: by 2002:a2e:9252:: with SMTP id v18mr7469945ljg.114.1584081903147;
 Thu, 12 Mar 2020 23:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200313020502.31341-1-ap420073@gmail.com>
In-Reply-To: <20200313020502.31341-1-ap420073@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 13 Mar 2020 15:44:51 +0900
Message-ID: <CAMArcTWw6Kqg2+PZ10F9f8ASm40wEgUq6jhVrWAKu7XC_FYmjQ@mail.gmail.com>
Subject: Re: [PATCH net 0/3] hsr: fix several bugs in generic netlink callback
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 at 11:05, Taehee Yoo <ap420073@gmail.com> wrote:
>
> This patchset is to fix several bugs they are related in
> generic netlink callback in hsr module.
>
> 1. The first patch is to add missing rcu_read_lock() in
> hsr_get_node_{list/status}().
> The hsr_get_node_{list/status}() are not protected by RTNL because
> they are callback functions of generic netlink.
> But it calls __dev_get_by_index() without acquiring RTNL.
> So, it would use unsafe data.
>
> 2. The second patch is to avoid failure of hsr_get_node_list().
> hsr_get_node_list() is a callback of generic netlink and
> it is used to get node information in userspace.
> But, if there are so many nodes, it fails because of buffer size.
> So, in this patch, restart routine is added.
>
> 3. The third patch is to set .netnsok flag to true.
> If .netnsok flag is false, non-init_net namespace is not allowed to
> operate generic netlink operations.
> So, currently, non-init_net namespace has no way to get node information
> because .netnsok is false in the current hsr code.
>

I found that the second patch doesn't preserve reverse christmas tree
variable ordering.
So, I will send a v2 patch.


> Taehee Yoo (3):
>   hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
>   hsr: add restart routine into hsr_get_node_list()
>   hsr: set .netnsok flag
>
>  net/hsr/hsr_framereg.c |  9 ++-----
>  net/hsr/hsr_netlink.c  | 61 +++++++++++++++++++++++++++---------------
>  2 files changed, 41 insertions(+), 29 deletions(-)
>
> --
> 2.17.1
>
