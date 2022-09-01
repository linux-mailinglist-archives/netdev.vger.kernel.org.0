Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AEC5A8D7E
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 07:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiIAFqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 01:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiIAFqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 01:46:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EEC1166C7
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 22:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16991619F1
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0D3C433D6;
        Thu,  1 Sep 2022 05:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662011172;
        bh=N6sy4DHYjouYCYQ6bWsBoZXK36R1GIhJGaayGM8TQ8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CDbV0cpc3rOerT7aDuF2wrdCi8nzQiFRujEe4nG7BZhoysNE+8CmYanyPymvVzntK
         3Fx3c6INfu0O4BTEb2y8oSwHZv17lu7L7x6A/6kIb3NlPHaEb+Q6uo+pH5bfOSpuwO
         EBW+pfqmhxkua//B5fj2hqMKUCy4mJLB7dI+XjRM=
Date:   Thu, 1 Sep 2022 07:46:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Message-ID: <YxBHL6YzF2dAWf3q@kroah.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831145439.2f268c34@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 02:54:39PM -0700, Jakub Kicinski wrote:
> On Mon, 29 Aug 2022 15:00:49 -0700 Tony Nguyen wrote:
> > From: Michal Michalik <michal.michalik@intel.com>
> > 
> > Some third party tools (ex. ubxtool) try to change GNSS TTY parameters
> > (ex. speed). While being optional implementation, without set_termios
> > handle this operation fails and prevents those third party tools from
> > working.

What tools are "blocked" by this?  And what is the problem they have
with just the default happening here?  You are now doing nothing, while
if you do not have the callback, at least a basic "yes, we accepted
these values" happens which was intended for userspace to not know that
there was a problem here.

> TTY interface in ice driver is virtual and doesn't need any change
> > on set_termios, so is left empty. Add this mock to support all Linux TTY
> > APIs.

"mock"?



> > 
> > Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
> > Signed-off-by: Michal Michalik <michal.michalik@intel.com>
> > Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> Please CC GNSS and TTY maintainers on the patches relating to 
> the TTY/GNSS channel going forward.
> 
> CC: Greg, Jiri, Johan
> 
> We'll pull in a day or two if there are no objections.

Please see above, I'd like to know what is really failing here and why
as forcing drivers to have "empty" functions like this is not good and
never the goal.

thanks,

greg k-h
