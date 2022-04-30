Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C7351596F
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 02:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380028AbiD3Ayi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 20:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240034AbiD3Ayg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 20:54:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9151233A37
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 17:51:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DC8D6246A
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 00:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCF8C385A7;
        Sat, 30 Apr 2022 00:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651279876;
        bh=jX7eUrV7j+cvceaJXIqx4fZhKDwK71UIqUl97mqcCaQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uiZLnOT+8Gfpz4nY6Rf7e3JHwqIQAOFaMlj5qzM2gGCZ6UNukZCzxSN/ZnWwn2jlv
         79vRMZ8O8+7CyXBiWHxwPQPqEzaQfAh40uIA0Tkoev6fd1pA+IcpQkDl4rJx9sE7u7
         bzds8J30t3gpJHHlHDPJejX3Vw20yTgGS5nf6hHlvZctjWgFtm5yoQ4CX7ExqQMRbM
         dfgonwmz6NlCzMuHYVkaHzg06Iy16gMxuta/HsdfsdbaAtNYYwOwEaGleD/jxmcgIW
         9CeVb8fQqIcYgiv9vtVeOh9Fv9Ec56cEZtxbHZv6eL9rWjj+zOsYv1jRILnLDcEk5a
         gCQHy8OggYNUA==
Date:   Fri, 29 Apr 2022 17:51:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 0/6] mptcp: Path manager mode selection
Message-ID: <20220429175114.2500d3a9@kernel.org>
In-Reply-To: <23ff3b49-2563-1874-fa35-3af55d3088e7@linux.intel.com>
References: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com>
        <20220428185739.39cdbb33@kernel.org>
        <23ff3b49-2563-1874-fa35-3af55d3088e7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 20:39:01 -0700 (PDT) Mat Martineau wrote:
> Sure, no problem. If you'd prefer a pull request for this feature as a 
> whole I could stage that.
> 
> Here's a tag (note: do not merge this as-is, the committer ids and full 
> history aren't suitable) -> 
> https://github.com/multipath-tcp/mptcp_net-next/commits/netdev-review-userspace-path-manager
> 
> The last 26 commits there cover the full userspace path manager kernel 
> code, with the first 6 of those being this series.
> 
> Userspace path managers makes use of generic netlink MPTCP events that 
> have already been upstream for a while, and the full series adds four 
> netlink commands for userspace:
> 
> * MPTCP_PM_CMD_ANNOUNCE: advertise an address that's available for 
> additional subflow connections.
> 
> * MPTCP_PM_CMD_REMOVE: revoke an advertisement
> 
> * MPTCP_PM_CMD_SUBFLOW_CREATE: initiate a new subflow on an existing MPTCP 
> connection
> 
> * MPTCP_PM_CMD_SUBFLOW_DESTROY: close a subflow on an existing MPTCP 
> connection
> 
> There's one commit for each command, each with an obvious title ("mptcp: 
> netlink: Add MPTCP_PM_CMD_<name>")

Thanks for the explanation, applied!
