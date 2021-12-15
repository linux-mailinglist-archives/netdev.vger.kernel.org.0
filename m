Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B04762AC
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 21:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhLOUJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 15:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbhLOUJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 15:09:14 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6AAC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 12:09:13 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id r15so43129324uao.3
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 12:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=jqqbdsGYw6IWc2KQYAh7tktFwBbjNaEl/CW8DwACOZA=;
        b=X5R6chFkDg93+YzdPXxl5LDVwLVWRsL/YDXtDnG+pThbd69z8W0X8ODQIRGccDlFSA
         u8DXZdLka4KpmO856Qo8S+RhxyS8abD3BPPfX69DLJWqyuejDIifTljzBMD+u6aY1npM
         wzyh2i1LJwTo7PYnJlPyME07aCREF/bB/C7tcEA6NAwtI6Y0EvT1lmuklFG3X7BgRADH
         fS+onscKzDzPFwIuaFvrBOiYJkQg4z+xiySOag7F5u3wAA4NLnpSRwYvUD+D7sSbaNxz
         OsUTeiqaIaUHdfRXu0bceHt4M0hXBX0Ns1FwVkmK/EMTpHnLeXZqBdiWm5RJY6E+cit7
         T3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jqqbdsGYw6IWc2KQYAh7tktFwBbjNaEl/CW8DwACOZA=;
        b=D2wSXVWRs/rd6RdUpawwVk6YM660JIPYc3/NVpZoz3yRqvXAKFy+9GgD3gJSBNN1bi
         E5GUHkg5dM/VX83x/8elfvHcwvkEvDihHmtZBJBUl3jPc4NIwy1x8QqTn5rUdG0xqBuF
         LWahKuxXzSKRA/l4oxMiJiZi0FLVUlWtT8V+TaANJ/qcv5t6PnzMsadCMivyjUfr28s7
         X17ct3GWmuF5u+doN6Pvhjhm5itaUX97mst268oT5H1/oUChwAlzpjKJgG9l5LKd1+x2
         O+OOZCAQVxiz+buW4hsMNW7b+xmsNXizzSUVCqPUiCHa5Y6RoeNqe54cM2bM3zOJT2O2
         kxQg==
X-Gm-Message-State: AOAM530/KXEfS8khuurt3MfjY6+z98mSxeXkTYWalW6YtN90k0uHi6kO
        i7MmH359ubp4SHpUQ2OdCuTFsej6mOB+azm4Jvia/Kp8ujGs7veNDx8=
X-Google-Smtp-Source: ABdhPJyF6RoNUyESWDBN/ezX+7kBKm4OmGJovYF/CVzcyGA7gsa5bfsRPYONn2rvhgBSoaJasb79+LZgrpAPyQz4GLI=
X-Received: by 2002:a67:ef4b:: with SMTP id k11mr4323906vsr.74.1639598952690;
 Wed, 15 Dec 2021 12:09:12 -0800 (PST)
MIME-Version: 1.0
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 15 Dec 2021 21:09:01 +0100
Message-ID: <CANr-f5x0_RDAfVQiqpcWOG2iVAtson0F6arQMSbrBXjB73kw+A@mail.gmail.com>
Subject: RFC: tsnep: ETF, AF_XDP, UIO or driver specific interface for real-time
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bjorn@kernel.org,
        magnus.karlsson@intel.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        gregkh@linuxfoundation.org, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

the driver for my FPGA based TSN endpoint Ethernet MAC is now in net-next. As
a first step, it supports a single TX/RX queue pair for normal Ethernet
communication. For TSN it supports hardware timestamps (PTP) and TAPRIO (gate
control). The next step is the user space interface for real-time communication
over additional TX/RX queue pairs.

Multiple interfaces are used for real-time communication in user space:
A) ETF for timed transmit
B) AF_XDP for direct access omitting the network stack
C) UIO for mapping devices to user space
D) driver specific interfaces for direct access to DMA buffers and IO memory
   (out of tree)

The additional TX/RX queue pairs of my Ethernet MAC are optimized for real-time
communication. The mapping to ETF or AF_XDP is not straightforward. I know a
little about UIO and ETF and I have read Documentation/networking/af_xdp.rst,
but that does not qualify me as an expert. So I want to discuss if ETF, AF_XDP,
UIO or any other standard Linux user space interface is the right choice for my
driver?

First I want to describe the main real-time feature of the device, the periodic
TX schedule:

The data exchange between hardware and software is done similarly to other
Ethernet MACs. Descriptor rings are used and the ownership of descriptors
is transferred from software to hardware and vice versa during operation.

Usually TX descriptor rings are queues, which transfer data from RAM to
Ethernet MAC as fast as possible. This is the case for the first TX/RX queue
pair, which is used by the Ethernet driver. For real-time communication
transmission at defined points in time is a requirement. Additionally, the
transmitted data shall be as up-to-data as possible. Therefore, the data shall
be transferred to the Ethernet MAC as late as possible. This enables minimal
reaction time for closed loop control. So there are actually two points in time.
First, the start of the DMA transfer of data from RAM to Ethernet MAC. Second,
the start of the transmission over Ethernet.

Therefore, the TX descriptor ring of additional TX/RX queue pairs is enhanced
with timing information. This timing information defines both points in time.
As a result, the TX descriptor ring is processed at defined points in time and
not as fast as possible.

Real-time communication is usually periodic. The timing pattern repeats after
the least common multiple of all cycle times. The relative timing information
of two consecutive TX descriptors is constant. So relative timing information
is used within the TX descriptor ring. There is no need to update this relative
timing information during operation. Only transmitted data and ownership must
be updated. The TAPRIO gate control list is good example for a periodic
schedule.

