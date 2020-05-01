Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523641C1873
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbgEAOrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:47:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729245AbgEAOr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588344448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TAjswuo/nfZVxK4WmcUPw+t1lhJhZPT7S8oViDh5c/M=;
        b=gZ0n49WCj0NWj2ULNX6/drg10r9zbl06ExpDL3zTyMK9Nk+HDRGBS1ahMhocTnlEwhF7Fn
        +/YNt/i3MMyBOkNczjZXlbZiqb9yot/ZDikgSY0R38k81zH9wwQfSmruAFt4Hd/JJLFkL1
        Nc9YyPx/aD+FDhf08V7d78ZIwVJw18o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-XycBYBrvMfGAR2SyAfIh3Q-1; Fri, 01 May 2020 10:47:19 -0400
X-MC-Unique: XycBYBrvMfGAR2SyAfIh3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E4DD1800D4A;
        Fri,  1 May 2020 14:47:16 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A2A56A94C;
        Fri,  1 May 2020 14:47:04 +0000 (UTC)
Date:   Fri, 1 May 2020 16:47:03 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sameehj@amazon.com" <sameehj@amazon.com>,
        Wei Liu <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        brouer@redhat.com
Subject: Re: [PATCH net-next v2 12/33] hv_netvsc: add XDP frame size to
 driver
Message-ID: <20200501164703.75eb5737@carbon>
In-Reply-To: <MN2PR21MB1437A4F44AC313E5DF962B35CAAA0@MN2PR21MB1437.namprd21.prod.outlook.com>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
        <158824568241.2172139.9308631605958332864.stgit@firesoul>
        <MN2PR21MB1437A4F44AC313E5DF962B35CAAA0@MN2PR21MB1437.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Apr 2020 14:20:20 +0000
Haiyang Zhang <haiyangz@microsoft.com> wrote:
> > -----Original Message-----
> > From: Jesper Dangaard Brouer <brouer@redhat.com>
> > 
> > The hyperv NIC drivers XDP implementation is rather disappointing as it will
> > be a slowdown to enable XDP on this driver, given it will allocate a new page
> > for each packet and copy over the payload, before invoking the XDP BPF-
> > prog.  
>
> This needs correction. As I said previously -- 
> This statement is not accurate -- The data path of netvsc driver does memory 
> allocation and copy even without XDP, so it's not "a slowdown to enable XDP".

Okay, I have changed the paragraph text to:

 The hyperv NIC driver does memory allocation and copy even without XDP.
 In XDP mode it will allocate a new page for each packet and copy over
 the payload, before invoking the XDP BPF-prog.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

