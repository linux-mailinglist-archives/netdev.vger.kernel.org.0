Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020E145E6CA
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 05:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358415AbhKZEWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 23:22:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234851AbhKZEUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 23:20:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D18C61106;
        Fri, 26 Nov 2021 04:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637900251;
        bh=S5s2dGbIC0xyuXFbz4DWp0PcL/REt8x8NlI07YbZI7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VPh1AtsPbL6o8LfUF/Qo/m+T66fWmv9Yg/EbtdBsOtWnfAhEJAN1a+rvSf+x0+GI9
         cim2YIx1IOnxh/c29M3JvKd89E8qS7rRY7zza0JI80lbWVWPGYSe+BDCb2NPxaHbQ2
         SFk0K5riliheEpy2+5nXc4lQGthNmRfzret2miR66h7Yyc5pf/6NXReZcYcG0v/t5H
         7dGGZUH0YYAQpVT/qBWBt7Q4RYcAKOvivMUFcajXv1d5T6ciTYpfxbyGfnLnXKrqeL
         GbBXHJoA1sAMM9FVlaWc+SR8IwEmHW2+dFT4pEigxqP2+C6CYWKNED3dODeJen6kEb
         o9SAGyWrq6EiA==
Date:   Thu, 25 Nov 2021 20:17:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     vijayendra.suman@oracle.com, ramanan.govindarajan@oracle.com,
        george.kennedy@oracle.com, eric.dumazet@gmail.com,
        syzkaller <syzkaller@googlegroups.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sched: sch_netem: Fix a divide error in
 netem_enqueue during randomized corruption.
Message-ID: <20211125201729.15728683@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124104716.25882-1-harshit.m.mogalapalli@oracle.com>
References: <20211124104716.25882-1-harshit.m.mogalapalli@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 02:47:15 -0800 Harshit Mogalapalli wrote:
> In netem_enqueue function the value of skb_headlen(skb) can be zero
> which leads to a division error during randomized corruption of the
> packet. This fix  adds a check to skb_headlen(skb) to prevent the division
> error.

Empty skbs are not sane. Is it just the fact that netlink_sendmsg()
does not pay much attention to len that's the problem? Can we fix that
instead?
