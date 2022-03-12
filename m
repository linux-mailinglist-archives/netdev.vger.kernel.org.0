Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD314D6C4E
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 04:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiCLDqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 22:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiCLDqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 22:46:33 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ED52357E3;
        Fri, 11 Mar 2022 19:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647056728; x=1678592728;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HTV/hwnCl3oMlcxgD2OJoaFHgGHJT1oYSwYuj+pbneQ=;
  b=ZApWC8hRHr92muurIkgPvitwI/AJrIwKQdNOtqauTrlYox/hVY1Tlt18
   hFL1dljKUK0y+fjsoddr4djUwPp9E9ql5bxvRdrP7m5H6qTNPa6qGAu98
   DAAaRFhZRdCeCSFgCdqRG+wZXN4vzxlEfhtXyR8SCPbx1C/I9X2aKnVTL
   lhy/REbCm5nrumz3ojyNkoIheFpxBlFgy/RuiAV12s8F0Z2Gx0+IRYPA4
   COs/JVllGRyrL2fqSKOXvxllat7GK6qbGqcqYvZIVjG80KOF9D6tbtZPR
   kR0+LTuqhIEJnbvFdDKAp2JpHOuoWNPv1AR1oYDs/q4Duj8H3PCye8SlS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="237907100"
X-IronPort-AV: E=Sophos;i="5.90,175,1643702400"; 
   d="scan'208";a="237907100"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 19:45:24 -0800
X-IronPort-AV: E=Sophos;i="5.90,175,1643702400"; 
   d="scan'208";a="612368790"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.194.234]) ([10.212.194.234])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 19:45:23 -0800
Message-ID: <fa67d95d-0ce1-e9e1-7d85-097b130e43c9@linux.intel.com>
Date:   Fri, 11 Mar 2022 19:45:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v5 04/13] net: wwan: t7xx: Add port proxy
 infrastructure
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
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-5-ricardo.martinez@linux.intel.com>
 <CAHNKnsTihx8XmNWOSE+Awx+LO0QDq_D-A3zftN0YmMvV8a5Htg@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsTihx8XmNWOSE+Awx+LO0QDq_D-A3zftN0YmMvV8a5Htg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/6/2022 6:52 PM, Sergey Ryazanov wrote:
