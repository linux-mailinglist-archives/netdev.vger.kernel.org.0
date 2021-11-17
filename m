Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE454540F3
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 07:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhKQGkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 01:40:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233680AbhKQGkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 01:40:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637131039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AnnDd8YZ4vyOlJjo3rcZsM+w/aKPEgM8EgOmw6rHdwI=;
        b=aRSs2zEyhTEahJ1Ib47xoRz/O+wLT9fBjMcQ3ZeCMB8e+BltoaoWTk25DOQfB9EQbTWfHk
        PI0fexV9kMmQgrh3HIURxxDi0euXn6CO/u2yejHTNMvF6nUjI/KgLUwU32mvGmHJwZew4g
        fRm1tadW7KgAJb4UKNuNCb5ovt/8Br0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-48273EVbOCmR47IwyCJTkg-1; Wed, 17 Nov 2021 01:37:13 -0500
X-MC-Unique: 48273EVbOCmR47IwyCJTkg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E7D91006AA5;
        Wed, 17 Nov 2021 06:37:12 +0000 (UTC)
Received: from p1 (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 888E41017E35;
        Wed, 17 Nov 2021 06:37:10 +0000 (UTC)
Date:   Wed, 17 Nov 2021 07:37:08 +0100
From:   Stefan Assmann <sassmann@redhat.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brelinski, Tony" <tony.brelinski@intel.com>
Subject: Re: [PATCH net 06/10] iavf: prevent accidental free of filter
 structure
Message-ID: <20211117063708.ekrxtv7e6jn5thvp@p1>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
 <20211115235934.880882-7-anthony.l.nguyen@intel.com>
 <20211116072421.jar25sc7plvql7gw@p1>
 <a7adb8a7-800e-6761-b791-e877ff79210a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7adb8a7-800e-6761-b791-e877ff79210a@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-16 20:18, Keller, Jacob E wrote:
> On 11/15/2021 11:24 PM, Stefan Assmann wrote:
> > On 2021-11-15 15:59, Tony Nguyen wrote:
> >> From: Jacob Keller <jacob.e.keller@intel.com>
> >>
> >> In iavf_config_clsflower, the filter structure could be accidentally
> >> released at the end, if iavf_parse_cls_flower or iavf_handle_tclass ever
> >> return a non-zero but positive value.
> >>
> >> In this case, the function continues through to the end, and will call
> >> kfree() on the filter structure even though it has been added to the
> >> linked list.
> >>
> >> This can actually happen because iavf_parse_cls_flower will return
> >> a positive IAVF_ERR_CONFIG value instead of the traditional negative
> >> error codes.
> > 
> > Hi Jacob,
> > 
> > where exactly does this happen?
> > Looking at iavf_parse_cls_flower() I see all returns of IAVF_ERR_CONFIG
> > as "return IAVF_ERR_CONFIG;" while IAVF_ERR_CONFIG is defined as
> >         IAVF_ERR_CONFIG                         = -4,
> > 
> > I'm not opposed to this change, just wondering what's going on.
> > 
> >   Stefan
> > 
> 
> Heh.
> 
> I don't have memory of the full context for the original work. We've
> been going through and trying to pull in fixes that we've done for our
> out-of-tree driver and get everything upstream.
> 
> At first I thought this might be because of some history where these
> values used to be positive in the out-of-tree history at some point...
> But I think this wasn't true. It is possible that some other flow
> accidentally sends a positive value, but I've long since lost memory of
> if I had an example of that. You're correct that IAVF_ERR_CONFIG is (and
> has been in both upstream and out-of-tree code since its inception)
> negative.
> 
> I don't think this change is harmful, but I think you're right in
> pointing out the description isn't really valid.
> 
> I'm happy to re-write this commit message for clarity.
> 
> I do think switching to "if (err)" is more idiomatic and the correct
> thing to do.

Great feedback thanks, I totally agree.

  Stefan

