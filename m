Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54764534AF5
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 09:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343515AbiEZHpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 03:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiEZHpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 03:45:47 -0400
Received: from smtpcmd10102.aruba.it (smtpcmd10102.aruba.it [62.149.156.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C236A3098
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 00:45:45 -0700 (PDT)
Received: from [192.168.1.56] ([79.0.204.227])
        by Aruba Outgoing Smtp  with ESMTPSA
        id u8Bgn1LFacKJdu8BgnlS5C; Thu, 26 May 2022 09:45:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1653551143; bh=cQA6Az6uyY2YU/mHvWmWAwyZ2RgH4N8lmwwSkKJxKMI=;
        h=Date:MIME-Version:Subject:To:From:Content-Type;
        b=lLp+55n3DglJ7gMl7Ve+EvRLyNh8294SZfutvhmZyis7BI7NhCyrF178n2CvbXD71
         FTmCkCbG4BOs7Sl2lpC8x90B8dpE5pC9i4GahAWBlRFgcZC5w5wDDieZtIKPI18BoO
         tADIxfHi4sppi5lkDU3r8osgDLXebik6jeuZ2BPO5OOH+1P18Q/Mo+yASMY8ceHKWi
         K9b8rynmVuQBb4mqoShMNW20jPgisN5aLOGFD+SJFioqedVRpBCaij2G7jgJPK0vLh
         PbXts0TDV35K+PfuPJ9dRZTKAhlKSURoiu7Y8m9DkLvaaYFmlS46MZp19kfwpyaCi/
         v7vZIlloRseFg==
Message-ID: <a554a5cd-541c-ebe5-c70e-953d0b8b1b87@enneenne.com>
Date:   Thu, 26 May 2022 09:45:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [DSA] fallback PTP to master port when switch does not support it
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Matej Zachar <zachar.matej@gmail.com>, netdev@vger.kernel.org
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
 <YktrbtbSr77bDckl@lunn.ch> <20220405124851.38fb977d@kernel.org>
 <20220407094439.ubf66iei3wgimx7d@skbuf>
 <8b90db13-03ca-3798-2810-516df79d3986@enneenne.com>
 <20220525155536.7kjqwnp6cepmrngr@skbuf>
From:   Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20220525155536.7kjqwnp6cepmrngr@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKlMjCNqX4qQ+MrlTOSDJiHgg35d9bs9lRwIuR5EhaJuobojJhQo5II/BZwraVdbWTJSLElR204clQrbs7LuPlszX9zz8VAXXJA/0qDM8ixy/2tkvsxW
 ud5XB9iVugrUBjxoVGh+Zkz/9YlhwzbGepGYXi/P5of3ZzT+0spzBgrJbYtsZkb55A7p8K1ReRdUZa6EcXCxenD1vprn00elB/R+X6MvVYvA79RTAK3hB4bu
 IAAsjlpuCZAWnoeAAfTBoySRmxggwjom7nuaa06PcS15XZsHFIg2fzEPYZiNyOXfmHgjgwVi0JJvsOPiOo0DBw==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/22 17:55, Vladimir Oltean wrote:
> On Wed, May 25, 2022 at 05:00:24PM +0200, Rodolfo Giometti wrote:
>> On 07/04/22 11:44, Vladimir Oltean wrote:
>>> On Tue, Apr 05, 2022 at 12:48:51PM -0700, Jakub Kicinski wrote:
>>>> On Tue, 5 Apr 2022 00:04:30 +0200 Andrew Lunn wrote:
>>>>> What i don't like about your proposed fallback is that it gives the
>>>>> impression the slave ports actually support PTP, when they do not.
>>>>
>>>> +1, running PTP on the master means there is a non-PTP-aware switch
>>>> in the path, which should not be taken lightly.
>>>
>>> +2, the change could probably be technically done, and there are aspects
>>> worth discussing, but the goal presented here is questionable and it's
>>> best to not fool ourselves into thinking that the variable queuing delays
>>> of the switch are taken into account when reporting the timestamps,
>>> which they aren't.
>>>
>>> I think that by the time you realize that you need PTP hardware
>>> timestamping on switch ports but you have a PTP-unaware switch
>>> integrated *into* your system, you need to go back to the drawing board.
>>
>> IMHO this patch is a great hack but what you say sounds good to me.
> 
> How many Ethernet connections are there between the switch and the host?

It depends how the hardware is designed. However usually the host has an 
ethernet connected to a switch's port named CPU port, so just one.

> One alternative which requires no code changes is to connect one more
> switch port and run PTP at your own risk on the attached FEC port
> (not DSA master).

I see, but here we are talking about of not-so-well designed boards :( whose 
have a switch that can't manage PTP and we still need to have a sort of time 
sync. The trick can be to forward PTP packets to the host's ethernet (and 
viceversa).

> What switch driver is it? There are 2 paths to be discussed.
> On TX, does the switch forward DSA-untagged packets from the host port? Where to?
> On RX, does the switch tag all packets with a DSA header towards the
> host? I guess yes,

Of course it's in charge of the DSA to properly setup the switch in order to 
abstract all switch's ports as host's ethernet ports, so all packets go where 
they have to go.

> but in that case, be aware that not many Ethernet
> controllers can timestamp non-PTP packets. And you need anyway to demote
> e.g. HWTSTAMP_FILTER_PTP_V2_EVENT to HWTSTAMP_FILTER_ALL when you pass
> the request to the master to account for that, which you are not doing.

Mmm... I can't see problems here... can you please explain it?

>> However we can modify the patch in order to leave the default behavior as-is
>> but adding the ability to enable this hack via DTS flag as follow:
>>
>>                  ports {
>>                          #address-cells = <1>;
>>                          #size-cells = <0>;
>>
>>                          port@0 {
>>                                  reg = <0>;
>>                                  label = "lan1";
>>                                  allow-ptp-fallback;
>>                          };
>>
>>                          port@1 {
>>                                  reg = <1>;
>>                                  label = "lan2";
>>                          };
>>
>>                          ...
>>
>>                          port@5 {
>>                                  reg = <5>;
>>                                  label = "cpu";
>>                                  ethernet = <&fec>;
>>
>>                                  fixed-link {
>>                                          speed = <1000>;
>>                                          full-duplex;
>>                                  };
>>                          };
>>                  };
>>
>> Then the code can do as follow:
>>
>> static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>> {
>>          struct dsa_slave_priv *p = netdev_priv(dev);
>>          struct dsa_switch *ds = p->dp->ds;
>>          int port = p->dp->index;
>>          struct net_device *master = dsa_slave_to_master(dev);
>>
>>          /* Pass through to switch driver if it supports timestamping */
>>          switch (cmd) {
>>          case SIOCGHWTSTAMP:
>>                  if (ds->ops->port_hwtstamp_get)
>>                          return ds->ops->port_hwtstamp_get(ds, port, ifr);
>>                  if (p->dp->allow_ptp_fallback && master->netdev_ops->ndo_do_ioctl)
>>                          return master->netdev_ops->ndo_do_ioctl(master, ifr, cmd);
>>                  break;
>>          case SIOCSHWTSTAMP:
>>                  if (ds->ops->port_hwtstamp_set)
>>                          return ds->ops->port_hwtstamp_set(ds, port, ifr);
>>                  if (p->dp->allow_ptp_fallback && master->netdev_ops->ndo_do_ioctl)
>>                          return master->netdev_ops->ndo_do_ioctl(master, ifr, cmd);
>>                  break;
>>          }
>>
>>          return phylink_mii_ioctl(p->dp->pl, ifr, cmd);
>> }
>>
>> In this manner the default behavior is to return error if the switch doesn't
>> support the PTP functions, but developers can intentionally enable the PTP
>> fallback on specific ports only in order to be able to use PTP on buggy
>> hardware.
>>
>> Can this solution be acceptable?
> 
> Generally we don't allow policy configuration through the device tree.

I agree, but here we have to signal an hardware that can't do something and 
(IMHO) the device tree is a good point to address it. :)

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
