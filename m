Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EF54EE562
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 02:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243538AbiDAAf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 20:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiDAAf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 20:35:27 -0400
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3:d6ae:52ff:feb8:f27b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F7C44A2F;
        Thu, 31 Mar 2022 17:33:34 -0700 (PDT)
Received: from [2c0f:f720:fe16:c400::1] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1na5EJ-0004XG-81; Fri, 01 Apr 2022 02:33:31 +0200
Received: from [192.168.42.210]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1na5ED-0002Pg-UO; Fri, 01 Apr 2022 02:33:26 +0200
Message-ID: <4b4ff443-f8a9-26a8-8342-ae78b999335b@uls.co.za>
Date:   Fri, 1 Apr 2022 02:33:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <E1nZMdl-0006nG-0J@plastiekpoot>
 <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
 <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CANn89i+KsjGUppc3D8KLa4XUd-dzS3A+yDxbv2bRkDEkziS1qw@mail.gmail.com>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <CANn89i+KsjGUppc3D8KLa4XUd-dzS3A+yDxbv2bRkDEkziS1qw@mail.gmail.com>
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

On 2022/04/01 02:10, Eric Dumazet wrote:
> On Thu, Mar 31, 2022 at 4:06 PM Jaco Kroon <jaco@uls.co.za> wrote:
>> Hi Neal,
>>
>> This sniff was grabbed ON THE CLIENT HOST.  There is no middlebox or
>> anything between the sniffer and the client.  Only the firewall on the
>> host itself, where we've already establish the traffic is NOT DISCARDED
>> (at least not in filter/INPUT).
>>
>> Setup on our end:
>>
>> 2 x routers, usually each with a direct peering with Google (which is
>> being ignored at the moment so instead traffic is incoming via IPT over DD).
>>
>> Connected via switch to
>>
>> 2 x firewalls, of which ONE is active (they have different networks
>> behind them, and could be active / standby for different networks behind
>> them - avoiding active-active because conntrackd is causing more trouble
>> than it's worth), Linux hosts, using netfilter, has been operating for
>> years, no recent kernel upgrades.
> Next step would be to attempt removing _all_ firewalls, especially not
> common setups like yours.
That I'm afraid is not going to happen here.  I can't imagine what we're
doing is that uncommon.  On the host basically for INPUT drop invalid,
ACCEPT related established, accept specific ports, drop everything
else.  Other than the redirects in NAT there really isn't anything "funny".
>
> conntrack had a bug preventing TFO deployment for a while, because
> many boxes kept buggy kernel versions for years.

We don't use conntrackd, we tried many years back, but eventually we
just ended up using ucarp with /32s on the interfaces and whatever
subnet is required for the floating IP itself, combined with OSPF to
sort out the routing, that way we get to avoid asymmetric routing and
the need for conntrackd.  The core firewalls basically on FORWARD does
some directing based on ingress and/or egress interface to determine
ruleset to apply, again INVALID and RELATED,ESTABLISHED rules at the head.

>
> 356d7d88e088687b6578ca64601b0a2c9d145296 netfilter: nf_conntrack: fix
> tcp_in_window for Fast Open

This is from Aug 9, 2013 ... our firewall's kernel isn't that old :). 
Again, the traffic was sniffed on the client side of that firewall, and
the only firewall between the sniffer and the processing part of the
kernel is the local netfilter.

I'll deploy same on a dev host we've got in the coming week and start a
bisect process.

Kind Regards,
Jaco

