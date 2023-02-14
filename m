Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DCE696FEE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjBNVkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjBNVkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:40:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BB42A6C1
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E37A661920
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 21:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7C4C433D2;
        Tue, 14 Feb 2023 21:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676410814;
        bh=9zJ2yLleauzTrndWo3SzNJtiDUzc8xd6z7KaiXQXC2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UTmjIa9Dy7RwDj517hPVIykW3wQxHxuzqHqv5jRvn4Je0u1ooKbYJpQttytItWp6q
         O6+D2Lo1XimLX91DKHdTU6hsmvnG5iGSYT4J4UEKHQJ+jdzar/GG7YhLNNYEfSPZ2Y
         xYmgm9Cb04B0Viqb/HmE6QANPfH0YyDbVZGsAL3wd8kK3H0J/mqhl1ogbOu+2E3Ud4
         11qJmRpVZ+ZTcxkWCbnOjEx3bnmeh10/hhqHWI4B+PXiqesjWKL76cRurAxfKR6RA0
         VlJqA6auBUDhELRfFc2Hi4twtu1BKZ2+qrHUN+oL/yr/oZd8h6ZvFlYZ8fnnr9pK6N
         BSukD+sHzBRmA==
Date:   Tue, 14 Feb 2023 13:40:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and
 classifiers
Message-ID: <20230214134013.0ad390dd@kernel.org>
In-Reply-To: <Y+uZ5LLX8HugO/5+@nanopsycho>
References: <20230214134915.199004-1-jhs@mojatatu.com>
        <Y+uZ5LLX8HugO/5+@nanopsycho>
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

On Tue, 14 Feb 2023 15:25:40 +0100 Jiri Pirko wrote:
> Tue, Feb 14, 2023 at 02:49:10PM CET, jhs@mojatatu.com wrote:
> >The CBQ + dsmark qdiscs and the tcindex + rsvp classifiers have served us for
> >over 2 decades. Unfortunately, they have not been getting much attention due
> >to reduced usage. While we dont have a good metric for tabulating how much use
> >a specific kernel feature gets, for these specific features we observed that
> >some of the functionality has been broken for some time and no users complained.
> >In addition, syzkaller has been going to town on most of these and finding
> >issues; and while we have been fixing those issues, at times it becomes obvious
> >that we would need to perform bigger surgeries to resolve things found while
> >getting a syzkaller fix in place. After some discussion we feel that in order
> >to reduce the maintenance burden it is best to retire them.
> >
> >This patchset leaves the UAPI alone. I could send another version which deletes
> >the UAPI as well. AFAIK, this has not been done before - so it wasnt clear what
> >how to handle UAPI. It seems legit to just delete it but we would need to
> >coordinate with iproute2 (given they sync up with kernel uapi headers). There  
> 
> I think we have to let the UAPI there to rot in order not to break
> compilation of apps that use those (no relation to iproute2).

Yeah, I was hoping there's no other users but this is the first match
on GitHub:

https://github.com/t2mune/nield/blob/0c0848d1d1e6c006185465ee96aeb5a13a1589e6/src/tcmsg_qdisc_dsmark.c

:(
