Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A541F3760
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 11:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgFIJz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 05:55:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38619 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728522AbgFIJz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 05:55:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591696525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8fFbCsU1oSPk2DqSBeHz33w2HQ4HTjTHQAGGZ09Klps=;
        b=hS8268edcJphAsV4Jk0gX2jYsWkZZ3b7WxgGG3OYY2h6j0SfaXqnlCZstr1IA5fiEY7KDm
        lJia/8XOyrnfYznfqF2fU9EyoAGTwb9s9Wo9F442fDhHiZiPu+sVYz+988j5o9J/npFa1c
        xS/hvb3+UK2xSTRLKPIMO2KlZXna5sI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-LrN1mwcBP5yToYNUaMAEOQ-1; Tue, 09 Jun 2020 05:55:22 -0400
X-MC-Unique: LrN1mwcBP5yToYNUaMAEOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0EBA461;
        Tue,  9 Jun 2020 09:55:20 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A1E02B580;
        Tue,  9 Jun 2020 09:55:15 +0000 (UTC)
Date:   Tue, 9 Jun 2020 11:55:13 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH bpf 0/3] bpf: avoid using/returning file descriptor
 value zero
Message-ID: <20200609115513.2422b53a@carbon>
In-Reply-To: <20200609013410.5ktyuzlqu5xpbp4a@ast-mbp.dhcp.thefacebook.com>
References: <159163498340.1967373.5048584263152085317.stgit@firesoul>
        <20200609013410.5ktyuzlqu5xpbp4a@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Jun 2020 18:34:10 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Mon, Jun 08, 2020 at 06:51:12PM +0200, Jesper Dangaard Brouer wrote:
> > Make it easier to handle UAPI/kABI extensions by avoid BPF using/returning
> > file descriptor value zero. Use this in recent devmap extension to keep
> > older applications compatible with newer kernels.
> > 
> > For special type maps (e.g. devmap and cpumap) the map-value data-layout is
> > a configuration interface. This is a kernel Application Binary Interface
> > (kABI) that can only be tail extended. Thus, new members (and thus features)
> > can only be added to the end of this structure, and the kernel uses the
> > map->value_size from userspace to determine feature set 'version'.  
> 
> please drop these kabi references. As far as I know kabi is a redhat invention
> and I'm not even sure what exactly it means.
> 'struct bpf_devmap_val' is uapi. No need to invent new names for existing concept.

Sure I can call it UAPI.

I was alluding to the difference between API and ABI, but it doesn't matter.
For the record, Red Hat didn't invent ABI (Application Binary Interface):
 https://en.wikipedia.org/wiki/Application_binary_interface


> > The recent extension of devmap with a bpf_prog.fd requires end-user to
> > supply the file-descriptor value minus-1 to communicate that the features
> > isn't used. This isn't compatible with the described kABI extension model.  
> 
> non-zero prog_fd requirement exists already in bpf syscall. It's not recent.
> So I don't think patch 1 is appropriate at this point. Certainly not
> for bpf tree. We can argue about it usefulness when bpf-next reopens.
> For now I think patches 2 and 3 are good to go.

Great.

> Don't delete 'enum sk_action' in patch 2 though.

Sorry, yes, that was a mistake.

> The rest looks good to me.

Thanks!
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

