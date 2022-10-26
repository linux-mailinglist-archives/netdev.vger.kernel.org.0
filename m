Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A8F60E1B4
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiJZNNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbiJZNNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:13:16 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812F7FC6ED
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:13:15 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id A2AF3240009;
        Wed, 26 Oct 2022 13:13:13 +0000 (UTC)
Message-ID: <572c2695-bf34-32b9-7d87-94e97302ac8a@ovn.org>
Date:   Wed, 26 Oct 2022 15:13:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     i.maximets@ovn.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
To:     Dave Taht <dave.taht@gmail.com>
References: <20221021114921.3705550-1-i.maximets@ovn.org>
 <CAA93jw6G85VNAbzEa9HQFyw6x1cmqR=LAVVJmGBHocEcjaxZzA@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [RFE net-next] net: tun: 1000x speed up
In-Reply-To: <CAA93jw6G85VNAbzEa9HQFyw6x1cmqR=LAVVJmGBHocEcjaxZzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/22 01:22, Dave Taht wrote:
> What does OVS do for automatic QoS configuration in the first place?
> Configure fq_codel? a shaper? what?

By default OVS will set up tc-htb as an egress traffic shaping when
users request QoS.  Netlink interface for it has RATE and PEAKRATE.
And these are not optional, so OVS has to come up with some values.

Link speed is a logically sane value to use as an upper limit, if
not specified.

Other types of classifiers can also be configured including hfsc,
sfq, codel, fq_codel, netem.

Best regards, Ilya Maximets.

> 
> On Fri, Oct 21, 2022 at 5:38 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>>
>> The 10Mbps link speed was set in 2004 when the ethtool interface was
>> initially added to the tun driver.  It might have been a good
>> assumption 18 years ago, but CPUs and network stack came a long way
>> since then.
>>
>> Other virtual ports typically report much higher speeds.  For example,
>> veth reports 10Gbps since its introduction in 2007.
>>
>> Some userspace applications rely on the current link speed in
>> certain situations.  For example, Open vSwitch is using link speed
>> as an upper bound for QoS configuration if user didn't specify the
>> maximum rate.  Advertised 10Mbps doesn't match reality in a modern
>> world, so users have to always manually override the value with
>> something more sensible to avoid configuration issues, e.g. limiting
>> the traffic too much.  This also creates additional confusion among
>> users.
>>
>> Bump the advertised speed to at least match the veth.  10Gbps also
>> seems like a more or less fair assumption these days, even though
>> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
>> and let the application/user decide on a right value for them.
>>
>> Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-July/051958.html
>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>> ---
>>
>> Sorry for the clickbait subject line.  Can change it to something more
>> sensible while posting non-RFE patch.  Something like:
>>
>>   'net: tun: bump the link speed from 10Mbps to 10Gbps'
>>
>> This patch is RFE just to start a conversation.
>>
>>  drivers/net/tun.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 27c6d235cbda..48bb4a166ad4 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -3514,7 +3514,7 @@ static void tun_default_link_ksettings(struct net_device *dev,
>>  {
>>         ethtool_link_ksettings_zero_link_mode(cmd, supported);
>>         ethtool_link_ksettings_zero_link_mode(cmd, advertising);
>> -       cmd->base.speed         = SPEED_10;
>> +       cmd->base.speed         = SPEED_10000;
>>         cmd->base.duplex        = DUPLEX_FULL;
>>         cmd->base.port          = PORT_TP;
>>         cmd->base.phy_address   = 0;
>> --
>> 2.37.3
>>
> 
> 

