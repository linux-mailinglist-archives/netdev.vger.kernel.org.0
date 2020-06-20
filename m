Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BC92021AF
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 07:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgFTFca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 01:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFTFca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 01:32:30 -0400
Received: from mail.bugwerft.de (mail.bugwerft.de [IPv6:2a03:6000:1011::59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71995C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 22:32:30 -0700 (PDT)
Received: from [192.168.178.106] (pd95efea6.dip0.t-ipconnect.de [217.94.254.166])
        by mail.bugwerft.de (Postfix) with ESMTPSA id D6ABF42AEE2;
        Sat, 20 Jun 2020 05:32:28 +0000 (UTC)
Subject: Re: Question on DSA switches, IGMP forwarding and switchdev
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
 <20200619215817.GN279339@lunn.ch>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <35040dbb-725d-848e-4589-9516fb869c6f@zonque.org>
Date:   Sat, 20 Jun 2020 07:32:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619215817.GN279339@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks a lot for the quick reply!

On 6/19/20 11:58 PM, Andrew Lunn wrote:
> On Fri, Jun 19, 2020 at 11:31:04PM +0200, Daniel Mack wrote:

>> When an IGMP query enters the switch, it is redirected to the CPU port
>> as all 'external' ports are configured for IGMP/MLP snooping by the
>> driver. The issue that I'm seeing is that the Linux bridge does not
>> forward the IGMP frames to any other port, no matter whether the bridge
>> is in snooping mode or not. This needs to happen however, otherwise the
>> stations will not see IGMP queries, and unsolicited membership reports
>> are not being transferred either.
> 
> I think all the testing i've done in this area i've had the bridge
> acting as the IGMP queirer. Hence it has replied to the query, rather
> than forward it out other ports.

Yes, if the bridge is itself generating the queries, this works.

> To get this far, has the bridge determined it is not the elected
> querier?  I guess it must of done. Otherwise it would not be
> forwarding it.

No, the querier is connected to one of the switch ports in a larger
topology. But the bridge must still forward such frames, otherwise IGMP
queries won't reach the senders, and membership reports won't reach the
querier.

> The problem here is:
> 
> https://elixir.bootlin.com/linux/v5.8-rc1/source/net/dsa/tag_edsa.c#L159

Ah, right!

> Setting offload_fwd_mark means the switch has forwarded the frame as
> needed to other ports of the switch. If the frame is an IGMP query
> frame, and the bridge is not the elected quierer, i guess we need to
> set this false? Or we need an FDB in the switch to forward it. What
> group address is being used?

If such a frame is ingressing, the software bridge must be able to
forward it again. So I suppose we need to set the forward flag to false
here, yes.


Thanks,
Daniel
