Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A666534DCCE
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 02:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhC3AGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 20:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhC3AGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 20:06:43 -0400
X-Greylist: delayed 138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Mar 2021 17:06:42 PDT
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 9B3C8C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 17:06:42 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 5F0A7504FD9
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 00:04:04 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1617061265; t=1617062644;
        bh=Ws7F9ezUXmX13raOPmi4BGQ/B5OSES+6rD76onNt+OA=;
        h=Date:To:From:Subject:From;
        b=EcnAN2WPMMxsAWZ2A1o3UBMn6BfD3fbG7Yx8BlAMdyMXQKISrT2o6ARdal+fHTedd
         vR6xddiQw8/iHgJFq6dDDAcbuafrCmCb3U2BMvivqQ7xG0lfABlUGOgE8M4K6oNciE
         PCaEL2mRLnRD5mAG18Y7JImWooqea4xXzTEYWPSmmnSYVF3CXmf+4HV4RDXwZ4IL1c
         9IgVNRbsxRa3Od1jVFzmsQqyxzVovkZ3UWReMQyC6BUIkkpYuRXC5B6OctY62/j0ra
         49WLMsgQSwEfeipAz5gRgJ9/nqVsnVpx68gMrwye4BVEKt3lDyeLHoK96rhzhoTrky
         9DdN01I4jIiTg==
Message-ID: <b024bedb-d9e8-ee04-2443-2804760f51e4@mattcorallo.com>
Date:   Mon, 29 Mar 2021 20:04:04 -0400
MIME-Version: 1.0
Content-Language: en-US
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Matt Corallo <linux-net@mattcorallo.com>
Subject: IP_FRAG_TIME Default Too Large
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IP_FRAG_TIME defaults to 30 full long seconds to wait for reassembly of fragments. In practice, with the default values, 
if I send enough fragments over a line that there is material loss, its not strange to see fragments be completely 
dropped for the remainder of a 30 second time period before returning to normal.

This issue largely goes away when setting net.ipv4.ipfrag_time to 0/1. Is there a reason IP_FRAG_TIME defaults to 
something so high? If its been 30 seconds the packet you receive next is almost certainly not the one you wanted.

That said, if I'm reading ip_fragment.c (and I'm almost certainly not), the behavior seems different than as documented 
- q.fqdir->timeout is only used in ip_frag_reinit which is only called when ip_frag_too_far hits indicating the packet 
is out of the net.ipv4.ipfrag_max_dist bound.

Reading the docs, I expected something more like "if the packet is out of the net.ipv4.ipfrag_max_dist bound, drop the 
queue, also if the packet is older than net.ipv4.ipfrag_time, drop the packet", not "if the packet is out of the 
net.ipv4.ipfrag_max_dist bound *and* the packet is older than net.ipv4.ipfrag_time, drop the queue". If I'm reading it 
right, this doesn't seem like what you generally want to happen - eg in my case if you get some loss on a flow that 
contains fragments its very easy to end up with all fragments lost until you meet the above criteria and drop the queue 
after 30 seconds, instead of making a best effort to reassemble new packets as they come in, dropping old ones.

Thanks,
Matt

(Note: not subscribed, please keep me on CC when responding)
