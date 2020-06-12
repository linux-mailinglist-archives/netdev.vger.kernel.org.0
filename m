Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2288A1F77A1
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 14:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgFLMFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 08:05:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32420 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725886AbgFLMFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 08:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591963534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5ghH5RlSs+XTEgRPgodo5nKXtKIcrVv1ZEvWgXN4nQ=;
        b=fAIvdC4dDGoszPen43mm1Cr0mXb/uY9EYHCZgAP1eBntn8bi5QQ8EtkLjYP2eOKKYrOicM
        QeGgj/PrC7bWvU3Mu1tnvmEUcGpc3Nx6VAu+ZBcKg/fDhENxHVbDe1VMVjYWo2IkSSQ7Cg
        Tcl3NNbpHXOsC4/o1spkgysAeKZeVMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-cktZo0nPMsej_p0D-mUS3A-1; Fri, 12 Jun 2020 08:05:31 -0400
X-MC-Unique: cktZo0nPMsej_p0D-mUS3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 504628015CE;
        Fri, 12 Jun 2020 12:05:29 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25E945D9C5;
        Fri, 12 Jun 2020 12:05:23 +0000 (UTC)
Date:   Fri, 12 Jun 2020 14:05:20 +0200
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Joe Perches <joe@perches.com>
Cc:     Gaurav Singh <gaurav1086@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP (eXpress Data Path)" <netdev@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xdp_rxq_info_user: Replace malloc/memset w/calloc
Message-ID: <20200612140520.1e3c0461@carbon>
In-Reply-To: <427be84b1154978342ef861f1f4634c914d03a94.camel@perches.com>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
        <20200612003640.16248-1-gaurav1086@gmail.com>
        <20200612084244.4ab4f6c6@carbon>
        <427be84b1154978342ef861f1f4634c914d03a94.camel@perches.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jun 2020 03:14:58 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2020-06-12 at 08:42 +0200, Jesper Dangaard Brouer wrote:
> > On Thu, 11 Jun 2020 20:36:40 -0400
> > Gaurav Singh <gaurav1086@gmail.com> wrote:
> >   
> > > Replace malloc/memset with calloc
> > > 
> > > Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
> > > Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>  
> > 
> > Above is the correct use of Fixes + Signed-off-by.
> > 
> > Now you need to update/improve the description, to also
> > mention/describe that this also solves the bug you found.  
> 
> This is not a fix, it's a conversion of one
> correct code to a shorter one.

Read the code again Joe.  There is a bug in the code that gets removed,
as it runs memset on the memory before checking if it was NULL.

IHMO this proves why is it is necessary to mention in the commit
message, as you didn't notice the bug in your code review.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

