Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412DA7DF91
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732428AbfHAP6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:58:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36722 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732363AbfHAP6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 11:58:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so59573137wme.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 08:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a0EUgeGqQ7K8JBk8474/F7Qfdf6czPogTZsCAuEQGPE=;
        b=Cedvc/hDg1zS8ujoDefQyjF2fh2A4pTTi8NTVs4oEoKXxc8aN3RlqCXndA1mzqx/VZ
         jMQu90wd7Fa+ep4/e9Jomy9e1HFs0ECgx3/8UgeNSfxczena2i0dwBiQQqBmPT484Soo
         BJIPNSxc3KmPbx8b+cUPUu/lG5SXtcbBTDsR6slhyKV6cZSHAGcozq93CiqGOO3W/WhN
         RkqBy1ElL52ysxRusPCYyHXV79QSVRGKeuif4VGYhoa8UMkld48nJ5HBfopG/eaKXcCW
         Qy/lGMnhHc5RztEWV7cH7n+RrUqq3zHCpaY3QcPpOTV9F3IArOpMDJ32OxiEQ2nErALk
         x1TA==
X-Gm-Message-State: APjAAAWZExORM3ymB7AGfuTM7ittyyNgNWDjr82q6EIbB6+peSiWoKim
        cm28yKCzTUljjWPfCDzlCDX+1g==
X-Google-Smtp-Source: APXvYqzzbNpTopM4KULhskQlC6/TwvH5ODVZW62e6oBlm1yrl91OGvxzGfqciA+7f4tgcVTJRlc2uQ==
X-Received: by 2002:a05:600c:2388:: with SMTP id m8mr15142423wma.23.1564675119726;
        Thu, 01 Aug 2019 08:58:39 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id r4sm44542036wrq.82.2019.08.01.08.58.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 08:58:39 -0700 (PDT)
Date:   Thu, 1 Aug 2019 17:58:36 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/11] vsock_test: skip read() in test_stream*close
 tests on a VMCI host
Message-ID: <20190801155836.ssounrtdtm5m6q6u@steredhat>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-11-sgarzare@redhat.com>
 <79ffb2a6-8ed2-cce2-7704-ed872446c0fe@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79ffb2a6-8ed2-cce2-7704-ed872446c0fe@cogentembedded.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 06:53:32PM +0300, Sergei Shtylyov wrote:
> Hello!
> 

Hi :)

> On 08/01/2019 06:25 PM, Stefano Garzarella wrote:
> 
> > When VMCI transport is used, if the guest closes a connection,
> > all data is gone and EOF is returned, so we should skip the read
> > of data written by the peer before closing the connection.
> > 
> > Reported-by: Jorgen Hansen <jhansen@vmware.com>
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  tools/testing/vsock/vsock_test.c | 26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> > index cb606091489f..64adf45501ca 100644
> > --- a/tools/testing/vsock/vsock_test.c
> > +++ b/tools/testing/vsock/vsock_test.c
> [...]
> > @@ -79,16 +80,27 @@ static void test_stream_client_close_server(const struct test_opts *opts)
> >  		exit(EXIT_FAILURE);
> >  	}
> >  
> > +	local_cid = vsock_get_local_cid(fd);
> > +
> >  	control_expectln("CLOSED");
> >  
> >  	send_byte(fd, -EPIPE);
> > -	recv_byte(fd, 1);
> > +
> > +	/* Skip the read of data wrote by the peer if we are on VMCI and
> 
>    s/wrote/written/?
> 

Thanks, I'll fix it!
Stefano

> > +	 * we are on the host side, because when the guest closes a
> > +	 * connection, all data is gone and EOF is returned.
> > +	 */
> > +	if (!(opts->transport == TEST_TRANSPORT_VMCI &&
> > +	    local_cid == VMADDR_CID_HOST))
> > +		recv_byte(fd, 1);
> > +
> >  	recv_byte(fd, 0);
> >  	close(fd);
> >  }
> [...]
> 
> MBR, Sergei

-- 
