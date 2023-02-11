Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B406930CD
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 13:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjBKMLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 07:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjBKMLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 07:11:05 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7EA59E6
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 04:11:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4230C5D585;
        Sat, 11 Feb 2023 12:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676117463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=atudL5OD5eFJtw/tJtgSwX2aAYm/I2wcmWP8F7kYs8s=;
        b=GfhyZO7gyy+3dgGAjv7UmprDpEXdgWK2viHpAQtpUFMEz22S7IQUiedYLlzI8oUrD0f9Wq
        SVQntZ9BcoLwOM9J+S5X1hUZq4aRAtzuqPcX8QFTc8gsWVJbEQ9K+s1cKbSril/XZSBw7P
        osNZXcHdT2w/l0jnfJE85faPxFGV+RU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676117463;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=atudL5OD5eFJtw/tJtgSwX2aAYm/I2wcmWP8F7kYs8s=;
        b=xEyHaxShVWa9q19o0UB6IhNn4yt4iFaLTBRRKpSuzeROSieZbVrWIaQNJATw/MQCUj9cs8
        JmM/fuWlRBTblVBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 09A2413A10;
        Sat, 11 Feb 2023 12:11:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id a5MEAdeF52NrXgAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 11 Feb 2023 12:11:03 +0000
Message-ID: <05d58d09-858f-5426-32e2-73f305bc98ff@suse.de>
Date:   Sat, 11 Feb 2023 13:11:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
 <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <20230209180727.0ec328dd@kernel.org>
 <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
 <20230210100915.3fde31dd@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230210100915.3fde31dd@kernel.org>
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

On 2/10/23 19:09, Jakub Kicinski wrote:
> On Fri, 10 Feb 2023 14:17:28 +0000 Chuck Lever III wrote:
>>>> I don't think it does, necessarily. But neither does it seem
>>>> to add any value (for this use case). <shrug>
>>>
>>> Our default is to go for generic netlink, it's where we invest most time
>>> in terms of infrastructure.
>>
>> v2 of the series used generic netlink for the downcall piece.
>> I can convert back to using generic netlink for v4 of the
>> series.
> 
> Would you be able to write the spec for it? I'm happy to help with that
> as I mentioned. Perhaps you have the user space already hand-written
> here but in case the mechanism/family gets reused it'd be sad if people
> had to hand write bindings for other programming languages.

Can you send me a pointer to the YAML specification (and parser)?
I couldn't find anything in the linux sources; but maybe I'm looking in 
the wrong tree or somesuch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

