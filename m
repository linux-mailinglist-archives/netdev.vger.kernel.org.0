Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ADE2D7D1F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395471AbgLKRj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:39:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395349AbgLKRjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:39:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607708261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOsykB63req6cE/5LoOyLCDL6IQs90px0MUJ01HwVJI=;
        b=PSKilKv7XKesaib60fZ8elobNIFXqcOhPdzYMhu9rwUIoF8JJ4UjYIJ53Gfa9EYJlr61/Z
        UIXF+tXfYMktxvAW85/7SL137w8SYAfZbQslnAoijB9Ku/Pf0cgXexlJkjxmdEjPcspbt5
        m8APAkS78bvgLo17bs7fkeeWO1gE7y8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-oRLqvIbJPGWTWyZB_yPhDA-1; Fri, 11 Dec 2020 12:37:38 -0500
X-MC-Unique: oRLqvIbJPGWTWyZB_yPhDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDC97107ACE4;
        Fri, 11 Dec 2020 17:37:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 590E96F45B;
        Fri, 11 Dec 2020 17:37:35 +0000 (UTC)
Message-ID: <81dfd08b90f841194237e074aaa3d57cada7afad.camel@redhat.com>
Subject: Re: [PATCH v17 3/3] bus: mhi: Add userspace client interface driver
From:   Dan Williams <dcbw@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Date:   Fri, 11 Dec 2020 11:37:34 -0600
In-Reply-To: <X9MjXWABgdJIpyIw@kroah.com>
References: <1607670251-31733-1-git-send-email-hemantk@codeaurora.org>
         <1607670251-31733-4-git-send-email-hemantk@codeaurora.org>
         <X9MjXWABgdJIpyIw@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-11 at 08:44 +0100, Greg KH wrote:
> On Thu, Dec 10, 2020 at 11:04:11PM -0800, Hemant Kumar wrote:
> > This MHI client driver allows userspace clients to transfer
> > raw data between MHI device and host using standard file
> > operations.
> > Driver instantiates UCI device object which is associated to device
> > file node. UCI device object instantiates UCI channel object when
> > device
> > file node is opened. UCI channel object is used to manage MHI
> > channels
> > by calling MHI core APIs for read and write operations. MHI
> > channels
> > are started as part of device open(). MHI channels remain in start
> > state until last release() is called on UCI device file node.
> > Device
> > file node is created with format
> > 
> > /dev/<mhi_device_name>
> > 
> > Currently it supports QMI channel. libqmi is userspace MHI client
> > which
> > communicates to a QMI service using QMI channel. libqmi is a glib-
> > based
> > library for talking to WWAN modems and devices which speaks QMI
> > protocol.
> > For more information about libqmi please refer
> > https://www.freedesktop.org/wiki/Software/libqmi/
> 
> This says _what_ this is doing, but not _why_.
> 
> Why do you want to circumvent the normal user/kernel apis for this
> type
> of device and move the normal network handling logic out to
> userspace?
> What does that help with?  What does the current in-kernel api lack
> that
> this userspace interface is going to solve, and why can't the in-
> kernel
> api solve it instead?
> 
> You are pushing a common user/kernel api out of the kernel here, to
> become very device-specific, with no apparent justification as to why
> this is happening.
> 
> Also, because you are going around the existing network api, I will
> need
> the networking maintainers to ack this type of patch.

Just to re-iterate: QMI ~= AT commands ~= MBIM (not quite, but same
level)

We already do QMI-over-USB, or AT-over-CDC-ACM. This is QMI-over-MHI.

It's not networking data plane. It's WWAN device configuration.

There are no current kernel APIs for this, and I really don't think we
want there to be. The API surface is *huge* and we definitely don't
want that in-kernel.

Dan

