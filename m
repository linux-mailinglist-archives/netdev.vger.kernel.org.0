Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5571539B63
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 04:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbiFACqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 22:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiFACqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 22:46:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83F35A5B2
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 19:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42DC360EE7
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 02:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D79C385A9;
        Wed,  1 Jun 2022 02:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654051568;
        bh=g2SNfgGfMdMKhYPLabKUvmye2yuPbn4g3VlhMuHDe3A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nzgOu0VLgbkWecqMl6iA8QbplMcIgwvtpNkraQ20SvBBawd6aJRTZq5/iYF9+5L6v
         Qm4TgE7zcDLr2tMffYT+R7lRLoNa8JqJjFUO3zAmpu3P8x0sLqb5Disz3ikaVZxEWb
         /Pgrcdzwrf5pEnrSemnO6sKKIqjMQNUgiMto8kGWKjhkDIYi2GfWKUCSk9iOWUWGGx
         eykbtWj7nLXWB6TN1Z/oa6AAQ7YoPXImZ9Y4DlhUui0F/gReEA1i8WRJiQTCqVm0Gy
         x0H1E5YEvOC5wIR3Ob02oJMt3uI/XLqY1l6PbN8IcQBsOsm8SSYVg6gAJYYOioDvk/
         LwdNYoCEB454Q==
Date:   Tue, 31 May 2022 19:46:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: correct the output of `ethtool --show-fec
 <intf>`
Message-ID: <20220531194607.7520df10@kernel.org>
In-Reply-To: <20220601014825.GA10961@nj-rack01-04.nji.corigine.com>
References: <20220530084842.21258-1-simon.horman@corigine.com>
        <20220530213232.332b5dff@kernel.org>
        <20220601014825.GA10961@nj-rack01-04.nji.corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jun 2022 09:48:25 +0800 Yinjun Zhang wrote:
> On Mon, May 30, 2022 at 09:32:32PM -0700, Jakub Kicinski wrote:
> > On Mon, 30 May 2022 10:48:42 +0200 Simon Horman wrote:  
> > > The output  of `Configured FEC encodings` should display user
> > > configured/requested value,  
> > 
> > That stands to reason, but when I checked what all drivers do 7 out 
> > of 10 upstream drivers at the time used it to report supported modes.  
> 
> It seems you're right. I agree it's OK that nfp driver keep the same with
> majority drivers' implementations.

FWIW this is what I found in my notes:

get:
 s - supported
 c - configured
set:
 1 - single mode
 m - multiple modes

      nfp | ionic | lio | cxgb4 | hns3 | i40e | ice | mlx5 | qede | sfc | bnxt
-----------------------------------------------------------------------------
get |  s  |   s   |  s  |   s   |  s   |  c?  |  s  |  c?  |  s   |  c? |
set |  1  |   1   |  1  |   m   |  m   |  1   |  1  |  m?  |  m   |  m  |

I don't know how accurate that was, hard to tell those things 
by looking only at the kernel driver.

> > At which point it may be better to change the text in ethtool user
> > space that try to change the meaning of the field..  
> 
> To adapt to both implementations, "Supported/Configured FEC encodings"
> would be a compromise I think.

Yup, it should help avoid bug reports. I don't have better ideas :(
