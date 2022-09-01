Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B055A8E7D
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiIAGo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiIAGo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D269713DDA
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 23:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7886A61B5C
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 06:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA168C433D6;
        Thu,  1 Sep 2022 06:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662014692;
        bh=/kmlEWRms6yaCVwfOmteh8vEjyfs6ZpshDCqhtY4dgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NwA8J+JIX8x7iqRyLYLcTINc4hv1sFmMj1VobgjYbbB3li/RrOt8s7kLfQZnN3GR+
         /dRKJvQwirss+yILvg6C2yakDt2Qz2fK4TpUJb4KftyKnKhB/Zhfn7ivhyXyEayr87
         pPcCGQnPT+V3Ir9vVvm4eJ78ddPncQpBTCpXZWYgYofd3ztTJmeQZ9ALpOIDop4Pbd
         wU4tVDD2EvF5Yg7JGzwYbE2ixfVxlvYpfQARvI0QMhVYqicjRB9CVVX8Pe4wfIkUJk
         ZvES2DTctPy6m861N9rGczyZSyGRg5W65yDwdRwlw6gn2//BKpPbok9pRk4kMLjqNX
         CPFDcB14oyhQg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oTdwa-0001dF-8t; Thu, 01 Sep 2022 08:44:53 +0200
Date:   Thu, 1 Sep 2022 08:44:52 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Message-ID: <YxBU5AV4jfqaExaW@hovoldconsulting.com>
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
> > working. TTY interface in ice driver is virtual and doesn't need any change
> > on set_termios, so is left empty. Add this mock to support all Linux TTY
> > APIs.
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

Hmm. Why was this implemented as a roll-your-own tty driver instead of
using the GNSS subsystem, which also would have allowed for a smaller
(and likely less buggy) implementation?

Looks like this was merged in 5.18 with 43113ff73453 ("ice: add TTY for
GNSS module for E810T device") without any input from people familiar
with tty either.

Johan
