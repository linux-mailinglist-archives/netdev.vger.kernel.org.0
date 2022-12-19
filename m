Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6306505DF
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 01:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiLSAVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 19:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiLSAU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 19:20:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B00B4AA
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 16:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671409212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bO0al5IyNGuGxF/jB0VxxHL7mf3PAKHAnthDgtMoOzk=;
        b=SM1qToN6hjk9ZgJiEpjkkVulLELSE74W9e3X2ejpk1dRziwnGjmpheINbfhDIm+VKu1aht
        haZ9p5i2E76Qp4o1MOgF/0I8WRTukmGcBysTdef7MSl0uBw639Rgscp5sG12geGKCJLthS
        TGvHFbU7v0fk5nnnLiEkNjvLEf46bZ8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-baBNUf38M4C_DVxz3rfWUQ-1; Sun, 18 Dec 2022 19:20:08 -0500
X-MC-Unique: baBNUf38M4C_DVxz3rfWUQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A5783C0D861;
        Mon, 19 Dec 2022 00:20:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8025E1400E44;
        Mon, 19 Dec 2022 00:20:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20221218120951.1212-1-hdanton@sina.com>
References: <20221218120951.1212-1-hdanton@sina.com> <20221216001958.1149-1-hdanton@sina.com> <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 7/9] rxrpc: Fix I/O thread stop
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1017323.1671409205.1@warthog.procyon.org.uk>
Date:   Mon, 19 Dec 2022 00:20:05 +0000
Message-ID: <1017324.1671409205@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:

> > So once we've observed that we've been asked to stop, we need to check if
> > there's more work to be done and, if so, do that work first.
> 
> In line with
> 
> 	if (condition)
> 		return;
> 	add to wait queue
> 	if (!condition)
> 		schedule();
> 
> this change should look like
> 
>    		if (!skb_queue_empty(&local->rx_queue) ...)
>  			continue;
> 
>  		if (kthread_should_stop())
>    			if (!skb_queue_empty(&local->rx_queue) ...)
>  				continue;
> 			else
>   				break;
> 
> as checking condition once barely makes sense.

Note that these are not really analogous.  The add-to-wait-queue step is
significantly more expensive than kthread_should_stop() and requires removal
in the event that the condition becomes true in the window.

In the case of kthread_should_stop(), it's just a test_bit() of a word that's
in a cacheline not going to get changed until the thread is stopped.  Testing
the value first and then checking the condition should be fine as the stop
flag can be shared in the cpu's data cache until it's set.

Also from a code-maintenance PoV, I don't want to write the condition twice if
I can avoid it.  That allows for the two copies to get out of sync.

> Because of a bit complex condition does not mean checking it once is neither
> sane nor correct.

So you agree with me, I think?

David

