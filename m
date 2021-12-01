Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5527A46470B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346855AbhLAGSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:18:17 -0500
Received: from mga18.intel.com ([134.134.136.126]:4889 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235759AbhLAGSQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 01:18:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="223271595"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="223271595"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 22:14:56 -0800
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="677142079"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.35.160]) ([10.209.35.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 22:14:55 -0800
Message-ID: <a9f1237c-78d5-d64e-6980-a7c7c5f6f5f9@linux.intel.com>
Date:   Tue, 30 Nov 2021 22:14:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 06/14] net: wwan: t7xx: Add AT and MBIM WWAN ports
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-7-ricardo.martinez@linux.intel.com>
 <CAHNKnsRe-88_jXvW4=0rPSDhVTbnJnDoeLpjHS4ouDv3pJXWSg@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsRe-88_jXvW4=0rPSDhVTbnJnDoeLpjHS4ouDv3pJXWSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/9/2021 4:06 AM, Sergey Ryazanov wrote:
> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez wrote:
>> ...
>>   static struct t7xx_port md_ccci_ports[] = {
>> +       {CCCI_UART2_TX, CCCI_UART2_RX, DATA_AT_CMD_Q, DATA_AT_CMD_Q, 0xff,
>> +        0xff, ID_CLDMA1, PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 0, "ttyC0", WWAN_PORT_AT},
>> +       {CCCI_MBIM_TX, CCCI_MBIM_RX, 2, 2, 0, 0, ID_CLDMA1,
>> +        PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 10, "ttyCMBIM0", WWAN_PORT_MBIM},
>> ...
>> +               if (count + CCCI_H_ELEN > txq_mtu &&
>> +                   (port_ccci->tx_ch == CCCI_MBIM_TX ||
>> +                    (port_ccci->tx_ch >= CCCI_DSS0_TX && port_ccci->tx_ch <= CCCI_DSS7_TX)))
>> +                       multi_packet = DIV_ROUND_UP(count, txq_mtu - CCCI_H_ELEN);
> I am just wondering, the chip does support MBIM message fragmentation,
> but does not support AT commands stream (CCCI_UART2_TX) fragmentation.
> Is that the correct conclusion from the code above?
Yes, that is correct.
>
> BTW, you could factor out data fragmentation support to a dedicated
> function to improve code readability. Something like this:
>
> static inline bool port_is_multipacket_capable(... *port)
> {
>          return port->tx_ch == CCCI_MBIM_TX ||
>                 (port->tx_ch >= CCCI_DSS0_TX && port->tx_ch <= CCCI_DSS7_TX);
> }
>
> So condition become something like that:
>
>          if (count + CCCI_H_ELEN > txq_mtu &&
>              port_is_multipacket_capable(port))
>                  multi_packet = DIV_ROUND_UP(count, txq_mtu - CCCI_H_ELEN);

Ricardo


