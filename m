Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB662ADE2C
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgKJSXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:23:32 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7322 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730618AbgKJSXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:23:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5faadaaa0001>; Tue, 10 Nov 2020 10:23:38 -0800
Received: from reg-r-vrt-018-180.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 10 Nov 2020 18:23:30 +0000
References: <1604989686-8171-1-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <wenxu@ucloud.cn>
CC:     <kuba@kernel.org>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 net-next 0/3] net/sched: fix over mtu packet of defrag in
In-Reply-To: <1604989686-8171-1-git-send-email-wenxu@ucloud.cn>
Date:   Tue, 10 Nov 2020 20:23:27 +0200
Message-ID: <ygnha6vpvzog.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605032618; bh=KCtShd+nZuOLEqX+qOJb6grTT0BK0nireSleso+AFA8=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=oU1+py/C6E1trI2MRH133JjUuQictrcLbPoJye0rCIa1GxZJc07ZPIk1RmeWSekU1
         22Gp6dgPeaANiPuoDSucBQKt/zxISYaTCTWnp+5bstTZt3gdOxQNOu0gHtNOV8TjoC
         am7VaBGJ8NSVaPJ7mtejACDt62pedR+PBQJKhfjLhmFeShMZbXMBbwHWqEukF0NtE+
         mAxYhPEYe5sQc/gg30zSCQPyVoigoXKZFBJ7/TXf3LwKkE9Vs7T3YdFNpst+N9Q7tj
         PWR/JYajjvb3xfZVz08WwqFQMcMCzrih7KuNIInzdc6LS1xfN9LccQ0JcwImQdk+Jm
         x2yRJh+kfvkWg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 10 Nov 2020 at 08:28, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
>
> The first patch fix miss init the qdisc_skb_cb->mru
> The send one refactor the hanle of xmit in act_mirred and prepare for the
> third one
> The last one add implict packet fragment support to fix the over mtu for
> defrag in act_ct.
>
> wenxu (3):
>   net/sched: fix miss init the mru in qdisc_skb_cb
>   net/sched: act_mirred: refactor the handle of xmit
>   net/sched: act_frag: add implict packet fragment support.
>
>  include/net/act_api.h     |  16 +++++
>  include/net/sch_generic.h |   5 --
>  net/core/dev.c            |   2 +
>  net/sched/Kconfig         |  13 ++++
>  net/sched/Makefile        |   1 +
>  net/sched/act_api.c       |  47 +++++++++++++
>  net/sched/act_ct.c        |   7 ++
>  net/sched/act_frag.c      | 164 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/sched/act_mirred.c    |  21 ++++--
>  9 files changed, 265 insertions(+), 11 deletions(-)
>  create mode 100644 net/sched/act_frag.c

Hi,

I ran our CT tests with this series and kernel debug configs enabled
without any issue.

Tested-by: Vlad Buslov <vladbu@nvidia.com>
