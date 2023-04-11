Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E86DCE7D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 02:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjDKAco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 20:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDKAcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 20:32:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBD32D49;
        Mon, 10 Apr 2023 17:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B37861FA7;
        Tue, 11 Apr 2023 00:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F5AC433EF;
        Tue, 11 Apr 2023 00:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681173149;
        bh=IPQiRaKv5N4+opLgH2RmWIdytX47K28TWJ6fB7F/4ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mDi/A2//d0R/Hvzon1hhED+jHJkvRVjIcq+GQTe+sjEF9gvI+4ZE9mPM4+M6hmLQ6
         QxfVMnujtGa1rq/6epuadF4HtpZgZKwtxmeekxccb4VS6pVXcDocWEDevHyyUup+ZZ
         88mF/mXduHMi8DLt1Oogc31S9dWEH/0z6hfd6pcuD7m8n63Mky9AXMyXRA5SckTLSk
         3J1IdqmaLJdwRbrYIqXuRJ8oTvrXcBDNjkufZqp1E7tU1oWlG8tRKtUvkzNb7wv+JK
         ZJ8yB4Uz5ohK/vnossIlah9hGKDRf9rj0NgT7D6F7ERKCY6/YFhsAZ7Ojzdwb7C93o
         kmMBZn0g2dLsw==
Date:   Mon, 10 Apr 2023 17:32:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yan Wang <rocklouts@sina.com>
Cc:     davem@davemloft.net, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com, edumazet@google.com,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [PATCH] net: stmmac:fix system hang when setting up standalone
 tag_8021q VLAN for DSA ports
Message-ID: <20230410173227.74f9d60a@kernel.org>
In-Reply-To: <20230408155823.12834-1-rocklouts@sina.com>
References: <20230407195730.298867dd@kernel.org>
        <20230408155823.12834-1-rocklouts@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  8 Apr 2023 23:58:23 +0800 Yan Wang wrote:
> The system hang because of dsa_tag_8021q_port_setup() callbcak
> stmmac_vlan_rx_add_vid().I found in stmmac_drv_probe() that
> cailing pm_runtime_put() disabled the clock when check the stmmac
> dirver.
> 
> First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
> resume/suspend is active.
> 
> Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
> will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
> The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
> registers after stmmac's clock is closed.
> 
> I would suggest adding the pm_runtime_resume_and_get() to the
> stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
> while in use.

Hm, the patch is not making it to the @vger list, even tho it did make
it to lore.kernel.org, it seems. I couldn't spot anything wrong with it.
Could you try sending it to testing@vger.kernel.org and contacting
John (added to CC) who administers vger.kernel.org, to figure out
what's wrong?

Based on this conversation:
https://lore.kernel.org/all/9539b880-642d-9ac5-ccfa-2b237548f4fc@kernel.org/
