Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425702AC042
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgKIPv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:51:56 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:23062 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgKIPv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604937108;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=+jztkjver5ug/iQJfMsQ/OYcghBQ8FwKRBFEfuozEOk=;
        b=hggzMfXVSDMn1Bdvfsl+8nffukJRbtqRwOb+dHgFSQDCK+n9GzanBfhLZ6JJuum3DH
        ISt2QlBB2XUm65M3YuVtBm9Z4f3LGaE/G465uOsrSp3KY9TavwKc38YCsFOrBT2pJz2L
        YXo3v9sQBmNOYjfpFpwWzPopXcd8mi21frjcim+HWKX9Yl0ohiXPL/aQKEqcoeOwYmm0
        QISG/OxxNV7t5zcr9dHcOhDYfc1QUypAUQtDn1+OgJEZo2y3gYzsixwpElSWJU+jIiuk
        /HicRXaPeFHbTBEGACfFyzEib3f45DM591i5ZF28RDBnxIRGy3cNX4RMFwKjo9VIOCdI
        vtpg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3HMbEWKONeXTNI="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwA9Fpk88X
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Nov 2020 16:51:46 +0100 (CET)
Subject: Re: [PATCH v4 5/7] can: update documentation for DLC usage in
 Classical CAN
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>
References: <20201109102618.2495-1-socketcan@hartkopp.net>
 <20201109102618.2495-6-socketcan@hartkopp.net>
 <CAMZ6RqLNkO=AgBeAh2fn+dU=Hz_EhFSMw6b9HNUDwZwZc_+6Ow@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <cd26154c-a5a5-f83c-0c8e-5bf65b50b278@hartkopp.net>
Date:   Mon, 9 Nov 2020 16:51:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqLNkO=AgBeAh2fn+dU=Hz_EhFSMw6b9HNUDwZwZc_+6Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.11.20 15:50, Vincent MAILHOL wrote:
> On Mon. 9 Nov 2020 at 19:26, Oliver Hartkopp wrote:
>>
>> The extension of struct can_frame with the len8_dlc element and the
>> can_dlc naming issue required an update of the documentation.
>>
>> Additionally introduce the term 'Classical CAN' which has been established
>> by CAN in Automation to separate the original CAN2.0 A/B from CAN FD.
>>
>> Updated some data structures and flags.
>>
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>> ---
>>   Documentation/networking/can.rst | 68 ++++++++++++++++++++++++--------
>>   1 file changed, 52 insertions(+), 16 deletions(-)
>>
>> diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
>> index ff05cbd05e0d..e17c6427bb3a 100644
>> --- a/Documentation/networking/can.rst
>> +++ b/Documentation/networking/can.rst
>> @@ -226,24 +226,40 @@ interface (which is different from TCP/IP due to different addressing
>>   the socket, you can read(2) and write(2) from/to the socket or use
>>   send(2), sendto(2), sendmsg(2) and the recv* counterpart operations
>>   on the socket as usual. There are also CAN specific socket options
>>   described below.
>>
>> -The basic CAN frame structure and the sockaddr structure are defined
>> -in include/linux/can.h:
>> +The Classical CAN frame structure (aka CAN 2.0B), the CAN FD frame structure
>> +and the sockaddr structure are defined in include/linux/can.h:
>>
>>   .. code-block:: C
>>
>>       struct can_frame {
>>               canid_t can_id;  /* 32 bit CAN_ID + EFF/RTR/ERR flags */
>> -            __u8    can_dlc; /* frame payload length in byte (0 .. 8) */
>> +            union {
>> +                    /* CAN frame payload length in byte (0 .. CAN_MAX_DLEN)
>> +                     * was previously named can_dlc so we need to carry that
>> +                     * name for legacy support
>> +                     */
>> +                    __u8 len;
>> +                    __u8 can_dlc; /* deprecated */
>> +            };
>>               __u8    __pad;   /* padding */
>>               __u8    __res0;  /* reserved / padding */
>> -            __u8    __res1;  /* reserved / padding */
>> +            __u8    len8_dlc; /* optional DLC for 8 byte payload length (9 .. 15) */
>>               __u8    data[8] __attribute__((aligned(8)));
>>       };
>>
>> +Remark: The len element contains the payload length in bytes and should be
>> +used instead of can_dlc. The deprecated can_dlc was misleadingly named as
>> +it always contained the plain payload length in bytes and not the so called
>> +'data length code' (DLC).
>> +
>> +To pass the raw DLC from/to a Classical CAN network device the len8_dlc
>> +element can contain values 9 .. 15 when the len element is 8 (the real
>> +payload length for all DLC values greater or equal to 8).
> 
> The "Classical CAN network device" part could make the reader
> misunderstand that FD capable controllers can not handle Classical CAN
> frames with DLC greater than 8. All the CAN-FD controllers I am aware
> of can emit both Classical and FD frames. On the contrary, some
> Classical CAN controllers might not support sending DLCs greater than
> 8. Propose to add the nuance that this depends on the device property:
> 
>   +To pass the raw DLC from/to a capable network device
>   +(c.f. cc-len8-dlc CAN device property), the len8_dlc element can
>   +contain values 9 .. 15 when the len element is 8 (the real payload
>   +length for all DLC values greater or equal to 8).
> 

This section only describes the Classical CAN data structure. I also 
thought about it - but I did not want to overload it with device properties.

>> +
>>   The alignment of the (linear) payload data[] to a 64bit boundary
>>   allows the user to define their own structs and unions to easily access
>>   the CAN payload. There is no given byteorder on the CAN bus by
>>   default. A read(2) system call on a CAN_RAW socket transfers a
>>   struct can_frame to the user space.
>> @@ -258,10 +274,27 @@ PF_PACKET socket, that also binds to a specific interface:
>>               int         can_ifindex;
>>               union {
>>                       /* transport protocol class address info (e.g. ISOTP) */
>>                       struct { canid_t rx_id, tx_id; } tp;
>>
>> +                    /* J1939 address information */
>> +                    struct {
>> +                            /* 8 byte name when using dynamic addressing */
>> +                            __u64 name;
>> +
>> +                            /* pgn:
>> +                             * 8 bit: PS in PDU2 case, else 0
>> +                             * 8 bit: PF
>> +                             * 1 bit: DP
>> +                             * 1 bit: reserved
>> +                             */
>> +                            __u32 pgn;
>> +
>> +                            /* 1 byte address */
>> +                            __u8 addr;
>> +                    } j1939;
>> +
>>                       /* reserved for future CAN protocols address information */
>>               } can_addr;
>>       };
> 
> This looks like some J1939 code. Did you mix your patches?
> 

