Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20E44EC939
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348608AbiC3QGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348621AbiC3QGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:06:22 -0400
Received: from bagheera.iewc.co.za (bagheera.iewc.co.za [IPv6:2c0f:f720:0:3:be30:5bff:feec:6f99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C7023D77F;
        Wed, 30 Mar 2022 09:04:33 -0700 (PDT)
Received: from [165.16.203.119] (helo=tauri.local.uls.co.za)
        by bagheera.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nZaYE-0007la-NE; Wed, 30 Mar 2022 17:48:02 +0200
Received: from [192.168.42.207]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nZZoV-00018E-Pe; Wed, 30 Mar 2022 17:00:47 +0200
Message-ID: <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
Date:   Wed, 30 Mar 2022 17:00:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <E1nZMdl-0006nG-0J@plastiekpoot>
 <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
 <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/03/30 15:56, Neal Cardwell wrote:
> On Wed, Mar 30, 2022 at 2:22 AM Jaco Kroon <jaco@uls.co.za> wrote:
>> Hi Eric,
>>
>> On 2022/03/30 05:48, Eric Dumazet wrote:
>>> On Tue, Mar 29, 2022 at 7:58 PM Jaco Kroon <jaco@uls.co.za> wrote:
>>>
>>> I do not think this commit is related to the issue you have.
>>>
>>> I guess you could try a revert ?
>>>
>>> Then, if you think old linux versions were ok, start a bisection ?
>> That'll be interesting, will see if I can reproduce on a non-production
>> host.
>>> Thank you.
>>>
>>> (I do not see why a successful TFO would lead to a freeze after ~70 KB
>>> of data has been sent)
>> I do actually agree with this in that it makes no sense, but disabling
>> TFO definitely resolved the issue for us.
>>
>> Kind Regards,
>> Jaco
> Thanks for the pcap trace! That's a pretty strange trace. I agree with
> Eric's theory that this looks like one or more bugs in a firewall,
> middlebox, or netfilter rule. From the trace it looks like the buggy
> component is sometimes dropping packets and sometimes corrupting them
> so that the client's TCP stack ignores them.
The capture was taken on the client.  So the only firewall there is
iptables, and I redirected all -j DROP statements to a L_DROP chain
which did a -j LOG prior to -j DROP - didn't pick up any drops here.
>
> Interestingly, in that trace the client SYN has a TFO option and
> cookie, but no data in the SYN.

So this allows the SMTP server which in the conversation speaks first to
identify itself to respond with data in the SYN (not sure that was
actually happening but if I recall I did see it send data prior to
receiving the final ACK on the handshake.

>
> The last packet that looks sane/normal is the ACK from the SMTP server
> that looks like:
>
> 00:00:00.000010 IP6 2a00:1450:4013:c16::1a.25 >
> 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . 6260:6260(0) ack 66263 win
> 774 <nop,nop,TS val 1206544341 ecr 331189186>
>
> That's the first ACK that crosses past 2^16. Maybe that is a
> coincidence, or maybe not. Perhaps the buggy firewall/middlebox/etc is

I believe it should be because we literally had this on every single
connection going out to Google's SMTP ... probably 1/100 connections
managed to deliver an email over the connection.  Then again ... 64KB
isn't that much ...

When you state sane/normal, do you mean there is fault with the other
frames that could not be explained by packet loss in one or both of the
directions?

> confused by the TFO option, corrupts its state, and thereafter behaves
> incorrectly past the first 64 KBytes of data from the client.

Only firewalls we've got are netfilter based, and these packets all
passed through the dedicated firewalls at least by the time they reach
here.  No middleboxes on our end, and if this was Google's side there
would be crazy noise be heard, not just me.  I think the trigger is
packet loss between us (as indicated we know they have link congestion
issues in JHB area, it took us the better part of two weeks to get the
first line tech on their side to just query the internal teams and
probably another week to get the response acknowledging this -
mybroadband.co.za has an article about other local ISPs also complaining).

>
> In addition to checking for checksum failures, mentioned by Eric, you
> could look for PAWS failures, something like:
>
>   nstat -az | egrep  -i 'TcpInCsumError|PAWS'

TcpInCsumErrors                 0                  0.0
TcpExtPAWSActive                0                  0.0
TcpExtPAWSEstab                 90092              0.0
TcpExtTCPACKSkippedPAWS         81317              0.0

Not sure what these mean, but i should probably investigate, the latter
two are definitely incrementing.

Appreciate the feedback and for looking at the traces.

Kind Regards,
Jaco

