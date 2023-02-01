Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F4B686054
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 08:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjBAHK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 02:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBAHJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 02:09:50 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1932B29412
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 23:09:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BA27320A9D;
        Wed,  1 Feb 2023 07:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675235385; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8h92BRTkwjJmB3POhZSy32W9JQ3pYmzgwAs4Ei5E+88=;
        b=QP6Fijn1yzUfJpN6xNbEwrVTb3uTLic2+ZCzvJzngvSFJGnnRlurYuMYEa4ApXusD7MCIt
        e1ymXAZwVsIOHTB++yek5QAIZ28P/xm65mMZEy0r7wLKunKpOv5RyJy6y2Lgq5TtYHW/+M
        S/LOquA3uWv3w+TU+L53+gdXuGbLyH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675235385;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8h92BRTkwjJmB3POhZSy32W9JQ3pYmzgwAs4Ei5E+88=;
        b=e1yIcM8xp2e4bYb3okU8tbN+HwCUQgMjZjoO47f+yJirBgcUztYGPYlKvEhvKdwaneH3wP
        /UPSOvC8XNtex1Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 846C61348C;
        Wed,  1 Feb 2023 07:09:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mo0EHzkQ2mMOJgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 01 Feb 2023 07:09:45 +0000
Message-ID: <54cf4728-de7b-5774-5e92-7c30a678e346@suse.de>
Date:   Wed, 1 Feb 2023 08:09:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
To:     Marcel Holtmann <marcel@holtmann.org>
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
 <29575fc2-5b1d-bdc0-e4bc-dbf5bd51075f@suse.de>
 <45C6BAF4-C5EF-40F9-AC23-91BFD8255FEE@holtmann.org>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <45C6BAF4-C5EF-40F9-AC23-91BFD8255FEE@holtmann.org>
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

On 1/31/23 21:32, Marcel Holtmann wrote:
> Hi Hannes,
> 
[ .. ]
>>> It is just painful for the simple reason that there is no real
>>> standard around CA certificates and where to place them. Every
>>> distro is kinda doing it their way and you expect your TLS
>>> library to do the magic.
>>> I like to see systemd create a keyring of the CA certs, seal it
>>> and then provide it do every process/service it launches. And
>>> for non systemd distros they need to find a way to actually
>>> provide that one keyring that can be used as master for all the
>>> CA certs.
>>> We have not bothered with that yet since for WiFi, you always
>>> have a client cert derived from the CA of the server. So you
>>> give a CA cert and a client cert when you connect to WiFi
>>> Enterprise systems.
>> The good thing is that NVMe is currently PSK-only, so the certificate
> bit is easy for me. Others like NFS will have to do proper X.509 cert
> handling, but I'll let them worry about that :-)
> 
> Interesting. I have not looked at PSK part yet. Do you require PSK-only
> or ECDHE+PSK. From what I quickly glanced at the spec, the PSK-only is
> really simple. That is the most simplest TLS Handshake I have seen and
> I should give that a spin.
> 

ECDHE+PSK, sadly; the PSK-only method will be deprecated eventually.
But I've got code for that already, so that's nothing to worry about.

> So NVMe agrees the PSK out-of-band? I might be able to read up on it,
> but I can only keep so much specifications in memory ;)
> 
Yep, that's the plan. Or, one could say, the 'P' in PSK :-)
That's where keyrings come in; idea is that external agent populate the 
keyring, and the kernel code just looks up keys from there.

[ .. ]
>>>> And that was the other thing; we found quite some TLS implementations,
>>>> but nearly all of the said '1.3 support to come' ...
>>> True to that. I think even OpenSSL started an effort to have a
>>> QUIC specific API now.
>>> The problem that I found is that TLS Handshake, TLS Alert and
>>> TLS Record protocol are not cleanly separated. They are mixed
>>> together.
>> Yep.
>>
>>> For example if I want to use kTLS, I mostly just have to deal
>>> with TLS Handshake portion. QUIC was specific and just uses
>>> TLS Handshake and TLS Alert are converted to QUIC errors.
>> Some for us. Alerts don't make sense to us as we have long-lived
>> connections, so the prime reason for alerts is gone, and we have
>> to re-establish the connection whenever the cipher is changed. So
>> we will be converting alerts in errors, too.
> 
> What is the solution for sequence number exhaustion. Do you
> re-connect or do you re-key via TLS?
> 
Reconnect. We don't have a good way of allowing for re-keying, as the
key material directly relates to information retrieved from the protocol 
itself (here: the TLS key might derived from the DH-CHAP authentication 
protocol running in NVMe space).
So for any re-key operationn we'll should to re-run that protocol. At 
which point we might as well kill the connection and start over, as this 
is basically the same operation.

[ .. ]
>>>>> Long story short, who is suppose to 
>>> And I am certain that Wireshark would love to get hold of
>>> the unencrypted TLS Handshake traffic. Debugging TLS
>>> and also QUIC transfers is hugely painful. The method of
>>> SSLKEYLOGFILE works but it is so cumbersome and defeats
>>> any kind of live traffic analysis. So having some DIAG
>>> here would help a lot of developers.
>> Oh, yes. That would be nice side-effect.
>>
>> So, when can I expect the patch?
>> :-)
> 
> Lol. I need to get a few things cleaned up in the userspace
> prototype I have. Then I take a stab at a kernel code. I do
> need to build myself a test setup for PSK-only since I have
> not yet bothered with that.
> 
I'd be happy to have the userspace code; my plan is to work on a frame 
forwarder (such that the TLS handshake and alert frames are forwarded to 
userspace via netlink).
Then I can repurpose the daemon code from the accept solution to handle 
those netlink frames, and use your library for the tls handshake.

That would give us a nice proof of concept, and if designed properly the 
frame forwarder could later be modified to redirect to the in-kernel code.

So having the userspace code already is a bonus.
And the 'patch' really was just for the userspace library :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

