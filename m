Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6988A4E577A
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343589AbiCWRaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343573AbiCWRaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:30:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66E55AA4A;
        Wed, 23 Mar 2022 10:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74C8060BA8;
        Wed, 23 Mar 2022 17:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEFCC340E8;
        Wed, 23 Mar 2022 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648056520;
        bh=aBhuHAboOdtdntqv58RsLj1elUW0/sNcvaZEifl9nPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FslTOWbpZIrKHWZguvaNvmRG15ldbTWzYBtD9Vf4Zviuha1M+mapY7YEikownSP5G
         H/SaYTSY9OWQk+VmfuPiiGKJvT7c7wYyCO1IlHlbMLpuTDMw/pWHTmRv+XEeGdLgd+
         dBk23QMMvfaBx/MJSGczwpMwshPa6kwxvfgK7k6/kjD1/o6F1qAJQsUftm9hQq2Lsi
         YuruyhBAkl+EO+5U918QgrxvMO4dKNPgTdkRHtVNtfDZUIOdNz25wZ+uPEy7KFLqBV
         5hrbk7GXxxUdRMcEsDqcwuHDbOrOS+enqlHWIe1bToE5BAMlFEhr6dniOh1pk17jiS
         KRy3u3tdBsuVg==
Date:   Wed, 23 Mar 2022 10:28:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Sun Shouxin <sunshouxin@chinatelecom.cn>, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v6 0/4] Add support for IPV6 RLB to balance-alb mode
Message-ID: <20220323102839.27ecc4a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4913.1648053525@famine>
References: <20220323120906.42692-1-sunshouxin@chinatelecom.cn>
        <7288faa9-0bb1-4538-606d-3366a7a02da5@kernel.org>
        <20220323083332.54dc0a6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4913.1648053525@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 09:38:45 -0700 Jay Vosburgh wrote:
> 	The summary (from my perspective) is that the alb/rlb technology
> more or less predates LACP, and is a complicated method to implement
> load balancing across a set of local network peers.  The existing
> implementation for IPv4 uses per-peer tailored ARP messages to "assign"
> particular peers on the subnet to particular bonding interfaces.  I do
> encounter users employing the alb/rlb mode, but it is uncommon; LACP is
> by far the most common mode that I see, with active-backup a distant
> second.
> 
> 	The only real advantage alb/rlb has over LACP is that the
> balance is done via traffic monitoring (i.e., assigning new peers to the
> least busy bond interface, with periodic rebalances) instead of a hash
> as with LACP.  In principle, some traffic patterns may end up with hash
> collisions on LACP, but will be more evenly balanced via the alb/rlb
> logic (but this hasn't been mentioned by the submitter that I recall).
> The alb/rlb logic also balances all traffic that will transit through a
> given router together (because it works via magic ARPs), so the scope of
> its utility is limited.
> 
> 	As much as I'm all in favor of IPv6 being a first class citizen,
> I haven't seen a compelling use case or significant advantage over LACP
> stated for alb/rlb over IPv6 that justifies the complexity of the
> implementation that will need to be maintained going forward.

That's pretty clear, thanks!

Sun Shouxin please do not post new revisions of the patches
unless you can convince Jay your use case is strong enough,
first.