The periodic nature of real-time communication has another side effect. The
timing is known in advance. So a TX descriptor is able to define the timing of
the next TX descriptor. As a result, the hardware knows the timing of the next
TX descriptor without fetching it from RAM. This prevents a chicken egg problem:
the TX descriptor cannot define its own DMA timing, because DMA would be needed
to read this timing.

All these properties lead to a periodic TX schedule implemented with an
enhanced TX descriptor ring. Let's describe the details with an example:

- two cycle times
  - single Ethernet frame every 100us, first TX at absolute time 7000us
    - TX times: 7000us, 7100us, 7200us, ...
  - single Ethernet frame every 200us, first TX at absolute time 7050us
    - TX times: 7050us, 7250us, 7450us, ...
- DMA shall be done as late as possible for 100us cycle time
- DMA of 200us cycle time shall be done directly after DMA of 100us cycle time

The perdiodic TX schedule for this example looks like this:

+-------------<-------------------------<-------------------------<------------+
|                                                                              |
+-->+-------------------+---->+-------------------+---->+-------------------+->+
    | TX desc 1 @0x1000 |     | TX desc 2 @0x2000 |     | TX desc 3 @0x3000 |
    |                   |     |                   |     |                   |
    | next_desc=0x2000  |     | next_desc=0x3000  |     | next_desc=0x1000  |
    | dma_incr=10us     |     | dma_incr=90us     |     | dma_incr=100us    |
    | tx_incr=50us      |     | tx_incr=50us      |     | tx_incr=100us     |
    +-------------------+     +-------------------+     +-------------------+

"next_desc" is the address of the next TX descriptor. "dma_incr" defines the
DMA start time of the next TX descriptor:

"DMA start time" = "Current DMA start time" + dma_incr

Similar "tx_incr" defines the Ethernet TX start time of the next TX descriptor:

"Ethernet TX start time" = "Current Ethernet TX start time" + tx_incr

The TX descriptor processing needs initial values for the address of the first
descriptor, the DMA start time of the first descriptor, and the Ethernet TX
start time of the first descriptor. These initial values are written to
registers:

- "TX descriptor address" register  = 0x1000
- "DMA start time" register         =   6980us
- "Ethernet TX start time" register =   7000us

These three registers always hold information about the next TX descriptor. The
location in the RAM, the point it time when it shall be read by DMA, the point
in time when it shall be transmitted.

The least common multiple of the cycle times is 200us. Thus, the sum of all
"tx_incr" values must be 200us. Also the sum of all "dma_incr" values must be
200us. Otherwise DMA and TX timing would drift away from each other.

TX descriptors 1 and 3 belong to the 100us cycle time. TX descriptor 2
belongs to
the 200us cycle time. The TX schedule is processed in the following steps:

              cycle time | DMA read | Ethernet TX
1) TX desc 1       100us |  @6980us |     @7000us
2) TX desc 2       200us |  @6990us |     @7050us
3) TX desc 3       100us |  @7080us |     @7100us
4) TX desc 1       100us |  @7180us |     @7200us
5) TX desc 2       200us |  @7190us |     @7250us
6) TX desc 3       100us |  @7280us |     @7300us
7) TX desc 1       100us |  @7380us |     @7400us
8) TX desc 2       200us |  @7390us |     @7450us
9) TX desc 3       100us |  @7480us |     @7500us
...

First DMA read is done at 6980us. This point in time is defined with the initial
value of the "DMA start time" register. The following DMA reads are
determined by
the "dma_incr" values of the TX descriptors. Every DMA read is started before
the Ethernet TX.

First Ethernet TX is done at 7000us. This point in time is defined with the
initial value of the "Ethernet TX start time" register. The following Ethernet
TX times are determined by the "tx_incr" values of the TX descriptors.

So the periodic TX schedule actually contains two schedules. One for DMA read
and another one for Ethernet TX. As a result, the timing of DMA and Ethernet TX
can be optimized independently from each other. The only restriction is that
DMA has to be done before the corresponding Ethernet TX.

This periodic TX schedule has been used in a similar way for the
EtherCAT fieldbus
for nearly 10 years with positive experience. So for OPC UA Pub/Sub TSN it
shall be used again.

This periodic TX schedule does not fit to ETF, because ETF uses absolute time
stamps and the timing is not known in advance. Additionally, the intention of
the periodic TX schedule is that the real-time application writes the data
directly to the TX descriptor ring. AF_XDP has a similar direction, but does
not support any TX timing.

I have no knowledge about any other Ethernet MAC which supports timed TX in
a similar way like this device.

Currently a simple device/driver specific interface is used. Similar to UIO it
supports the mapping of registers of TX/RX queue pairs to user space. Every
additional TX/RX queue pair has its own register set within a separate 4kB
IO-memory. Thus, only the register sets of the additional TX/RX queue pairs are
mapped to user space. Every TX/RX queue pair is more less a separate device,
which can be operated independent of any other TX/RX queue pair. Additionally,
this device/driver specific interface supports the mapping of DMA buffers.

A similar approach has been used for years for the periodic TX schedule in
combination with the EtherCAT fieldbus (out of tree driver). The main advantage
of this approach is that no hard or soft IRQs are needed for operation. There is
no need to increase to priority of soft IRQs, which can lead to real-time
problems.

Which user space interface shall be used for this periodic TX schedule? Is
ETF or XDP an option? Shall UIO be used like for other real-time controllers?
Is a device/driver specific interface the way to go, because no other Ethernet
MAC has an interface like this?

I'm looking forward to your comments.

Gerhard
