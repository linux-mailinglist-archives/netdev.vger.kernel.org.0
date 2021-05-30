Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E433952CF
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 22:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhE3UHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 16:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhE3UG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 16:06:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10CEE61205;
        Sun, 30 May 2021 20:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622405120;
        bh=0WJeJ66NcHjRTfmQ2VvtY7ODpeaqp8ukoRUJHXV3uGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fCGkrRpwji7Zs3xy3bW2FhrKrYh7ZYBRIKMQwXUKdLcck1KT+OVOWp0IzPaTPxDba
         bNLeJjJHIM8L8nM7JFIBdbj+oOJeyFfAfGxa3TJo80AbkW75LERnqazVt51z7PjbYK
         TaFSYsXxsNVLB2xZimr1B0L/AtKKZGxvvHITlP9JHNvgdxazXQIGtK8GBSpPNdjL4o
         JwF0m1aVrwjruCF9B/zjIVIAzjleN+xeI2eLd6sOJPOHzn2PEeaWmrN3nFrShmroSF
         1jBXecHYm4LbZYqH/M6SPM13zaAeQPjBkYkooARtQL8oc8Y/o8awRNeEs5G6MUitZ4
         Tg+GUBRFB05tQ==
Date:   Sun, 30 May 2021 13:05:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
Message-ID: <20210530130519.2fc95684@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1616887215.34203636.1622386231363.JavaMail.zimbra@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
        <20210527151652.16074-3-justin.iurman@uliege.be>
        <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be>
        <1616887215.34203636.1622386231363.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 May 2021 16:50:31 +0200 (CEST) Justin Iurman wrote:
> >> Last two sentences are repeated.  
> > 
> > One describes net.ipv6.conf.XXX.ioam6_id (per interface) and the other describes
> > net.ipv6.ioam6_id (per namespace). It allows for defining an IOAM id to an
> > interface and, also, the node in general.
> >   
> >> Is 0 a valid interface ID? If not why not use id != 0 instead of
> >> having a separate enabled field?  
> > 
> > Mainly for semantic reasons. Indeed, I'd prefer to keep a specific "enable" flag
> > per interface as it sounds more intuitive. But, also because 0 could very well
> > be a "valid" interface id (more like a default value).  
> 
> Actually, it's more than for semantic reasons. Take the following topology:
> 
>  _____              _____              _____
> |     | eth0  eth0 |     | eth1  eth0 |     |
> |  A  |.----------.|  B  |.----------.|  C  |
> |_____|            |_____|            |_____|
> 
> If I only want IOAM to be deployed from A to C but not from C to A,
> then I would need the following on B (let's just focus on B):
> 
> B.eth0.ioam6_enabled = 1 // enable IOAM *on input* for B.eth0
> B.eth0.ioam6_id = B1
> B.eth1.ioam6_id = B2
> 
> Back to your suggestion, if I only had one field (i.e., ioam6_id != 0
> to enable IOAM), I would end up with:
> 
> B.eth0.ioam6_id = B1 // (!= 0)
> B.eth1.ioam6_id = B2 // (!= 0)
> 
> Which means in this case that IOAM would also be enabled on B for the
> reverse path. So we definitely need two fields to distinguish both
> the status (enabled/disabled) and the IOAM ID of an interface.

Makes sense. Is it okay to assume 0 is equivalent to ~0, though:

+		raw32 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
+		if (!raw32)
+			raw32 = IOAM6_EMPTY_u24;

etc. Quick grep through the RFC only reveals that ~0 is special (not
available). Should we init ids to ~0 instead of 0 explicitly?
