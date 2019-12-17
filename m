Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B2312361C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfLQT5k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Dec 2019 14:57:40 -0500
Received: from mga18.intel.com ([134.134.136.126]:13873 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbfLQT5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 14:57:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 11:57:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="212487473"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga007.fm.intel.com with ESMTP; 17 Dec 2019 11:57:38 -0800
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.124]) by
 FMSMSX103.amr.corp.intel.com ([169.254.2.119]) with mapi id 14.03.0439.000;
 Tue, 17 Dec 2019 11:57:38 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
Thread-Topic: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
Thread-Index: AQHVtGD6wfSrkAg3wE2y4cWf1VMoIKe+vkZQ
Date:   Tue, 17 Dec 2019 19:57:38 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
References: <20191216223344.2261-1-olteanv@gmail.com>
In-Reply-To: <20191216223344.2261-1-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTkyM2I3NTMtYTliNy00MmMwLWJmZmUtNmVmOThhNjQwNTZmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiV1BBNHFGc0xHSUp6N3hseTd2b0VJMlwvb2M0S205NTlQTkJrSEFIS2o4WmEwT0tvOWdNQjhzRGk2NGRwajh1ekMifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Vladimir Oltean
> Sent: Monday, December 16, 2019 2:34 PM
> To: davem@davemloft.net; jakub.kicinski@netronome.com
> Cc: richardcochran@gmail.com; f.fainelli@gmail.com; vivien.didelot@gmail.com;
> andrew@lunn.ch; netdev@vger.kernel.org; Vladimir Oltean
> <olteanv@gmail.com>
> Subject: [PATCH net] net: dsa: sja1105: Fix double delivery of TX timestamps to
> socket error queue
> 
> On the LS1021A-TSN board, it can be seen that under rare conditions,
> ptp4l gets unexpected extra data in the event socket error queue.
> 
> This is because the DSA master driver (gianfar) has TX timestamping
> logic along the lines of:
> 
> 1. In gfar_start_xmit:
> 	do_tstamp = (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> 		    priv->hwts_tx_en;
> 	(...)
> 	if (unlikely(do_tstamp))
> 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> 2. Later in gfar_clean_tx_ring:
> 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
> 		(...)
> 		skb_tstamp_tx(skb, &shhwtstamps);

I'm not sure I fully understand the problem.

> 
> That is to say, between the first and second check, it drops
> priv->hwts_tx_en (it assumes that it is the only one who can set
> SKBTX_IN_PROGRESS, disregarding stacked net devices such as DSA switches
> or PTP-capable PHY drivers). Any such driver (like sja1105 in this case)
> that would set SKBTX_IN_PROGRESS would trip up this check and gianfar
> would deliver a garbage TX timestamp for this skb too, which can in turn
> have unpredictable and surprising effects to user space.
> 
> In fact gianfar is by far not the only driver which uses
> SKBTX_IN_PROGRESS to identify skb's that need special handling. The flag
> used to have a historical purpose and is now evaluated in the networking
> stack in a single place: in __skb_tstamp_tx, only on the software
> timestamping path (hwtstamps == NULL) which is not relevant for us.
> 
> So do the wise thing and drop the unneeded assignment. Even though this
> patch alone will not protect against all classes of Ethernet driver TX
> timestamping bugs, it will circumvent those related to the incorrect
> interpretation of this skb tx flag.
>

I thought the point of SKBTX_IN_PROGRESS was to inform the stack that a timestamp was pending. By not setting it, you no longer do this.

Maybe that has changed since the original implementation? Or am I misunderstanding this patch..?

You're removing the sja1105 assignment, not the one from the gianfar. Hmm

Ok, so the issue is that sja1105_ptp.c was incorrectly setting the flag.

Would it make more sense for gianfar to set SKBTX_IN_PROGRESS, but then use some other indicator internally, so that other callers who set it don't cause the gianfar driver to behave incorrectly? I believe we handle it in the Intel drivers that way by storing the skb. Then we don't check the SKBTX_IN_PROGRESS later.

Thanks,
Jake 
 
> Fixes: 47ed985e97f5 ("net: dsa: sja1105: Add logic for TX timestamping")
> Suggested-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_ptp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c
> b/drivers/net/dsa/sja1105/sja1105_ptp.c
> index 54258a25031d..038c83fbd9e8 100644
> --- a/drivers/net/dsa/sja1105/sja1105_ptp.c
> +++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
> @@ -668,8 +668,6 @@ void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int
> slot,
>  	u64 ticks, ts;
>  	int rc;
> 
> -	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> -
>  	mutex_lock(&ptp_data->lock);
> 
>  	rc = sja1105_ptpclkval_read(priv, &ticks, NULL);
> --
> 2.17.1

