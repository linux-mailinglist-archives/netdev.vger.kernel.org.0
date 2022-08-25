Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F375A0896
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 07:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiHYF70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 01:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHYF7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 01:59:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61BF9F198;
        Wed, 24 Aug 2022 22:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 885DEB82752;
        Thu, 25 Aug 2022 05:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CD0C433D6;
        Thu, 25 Aug 2022 05:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661407162;
        bh=ThkTyKE8Sd6JCI3b/NADDD7sIGHfT924CUMVZRD7mZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZE4ACLFwkr2h9zuwBDY5/f3BSOHoP1JDM/A+px6CtF9rJm/BEDAjrZgYszUQ6qJmI
         30BnqCG6+H/LXWfzSZb0DOEMC4GtuRTVFvItCKy+lc04DoWdvxG6K3z9jjjK+Au69G
         dhOK5gWmyxPbDH14qfB737S9Xi3Z7KCFZJS3X4mA=
Date:   Thu, 25 Aug 2022 07:59:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     duoming@zju.edu.cn
Cc:     Brian Norris <briannorris@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        amit karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kvalo@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] Add new APIs of devcoredump and fix bugs
Message-ID: <YwcPxT2JLQHXbdFI@kroah.com>
References: <cover.1661252818.git.duoming@zju.edu.cn>
 <CA+ASDXNf5JV9mj8mbm1OGZ_zd4d8srFc=E++Amg4MoQjqjS_TA@mail.gmail.com>
 <27a2a8a7.99f01.182d2758bc9.Coremail.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27a2a8a7.99f01.182d2758bc9.Coremail.duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 08:44:55AM +0800, duoming@zju.edu.cn wrote:
> Hello,
> 
> On Wed, 24 Aug 2022 13:42:09 -0700 Brian Norris wrote:
> 
> > On Tue, Aug 23, 2022 at 4:21 AM Duoming Zhou <duoming@zju.edu.cn> wrote:
> > >
> > > The first patch adds new APIs to support migration of users
> > > from old device coredump related APIs.
> > >
> > > The second patch fix sleep in atomic context bugs of mwifiex
> > > caused by dev_coredumpv().
> > >
> > > Duoming Zhou (2):
> > >   devcoredump: add new APIs to support migration of users from old
> > >     device coredump related APIs
> > >   mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
> > 
> > I would have expected a third patch in here, that actually converts
> > existing users. Then in the following release cycle, clean up any new
> > users of the old API that pop up in the meantime and drop the old API.
> > 
> > But I'll defer to the people who would actually be merging your code.
> > Technically it could also work to simply provide the API this cycle,
> > and convert everyone in the next.
> 
> Thank your for your time and reply.
> 
> If this patch set is merged into the linux-next tree, I will send the 
> third patch which targets at linux-next tree and converts existing users 
> at later timer of this release cycle. Because there are new users that 
> may use the old APIs comes into linux-next tree during the remaining time
> of this release cycle.

No, that's not how this works, we can't add patches with new functions
that no one uses.  And it's not how I asked for this api to be migrated
over time properly.  I'll try to respond to your patch with more details
in a week or so when I catch up on patch review...

greg k-h
