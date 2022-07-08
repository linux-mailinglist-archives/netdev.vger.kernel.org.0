Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDDA56B336
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbiGHHMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiGHHMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:12:50 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9287696F;
        Fri,  8 Jul 2022 00:12:48 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 910741887361;
        Fri,  8 Jul 2022 07:12:46 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 8876325032B7;
        Fri,  8 Jul 2022 07:12:46 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 70813A1E00B7; Fri,  8 Jul 2022 07:12:46 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 08 Jul 2022 09:12:46 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: dsa: mv88e6xxx: allow reading FID when
 handling ATU violations
In-Reply-To: <20220707102836.u7ig6rr2664mcrlf@skbuf>
References: <20220706122502.1521819-1-netdev@kapio-technology.com>
 <20220707102836.u7ig6rr2664mcrlf@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <f8a4f54a90efa545cac1ff2cdbde78c7@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-07 12:28, Vladimir Oltean wrote:
> On Wed, Jul 06, 2022 at 02:25:02PM +0200, Hans Schultz wrote:
>> For convenience the function mv88e6xxx_g1_atu_op() has been used to 
>> read
>> ATU violations, but the function has other purposes and does not 
>> enable
>> the possibility to read the FID when reading ATU violations.
>> 
>> The FID is needed to get hold of which VID was involved in the 
>> violation,
>> thus the need for future purposes to be able to read the FID.
> 
> Make no mistake, the existing code doesn't disallow reading back the 
> FID
> during an ATU Get/Clear Violation operation, and your patch isn't
> "allowing" something that wasn't disallowed.

It would only read 0 the way it worked. And I don't understand why
mv88e6xxx_g1_atu_op() writes the FID?

> 
> The documentation for the ATU FID register says that its contents is
> ignored before the operation starts, and it contains the returned ATU
> entry's FID after the operation completes.
> 
> So the change simply says: don't bother to write the ATU FID register
> with zero, it doesn't matter what this contains. This is probably true,
> but the patch needs to do what's written on the box.

Writing 0 to the ATU fID register resulted in a read giving zero of 
course.

> 
> Please note that this only even matters at all for switches with
> mv88e6xxx_num_databases(chip) > 256, where MV88E6352_G1_ATU_FID is a
> dedicated register which this patch avoids writing. For other switches,
> the FID is embedded within MV88E6XXX_G1_ATU_CTL or MV88E6XXX_G1_ATU_OP.
> So _practically_, for those switches, you are still emitting the
> GET_CLR_VIOLATION ATU op with a FID of 0 whether you like it or not, 
> and
> this patch introduces a (most likely irrelevant) discrepancy between 
> the
> access methods for various switches.
> 
> Please note that this observation is relevant for your future changes 
> to
> read back the FID too. As I said here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-4-schultz.hans+netdev@gmail.com/#24912482
> you can't just assume that the FID lies within the MV88E6352_G1_ATU_FID
> register, just look at the way it is packed within 
> mv88e6xxx_g1_atu_op().
> You'll need to unpack it in the same way.

So I need a new function to read the FID that mimics 
mv88e6xxx_g1_atu_op()
as far as I understand?
