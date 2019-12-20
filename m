Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4F5128084
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfLTQV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:21:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28808 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726808AbfLTQV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:21:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576858887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIkguvuZQtE5c36mLB6oxEenExckhELOj2EqPR6boyw=;
        b=iw3iS+Ubftq2YZPPOiWbWsAwaoB2+wav2A0Rlg6Ak0P7l/gbTWBc/kDhCBbTEfp2z3CJf0
        l/JZJPKzc4HoQJUnOfbHP86KWPnhBQfzDViVC+0FdlM3rDhYfzX5grEkjnmBUtA35StItj
        R94YxWbn2sFNdLzlZ8tg9bkdlGOp/YQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-wKLuq1GBM72K3JK2EID-Pg-1; Fri, 20 Dec 2019 11:21:23 -0500
X-MC-Unique: wKLuq1GBM72K3JK2EID-Pg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C8CA800D4E;
        Fri, 20 Dec 2019 16:21:22 +0000 (UTC)
Received: from ovpn-116-246.ams2.redhat.com (ovpn-116-246.ams2.redhat.com [10.36.116.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2063D60BEC;
        Fri, 20 Dec 2019 16:21:20 +0000 (UTC)
Message-ID: <1563cacb2fb2f5c59bedc7a33667586d4c3ec6c5.camel@redhat.com>
Subject: Re: [PATCH net-next v5 05/11] tcp, ulp: Add clone operation to
 tcp_ulp_ops
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Fri, 20 Dec 2019 17:21:19 +0100
In-Reply-To: <de3e37b0-f3ff-c5d0-9a38-890ce04916c7@gmail.com>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
         <20191219223434.19722-6-mathew.j.martineau@linux.intel.com>
         <de3e37b0-f3ff-c5d0-9a38-890ce04916c7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-12-20 at 07:26 -0800, Eric Dumazet wrote:
> 
> On 12/19/19 2:34 PM, Mat Martineau wrote:
> > If ULP is used on a listening socket, icsk_ulp_ops and icsk_ulp_data are
> > copied when the listener is cloned. Sometimes the clone is immediately
> > deleted, which will invoke the release op on the clone and likely
> > corrupt the listening socket's icsk_ulp_data.
> > 
> > The clone operation is invoked immediately after the clone is copied and
> > gives the ULP type an opportunity to set up the clone socket and its
> > icsk_ulp_data.
> > 
> 
> Since the method is void, this means no error can happen.
> 
> For example we do not intend to attempt a memory allocation ?

if the MPTCP ULP clone fails, we fallback to plain TCP (the 'is_mptcp'
flag cleared on the tcp 'struct sock'), so we don't have an error
return code there.

If we change the 'clone' signature, than the only in-kernel user will
always return 0, would that be ok?

Thank you!

Paolo

