Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB20D23CF7E
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgHETV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:21:26 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:61112 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728929AbgHERmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596649366; x=1628185366;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=lNEkMbYi0vdrAauS7Kx1F2bZJKjVMy/W93IpO/fQsUY=;
  b=QLWP0f4m1iXMxE7WwpXelDNbJnoNpF+g0+s6zbmV6NzsvnU9VULdxkeI
   gY9/qb9cgZPYou8CeQkx/eJVolTOG/oZ7NyXiJT+rDnyjMXLfW03bDpfT
   KqB676qf2oJz5gqmTw4a4slQHYINimnhvUdLlAyixXdcL2ljd5cHg23Bh
   E=;
IronPort-SDR: 9ySw8fWle7MttK7suY4BIhxnPpUpw/OAAJafe5LAcUtSaR7nXlHuY3JimXe5qJR44ypaJ2YRoP
 96gheUehfPyA==
X-IronPort-AV: E=Sophos;i="5.75,438,1589241600"; 
   d="scan'208";a="57653120"
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend mode
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 05 Aug 2020 17:42:44 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id C5250A2967;
        Wed,  5 Aug 2020 17:42:42 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 17:42:20 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 17:42:20 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Wed, 5 Aug 2020 17:42:19 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id D027740865; Wed,  5 Aug 2020 17:42:19 +0000 (UTC)
Date:   Wed, 5 Aug 2020 17:42:19 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     Stefano Stabellini <sstabellini@kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <konrad.wilk@oracle.com>, <roger.pau@citrix.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Message-ID: <20200805174219.GA16105@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <alpine.DEB.2.21.2007211640500.17562@sstabellini-ThinkPad-T480s>
 <20200722180229.GA32316@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <alpine.DEB.2.21.2007221645430.17562@sstabellini-ThinkPad-T480s>
 <20200723225745.GB32316@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <alpine.DEB.2.21.2007241431280.17562@sstabellini-ThinkPad-T480s>
 <66a9b838-70ed-0807-9260-f2c31343a081@oracle.com>
 <20200730230634.GA17221@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <53b577a3-6af9-5587-7e47-485be38b3653@oracle.com>
 <20200804234201.GA23820@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <50d0dbe1-533e-792a-6916-8c72d623064a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50d0dbe1-533e-792a-6916-8c72d623064a@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 09:31:13AM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 8/4/20 7:42 PM, Anchal Agarwal wrote:
> >
> > I think this could be done. PM_HIBERNATION_PREPARE could return -ENOTSUPP
> > for arm and pvh dom0 when the notifier call chain is invoked for this case
> > in hibernate(). This will then be an empty notifier just for checking two
> > usecases.
> > Also, for pvh dom0, the earlier code didn't register any notifier,
> > with this approach you are suggesting setup the notifier for hvm/pvh dom0 and
> > arm but fail during notifier call chain during PM_HIBERNATION_PREPARE ?
> 
> 
> Right.
> 
> 
> (Although the earlier code did register the notifier:
> xen_setup_pm_notifier() would return an error for !xen_hvm_domain() and
> PVH *is* an HVM domain, so registration would actually happen)
>
Yes you are right. My bad, what I meant with "earlier code" was whatever we
discussed w.r.t to removing the notifier all together, it won't be registered for
pvh dom0.
Anyways got the point :)
> 
> >
> > I think still getting rid of suspend mode that was earlier a part of this
> > notifier is a good idea as it seems redundant as you pointed out earlier.
> 
> 
> Yes.
> 
> 
> -boris
Thanks,
Anchal
> 
> 
