Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B050FA1F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348732AbiDZKUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348929AbiDZKTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:19:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBE97EA28;
        Tue, 26 Apr 2022 02:43:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E1583210E6;
        Tue, 26 Apr 2022 09:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650966217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wSgd95mYy00KtCQ6YWhCz6vTpakQUV5AuNG8Spd/yA8=;
        b=ZIVbjB66FeHQ6yj5TXWbJ/gSKjO4yRdrZIVf5dE0CoQTuXEtJAs1Bxos3O6G+NT0xqQua8
        Mv+UVR+IYJXVn0q2VgIrBCb/5tnBkFS08lhYAMFEoKCFkoNF++zX3KXU6BQ2RfBdT9tSI4
        B+cWZZrL6saQUSGzWVQ3meuz8ekKA/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650966217;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wSgd95mYy00KtCQ6YWhCz6vTpakQUV5AuNG8Spd/yA8=;
        b=Qa0uHqnJwSM2/PfR3ZlE/7jOzJXiAuAlYesCktb4E/sC8Y0y/IDp51Xl5Ilm4fLT6QsXF3
        i3Dl8iZXqO3DtDBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A9D8813223;
        Tue, 26 Apr 2022 09:43:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JOtuKMm+Z2KWPgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 26 Apr 2022 09:43:37 +0000
Message-ID: <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
Date:   Tue, 26 Apr 2022 11:43:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Cc:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ak@tempesta-tech.com,
        borisp@nvidia.com, simo@redhat.com
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
In-Reply-To: <20220425101459.15484d17@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/22 19:14, Jakub Kicinski wrote:
> On Mon, 18 Apr 2022 12:49:50 -0400 Chuck Lever wrote:
>> In-kernel TLS consumers need a way to perform a TLS handshake. In
>> the absence of a handshake implementation in the kernel itself, a
>> mechanism to perform the handshake in user space, using an existing
>> TLS handshake library, is necessary.
>>
>> I've designed a way to pass a connected kernel socket endpoint to
>> user space using the traditional listen/accept mechanism. accept(2)
>> gives us a well-understood way to materialize a socket endpoint as a
>> normal file descriptor in a specific user space process. Like any
>> open socket descriptor, the accepted FD can then be passed to a
>> library such as openSSL to perform a TLS handshake.
>>
>> This prototype currently handles only initiating client-side TLS
>> handshakes. Server-side handshakes and key renegotiation are left
>> to do.
>>
>> Security Considerations
>> ~~~~~~~~ ~~~~~~~~~~~~~~
>>
>> This prototype is net-namespace aware.
>>
>> The kernel has no mechanism to attest that the listening user space
>> agent is trustworthy.
>>
>> Currently the prototype does not handle multiple listeners that
>> overlap -- multiple listeners in the same net namespace that have
>> overlapping bind addresses.
> 
> Create the socket in user space, do all the handshakes you need there
> and then pass it to the kernel.  This is how NBD + TLS works.  Scales
> better and requires much less kernel code.
> 
But we can't, as the existing mechanisms (at least for NVMe) creates the 
socket in-kernel.
Having to create the socket in userspace would require a completely new 
interface for nvme and will not be backwards compatible.
Not to mention having to rework the nvme driver to accept sockets from 
userspace instead of creating them internally.

With this approach we can keep existing infrastructure, and can get a 
common implementation for either transport.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
