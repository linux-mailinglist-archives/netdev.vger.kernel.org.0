Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF60A1E475C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389602AbgE0Pao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:30:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388145AbgE0Pao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:30:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590593443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qBFd5SKDdf1t0kkoyAdfirqzLgby4wpAUw4OqWeZPFE=;
        b=XAmYsgZJjZUnNSdo7QQ/GERgixJfEYowB1NhN/E9MPHOOrjAJG1vnEHN/bcIb9PN0bCjgX
        xZ1q3wKZOO5orI582C6RDYCwC8dRMoojtGL5J/4UPReM6s19Q1Uo0n0nOE2ZHhiw2BVAh6
        oZF1ItM332dW6ZgAbVuHXF/7hAtIoeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-0OtYbYCdM-6qSZPjG_rmpg-1; Wed, 27 May 2020 11:30:38 -0400
X-MC-Unique: 0OtYbYCdM-6qSZPjG_rmpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F7DE108BD0A;
        Wed, 27 May 2020 15:30:34 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E8B76E71D;
        Wed, 27 May 2020 15:30:23 +0000 (UTC)
Date:   Wed, 27 May 2020 17:30:21 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, toke@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next 1/5] bpf: Handle 8-byte values in DEVMAP and
 DEVMAP_HASH
Message-ID: <20200527173021.10468d8b@carbon>
In-Reply-To: <bb30af38-c74c-1c78-0b10-a00de39b434b@gmail.com>
References: <20200527010905.48135-1-dsahern@kernel.org>
        <20200527010905.48135-2-dsahern@kernel.org>
        <20200527122612.579fbb25@carbon>
        <bb30af38-c74c-1c78-0b10-a00de39b434b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 08:27:36 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 5/27/20 4:26 AM, Jesper Dangaard Brouer wrote:
> > IMHO we really need to leverage BTF here, as I'm sure we need to do more
> > extensions, and this size matching will get more and more unmaintainable.
> > 
> > With BTF in place, dumping the map via bpftool, will also make the
> > fields "self-documenting".  
> 
> furthermore, the kernel is changing the value - an fd is passed in and
> an id is returned. I do not see how any of this fits into BTF.

It can, as BTF actually support union's (I just tested that).

For the sake of end-users understanding this, I do wonder if it is
better to define the struct without the union, and have longer names
that will be part of BTF description, e.g (dumped via bpftool):

 struct dev_map_ext_val {
        u32 ifindex;
        int bpf_prog_fd_write;
        u32 bpf_prog_id_read;
 };

But a union would also work (also tested via BPF loading and BTF dumpinmg):

 struct dev_map_ext_val {
        u32 ifindex;
        union {
                int bpf_prog_fd_write;
                u32 bpf_prog_id_read;
        };
 };

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

