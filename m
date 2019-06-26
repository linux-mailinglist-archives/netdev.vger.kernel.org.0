Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D705723A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFZUGi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Jun 2019 16:06:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:28776 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfFZUGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 16:06:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 13:06:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,421,1557212400"; 
   d="scan'208";a="170165635"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Jun 2019 13:06:38 -0700
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 26 Jun 2019 13:06:37 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.248]) by
 ORSMSX153.amr.corp.intel.com ([169.254.12.252]) with mapi id 14.03.0439.000;
 Wed, 26 Jun 2019 13:06:37 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Murali Karicheri" <m-karicheri2@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Subject: Re: [PATCH net-next v6 1/8] igb: clear out skb->tstamp after
 reading the txtime
Thread-Topic: [PATCH net-next v6 1/8] igb: clear out skb->tstamp after
 reading the txtime
Thread-Index: AQHVK6JhPjkpa7dX90S71tT+LMvAd6auzVqAgAAF/AA=
Date:   Wed, 26 Jun 2019 20:06:32 +0000
Message-ID: <0F0BD2D0-0021-46F7-984E-D39E0D2D90CC@intel.com>
References: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
 <1561500439-30276-2-git-send-email-vedang.patel@intel.com>
 <4f0681155a6057bf40e281bfc251aba60c296201.camel@intel.com>
In-Reply-To: <4f0681155a6057bf40e281bfc251aba60c296201.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.64]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C6C9D7F9AC364F4786AA3706B9BCDD8D@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeff,

> On Jun 26, 2019, at 12:44 PM, Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com> wrote:
> 
> On Tue, 2019-06-25 at 15:07 -0700, Vedang Patel wrote:
>> If a packet which is utilizing the launchtime feature (via SO_TXTIME
>> socket
>> option) also requests the hardware transmit timestamp, the hardware
>> timestamp is not delivered to the userspace. This is because the
>> value in
>> skb->tstamp is mistaken as the software timestamp.
>> 
>> Applications, like ptp4l, request a hardware timestamp by setting the
>> SOF_TIMESTAMPING_TX_HARDWARE socket option. Whenever a new timestamp
>> is
>> detected by the driver (this work is done in igb_ptp_tx_work() which
>> calls
>> igb_ptp_tx_hwtstamps() in igb_ptp.c[1]), it will queue the timestamp
>> in the
>> ERR_QUEUE for the userspace to read. When the userspace is ready, it
>> will
>> issue a recvmsg() call to collect this timestamp.  The problem is in
>> this
>> recvmsg() call. If the skb->tstamp is not cleared out, it will be
>> interpreted as a software timestamp and the hardware tx timestamp
>> will not
>> be successfully sent to the userspace. Look at skb_is_swtx_tstamp()
>> and the
>> callee function __sock_recv_timestamp() in net/socket.c for more
>> details.
>> 
>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
>> ---
>> drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>> 1 file changed, 1 insertion(+)
> 
> Since this fix is really not needed for the rest of the patch series,
> if you have to do another version of the series, can you drop this
> patch from any future version?  I don't want to keep spinning my
> validation team on a updated version of this patch, that is not really
> being updated.
> 
> I plan to take this version of the patch and will hold onto it for my
> next 1GbE updates to Dave.

This patch is needed for ptp4l to function properly when txtime-assist mode is enabled. So, dropping this patch will break the series. When are you planning to submit the next set of updates to Dave? If a new version is needed, I can plan to send it out after you send your updates.

Thanks,
Vedang
