Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCDE1544C0
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgBFNVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:21:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbgBFNVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580995281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6S7ClQW5Wm4rgDcYznVacMFlwU0ScpDkO9Yz5LhdyY=;
        b=DR9WjrVdZWqmvxmxDNT/v904Zy05A9hrbid9Rj+9Vz5fwYu+LHbQ/MzsFgpdqgU4Ay5elc
        Hgj9DKcQhii2kwNX8ZthUG83iZ6sq0YerVYJrlBc/XlFWNfi5uZ8IgWsJEn8wcf8oWtEaR
        jvTCQe++oHidrJzFWq1qRRmBjTnmXZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-HKeAtuHZMmeL9h-e_aZAig-1; Thu, 06 Feb 2020 08:21:19 -0500
X-MC-Unique: HKeAtuHZMmeL9h-e_aZAig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 369DE10883B2;
        Thu,  6 Feb 2020 13:21:18 +0000 (UTC)
Received: from ovpn-116-143.ams2.redhat.com (ovpn-116-143.ams2.redhat.com [10.36.116.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26FEE84DB4;
        Thu,  6 Feb 2020 13:21:16 +0000 (UTC)
Message-ID: <13e8950e8537e549f6afb6e254ec75a7462ce648.camel@redhat.com>
Subject: Re: [BUG] pfifo_fast may cause out-of-order CAN frame transmission
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Date:   Thu, 06 Feb 2020 14:21:16 +0100
In-Reply-To: <ef6b4e00-75fe-70f6-6b57-7bdbaa1aac33@pengutronix.de>
References: <661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de>
         <7717e4470f6881bbc92645c72ad7f6ec71360796.camel@redhat.com>
         <779d3346-0344-9064-15d5-4d565647a556@pengutronix.de>
         <1b70f56b72943bf5dfd2813565373e8c1b639c31.camel@redhat.com>
         <53ce1ab4-3346-2367-8aa5-85a89f6897ec@pengutronix.de>
         <57a2352dfc442ea2aa9cd653f8e09db277bf67c7.camel@redhat.com>
         <b012e914-fc1a-5a45-f28b-e9d4d4dfc0fe@pengutronix.de>
         <ef6b4e00-75fe-70f6-6b57-7bdbaa1aac33@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-02-04 at 17:25 +0100, Ahmad Fatoum wrote:
> Hello Paolo,
> 
> On 1/20/20 5:06 PM, Ahmad Fatoum wrote:
> > Hello Paolo,
> > 
> > On 1/16/20 1:40 PM, Paolo Abeni wrote:
> > > I'm sorry for this trial & error experience. I tried to reproduce the
> > > issue on top of the vcan virtual device, but it looks like it requires
> > > the timing imposed by a real device, and it's missing here (TL;DR: I
> > > can't reproduce the issue locally).
> > 
> > No worries. I don't mind testing.
> > 
> > > Code wise, the 2nd patch closed a possible race, but it dumbly re-
> > > opened the one addressed by the first attempt - the 'empty' field must
> > > be cleared prior to the trylock operation, or we may end-up with such
> > > field set and the queue not empty.
> > > 
> > > So, could you please try the following code?
> > 
> > Unfortunately, I still see observe reodering.
> 
> Any news?

I'm unable to find any better solution than a revert. That will cost
some small performace regression, so I'm a bit reluctant to go ahead.
If there is agreement I can post the revert.

Cheers,

Paolo

