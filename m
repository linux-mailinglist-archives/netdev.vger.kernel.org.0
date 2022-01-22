Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72AD49699E
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 04:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiAVDlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 22:41:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43644 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiAVDlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 22:41:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25002B81E19;
        Sat, 22 Jan 2022 03:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F242C340E1;
        Sat, 22 Jan 2022 03:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642822858;
        bh=igEU1QuiHanlHIFCByVGoT1A/m68UIGIsY0mOD/CqdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lff2RYkwS/qEobQS3/JbW6I+jGSUHhKefhpZqvIgA6DA/PEO+RzzADhCif78S53ew
         sQtqIDERna42Ql0BpsqBhyroFNTjKa8med8QoXj55IZRz1lwpwVQB+wXmmzobcr3zA
         9yzqrxXJ+vJ29E2hd8Csf/Hgzp5bPr+uZFg6MIqJz352EArJ4u/Po6/dbs3CepmCLP
         Oos9PV/f1QOaahscV/I6E1Cn48FGhjNyVl0W2nV3g8vLWO0/3ICtWfKwaWbjT0Axit
         t6PUbqheqY8I+cYhdphyh4ltAK+joFk5dVBncOpaAh14GqOWIrPkzorVpAGrLDsQYZ
         QYMB7P1P4U2xA==
Date:   Fri, 21 Jan 2022 19:40:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] net-core: add InMacErrors counter
Message-ID: <20220121194057.17079951@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220122000301.1872828-1-jeffreyji@google.com>
References: <20220122000301.1872828-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jan 2022 00:03:01 +0000 Jeffrey Ji wrote:
> From: jeffreyji <jeffreyji@google.com>
> 
> Increment InMacErrors counter when packet dropped due to incorrect dest
> MAC addr.
> 
> example output from nstat:
> \~# nstat -z "*InMac*"
> \#kernel
> Ip6InMacErrors                  0                  0.0
> IpExtInMacErrors                1                  0.0
> 
> Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> counter was incremented.
> 
> Signed-off-by: jeffreyji <jeffreyji@google.com>

How about we use the new kfree_skb_reason() instead to avoid allocating
per-netns memory the stats?
