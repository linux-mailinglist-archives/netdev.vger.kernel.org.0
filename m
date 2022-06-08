Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FEB5427E6
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbiFHHXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351731AbiFHGPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:15:24 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5387E1EEBA1;
        Tue,  7 Jun 2022 22:46:14 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2585jrgk007510;
        Wed, 8 Jun 2022 07:45:53 +0200
Date:   Wed, 8 Jun 2022 07:45:53 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, rui.zhang@intel.com,
        yu.c.chen@intel.com
Subject: Re: [net]  6922110d15: suspend-stress.fail
Message-ID: <20220608054553.GA7499@1wt.eu>
References: <20220605143935.GA27576@xsang-OptiPlex-9020>
 <20220607174730.018fe58e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607174730.018fe58e@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 05:47:30PM -0700, Jakub Kicinski wrote:
> On Sun, 5 Jun 2022 22:39:35 +0800 kernel test robot wrote:
> > Greeting,
> > 
> > FYI, we noticed the following commit (built with gcc-11):
> > 
> > commit: 6922110d152e56d7569616b45a1f02876cf3eb9f ("net: linkwatch: fix failure to restore device state across suspend/resume")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > in testcase: suspend-stress
> > version: 
> > with following parameters:
> > 
> > 	mode: freeze
> > 	iterations: 10
> > 
> > 
> > 
> > on test machine: 4 threads Ivy Bridge with 4G memory
> > 
> > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > 
> > 
> > 
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > 
> > 
> > Suspend to freeze 1/10:
> > Done
> > Suspend to freeze 2/10:
> > network not ready
> > network not ready
> > network not ready
> > network not ready
> > network not ready
> > network not ready
> > network not ready
> > network not ready
> > network not ready
> > network not ready
> > network not ready
> > Done
> 
> What's the failure? I'm looking at this script:
> 
> https://github.com/intel/lkp-tests/blob/master/tests/suspend-stress
> 
> And it seems that we are not actually hitting any "exit 1" paths here.

I'm not sure how the test has to be interpreted but one possible
interpretation is that the link really takes time to re-appear and
that prior to the fix, the link was believed to still be up since
the event was silently lost during suspend, while now the link is
correctly being reported as being down and something is waiting for
it to be up again, as it possibly should. Thus it could be possible
that the fix revealed an incorrect expectation in that test.

Willy
