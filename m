Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE0250EEC2
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 04:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbiDZCck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 22:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbiDZCcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 22:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E567D113C90
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650940173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9v0IAPbJqvO9CVmyKEgTAC/CsgjTQQKmLXagV0w2E94=;
        b=SSsy7wg6QvMkfqPjJi9L1gOvRspfU62l31UBEJJf1995vmHfO+qIh0yAZWCEehoblUKFmn
        bUQSMIFekKpCK5H1YhwvHUTMRQHMC2EiMcMJ9NgW01aKIU+LuU2TU1bf5O5avJlC6lu0c/
        RQ6w6+MSfME5j42s4WVM2m/lIaSaw4M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-0QeWDT_QN3u-NXAPl0MZXA-1; Mon, 25 Apr 2022 22:29:29 -0400
X-MC-Unique: 0QeWDT_QN3u-NXAPl0MZXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D29D803D77;
        Tue, 26 Apr 2022 02:29:29 +0000 (UTC)
Received: from Laptop-X1 (ovpn-13-51.pek2.redhat.com [10.72.13.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 16B5E111DCFE;
        Tue, 26 Apr 2022 02:29:14 +0000 (UTC)
Date:   Tue, 26 Apr 2022 10:29:09 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        toke@redhat.com, Paul Chaignon <paul@isovalent.com>
Subject: Re: [PATCH iproute2-next 1/3] libbpf: Use bpf_object__load instead
 of bpf_object__load_xattr
Message-ID: <YmdY9dLilPrHxz3Y@Laptop-X1>
References: <20220423152300.16201-1-dsahern@kernel.org>
 <20220423152300.16201-2-dsahern@kernel.org>
 <YmSuaX7MUIqoNbC3@Laptop-X1>
 <cde7f66a-7a23-0d98-d5fe-04ecc8cd5f6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cde7f66a-7a23-0d98-d5fe-04ecc8cd5f6b@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 10:10:44AM -0600, David Ahern wrote:
> On 4/23/22 7:56 PM, Hangbin Liu wrote:
> > Hi David,
> > 
> > This patch revert c04e45d0 lib/bpf: fix verbose flag when using libbpf,
> > Should we set prog->log_level directly before it loaded, like
> > bpf_program__set_log_level() does?
> > 
> 
> that API is new - Dec 2021 so it will not be present across relevant
> libbpf versions. Detecting what exists in a libbpf version and adding
> compat wrappers needs to be added. That's an undertaking I do not have
> time for at the moment. If you or someone else does it would be appreciated.
> 
Ah, yes, I forgot we can't set prog log_level directly. Looks we need to
add a new flag similar with HAVE_LIBBPF_SECTION_NAME... It's really a pain to
add more flags for libbfp...

Hi Paul, will you do that?

Thanks
Hangbin

