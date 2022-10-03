Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FA35F3361
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiJCQWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJCQWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:22:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119101DF2B
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 09:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A472661148
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 16:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8970EC433D6;
        Mon,  3 Oct 2022 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664814150;
        bh=ka2xbNQQ4V4EQHeddHLZAFlcdwwBm3lkPpxZageiyZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jWV382j3kbZD2lEFN6fBCRj+zwkncTR72BjI2L+jWG8ffBW7IBAvNY9lrvDJXZLoM
         cCzVn9TwqKEFuArodXO3QjLdiG4yhJ3Z4MR32AVuAMpB2LJPiCTRtt9h/Qc78pOkee
         W7TuET/9V1pbon6Eip4rkTuHD//ELyJDB/E6zCVM=
Date:   Mon, 3 Oct 2022 18:22:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: fix mvpp2 debugfs leak
Message-ID: <YzsMQyPJ+I0FqVOA@kroah.com>
References: <E1ofOAB-00CzkG-UO@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ofOAB-00CzkG-UO@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 05:19:27PM +0100, Russell King (Oracle) wrote:
> When mvpp2 is unloaded, the driver specific debugfs directory is not
> removed, which technically leads to a memory leak. However, this
> directory is only created when the first device is probed, so the
> hardware is present. Removing the module is only something a developer
> would to when e.g. testing out changes, so the module would be
> reloaded. So this memory leak is minor.
> 
> The original attempt in commit fe2c9c61f668 ("net: mvpp2: debugfs: fix
> memory leak when using debugfs_lookup()") that was labelled as a memory
> leak fix was not, it fixed a refcount leak, but in doing so created a
> problem when the module is reloaded - the directory already exists, but
> mvpp2_root is NULL, so we lose all debugfs entries. This fix has been
> reverted.
> 
> This is the alternative fix, where we remove the offending directory
> whenever the driver is unloaded.
> 
> Fixes: 21da57a23125 ("net: mvpp2: add a debugfs interface for the Header Parser")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for fixing this up properly.

greg k-h
