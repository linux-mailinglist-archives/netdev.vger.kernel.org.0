Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562D12ADC2A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgKJQ2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJQ2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 11:28:34 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D14AC20780;
        Tue, 10 Nov 2020 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605025714;
        bh=oXZWAweYw5PK0cS1GU3G7fUcuRBZOSYTr+SxCTh7m6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GHFL+FDWoAaAXaXZf48zua7qQGkvC+mZMVvHpYYzteL9dyBiNGna3GQgxtgROQafl
         ZFFkw7R71YyvGBfsciBBdjtzYYaE7Vkv1mGlq5cJtmYIvxNPbavMGQT6GbIW6f1dbh
         VFMzYP+5C5v8RInGGx6blo0mDfuIyneWm6sKwtlc=
Date:   Tue, 10 Nov 2020 08:28:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
Message-ID: <20201110082832.4ef61eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0cd430df-167a-be86-66c5-f0838ed24641@chelsio.com>
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
        <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
        <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <043b91f8-60e0-b890-7ce2-557299ee745d@chelsio.com>
        <20201105104658.4f96cc90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a9d6ec03-1638-6282-470a-3a6b09b96652@chelsio.com>
        <20201106122831.5fccebe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8c7a1bab-3c7b-e3bf-3572-afdf2abd2505@chelsio.com>
        <20201109105851.41417807@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <0cd430df-167a-be86-66c5-f0838ed24641@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 10:37:11 +0530 Vinay Kumar Yadav wrote:
> It is not incompatible. It fits in k.org tls infrastructure (TLS-TOE 
> mode). For the current issue we have proposed a fix. What is the issue 
> with proposed fix, can you elaborate and we will address that?

Your lack of understanding of how netdev offloads are supposed to work
is concerning. Application is not supposed to see any difference
between offloaded and non-offloaded modes of operation.

Your offload was accepted based on the assumption that it works like
the software kernel TLS mode. Nobody had the time to look at your
thousands lines of driver code at the time.

Now you're telling us that the uAPI for the offload is completely
different - it only works on listening sockets while software tls 
only works on established sockets. Ergo there is no software fallback
for your offload.

Furthermore the severity of the bugs you just started to fix now, after
the code has been in the kernel for over a year suggests there are no
serious users and we can just remove this code.
