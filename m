Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097D08124C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 08:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfHEG2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 02:28:24 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36198 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfHEG2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 02:28:23 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so79957409qtc.3
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 23:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KWA/zRel4261JwzY6PT0mEAQMawH9MJ6QOovbW+PtWw=;
        b=KltqvwrBE1DxBcpnONfue8WLR9jq/RFooaWd6cXfHbuVKSspWypbdtfmfg2DqGUjBd
         5kGOpBI8tLhde+vUP8EjoDCkxqvgkSfZ8cdJKDAQG78O6h2C8Yvu9oVAJ/Y42SCvUyqj
         1FmJ9lr0fhvgmHqEN1VL5Oi2sRzEzv3mqv+yqIvbcP3pkwdgGO6GJgQyhgLTpQFHnsbs
         IwPr5fiUrSaBc9w+C8LUb3q3SCFo1kSj+K6kAIu+bxQcYlJqr4KlnnSi7p6FNVbjEbV8
         lk4Xwx+hyltZ3azmLWgApTencaYjTTmHqbPhKyL5Dqr9OH84/6aazxYXNKwrfHmM7JdA
         Ygvw==
X-Gm-Message-State: APjAAAWBldJCDfaWCUfXhYCfoGD30IGAcLJLPv55b6D0wfUqD4wKs0OO
        c4BRDFsAB9+8C13YrvamBWKDBA==
X-Google-Smtp-Source: APXvYqxmlaPhRV6WcTX7MFxiXlbHz2huG6EImOc41/XnvtSvCJPv0MiUiy9pupzwZ++qXjlc9yUxxA==
X-Received: by 2002:ad4:4a14:: with SMTP id m20mr5317024qvz.58.1564986502769;
        Sun, 04 Aug 2019 23:28:22 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id q56sm42239382qtq.64.2019.08.04.23.28.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 23:28:21 -0700 (PDT)
Date:   Mon, 5 Aug 2019 02:28:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190805020752-mutt-send-email-mst@kernel.org>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com>
 <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802094331-mutt-send-email-mst@kernel.org>
 <6c3a0a1c-ce87-907b-7bc8-ec41bf9056d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c3a0a1c-ce87-907b-7bc8-ec41bf9056d8@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 12:33:45PM +0800, Jason Wang wrote:
> 
> On 2019/8/2 下午10:03, Michael S. Tsirkin wrote:
> > On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
> > > Btw, I come up another idea, that is to disable preemption when vhost thread
> > > need to access the memory. Then register preempt notifier and if vhost
> > > thread is preempted, we're sure no one will access the memory and can do the
> > > cleanup.
> > Great, more notifiers :(
> > 
> > Maybe can live with
> > 1- disable preemption while using the cached pointer
> > 2- teach vhost to recover from memory access failures,
> >     by switching to regular from/to user path
> 
> 
> I don't get this, I believe we want to recover from regular from/to user
> path, isn't it?

That (disable copy to/from user completely) would be a nice to have
since it would reduce the attack surface of the driver, but e.g. your
code already doesn't do that.



> 
> > 
> > So if you want to try that, fine since it's a step in
> > the right direction.
> > 
> > But I think fundamentally it's not what we want to do long term.
> 
> 
> Yes.
> 
> 
> > 
> > It's always been a fundamental problem with this patch series that only
> > metadata is accessed through a direct pointer.
> > 
> > The difference in ways you handle metadata and data is what is
> > now coming and messing everything up.
> 
> 
> I do propose soemthing like this in the past:
> https://www.spinics.net/lists/linux-virtualization/msg36824.html. But looks
> like you have some concern about its locality.

Right and it doesn't go away. You'll need to come up
with a test that messes it up and triggers a worst-case
scenario, so we can measure how bad is that worst-case.

> But the problem still there, GUP can do page fault, so still need to
> synchronize it with MMU notifiers.

I think the idea was, if GUP would need a pagefault, don't
do a GUP and do to/from user instead. Hopefully that
will fault the page in and the next access will go through.

> The solution might be something like
> moving GUP to a dedicated kind of vhost work.

Right, generally GUP.

> 
> > 
> > So if continuing the direct map approach,
> > what is needed is a cache of mapped VM memory, then on a cache miss
> > we'd queue work along the lines of 1-2 above.
> > 
> > That's one direction to take. Another one is to give up on that and
> > write our own version of uaccess macros.  Add a "high security" flag to
> > the vhost module and if not active use these for userspace memory
> > access.
> 
> 
> Or using SET_BACKEND_FEATURES?

No, I don't think it's considered best practice to allow unpriveledged
userspace control over whether kernel enables security features.

> But do you mean permanent GUP as I did in
> original RFC https://lkml.org/lkml/2018/12/13/218?
> 
> Thanks

Permanent GUP breaks THP and NUMA.

> > 
> > 
