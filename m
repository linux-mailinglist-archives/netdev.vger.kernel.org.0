Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2042630FECD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBDUuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhBDUuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 15:50:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 046D164E24;
        Thu,  4 Feb 2021 20:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612471775;
        bh=VfcCFu3KBpAOs/tykuNNtUH6/tVWUklPM/YcbaSGAeQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z7dIZ9lqj9RcSZPcGNI9W4G5JVVxok7S98KICiPC+CftdHpKuv8/CncbOrqQziKGs
         aF1dzwoF3/XXvdujVPKIwGlaMpxbBHoDEdByV/nirmxfaPV0MEiwn+p4ppruXS3L+2
         043Ujc0ncLoiAv+5wiycMs9egdSfLMiMt4G2+Zh9ep4BthaoNBNwQZmh9qs5LuOpFv
         RR69H/22EYWsKog50k3R72FKyZGh2Zrj+BQqcZy5lu3vHt4/zpF2eQjkscD7xGtclH
         TdZhbIvKy9S1n2DHkvXARoQAncqCYKWgbgkx86Iw+N+r9laZvfSt5yzAa7NCG8Ysg9
         yowlF2hNQkemQ==
Date:   Thu, 4 Feb 2021 12:49:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>, wenxu@ucloud.cn
Cc:     jhs@mojatatu.com, netdev@vger.kernel.org,
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net v2] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210204124933.1f921bfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204155101.GK3399@horizon.localdomain>
References: <1612453571-3645-1-git-send-email-wenxu@ucloud.cn>
        <20210204155101.GK3399@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 12:51:01 -0300 Marcelo Ricardo Leitner wrote:
> On Thu, Feb 04, 2021 at 11:46:11PM +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > Reject the unsupported and invalid ct_state flags of cls flower rules.
> > 
> > Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
> >   
> 
> Hopefully Jakub can strip the blank line above.

Let's do one more spin, actually. Please remove this empty line between
tags wenxu.

> > +	if (state & ~TCA_FLOWER_KEY_CT_FLAGS_MASK) {
> > +		NL_SET_ERR_MSG_MOD(extack, "unsupported ct_state flags");
> > +		return -EINVAL;
> > +	}

For this check - can we use NLA_POLICY_MASK() please?

I wonder if we should use NL_SET_ERR_MSG_ATTR() for other checks.
Sadly there's no macro for both MOD and ATTR, and this is a fix,
but ATTR is probably far more informative than the module name so
I'd go with ATTR.
