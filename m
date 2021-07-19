Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57253CF040
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241605AbhGSXKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:10:42 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:56582 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381883AbhGSWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1626736422; x=1658272422;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=3TLyIqZ2qOOjigHJkXfv0aAq4lL34uZabzOemPuveSE=;
  b=sb5UBIJ7D5GT+5FpvlXTLeR/cmhvTbV5QjkVIDeE30nPvsNmiNm4NIRf
   0U6c1DkpVkYk5C/j6Y4U+v8RgQXsrOUEZUeprQIGG+2RSC0tBua1za9Kj
   YCKje5ta9wbInd9h/QlVi5+/fTeH823jRb73k2Y6OElm4oH26iFm7/GrC
   4=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 19 Jul 2021 16:13:38 -0700
X-QCInternal: smtphost
Received: from nalasexr03e.na.qualcomm.com ([10.49.195.114])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 19 Jul 2021 16:13:34 -0700
Received: from [10.226.59.216] (10.80.80.8) by nalasexr03e.na.qualcomm.com
 (10.49.195.114) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 19 Jul
 2021 16:13:33 -0700
Subject: Re: [RFC PATCH net-next 0/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
To:     Stephan Gerhold <stephan@gerhold.net>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        MSM <linux-arm-msm@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>
References: <20210719145317.79692-1-stephan@gerhold.net>
 <CAOCk7NonuOKWrpr-MwdjAwF1F4jviEMf=c04vVBxQ-OmfY2b-g@mail.gmail.com>
 <YPXC7PDCUopdCdTV@gerhold.net>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
Message-ID: <e37868ee-2bd0-3b50-eb95-8eb2bf32d956@quicinc.com>
Date:   Mon, 19 Jul 2021 17:13:32 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPXC7PDCUopdCdTV@gerhold.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanexm03d.na.qualcomm.com (10.85.0.91) To
 nalasexr03e.na.qualcomm.com (10.49.195.114)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/2021 12:23 PM, Stephan Gerhold wrote:
> On Mon, Jul 19, 2021 at 09:43:27AM -0600, Jeffrey Hugo wrote:
>> On Mon, Jul 19, 2021 at 9:01 AM Stephan Gerhold <stephan@gerhold.net> wrote:
>>>
>>> The BAM Data Multiplexer provides access to the network data channels
>>> of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
>>> or MSM8974. This series adds a driver that allows using it.
>>>
>>> For more information about BAM-DMUX, see PATCH 4/4.
>>>
>>> Shortly said, BAM-DMUX is built using a simple protocol layer on top of
>>> a DMA engine (Qualcomm BAM DMA). For BAM-DMUX, the BAM DMA engine runs in
>>> a quite strange mode that I call "remote power collapse", where the
>>> modem/remote side is responsible for powering on the BAM when needed but we
>>> are responsible to initialize it. The BAM is power-collapsed when unneeded
>>> by coordinating power control via bidirectional interrupts from the
>>> BAM-DMUX driver.
>>
>> The hardware is physically located on the modem, and tied to the modem
>> regulators, etc.  The modem has the ultimate "off" switch.  However,
>> due to the BAM architecture (which is complicated), configuration uses
>> cooperation on both ends.
>>
> 
> What I find strange is that it wasn't done similarly to e.g. Slimbus
> which has a fairly similar setup. (I used that driver as inspiration for
> how to use the mainline qcom_bam driver instead of the "SPS" from
> downstream.)
> 
> Slimbus uses qcom,controlled-remotely together with the LPASS
> remoteproc, so it looks like there LPASS does both power-collapse
> and initialization of the BAM. Whereas here the modem does the
> power-collapse but we're supposed to do the initialization.

I suspect I don't have a satisfactory answer for you.  The teams that 
did slimbus were not the teams involved in the bam_dmux, and the two 
didn't talk to each-other.  The bam_dmux side wasn't aware of the 
slimbus situation, at the time.  I don't know if the slimbus folks knew 
about bam_dmux.  If you have two silos working independently, its 
unlikely they will create exactly the same solution.

> 
>>>
>>> The series first adds one possible solution for handling this "remote power
>>> collapse" mode in the bam_dma driver, then it adds the BAM-DMUX driver to
>>> the WWAN subsystem. Note that the BAM-DMUX driver does not actually make
>>> use of the WWAN subsystem yet, since I'm not sure how to fit it in there
>>> yet (see PATCH 4/4).
>>>
>>> Please note that all of the changes in this patch series are based on
>>> a fairly complicated driver from Qualcomm [1].
>>> I do not have access to any documentation about "BAM-DMUX". :(
>>
>> I'm pretty sure I still have the internal docs.
>>
>> Are there specific things you want to know?
> 
> Oh, thanks a lot for asking! I mainly mentioned this here to avoid
> in-depth questions about the hardware (since I can't answer those).
> 
> I can probably think of many, many questions, but I'll try to limit
> myself to the two I'm most confused about. :-)
> 
> 
> It's somewhat unrelated to this initial patch set since I'm not using
> QMAP at the moment, but I'm quite confused about the "MTU negotiation
> feature" that you added support for in [1]. (I *think* that is you,
> right?) :)

Yes.  Do I owe you for some brain damage?  :)

