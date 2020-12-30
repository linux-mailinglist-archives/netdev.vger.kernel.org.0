Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFBC2E76CE
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 08:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgL3HS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 02:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgL3HS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 02:18:29 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEB2C06179B;
        Tue, 29 Dec 2020 23:17:48 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 14555C01E; Wed, 30 Dec 2020 08:17:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1609312667; bh=HCaSoQg8ICQUetSY/RdCKPwts6rtqy9M+q2/JVAQ/U0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RgexwDLJ7hCvc7e+ifUEjQVJ9zgsIRmVxms2KvvSQh5c8ycXyuHKb4fOXRlrtKvGa
         suHrv2Rcao3ByqqlGDS1SisNsOMbeNzfVECfuL9rfcbT3Fb8c/16Ut/PT+ToQu6mn9
         KyRT6CISOBg81zLwtNcpFKY9lAaNCWxAoqck6cBN4JvHsB45CmGhgfSC00+uXnF/k0
         IZxdzBFDxVNNj0BGVg0drdAZM3CyT5qnCzsKV+skAe1DXOeY2mPeXk2IUxtZW5Hxi/
         TcpVg7TQFmjoJZcZlgd9wWep1Bp0GHjT8Yk/4TRLExy4F6q+YcMc7sWw0qABFG/7DB
         i3+ir71hKCkYw==
Date:   Wed, 30 Dec 2020 08:17:32 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ericvh@gmail.com,
        lucho@ionkov.net, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix: Uninitialized variable p.
Message-ID: <20201230071732.GA4256@nautica>
References: <1609310713-84972-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1609310713-84972-1-git-send-email-abaci-bugfix@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YANG LI wrote on Wed, Dec 30, 2020:
> The pointer p is being used but it isn't being initialized,
> need to assign a NULL to it.

My understanding is p has to be initialized: the only way out of the
while(1) loop below sets it.


I don't mind fixing false positive warnings as it makes maintenance
easier for everyone, but:

 1/ the commit message needs to reflect that and at least name which
tool had a problem with it. I'm tempted to think this case is common
enough that the tool ought to be fixed instead...

 2/ the code needs to work in the p=NULL case if you set it that way
(right now, it doesn't, so in the event the code changes in the future
and there really comes a way to skip initialization this change would
actually hinder bug detection -- it'd need to add a p == NULL check
below, which is going to be useless code, but hopefully compilers will
optimize it away)


Thanks,
-- 
Dominique
