Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBEB681D54
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjA3Vw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjA3VwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:52:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CC2234C3;
        Mon, 30 Jan 2023 13:52:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E920611C3;
        Mon, 30 Jan 2023 21:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7CBC433A1;
        Mon, 30 Jan 2023 21:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675115542;
        bh=IM+1lYgPR9x1qxqsXW7YPLG/jy8uVwJ9GsUMvJwTEeE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D0UHh/bjU+VEMh6OXcy07pjTLUIynHLCNlM5AfyDduq4Zk4TlmvmQVLpla85FkFgM
         ygmU4rbbUfzKQ2y7o5rgyzqEC6c0d5R58akc+SWFxqL/dud1SN373keVIJa3CLAj1+
         FE6Q8iypSgIGeeekJieD4T4mdg40vIIidnLg4M/LzQYKLOm4rEUgokiPQC0FDYKo32
         l/7HXajpuqdGSENJ9ON28WTBnZU1qi4etVEas6ml8MRGy+0mQ6JPpR/S9v78GJMTGm
         FvBNg7sYh2IrMkIfEI0406gf0c2wJ2yvDlOBDS2SXkXv+EVI2ADQrYTd7+SnRgO8SX
         dz1cRf17HAvsg==
Date:   Mon, 30 Jan 2023 13:52:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
Message-ID: <20230130135221.3deeed6c@kernel.org>
In-Reply-To: <6758c48d926845ae323a68fb4649fb982e2321c4.camel@redhat.com>
References: <cover.1604055792.git.pabeni@redhat.com>
        <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <86c37d881a93d5690faf20de3bccceca1493fd74.camel@redhat.com>
        <20201103085245.3397defa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <79c58e6cf23196b73887b20802daebd59fe89476.camel@redhat.com>
        <20201104114226.250a4e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6758c48d926845ae323a68fb4649fb982e2321c4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Jan 2023 10:25:34 +0100 Paolo Abeni wrote:
> Let me try for a moment to revive this old thread.
> 
> Tha series proposed a new sysctl know to implement a global/default rps
> mask applying to all the network devices as a way to simplify some RT
> setups. It has been rejected as the required task is doable in user-
> space.
> 
> Currently the orchestration infrastructure does that, setting the per
> device, per queue rps mask and CPU isolation.
> 
> The above leads to a side problem: when there are lot of netns/devices
> with several queues, even a reasonably optimized user-space solution
> takes a relevant amount of time to traverse the relevant sysfs dirs and
> do I/O on them. Overall the additional time required is very
> measurable, easily ranging in seconds.
> 
> The default_rps_mask would basically kill that overhead.
> 
> Is the above a suitable use case?

Alright, thanks for trying the user space fix.
