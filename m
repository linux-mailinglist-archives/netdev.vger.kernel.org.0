Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F591F54BF
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 14:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgFJM0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 08:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729077AbgFJM0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 08:26:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D02206F4;
        Wed, 10 Jun 2020 12:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591792007;
        bh=PBnbsD1r4hBJSwpcdPlA8plwD/kWkJiD61twepTwXNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jJpTTwI4BcRIVrN10ZRmWWQHb9uLqvUrrTbyJC1G5ckdCzOCEOBlPdgX2dMouNv0y
         YAgEbPCewSSW4UUxn4RQtfuCNeuAdQ/VXQBBn5Ha87ZqsZt+1tcxAPrnMH0pHm3w0F
         EFkHX/7w+geTl3Np545ZBkOWixSYUU12SBQ6Y3Ls=
Date:   Wed, 10 Jun 2020 14:26:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
Message-ID: <20200610122641.GB1900758@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-2-stanimir.varbanov@linaro.org>
 <20200609111615.GD780233@kroah.com>
 <0830ba57-d416-4788-351a-6d1b2ca5b7d8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0830ba57-d416-4788-351a-6d1b2ca5b7d8@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 01:29:20PM +0300, Stanimir Varbanov wrote:
> Hi Greg,
> 
> On 6/9/20 2:16 PM, Greg Kroah-Hartman wrote:
> > On Tue, Jun 09, 2020 at 01:45:58PM +0300, Stanimir Varbanov wrote:
> >> This adds description of the level bitmask feature.
> >>
> >> Cc: Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
> >>
> >> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> >> ---
> >>  Documentation/admin-guide/dynamic-debug-howto.rst | 10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >> diff --git a/Documentation/admin-guide/dynamic-debug-howto.rst b/Documentation/admin-guide/dynamic-debug-howto.rst
> >> index 0dc2eb8e44e5..c2b751fc8a17 100644
> >> --- a/Documentation/admin-guide/dynamic-debug-howto.rst
> >> +++ b/Documentation/admin-guide/dynamic-debug-howto.rst
> >> @@ -208,6 +208,12 @@ line
> >>  	line -1605          // the 1605 lines from line 1 to line 1605
> >>  	line 1600-          // all lines from line 1600 to the end of the file
> >>  
> >> +level
> >> +    The given level will be a bitmask ANDed with the level of the each ``pr_debug()``
> >> +    callsite. This will allow to group debug messages and show only those of the
> >> +    same level.  The -p flag takes precedence over the given level. Note that we can
> >> +    have up to five groups of debug messages.
> > 
> > As was pointed out, this isn't a "level", it's some arbitrary type of
> > "grouping".
> 
> Yes, it is grouping of KERN_DEBUG level messages by importance (my
> fault, I put incorrect name).  What is important is driver author
> decision.  Usually when the driver is huge and has a lot of debug
> messages it is not practical to enable all of them to chasing a
> particular bug or issue.  You know that debugging (printk) add delays
> which could hide or rise additional issue(s) which would complicate
> debug and waste time.

That is why it is possible to turn on and off debugging messages on a
function/line basis already.  Why not just use that instead?

> For the Venus driver I have defined three groups of KERN_DEBUG - low,
> medium and high (again the driver author(s) will decide what the
> importance is depending on his past experience).
> 
> There is another point where the debugging is made by person who is not
> familiar with the driver code. In that case he/she cannot enable lines
> or range of lines because he don't know the details. Here the grouping
> by importance could help.

And they will really know what "low/medium/high" are?

Anyway, that makes a bit more sense, but the documentation could use a
lot more in order to describe this type of behavior, and what is
expected by both driver authors, and users of the interface.

thanks,

greg k-h
