Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F43B4B8805
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 13:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiBPMsS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Feb 2022 07:48:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiBPMsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 07:48:17 -0500
Received: from unicorn.mansr.com (unicorn.mansr.com [81.2.72.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560F4202077;
        Wed, 16 Feb 2022 04:48:05 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [81.2.72.235])
        by unicorn.mansr.com (Postfix) with ESMTPS id A047415360;
        Wed, 16 Feb 2022 12:48:03 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 9D701219C0A; Wed, 16 Feb 2022 12:48:03 +0000 (GMT)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <jbe@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: handle hwaccel VLAN tags
References: <20220215145913.10694-1-mans@mansr.com>
        <20220215203606.5hipm6p7b34ja3ed@skbuf>
Date:   Wed, 16 Feb 2022 12:48:03 +0000
In-Reply-To: <20220215203606.5hipm6p7b34ja3ed@skbuf> (Vladimir Oltean's
        message of "Tue, 15 Feb 2022 22:36:06 +0200")
Message-ID: <yw1xee432d18.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Tue, Feb 15, 2022 at 02:59:13PM +0000, Mans Rullgard wrote:
>> Check for a hwaccel VLAN tag on rx and use it if present.  Otherwise,
>> use __skb_vlan_pop() like the other tag parsers do.  This fixes the case
>> where the VLAN tag has already been consumed by the master.
>> 
>> Signed-off-by: Mans Rullgard <mans@mansr.com>
>> ---
>>  net/dsa/tag_lan9303.c | 21 +++++++--------------
>>  1 file changed, 7 insertions(+), 14 deletions(-)
>> 
>> diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
>> index cb548188f813..7fe180941ac4 100644
>> --- a/net/dsa/tag_lan9303.c
>> +++ b/net/dsa/tag_lan9303.c
>> @@ -77,7 +77,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
>>  
>>  static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
>>  {
>> -	__be16 *lan9303_tag;
>>  	u16 lan9303_tag1;
>>  	unsigned int source_port;
>>  
>> @@ -87,14 +86,15 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
>>  		return NULL;
>>  	}
>>  
>> -	lan9303_tag = dsa_etype_header_pos_rx(skb);
>> -
>> -	if (lan9303_tag[0] != htons(ETH_P_8021Q)) {
>> -		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid VLAN marker\n");
>> -		return NULL;
>> +	skb_push_rcsum(skb, ETH_HLEN);
>> +	if (skb_vlan_tag_present(skb)) {
>> +		lan9303_tag1 = skb_vlan_tag_get(skb);
>> +		__vlan_hwaccel_clear_tag(skb);
>> +	} else {
>> +		__skb_vlan_pop(skb, &lan9303_tag1);
>
> Sorry for the bad example, there is no reason to call skb_push_rcsum()
> and skb_pull_rcsum() if we go through the skb_vlan_tag_present() code
> path, just the "else" branch.

I could have realised that myself, had I not simply blindly copied the
example.  Anyway, new patch sent.

-- 
Måns Rullgård
