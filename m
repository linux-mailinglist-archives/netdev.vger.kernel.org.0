Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC5E2C84F6
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgK3NS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:18:56 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:38490 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgK3NSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:18:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606742335; x=1638278335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5jXmg4UufclX3ah8/cKqatJkP1X5CSE4slPHip0hBjA=;
  b=V7qqex0ykNYm5yhx/ElaarxJR+9YZ4TbfterWkT/jchMvXMK0CECU1Xd
   w2PIF5zCQCM4MNayfQf/ZgrVhFNZ/rC2dj2LspLrMA1kDnok+952VBNDO
   JEx3cSfWFhfyJMMZrKsB0y+pruCZS+TaobjjVOsLfhtz1mbrBc9XdKirX
   EZ5VfXFbBGPG60YnGtk9vcdUuYK751SXGrq+UItJPo6NoRSu/xNAgSfOn
   eijNrkAaAyrZ3rruQua8x/UCUwyhrLjyhZAzaTmrk1bAOioRCU1UWVCE9
   0+a3uehyS2JDuxckHNezPWEa8IqUWQkTCoWyL5ZGuVM2TkhMjM8G4Afr1
   Q==;
IronPort-SDR: C37KgwIk+0AoN18mMjEAY78Z/0rVF9kTytQE+e3Q8bb7IBkqgn0MHD0iuhEuHwxzHIUOvHTm3I
 M9CxsLcOu/c93eMz5ZlX5faYdABa59a+6r8+VoG4zxrAtbG2x6oFDMYtjBHrO4m5u0W2VwKdoC
 YpdfV2GBQ3ZpBeTOodq0AO6G/LZHAMviIgh3zudYzdIgOsfS0WMcilvIrE0NvwZW4SBDvw8p+z
 XKXpkEiakXc1p3SiZ3RH4jWIcRvdKJ08eatbDNUeMzDPNmb5/X18ZPwY4afp/4ALsixIGyc71+
 xmk=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="95242399"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 06:17:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 06:17:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 06:17:49 -0700
Date:   Mon, 30 Nov 2020 14:17:48 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130131748.oqrzjhyf543gj3jo@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128184514.GD2191767@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201128184514.GD2191767@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.11.2020 19:45, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> +/* Add a potentially wrapping 32 bit value to a 64 bit counter */
>> +static inline void sparx5_update_counter(u64 *cnt, u32 val)
>> +{
>> +     if (val < (*cnt & U32_MAX))
>> +             *cnt += (u64)1 << 32; /* value has wrapped */
>> +
>> +     *cnt = (*cnt & ~(u64)U32_MAX) + val;
>> +}
>
>I don't follow what this is doing. Could you give some examples?

The statistics counters comes from different sources, and unfortunately
have different layouts: Some are 32 bit and some a 40 bit, so this
function is a wrapper to be able to handle them in the same way, polling
the counters often enough to be able to catch overruns.

>
>> +static const char *const sparx5_stats_layout[] = {
>> +     "rx_in_bytes",
>> +     "rx_symbol_err",
>> +     "rx_pause",
>> +     "rx_unsup_opcode",
>
>> +static void sparx5_update_port_stats(struct sparx5 *sparx5, int portno)
>> +{
>> +     struct sparx5_port *spx5_port = sparx5->ports[portno];
>> +     bool high_speed_dev = sparx5_is_high_speed_device(&spx5_port->conf);
>
>Reverse christmas tree. Which in this case, means you need to move the
>assignment into the body of the code.

OK.
>
>> +static void sparx5_get_sset_strings(struct net_device *ndev, u32 sset, u8 *data)
>> +{
>> +     struct sparx5_port *port = netdev_priv(ndev);
>> +     struct sparx5  *sparx5 = port->sparx5;
>> +     int idx;
>> +
>> +     if (sset != ETH_SS_STATS)
>> +             return;
>> +
>> +     for (idx = 0; idx < sparx5->num_stats; idx++)
>> +             memcpy(data + idx * ETH_GSTRING_LEN,
>> +                    sparx5->stats_layout[idx], ETH_GSTRING_LEN);
>
>You cannot use memcpy here, because the strings you have defined are
>not ETH_GSTRING_LEN long. We once had a driver which happened to have
>its strings at the end of a page. The memcpy would copy the string,
>but keep going passed the end of string, over the page boundary, and
>trigger a segmentation fault.

Yes, I see that.

Thanks for the comments
/Steen
>
>        Andrew

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
