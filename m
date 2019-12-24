Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DFC12A2A2
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLXOyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:54:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28604 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726171AbfLXOyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 09:54:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577199240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LOrVAni8pNTG3qCvTLIeHwOlj2Xpnx7lR1y1cU8pbNs=;
        b=VobxI1Vp7rMfcycAL9eS7NHrMka1hMHkp/kw0f6/IrseKjY3HFx6zSHtlqeK+0MTQpmMI1
        IJe5rvfh0a+tZQK0ucMWUhPT472xWxXQ1KBeQmV3xgZvfn6GhACPyifcpLnR1yrVmbAx4n
        IevMcYJSyhoR5COq7GOuef+J4FSYnL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-kRTRlfhYM5OUVwcziqymCw-1; Tue, 24 Dec 2019 09:53:58 -0500
X-MC-Unique: kRTRlfhYM5OUVwcziqymCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 324AC107ACC4;
        Tue, 24 Dec 2019 14:53:57 +0000 (UTC)
Received: from ovpn-204-34.brq.redhat.com (ovpn-204-34.brq.redhat.com [10.40.204.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4EDD805FF;
        Tue, 24 Dec 2019 14:53:55 +0000 (UTC)
Message-ID: <49bdcf7998d31d12716c60af0a47414adc76f284.camel@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: add delete_empty() to filters and
 use it in cls_flower
From:   Davide Caratti <dcaratti@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <vbf7e2m2bno.fsf@mellanox.com>
References: <cover.1577179314.git.dcaratti@redhat.com>
         <a59aea617b35657ea22faaafb54a18a4645b3b36.1577179314.git.dcaratti@redhat.com>
         <vbf7e2m2bno.fsf@mellanox.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 24 Dec 2019 15:53:54 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Jamal and Vlad,

thanks for looking at this.

On Tue, 2019-12-24 at 11:48 +0000, Vlad Buslov wrote:
> I guess we can reduce this code to just:
> 
> spin_lock(&tp->lock);
> tp->deleting = idr_is_empty(&head->handle_idr);
> spin_unlock(&tp->lock);

on the current version of delete_empty() for cls_flower, we are assuming
an empty filter also when the IDR is allocated, but its refcount is zero:

1931         idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
1932                 /* don't return filters that are being deleted */
1933                 if (!refcount_inc_not_zero(&f->refcnt))
1934                         continue;
1935                 if (arg->fn(tp, f, arg) < 0) {
1936                         __fl_put(f);
1937                         arg->stop = 1;
1938                         break;
1939                 }
1940                 __fl_put(f);
1941                 arg->count++;
1942         }

but probably this is relevant to dump(), not delete(). Correct?

 # ./tdc.py -c flower -d enp2s0

^^ I'm running several loops of this, just to make sure. If I don't find
anything relevant in few hours, I will send a v2.
thanks!
-- 
davide


