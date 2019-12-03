Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FE3110359
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 18:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfLCRWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 12:22:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:12474 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfLCRWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 12:22:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 09:22:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,273,1571727600"; 
   d="scan'208";a="412264299"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 03 Dec 2019 09:22:49 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: tperf: An initial TSN Performance Utility
In-Reply-To: <20191203142745.GA2680@khorivan>
References: <BN8PR12MB3266E99E5C289CB6B77A5C58D3420@BN8PR12MB3266.namprd12.prod.outlook.com> <20191203142745.GA2680@khorivan>
Date:   Tue, 03 Dec 2019 09:22:55 -0800
Message-ID: <87blsp9vdc.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> writes:

> On Tue, Dec 03, 2019 at 10:00:15AM +0000, Jose Abreu wrote:
>>Hi netdev,
>>
>>[ I added in cc the people I know that work with TSN stuff, please add
>>anyone interested ]
>>
>>We are currently using a very basic tool for monitoring the CBS
>>performance of Synopsys-based NICs which we called tperf. This was based
>>on a patchset submitted by Jesus back in 2017 so credits to him and
>>blames on me :)
>>
>>The current version tries to send "dummy" AVTP packets, and measures the
>>bandwidth of both receiver and sender. By using this tool in conjunction
>>with iperf3 we can check if CBS reserved queues are behaving correctly
>>by reserving the priority traffic for AVTP packets.
>>
>>You can checkout the tool in the following address:
>>	GitHub: https://github.com/joabreu/tperf
>>
>>We are open to improve this to more robust scenarios, so that we can
>>have a common tool for TSN testing that's at the same time light
>>weighted and precise.
>>
>>Anyone interested in helping ?

@Jose, that's really nice. I will play with it for sure.

>
> I've also have tool that already includes similar functionality.
>
> https://github.com/ikhorn/plget
>
> It's also about from 2016-2017 years.
> Not ideal, but it helped me a lot for last years. Also worked with XDP, but
> libbpf library is old already and should be updated. But mostly it was used to
> get latencies and observe hw ts how packets are put on the line.
>
> I've used it for CBS and for TAPRIO scheudler testing, observing h/w ts of each
> packet, closed and open gates, but a target board should support hw ts to be
> accurate, that's why ptp packets were used.
>
> It includes also latency measurements based as on hw timestamp as on software
> ts.

@Ivan, I took a look at plget some time ago. One thing that I missed is
a test method that doesn't use the HW transmit timestamp, as retrieving
the TX timestamp can be quite slow, and makes it hard to measure latency
when sending something like ~10K packet/s.

What I mean is something like this: the transmit side takes a timestamp,
stores it in the packet being sent and sends the packet, the receive
side gets the HW receive timestamp (usually faster) and calculates the
latency based on the HW receive timestamp and the timestamp in the
packet. I know that you should take the propagation delay and other
stuff into account. But on back-to-back systems (at least) these other
delays should be quite small compared to the whole latency.

Do you think adding a test method similar to this would make sense for
plget?


Cheers,
--
Vinicius
