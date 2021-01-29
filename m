Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF10F308E08
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhA2UEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:04:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233143AbhA2UDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 15:03:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47E8464DFB;
        Fri, 29 Jan 2021 20:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611950571;
        bh=KwihAEFWKDSpf6SM8XAVBapoSBLr9FWQfLGmRKqnbiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JSOVj0SsRgnedf1jkzBO01LO2S7xQKWkb/P8SFyWRIJGpXF0BgNA5UnCekNDys5oD
         +JnTd1BPojGcCAG2ZjBR1uebqryDDrN45SUNMMhVsmTXOaDyCq4GXCNKqN7TcLMfg3
         aumrBKY7WytJ+6yVKhqasO3XQVoWeJASnim4+grpZfmaSpj/q/BfwtM2z0m8C3obeL
         XdsbSwp3gs/uKehBZ8pwyV0P2CChYujkqhrwORTI8NW6SMfsyRFyvc9h/yX6G5Ortg
         9e4LtzPazqunQcdwtsi8mAVsDbZd15J9maPYFXZUnBQGzNjEPVrOlAOukUAlx+Ehiy
         CzZAvARM0qljA==
Date:   Fri, 29 Jan 2021 12:02:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Message-ID: <20210129120250.269c366d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
References: <20210122150638.210444-1-willy@infradead.org>
        <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
        <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 11:48:15 -0800 Shoaib Rao wrote:
> >> SO_OOBINLINE does not control the delivery of signal, It controls how
> >> OOB Byte is delivered. It may not be obvious but this change does not
> >> deliver any Byte, just a signal. So, as long as sendmsg flag contains
> >> MSG_OOB, signal will be delivered just like it happens for TCP.  
> > Not as far as I can read this code. If MSG_OOB is set the data from the
> > message used to be discarded, and EOPNOTSUPP returned. Now the data gets
> > queued to the socket, and will be read inline.  
> 
> Data was discarded because the flag was not supported, this patch 
> changes that but does not support any urgent data.

When you say it does not support any urgent data do you mean the
message len must be == 0 because something is checking it, or that 
the code does not support its handling?

I'm perfectly fine with the former, just point me at the check, please.

> OOB data has some semantics that would have to be followed and if we 
> support SO_OOBINLINE we would have to support NOT SO_OOBINLINE.
> 
> One can argue that we add a socket option to allow this OR just do what 
> TCP does.
