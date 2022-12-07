Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9E64593A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiLGLtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLGLs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:48:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FF5100F
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670413672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o5oPDAj17JV2CSqTQ+NSzev8NXDVTqHrEViGfsuVkew=;
        b=V8Joh0h+HZrE5/8GibogrCADHTZJ5BQi5eddVXC812+IcjYtOzeOUcN6BwPpYB5J9o7FxD
        +p5RMxNfniA2WnT7q9KJj1UmMSpMPha+m//ZnRh6v8ClL1gzO+Q3OyiweMDsKdkQnoip/B
        DxGA9JBNR8kgFJOKhtlS9g92AKTBp44=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-KOQaBSfiPW6HBWNPADE4ig-1; Wed, 07 Dec 2022 06:47:49 -0500
X-MC-Unique: KOQaBSfiPW6HBWNPADE4ig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E37E185A79C;
        Wed,  7 Dec 2022 11:47:49 +0000 (UTC)
Received: from [172.16.176.1] (unknown [10.22.50.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81AC940C2064;
        Wed,  7 Dec 2022 11:47:47 +0000 (UTC)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     Anna Schumaker <anna@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH v2] sunrpc: Use GFP_NOFS to prevent use of
 current->task_frag.
Date:   Wed, 07 Dec 2022 06:47:43 -0500
Message-ID: <16B6A2FD-3ED4-40FF-9776-E4BC341139F2@redhat.com>
In-Reply-To: <20221025111525.GA4415@localhost.localdomain>
References: <de6d99321d1dcaa2ad456b92b3680aa77c07a747.1665401788.git.gnault@redhat.com>
 <Y0QyYV1Wyo4vof70@infradead.org>
 <20221010165650.GA3456@ibm-p9z-18-fsp.mgmt.pnr.lab.eng.rdu2.redhat.com>
 <Y0UKq62ByUGNQpuY@infradead.org>
 <20221011150057.GB3606@localhost.localdomain>
 <a0bf0d49a7a69d20cfe007d66586a2649557a30b.camel@kernel.org>
 <20221011211433.GA13385@ibm-p9z-18-fsp.mgmt.pnr.lab.eng.rdu2.redhat.com>
 <20221013121834.GA3353@localhost.localdomain>
 <20221025111525.GA4415@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 Oct 2022, at 7:15, Guillaume Nault wrote:

> On Thu, Oct 13, 2022 at 02:18:37PM +0200, Guillaume Nault wrote:
>> Still, that looks like net-next material to me. Reverting sunrpc to use
>> GFP_NOFS looks better for an immediate bug fix.
>
> Could we please move forward with this patch? This bug really needs to be
> fixed. So please let's either revert to GFP_NOFS or actively work on a
> different solution.

Hey Trond, Anna - I think the right thing to do here is send this patch to
-stable as stable-only while we try to get this fixed up.  Any objections to
that?

Ben

