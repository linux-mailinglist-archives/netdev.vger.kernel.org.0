Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BAF5A283F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 15:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241631AbiHZNKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 09:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiHZNKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 09:10:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB5260500
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 06:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661519447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=L/GvZcbBW9Q/L3AcRPsC5ZrF43Bwx1dLvFYcF5j9tsc=;
        b=HzYtv7jX9ljViyQ3HPE3HXUuY6mV7NRgeMZTGgOf02Kaz93cLCTSz2kMwkalhypNWM7zwc
        HT76qUfTj6Na9jktVkV3j9feL45mnvuJ5RzC+fx00Yz8TAJOHz/ScABQidGtpPv5RmymK9
        caQLqFfJrayjpA2hWXOpZIoUuDY+C3Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-xWtvSjyHMvWLAd9Rz1hQ0w-1; Fri, 26 Aug 2022 09:10:44 -0400
X-MC-Unique: xWtvSjyHMvWLAd9Rz1hQ0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 308DE85A58B;
        Fri, 26 Aug 2022 13:10:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FCD61121314;
        Fri, 26 Aug 2022 13:10:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
cc:     dhowells@redhat.com, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Not getting ICMP reports from the UDP socket in rxrpc
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2666574.1661519443.1@warthog.procyon.org.uk>
Date:   Fri, 26 Aug 2022 14:10:43 +0100
Message-ID: <2666575.1661519443@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Do you know if ICMP handling has changed inside of ipv4/ipv6?  I've realised
that though rxrpc tries to get ICMP events, they're not coming through.

rxrpc_open_socket() does:

	usk->sk_error_report = rxrpc_error_report;

to set the error collector and:

		ip6_sock_set_recverr(usk);
		ip_sock_set_recverr(usk);

as appropriate to say that it wants to get ICMP messages, but they don't seem
to come.  I put a printk() into sk_error_report(), but I don't see anything
printed when ICMP messages come in (but I do if I telnet to a random port on
my test server).

Thanks,
David

