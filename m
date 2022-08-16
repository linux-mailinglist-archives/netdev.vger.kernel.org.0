Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6BF59615A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiHPRmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiHPRmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:42:37 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366D77FF98
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=usWA1FYfxZiMiM8vhSXRC5A8QO8bcDwoipgzL9wfqWw=; b=h+3Y+Jcmh/ag2jkmKAsXUv+AB4
        odY3a626coXI92ivzRbQiS5CNkQN4DqDmo4fJRAQATen7yUdhz+NwzNwJiRmykljRwuqNK2eEo04l
        EF8L+pHoIWSyS4bwlQAnvprLvZgMHLLIut/yFEGvq5S4WO0n5/0Xi7phcfdoM0v/YUV5PsMJbKCMP
        IwTDzZKZLI4T9ldpxAvzA1YsOP2SzRqJnUdfbYrhOXMazxNX87b2RC+aW1V4b/gP7XG1aOtxDQE1E
        lz9xhVKoDJmiScE7aIGfFhDrDtTsXQ14hjCKMLWfeD6kEhV+/aoqXB2EHqX5qViZ74Tm0rb52Yvio
        6RG5Y8PA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oO0aH-005866-Hy;
        Tue, 16 Aug 2022 17:42:33 +0000
Date:   Tue, 16 Aug 2022 18:42:33 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Kirill Tkhai <tkhai@ya.ru>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com
Subject: Re: [PATCH v2 0/2] unix: Add ioctl(SIOCUNIXGRABFDS) to grab files of
 receive queue skbs
Message-ID: <YvvXCWYpVCOxZeEt@ZenIV>
References: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 12:13:16AM +0300, Kirill Tkhai wrote:
> When a fd owning a counter of some critical resource, say, of a mount,
> it's impossible to umount that mount and disconnect related block device.
> That fd may be contained in some unix socket receive queue skb.
> 
> Despite we have an interface for detecting such the sockets queues
> (/proc/[PID]/fdinfo/[fd] shows non-zero scm_fds count if so) and
> it's possible to kill that process to release the counter, the problem is
> that there may be several processes, and it's not a good thing to kill
> each of them.
> 
> This patch adds a simple interface to grab files from receive queue,
> so the caller may analyze them, and even do that recursively, if grabbed
> file is unix socket itself. So, the described above problem may be solved
> by this ioctl() in pair with pidfd_getfd().
> 
> Note, that the existing recvmsg(,,MSG_PEEK) is not suitable for that
> purpose, since it modifies peek offset inside socket, and this results
> in a problem in case of examined process uses peek offset itself.
> Additional ptrace freezing of that task plus ioctl(SO_PEEK_OFF) won't help
> too, since that socket may relate to several tasks, and there is no
> reliable and non-racy way to detect that. Also, if the caller of such
> trick will die, the examined task will remain frozen forever. The new
> suggested ioctl(SIOCUNIXGRABFDS) does not have such problems.
> 
> The realization of ioctl(SIOCUNIXGRABFDS) is pretty simple. The only
> interesting thing is protocol with userspace. Firstly, we let userspace
> to know the number of all files in receive queue skbs. Then we receive
> fds one by one starting from requested offset. We return number of
> received fds if there is a successfully received fd, and this number
> may be less in case of error or desired fds number lack. Userspace
> may detect that situations by comparison of returned value and
> out.nr_all minus in.nr_skip. Looking over different variant this one
> looks the best for me (I considered returning error in case of error
> and there is a received fd. Also I considered returning number of
> received files as one more member in struct unix_ioc_grab_fds).

IMO it's a bad interface.  Take a good look at the logics in scan_children();
TCP_LISTEN side is there for reason.  And your magical ioctl won't help
with that case.
