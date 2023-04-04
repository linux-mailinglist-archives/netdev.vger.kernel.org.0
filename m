Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603236D70D5
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbjDDXmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjDDXmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:42:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886D23C1D
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 16:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BCC7621F5
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB85C433EF;
        Tue,  4 Apr 2023 23:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680651762;
        bh=8LrhP86/tYyMqbTNkGyEJi+H9C+xM7+1Yg5R3FKki+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MWG1uN0CCdHSwJ6jYHH2cS5NUmb6CF6OMAVGQIPsIX6szv3fsTtZT6rQK42YG3j8j
         Na9Ao2DvTQWJDFchrQme5W25aK04TC6LrgJ/Zomx4dcX9rYRhVgkC3mc6uTBNR/NQr
         g4p1D6zEJ+sOTVOwQ+tChRbF4jRQwN8oNciO+/Z3rZzbhqhHw+IKr5zrdtixkDPWau
         ZDZOBPuxRhh1GvXWyOtguPcDDV1zXew+G7iZZsDvdSKjUjywZdOFWScMqkHMYzTZSh
         tS/SXP9S2VJs67EPTYDP51G+05VPY90pA58FuLdwjTzvfPYZ7nSTfaMGUrmTeNoDKZ
         SL93fP2s2LOmA==
Date:   Tue, 4 Apr 2023 16:42:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
        sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH net-next 3/6] net: ethtool: let the core choose RSS
 context IDs
Message-ID: <20230404164241.5142d44b@kernel.org>
In-Reply-To: <ecd752db-ff2a-6948-2ff8-531343f80696@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
        <00a28ff573df347ba0762004bc8c7aa8dfcf31f6.1680538846.git.ecree.xilinx@gmail.com>
        <20230403145406.5c62a874@kernel.org>
        <ecd752db-ff2a-6948-2ff8-531343f80696@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 13:14:39 +0100 Edward Cree wrote:
> > Would it be easier to pass struct ethtool_rxfh_context instead of
> > doing it field by field?  Otherwise Intel will need to add more
> > arguments and touch all drivers. Or are you thinking that they should
> > use a separate callback for the "RR RSS" or whatever their thing is?  
> 
> Initially I tried to just pass in ctx with the new values already
>  filled in.  But that breaks if the op fails; we have to leave the
>  old values in ctx.  We maybe could create a second, ephemeral
>  struct ethtool_rxfh_context to pass the new values in, but then
>  we have to worry about which one's priv the driver uses.
> (We can't e.g. just pass in the ephemeral one, and copy its priv
>  across when we update the real ctx after the op returns, because
>  what if the driver stores, say, a list_head in its priv?)
> 
> And if we did pass a struct wrapping indir, key and hfunc, then
>  any patch adding more fields to it would need existing drivers
>  to check the new fields were unused / set to NO_CHANGE.
> 
> So I think we just have to accept that new fields will mean
>  changing all drivers.  (There's only half a dozen, anyway.)
> And doing that through the op arguments means the compiler will
>  catch any driver that hasn't been updated, rather than the
>  driver potentially silently ignoring the new field.

Fair point with needing to copy in case of error, okay :(
