Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD3750993F
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385985AbiDUHjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385901AbiDUHjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:39:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E4EE006;
        Thu, 21 Apr 2022 00:36:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 01A711F752;
        Thu, 21 Apr 2022 07:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650526577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAXsOk6yzhhd0eEtaA8q2o8v1Ej4I4CXR8fJhC0OpzA=;
        b=m7TWSKxIaO2OHLz7OIQd6C4I7WuNfP/PiKnYwyQ8oWKuFzbWJ1EDilLdlUZNHpiX0+8aXV
        iDTBl/k4IvLIUmYk3H4SY5cAgXftC+9bG9nFyPxBf3Dqg6mxbDqtmiZ4fBlzJzjzRxZEyS
        XH5g16JCcPC8LacP4MqYiMnjPzfe/x8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650526577;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAXsOk6yzhhd0eEtaA8q2o8v1Ej4I4CXR8fJhC0OpzA=;
        b=RtaRTiFpEp3jVgAoA0j68Wo9/+Y1x76ysid8GO1AJ54b+r10NsbcS4soPdBAxjJOmdQShC
        /xD4m7TEgRjXkqAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB58F13A84;
        Thu, 21 Apr 2022 07:36:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kOefMHAJYWL/EQAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 21 Apr 2022 07:36:16 +0000
Message-ID: <0ec079d6-2c7f-4029-76c8-3e43cd99bba2@suse.de>
Date:   Thu, 21 Apr 2022 09:36:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Content-Language: en-US
To:     Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/22 18:49, Chuck Lever wrote:
> In-kernel TLS consumers need a way to perform a TLS handshake. In
> the absence of a handshake implementation in the kernel itself, a
> mechanism to perform the handshake in user space, using an existing
> TLS handshake library, is necessary.
> 
> I've designed a way to pass a connected kernel socket endpoint to
> user space using the traditional listen/accept mechanism. accept(2)
> gives us a well-understood way to materialize a socket endpoint as a
> normal file descriptor in a specific user space process. Like any
> open socket descriptor, the accepted FD can then be passed to a
> library such as openSSL to perform a TLS handshake.
> 
> This prototype currently handles only initiating client-side TLS
> handshakes. Server-side handshakes and key renegotiation are left
> to do.
> 
> Security Considerations
> ~~~~~~~~ ~~~~~~~~~~~~~~
> 
> This prototype is net-namespace aware.
> 
> The kernel has no mechanism to attest that the listening user space
> agent is trustworthy.
> 
> Currently the prototype does not handle multiple listeners that
> overlap -- multiple listeners in the same net namespace that have
> overlapping bind addresses.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>   .../networking/tls-in-kernel-handshake.rst         |  103 ++
>   include/linux/socket.h                             |    1
>   include/net/sock.h                                 |    3
>   include/net/tls.h                                  |   15
>   include/net/tlsh.h                                 |   22
>   include/uapi/linux/tls.h                           |   16
>   net/core/sock.c                                    |    2
>   net/tls/Makefile                                   |    2
>   net/tls/af_tlsh.c                                  | 1040 ++++++++++++++++++++
>   net/tls/tls_main.c                                 |   10
>   10 files changed, 1213 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/networking/tls-in-kernel-handshake.rst
>   create mode 100644 include/net/tlsh.h
>   create mode 100644 net/tls/af_tlsh.c
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
