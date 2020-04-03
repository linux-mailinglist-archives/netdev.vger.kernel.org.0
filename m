Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7F319D307
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 11:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390662AbgDCJCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 05:02:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58511 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390647AbgDCJCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 05:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585904540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W/fVozu5ZUY7Dfi/j4fRL9U2+cFmY3+/tPmEmw3C8Io=;
        b=i2RDNf13sXKnFdKn89IdfbVWwCzd1DWBB7d8eqMaDAPibXYux/03WLxTap1pFzDs1ahTMe
        gSBlji+lf49tDTXqGuvduid1Pq1osJPO6OcgF3ggi4+ycrHg+rcrF49VMCypHK8CM45j+W
        yuiw+/zicmZe9eJEUWwWRsoPBzXBOXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-pmRMg2aVOimnUa3sUmOSJw-1; Fri, 03 Apr 2020 05:02:16 -0400
X-MC-Unique: pmRMg2aVOimnUa3sUmOSJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 496A0107ACC4;
        Fri,  3 Apr 2020 09:02:14 +0000 (UTC)
Received: from krava (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 587BB92FAD;
        Fri,  3 Apr 2020 09:02:05 +0000 (UTC)
Date:   Fri, 3 Apr 2020 11:01:58 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Florent Revest <revest@chromium.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/3] bpf: Add d_path helper
Message-ID: <20200403090158.GE2784502@krava>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200401110907.2669564-3-jolsa@kernel.org>
 <2c93a2c75e55291473370d9805f8dd0484acd5a3.camel@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c93a2c75e55291473370d9805f8dd0484acd5a3.camel@chromium.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 04:02:55PM +0200, Florent Revest wrote:
> On Wed, 2020-04-01 at 13:09 +0200, Jiri Olsa wrote:
> > + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> > + *	Description
> > + *		Return full path for given 'struct path' object, which
> > + *		needs to be the kernel BTF 'path' object. The path is
> > + *		returned in buffer provided 'buf' of size 'sz'.
> > + *
> > + *	Return
> > + *		length of returned string on success, or a negative
> > + *		error in case of failure
> > + *
> 
> You might want to add that d_path is ambiguous since it can add
> " (deleted)" at the end of your path and you don't know whether this is
> actually part of the file path or not. :) 

right

> 
> > +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> > +{
> > +	char *p = d_path(path, buf, sz - 1);
> 
> I am curious why you'd use sz - 1 here? In my experience, d_path's
> output is 0 limited so you shouldn't need to keep an extra byte for
> that (if that was the intention here).
> 
> > +	int len;
> > +
> > +	if (IS_ERR(p)) {
> > +		len = PTR_ERR(p);
> > +	} else {
> > +		len = strlen(p);
> > +		if (len && p != buf) {
> > +			memmove(buf, p, len);
> 
> Have you considered returning the offset within buf instead and let the
> BPF program do pointer arithmetics to find the beginning of the string?

we could do that.. I was following some other user of d_path,
which I can't find at the moment ;-) I'll check

> 
> > +			buf[len] = 0;
> 
> If my previous comment about sz - 1 is true, then this wouldn't be
> necessary, you could just use memmove with len + 1.

hum, you might be right, I'll check on this

thanks,
jirka

> 
> > +		}
> > +	}
> > +
> > +	return len;
> > +}
> 

