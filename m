Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B946656B5C7
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 11:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbiGHJjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 05:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbiGHJjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 05:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26FEC65D6F
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 02:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657273150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4UPveqJBbaI6azQGRwsMHikunCUeOc3vlQ7vCa3TUTU=;
        b=KojcNzGJbSTNUjqNBj/dIjWkM3fkEfLy5q1lVE/BFwknXQNNAnxYCN4rsvpl/shu0BIXVa
        TpfVjRSI2J3SVqtwihQKPDWxOMJtdkrMXxpdcgEg4O2ViFHm36EY/jhOSQFr2yL4SVTj8l
        fBVzsPlg8syo4LdBSASudYWuRU+NDg0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-TcUMHTKGPkWRjjBANTXw8A-1; Fri, 08 Jul 2022 05:39:07 -0400
X-MC-Unique: TcUMHTKGPkWRjjBANTXw8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F0428041BE;
        Fri,  8 Jul 2022 09:39:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8A5B1121314;
        Fri,  8 Jul 2022 09:39:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220707182052.769989-1-justinstitt@google.com>
References: <20220707182052.769989-1-justinstitt@google.com> <20220706235648.594609-1-justinstitt@google.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        marc.dionne@auristor.com, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
        trix@redhat.com
Subject: Re: [PATCH v2] net: rxrpc: fix clang -Wformat warning
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1840088.1657273144.1@warthog.procyon.org.uk>
Date:   Fri, 08 Jul 2022 10:39:04 +0100
Message-ID: <1840089.1657273144@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Justin Stitt <justinstitt@google.com> wrote:

> y is a u32 but the format specifier is `%hx`. Going from unsigned int to
> short int results in a loss of data. This is surely not intended
> behavior. If it is intended, the warning should be suppressed through
> other means.

Yeah, y is reduced to a 16-bit number so that it can be used in the protocol,
but the type is still 32-bit because that's needed for the calculation.  An
alternative would be to print sp->hdr.cksum since that's the value that will
appear on the wire, but I've no objection to this change either.

> This patch should get us closer to the goal of enabling the -Wformat
> flag for Clang builds.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Acked-by: David Howells <dhowells@redhat.com>

