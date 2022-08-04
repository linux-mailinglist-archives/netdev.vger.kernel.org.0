Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7CE589868
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 09:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiHDHd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 03:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiHDHdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 03:33:25 -0400
Received: from smtp116.iad3a.emailsrvr.com (smtp116.iad3a.emailsrvr.com [173.203.187.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9782250C;
        Thu,  4 Aug 2022 00:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1659598403;
        bh=kYhrOpJX2cllhR3M2EBifKrqWsb/ILqyjRs7YM4OHjU=;
        h=Date:To:From:Subject:From;
        b=ISDfqj1G3uusPVK1E44YDt4hYar4Xj2ivxFzmGL2gWAjMMX2ry49Lhk5J9xt8p7el
         0lrphm899gep807MRhd2qHFAQSvC8nwBSk3Y0FmOAUdFWi1T96aKN1DNXKaNtYKPd7
         VuCcLGRRCETii3jF68+7Qv1MaGuLh6Cie7efqsqo=
X-Auth-ID: antonio@openvpn.net
Received: by smtp23.relay.iad3a.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id A1983239B9;
        Thu,  4 Aug 2022 03:33:22 -0400 (EDT)
Message-ID: <684e4a61-3fe3-00ac-42d2-213e501f14d4@openvpn.net>
Date:   Thu, 4 Aug 2022 09:34:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net> <YtbNBUZ0Kz7pgmWK@lunn.ch>
 <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net> <YuKKJxSFOgOL836y@lunn.ch>
 <52b9d7c9-9f7c-788e-2327-33af63b9c748@openvpn.net>
 <20220803084202.4e249bdb@hermes.local>
 <1219c53f-362e-cd55-73e0-87dfe281ec34@openvpn.net>
 <20220803091942.0e388f5b@hermes.local>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
In-Reply-To: <20220803091942.0e388f5b@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 35c30856-d3b1-47cd-9a9b-4df3cd07592e-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/08/2022 18:19, Stephen Hemminger wrote:
> On Wed, 3 Aug 2022 17:48:45 +0200
> Antonio Quartulli <antonio@openvpn.net> wrote:
> 
>> There must have been some confusion - sorry about that.
>>
>> The repository I linked in my previous email is this very same driver
>> packaged as "out-of-tree" module (i.e. for people running a kernel that
>> does not yet ship ovpn-dco) and contains some compat wrapper.
>>
>>
>> The driver I have submitted to the list is 100% standalone and does not
>> contain any compat code.
>>
>>
>> The only extra component required to do something useful with this
>> driver is the OpenVPN software in userspace.
> 
> 
> Good to here thanks.
> I wonder if there is any chance of having multiple VPN projects
> using same infrastructure. There seems to be some parallel effort
> in L2TP, OpenVPN, etc.

Thanks for rising this point, Stephen.

I also believe it would be nice to re-use as much infrastructure as 
possible (I always strive to reduce code duplication, while keeping core 
building blocks simple and re-usable), however, it seems that the 
various implementations currently do not share much logic.

What could be shared is already shared (i.e. crypto, napi, gso, netdev, 
etc). Handling the data traffic is something that can hardly be shared 
due to different packet manipulation (i.e. encapsulation).

One area that could still be worth exploring might be the queuing 
mechanism that handles packet reception+decryption and 
encryption+transmission. If we factor out the protocol specific bits, we 
might be able to make the high level logic common.

However, so far all my attempts did not lead to anything that could be 
implemented in a reasonable manner.

Still, I believe this is something we could work on in the medium/long-term.


Regards,


-- 
Antonio Quartulli
OpenVPN Inc.
