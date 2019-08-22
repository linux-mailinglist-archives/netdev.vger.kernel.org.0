Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF3599060
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733002AbfHVKIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732979AbfHVKIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:08:40 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B611A50F7C
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 10:08:39 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id a17so2982629wrw.3
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 03:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+QZ6pW149hcLIfsZZS+dKkZglSU+Xi8vHC91tSDHm3c=;
        b=p4TRn3C5uYF0nUaDgtMvDko1ZcdUmu1eiE1hEdyLw8C7H5qkGuBwvD9gvZRR1YRjA3
         p9Tu/346w5aBS25tYJGq30xi+SUR2eMI75HyD3rT+S1zYiM9aKQ546Fry7LPnGAsG4+O
         2rUKMOiykP9AX1x7Jrn4TcXr3miFYSiIftIvfQy+7ehoGI7fv76Qb8Njfl6jCZ5fV9He
         XnMmI5wC4tZSOhN3BBCH+I1HEVIwtzsiaNPYu6XVEM9Z2QhklI9r0ASgV46yKvKN01YM
         eJ4I2gtLF9Vmywhzuyeq8Qsv0vhrgqzOTjAp4slh7Xzz27s0xnBaeEl7f/MXIfge6HYQ
         YZ+Q==
X-Gm-Message-State: APjAAAX7E8FlEHFkHu7cH4egBd3ztSS4cofyScfLcoH4Bw8hUPyyHucM
        uIHvi4g/Kyn3t1mMF8IBJoLxw1jwi8e5X2qZmzpsddSF262WrjviQXj398CqyT34zc0qebCBiLL
        Nluuf/wgNueSnGqA1
X-Received: by 2002:a1c:7513:: with SMTP id o19mr5210669wmc.126.1566468518280;
        Thu, 22 Aug 2019 03:08:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx0XnwkglmAIZNRemEqCnbp6/DI7ya5vpk8WBx5UrfbHbyKJgBnEIawFQuaHzBUlbkohxgoxQ==
X-Received: by 2002:a1c:7513:: with SMTP id o19mr5210642wmc.126.1566468518041;
        Thu, 22 Aug 2019 03:08:38 -0700 (PDT)
Received: from steredhat (host80-221-dynamic.18-79-r.retail.telecomitalia.it. [79.18.221.80])
        by smtp.gmail.com with ESMTPSA id o129sm7596453wmb.41.2019.08.22.03.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 03:08:37 -0700 (PDT)
Date:   Thu, 22 Aug 2019 12:08:35 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/11] vsock_test: skip read() in test_stream*close
 tests on a VMCI host
Message-ID: <20190822100835.7u27ijlaydk72orv@steredhat>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-11-sgarzare@redhat.com>
 <20190820083203.GB9855@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820083203.GB9855@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 09:32:03AM +0100, Stefan Hajnoczi wrote:
> On Thu, Aug 01, 2019 at 05:25:40PM +0200, Stefano Garzarella wrote:
> > When VMCI transport is used, if the guest closes a connection,
> > all data is gone and EOF is returned, so we should skip the read
> > of data written by the peer before closing the connection.
> 
> All transports should aim for identical semantics.  I think virtio-vsock
> should behave the same as VMCI since userspace applications should be
> transport-independent.

Yes, it is a good point!

> 
> Let's view this as a vsock bug.  Is it feasible to change the VMCI
> behavior so it's more like TCP sockets?  If not, let's change the
> virtio-vsock behavior to be compatible with VMCI.

I'm not sure it is feasible to change the VMCI behavior. IIUC reading the
Jorgen's answer [1], this was a decision made during the implementation.

@Jorgen: please, can you confirm? or not :-)

If it is the case, I'll change virtio-vsock to the same behavior.


Thanks,
Stefano

[1] https://patchwork.ozlabs.org/cover/847998/#1831400
