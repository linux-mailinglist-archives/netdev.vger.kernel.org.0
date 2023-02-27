Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520ED6A45B5
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjB0PPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjB0PPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:15:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF6D5FE3
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:14:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2D118218E5;
        Mon, 27 Feb 2023 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677510898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IvHmsGye/4KcLT5NYSX+mppshFZNHEXEqdWlXZ8txcs=;
        b=I0tjt57SVKzvaefaSO/7ug+dArv9CzgtB+Yzr/AHtZD2y+GLgxF01FrpgcTpd/9UGZsge3
        Gki/yqtyQhHawuEbfdAnLO+i5rC7wV/Uhh3CmKlwBQk63tpZnSmnU+eC/M+TeQI0m5xU/j
        EESoFeBup70eF1NonDafQYdhYnDOI0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677510898;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IvHmsGye/4KcLT5NYSX+mppshFZNHEXEqdWlXZ8txcs=;
        b=pRk8+UZIVSq0wDNlgl5QEFdc0wXJ4UReO0kJs3Ci+IFg4AD4zH/hQ2ciz4i6ReG6V5rHMy
        gG1mUXR0yXEmViCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D91C913A43;
        Mon, 27 Feb 2023 15:14:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vs7eMfHI/GOxIQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 27 Feb 2023 15:14:57 +0000
Message-ID: <006c4e44-572b-a6f8-9af0-5f568913e7a0@suse.de>
Date:   Mon, 27 Feb 2023 16:14:56 +0100
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
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <1B595556-0236-49F3-A8B0-ECF2332450D4@oracle.com>
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

On 2/27/23 15:59, Chuck Lever III wrote:
> 
> 
>> On Feb 27, 2023, at 4:24 AM, Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 2/24/23 20:19, Chuck Lever wrote:
[ .. ]
>>> +	req = sock->sk->sk_handshake_req;
>>> +	if (!req) {
>>> +		err = -EBUSY;
>>> +		goto out_status;
>>> +	}
>>> +
>>> +	trace_handshake_cmd_done(net, req, sock, fd);
>>> +
>>> +	status = -EIO;
>>> +	if (tb[HANDSHAKE_A_DONE_STATUS])
>>> +		status = nla_get_u32(tb[HANDSHAKE_A_DONE_STATUS]);
>>> +
>> And this makes me ever so slightly uneasy.
>>
>> As 'status' is a netlink attribute it's inevitably defined as 'unsigned'.
>> Yet we assume that 'status' is a negative number, leaving us _technically_ in unchartered territory.
> 
> Ah, that's an oversight.
> 
> 
>> And that is notwithstanding the problem that we haven't even defined _what_ should be in the status attribute.
> 
> It's now an errno value.
> 
> 
>> Reading the code I assume that it's either '0' for success or a negative number (ie the error code) on failure.
>> Which implicitely means that we _never_ set a positive number here.
>> So what would we lose if we declare 'status' to carry the _positive_ error number instead?
>> It would bring us in-line with the actual netlink attribute definition, we wouldn't need
>> to worry about possible integer overflows, yadda yadda...
>>
>> Hmm?
> 
> It can also be argued that errnos in user space are positive-valued,
> therefore, this user space visible protocol should use a positive
> errno.
> 
> 
Thanks.

[ .. ]
>>> +
>>> +/**
>>> + * handshake_req_cancel - consumer API to cancel an in-progress handshake
>>> + * @sock: socket on which there is an ongoing handshake
>>> + *
>>> + * XXX: Perhaps killing the user space agent might also be necessary?
>>
>> I thought we had agreed that we would be sending a signal to the userspace process?
> 
> We had discussed killing the handler, but I don't think it's necessary.
> I'd rather not do something that drastic unless we have no other choice.
> So far my testing hasn't shown a need for killing the child process.
> 
> I'm also concerned that the kernel could reuse the handler's process ID.
> handshake_req_cancel would kill something that is not a handshake agent.
> 
Hmm? If that were the case, wouldn't we be sending the netlink message 
to the
wrong process, to?

And in the absence of any timeout handler: what do we do if userspace is 
stuck / doesn't make forward progress?
At one point TCP will timeout, and the client will close the connection.
Leaving us with (potentially) broken / stuck processes. Sure we would 
need to initiate some cleanup here, no?

>> Ideally we would be sending a SIGHUP, wait for some time on the userspace
>> process to respond with a 'done' message, and send a 'KILL' signal if we
>> haven't received one.
>>
>> Obs: Sending a KILL signal would imply that userspace is able to cope with
>> children dying. Which pretty much excludes pthreads, I would think.
>>
>> Guess I'll have to consult Stevens :-)
> 
> Basically what cancel does is atomically disarm the "done" callback.
> 
> The socket belongs to the kernel, so it will live until the kernel is
> good and through with it.
> 
Oh, the socket does. But the process handling the socket is not.
So even if we close the socket from the kernel there's no guarantee that 
userspace will react to it.

Problem here is with using different key materials.
As the current handshake can only deal with one key at a time the only 
chance we have for several possible keys is to retry the handshake with 
the next key.
But out of necessity we have to use the _same_ connection (as tlshd 
doesn't control the socket). So we cannot close the socket, and hence we 
can't notify userspace to give up the handshake attempt.
Being able to send a signal would be simple; sending SIGHUP to 
userspace, and wait for the 'done' call.
If it doesn't come we can terminate all attempts.
But if we get the 'done' call we know it's safe to start with the next 
attempt.

> 
>>> + *
>>> + * Request cancellation races with request completion. To determine
>>> + * who won, callers examine the return value from this function.
>>> + *
>>> + * Return values:
>>> + *   %0 - Uncompleted handshake request was canceled or not found
>>> + *   %-EBUSY - Handshake request already completed
>>
>> EBUSY? Wouldn't be EAGAIN more approriate?
> 
> I don't think EAGAIN would be appropriate at all. The situation
> is that the handshake completed, so there's no need to call cancel
> again. It's synonym, EWOULDBLOCK, is also not a good semantic fit.
> 
> 
>> After all, the request is everything _but_ busy...
> 
> I'm open to suggestion.
> 
> One option is to use a boolean return value instead of an errno.
> 
> 
Yeah, that's probably better.

BTW: thanks for the tracepoints!

Cheers,

Hannes

