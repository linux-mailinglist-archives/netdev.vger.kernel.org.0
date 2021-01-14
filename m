Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984282F6F1D
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731056AbhANXso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:48:44 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:54737 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731034AbhANXsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 18:48:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610668104; h=Message-ID: Subject: Cc: To: From: Date:
 Content-Transfer-Encoding: Content-Type: MIME-Version: Sender;
 bh=VqOOSdGNfO/h3J3IXfSdwQd9CHDv+2u1qcF0HvHMhF0=; b=j9tYLxyCfD7H/DtZFZFFsfagsbp75Dj7+Dp9SUUOm7/YtQNyzQfIpw7zuXAu+HwXgmKo7up6
 0uMXaCn8uoY9OiUNMxb38AsfDu9Z2rRRCV9BunZdqnkscvdpj5nybxx/+82tszyTfgOz2bKF
 eC+VHAgF4rkhieKvGnf95OJr0v0=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6000d82cba7f86850673554d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 23:47:56
 GMT
Sender: stranche=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1A4B5C433ED; Thu, 14 Jan 2021 23:47:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stranche)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 88A25C433C6;
        Thu, 14 Jan 2021 23:47:55 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 14 Jan 2021 16:47:55 -0700
From:   stranche@codeaurora.org
To:     netdev@vger.kernel.org
Cc:     subashab@codeaurora.org, dsahern@gmail.com, weiwan@google.com
Subject: List corruption from ipv6_route_seq_start
Message-ID: <a0d35019167c32728aa810fee91909b5@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

We've had a list corruption reported to us when using the 
/proc/net/ipv6_route file to read the routing information on the system 
on the 5.4.61 kernel.
 From the list pointers, it seems that the list_head in the fib6_walker 
has been reinitialized with INIT_LIST_HEAD() in 
ipv6_route_seq_setup_walk() while the walker was still on the 
fib6_walker list.

net->ipv6.fib6_walkers : 0xFFFFFFC013114DB0
next : 0xFFFFFF81E0899C88
prev : 0xFFFFFF81E0899C88

w->lh : 0xFFFFFF81E0899C88
next : 0xFFFFFF81E0899C88 // should be 0xFFFFFFC013114DB0
prev : 0xFFFFFF81E0899C88 // should be 0xFFFFFFC013114DB0

Looking over the seq_file operations for this, the only way I can see 
ipv6_route_seq_setup_walk() being called on a walker that has not been 
removed from the list with fib6_walker_unlink() is if 
ipv6_route_iter_active() returns false during ipv6_route_seq_stop(). As 
far as I can tell, this check is trying to assess if the walker has 
reached the end of the tree, and therefore no longer placed back on the 
fib6_walker list by ipv6_route_seq_next(), to avoid trying to double 
unlink the entry. This check seems to only be needed since 
fib6_unlink_walker() uses a plain list_del() call instead of 
list_del_init(), so simply checking list_empty(&w->lh) wouldn't 
correctly indicate if the walker had been unlinked previously.

At least from the semantics of the seq_file operations being used in 
seq_read(), it seems that there wouldn't be a reason to keep the walker 
around in the list after the completion of ipv6_route_seq_stop(), so I'm 
wondering if switching to this more direct check would be appropriate, 
as there seems to be some way that the current roundabout method is 
failing.

Call trace:
   __list_add_valid+0x74/0x90
   fib6_walker_link+0x78/0xb8
   ipv6_route_seq_start+0xec/0x138
   seq_read+0x18c/0x5b8
   proc_reg_read+0xa4/0x188
   __vfs_read+0x60/0x204
   vfs_read+0xa4/0x144

Thanks,
Sean
