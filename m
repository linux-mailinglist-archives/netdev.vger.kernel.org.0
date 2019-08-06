Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D13830FD
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 13:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfHFLxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 07:53:20 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44440 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHFLxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 07:53:20 -0400
Received: by mail-qk1-f196.google.com with SMTP id d79so62529656qke.11
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 04:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eo4243fxJunv120eldJ+yINhsaoHQ/b07ic+MhyUnUY=;
        b=Z0mI1c0biLAyuHhq5HIH9liJ9V9NmYB6TCZCXG/MS5n6b7MXngGDqXWAvW9Q3wU70f
         Yuj4Gf5hmNpwIefJdv3jpcVqzwrm17rlQpqCpa8h75KznnlVcHW+bOQ8mi52XzW32i5X
         xMyKUlZMHS1zgPqQftCrIwo83eGAnrddpriXhq4ERkbDt3WwCS0upZb4/WtoahuAO8kW
         rLLLe/brCqzVyuGIKUWxPpcJJrKlwgWXPRE3jAKSeJ2mD0cdUXjpM0rJYi2yNTADYoYQ
         aDzSN7ZZQHTrS2/K7nALIkgZpt7+fyciFkxjLncICC8fqlQT1qsJ9jdY2CtN6k6kVuIQ
         kuUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eo4243fxJunv120eldJ+yINhsaoHQ/b07ic+MhyUnUY=;
        b=TQkeSZZm4uMIrCA6ztUeRaxQVDOuHs1cJZBhLlxOTLWDhGV1MnAoN4up2hW/hX140z
         Mb6PgOUAQ51IdaY1I6cqUcejF+nGccWZcuYfDup9mhwEY/snAQOfTToRAGVH//V1EDUp
         81gZoZ0qv0lNdD0FA/eLzvtnhEe7b1JeppNeX6HSQ7dkR7ul53ZhRZ57i+jzk1gcjqfA
         jJ6dsN5dUcZrPKUU/6+LJqrqOT+3vyE9x32/A0ZWUtDM6A85pWAt7KHm7B1pknp3uYzb
         ecqsgi1BYUkiocO0DdqiF0Fwl62VglBWYh6lixST1koYfRQH+VYjh+4qJldob14Y3nXV
         YTrg==
X-Gm-Message-State: APjAAAXwDLfgF/8+r/A+Vf2deGzlrd1Sa8k+f/yu16jsxFoJxEFuq4JU
        43hEN5nGosWrNHOxBoJ8iUq/Zw==
X-Google-Smtp-Source: APXvYqw8Kp97Codo4loFeh85jsMCmVqW5Bh1vzUEuORvgfGzgHvIynQzybQA5mb0rqsqpydwn040qg==
X-Received: by 2002:a05:620a:127c:: with SMTP id b28mr2606352qkl.299.1565092399391;
        Tue, 06 Aug 2019 04:53:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id r14sm40128814qke.47.2019.08.06.04.53.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Aug 2019 04:53:18 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1huy1l-0003cs-Vr; Tue, 06 Aug 2019 08:53:17 -0300
Date:   Tue, 6 Aug 2019 08:53:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190806115317.GA11627@ziepe.ca>
References: <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <20190802172418.GB11245@ziepe.ca>
 <20190803172944-mutt-send-email-mst@kernel.org>
 <20190804001400.GA25543@ziepe.ca>
 <20190804040034-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804040034-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 04:07:17AM -0400, Michael S. Tsirkin wrote:
> > > > Also, why can't this just permanently GUP the pages? In fact, where
> > > > does it put_page them anyhow? Worrying that 7f466 adds a get_user page
> > > > but does not add a put_page??
> > 
> > You didn't answer this.. Why not just use GUP?
> > 
> > Jason
> 
> Sorry I misunderstood the question. Permanent GUP breaks lots of
> functionality we need such as THP and numa balancing.

Really? It doesn't look like that many pages are involved..

Jason
