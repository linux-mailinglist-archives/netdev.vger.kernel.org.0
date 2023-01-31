Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3785683785
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjAaU1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjAaU1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:27:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4215B577DE
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 12:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675196804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JGQLmRPbVeAXgpk4TPKrjhZA0elvU1IJn7EqtLM+wbE=;
        b=Khe9s5Rmh9BN4w5UBcnSLpbQxYGFs0BO2VsR7tT/gCz1hrA2yvsNBHEhX7oae5d3x/KYxS
        j6yst3vZSWuLH3LMC01yebj0ecKPvUsxfos54Ztt+KvNxoY47fwIDwDOKIFevEdUI8ozun
        P1MowMRvcCdwwAnBGhGUS5X4ws1OPyk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-agK39m-bMR6C61g_E44JDw-1; Tue, 31 Jan 2023 15:26:40 -0500
X-MC-Unique: agK39m-bMR6C61g_E44JDw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8E223C0E20C;
        Tue, 31 Jan 2023 20:26:39 +0000 (UTC)
Received: from [172.16.176.1] (unknown [10.22.50.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B7EC492B01;
        Tue, 31 Jan 2023 20:26:38 +0000 (UTC)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        hare@suse.com, David Howells <dhowells@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>, jmeneghi@redhat.com,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Date:   Tue, 31 Jan 2023 15:26:36 -0500
Message-ID: <3E3F4884-A149-481C-9D5D-663498F34D74@redhat.com>
In-Reply-To: <7CF65B71-E818-4A17-AE07-ABBEA745DBF0@oracle.com>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
 <860B3B8A-1322-478E-8BF9-C5A3444227F7@oracle.com>
 <20230130203526.52738cba@kernel.org>
 <9B7B66AA-E885-4317-8FE7-C9ABC94E027C@oracle.com>
 <20230131113029.7647e475@kernel.org>
 <7CF65B71-E818-4A17-AE07-ABBEA745DBF0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31 Jan 2023, at 14:34, Chuck Lever III wrote:

>> On Jan 31, 2023, at 2:30 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>>
>>> On Tue, 31 Jan 2023 15:18:02 +0000 Chuck Lever III wrote:
>>> And, do you have a preferred mechanism or code sample for
>>> installing a socket descriptor?
>>
>> I must admit - I don't.
>
> As part of responding to the handshake daemon's netlink call,
> I'm thinking of doing something like:
>
> get_unused_fd_flags(), then sock_alloc_file(), and then fd_install()

It seems odd to me that we're not taking advantage of request_key() to do
this work.  It was designed for exactly this problem: the kernel needs
something/work (a tls handhsake) from/done in userspace.

I have a working implementation here:
https://github.com/bcodding/linux/tree/tls_keys

Perhaps there's no interest because no one likes call_usermode_helper(),
which cannot figure out what set of namespace(s) to use, but there's a
solution for that as well: keyagents can represent a running process to
satisfy request_key().
https://lore.kernel.org/linux-nfs/cover.1657624639.git.bcodding@redhat.com/

Keyagents are not required to simply pass socket fds to userspace, however
they do create a flexible way for containers to specify exactly where the
kernel should send various key requests.

I am happy to continue to explain how these approaches work, though I would
also much prefer to see us doing handshakes in-kernel.

Ben

