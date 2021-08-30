Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA903FBB68
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhH3SGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238265AbhH3SGq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 14:06:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39C8660F92;
        Mon, 30 Aug 2021 18:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630346752;
        bh=yBsULqO69nDH7pZARuM9vk2OOZzs8KZhiDfM0e6XAro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i+OX2QV7oSmtpwBmVbZ0udwXH1exskmS6Q/mIbRTRJQcxk3CWCGOGMOaluCxEHlQs
         Xov2lzYvp9lykUHI0+y93of+rZO++UkR/Ri/mjjsLZxO+TV5MxTr+U4ayapFSNJfvU
         xGAewOA6zJ0rWJcNmQUxUsZ1EcOCExPCQFtvTCRg/4Y63fjYt3DidWBxFZGyE7Nk5X
         U26A5hcX7KipknOaQeNi6h2svY0Z+NB33gkcA3vzOetyCk2IRstBmiTbpMVJ2MK+M2
         L28LoCJS5mUVUOVLgQ8kvgn0QRHIGuB6wsbCpl0XB3HLSPLdkAPCnR86xtzamtPHao
         f7Su5oTeza0Dg==
Date:   Mon, 30 Aug 2021 11:05:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: Fix qdisc_rate_table refcount leak when get
 tcf_block failed
Message-ID: <20210830110551.730c34c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1630252681-71588-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1630252681-71588-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Aug 2021 23:58:01 +0800 Xiyu Yang wrote:
> The reference counting issue happens in one exception handling path of
> cbq_change_class(). When failing to get tcf_block, the function forgets
> to decrease the refcount of "rtab" increased by qdisc_put_rtab(),
> causing a refcount leak.
> 
> Fix this issue by jumping to "failure" label when get tcf_block failed.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>

Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