This belongs to "update data structures" in the commit message ;-)

>>   To determine the interface index an appropriate ioctl() has to
>> @@ -369,11 +402,11 @@ bitrates for the arbitration phase and the payload phase of the CAN FD frame
>>   and up to 64 bytes of payload. This extended payload length breaks all the
>>   kernel interfaces (ABI) which heavily rely on the CAN frame with fixed eight
>>   bytes of payload (struct can_frame) like the CAN_RAW socket. Therefore e.g.
>>   the CAN_RAW socket supports a new socket option CAN_RAW_FD_FRAMES that
>>   switches the socket into a mode that allows the handling of CAN FD frames
>> -and (legacy) CAN frames simultaneously (see :ref:`socketcan-rawfd`).
>> +and Classical CAN frames simultaneously (see :ref:`socketcan-rawfd`).
>>
>>   The struct canfd_frame is defined in include/linux/can.h:
>>
>>   .. code-block:: C
>>
>> @@ -395,21 +428,21 @@ all structure elements can be used as-is - only the data[] becomes extended.
> 
> In below paragraph, needs to add an exception for can_frame.len8_dlc:
> 
>   The struct canfd_frame and the existing struct can_frame have the can_id,
>   the payload length and the payload data at the same offset inside their
>   structures. This allows to handle the different structures very similar.
>   When the content of a struct can_frame is copied into a struct canfd_frame
>   -all structure elements can be used as-is - only the data[] becomes extended.
>   +all structure elements (except the len8_dlc field) can be used as-is and the
>   +data[] becomes extended.
> 

This section tells about the mapping of "the can_id, the payload length 
and the payload data"

Intentionally nothing about flags and len8_dlc.

>>   When introducing the struct canfd_frame it turned out that the data length
>>   code (DLC) of the struct can_frame was used as a length information as the
>>   length and the DLC has a 1:1 mapping in the range of 0 .. 8. To preserve
>>   the easy handling of the length information the canfd_frame.len element
>>   contains a plain length value from 0 .. 64. So both canfd_frame.len and
>> -can_frame.can_dlc are equal and contain a length information and no DLC.
>> +can_frame.len are equal and contain a length information and no DLC.
>>   For details about the distinction of CAN and CAN FD capable devices and
>>   the mapping to the bus-relevant data length code (DLC), see :ref:`socketcan-can-fd-driver`.
> 
> Now that the field has been renamed, the "1:1 mapping" explanation
> becomes obsolete. I propose to drastically reduce the paragraph:
> 

