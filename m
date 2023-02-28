Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09DC6A5C4C
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjB1Psm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjB1Psl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:48:41 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E001BCB
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:48:39 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 85DCA218E5;
        Tue, 28 Feb 2023 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677599318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCarZDlfiIsPEDcXnexMYN0JhyOgEyMFY/lbcdHhw44=;
        b=GcGzC3PHhoS7WZFFB/rNe7GBU7IrHviQ1x3Gu5eu3EQqRDJeLsu+ybG0VehYIS0F0ADoBv
        mb85TIspzu9o4//JlQngESS0pmvJGe9aF2qQByusoJ7qcyCC+Q8H7HvCGZR8OVEdifEOwW
        9efhYY1HJpqWsU4A5MTBHd+S8SK7PBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677599318;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCarZDlfiIsPEDcXnexMYN0JhyOgEyMFY/lbcdHhw44=;
        b=lix1CMvbZcOAC+K1Lf21gmrmheIKbRDTbJtHcqYOiXn++b7CRsTOKNoMzwdUA0ag94c66c
        piS9Zosfb/2eB9Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 65C9C13440;
        Tue, 28 Feb 2023 15:48:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sf9VGFYi/mPeBAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 28 Feb 2023 15:48:38 +0000
Message-ID: <aae5c8e6-738e-669f-3f0e-059282d55449@suse.de>
Date:   Tue, 28 Feb 2023 16:48:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Chuck Lever <cel@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
 <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
 <1B595556-0236-49F3-A8B0-ECF2332450D4@oracle.com>
 <006c4e44-572b-a6f8-9af0-5f568913e7a0@suse.de>
 <90C7DF9C-6860-4317-8D01-C60C718C8257@oracle.com>
 <71affa5a-d6fa-d76b-10a1-882a9107a3b4@suse.de>
 <69541D93-7693-4631-9263-DE77D289AA71@oracle.com>
 <b9c3e5aa-c7e1-08dd-8a1b-00035f046071@suse.de>
 <D06D70DC-D053-4212-B72C-82C1BB1AF9F2@oracle.com>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <D06D70DC-D053-4212-B72C-82C1BB1AF9F2@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/23 15:28, Chuck Lever III wrote:
> 
> 
>> On Feb 28, 2023, at 1:58 AM, Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 2/27/23 19:10, Chuck Lever III wrote:
>>>> On Feb 27, 2023, at 12:21 PM, Hannes Reinecke <hare@suse.de> wrote:
>>>>
>>>>> On 2/27/23 16:39, Chuck Lever III wrote:
>>>>>> On Feb 27, 2023, at 10:14 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>>>>
>>>>>> Problem here is with using different key materials.
>>>>>> As the current handshake can only deal with one key at a time
>>>>>> the only chance we have for several possible keys is to retry
>>>>>> the handshake with the next key.
>>>>>> But out of necessity we have to use the _same_ connection
>>>>>> (as tlshd doesn't control the socket). So we cannot close
>>>>>> the socket, and hence we can't notify userspace to give up the handshake attempt.
>>>>>> Being able to send a signal would be simple; sending SIGHUP to userspace, and wait for the 'done' call.
>>>>>> If it doesn't come we can terminate all attempts.
>>>>>> But if we get the 'done' call we know it's safe to start with the next attempt.
>>>>> We solve this problem by enabling the kernel to provide all those
>>>>> materials to tlshd in one go.
>>>> Ah. Right, that would work, too; provide all possible keys to the
>>>> 'accept' call and let the userspace agent figure out what to do with
>>>> them. That makes life certainly easier for the kernel side.
>>>>
>>>>> I don't think there's a "retry" situation here. Once the handshake
>>>>> has failed, the client peer has to know to try again. That would
>>>>> mean retrying would have to be part of the upper layer protocol.
>>>>> Does an NVMe initiator know it has to drive another handshake if
>>>>> the first one fails, or does it rely on the handshake itself to
>>>>> try all available identities?
>>>>> We don't have a choice but to provide all the keys at once and
>>>>> let the handshake negotiation deal with it.
>>>>> I'm working on DONE passing multiple remote peer IDs back to the
>>>>> kernel now. I don't see why ACCEPT couldn't pass multiple peer IDs
>>>>> the other way.
>>>> Nope. That's not required.
>>>> DONE can only ever have one peer id (TLS 1.3 specifies that the client
>>>> sends a list of identities, the server picks one, and sends that one back
>>>> to the client). So for DONE we will only ever have 1 peer ID.
>>>> If we allow for several peer IDs to be present in the client ACCEPT message
>>>> then we'd need to include the resulting peer ID in the client DONE, too;
>>>> otherwise we'll need it for the server DONE only.
>>>>
>>>> So all in all I think we should be going with the multiple IDs in the
>>>> ACCEPT call (ie move the key id from being part of the message into an
>>>> attribute), and have a peer id present in the DONE all for both versions,
>>>> server and client.
>>> To summarize:
>>> ---
>>> The ACCEPT request (from tlshd) would have just the handler class
>>> "Which handler is responding". The kernel uses that to find a
>>> handshake request waiting for that type of handler. In our case,
>>> "tlshd".
>>> The ACCEPT response (from the kernel) would have the socket fd,
>>> the handshake parameters, and zero or more peer ID key serial
>>> numbers. (Today, just zero or one peer IDs).
>>>> There is also an errno status in the ACCEPT response, which
>>> the kernel can use to indicate things like "no requests in that
>>> class were found" or that the request was otherwise improperly
>>> formed.
>>> ---
>>> The DONE request (from tlshd) would have the socket fd (and
>>> implicitly, the handler's PID), the session status, and zero
>>> or one remote peer ID key serial numbers.
>>>> The DONE response (from the kernel) is an ACK. (Today it's
>>> more than that, but that's broken and will be removed).
>>> ---
>>> For the DONE request, the session status is one of:
>>> 0: session established -- see @peerid for authentication status
>>> EIO: local error
>>> EACCES: handshake rejected
>>> For server handshake completion:
>>> @peerid contains the remote peer ID if the session was
>>> authenticated, or TLS_NO_PEERID if the session was not
>>> authenticated.
>>> status == EACCES if authentication material was present from
>>> both peers but verification failed.
>>> For client handshake completion:
>>> @peerid contains the remote peer ID if authentication was
>>> requested and the session was authenticated
>>> status == EACCES if authentication was requested and the
>>> session was not authenticated, or if verification failed.
>>> (Maybe client could work like the server side, and the
>>> kernel consumer would need to figure out if it cares
>>> whether there was authentication).
>> Yes, that would be my preference. Always return @peerid
>> for DONE if the TLS session was established.
> 
> You mean if the TLS session was authenticated. The server
> won't receive a remote peer identity if the client peer
> doesn't authenticate.
> 
Ah, yes, forgot about that.
(PSK always 'authenticate' as the identity is that used to
find the appropriate PSK ...)

> 
>> We might also consider returning @peerid with EACCESS
>> to indicate the offending ID.
> 
> I'll look into that.
> 
> 
>>> Is that adequate?
>> Yes, it is.
> 
> What about the narrow set of DONE status values? You've
> recently wanted to add ENOMEM, ENOKEY, and EINVAL to
> this set. My experience is that these status values are
> nearly always obscured before they can get back to the
> requesting user.
> 
> Can the kernel make use of ENOMEM, for example? It might
> be able to retry, I suppose... retrying is not sensible
> for the server side.
> 
The usual problem: Retry or no retry.
Sadly error numbers are no good indicator to that.
Maybe we should take the NVMe approach and add a _different_
attribute indicating whether this particular error status
should be retried.

> 
>> So the only bone of contention is the timeout; as we won't
>> be implementing signals I still think that we should have
>> a 'timeout' attribute. And if only to feed the TLS timeout
>> parameter for gnutls ...
> 
> I'm still not seeing the case for making it an individual
> parameter for each handshake request. Maybe a config
> parameter, if a short timeout is actually needed... even
> then, maybe a built-in timeout is preferable to yet another
> tuning knob that can be abused.
> 
The problem I see is that the kernel-side needs to make forward
progress eventually, and calling into userspace is a good recipe
of violating that principle.
Sending a timeout value as a netlink parameter has the advantage
the both sides are aware that there _is_ a timeout.
The alternative would be an unconditional wait in the kernel,
and a very real possibility of a stuck process.

> I'd like to see some testing results to determine that a
> short timeout is the only way to handle corner cases.
> 
Short timeouts are especially useful for testing and debugging;
timeout handlers are prone to issues, and hence need a really good
bashing to hash out issues.
And not having a timeout is also not a good idea, see above.

But yeah, in theory we could use a configuration timeout in tlshd.

In the end, it's _just_ another netlink attribute, which might
(or might not) be present. Which replaces a built-in value.
I hadn't thought this to be such an issue ...

Cheers,

Hannes

