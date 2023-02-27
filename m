Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB456A47C3
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjB0RVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjB0RVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:21:04 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3A8222FE
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:21:02 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E5FE01FD63;
        Mon, 27 Feb 2023 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677518460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BXH7sNWzlJloz0Cfvif4325pQtBzXVZgf5yqPTfQ87w=;
        b=oG+yG3lctdtNwKWIIgslW3Vp24+HZT+3dXIrdCxklTj1qTza00W1xVps3W29aqyYN7HQMD
        nh0S+eQ9Huw0vTTAkU8aYdUglwwFM4YNogFPct8QoIlk7z9SdnYXejsEIL9dKPwjkwDbzc
        xCywFuIGVFrf2d1TqM07WZAJ7Kj12t4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677518460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BXH7sNWzlJloz0Cfvif4325pQtBzXVZgf5yqPTfQ87w=;
        b=nqO/luLqtfh6pTMuVtk9j8v58b7w47z4noBmX5K775GWIAZs37XmUxBEN0OXOxce0cxnmp
        7lWfCwFhoS7ypSCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A9AB913A43;
        Mon, 27 Feb 2023 17:21:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fnNUJ3zm/GNzXQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 27 Feb 2023 17:21:00 +0000
Message-ID: <71affa5a-d6fa-d76b-10a1-882a9107a3b4@suse.de>
Date:   Mon, 27 Feb 2023 18:21:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Content-Language: en-US
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
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <90C7DF9C-6860-4317-8D01-C60C718C8257@oracle.com>
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

