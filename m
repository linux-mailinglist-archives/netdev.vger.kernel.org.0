Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C70F6C0AEC
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 07:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCTGxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 02:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCTGx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 02:53:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A8B14482
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 23:53:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7B9CA21AEB;
        Mon, 20 Mar 2023 06:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679295204; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOv+1kshHknksivNxrBqnckDtWf8GdhyHq+7PypZO5c=;
        b=FkNHgyfv0LQq3I7DTYuWxM5Qeee/NIxlDCXwI0DEomJA/VocY+1Sz5iI3UAzCPfLY4B6sS
        b004e2RHQH2iUljFlTtp+gw+0cce1pSdQHF3qYL45Ll9xV/eatzV6pHzcdSZ7KikU2VXRM
        uKr6k69wjpI2siXmCr+fEWmDG9GAm8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679295204;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOv+1kshHknksivNxrBqnckDtWf8GdhyHq+7PypZO5c=;
        b=Xb2fSZdWx2knaI/WRm7JWah1fxw2djubPx8FzcvV6xP/29bXG0fXFWgvIPqntAAfIDl7FY
        0td6RpmAWpn4x1Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5512513416;
        Mon, 20 Mar 2023 06:53:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cJmvE+QCGGRxIwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 20 Mar 2023 06:53:24 +0000
Message-ID: <2f2f146a-0997-141f-9f71-14707335a1f2@suse.de>
Date:   Mon, 20 Mar 2023 07:53:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v7 2/2] net/tls: Add kernel APIs for requesting a TLSv1.3
 handshake
Content-Language: en-US
To:     Chuck Lever <cel@kernel.org>, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
 <167915630642.91792.1484529232073813141.stgit@manet.1015granger.net>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <167915630642.91792.1484529232073813141.stgit@manet.1015granger.net>
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
> To enable kernel consumers of TLS to request a TLS handshake, add
> support to net/tls/ to request a handshake upcall.
> 
> This patch also acts as a template for adding handshake upcall
> support to other kernel transport layer security providers.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>   Documentation/netlink/specs/handshake.yaml |    4
>   Documentation/networking/index.rst         |    1
>   Documentation/networking/tls-handshake.rst |  217 +++++++++++++++
>   MAINTAINERS                                |    2
>   include/net/handshake.h                    |   43 +++
>   include/uapi/linux/handshake.h             |    2
>   net/handshake/Makefile                     |    2
>   net/handshake/genl.c                       |    3
>   net/handshake/genl.h                       |    1
>   net/handshake/tlshd.c                      |  417 ++++++++++++++++++++++++++++
>   10 files changed, 689 insertions(+), 3 deletions(-)
>   create mode 100644 Documentation/networking/tls-handshake.rst
>   create mode 100644 include/net/handshake.h
>   create mode 100644 net/handshake/tlshd.c
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

