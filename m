Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222F71810BB
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 07:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgCKGbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 02:31:18 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:43085 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKGbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 02:31:17 -0400
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 02B6VBSc001049;
        Wed, 11 Mar 2020 15:31:11 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 02B6VBSc001049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1583908272;
        bh=mEEjYZ+g7SPfvBGbp0usmZazwZG/pK4cfo+e69Wz/94=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0xE1L4gZVa5pQf1L/jmE+y6SYbQRHBoZlnSMVpcmhKCNdl5F9TMc5izykQAUefqUd
         cn2tJwt/9aQKZLeJA42BwUSyKid9pAjK0yzeDOx9NvOThSCrkjTaesO2i6ql2pVcot
         QeiQtN3CdsuS0/U09n+GieuDqOO/5krQ4jgElJ+VNAGF1L2G1lAwm2Xz3sZD0AdJyr
         LHl21K6eHdvlzZO5qinZZCNT+Ws4jDqHu5f7M6N+WujoPy0HAdRVmnjytl24myyF3x
         suJl3SgDKzVkZWIpxWYXdIVGvSyMMnoXiOVLhBB+ZcXR4iiqS2bqA1ZjIOlmdWl+Ab
         658g2WQGX7fvQ==
X-Nifty-SrcIP: [209.85.221.177]
Received: by mail-vk1-f177.google.com with SMTP id w4so221452vkd.5;
        Tue, 10 Mar 2020 23:31:11 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1PfxFuXUyMfPH688801o/YzSkAETofcrITB8R4LCY1q6U6IaFa
        du4+Wmg8UaCGmagiksXlAOaCIDZNgtrUKajhqB4=
X-Google-Smtp-Source: ADFU+vvCKPRQjwdCvZHOCpGvXimbsrP/K82eSLJbFxeu+mB/zqXzXNLtC4QloHRtdNmpy6tI6qPFP0ZLoVxoTslt+JM=
X-Received: by 2002:a1f:cbc1:: with SMTP id b184mr1007267vkg.73.1583908270440;
 Tue, 10 Mar 2020 23:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200311054953.11956-1-masahiroy@kernel.org>
In-Reply-To: <20200311054953.11956-1-masahiroy@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 11 Mar 2020 15:30:34 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQsitL-j0Z5mBC=QWUCxG2uhv1b2oaNh1daFSRwC38A=w@mail.gmail.com>
Message-ID: <CAK7LNAQsitL-j0Z5mBC=QWUCxG2uhv1b2oaNh1daFSRwC38A=w@mail.gmail.com>
Subject: Re: [PATCH] net: drop_monitor: make drop_monitor built-in
To:     Neil Horman <nhorman@tuxdriver.com>,
        Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 2:50 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.
>
> The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
> from being 'm' when NET_DEVLINK=y.
>
> With the planned Kconfig change that relaxes the 'imply', the
> combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed,
> causing a link error of vmlinux.
>
> As far as I see the mainline code, NET_DROP_MONITOR=m does not provide
> any useful case.
>
> The call-site of net_dm_hw_report() only exists in net/core/devlink.c,
> which is always built-in since NET_DEVLINK is a bool type option.
>
> So, NET_DROP_MONITOR=m causes a build error, or creates an unused
> module at best.
>
> Make NET_DROP_MONITOR a bool option, and remove the module exit code.
> I also unexported net_dm_hw_report because I see no other call-site
> in upstream.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>


Sorry, I take this back.
This is probably not the right fix.



I just sent an alternative patch.
( Replace IS_ENABLE with IS_REACHABLE )


-- 
Best Regards
Masahiro Yamada
