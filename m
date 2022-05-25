Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814A1533FDA
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 17:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244955AbiEYPCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 11:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245003AbiEYPBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 11:01:32 -0400
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 May 2022 08:01:30 PDT
Received: from smtpcmd0872.aruba.it (smtpcmd0872.aruba.it [62.149.156.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08493AF1F3
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 08:01:29 -0700 (PDT)
Received: from [192.168.1.56] ([79.0.204.227])
        by Aruba Outgoing Smtp  with ESMTPSA
        id tsUqnOLqzY1m9tsUqnPJWz; Wed, 25 May 2022 17:00:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1653490826; bh=YBsuP3ws32I9GclgsdibFLP8cViqNi669R6J0DcwC3k=;
        h=Date:MIME-Version:Subject:To:From:Content-Type;
        b=Sk6x8zELriD9lcbQXuFvT8D4wM2pab3FeJ/EtjQ5b5A8db6RGohh5NAPNlktwOFXu
         T4BA29DtY0ykbZQg2Ho6oQq0QoUwhzP+nW/RRBdNyG0jGXS9AHPm9wEu0BiGfsplRh
         hNYN7VqK3BGfaeE/OeE/A2waIdR7lDBfMGNtSdRe3xO/Qovuek/Ne6UJ7GCznfdQ5W
         JyJOHuFBw1Roo42sqbiEXgwN0w9zGfdWV1jf15/S/WPLzT/5DHgq+LoV6jGNJgbcS2
         ladlz/uHZzvP74zXf75I3rhliDVpHmqF3MKDFVBEc0qcTjsOukbPmSpqKCvev1EX14
         6Gl2q8axjwoIg==
Message-ID: <8b90db13-03ca-3798-2810-516df79d3986@enneenne.com>
Date:   Wed, 25 May 2022 17:00:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [DSA] fallback PTP to master port when switch does not support it
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Matej Zachar <zachar.matej@gmail.com>, netdev@vger.kernel.org
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
 <YktrbtbSr77bDckl@lunn.ch> <20220405124851.38fb977d@kernel.org>
 <20220407094439.ubf66iei3wgimx7d@skbuf>
From:   Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20220407094439.ubf66iei3wgimx7d@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfNSeE5CvX4Rju0sz7dM6Q96isE+38xvxEstF5+2k3L0RYa/QMaSAWLEuWYM3STybAO/FeBHwnzxVfy4XfN5rMOWVul6yA8Wi0f/Hf4TvnkydZbKoaKnc
 2LvHIvTpAUX2bbPs4GDXXZY0Fdkf+c8ug8XzK4CGY4rM6OVG0UpEn2tBl+SrGLAtS+6QXHyvAeEsaPynGZg/EKbFMxcGVRsQyBzsXuF0r22D5aXtxqfBRGNJ
 DAwopzvX5xAH1TjDclibN4LOB97dHEgT8q8mDFLax06awEuztFNBnhKefd/HA+GrC2tAbwocQ0Polhbltc0SeA==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/04/22 11:44, Vladimir Oltean wrote:
> On Tue, Apr 05, 2022 at 12:48:51PM -0700, Jakub Kicinski wrote:
>> On Tue, 5 Apr 2022 00:04:30 +0200 Andrew Lunn wrote:
>>> What i don't like about your proposed fallback is that it gives the
>>> impression the slave ports actually support PTP, when they do not.
>>
>> +1, running PTP on the master means there is a non-PTP-aware switch
>> in the path, which should not be taken lightly.
> 
> +2, the change could probably be technically done, and there are aspects
> worth discussing, but the goal presented here is questionable and it's
> best to not fool ourselves into thinking that the variable queuing delays
> of the switch are taken into account when reporting the timestamps,
> which they aren't.
> 
> I think that by the time you realize that you need PTP hardware
> timestamping on switch ports but you have a PTP-unaware switch
> integrated *into* your system, you need to go back to the drawing board.

IMHO this patch is a great hack but what you say sounds good to me.

However we can modify the patch in order to leave the default behavior as-is but 
adding the ability to enable this hack via DTS flag as follow:

                 ports {
                         #address-cells = <1>;
                         #size-cells = <0>;

                         port@0 {
                                 reg = <0>;
                                 label = "lan1";
                                 allow-ptp-fallback;
                         };

                         port@1 {
                                 reg = <1>;
                                 label = "lan2";
                         };

                         ...

                         port@5 {
                                 reg = <5>;
                                 label = "cpu";
                                 ethernet = <&fec>;

                                 fixed-link {
                                         speed = <1000>;
                                         full-duplex;
                                 };
                         };
                 };

Then the code can do as follow:

static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
{
         struct dsa_slave_priv *p = netdev_priv(dev);
         struct dsa_switch *ds = p->dp->ds;
         int port = p->dp->index;
         struct net_device *master = dsa_slave_to_master(dev);

         /* Pass through to switch driver if it supports timestamping */
         switch (cmd) {
         case SIOCGHWTSTAMP:
                 if (ds->ops->port_hwtstamp_get)
                         return ds->ops->port_hwtstamp_get(ds, port, ifr);
                 if (p->dp->allow_ptp_fallback && master->netdev_ops->ndo_do_ioctl)
                         return master->netdev_ops->ndo_do_ioctl(master, ifr, cmd);
                 break;
         case SIOCSHWTSTAMP:
                 if (ds->ops->port_hwtstamp_set)
                         return ds->ops->port_hwtstamp_set(ds, port, ifr);
                 if (p->dp->allow_ptp_fallback && master->netdev_ops->ndo_do_ioctl)
                         return master->netdev_ops->ndo_do_ioctl(master, ifr, cmd);
                 break;
         }

         return phylink_mii_ioctl(p->dp->pl, ifr, cmd);
}

In this manner the default behavior is to return error if the switch doesn't 
support the PTP functions, but developers can intentionally enable the PTP 
fallback on specific ports only in order to be able to use PTP on buggy hardware.

Can this solution be acceptable?

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
