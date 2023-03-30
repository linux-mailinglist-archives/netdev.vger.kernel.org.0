Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F796D0CBF
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjC3R0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjC3R02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:26:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791A8EB6D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:26:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 10C301F86C;
        Thu, 30 Mar 2023 17:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680197186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VD2q6yCno6nL9gg4yLFM9gH58Kurs4fAyvr3OwfDVjY=;
        b=UBVLZ4e5G4xNQvAWvx1pcj6Cl6laN/l5istKlb46pj8rQ/f177eFisKvJk0z5+A7wem7yx
        2wIUiCx5oT6q8OqR+0pmharYWtLpe0UuxlkkBvlzrs9+nvyxHCe+7neJW+x9A3TnAl8VCy
        UDT1VfP0brDJyrXSU7GE42jiz5WAy1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680197186;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VD2q6yCno6nL9gg4yLFM9gH58Kurs4fAyvr3OwfDVjY=;
        b=DUL/dYXb3QOMn/80ABsD1bFZY5qJZMtvBdeDoNgjYNBtJpDD4EfZ4DenB2sCtIXD/FO0ky
        abYJYAiAkeICKYCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC0381348E;
        Thu, 30 Mar 2023 17:26:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rxDtMEHGJWRFCAAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 30 Mar 2023 17:26:25 +0000
Message-ID: <26cb6ed1-4c32-6042-1d45-97b15a94ef57@suse.de>
Date:   Thu, 30 Mar 2023 19:26:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 10/18] nvme-tcp: fixup send workflow for kTLS
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Boris Pismenny <borisp@nvidia.com>, john.fastabend@gmail.com,
        "kuba@kernel.org" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
        Chuck Lever <chuck.lever@oracle.com>,
        kernel-tls-handshake@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230329135938.46905-1-hare@suse.de>
 <20230329135938.46905-11-hare@suse.de>
 <634385cc-35af-eca0-edcb-1196a95d1dfa@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <634385cc-35af-eca0-edcb-1196a95d1dfa@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/23 17:24, Sagi Grimberg wrote:
> 
>> kTLS does not support MSG_EOR flag for sendmsg(), and in general
>> is really picky about invalid MSG_XXX flags.
> 
> CC'ing TLS folks.
> 
> Can't tls simply ignore MSG_EOR instead of consumers having to be 
> careful over it?
> 
>> So ensure that the MSG_EOR flags is blanked out for TLS, and that
>> the MSG_SENDPAGE_LAST is only set if we actually do sendpage().
> 
> You mean MSG_SENDPAGE_NOTLAST.
> 
> It is also a bit annoying that a tls socket dictates different behavior
> than a normal socket.
> 
> The current logic is rather simple:
> if more data comming:
>      flags = MSG_MORE | MSG_SENDPAGE_NOTLAST
> else:
>      flags = MSG_EOR
> 
> Would like to keep it that way for tls as well. Can someone
> explain why this is a problem with tls?

TLS is using MSG_EOR internally (to control the flow of the underlying 
tcp stream), so it's meaningless for the ULP.
I've no idea about SENDPAGE_NOTLAST; that one is particularly annoying
as we have to check whether we do sendpage() or sendmsg().

But TLS really should blank out invalid flags, as it has different rules 
for them than anyone else. And the caller really shouldn't be burdened
with checking whether TLS is enabled or not.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

