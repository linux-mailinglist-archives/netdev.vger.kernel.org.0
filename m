Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5273268856C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjBBRcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbjBBRcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:32:25 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3061474C06
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:32:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5B90133AD9;
        Thu,  2 Feb 2023 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675359130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7FdfcBu31B88bjtOuE0P3v5gephWh2pPYULLwecN2o=;
        b=1f+cxqw+mt3Np8rgZRU06vKInVlFLeCDAiDp92wOPmNF+wkHHFEInLbpSNiGPKySpqpyE4
        GXZQW0QQ5qt/CSsqw6xLy+7NjwfTMl95+G30+WFxaQqe4cx8O8lCYK2X9NbXF+8Iw1se2B
        OoyajOs9I2HXA4oiGgT/7QTQVGqLO7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675359130;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7FdfcBu31B88bjtOuE0P3v5gephWh2pPYULLwecN2o=;
        b=uHqCwE27ZBhjpIqUiAM/dLWCE03w0vcLfPDyyLqLSDFaz1z5lbiLRQRTSS/gtce5x86zbI
        etB6RaQXq9aQrtCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 228D5139D0;
        Thu,  2 Feb 2023 17:32:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id J7DGBZrz22OvJQAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 02 Feb 2023 17:32:10 +0000
Message-ID: <a00734e4-bd74-1100-d1f7-83d899572b47@suse.de>
Date:   Thu, 2 Feb 2023 18:32:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        hare@suse.com, dhowells@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com, bcodding@redhat.com, jlayton@redhat.com
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
 <048cba69-aa9a-08d1-789f-fe17c408cfb2@suse.de>
 <60962833-2EA3-449C-8F58-887C833DFC5C@holtmann.org>
 <10d117b6-a1bf-ee19-7d61-f6ba764aeab6@suse.de>
 <98A14BB2-67BB-4B63-8FC7-E673980EB773@holtmann.org>
 <CADvbK_eiMmZgPr-L==-zMHDfej82aVv_-xMxv6iqroV2Q9yCHw@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CADvbK_eiMmZgPr-L==-zMHDfej82aVv_-xMxv6iqroV2Q9yCHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/23 18:13, Xin Long wrote:
> On Tue, Jan 31, 2023 at 9:24 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>>
>> I know, utilizing existing TLS libraries is a pain if you don’t do
>> exactly what they had in mind. I started looking at QUIC a while
>> back and quickly realized, I have to start looking at TLS 1.3 first.
>>
>> My past experience with GnuTLS and OpenSSL have been bad and that is
>> why iwd (our WiFi daemon) has its own TLS implementation utilizing
>> AF_ALG and keyctl.
> Hi Marcel,
> 
> I'm no expert on TLS, but I'm a supporter of in-kernel TLS 1.3 Handshake
> implementation :). When working on implementing in-kernel QUIC protocol,
> the code looks a lot simpler with the pure in-kernel TLS 1.3 Handshake APIs
> than the upcall method, and I believe the NFS over TLS 1.3 in kernel will
> feel the same.
> 
>>
>> While that might have been true in the past and with TLS 1.2 and earlier,
>> I am not sure that is all true today.
>>
>> Lets assume we start with TLS 1.3 and don’t have backwards compatibility
>> with TLS 1.2 and earlier. And for now we don’t worry about Middleboxes
>> compatibility mode since you don’t have to for all the modern protocols
>> that utilize just the TLS 1.3 handshake like QUIC.
>>
>> Now the key derivation is just choosing 1 out of 5 ciphers and using
>> its associated hash algorithm to derive the keys. This is all present
>> functionality in the kernel and so well tested that it doesn’t worry
>> me at all. We also have a separate RFC with just sample data so you
>> can check your derivation functionality. Especially if you check it
>> against AEAD encrypted sample data, any mistake is fatal.
>>
>> The shared key portion is just ECDHE or DHE and you either end up with
>> x25519 or secp256r1 and both are in the kernel. Bluetooth has been
>> using secp256r1 inside the kernel for many years now. We all know how
>> to handle and verify public keys from secp256r1 and neat part is that
>> it would be also offloaded to hardware if needed. So the private key
>> doesn’t need to stay even in kernel memory.
>>
>> So dealing with generating your key material for your cipher is really
>> simple and similar things have been done for Bluetooth for a long
>> time now. And it looks like NVMe is also utilizing KPP as of today.
>>
>> The tricky part is the authentication portion of TLS utilizing
>> certificates. That part is complicated, but then again, we already
>> decided the kernel needs to handle certificates for various places
>> and you have to assume that it is fairly secure.
>>
>> Now, you need to secure the handshake protocol like any other protocol
>> and the only difference is that it will lead to key material and
>> does authentication with certificates. All of it, the kernel already
>> does in one form or another.
>>
>> The TLS 1.3 spec is also really nicely written and explicit in
>> error behavior in case of attempts to attack the protocol. While
>> implementing my TLS 1.3 only prototype I have been positively
>> surprised on how clean it is. I personally think they went over
>> board with the key verification, but so be it.
>>
>> Once I have cleaned up my TLS 1.3 prototype, I am happy to take
>> a stab at a kernel version.
>>
> I'm glad to hear that you're planning to add this in kernel space, and I
> agree that there won't be a lot of things to do in kernel due to the kernel
> crypto APIs. There is also a TLS 1.3 Handshake prototype I worked on and
> based on the torvalds/linux kernel code. In case of any duplicate work
> when you're doing it, I just share my code here:
> 
>    https://github.com/lxin/tls_hs/blob/master/crypto/tls_hs.c
> 
> and the TLS_HS APIs docs for QUIC and NFS use are here:
> 
>    https://github.com/lxin/tls_hs
> 
> Hopefully, it will help.
> 
> Besides, There were some security concerns from others for which I didn't
> continue:
> 
>    https://github.com/lxin/tls_hs#the-security-issues
> 
> It will be great if we can have your opinions about it.
> 
> Thanks.
Wow.
That certainly looks good; I'll give it a go and try to integrate it 
with my NVMe-TLS stuff.
Thanks a lot for this!

As for your security concerns:
- Certification management _is_ complete, but we have the kernel keyring
   to help us out. The cert can be looked up in the keyring, and one can
   even call request_key() to get userspace to supply us with one.
   With that we can just use the kernel keyring to lookup certificates
   and don't worry about key management itself.
- TLS 1.3 is nailed down, and won't inherit more encryption algorithms.
   So nothing to worry about
- Corner cases ... yes, the code needs to be validated.
- RSA rewrite ... can't we disallow RSA for in-kernel usage?
- mpi code not constant-time safe; might be. But that goes for all
   in-kernel users, and I'm not sure if _we_ have to worry about that.
- DH and ECDH potentially broken: not anymore; got fixed up to
   be FIPS compliant
- Take advantage of decades of work in userspace: that's _precisely_
   why we're sticking with TLS 1.3. Most of the backwards-compat stuff
   got removed, so we _don't_ have to worry about that.

So it's at least worth a shot, to see where we end up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

