Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88E1362747
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243997AbhDPR6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236242AbhDPR6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 13:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9ABD611AB;
        Fri, 16 Apr 2021 17:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618595856;
        bh=pLllX/ftZ98gDGCucqoexhXesAQdKxp7bgDkdCXVwHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uOnWk4W2lyP6cCmiVwb6rxIaGWOZ+FOIdkDShZtEalTj24ZH8x49c79fmeTHtH3yp
         GDu2smEZ+KWnUSuH3eWE5TQeCRu1y3fUxRg1t9n55ttDMu8YbIjew6TwZIfeOvZCh8
         Q6Mu61OcaliUWwhwCPrLev0Z8+9sEh0f5FRmFoQBJLI5zL3e1j5rFjV4AMFk8851H4
         bJUZnPS0uYbHExAxVRV94dt/o0d3torYtSQWcwNfp0c9H2knzbmwqrSK5afKMTH5pv
         fawdC1mk0Epn+/kTMUczghfVIqaNu1GE5raZo+J+7XIynmjydzmVVp6sq8uv57EC/B
         5krJeyrHvvfgA==
Date:   Fri, 16 Apr 2021 10:57:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH net-next] scm: optimize put_cmsg()
Message-ID: <20210416105735.073466b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415173753.3404237-1-eric.dumazet@gmail.com>
References: <20210415173753.3404237-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 10:37:53 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Calling two copy_to_user() for very small regions has very high overhead.
> 
> Switch to inlined unsafe_put_user() to save one stac/clac sequence,
> and avoid copy_to_user().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>

Hi Eric!

This appears to break boot on my systems.

IDK how exactly, looks like systemd gets stuck waiting for nondescript
services to start in initramfs. I have lots of debug enabled and didn't
spot anything of note in kernel logs.

I'll try to poke at this more, but LMK if you have any ideas. The
commit looks "obviously correct" :S
