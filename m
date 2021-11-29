Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78661462080
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345064AbhK2Tc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242344AbhK2Ta5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F77C061A14;
        Mon, 29 Nov 2021 07:47:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F97B61536;
        Mon, 29 Nov 2021 15:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7654CC53FCB;
        Mon, 29 Nov 2021 15:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638200851;
        bh=FfASUp8MlbvHvvn0UoveDoyAdYm0syeQrhTp3gcGOUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L+6BaPI93HhxS45hgiy3jcoMgNYYuXZdMIWfOwORrI7FYDO1WLrNQMXjx3Jp2M2ui
         h7qRwD4MSS0XjKMaZrTCSfj8az+yz1iorVgdf4zE2Tr8+GOAKOXQjgq5NTU5Gmdd5C
         xJTyd5qV2+QHeBs2pTBPk1m6VkCC6ZfIKRyOXv1PDA1K4qCypEf8tU8890pk141j5g
         AlQibNu4VkiJqHX4EL4uh7Y4r268nuxkfJ1NyHfTl876543ZFzi9Yhe/M8KNhk0kHD
         vAI96aUA/0gC9ahEu3Mm73nYNaUzZs45/ieioYJF1O88VmG4acYk3WQpOCwWSFpJf3
         W0w/BH/rVFWaA==
Date:   Mon, 29 Nov 2021 07:47:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        ramanan.govindarajan@oracle.com, george.kennedy@oracle.com,
        vijayendra.suman@oracle.com,
        syzkaller <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Yajun Deng <yajun.deng@linux.dev>,
        David Ahern <dsahern@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: netlink: af_netlink: Prevent empty skb by
 adding a check on len.
Message-ID: <20211129074730.277eebc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211127092841.57b6a217@hermes.local>
References: <20211127081458.6936-1-harshit.m.mogalapalli@oracle.com>
        <20211127092841.57b6a217@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Nov 2021 09:28:41 -0800 Stephen Hemminger wrote:
> Are you sure no application is doing zero length send for some
> reason?
> Maybe doing the check in netlink_deliver_tap would be less likely
> to cause visible change in behavior to applications.

That's still a uAPI change, and leads to less obvious code.

I'd prefer to stick to the current patch which at least signals very
clearly that the functionality has been broken by returning an error 
to the caller, and we can rethink if anyone actually complains.

Maybe adding a pr_warn_once() to the case would save the hypothetical
user/developer some time, too?