> 
> The part that I somewhat understand is the "signal" sent in the "OPEN"
> command from the modem. It tells us the maximum buffer size the modem
> is willing to accept for TX packets ("ul_mtu" in that commit).
> 
> Similarly, if we send "OPEN" to the modem we make the modem aware
> of our maximum RX buffer size plus the number of RX buffers.
> (create_open_signal() function).
> 
> The part that is confusing me is the way the "dynamic MTU" is
> enabled/disabled based on the "signal" in "DATA" commands as well.
> (process_dynamic_mtu() function). When would that happen? The code
> suggests that the modem might just suddenly announce that the large
> MTU should be used from now on. But the "buffer_size" is only changed
> for newly queued RX buffers so I'm not even sure how the modem knows
> that it can now send more data at once.
> 
> Any chance you could clarify how this should work exactly?

So, I think some of this might make more sense after my response to 
question #2.

I don't know how much of this translates to modern platforms.  I don't 
really work on MSMs anymore, but I can convey what I recall and how 
things were "back then"

So, essentially the change you are looking at is the bam_dmux portion of 
an overall feature for improving the performance of what was known as 
"tethered rmnet".

Per my understanding (which the documentation of this feature 
reinforces), teathered rmnet was chiefly a test feature.  Your "data" 
(websites, email, etc) could be consumed by the device itself, or 
exported off, if you teathered your phone to a laptop so that the laptop 
could use the phone's data connection.  There ends up being 3 
implementations for this.

Consuming the data on the phone would route it to the IP stack via the 
rmnet driver.

Consuming the data on an external device could take one of 2 routes.

Android would use the "native" routing of the Linux IP stack to 
essentially NAT the laptop.  The data would go to the rmnet driver, to 
the IP stack, and the IP stack would route it to USB.

The other route is that the data could be routed directly to USB.  This 
is "teathered rmnet".  In the case of bam_dmux platforms, the USB stack 
is a client of bam_dmux.

Teathered rmnet was never an end-user usecase.  It was essentially a 
validation feature for both internal testing, and also qualifying the 
device with the carriers.  The carriers knew that Android teathering 
involved NAT based routing on the phone, and wanted to figure out if the 
phone could meet the raw performance specs of the RF technology (LTE 
Category 4 in this case) in a tethered scenario, without the routing.

For tethered rmnet, USB (at the time) was having issues consistently 
meeting those data rates (50mbps UL, 100mbps DL concurrently, if I 
recall correctly).  So, the decided solution was to implement QMAP 
aggregation.

A QMAP "call" over tethered rmnet would be negotiated between the app on 
the PC, and "dataservices" or "DS" on the modem.  One of the initial 
steps of that negotitation causes DS to tell A2 software that QMAP over 
tethered rmnet is being activated.  That would trigger A2 to activate 
the process_dynamic_mtu() code path.  Now bam_dmux would allocate future 
RX buffers of the increased size which could handle the aggregated 
packets.  I think the part that is confusing you is, what about the 
already queued buffers that are of the old size?  Well, essentially 
those get consumed by the rest of the QMAP call negotiation, so by the 
time actual aggregated data is going to be sent from Modem to bam_dmux, 
the pool has been consumed and refilled.

When the tethered rmnet connection is "brought down", DS notifies A2, 
and A2 stops requesting the larger buffers.

Since this not something an end user should ever exercise, you may want 
to consider dropping it.

> And a second question if you don't mind: What kind of hardware block
> am I actually talking to here? I say "modem" above but I just know about
> the BAM and the DMUX protocol layer. I have also seen assertion failures
> of the modem DSP firmware if I implement something incorrectly.
> 
> Is the DMUX protocol just some firmware concept or actually something
> understood by some hardware block? I've also often seen mentions of some
> "A2" hardware block but I have no idea what that actually is. What's
> even worse, in a really old kernel A2/BAM-DMUX also appears as part of
> the IPA driver [2], and I thought IPA is the new thing after BAM-DMUX...

