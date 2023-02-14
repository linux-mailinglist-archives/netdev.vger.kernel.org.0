Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772C8695F8B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBNJok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjBNJoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:44:39 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFF3CC30
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:44:37 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1D1E821B1D;
        Tue, 14 Feb 2023 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676367876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HHY/7g+mPLAW7SaTid/CbXRD+Irq433VXV9djXixeP8=;
        b=KgmYmbm+f6qVEmVFXnNvOFdsJ7r/GiaZyVWPRjV/0jGESY0I0nJLze3hovClAgwS3Oq1aQ
        FrbXEY7DF08SxAncjm3wYRfakj4+WjXIu6G6QM5UcnJXTAqWXZhaESpVMhhuO5oZv4aIXI
        dhzQiNkTaTiXXYlnRH8VvL3DtGbxyfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676367876;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HHY/7g+mPLAW7SaTid/CbXRD+Irq433VXV9djXixeP8=;
        b=w5XM/9BlEWv5d+k6Qqydee6NtouaX0Fp1e8KAKP/R23kRrONMqo3+nFfrioLPuf7Y5z/30
        Yl4tk995/SdvEVDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 04B2213A21;
        Tue, 14 Feb 2023 09:44:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ULfPAARY62O/TAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Feb 2023 09:44:36 +0000
Message-ID: <fde7055b-dbc7-f438-1a15-4ffaa92d1fa8@suse.de>
Date:   Tue, 14 Feb 2023 10:44:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Chuck Lever <chuck.lever@oracle.com>, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        bcodding@redhat.com, kolga@netapp.com, jmeneghi@redhat.com
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 0/2] Another crack at a handshake upcall mechanism
In-Reply-To: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/23 22:41, Chuck Lever wrote:
> Hi-
> 
> Here is v3 of a series to add generic support for transport layer
> security handshake on behalf of kernel consumers (user space
> consumers use a security library directly, of course).
> 
> This version of the series does away with the listen/poll/accept/
> close design and replaces it with a full netlink implementation
> that handles much of the same function.
> 
> The first patch in the series adds a new netlink family to handle
> the kernel-user space interaction to request a handshake. The second
> patch demonstrates how to extend this new mechanism to support a
> particular transport layer security protocol (in this case,
> TLSv1.3).
> 
> Of particular interest is that the user space handshake agent now
> must perform a second downcall when the handshake is complete,
> rather than simply closing the socket descriptor. This enables the
> user space agent to pass down a session status, whether the session
> was mutually authenticated, and the identity of the remote peer.
> (Although these facilities are plumbed into the netlink protocol,
> they have yet to be fully implemented by the kernel or the sample
> user space agent below).
> 
> Certificates and pre-shared keys are made available to the user
> space agent via keyrings, or the agent can use authentication
> materials residing in the local filesystem.
> 
> The full patch set to support SunRPC with TLSv1.3 is available in
> the topic-rpc-with-tls-upcall branch here, based on v6.1.10:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git
> 
> A sample user space handshake agent with netlink support is
> available in the "netlink" branch here:
> 
>     https://github.com/oracle/ktls-utils
> 
> ---
> 
> Changes since v2:
> - PF_HANDSHAKE replaced with NETLINK_HANDSHAKE
> - Replaced listen(2) / poll(2) with a multicast notification service
> - Replaced accept(2) with a netlink operation that can return an
>    open fd and handshake parameters
> - Replaced close(2) with a netlink operation that can take arguments
> 
> Changes since RFC:
> - Generic upcall support split away from kTLS
> - Added support for TLS ServerHello
> - Documentation has been temporarily removed while API churns
> 
> Chuck Lever (2):
>        net/handshake: Create a NETLINK service for handling handshake requests
>        net/tls: Support AF_HANDSHAKE in kTLS
> 
> The use of AF_HANDSHAKE in the short description here is stale. I'll
> fix that in a subsequent posting.
> 
Have been playing around with this patchset, and for some reason I get a 
weird crash:

[ 5101.640941] nvme nvme0: queue 0: start TLS with key 15982809
[ 5111.769538] nvme nvme0: queue 0: TLS handshake complete, tmo 2500, 
error -110
[ 5111.769545] BUG: kernel NULL pointer dereference, address: 
0000000000000068
[ 5111.770089] #PF: supervisor read access in kernel mode
[ 5111.770460] #PF: error_code(0x0000) - not-present page
[ 5111.770828] PGD 0 P4D 0
[ 5111.771019] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 5111.771344] CPU: 0 PID: 8611 Comm: nvme Kdump: loaded Tainted: G 
[ 5111.772193] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
[ 5111.772864] RIP: 0010:kernel_sock_shutdown+0x9/0x20

which looks to me as if the socket had been deallocated once the netlink
handshake has completed.
And indeed, handshake_accept() has the 'CLOEXEC' flag set.
So if the userprocess exits it'll close the socket, and we're hosed.
Which seems to be what is happening here.

Let's see if things work out better without the CLOEXEC flag.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

