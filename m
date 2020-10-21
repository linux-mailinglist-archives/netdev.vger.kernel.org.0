Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16829511C
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 18:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503173AbgJUQtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 12:49:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503157AbgJUQtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 12:49:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603298986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EBKIX4NScpYanL37LvbZAWmxt6PXSYIFIAOMsAhRQoo=;
        b=eoPI6/Z2mGJhytO/cdFMkzjpJDVgwv6gH8Y498gWOwS6YdaDSTJ/VslOUNeSy1RK1SvN8G
        7V6CmAnL98aic+Q0Gi65bXg4pPCYrGamRBsqyY3SpRWb0L3UUDklIe+Wt5bbJbgh28wCnv
        OMv9vCSfwa5jdJzdSacxqK4KOAqwTHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-IGvRjFQzPdiBi1AylCyuRA-1; Wed, 21 Oct 2020 12:49:39 -0400
X-MC-Unique: IGvRjFQzPdiBi1AylCyuRA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A50B5F9C1;
        Wed, 21 Oct 2020 16:49:37 +0000 (UTC)
Received: from x2.localnet (ovpn-117-184.rdu2.redhat.com [10.10.117.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 406B6389;
        Wed, 21 Oct 2020 16:49:26 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>, linux-audit@redhat.com
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V9 05/13] audit: log container info of syscalls
Date:   Wed, 21 Oct 2020 12:49:25 -0400
Message-ID: <2174083.ElGaqSPkdT@x2>
Organization: Red Hat
In-Reply-To: <20201021163926.GA3929765@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com> <20201002195231.GH2882171@madcap2.tricolour.ca> <20201021163926.GA3929765@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, October 21, 2020 12:39:26 PM EDT Richard Guy Briggs wrote:
> > I think I have a way to generate a signal to multiple targets in one
> > syscall...  The added challenge is to also give those targets different
> > audit container identifiers.
> 
> Here is an exmple I was able to generate after updating the testsuite
> script to include a signalling example of a nested audit container
> identifier:
> 
> ----
> type=PROCTITLE msg=audit(2020-10-21 10:31:16.655:6731) :
> proctitle=/usr/bin/perl -w containerid/test type=CONTAINER_ID
> msg=audit(2020-10-21 10:31:16.655:6731) :
> contid=7129731255799087104^3333941723245477888 type=OBJ_PID
> msg=audit(2020-10-21 10:31:16.655:6731) : opid=115583 oauid=root ouid=root
> oses=1 obj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> ocomm=perl type=CONTAINER_ID msg=audit(2020-10-21 10:31:16.655:6731) :
> contid=3333941723245477888 type=OBJ_PID msg=audit(2020-10-21
> 10:31:16.655:6731) : opid=115580 oauid=root ouid=root oses=1
> obj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 ocomm=perl
> type=CONTAINER_ID msg=audit(2020-10-21 10:31:16.655:6731) :
> contid=8098399240850112512^3333941723245477888 type=OBJ_PID
> msg=audit(2020-10-21 10:31:16.655:6731) : opid=115582 oauid=root ouid=root
> oses=1 obj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> ocomm=perl type=SYSCALL msg=audit(2020-10-21 10:31:16.655:6731) :
> arch=x86_64 syscall=kill success=yes exit=0 a0=0xfffe3c84 a1=SIGTERM
> a2=0x4d524554 a3=0x0 items=0 ppid=115564 pid=115567 auid=root uid=root
> gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root
> tty=ttyS0 ses=1 comm=perl exe=/usr/bin/perl
> subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> key=testsuite-1603290671-AcLtUulY ----
> 
> There are three CONTAINER_ID records which need some way of associating
> with OBJ_PID records.  An additional CONTAINER_ID record would be present
> if the killing process itself had an audit container identifier.  I think
> the most obvious way to connect them is with a pid= field in the
> CONTAINER_ID record.

pid is the process sending the signal, opid is the process receiving the 
signal. I think you mean opid?

-Steve


