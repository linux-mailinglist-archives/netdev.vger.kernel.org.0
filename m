Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DF32761D7
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIWURK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgIWURJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:17:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D9BC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 13:17:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3BD111E3E4CA;
        Wed, 23 Sep 2020 13:00:20 -0700 (PDT)
Date:   Wed, 23 Sep 2020 13:17:07 -0700 (PDT)
Message-Id: <20200923.131707.1724242419810377273.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     vladimir.oltean@nxp.com, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, richardcochran@gmail.com
Subject: Re: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923200800.t7y47fagvgffw4ya@soft-dev3.localdomain>
References: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
        <20200923200800.t7y47fagvgffw4ya@soft-dev3.localdomain>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 13:00:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Wed, 23 Sep 2020 22:08:00 +0200

> The 09/23/2020 14:24, Vladimir Oltean wrote:
>> @@ -345,7 +344,23 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>>         info.vid = skb_vlan_tag_get(skb);
>> 
>>         /* Check if timestamping is needed */
>> -       do_tstamp = (ocelot_port_add_txtstamp_skb(ocelot_port, skb) == 0);
>> +       if (ocelot->ptp && (shinfo->tx_flags & SKBTX_HW_TSTAMP)) {
>> +               info.rew_op = ocelot_port->ptp_cmd;
>> +
>> +               if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
>> +                       struct sk_buff *clone;
>> +
>> +                       clone = skb_clone_sk(skb);
>> +                       if (!clone) {
>> +                               kfree_skb(skb);
>> +                               return NETDEV_TX_OK;
> 
> Why do you return NETDEV_TX_OK?
> Because the frame is not sent yet.

Returning anything other than NETDEV_TX_OK will cause the networking stack
to try and requeue 'skb'.
