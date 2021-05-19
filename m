Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAA13892D6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354952AbhESPo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 11:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242076AbhESPoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 11:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F7860D07;
        Wed, 19 May 2021 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621438980;
        bh=KaSVb/oZ/hbXppu3Y0486KwtT3znvB8EkCNw1WfZ//o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vE468iAEIhQmaJ20YTgK/EOOfR+ctZemzuvMSUU67Mh05ibc6eUXvTZkexo13jsTM
         ZWEIHAygjyv4aNy2oRzUSlhDMeZb63l3XO+swZPuJ7LgJMAJwFrtFHEEeAcfwvNkLv
         lsUYnNheTWjcRjjU7Os4QhfQLc4tpMkvCBCHFAqw=
Date:   Wed, 19 May 2021 17:42:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeff Johnson <jjohnson@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jjohnson=codeaurora.org@codeaurora.org
Subject: Re: [PATCH v2] b43: don't save dentries for debugfs
Message-ID: <YKUyAoBq/cepglmk@kroah.com>
References: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
 <891f28e4c1f3c24ed1b257de83cbb3a0@codeaurora.org>
 <f539277054c06e1719832b9e99cbf7f1@codeaurora.org>
 <YKScfFKhxtVqfRkt@kroah.com>
 <2eb3af43025436c0832c8f61fbf519ad@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2eb3af43025436c0832c8f61fbf519ad@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 08:04:59AM -0700, Jeff Johnson wrote:
> On 2021-05-18 22:05, Greg Kroah-Hartman wrote:
> > On Tue, May 18, 2021 at 03:00:44PM -0700, Jeff Johnson wrote:
> > > On 2021-05-18 12:29, Jeff Johnson wrote:
> > > Would still like guidance on if there is a recommended way to get a
> > > dentry not associated with debugfs.
> > 
> > What do you exactly mean by "not associated with debugfs"?
> > 
> > And why are you passing a debugfs dentry to relay_open()?  That feels
> > really wrong and fragile.
> 
> I don't know the history but the relay documentation tells us:
> "If you want a directory structure to contain your relay files,
> you should create it using the host filesystem’s directory
> creation function, e.g. debugfs_create_dir()..."
> 
> So my guess is that the original implementation followed that
> advice.  I see 5 clients of this functionality, and all 5 pass a
> dentry returned from debugfs_create_dir():
> 
> drivers/gpu/drm/i915/gt/uc/intel_guc_log.c, line 384
> drivers/net/wireless/ath/ath10k/spectral.c, line 534
> drivers/net/wireless/ath/ath11k/spectral.c, line 902
> drivers/net/wireless/ath/ath9k/common-spectral.c, line 1077
> kernel/trace/blktrace.c, line 549

Ah, that's just the "parent" dentry for the relayfs file.  That's fine,
not a big deal, debugfs will always provide a way for you to get that if
needed.

thanks,

greg k-h
