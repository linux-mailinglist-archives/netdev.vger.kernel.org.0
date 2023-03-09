Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B646B2BA6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCIRJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjCIRI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:08:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606A4E919A;
        Thu,  9 Mar 2023 09:05:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A7D3B81FFB;
        Thu,  9 Mar 2023 17:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D14EC433EF;
        Thu,  9 Mar 2023 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678381526;
        bh=gkS1wBSZK3kiahQZWpJos1mMv60Qrr7yHKQW/zlsIwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J8aHwmrxI1R2CtiQPxxVKn/k5+gYyHIbD/nIgltTopgF2q9+uAqtFV2aTMM/PpjKA
         /Pz44E2gTmwQGEP1T3wrkFGUO/ZmOUs4Hvv3zQ7MzLjU+uLIG6bsrH4GJkSdGF/Eqw
         Pmy2ygfsBiKEugLTLkyrqLBZ9X0GbGah/xNZy2fvs38LeF+8yfAS8mek7iqRO9PyeZ
         CQQSPx1dBWuVlj7a4r2AAft4bR+uAMGDMEdKdRTimTHRha9edhKOpEd9o1Pjs6rXXa
         fL0sGZT63bXQbjPgpnSieMVwsAPCq3UxOb+Nfgq/ZmjsZpTVxTIpMqIVQHwI9d7Pw6
         u4s7z5qVrE5Pw==
Date:   Thu, 9 Mar 2023 18:05:19 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Process connector bug fixes & enhancements
Message-ID: <20230309170519.rufxekqqybbhvbis@wittgenstein>
References: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 07:19:48PM -0800, Anjali Kulkarni wrote:
> From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
> 
> In this series, we add back filtering to the proc connector module. This
> is required to fix some bugs and also will enable the addition of event 
> based filtering, which will improve performance for anyone interested
> in a subset of process events, as compared to the current approach,
> which is to send all event notifications.
> 
> Thus, a client can register to listen for only exit or fork or a mix or
> all of the events. This greatly enhances performance - currently, we
> need to listen to all events, and there are 9 different types of events.
> For eg. handling 3 types of events - 8K-forks + 8K-exits + 8K-execs takes
> 200ms, whereas handling 2 types - 8K-forks + 8K-exits takes about 150ms,
> and handling just one type - 8K exits takes about 70ms.
> 
> Reason why we need the above changes and also a new event type 
> PROC_EVENT_NONZERO_EXIT, which is only sent by kernel to a listening
> application when any process exiting has a non-zero exit status is:
> 
> Oracle DB runs on a large scale with 100000s of short lived processes,
> starting up and exiting quickly. A process monitoring DB daemon which
> tracks and cleans up after processes that have died without a proper exit
> needs notifications only when a process died with a non-zero exit code
> (which should be rare).
> 
> This change will give Oracle DB substantial performance savings - it takes
> 50ms to scan about 8K PIDs in /proc, about 500ms for 100K PIDs. DB does
> this check every 3 secs, so over an hour we save 10secs for 100K PIDs.
> 
> Measuring the time using pidfds for monitoring 8K process exits took 4
> times longer - 200ms, as compared to 70ms using only exit notifications
> of proc connector. Hence, we cannot use pidfd for our use case.

Just out of curiosity, what's the reason this took so much longer?

> 
> This kind of a new event could also be useful to other applications like
> Google's lmkd daemon, which needs a killed process's exit notification.

Fwiw - independent of this thing here - I think we might need to also
think about making the exit status of a process readable from a pidfd.
Even after the process has been exited + reaped... I have a _rough_ idea
how I thought this could work:

* introduce struct pidfd_info
* allocate one struct pidfd_info per struct pid _lazily_when the first a pidfd is created
* stash struct pidfd_info in pidfd_file->private_data
* add .exit_status field to struct pidfd_info
* when process exits statsh exit status in struct pidfd_info
* add either new system call or ioctl() to pidfd which returns EAGAIN or
  sm until process has exited and then becomes readable

Thought needs to be put into finding struct pidfd_info based on struct pid...
