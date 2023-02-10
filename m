Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D94692196
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjBJPG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjBJPGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:06:55 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819F67394D
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:06:22 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 230D4345C5;
        Fri, 10 Feb 2023 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676041581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JWFnVwGaX15K0LfK1aw0MMmFSgINxawCfJ88zdLEKZE=;
        b=VIiW1YcIXc0Vp6WTJF6+K7GmJ7OApv9N8yKhCB5jf1ixZ/qd7RAQwOYRgnF5jhqg6CkxGw
        Wu8bMfmCN6qopsTH/2rK/og6VZHDMigj/U2R0EmzukBc2AUT8tvcbbQRAl/jEy75jYaNgn
        4w+EPugv9InRPYvKldNa7gHpJjOgYpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676041581;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JWFnVwGaX15K0LfK1aw0MMmFSgINxawCfJ88zdLEKZE=;
        b=+xUj2OgkDTf4PlzgbM+uHXP63bJXzpfA7Ea0abB8bGWCxqn00zUHzdkmlkenRO4avdORYX
        PELAmgrYc3OeOyAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 06F031325E;
        Fri, 10 Feb 2023 15:06:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HuRXOmxd5mMCXAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 10 Feb 2023 15:06:20 +0000
Message-ID: <4a4626dc-65f0-ac09-0cda-fa61d2fa48fc@suse.de>
Date:   Fri, 10 Feb 2023 16:06:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Content-Language: en-US
To:     Chuck Lever III <chuck.lever@oracle.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
 <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
 <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
 <71bb94a96eebadb7cffcc7d4ddb11db366fd9fcf.camel@redhat.com>
 <68DCB255-772E-4F48-BC9B-AE2F50392402@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <68DCB255-772E-4F48-BC9B-AE2F50392402@oracle.com>
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

On 2/10/23 15:31, Chuck Lever III wrote:
> 
> 
>> On Feb 10, 2023, at 6:41 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>>
>> On Thu, 2023-02-09 at 16:34 +0000, Chuck Lever III wrote:
>>>
[ .. ]
>>> All that said, the single pending list can be replaced easily. It
>>> would be straightforward to move it into struct net, for example.
>>
>> In the end I don't see a operations needing a full list traversal.
>> handshake_nl_msg_accept walk that, but it stops at netns/proto matching
>> which should be ~always /~very soon in the typical use-case. And as you
>> said it should be easy to avoid even that.
>>
>> I think it could be useful limiting the number of pending handshake to
>> some maximum, to avoid problems in pathological/malicious scenarios.
> 
> Defending against DoS is sensible. Maybe having a per-net
> maximum of 5 or 10 pending handshakes? handshake_request() can
> return an error code if a handshake is requested while we're
> over that maximum.
> 
Can we check the source settings? Having more than one handshake in the 
queue coming from the same SRC IP/SRC Port seems a bit pointless, 
doesn't it?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

