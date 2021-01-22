Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DED2FFE24
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbhAVI1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:27:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbhAVI0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:26:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611303914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3oZAyMnHl5/M5aWyeYIaLwYFeScO0O+ZrUVndtZhMo=;
        b=ZA9m6mF5+Jm/CQ+qGkrQt18PyULUlWdqXrVuElDIWkhM2mNqUl7CHa/yJ4jIeh/wVW2bDR
        yPHwefCp4K45eNxp9/KN/8Dq2CsNvz/XBVkoxTmtsGLn/bEO9KrSyQknG/eBoh2lFQFkt7
        UJzRwAkcmA2k4x1V4QLgn7JHmtqX+lg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-Q-CPgi4wOmSjchIN67K-oQ-1; Fri, 22 Jan 2021 03:25:10 -0500
X-MC-Unique: Q-CPgi4wOmSjchIN67K-oQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E1E69CDB6;
        Fri, 22 Jan 2021 08:25:09 +0000 (UTC)
Received: from ovpn-113-245.ams2.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00EC35D9E8;
        Fri, 22 Jan 2021 08:25:07 +0000 (UTC)
Message-ID: <e093e7615490baad413ef6ba49154e3e4e98399a.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 5/5] mptcp: implement delegated actions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jan 2021 09:25:07 +0100
In-Reply-To: <20210121173437.1b945b01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1611153172.git.pabeni@redhat.com>
         <fbae7709d333eb2afcc79e69a8db3d952292564f.1611153172.git.pabeni@redhat.com>
         <20210121173437.1b945b01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 2021-01-21 at 17:34 -0800, Jakub Kicinski wrote:
> On Wed, 20 Jan 2021 15:39:14 +0100 Paolo Abeni wrote:
> > On MPTCP-level ack reception, the packet scheduler
> > may select a subflow other then the current one.
> > 
> > Prior to this commit we rely on the workqueue to trigger
> > action on such subflow.
> > 
> > This changeset introduces an infrastructure that allows
> > any MPTCP subflow to schedule actions (MPTCP xmit) on
> > others subflows without resorting to (multiple) process
> > reschedule.
> 
> If your work doesn't reschedule there should not be multiple 
> rescheds, no?

Thank you for looking into this.

With the workqueue it would be:

<running process> -> BH -> (process scheduler) -> MPTCP workqueue ->
(process scheduler) -> <running process>

With this infra is:

<running process> -> BH -> BH -> <running process>

> > A dummy NAPI instance is used instead. When MPTCP needs to
> > trigger action an a different subflow, it enqueues the target
> > subflow on the NAPI backlog and schedule such instance as needed.
> > 
> > The dummy NAPI poll method walks the sockets backlog and tries
> > to acquire the (BH) socket lock on each of them. If the socket
> > is owned by the user space, the action will be completed by
> > the sock release cb, otherwise push is started.
> > 
> > This change leverages the delegated action infrastructure
> > to avoid invoking the MPTCP worker to spool the pending data,
> > when the packet scheduler picks a subflow other then the one
> > currently processing the incoming MPTCP-level ack.
> > 
> > Additionally we further refine the subflow selection
> > invoking the packet scheduler for each chunk of data
> > even inside __mptcp_subflow_push_pending().
> 
> Is there much precedence for this sort of hijacking of NAPI 
> for protocol work? 

AFAICS, xfrm is using a similar trick in the receive path.

Note that we uses TX-only NAPIs, so this does not pollute the napi hash
table.

> Do you need it because of locking?

This infrastructure is used to avoid the workqueue usage in the MPTCP
receive path (to push pending data). With many mptcp connections
established that would be very bad for tput and latency. This
infrastructure is not strictly needed from a functinal PoV, but I was
unable to find any other way to avoid the workqueue usage.

Please let me know if the above is clear enough!

Thanks,

Paolo

