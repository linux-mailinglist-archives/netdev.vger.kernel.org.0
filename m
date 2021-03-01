Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B390327634
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 03:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhCACwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 21:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhCACwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 21:52:32 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCD1C061756;
        Sun, 28 Feb 2021 18:51:51 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id E5474C022; Mon,  1 Mar 2021 03:51:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1614567105; bh=F+Lh7tLgOo+TtdtsS58P5I40l0lHx/XnMQ8Qg4cItMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDR84AsQhMDUKebBJySfKhAIbESMHKQUzVysTTShIWc47NyTmZkjnLjW1gJR3fH9A
         sDQmHdcOEfumBRyccrv+lP4W5AByVZeNNDkRq5AHBzG3BxWS5qyubPJtb5qja0XP7R
         ehrTtbbOVF8Alo8asNJxuUYAoHSnUghW/8e7pnRej/ngxaVaK3aovH9W/HsMzNX05M
         LjMbJ+6+uEisMM1VoElf27kB/1WoX+d0GIX3ZnxuO3Eb6aJkPYffHH4PigHEEhxGAP
         Mgfcx7VbfIhPpKUk8iXjj6xpmGD6ds7SFNdnLWwB/WiYIle75rv9Ci6OVkYN1kMasv
         gI1Dv1ZYcFNDQ==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id B6E52C01B;
        Mon,  1 Mar 2021 03:51:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1614567105; bh=F+Lh7tLgOo+TtdtsS58P5I40l0lHx/XnMQ8Qg4cItMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDR84AsQhMDUKebBJySfKhAIbESMHKQUzVysTTShIWc47NyTmZkjnLjW1gJR3fH9A
         sDQmHdcOEfumBRyccrv+lP4W5AByVZeNNDkRq5AHBzG3BxWS5qyubPJtb5qja0XP7R
         ehrTtbbOVF8Alo8asNJxuUYAoHSnUghW/8e7pnRej/ngxaVaK3aovH9W/HsMzNX05M
         LjMbJ+6+uEisMM1VoElf27kB/1WoX+d0GIX3ZnxuO3Eb6aJkPYffHH4PigHEEhxGAP
         Mgfcx7VbfIhPpKUk8iXjj6xpmGD6ds7SFNdnLWwB/WiYIle75rv9Ci6OVkYN1kMasv
         gI1Dv1ZYcFNDQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 090953bd;
        Mon, 1 Mar 2021 02:51:39 +0000 (UTC)
Date:   Mon, 1 Mar 2021 11:51:24 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: free what was emitted when read count is 0
Message-ID: <YDxWrB8AoxJOmScE@odin>
References: <20210301103336.2e29da13@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210301103336.2e29da13@xhacker.debian>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jisheng Zhang wrote on Mon, Mar 01, 2021 at 10:33:36AM +0800:
> I met below warning when cating a small size(about 80bytes) txt file
> on 9pfs(msize=2097152 is passed to 9p mount option), the reason is we
> miss iov_iter_advance() if the read count is 0, so we didn't truncate
> the pipe, then iov_iter_pipe() thinks the pipe is full. Fix it by
> calling iov_iter_advance() on the iov_iter "to" even if read count is 0

Hm, there are plenty of other error cases that don't call
iov_iter_advance() and shouldn't trigger this warning ; I'm not sure
just adding one particular call to this is a good solution.


How reproducible is this? From the description it should happen
everytime you cat a small file? (I'm surprised cat uses sendfile, what
cat version? coreutils' doesn't seem to do that on their git)

What kernel version do you get this on? Bonus points if you can confirm
this didn't use to happen, and full points for a bisect.


(cat on a small file is something I do all the time in my tests, I'd
like to be able to reproduce to understand the issue better as I'm not
familiar with that part of the code)

Thanks,
-- 
Dominique
