Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3CC4D422
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 18:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfFTQtO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jun 2019 12:49:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:40441 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbfFTQtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 12:49:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 09:49:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,397,1557212400"; 
   d="scan'208";a="154181740"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga008.jf.intel.com with ESMTP; 20 Jun 2019 09:49:10 -0700
Received: from orsmsx163.amr.corp.intel.com (10.22.240.88) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Jun 2019 09:49:10 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.248]) by
 ORSMSX163.amr.corp.intel.com ([169.254.9.84]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 09:49:09 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH net-next v4 1/7] igb: clear out tstamp after sending the
 packet
Thread-Topic: [PATCH net-next v4 1/7] igb: clear out tstamp after sending
 the packet
Thread-Index: AQHVJsYWP6DikpavGkiqH8wEAgHHrKak0uSAgABk7YA=
Date:   Thu, 20 Jun 2019 16:49:05 +0000
Message-ID: <A1A5CF42-A7D4-4DC4-9D57-ED0340B04A6F@intel.com>
References: <1560966016-28254-1-git-send-email-vedang.patel@intel.com>
 <1560966016-28254-2-git-send-email-vedang.patel@intel.com>
 <d6655497-5246-c24e-de35-fc6acdad0bf1@gmail.com>
In-Reply-To: <d6655497-5246-c24e-de35-fc6acdad0bf1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.150]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <240ADF7AD22D274989F89AB520E5E961@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 20, 2019, at 3:47 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> 
> 
> On 6/19/19 10:40 AM, Vedang Patel wrote:
>> skb->tstamp is being used at multiple places. On the transmit side, it
>> is used to determine the launchtime of the packet. It is also used to
>> determine the software timestamp after the packet has been transmitted.
>> 
>> So, clear out the tstamp value after it has been read so that we do not
>> report false software timestamp on the receive side.
>> 
>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
>> ---
>> drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>> 1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
>> index fc925adbd9fa..f66dae72fe37 100644
>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>> @@ -5688,6 +5688,7 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
>> 	 */
>> 	if (tx_ring->launchtime_enable) {
>> 		ts = ns_to_timespec64(first->skb->tstamp);
>> +		first->skb->tstamp = 0;
> 
> Please provide more explanations.
> 
> Why only this driver would need this ?
> 
Currently, igb is the only driver which uses the skb->tstamp option on the transmit side (to set the hardware transmit timestamp). All the other drivers only use it on the receive side (to collect and send the hardware transmit timestamp to the userspace after packet has been sent).

So, any driver which supports the hardware txtime in the future will have to clear skb->tstamp to make sure that hardware tx transmit and tx timestamping can be done on the same packet.

Thanks,
Vedang
> 
>> 		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
>> 	} else {
>> 		context_desc->seqnum_seed = 0;
>> 

