Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532BA5912E4
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbiHLP2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238885AbiHLP2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C3A7C186;
        Fri, 12 Aug 2022 08:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 967F56148F;
        Fri, 12 Aug 2022 15:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C47C433C1;
        Fri, 12 Aug 2022 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660318080;
        bh=Js90lG2a8CweNtF1ZgBlqyryGecyyYI5L5XDv9jU1pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KobhE0oAhe5CUh6J0+dCswDw2xxhwa7nkHxFglctgM1+T6exPV0IQp2feT6W6xJao
         fcdt0YCo+oB9DfCD2VeRPnAQnmiGfwMIfwDjCfCYj5DsOUNPeVL15cJAbw8nSxoMMB
         p7hYC6DPcda76poYonlcnU2DZq/6k4d2y6V/M8Js=
Date:   Fri, 12 Aug 2022 17:27:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddh Raman Pant <code@siddh.me>
Cc:     johannes berg <johannes@sipsolutions.net>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot+6cb476b7c69916a0caca 
        <syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        syzbot+f9acff9bf08a845f225d 
        <syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com>,
        syzbot+9250865a55539d384347 
        <syzbot+9250865a55539d384347@syzkaller.appspotmail.com>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: Re: [PATCH v2] wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
Message-ID: <YvZxfpY4JUqvsOG5@kroah.com>
References: <20220726123921.29664-1-code@siddh.me>
 <18291779771.584fa6ab156295.3990923778713440655@siddh.me>
 <YvZEfnjGIpH6XjsD@kroah.com>
 <18292791718.88f48d22175003.6675210189148271554@siddh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18292791718.88f48d22175003.6675210189148271554@siddh.me>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 08:03:05PM +0530, Siddh Raman Pant wrote:
> On Fri, 12 Aug 2022 17:45:58 +0530  Greg KH  wrote:
> > The merge window is for new features to be added, bugfixes can be merged
> > at any point in time, but most maintainers close their trees until after
> > the merge window is closed before accepting new fixes, like this one.
> > 
> > So just relax, wait another week or so, and if there's no response,
> > resend it then.
> > 
> 
> Okay, sure.
> 
> > Personally, this patch seems very incorrect, but hey, I'm not the wifi
> > subsystem maintainer :)
> 
> Why do you think so?

rcu just delays freeing of an object, you might just be delaying the
race condition.  Just moving a single object to be freed with rcu feels
very odd if you don't have another reference somewhere.

Anyway, I don't know this codebase, so I could be totally wrong.

greg k-h
