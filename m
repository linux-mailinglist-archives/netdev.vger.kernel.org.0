Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0D15839B2
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiG1Hnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiG1Hng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:43:36 -0400
X-Greylist: delayed 187 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Jul 2022 00:43:35 PDT
Received: from smtp80.ord1d.emailsrvr.com (smtp80.ord1d.emailsrvr.com [184.106.54.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CAC606BF
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1658994214;
        bh=COnHq0q10jhFOxbkwvLuP4sHO7hzKD2UTU9fvogld5o=;
        h=Date:Subject:To:From:From;
        b=imTyKsUTDpVzxEuwveDG9Vi/iPpqKWnZg0vHRucblp1d5tQO6MuTx+7WB+8L2f2dk
         YW9WYmM4V2DSzo6pGqIjf7+RQEdfKJZq1B33HaqSQhxGDR/ErZ21+856eJAyrStgrV
         eaPQ4qTYUGlrESkf2GsmhGL5N4yvZI+rwrVuiJxg=
X-Auth-ID: antonio@openvpn.net
Received: by smtp3.relay.ord1d.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 9B1F460090;
        Thu, 28 Jul 2022 03:43:33 -0400 (EDT)
Message-ID: <d645f6e1-d977-e2ea-1f8e-0b5458c9438e@openvpn.net>
Date:   Thu, 28 Jul 2022 09:44:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net> <YtbPtkF1Ah9xrBam@lunn.ch>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
In-Reply-To: <YtbPtkF1Ah9xrBam@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 8cf5a843-5e45-45b4-8822-23f11e9ecabf-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 19/07/2022 17:37, Andrew Lunn wrote:
>> +static int ovpn_net_change_mtu(struct net_device *dev, int new_mtu)
>> +{
>> +	if (new_mtu < IPV4_MIN_MTU ||
>> +	    new_mtu + dev->hard_header_len > IP_MAX_MTU)
>> +		return -EINVAL;
> 
> If you set dev->min_mtu and dev->max_mtu, the core will validate this
> for you, see dev_validate_mtu().

Yeah, thanks for the pointer.

> 
>> +static int ovpn_get_link_ksettings(struct net_device *dev,
>> +				   struct ethtool_link_ksettings *cmd)
>> +{
>> +	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported, 0);
>> +	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising, 0);
> 
> These two should not be needed. Look at tun, veth etc, they don't set
> them.

I found this in tun.c:

3512         ethtool_link_ksettings_zero_link_mode(cmd, supported);
3513         ethtool_link_ksettings_zero_link_mode(cmd, advertising);

Which seems a more appropriate version of my code, no?

Regards,

-- 
Antonio Quartulli
OpenVPN Inc.
