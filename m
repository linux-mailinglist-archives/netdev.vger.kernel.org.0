Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A57F2034AD
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgFVKTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:19:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35660 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726853AbgFVKTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592821139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hhx2/dKVX3sYoJHRc0UNtjJeMWtsunceOpFQydeky9g=;
        b=g/mgi4fvYjI6CEJCq/65btmwKrJXsL3hQF9Zpi/aRu8N71SHE2ozPitmB2/fkc4MFpJxTN
        WvIMofzwPqpWLfj1yVuw9H6X+HR6su0IvWE+PgMvT52C6eLRUZrpSKCTgGimfi2VsSe/LK
        PFVZSKcAeExSV+O8dzIlxJYKVBD4Hqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-yxXM4gCnN6qrPx4XoFPRTA-1; Mon, 22 Jun 2020 06:18:55 -0400
X-MC-Unique: yxXM4gCnN6qrPx4XoFPRTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1C4718A8221;
        Mon, 22 Jun 2020 10:18:54 +0000 (UTC)
Received: from ovpn-113-146.ams2.redhat.com (ovpn-113-146.ams2.redhat.com [10.36.113.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 982167166E;
        Mon, 22 Jun 2020 10:18:53 +0000 (UTC)
Message-ID: <07e0f81138421beee347c362dce61f78dd8bf00c.camel@redhat.com>
Subject: Re: sock diag uAPI and MPTCP
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Mon, 22 Jun 2020 12:18:52 +0200
In-Reply-To: <20200620.174408.1728600398443363480.davem@davemloft.net>
References: <c5b53444ca4c79b887629c93d954dadbc4a777da.camel@redhat.com>
         <20200620.174408.1728600398443363480.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-06-20 at 17:44 -0700, David Miller wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Fri, 19 Jun 2020 12:54:40 +0200
> 
> > IPPROTO_MPTCP value (0x106) can't be represented using the current sock
> > diag uAPI, as the 'sdiag_protocol' field is 8 bits wide.
> > 
> > To implement diag support for MPTCP socket, we will likely need a
> > 'inet_diag_req_v3' with a wider 'sdiag_protocol'
> > field. inet_diag_handler_cmd() could detect the version of
> > the inet_diag_req_v* provided by user-space checking nlmsg_len() and
> > convert _v2 reqs to _v3.
> > 
> > This change will be a bit invasive, as all in kernel diag users will
> > then operate only on 'inet_diag_req_v3' (many functions' signature
> > change required), but the code-related changes will be encapsulated
> > by inet_diag_handler_cmd().
> 
> Another way to extend the size of a field is to add an attribute which
> supercedes the header structure field when present.
> 
> We did this when we needed to make the fib rule table ID number larger,
> see FRA_TABLE.
> 
> You'd only need to specify this when using protocol values larger than
> 8 bits in size.

Thank you very much for the directions! This looks like a better, more
encapsulated solution. I'll try to give it a shot.

Thanks!

Paolo