A2 predates IPA.  IPA is essentially an evolution of A2.

Sit down son, let me tell you the history of the world  :)

A long time ago, there was only a single processor that did both the 
"modem" and the "apps".  We generally would call these the 6K days as 
that was the number of the chips (6XXX).  Then it was decided that the 
roles of Apps and Modem should be separated into two different cores. 
The modem, handling more "real time" things, and apps, being more 
"general purpose".  This started with the 7K series.

However, this created a problem as data from a data call may need to be 
consumed by the modem, or the apps, and it wouldn't be clear until the 
packet headers were inspected, where the packet needed to be routed to. 
  Sometimes this was handled on apps, sometimes on modem.  Usually via a 
fully featured IP stack.

With LTE, software couldn't really keep up, and so a hardware engine to 
parse the fields and route the package based on programmed filters was 
implemented.  This is the "Algorithm Accelerator", aka AA, aka A2.

The A2 first appeared on the 9600 chip, which was originally intended 
for Gobi- those dongles you could plug into your laptop to give it a 
data connection on the go when there was no wifi.  It was then coupled 
with both 7x30 and 8660 in what we would call "fusion" to create the 
first LTE capable phones (HTC thunderbolt is the product I recall) until 
an integrated solution could come along.

That integrated solution was 8960.

Back to the fusion solution for a second, the 9600 was connected to the 
7x30/8660 via SDIO.  Prior to this, the data call control and data path 
was all in chip via SMD.  Each rmnet instance had its own SMD channel, 
so essentially its own physical pipe.  With SDIO and 9600, there were 
not enough lanes, so we invented SDIO_CMUX and SDIO_DMUX - the Control 
and Data multiplexers over SDIO.

With 8960, everything was integrated again, so we could run the control 
path over SMD and didn't need a mux.  However, the A2 moved from the 
9600 modem to the 8960 integrated modem, and now we had a direct 
connection to its BAM.  Again, the BAM had a limited number of physical 
pipes, so we needed a data multiplexer again.  Thus SDIO_DMUX evolved 
into BAM_DMUX.

The A2 is a hardware block with an attached BAM, that "hangs off" the 
modem.  There is a software component that also runs on the modem, but 
in general is limited to configuration.  Processing of data is expected 
to be all in hardware.  As I think I mentioned, the A2 is a hardware 
engine that routes IP packets based on programmed filters.

BAM instances (as part of the smart peripheral subsystem or SPS) can 
either be out in the system, or attached to a peripheral.  The A2 BAM is 
attached to the A2 peripheral.  BAM instances can run in one of 3 modes 
- BAM-to-BAM, BAM-to-System, or System-to-System.  BAM-to-BAM is two BAM 
instances talking to eachother.  If the USB controller has a BAM, and 
the A2 has a BAM, those two BAMS could talk directly to copy data 
between the A2 and USB hardware blocks without software interaction 
(after some configuration).  "System" means system memory, or DDR. 
Bam-to-System is the mode the A2 BAM runs in where it takes data to/from 
DDR and gives/takes that data with the A2.  System-to-System would be 
used by a BAM instance not associated with any peripheral to transfer 
data say from Apps DDR to Modem DDR.

The A2 can get data from the RF interface, and determine if that needs 
to go to some modem consumer, the apps processor, or on some chips to 
the wifi processor.  All in hardware, much faster than software for 
multiple reasons, but mainly because multiple filters can be evaluated 
in parallel, each filter looking at multiple fields in parallel.  In a 
nutshell, the IPA is a revised A2 that is not associated with any 
processor (like the modem), which allows it to route data better (think 
wifi and audio usecases).

Hope that all helps.  I'm "around" for more questions.

> 
> Not sure how much you can reveal about this. :)
> 
> Thanks a lot!
> Stephan
> 
> [1]: https://source.codeaurora.org/quic/la/kernel/msm-3.10/commit/?h=LA.BR.1.2.9.1-02310-8x16.0&id=c7001b82388129ee02ac9ae1a1ef9993eafbcb26
> [2]: https://source.codeaurora.org/quic/la/kernel/msm/tree/drivers/platform/msm/ipa/a2_service.c?h=LA.BF.1.1.3-01610-8x74.0
> 

