Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B87362ECF1
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240496AbiKREqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKREqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:46:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7851A8CBA4;
        Thu, 17 Nov 2022 20:46:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9223CB82288;
        Fri, 18 Nov 2022 04:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA582C433C1;
        Fri, 18 Nov 2022 04:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668746761;
        bh=JKir5nGbSQSafv+ywUHsGDpTr69oEQN8yx8bMZ+kP6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=alzWEUMop1o7kfqTwQH1cCKVzWS6f0t3dYzV/9e5n5Q6ueEwloBaH+CQG0KD6qwa2
         AFR9vwbhP4XA/9PKLAaWlJ1q1lLP5N/H8aN/gTjx33+ibZxHIAIFCGx04j23UEBmpD
         zVHvA0LUODibr6BtoT+tNymD9O30LiKjRtoDy51UlzMiBwNe+3G431Vd+DBzvYriff
         BQcoxRoSVU5lLhVBqVxqrZwP4xsEJ5GNI7H8f+JIxeHqzZjBvyFCs8Qi2XHyQb07gm
         IfKrILirCaoPdsXW0+l9lYtzPJqmKpP3AjEJpq4S7tkjmT+dub1NxKWDoGDPDNEgbR
         3VEgW9H8EalAQ==
Date:   Thu, 17 Nov 2022 20:45:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Collin <collin@burrougc.net>, linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: Missing generic netlink controller operations
Message-ID: <20221117204559.4ab9e4f8@kernel.org>
In-Reply-To: <8baab0a4-aa71-2fd9-d3cd-93daf1d792cb@infradead.org>
References: <40386821-902a-4299-98c8-cbf60dbd4c2c@app.fastmail.com>
        <8baab0a4-aa71-2fd9-d3cd-93daf1d792cb@infradead.org>
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

On Thu, 17 Nov 2022 08:38:40 -0800 Randy Dunlap wrote:
> [change linux-netdev@ to netdev@]
> 
> On 11/16/22 19:54, Collin wrote:
> > While messing around with libnl and netlink I noticed that despite
> > existing in an enum in linux/genetlink.h, the
> > CTRL_CMD_{NEW,DEL,GET}OPS operations (and in fact, all operations
> > except for
> > CTRL_CMD_{NEWFAMILY,DELFAMILY,NEWMCAST_GRP,DELMCAST_GRP}) are
> > unimplemented, and have been around, untouched, since the
> > introduction of the generic netlink family. Is there a reason these
> > exist without implementation, or has it simply not been done?  

Only CTRL_CMD_GETMCAST_GRP was never used AFAIU, it was likely added
to maintain the triplet cadence (NEW,DEL,GET); probably cargo cult /
inspired by the classic netlink / rtnl.

Ops used to be more dynamic, and separately registered, I think.
Which found no real life use, so that option was dropped and now
all ops must be statically defined for the family at family
registration time.
