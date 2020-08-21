Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA2E24C90A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 02:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgHUAOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 20:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgHUAOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 20:14:34 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61DF820702;
        Fri, 21 Aug 2020 00:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597968873;
        bh=o1Zwo1/KaKyzpCwoAXezNKyP7BpfT2liKYzwKSwJDqM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tosj4AQ3srOnXy/NJGKJ3gHfoeNr315jbaJyK7Xdexw7XilmeUMx9a7rhq2SyZTmK
         uo/irX8RWCMcCoLlSTqs4RCRl6mfOvMAifyFL12YcENU+JjkmuyjRpiQqkXeAwW7nZ
         5sJ5RV9jOgW2cs1+R73s5lk489aUaUskl2K88qzo=
Date:   Thu, 20 Aug 2020 17:14:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Thompson <dthompson@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com,
        Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next v2] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <20200820171431.194169ee@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820230439.5duakpmsg7jysdwq@skbuf>
References: <1596149638-23563-1-git-send-email-dthompson@mellanox.com>
        <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200820230439.5duakpmsg7jysdwq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 02:04:39 +0300 Vladimir Oltean wrote:
> On Thu, Jul 30, 2020 at 05:30:59PM -0700, Jakub Kicinski wrote:
> > On Thu, 30 Jul 2020 18:53:58 -0400 David Thompson wrote:  
> > > +
> > > +	/* Tell networking subsystem to poll GigE driver */
> > > +	napi_schedule(&priv->napi);  
> > 
> > _irqoff  
> 
> Hmm, I wouldn't be so sure about this particular advice. With
> PREEMPT_RT, interrupt handlers are force-threaded and run in process
> context, therefore with hardirqs enabled. This driver doesn't call
> request_irq with IRQF_NO_THREAD, so calling napi_schedule_irqoff would
> create a bug that is very, very difficult to find.

Doesn't PREEMPT_RT take a local_lock or some form thereof around the
irq threads then? If it doesn't then we probably need one around NAPI.

Regardless even if that's the case this is an existing issue, and not
something that changes how the driver API would look.