I would suggest to send a patch when the patch set has been applied. The 
process is slightly wrong, when you dictate your suggestions and I 
re-post version by version.

Thanks,
Oliver

>   +Despite being formerly named can_dlc, the len field of both struct
>   +can_frame and struct canfd_frame are equal and contain a plain length
>   +value from 0 .. 64; no DLC.  For details about the distinction of CAN
>   +and CAN FD capable devices and the mapping to the bus-relevant data
>   +length code (DLC), see :ref:`socketcan-can-fd-driver`.
> 
>>   The length of the two CAN(FD) frame structures define the maximum transfer
>>   unit (MTU) of the CAN(FD) network interface and skbuff data length. Two
>>   definitions are specified for CAN specific MTUs in include/linux/can.h:
>>
>>   .. code-block:: C
>>
>> -  #define CAN_MTU   (sizeof(struct can_frame))   == 16  => 'legacy' CAN frame
>> +  #define CAN_MTU   (sizeof(struct can_frame))   == 16  => Classical CAN frame
>>     #define CANFD_MTU (sizeof(struct canfd_frame)) == 72  => CAN FD frame
>>
>>
>>   .. _socketcan-raw-sockets:
>>
>> @@ -607,11 +640,11 @@ Example:
>>
>>       if (nbytes == CANFD_MTU) {
>>               printf("got CAN FD frame with length %d\n", cfd.len);
>>               /* cfd.flags contains valid data */
>>       } else if (nbytes == CAN_MTU) {
>> -            printf("got legacy CAN frame with length %d\n", cfd.len);
>> +            printf("got Classical CAN frame with length %d\n", cfd.len);
>>               /* cfd.flags is undefined */
>>       } else {
>>               fprintf(stderr, "read: invalid CAN(FD) frame\n");
>>               return 1;
>>       }
>> @@ -621,21 +654,21 @@ Example:
>>       printf("can_id: %X data length: %d data: ", cfd.can_id, cfd.len);
>>       for (i = 0; i < cfd.len; i++)
>>               printf("%02X ", cfd.data[i]);
>>
>>   When reading with size CANFD_MTU only returns CAN_MTU bytes that have
>> -been received from the socket a legacy CAN frame has been read into the
>> +been received from the socket a Classical CAN frame has been read into the
>>   provided CAN FD structure. Note that the canfd_frame.flags data field is
>>   not specified in the struct can_frame and therefore it is only valid in
>>   CANFD_MTU sized CAN FD frames.
>>
>>   Implementation hint for new CAN applications:
>>
>>   To build a CAN FD aware application use struct canfd_frame as basic CAN
>>   data structure for CAN_RAW based applications. When the application is
>>   executed on an older Linux kernel and switching the CAN_RAW_FD_FRAMES
>> -socket option returns an error: No problem. You'll get legacy CAN frames
>> +socket option returns an error: No problem. You'll get Classical CAN frames
>>   or CAN FD frames and can process them the same way.
>>
>>   When sending to CAN devices make sure that the device is capable to handle
>>   CAN FD frames by checking if the device maximum transfer unit is CANFD_MTU.
>>   The CAN device MTU can be retrieved e.g. with a SIOCGIFMTU ioctl() syscall.
>> @@ -840,10 +873,12 @@ TX_RESET_MULTI_IDX:
>>          Reset the index for the multiple frame transmission.
>>
>>   RX_RTR_FRAME:
>>          Send reply for RTR-request (placed in op->frames[0]).
>>
>> +CAN_FD_FRAME:
>> +       The CAN frames following the bcm_msg_head are struct canfd_frame's
>>
>>   Broadcast Manager Transmission Timers
>>   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>>   Periodic transmission configurations may use up to two interval timers.
>> @@ -1024,11 +1059,11 @@ In this example an application requests any CAN traffic from vcan0::
>>
>>   Additional procfs files in /proc/net/can::
>>
>>       stats       - SocketCAN core statistics (rx/tx frames, match ratios, ...)
>>       reset_stats - manual statistic reset
>> -    version     - prints the SocketCAN core version and the ABI version
>> +    version     - prints SocketCAN core and ABI version (removed in Linux 5.10)
>>
>>
>>   Writing Own CAN Protocol Modules
>>   --------------------------------
>>
>> @@ -1068,11 +1103,11 @@ General Settings
>>   .. code-block:: C
>>
>>       dev->type  = ARPHRD_CAN; /* the netdevice hardware type */
>>       dev->flags = IFF_NOARP;  /* CAN has no arp */
>>
>> -    dev->mtu = CAN_MTU; /* sizeof(struct can_frame) -> legacy CAN interface */
>> +    dev->mtu = CAN_MTU; /* sizeof(struct can_frame) -> Classical CAN interface */
>>
>>       or alternative, when the controller supports CAN with flexible data rate:
>>       dev->mtu = CANFD_MTU; /* sizeof(struct canfd_frame) -> CAN FD interface */
>>
>>   The struct can_frame or struct canfd_frame is the payload of each socket
>> @@ -1182,10 +1217,11 @@ Setting CAN device properties::
>>           [ one-shot { on | off } ]
>>           [ berr-reporting { on | off } ]
>>           [ fd { on | off } ]
>>           [ fd-non-iso { on | off } ]
>>           [ presume-ack { on | off } ]
>> +        [ cc-len8-dlc { on | off } ]
>>
>>           [ restart-ms TIME-MS ]
>>           [ restart ]
>>
>>           Where: BITRATE       := { 1..1000000 }
>> @@ -1324,26 +1360,26 @@ CAN FD (Flexible Data Rate) Driver Support
>>   CAN FD capable CAN controllers support two different bitrates for the
>>   arbitration phase and the payload phase of the CAN FD frame. Therefore a
>>   second bit timing has to be specified in order to enable the CAN FD bitrate.
>>
>>   Additionally CAN FD capable CAN controllers support up to 64 bytes of
>> -payload. The representation of this length in can_frame.can_dlc and
>> +payload. The representation of this length in can_frame.len and
>>   canfd_frame.len for userspace applications and inside the Linux network
>>   layer is a plain value from 0 .. 64 instead of the CAN 'data length code'.
>> -The data length code was a 1:1 mapping to the payload length in the legacy
>> +The data length code was a 1:1 mapping to the payload length in the Classical
>>   CAN frames anyway. The payload length to the bus-relevant DLC mapping is
>>   only performed inside the CAN drivers, preferably with the helper
>>   functions can_dlc2len() and can_len2dlc().
> 
> Same as above: the "1:1 mapping" part is obsolete. Now that can_dlc
> has been renamed to length, no need to cover this matter in further
> details. I propose to replace it by below paragraph:
> 
>   +Additionally CAN FD capable CAN controllers support up to 64 bytes of
>   +payload. The representation of this length in can_frame.len and
>   +canfd_frame.len for userspace applications and inside the Linux
>   +network layer is a plain value from 0 .. 64.
> 
> In addition, I propose to add a sentence about the two new DLC helper
> functions:
> 
>   +The payload length to the bus-relevant DLC mapping is only performed
>   +inside the CAN drivers, preferably with the helper functions
>   +can_dlc2len() and can_len2dlc(). If the controller handles Classical
>   +CAN frames with DLC greater than 8, helper functions
>   +can_get_len8_dlc() and can_get_cc_dlc() can be used to respectively
>   +fill the len8_dlc fill during reception and get the DLC value during
> 
>>
>>   The CAN netdevice driver capabilities can be distinguished by the network
>>   devices maximum transfer unit (MTU)::
>>
>> -  MTU = 16 (CAN_MTU)   => sizeof(struct can_frame)   => 'legacy' CAN device
>> +  MTU = 16 (CAN_MTU)   => sizeof(struct can_frame)   => Classical CAN device
>>     MTU = 72 (CANFD_MTU) => sizeof(struct canfd_frame) => CAN FD capable device
>>
>>   The CAN device MTU can be retrieved e.g. with a SIOCGIFMTU ioctl() syscall.
>> -N.B. CAN FD capable devices can also handle and send legacy CAN frames.
>> +N.B. CAN FD capable devices can also handle and send Classical CAN frames.
>>
>>   When configuring CAN FD capable CAN controllers an additional 'data' bitrate
>>   has to be set. This bitrate for the data phase of the CAN FD frame has to be
>>   at least the bitrate which was configured for the arbitration phase. This
>>   second bitrate is specified analogue to the first bitrate but the bitrate
