Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFAA6D171D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjCaGDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCaGDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:03:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D44BA
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:03:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 62F7421AD8;
        Fri, 31 Mar 2023 06:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680242595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6LJLdpTifbWu/NCZqsThk4lhL367AO5FzmVb5gHQL1I=;
        b=EvfitK98rEkxTjr9Gf5JVZ8YVrIFBKyst9v8/QgRdtlRN1EjqHNyAXgrHP++rzUEzNAPNn
        Yc7efdCR0IvTnixcjRdl63Y8qw+qg+CixKZw+YROUofcSbhjitWhsZRVV/TRiP69KZO8QD
        2YrlZFgLG65yWPccVKWHd7NdoC/2qdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680242595;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6LJLdpTifbWu/NCZqsThk4lhL367AO5FzmVb5gHQL1I=;
        b=6szLB+9qXktTeIlghC8MGiUpZtjZgfPVbaO3F3Fhzq+BAhKjMyUTF1AbwdVgxHQu3uRnlD
        KGqyjHP1CLLEO0Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9C6E7133B6;
        Fri, 31 Mar 2023 06:03:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pnSoI5R3JmTyTAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 31 Mar 2023 06:03:00 +0000
Message-ID: <7f057726-8777-2fd3-a207-b3cd96076cb9@suse.de>
Date:   Fri, 31 Mar 2023 08:03:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 10/18] nvme-tcp: fixup send workflow for kTLS
To:     Jakub Kicinski <kuba@kernel.org>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Boris Pismenny <borisp@nvidia.com>,
        john.fastabend@gmail.com, Paolo Abeni <pabeni@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org,
        Chuck Lever <chuck.lever@oracle.com>,
        kernel-tls-handshake@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230329135938.46905-1-hare@suse.de>
 <20230329135938.46905-11-hare@suse.de>
 <634385cc-35af-eca0-edcb-1196a95d1dfa@grimberg.me>
 <20230330224920.3a47fec9@kernel.org>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230330224920.3a47fec9@kernel.org>
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

On 3/31/23 07:49, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 18:24:04 +0300 Sagi Grimberg wrote:
>>> kTLS does not support MSG_EOR flag for sendmsg(), and in general
>>> is really picky about invalid MSG_XXX flags.
>>
>> CC'ing TLS folks.
>>
>> Can't tls simply ignore MSG_EOR instead of consumers having to be
>> careful over it?
> 
> I think we can support EOR, I don't see any fundamental problem there.
> 
>>> So ensure that the MSG_EOR flags is blanked out for TLS, and that
>>> the MSG_SENDPAGE_LAST is only set if we actually do sendpage().
>>
>> You mean MSG_SENDPAGE_NOTLAST.
>>
>> It is also a bit annoying that a tls socket dictates different behavior
>> than a normal socket.
>>
>> The current logic is rather simple:
>> if more data comming:
>> 	flags = MSG_MORE | MSG_SENDPAGE_NOTLAST
>> else:
>> 	flags = MSG_EOR
>>
>> Would like to keep it that way for tls as well. Can someone
>> explain why this is a problem with tls?
> 
> Some of the flags are call specific, others may be internal to the
> networking stack (e.g. the DECRYPTED flag). Old protocols didn't do
> any validation because people coded more haphazardly in the 90s.
> This lack of validation is a major source of technical debt :(

A-ha. So what is the plan?
Should the stack validate flags?
And should the rules for validating be the same for all protocols?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