> On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Port-proxy provides a common interface to interact with different types
>> of ports. Ports export their configuration via `struct t7xx_port` and
>> operate as defined by `struct port_ops`.
> [skipped]
...
> +/* Channel ID and Message ID definitions.
> + * The channel number consists of peer_id(15:12) , channel_id(11:0)
> + * peer_id:
> + * 0:reserved, 1: to sAP, 2: to MD
> + */
> +enum port_ch {
> +       /* to MD */
> +       PORT_CH_CONTROL_RX = 0x2000,
> +       PORT_CH_CONTROL_TX = 0x2001,
> +       PORT_CH_UART1_RX = 0x2006,      /* META */
> +       PORT_CH_UART1_TX = 0x2008,
> +       PORT_CH_UART2_RX = 0x200a,      /* AT */
> +       PORT_CH_UART2_TX = 0x200c,
> +       PORT_CH_MD_LOG_RX = 0x202a,     /* MD logging */
> +       PORT_CH_MD_LOG_TX = 0x202b,
> +       PORT_CH_LB_IT_RX = 0x203e,      /* Loop back test */
> +       PORT_CH_LB_IT_TX = 0x203f,
> +       PORT_CH_STATUS_RX = 0x2043,     /* Status polling */
> There is no STATUS_TX channel, so how is the polling performed? Is it
> performed through the CONTROL_TX channel? Or should the comment be
> changed to "status events"?
Currently there's no port listening to this channel, the suggested 
comment would be more accurate.
>> +       PORT_CH_MIPC_RX = 0x20ce,       /* MIPC */
>> +       PORT_CH_MIPC_TX = 0x20cf,
>> +       PORT_CH_MBIM_RX = 0x20d0,
>> +       PORT_CH_MBIM_TX = 0x20d1,
>> +       PORT_CH_DSS0_RX = 0x20d2,
>> +       PORT_CH_DSS0_TX = 0x20d3,
>> +       PORT_CH_DSS1_RX = 0x20d4,
>> +       PORT_CH_DSS1_TX = 0x20d5,
>> +       PORT_CH_DSS2_RX = 0x20d6,
>> +       PORT_CH_DSS2_TX = 0x20d7,
>> +       PORT_CH_DSS3_RX = 0x20d8,
>> +       PORT_CH_DSS3_TX = 0x20d9,
>> +       PORT_CH_DSS4_RX = 0x20da,
>> +       PORT_CH_DSS4_TX = 0x20db,
>> +       PORT_CH_DSS5_RX = 0x20dc,
>> +       PORT_CH_DSS5_TX = 0x20dd,
>> +       PORT_CH_DSS6_RX = 0x20de,
>> +       PORT_CH_DSS6_TX = 0x20df,
>> +       PORT_CH_DSS7_RX = 0x20e0,
>> +       PORT_CH_DSS7_TX = 0x20e1,
>> +};
>> +
>> ...
>> +
>> +struct t7xx_port_static {
...
>> +int t7xx_port_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
>> +{
>> +       struct ccci_header *ccci_h;
>> +       unsigned long flags;
>> +       u32 channel;
>> +       int ret = 0;
>> +
>> +       spin_lock_irqsave(&port->rx_wq.lock, flags);
>> +       if (port->rx_skb_list.qlen >= port->rx_length_th) {
>> +               port->flags |= PORT_F_RX_FULLED;
>> +               spin_unlock_irqrestore(&port->rx_wq.lock, flags);
>> +
>> +               return -ENOBUFS;
>> +       }
>> +       ccci_h = (struct ccci_header *)skb->data;
>> +       port->flags &= ~PORT_F_RX_FULLED;
>> +       if (port->flags & PORT_F_RX_ADJUST_HEADER)
>> +               t7xx_port_adjust_skb(port, skb);
>> +       channel = FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status));
>> +       if (channel == PORT_CH_STATUS_RX) {
>> +               ret = port->skb_handler(port, skb);
> This handler will never be called. A message with channel =
> PORT_CH_STATUS_RX will be dropped in the t7xx_port_proxy_recv_skb()
> function, since the corresponding port is nonexistent.
>
>> +       } else {
>> +               if (port->wwan_port)
>> +                       wwan_port_rx(port->wwan_port, skb);
>> +               else
>> +                       __skb_queue_tail(&port->rx_skb_list, skb);
>> +       }
>> +       spin_unlock_irqrestore(&port->rx_wq.lock, flags);
>> +
>> +       wake_up_all(&port->rx_wq);
>> +       return ret;
>> +}
> Whole this function looks like a big unintentional duct tape. On the
> one hand, each port type has a specific recv_skb callback. But in
> fact, all message processing paths pass through this place. And here
> the single function forced to take into account the specialties of
> each port type:
> a) immediately passes status events to the handler via the indirect call;
> b) enqueues control messages to the rx queue;
> c) directly passes WWAN management (MBIM & AT) message to the WWAN subsystem.
>
> I would like to suggest the following reworking plan for the function:
> 1) move the common processing code (header stripping code) to the
> t7xx_port_proxy_recv_skb() function, where it belongs;
> 2) add a dedicated port ops for the PORT_CH_STATUS_RX channel and call
> control_msg_handler() from its recv_skb callback (lets call it
> t7xx_port_status_recv_skb()); this will solve both issues: status
> messages will no more dropped and status message hook will be removed;
> 3) move the wwan_port_rx() call to the t7xx_port_wwan_recv_skb()
> callback; this will remove another one hook;
> 4) finally rename t7xx_port_recv_skb() to t7xx_port_enqueue_skb(),
> since after the hooks removing, the only purpose of this function will
> be to enqueue received skb(s).

Thanks for the suggestions.

After the changes this function will just figure out the channel by 
reading the CCCI header and invoke the corresponding port's recv_skb().

I do not think we want to remove the CCCI header yet since recv_skb() 
may fail and the caller might decide to try again later.

The generic t7xx_port_enqueue_skb() function will remove the CCCI header 
before enqueuing the skb, t7xx_port_wwan_recv_skb() should do the same 
before calling wwan_port_rx().

...

>> +{
>> +       struct t7xx_port_static *port_static = port->port_static;
>> +       struct t7xx_fsm_ctl *ctl = port->t7xx_dev->md->fsm_ctl;
>> +       struct cldma_ctrl *md_ctrl;
>> +       enum md_state md_state;
>> +       unsigned int fsm_state;
>> +
>> +       md_state = t7xx_fsm_get_md_state(ctl);
>> +
>> +       fsm_state = t7xx_fsm_get_ctl_state(ctl);
>> +       if (fsm_state != FSM_STATE_PRE_START) {
>> +               if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2)
>> +                       return -ENODEV;
>> +
>> +               if (md_state == MD_STATE_EXCEPTION && port_static->tx_ch != PORT_CH_MD_LOG_TX &&
>> +                   port_static->tx_ch != PORT_CH_UART1_TX)
> There are no ports defined for PORT_CH_MD_LOG_TX and PORT_CH_UART1_TX
> channels, should this check be removed?

PORT_CH_UART1_TX should be removed, but PORT_CH_MD_LOG_TX is going to be used by the upcoming modem logging port feature.
...


