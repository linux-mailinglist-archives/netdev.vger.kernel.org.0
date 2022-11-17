Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB2C62DA12
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbiKQMAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbiKQMAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:00:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1BA5A6CF
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668686386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NPf1RG+wCb7clBGA38jNh+ZPSc1moikSLN57Kq5O9Bs=;
        b=JMAtntRjnxMtnUJJQV7M9yIMeXMcTwtIYAGlSnl1yKnH6xlze0J6b5wr+Z+5m7qNMj/2Mb
        gZCfO8JKjPk0IOnHL87DSihG5AWPTXnpXFFd0klORBYtyy+/VXEunJrinPZhxMdF5GTRLP
        2os8J6sc+7O9UAzOKwcE8w4A6SDVG4U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-qbEPj9JGO7ylkfBZD0NLwQ-1; Thu, 17 Nov 2022 06:59:37 -0500
X-MC-Unique: qbEPj9JGO7ylkfBZD0NLwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DB52811E67;
        Thu, 17 Nov 2022 11:59:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40CB6111E3ED;
        Thu, 17 Nov 2022 11:59:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y3YOUQM/ldDe/sgC@kadam>
References: <Y3YOUQM/ldDe/sgC@kadam> <Y3XmQsOFwTHUBSLU@kili> <3475095.1668678264@warthog.procyon.org.uk>
To:     Dan Carpenter <error27@gmail.com>
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: uninitialized variable in rxrpc_send_ack_packet()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3708247.1668686372.1@warthog.procyon.org.uk>
Date:   Thu, 17 Nov 2022 11:59:32 +0000
Message-ID: <3708248.1668686372@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

> We disabled GCC's check for uninitialized variables.  It could be that
> you have the .config to automatically zero out stack variables.
> 
> CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
> CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
> CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y

Ah.  Is there a way to reenable that?

David

