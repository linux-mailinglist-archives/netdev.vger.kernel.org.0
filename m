Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010F56C0AE0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 07:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCTGtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 02:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCTGtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 02:49:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94103126CF
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 23:49:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 966B821B1A;
        Mon, 20 Mar 2023 06:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679294943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dwb6SAQzdh7WC6l8i7j1TEvkQ/bUk9mR0xBMszfRK34=;
        b=qmh4RdPc/jxoLKlufx0nVQkZkd2DcOcJxWmgVsdX3dUBm0I7tb89Eg6/pBCU71kV+TiZbA
        lN75eBJ7gMBuK66n+MpQaC3SIhnYHB64a1t6UK6Ev67TJNCplJROO3oXz68l+QDCXQusNR
        r9WtUkmx/Ubt/pNrnKBU5nJO2lK6cgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679294943;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dwb6SAQzdh7WC6l8i7j1TEvkQ/bUk9mR0xBMszfRK34=;
        b=8iNz11H9DKSfffD1V9cR5wwnf6hR3fvffDddsKGkcHAAv0Q0mRDYGN9Nn2IjMfi6CB5V1K
        0vulFP8RKolFXNBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 62EBD13416;
        Mon, 20 Mar 2023 06:49:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IXEAF98BGGSKIQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 20 Mar 2023 06:49:03 +0000
Message-ID: <535a9fb0-6e87-fce6-4e6a-32250485ccbc@suse.de>
Date:   Mon, 20 Mar 2023 07:49:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Content-Language: en-US
To:     Chuck Lever <cel@kernel.org>, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
 <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/23 17:18, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> When a kernel consumer needs a transport layer security session, it
> first needs a handshake to negotiate and establish a session. This
> negotiation can be done in user space via one of the several
> existing library implementations, or it can be done in the kernel.
> 
> No in-kernel handshake implementations yet exist. In their absence,
> we add a netlink service that can:
> 
> a. Notify a user space daemon that a handshake is needed.
> 
> b. Once notified, the daemon calls the kernel back via this
>     netlink service to get the handshake parameters, including an
>     open socket on which to establish the session.
> 
> c. Once the handshake is complete, the daemon reports the
>     session status and other information via a second netlink
>     operation. This operation marks that it is safe for the
>     kernel to use the open socket and the security session
>     established there.
> 
> The notification service uses a multicast group. Each handshake
> mechanism (eg, tlshd) adopts its own group number so that the
> handshake services are completely independent of one another. The
> kernel can then tell via netlink_has_listeners() whether a handshake
> service is active and prepared to handle a handshake request.
> 
> A new netlink operation, ACCEPT, acts like accept(2) in that it
> instantiates a file descriptor in the user space daemon's fd table.
> If this operation is successful, the reply carries the fd number,
> which can be treated as an open and ready file descriptor.
> 
> While user space is performing the handshake, the kernel keeps its
> muddy paws off the open socket. A second new netlink operation,
> DONE, indicates that the user space daemon is finished with the
> socket and it is safe for the kernel to use again. The operation
> also indicates whether a session was established successfully.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>   Documentation/netlink/specs/handshake.yaml |  122 +++++++++++
>   MAINTAINERS                                |    8 +
>   include/trace/events/handshake.h           |  159 ++++++++++++++
>   include/uapi/linux/handshake.h             |   70 ++++++
>   net/Kconfig                                |    5
>   net/Makefile                               |    1
>   net/handshake/Makefile                     |   11 +
>   net/handshake/genl.c                       |   57 +++++
>   net/handshake/genl.h                       |   23 ++
>   net/handshake/handshake.h                  |   82 +++++++
>   net/handshake/netlink.c                    |  316 ++++++++++++++++++++++++++++
>   net/handshake/request.c                    |  307 +++++++++++++++++++++++++++
>   net/handshake/trace.c                      |   20 ++
>   13 files changed, 1181 insertions(+)
>   create mode 100644 Documentation/netlink/specs/handshake.yaml
>   create mode 100644 include/trace/events/handshake.h
>   create mode 100644 include/uapi/linux/handshake.h
>   create mode 100644 net/handshake/Makefile
>   create mode 100644 net/handshake/genl.c
>   create mode 100644 net/handshake/genl.h
>   create mode 100644 net/handshake/handshake.h
>   create mode 100644 net/handshake/netlink.c
>   create mode 100644 net/handshake/request.c
>   create mode 100644 net/handshake/trace.c
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

