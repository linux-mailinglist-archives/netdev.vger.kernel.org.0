Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CAA6C925F
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 06:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjCZEgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 00:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjCZEgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 00:36:15 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0A1B773;
        Sat, 25 Mar 2023 21:36:13 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 0C17C761B92;
        Sun, 26 Mar 2023 04:36:13 +0000 (UTC)
Received: from pdx1-sub0-mail-a273.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 5C59F761D2C;
        Sun, 26 Mar 2023 04:36:12 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1679805372; a=rsa-sha256;
        cv=none;
        b=Z1XY2e0fXB7Odtdy1D6F8wbv40N6lCvvGmLTmhiMYsYOdAVOLF4vJ3zSZxT2BRAZd39eAL
        0aGtURZg+Tu6QKepNgf3YWDTqBXuTymoU1t1znx2IpApRrwdvCK8LFso7b7ytYL4aPgHcM
        iSm6NhPrvctUIBchg7fKHHEt1I6012FlU3z6/qxInL2CvOJZL7Ja/YFV2azw1aPF9NimOi
        eNXtEBpI147pAB4scBTfGD4U1UE3tbfVuKuX3KOdYI5jxDnL6mU6fKZ+MJHVk8nGfINHuK
        OtJyhQY+rNqp7hu1X2FhWEv2IWYgvpXetgGlUnSB7OWNEmd0+7HB9mBzGw8feA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1679805372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=1pX8gwcaIUB5yImkwENM3ThgXU4Y2X6MHgVGLJ9iLL4=;
        b=mJ0XBpQ6gTHXAjDhzySdRhb5P4U8OXAbU4AHqpL6+i7TbEzggY0CV/hmR8gUEMeX3Ix9/u
        slXah6wzuQONOVdg6pwfiyH9ceBziDhGpBEJGVyis6XjKES2KSMMx6lHoyfNjAS1k3OQPW
        gloM1g+GcoW1sLSjenr8Q3xbmE7SwdljUAGxrqU7GXN+EjulL63cEYwHyefaOm+9A7OhSW
        YJXh31kifsQKBg5GA+pVN2m/6wzCtQ+DluzOZmu0ub40VScWsGDELVch29RTH0VlZzvyuj
        Wv9WmY6KzHNxlC9ApJHUrXVz0RnUs/lEgVAocCC9Z0kohi6rQeIuuFZ+TcWBUQ==
ARC-Authentication-Results: i=1;
        rspamd-6bb57cb6b4-slwh7;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Turn-Tank: 6bfce2c57200325b_1679805372833_4213685303
X-MC-Loop-Signature: 1679805372833:2292242587
X-MC-Ingress-Time: 1679805372833
Received: from pdx1-sub0-mail-a273.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.126.30.44 (trex/6.7.2);
        Sun, 26 Mar 2023 04:36:12 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a273.dreamhost.com (Postfix) with ESMTPSA id 4PkjnR38Ncz2p;
        Sat, 25 Mar 2023 21:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1679805372;
        bh=1pX8gwcaIUB5yImkwENM3ThgXU4Y2X6MHgVGLJ9iLL4=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=gQcJYiMa7Wfn+4cuYaFdEkjmZwSggzTIh7HDqGIkCPWjLOO/IE+3qFBpkmqTh250w
         A3+rZIjxwUbJLkBxFY797GbLbktz5nYyUtC1//XsPTChjhwFqhIDIO4YgSloioH9Tp
         jAZuLcImGDs+gxgGXVb8EhRRi5U33tMBnAiARuDbBr2vUQtfIDEVokvlJjVk8Zq9lL
         h5rb9PIMSW/0P/DA9Q0HscWmWzrsezapidCHz4whVHv1VYAd8URDwPHM6UNQQPg+3A
         bntJqnNfuLYSGW3L0x0WKTRdAUpJy9sYhpSe/00n0S5LAUmmesWCAdDmL25iWq3Ho8
         MlgDJKUJWqIcA==
Date:   Sat, 25 Mar 2023 21:06:05 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v6] epoll: use refcount to reduce ep_mutex contention
Message-ID: <20230326040605.qmnu7zi2qx6glfy2@offworld>
References: <4a57788dcaf28f5eb4f8dfddcc3a8b172a7357bb.1679504153.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4a57788dcaf28f5eb4f8dfddcc3a8b172a7357bb.1679504153.git.pabeni@redhat.com>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023, Paolo Abeni wrote:

>We are observing huge contention on the epmutex during an http
>connection/rate test:
>
> 83.17% 0.25%  nginx            [kernel.kallsyms]         [k] entry_SYSCALL_64_after_hwframe
>[...]
>           |--66.96%--__fput
>                      |--60.04%--eventpoll_release_file
>                                 |--58.41%--__mutex_lock.isra.6
>                                           |--56.56%--osq_lock
>
>The application is multi-threaded, creates a new epoll entry for
>each incoming connection, and does not delete it before the
>connection shutdown - that is, before the connection's fd close().
>
>Many different threads compete frequently for the epmutex lock,
>affecting the overall performance.
>
>To reduce the contention this patch introduces explicit reference counting
>for the eventpoll struct. Each registered event acquires a reference,
>and references are released at ep_remove() time.
>
>The eventpoll struct is released by whoever - among EP file close() and
>and the monitored file close() drops its last reference.
>
>Additionally, this introduces a new 'dying' flag to prevent races between
>the EP file close() and the monitored file close().
>ep_eventpoll_release() marks, under f_lock spinlock, each epitem as dying
>before removing it, while EP file close() does not touch dying epitems.
>
>The above is needed as both close operations could run concurrently and
>drop the EP reference acquired via the epitem entry. Without the above
>flag, the monitored file close() could reach the EP struct via the epitem
>list while the epitem is still listed and then try to put it after its
>disposal.
>
>An alternative could be avoiding touching the references acquired via
>the epitems at EP file close() time, but that could leave the EP struct
>alive for potentially unlimited time after EP file close(), with nasty
>side effects.
>
>With all the above in place, we can drop the epmutex usage at disposal time.
>
>Overall this produces a significant performance improvement in the
>mentioned connection/rate scenario: the mutex operations disappear from
>the topmost offenders in the perf report, and the measured connections/rate
>grows by ~60%.

Nice, and now just a single nested use-case for the global lock. It should
probably renamed to 'epnested_mutex'.

>To make the change more readable this additionally renames ep_free() to
>ep_clear_and_put(), and moves the actual memory cleanup in a separate
>ep_free() helper.
>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
