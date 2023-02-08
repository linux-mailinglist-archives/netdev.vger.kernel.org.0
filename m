Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C4268F313
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjBHQUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjBHQUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:20:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7534F10EC
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 08:20:50 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 26F1D1FE9A;
        Wed,  8 Feb 2023 16:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675873249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92tqrcXyZ/Tx8f34e9+1GDPLj8k5sRjHk3hRHkNZKao=;
        b=Jx77GrTimZvYMBTkqqYx2ADcgigGrzRbNvXmX5Tr1mUPMOgyEWyqKozeRlNaimUKNVo3hC
        k2jW8WbwxRQjcQF1zkuxvUMo4l/GwVfqsz0sdTfx1+v1Q6slSZY1dHZNU1JxxG0lBEPbci
        Yx3knyXx0tvtwcu6EdB20bySG7wMSTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675873249;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92tqrcXyZ/Tx8f34e9+1GDPLj8k5sRjHk3hRHkNZKao=;
        b=xtmB8cUCnWBQFOC91MHysahdMalKDKg/5+IeKhQKVmeg5egQpJBkbLT0R5y2gXZMF5yg3h
        DTn/HRKHs24iwWCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8BBE31358A;
        Wed,  8 Feb 2023 16:20:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jh3aIN/L42NvVwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 08 Feb 2023 16:20:47 +0000
Message-ID: <1a140441-a9d2-2fca-23df-20f1f4ed0079@suse.de>
Date:   Wed, 8 Feb 2023 17:20:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Content-Language: en-US
To:     Chuck Lever <chuck.lever@oracle.com>, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        bcodding@redhat.com, kolga@netapp.com, jmeneghi@redhat.com
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/23 22:41, Chuck Lever wrote:
> When a kernel consumer needs a transport layer security session, it
> first needs a handshake to negotiate and establish a session. This
> negotiation can be done in user space via one of the several
> existing library implementations, or it can be done in the kernel.
> 
> No in-kernel handshake implementations yet exist. In their absence,
> we add a netlink service akin to NETLINK_ROUTE that can:
> 
> a. Notify a user space daemon that a handshake is needed.
> 
> b. Once notified, the daemon calls the kernel back via this
>     netlink service to get the handshake parameters, including an
>     open socket on which to establish the session.
> 
> The notification service uses a multicast group. Each handshake
> protocol (eg, TLSv1.3, PSP, etc) adopts its own group number so that
> the user space daemons for performing the handshakes are completely
> independent of one another. The kernel can then tell via
> netlink_has_listeners() whether a user space daemon is active and
> can handle a handshake request for the desired security layer
> protocol.
> 
> A new netlink operation, ACCEPT, acts like accept(2) in that it
> instantiates a file descriptor in the user space daemon's fd table.
> If this operation is successful, the reply carries the fd number,
> which can be treated as an open and ready file descriptor.
> 
> While user space is performing the handshake, the kernel keeps its
> muddy paws off the open socket. The act of closing the user space
> file descriptor alerts the kernel that the open socket is safe to
> use again. When the user daemon completes a handshake, the kernel is
> responsible for checking that a valid transport layer security
> session has been established.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>   include/net/handshake.h            |   37 ++++
>   include/net/net_namespace.h        |    1
>   include/net/sock.h                 |    1
>   include/uapi/linux/handshake.h     |   65 +++++++
>   include/uapi/linux/netlink.h       |    1
>   net/Makefile                       |    1
>   net/handshake/Makefile             |   11 +
>   net/handshake/netlink.c            |  320 ++++++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/netlink.h |    1
>   9 files changed, 438 insertions(+)
>   create mode 100644 include/net/handshake.h
>   create mode 100644 include/uapi/linux/handshake.h
>   create mode 100644 net/handshake/Makefile
>   create mode 100644 net/handshake/netlink.c
> 
Looks good on first glance; I'll give it a go on my testbed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

