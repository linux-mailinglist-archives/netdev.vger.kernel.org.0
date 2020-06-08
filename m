Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1118A1F2044
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 21:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgFHTpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 15:45:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726409AbgFHTpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 15:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591645501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VaxVZkjnEZYrrPi0S56z9hliQp1tI96IZ+GgYvyZSpw=;
        b=Laiqj9qnVH+qZ1sgtW/qMKNVac8Jz1q5PxhyotbDOezlHUZMAPfQ4q721GiyqhCOkJvBFx
        VxaG1etUd6A7Obb3vfzXW7K8uMjhHPHqZsfBEFeuP025E3dmEuJOumJSWa4zvllZXM95Sa
        XW1UD5xKL3J2XiHGWpnLJ/FvyvIfo0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-nq1Dq9QyM06uvBumsB0RcQ-1; Mon, 08 Jun 2020 15:44:46 -0400
X-MC-Unique: nq1Dq9QyM06uvBumsB0RcQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C517918FE860;
        Mon,  8 Jun 2020 19:44:44 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 715E1768B4;
        Mon,  8 Jun 2020 19:44:39 +0000 (UTC)
Date:   Mon, 8 Jun 2020 21:44:37 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH bpf 1/3] bpf: syscall to start at file-descriptor 1
Message-ID: <20200608214437.5f7766ab@carbon>
In-Reply-To: <CAEf4BzagW8GFfybMf10yorwTA+fpiuZHqT41Uu-vAsRHnZqKRw@mail.gmail.com>
References: <159163498340.1967373.5048584263152085317.stgit@firesoul>
        <159163507753.1967373.62249862728421448.stgit@firesoul>
        <CAEf4BzagW8GFfybMf10yorwTA+fpiuZHqT41Uu-vAsRHnZqKRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Jun 2020 11:36:33 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Mon, Jun 8, 2020 at 9:51 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >
> > This patch change BPF syscall to avoid returning file descriptor value zero.
> >
> > As mentioned in cover letter, it is very impractical when extending kABI
> > that the file-descriptor value 'zero' is valid, as this requires new fields
> > must be initialised as minus-1. First step is to change the kernel such that
> > BPF-syscall simply doesn't return value zero as a FD number.
> >
> > This patch achieves this by similar code to anon_inode_getfd(), with the
> > exception of getting unused FD starting from 1. The kernel already supports
> > starting from a specific FD value, as this is used by f_dupfd(). It seems
> > simpler to replicate part of anon_inode_getfd() code and use this start from
> > offset feature, instead of using f_dupfd() handling afterwards.  
> 
> Wouldn't it be better to just handle that on libbpf side? That way it
> works on all kernels and doesn't require this duplication of logic
> inside kernel?

IMHO this is needed on the kernel side, to pair it with the API change.
I don't see how doing this in libbpf can cover all cases.

First of all, some users might not be using libbpf.

Second, a userspace application could be using an older version of
libbpf on a newer kernel. (Notice this is not only due to older
distros, but also because projects using git submodule libbpf will
freeze at some point in time that worked).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