On 2/27/23 16:39, Chuck Lever III wrote:
> 
> 
>> On Feb 27, 2023, at 10:14 AM, Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 2/27/23 15:59, Chuck Lever III wrote:
>>>> On Feb 27, 2023, at 4:24 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>>
>>>> On 2/24/23 20:19, Chuck Lever wrote:
>> [ .. ]
>>>>> +	req = sock->sk->sk_handshake_req;
>>>>> +	if (!req) {
>>>>> +		err = -EBUSY;
>>>>> +		goto out_status;
>>>>> +	}
>>>>> +
>>>>> +	trace_handshake_cmd_done(net, req, sock, fd);
>>>>> +
>>>>> +	status = -EIO;
>>>>> +	if (tb[HANDSHAKE_A_DONE_STATUS])
>>>>> +		status = nla_get_u32(tb[HANDSHAKE_A_DONE_STATUS]);
>>>>> +
>>>> And this makes me ever so slightly uneasy.
>>>>
>>>> As 'status' is a netlink attribute it's inevitably defined as 'unsigned'.
>>>> Yet we assume that 'status' is a negative number, leaving us _technically_ in unchartered territory.
>>> Ah, that's an oversight.
>>>> And that is notwithstanding the problem that we haven't even defined _what_ should be in the status attribute.
>>> It's now an errno value.
>>>> Reading the code I assume that it's either '0' for success or a negative number (ie the error code) on failure.
>>>> Which implicitely means that we _never_ set a positive number here.
>>>> So what would we lose if we declare 'status' to carry the _positive_ error number instead?
>>>> It would bring us in-line with the actual netlink attribute definition, we wouldn't need
>>>> to worry about possible integer overflows, yadda yadda...
>>>>
>>>> Hmm?
>>> It can also be argued that errnos in user space are positive-valued,
>>> therefore, this user space visible protocol should use a positive
>>> errno.
>> Thanks.
>>
>> [ .. ]
>>>>> +
>>>>> +/**
>>>>> + * handshake_req_cancel - consumer API to cancel an in-progress handshake
>>>>> + * @sock: socket on which there is an ongoing handshake
>>>>> + *
>>>>> + * XXX: Perhaps killing the user space agent might also be necessary?
>>>>
>>>> I thought we had agreed that we would be sending a signal to the userspace process?
>>> We had discussed killing the handler, but I don't think it's necessary.
>>> I'd rather not do something that drastic unless we have no other choice.
>>> So far my testing hasn't shown a need for killing the child process.
>>> I'm also concerned that the kernel could reuse the handler's process ID.
>>> handshake_req_cancel would kill something that is not a handshake agent.
>> Hmm? If that were the case, wouldn't we be sending the netlink message to the
>> wrong process, to?
> 
> Notifications go to anyone who is listening for handshake requests
> and contain nothing but the handler class number. "Who is to respond
> to this notification". It is up to those processes to send an ACCEPT
> to the kernel, and then later a DONE.
> 
> So... listeners have to register to get notifications, and the
> registration goes away as soon as the netlink socket is closed. That
> is what the long-lived parent tlshd process does.
> 
> After notification, the handshake is driven entirely by the handshake
> agent (the tlshd child process). The kernel is not otherwise sending
> unsolicited netlink messages to anyone.
> 
> If you're concerned about the response messages that the kernel
> sends back to the handshake agent... any new process would have to
> have a netlink socket open, resolved to the HANDSHAKE family, and
> it would have to recognize the message sequence ID in the response
> message. Very very unlikely that all that would happen.
> 
> 
Yes, agree.

>> And in the absence of any timeout handler: what do we do if userspace is stuck / doesn't make forward progress?
>> At one point TCP will timeout, and the client will close the connection.
>> Leaving us with (potentially) broken / stuck processes. Sure we would need to initiate some cleanup here, no?
> 
> I'm not sure. Test and see.
> 
> In my experience, one peer or the other closes the socket, and the
> other follows suit. The handshake agent hits an error when it tries
> to use the socket, and exits.
> 
> 
Hmm. Yes, if the other side closes the socket we'll have to follow suit.
I'm not sure, though, if a TLS timeout necessarily induces as connection 
close. But okay, let's see how things pan out.

>>>> Ideally we would be sending a SIGHUP, wait for some time on the userspace
>>>> process to respond with a 'done' message, and send a 'KILL' signal if we
>>>> haven't received one.
>>>>
>>>> Obs: Sending a KILL signal would imply that userspace is able to cope with
>>>> children dying. Which pretty much excludes pthreads, I would think.
>>>>
>>>> Guess I'll have to consult Stevens :-)
>>> Basically what cancel does is atomically disarm the "done" callback.
>>> The socket belongs to the kernel, so it will live until the kernel is
>>> good and through with it.
>> Oh, the socket does. But the process handling the socket is not.
>> So even if we close the socket from the kernel there's no guarantee that userspace will react to it.
> 
> If the kernel finishes first (ie, cancels and closes the socket,
> as it is supposed to) the user space endpoint is dead. I don't
> think it matters what the handshake agent does at that point,
> although if this happens frequently, it might amount to a
> resource leak.
> 
> 
>> Problem here is with using different key materials.
>> As the current handshake can only deal with one key at a time
>> the only chance we have for several possible keys is to retry
>> the handshake with the next key.
>> But out of necessity we have to use the _same_ connection
>> (as tlshd doesn't control the socket). So we cannot close
>> the socket, and hence we can't notify userspace to give up the handshake attempt.
>> Being able to send a signal would be simple; sending SIGHUP to userspace, and wait for the 'done' call.
>> If it doesn't come we can terminate all attempts.
>> But if we get the 'done' call we know it's safe to start with the next attempt.
> 
> We solve this problem by enabling the kernel to provide all those
> materials to tlshd in one go.
> 
Ah. Right, that would work, too; provide all possible keys to the 
'accept' call and let the userspace agent figure out what to do with 
them. That makes life certainly easier for the kernel side.

> I don't think there's a "retry" situation here. Once the handshake
> has failed, the client peer has to know to try again. That would
> mean retrying would have to be part of the upper layer protocol.
> Does an NVMe initiator know it has to drive another handshake if
> the first one fails, or does it rely on the handshake itself to
> try all available identities?
> 
> We don't have a choice but to provide all the keys at once and
> let the handshake negotiation deal with it.
> 
> I'm working on DONE passing multiple remote peer IDs back to the
> kernel now. I don't see why ACCEPT couldn't pass multiple peer IDs
> the other way.
> 
Nope. That's not required.
DONE can only ever have one peer id (TLS 1.3 specifies that the client 
sends a list of identities, the server picks one, and sends that one 
back to the client). So for DONE we will only ever have 1 peer ID.
If we allow for several peer IDs to be present in the client ACCEPT 
message then we'd need to include the resulting peer ID in the client 
DONE, too; otherwise we'll need it for the server DONE only.

So all in all I think we should be going with the multiple IDs in the 
ACCEPT call (ie move the key id from being part of the message into an 
attribute), and have a peer id present in the DONE all for both 
versions, server and client.

> Note that currently the handshake upcall mechanism supports only
> one handshake per socket lifetime, as the handshake_req is
> released by the socket's sk_destruct callback.
> 
Oh, that's fine; we'll have one socket per (nvme) connection anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

