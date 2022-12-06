Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734376449BE
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbiLFQxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiLFQxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:53:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1211F223
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670345530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XIpckjVarsXSQqROHjIV5YMQ3njKr27YAdfHQ1eBWXM=;
        b=KX9dt6fDrs5SJBb84CQSYzFmFhrM2k6g5IqxaIWVVdAlQ8ommRQp7ziUaVlLS6GB/jHw77
        Mpx9PreddKJCkjw9omz6/kXiNihynjk3EKq3bwGEXeaYW++vLOej6ou+1afSjSWLwRZ+ax
        XnKEGe4MIyeQXBIn0B8PM9ViOtxUQU0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-524-kInnQFAqNeixUH4izlJ4hw-1; Tue, 06 Dec 2022 11:52:01 -0500
X-MC-Unique: kInnQFAqNeixUH4izlJ4hw-1
Received: by mail-wm1-f71.google.com with SMTP id c1-20020a7bc001000000b003cfe40fca79so5864467wmb.6
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:52:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XIpckjVarsXSQqROHjIV5YMQ3njKr27YAdfHQ1eBWXM=;
        b=T94g14yiL4dOwiKTX5hfdqaT4rTYwZcrXXmzgMDUMRAdNDvm7DaErAGPrGeVqOM/2Z
         us8UAvXBKhHQ4Obiq8ttY0wPAUqqqbhDmqaGwuhvSSAauWNdKgej68OAxDRH+rgHC8p1
         fPLStUBPN2oEN8uFZAJvVG6tRQABH5Cwzn5IUTo9BJMHE75xQOIC1i7fzxLrgyaMnkDL
         rWPlnc66CB8nviE75shOD+JuUsKWkZYG7eILtyi1dgzgZSocIw/rV2GRnNmaFtgjC2TV
         49eJhb2p1Ss+9twJfd/z+ua2cpVDYq6RGMHqywiXUt2AtkeypxMsFCYp0Z2v7APRKorW
         Lcdw==
X-Gm-Message-State: ANoB5pkPEb3JjxkQ5rXR1iTkHpZ9aYZOm1zf59pGZqUF8/sImDLow44r
        JTyqBFmq07OVZbN+hT8VW8SwggqgNG5+5TUNpRKj+OltMltNFL1Lw2hSbE7fz1oa1/WaLUISIe9
        iTusFOASywRYklNT3
X-Received: by 2002:adf:ebc6:0:b0:241:c6d8:be83 with SMTP id v6-20020adfebc6000000b00241c6d8be83mr46196224wrn.454.1670345519817;
        Tue, 06 Dec 2022 08:51:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf60dqg/J7gSlr8BiWptFPCbF1mq7Dzc0r47+I6tQYq+KjcdkixAhM+jx7p9yL/Kn4RX5L/gMA==
X-Received: by 2002:adf:ebc6:0:b0:241:c6d8:be83 with SMTP id v6-20020adfebc6000000b00241c6d8be83mr46196208wrn.454.1670345519570;
        Tue, 06 Dec 2022 08:51:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id f6-20020a0560001b0600b002415dd45320sm16896783wrz.112.2022.12.06.08.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:51:59 -0800 (PST)
Message-ID: <99550009c78de401d55356721aac56873319b5cc.camel@redhat.com>
Subject: Re: Broken SELinux/LSM labeling with MPTCP and accept(2)
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>, mptcp@lists.linux.dev,
        network dev <netdev@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 06 Dec 2022 17:51:57 +0100
In-Reply-To: <CAFqZXNtOku4vr5RrQU4vcvCVz5iK79CimeUVHu0S=QoN-QVEjg@mail.gmail.com>
References: <CAFqZXNs2LF-OoQBUiiSEyranJUXkPLcCfBkMkwFeM6qEwMKCTw@mail.gmail.com>
         <108a1c80eed41516f85ebb264d0f46f95e86f754.camel@redhat.com>
         <CAHC9VhSSKN5kh9Kqgj=aCeA92bX1mJm1v4_PnRgua86OHUwE3w@mail.gmail.com>
         <48dd1e9b21597c46e4767290e5892c01850a45ff.camel@redhat.com>
         <CAHC9VhT0rRhr7Ty_p3Ld5O+Ltf8a8XSXcyik7tFpDRMrTfsF+A@mail.gmail.com>
         <50e7ea22119c3afcb4be5a4b6ad9747465693d10.camel@redhat.com>
         <CAFqZXNtOku4vr5RrQU4vcvCVz5iK79CimeUVHu0S=QoN-QVEjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-06 at 15:43 +0100, Ondrej Mosnacek wrote:
> On Mon, Dec 5, 2022 at 9:58 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > On Fri, 2022-12-02 at 15:16 -0500, Paul Moore wrote:
> [...]
> > > What if we added a new LSM call in mptcp_subflow_create_socket(), just
> > > after the sock_create_kern() call?
> > 
> > That should work, I think. I would like to propose a (last) attempt
> > that will not need an additional selinux hook - to try to minimize the
> > required changes and avoid unnecessary addional work for current and
> > future LSM mainteniance and creation.
> > 
> > I tested the following patch and passes the reproducer (and mptcp self-
> > tests). Basically it introduces and uses a sock_create_nosec variant,
> > to allow mptcp_subflow_create_socket() calling
> > security_socket_post_create() with the corrct arguments. WDYT?
> 
> This seems like a step in the right direction, but I wonder if we
> shouldn't solve the current overloading of the "kern" flag more
> explicitly - i.e. split it into two flags: one to indicate that the
> socket will only be used internally by the kernel ("internal") and
> another one to indicate if it should be labeled according to the
> current task or as a kernel-created socket ("kern"?). Technically,
> each combination could have a valid use case:
> - !internal && !kern -> a regular userspace-created socket,
> - !internal && kern -> a socket that is exposed to userspace, but
> created by the kernel outside of a syscall (e.g. some global socket
> created during initcall phase and later returned to userspace via an
> ioctl or something),
> - internal && !kern -> our MPTCP case, where the socket itself is
> internal, but the label is still important so it can be passed onto
> its accept-offspring (which may no longer be internal),
> - internal && kern -> a completely kernel-internal socket.

I would say perfect is the enemy of good ;) it would be nice to have a
fix sometime soon, and we can improve as needed.

> Another concern I have about this approach is whether it is possible
> (in some more advanced scenario) for mptcp_subflow_create_socket() to
> be called in the context of a different task than the one
> creating/handling the main socket. Because then a potential socket
> accepted from the new subflow socket would end up with an unexpected
> (and probably semantically wrong) label. Glancing over the call tree,
> it seems it can be called via some netlink commands - presumably
> intended to be used by mptcpd?

Yes, the above can happen, but I think it does not have LSM-related
implications, as subflows created in the above scenario can be MP_JOIN
only - that is, will never be even indirectly exposed to user-space.


Cheers,

Paolo

