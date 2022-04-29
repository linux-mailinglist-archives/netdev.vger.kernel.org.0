Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEB8514247
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 08:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354514AbiD2G3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 02:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiD2G3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 02:29:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8428C2FFEB;
        Thu, 28 Apr 2022 23:25:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D483E1F891;
        Fri, 29 Apr 2022 06:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651213540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mEw62v1kuJQHmlRrCyVjGQtqwhVWqTxtmaom/79rnco=;
        b=x0L/HqCw7Unnw352nykpZUI0RufEfg7p6tti/IVUnAHk1WiKawp/ZPd4Gs4EYSgkGmtSW+
        Tkg1rEPv2HSA+mMrJGa9cTiQxtgUDDkrRGOMyNJf6mPdkVHjPsimAmrWXEW3lJjEHkji+T
        /uSmmrqRyYGdVI8nc2RQ4zJ67J8K110=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651213540;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mEw62v1kuJQHmlRrCyVjGQtqwhVWqTxtmaom/79rnco=;
        b=/1iJkvcS+vjQLEvIiuZZqcO9XLwmKyKmapOwwGqhBVZ+bsDuQ854eOrIwSM4qdkMsN3PX6
        1Duj/jqrS6/I8WCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9BAA013446;
        Fri, 29 Apr 2022 06:25:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id f6ByJOSEa2KbLAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 29 Apr 2022 06:25:40 +0000
Message-ID: <32eb95ad-ceb7-4138-63d9-f6108f0f6393@suse.de>
Date:   Fri, 29 Apr 2022 08:25:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Content-Language: en-US
To:     Chuck Lever III <chuck.lever@oracle.com>,
        Boris Pismenny <borispismenny@gmail.com>
Cc:     Alexander Krizhanovsky <ak@tempesta-tech.com>,
        Simo Sorce <simo@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <068945db-f29e-8586-0487-bb5be68c7ba8@gmail.com>
 <33F93223-519B-47E9-8578-B18DCB8F1F8E@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <33F93223-519B-47E9-8578-B18DCB8F1F8E@oracle.com>
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

On 4/28/22 17:24, Chuck Lever III wrote:
> 
> 
>> On Apr 28, 2022, at 4:49 AM, Boris Pismenny <borispismenny@gmail.com> wrote:
>>
>> On 18/04/2022 19:49, Chuck Lever wrote:
>>> In-kernel TLS consumers need a way to perform a TLS handshake. In
>>> the absence of a handshake implementation in the kernel itself, a
>>> mechanism to perform the handshake in user space, using an existing
>>> TLS handshake library, is necessary.
>>>
>>> I've designed a way to pass a connected kernel socket endpoint to
>>> user space using the traditional listen/accept mechanism. accept(2)
>>> gives us a well-understood way to materialize a socket endpoint as a
>>> normal file descriptor in a specific user space process. Like any
>>> open socket descriptor, the accepted FD can then be passed to a
>>> library such as openSSL to perform a TLS handshake.
>>>
>>> This prototype currently handles only initiating client-side TLS
>>> handshakes. Server-side handshakes and key renegotiation are left
>>> to do.
>>>
>>> Security Considerations
>>> ~~~~~~~~ ~~~~~~~~~~~~~~
>>>
>>> This prototype is net-namespace aware.
>>>
>>> The kernel has no mechanism to attest that the listening user space
>>> agent is trustworthy.
>>>
>>> Currently the prototype does not handle multiple listeners that
>>> overlap -- multiple listeners in the same net namespace that have
>>> overlapping bind addresses.
>>>
>>
>> Thanks for posting this. As we discussed offline, I think this approach
>> is more manageable compared to a full in-kernel TLS handshake. A while
>> ago, I've hacked around TLS to implement the data-path for NVMe-TLS and
>> the data-path is indeed very simple provided an infrastructure such as
>> this one.
>>
>> Making this more generic is desirable, and this obviously requires
>> supporting multiple listeners for multiple protocols (TLS, DTLS, QUIC,
>> PSP, etc.), which suggests that it will reside somewhere outside of net/tls.
>> Moreover, there is a need to support (TLS) control messages here too.
>> These will occasionally require going back to the userspace daemon
>> during kernel packet processing. A few examples are handling: TLS rekey,
>> TLS close_notify, and TLS keepalives. I'm not saying that we need to
>> support everything from day-1, but there needs to be a way to support these.
> 
> I agree that control messages need to be handled as well. For the
> moment, the prototype simply breaks the connection when a control
> message is encountered, and a new session is negotiated. That of
> course is not the desired long-term solution.
> 
> If we believe that control messages are going to be distinct for
> each transport security layer, then perhaps we cannot make the
> handshake mechanism generic -- it will have to be specific to
> each security layer. Just a thought.
> 
> 
>> A related kernel interface is the XFRM netlink where the kernel asks a
>> userspace daemon to perform an IKE handshake for establishing IPsec SAs.
>> This works well when the handshake runs on a different socket, perhaps
>> that interface can be extended to do handshakes on a given socket that
>> lives in the kernel without actually passing the fd to userespace. If we
>> avoid instantiating a full socket fd in userspace, then the need for an
>> accept(2) interface is reduced, right?
> 
> Certainly piping the handshake messages up to user space instead
> of handing off a socket is possible. The TLS libraries would need
> to tolerate this, and GnuTLS (at least) appears OK with performing
> a handshake on an AF_TLSH socket.
> 
Yeah, and I guess that'll be the hard part.
We would need to design an entirely data path for gnutls when going down 
that path.
The beauty of the fd-passing idea is that gnutls (and openssl for that 
matter) will 'just work' (tm), without us have to do larger surgery there.
Just for reference, I've raised an issue with gnutls to accept long 
identifiers in TLS 1.3 (issue #1323), which is required for 
NVMe-over-TLS support. That one is lingering for over two months now.
And that's a relatively simple change; I don't want to imagine how long 
it'd take to try to push in a larger redesign...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
