Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C181D9D14
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgESQn3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 May 2020 12:43:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:5933 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgESQn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:43:28 -0400
IronPort-SDR: Elhj+qxrW9ZaRoXejca9Y8nhJNeXiN7HjGSZRendW0jz1oYyMfICU4IJehuIF3kT/9uLMx6Eed
 FYQzJtTO5fgw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 09:43:28 -0700
IronPort-SDR: +FjcqJDHR9R/Re7HZp4dpz/9ikQyuz/ivoU0Gz9SJLda9voOJwIOIrIrnSEjBElu6sfgAx3xKC
 AdGvDuvCf8ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="466192281"
Received: from stputhen-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.5.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 09:43:27 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Po Liu <po.liu@nxp.com>, Michal Kubecek <mkubecek@suse.cz>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "intel-wired-lan\@lists.osuosl.org" 
        <intel-wired-lan@lists.osuosl.org>,
        "jeffrey.t.kirsher\@intel.com" <jeffrey.t.kirsher@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "m-karicheri2\@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu\@synopsys.com" <Jose.Abreu@synopsys.com>
Subject: RE: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <VE1PR04MB6496D0B1507969D8474F78FC92B90@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <VE1PR04MB6496D0B1507969D8474F78FC92B90@VE1PR04MB6496.eurprd04.prod.outlook.com>
Date:   Tue, 19 May 2020 09:43:27 -0700
Message-ID: <87lflnooy8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Po Liu <po.liu@nxp.com> writes:

> Hi Vinicius,
>
>> -----Original Message-----
>> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Sent: 2020年5月19日 3:34
>> To: Michal Kubecek <mkubecek@suse.cz>; netdev@vger.kernel.org
>> Cc: intel-wired-lan@lists.osuosl.org; jeffrey.t.kirsher@intel.com; Vladimir
>> Oltean <vladimir.oltean@nxp.com>; Po Liu <po.liu@nxp.com>; m-
>> karicheri2@ti.com; Jose.Abreu@synopsys.com
>> Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame
>> preemption
>> 
>> Hi,
>> 
>> Michal Kubecek <mkubecek@suse.cz> writes:
>> 
>> > On Fri, May 15, 2020 at 06:29:44PM -0700, Vinicius Costa Gomes wrote:
>> >> Hi,
>> >>
>> >> This series adds support for configuring frame preemption, as defined
>> >> by IEEE 802.1Q-2018 (previously IEEE 802.1Qbu) and IEEE 802.3br.
>> >>
>> >> Frame preemption allows a packet from a higher priority queue marked
>> >> as "express" to preempt a packet from lower priority queue marked as
>> >> "preemptible". The idea is that this can help reduce the latency for
>> >> higher priority traffic.
>> >>
>> >> Previously, the proposed interface for configuring these features was
>> >> using the qdisc layer. But as this is very hardware dependent and all
>> >> that qdisc did was pass the information to the driver, it makes sense
>> >> to have this in ethtool.
>> >>
>> >> One example, for retrieving and setting the configuration:
>> >>
>> >> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0 Frame
>> >> preemption settings for enp3s0:
>> >>      support: supported
>> >
>> > IMHO we don't need a special bool for this. IIUC this is not a state
>> > flag that would change value for a particular device; either the
>> > device supports the feature or it does not. If it does not, the
>> > ethtool_ops callbacks would return -EOPNOTSUPP (or would not even
>> > exist if the driver has no support) and ethtool would say so.
>> 
>> (I know that the comments below only apply if "ethtool-way" is what's
>> decided)
>> 
>> Cool. Will remove the supported bit.
>
> Shall it move to the link_ksettings fixed supported list? So can be
> checked by the ethtool -k command. I understand that the hw features
> are encouraged listing in the ksettings.

Having it in link_ksettings might make sense, using something like
"frame-preemption: off [fixed]" to mean "not supported" sounds nice.

> The two MACs should all be initialized at driver size. And all frame queues should assigned to the express MAC by default. That looks as normal mode called preemption disable.
> Any frame queues assigned pass preemptable MAC could be called
> preemption enable.

If you mean to have frame-preemption enabled by default, I think it
should be a per-driver decision, and probably disabled by default, at
least in the begining: frame preemption might interact badly with other
features, jumbo frames and EEE come to mind.


Cheers,
--
Vinicius
