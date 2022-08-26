Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3B45A28BB
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 15:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbiHZNjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 09:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiHZNjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 09:39:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FDA1EC60
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 06:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661521189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fAOu6Q9d8+BK41qr2yyldKzFEjX6253oA+dNZQQI2k=;
        b=QhuWXtglWbnL02HC6cdguoc+6Au7DGZ49Tt/8g8ZioVMk4G1By/Y+JTti6hNcfY5FHPgup
        LSWD87JY5TX/7DF3ejMvCv50/cjXqpTdceK7OvX9WX5NKK/3DbVcxNyrPgktA4Rftd2Ixh
        lPA45Kd2pEu+lokQC3bOu3NNEtgto14=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-SRgt7xkfOTa8wj2msvedJA-1; Fri, 26 Aug 2022 09:39:44 -0400
X-MC-Unique: SRgt7xkfOTa8wj2msvedJA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EEF5185A7A4;
        Fri, 26 Aug 2022 13:39:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A19A8492C3B;
        Fri, 26 Aug 2022 13:39:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <2666575.1661519443@warthog.procyon.org.uk>
References: <2666575.1661519443@warthog.procyon.org.uk>
Cc:     dhowells@redhat.com, Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Not getting ICMP reports from the UDP socket in rxrpc
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2764874.1661521182.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 26 Aug 2022 14:39:42 +0100
Message-ID: <2764878.1661521182@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Do you know if ICMP handling has changed inside of ipv4/ipv6?  I've real=
ised
> that though rxrpc tries to get ICMP events, they're not coming through.
> =

> rxrpc_open_socket() does:
> =

> 	usk->sk_error_report =3D rxrpc_error_report;
> =

> to set the error collector and:
> =

> 		ip6_sock_set_recverr(usk);
> 		ip_sock_set_recverr(usk);
> =

> as appropriate to say that it wants to get ICMP messages, but they don't=
 seem
> to come.  I put a printk() into sk_error_report(), but I don't see anyth=
ing
> printed when ICMP messages come in (but I do if I telnet to a random por=
t on
> my test server).

Ah... there's a separate error handling hook (encap_err_lookup) for tunnel=
s.
I guess I need that.  Do you know if only ICMP/ICMP6 messages go through t=
hat
and not other SO_EE_ORIGIN_* types?

David

