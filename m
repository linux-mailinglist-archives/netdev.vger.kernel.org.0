Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854A937CC35
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhELQnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 12:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234285AbhELQIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 12:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC2261447;
        Wed, 12 May 2021 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620833956;
        bh=3OKE5hvIdwuXgAtAcX9qP9UHIBPfVufpxaoy+qmN7ik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ax9+eTqIZr/T8ny36CIMXGA9hNYiTeTt9XbyhxfEPDGXfPAWU5nG5S/zjLcbQdn2T
         qPOwqL20LTk856KlTtKDU367ck3i3dA3AxM4oeR6uX48dP/RFymAX834uZPxeBcu8w
         eUcelaBUPJW2GP0qFvlCmVOjyJtRYoBeyK/GD7wHbr1RbbuwdOc6IS4l25COBK2Ja7
         iu+uG26ufHxyBoZgBdISpfOm8q7sTncmgVeSdropTh79gPy81Kfu0hcfLyGW9KcCnc
         r5pDV9LfJZzg1KLwXF88yxTD8qEgSGadtSIACQ4/iSl9w0RmSOm7AVqyHtG8gaKCby
         4IP1ixvg62zpg==
Date:   Wed, 12 May 2021 08:39:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rocco yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>
Subject: Re: [PATCH][v3] rtnetlink: add rtnl_lock debug log
Message-ID: <20210512083913.733f9803@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210511113257.2094-1-rocco.yue@mediatek.com>
References: <20210511113257.2094-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 May 2021 19:32:57 +0800 Rocco yue wrote:
> We often encounter system hangs caused by certain process
> holding rtnl_lock for a long time. Even if there is a lock
> detection mechanism in Linux, it is a bit troublesome and
> affects the system performance. We hope to add a lightweight
> debugging mechanism for detecting rtnl_lock.
> 
> Up to now, we have discovered and solved some potential bugs
> through this lightweight rtnl_lock debugging mechanism, which
> is helpful for us.
> 
> When you say Y for RTNL_LOCK_DEBUG, then the kernel will
> detect if any function hold rtnl_lock too long and some key
> information will be printed out to help locate the problem.
> 
> i.e: from the following logs, we can clearly know that the
> pid=2206 RfxSender_4 process holds rtnl_lock for a long time,
> causing the system to hang. And we can also speculate that the
> delay operation may be performed in devinet_ioctl(), resulting
> in rtnl_lock was not released in time.

You can achieve that with a pair of fexit/fentry hooks or kprobes,
and maybe a bit of BPF. No need for config options, and hardcoded
parameters..
