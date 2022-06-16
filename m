Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D951154E277
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377268AbiFPNt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377113AbiFPNtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:49:51 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A72CDFA;
        Thu, 16 Jun 2022 06:49:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VGaYQbt_1655387367;
Received: from 30.225.28.136(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VGaYQbt_1655387367)
          by smtp.aliyun-inc.com;
          Thu, 16 Jun 2022 21:49:44 +0800
Message-ID: <61fbee55-245f-b912-95df-d9557849d08f@linux.alibaba.com>
Date:   Thu, 16 Jun 2022 21:49:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
 <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
 <7d57f299-115f-3d34-a45e-1c125a9a580a@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <7d57f299-115f-3d34-a45e-1c125a9a580a@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/6/1 下午2:33, D. Wythe wrote:
> 
> 在 2022/5/25 下午9:42, Alexandra Winter 写道:
> 
>> We need to carefully evaluate them and make sure everything is compatible
>> with the existing implementations of SMC-D and SMC-R v1 and v2. In the
>> typical s390 environment ROCE LAG is propably not good enough, as the card
>> is still a single point of failure. So your ideas need to be compatible
>> with link redundancy. We also need to consider that the extension of the
>> protocol does not block other desirable extensions.
>>
>> Your prototype is very helpful for the understanding. Before submitting any
>> code patches to net-next, we should agree on the details of the protocol
>> extension. Maybe you could formulate your proposal in plain text, so we can
>> discuss it here?
>>
>> We also need to inform you that several public holidays are upcoming in the
>> next weeks and several of our team will be out for summer vacation, so please
>> allow for longer response times.
>>
>> Kind regards
>> Alexandra Winter
>>
> 
> Hi alls,
> 
> In order to achieve signle-link compatibility, we must
> complete at least once negotiation. We wish to provide
> higher scalability while meeting this feature. There are
> few ways to reach this.
> 
> 1. Use the available reserved bits. According to
> the SMC v2 protocol, there are at least 28 reserved octets
> in PROPOSAL MESSAGE and at least 10 reserved octets in
> ACCEPT MESSAGE are available. We can define an area in which
> as a feature area, works like bitmap. Considering the subsequent scalability, we MAY use at least 2 reserved ctets, which can support negotiation of at least 16 features.
> 
> 2. Unify all the areas named extension in current
> SMC v2 protocol spec without reinterpreting any existing field
> and field offset changes, including 'PROPOSAL V1 IP Subnet Extension',
> 'PROPOSAL V2 Extension', 'PROPOSAL SMC-DV2 EXTENSION' .etc. And provides
> the ability to grow dynamically as needs expand. This scheme will use
> at least 10 reserved octets in the PROPOSAL MESSAGE and at least 4 reserved octets in ACCEPT MESSAGE and CONFIRM MESSAGE. Fortunately, we only need to use reserved fields, and the current reserved fields are sufficient. And then we can easily add a new extension named SIGNLE LINK. Limited by space, the details will be elaborated after the scheme is finalized.
> 
> But no matter what scheme is finalized, the workflow should be similar to:
> 
> Allow Single-link:
> 
> client                                server
>      proposal with Single-link feature bit or extension
>          -------->
> 
>      accept with Single-link feature bit extension
>          <--------
> 
>          confirm
>          -------->
> 
> 
> Deny or not recognized:
> 
> client                                 server
>      proposal with Single-link feature bit or extension
>          -------->
> 
>          rkey confirm
>          <------
>          ------>
> 
>      accept without Single-link feature bit or extension
>          <------
> 
>          rkey confirm
>          ------->
>          <------
> 
>          confirm
>          ------->
> 
> 
> Look forward to your advice and comments.
> 
> Thanks.

Hi all,

On the basis of previous，If we can put the application data over the PROPOSAL message,
we can achieve SMC 0-RTT. Its process should be similar to the following:

client									server
	PROPOSAL MESSAGE
		with first contact
		with 0RTT query extension
		-------->

	ACCEPT MESSAGE
			with(or without)
			0RTT response extension
		<--------

	CONFIRM MESSAGE
		-------->

client									server
	PROPOSAL MESSAGE
		without	first contact
		with ORTT Data
		-------->

	ACCEPT MESSAGE
		<---------

	CONFIRM MESSAGE
		-------->

If so, using reserved bit to exchange feature are not enough. We have a simple design
to perform compatibility with legacy extensions and support future extensions.

This draft try to unify all the areas named extension in current
SMC v2 protocol spec, includes 'PROPOSAL V1 IP Subnet Extension',
'PROPOSAL V2 Extension', 'PROPOSAL SMC-DV2 EXTENSION',
and 'First Contact Extension'.

This draft does lots of compromise designs in order to achieve compatibility.
I believe there must have better ways. Let me get the ball rolling. And please let
me know if you have any suggestions or better ideas. This draft of the design
is as follows:

SMC V2 CLC PROPOSAL MESSAGE:

+------+-------+------------------------------------------------------------+
|0	50     |NOT changed						    |
+------+-------+------------------------------------------------------------+
|50    |2      |SMC Version 2 Extension Offset(applicable when SMC V2)      |
+------+-------+------------------------------------------------------------+
|52    |19     |Reserved for growth                                         |
+------+-------+------------------------------------------------------------+
|71    |*      |Extension Area  (reserved before)                           |
+------+-------+------------------------------------------------------------+
|71    |2      |number of Extensions  (reserved before)                     |
+------+-------+------------------------------------------------------------+
|73    |7      |V1 IP Subnet Extension Header (when applicable)             |
+------+-------+------------------------------------------------------------+
|73    |7      |Padding Extension (when V1 IP Subnet Extension not present) |
+------+-------+------------------------------------------------------------+
|80    |*      |V1 IP Subnet Extension Payload (when applicable)            |
+------+-------+------------------------------------------------------------+
|      |       |V2 Extension (when applicable)                              |
+------+-------+------------------------------------------------------------+
|      |       |other available Extension (when applicable)                 |
+------+-------+------------------------------------------------------------+
|*     |4      |Eye catcher ‘SMCR’ (EBCDIC) message end                     |
+------+-------+------------------------------------------------------------+

Notes:

     1. In the current implementation, server read the proposal message with
fixed length, areas beyond the length will be silently ignored, and server will give
up to check eye catcher. Therefore, It's safe to extend the message from the tail.

     2. (reserved before) means that the areas used to be reserved.

     3. none of the existing fields have their offsets changed
within the PROPOSAL message.


Extension Areas Format:

+------+-------+-----------------------+
|0     |*      |Extensions Area        |
+------+-------+-----------------------+
|0     |2      |Number of Extensions   |
+------+-------+-----------------------+
|2     |*      |Extensions             |
+------+-------+-----------------------+
|      |       |End of Extensions Area |
+------+-------+-----------------------+

notes:

     1. All extensions within the extension areas should be contiguous.


Extension Format:

+------+-------+----------------------------------------+
|0     |*      |Extension                               |
+------+-------+----------------------------------------+
|0     |6+     |Extension header                        |
+------+-------+----------------------------------------+
|0     |4      |reserved                                |
+------+-------+----------------------------------------+
|2     |*      |Extension Type (variable length)        |
+------+-------+----------------------------------------+
|*     |*      |Payload Length (variable length)        |
+------+-------+----------------------------------------+
|*     |*      |payload                                 |
+------+-------+----------------------------------------+

notes:

     1. This scheme was specially designed to be compatible with
'PROPOSAL V2 Extension', since it is the only extension with no
reserved octets ahead of it.

     2. Another special case is 'PROPOSAL SMC-DV2 EXTENSION', it's also
has no reserved octets ahead of it, but it can be treats as an
optional part of 'PROPOSAL V2 Extension'.

     3. To be compatible with 'PROPOSAL V2 Extension', there are only
2 reserved octets left to place type and length fields. If octet per
each fileds, there can be only a maximum of 255 extension types and
a maximum length of 255. For better scalability, the type and length
fields are encoded as variable length integer.

variable length integer encoding:

+--------------+-------+---------------+--------+
|first bit     |octet  |Usable Bits    |Range   |
+--------------+-------+---------------+--------+
|0             |1      |7              |0-127   |
+--------------+-------+---------------+--------+
|1             |2      |15             |0-32767 |
+--------------+-------+---------------+--------+

notes;

     1. This design introduces some complexity and we can totally give it
up if we do not need more than 255 extensions at all.

V1 IP Subnet Extension Format:

+------+-------+-------------------------------------------------+
|0     |7      |Extension Header                                 |
+------+-------+-------------------------------------------------+
|0     |4      |Reserved                                         |
+------+-------+-------------------------------------------------+
|4     |1      |Extension type(0x2)                              |
+------+-------+-------------------------------------------------+
|5     |2      |payload length                                   |
+------+-------+-------------------------------------------------+
|7     |*      |V1 IP Subnet Extension Payload                   |
+------+-------+-------------------------------------------------+
|7     |5      |Client IPv4 Subnet Mask (IPv4 only)              |
+------+-------+-------------------------------------------------+
|7     |4      |Subnet Mask                                      |
+------+-------+-------------------------------------------------+
|9     |2      |Reserved                                         |
+------+-------+-------------------------------------------------+
|11    |*      |Client IPv6 Prefix Array (zero for IPv4)         |
+------+-------+-------------------------------------------------+
|11    |1      |Number of IPv6 Prefixes in Prefix array (1 - 8)  |
+------+-------+-------------------------------------------------+
|12    |*      |Prefix Array, variable length array              |
+------+-------+-------------------------------------------------+

notes:

     1. newly V1 IP Subnet Extension borrows 7 octets from the
reserved fields in the upper near part to form a completed extension.

     2. none of the existing fields have their offsets changed
within the PROPOSAL message.

Padding Extension Format:

+------+-------+-------------------------------+
|0     |2      |Reserved                       |
+------+-------+-------------------------------+
|2     |1      |Extension type(0x0)            |
+------+-------+-------------------------------+
|3     |*      |Payload length                 |
+------+-------+-------------------------------+
|*     |*      |Padding (fill with 0x0)        |
+------+-------+-------------------------------+

notes:

     1. Padding Extension is used to fill reserved areas that
have not been used yet. It doesn't mean anything, and can be replaced
in the future.

SMCv2 EXTENSION Format:

+------+-------+------------------------------------------------------------+
|0     |8      |SMCv2 Extension - Client Options Area (SMCRv2 & SMCDv2)     |
+------+-------+------------------------------------------------------------+
|0     |8      |SMCv2 Extension - Client Options Area Header                |
+------+-------+------------------------------------------------------------+
|0     |1      |EID Number                                                  |
+------+-------+------------------------------------------------------------+
|1     |1      |ISMv2 GID Number                                            |
+------+-------+------------------------------------------------------------+
|2     |1      |Flag 1 (bit 8) - Reserved                                   |
+------+-------+------------------------------------------------------------+
|3     |1      |Flag 2 (bit 8)                                              |
+------+-------+------------------------------------------------------------+
|4     |2      |Extension Header (reserved before)                          |
+------+-------+------------------------------------------------------------+
|4     |1      |Extension type(0x3)                                         |
+------+-------+------------------------------------------------------------+
|5     |1      |payload length (range 0-127)                                |
+------+-------+------------------------------------------------------------+
|6     |2      |SMCDv2 Extension Offset (if present)                        |
+------+-------+------------------------------------------------------------+
|8     |16     |RoCEv2 GID (IPv4 or IPv6 address)                           |
+------+-------+------------------------------------------------------------+
|8     |16     |RoCEv2 GID IPv6 address (when IPv6)                         |
+------+-------+------------------------------------------------------------+
|8     |12     |RoCEv2 GID IPv4 reserved (when IPv4)                        |
+------+-------+------------------------------------------------------------+
|20    |4      |RoCEv2 GID IPv4 address (right aligned)                     |
+------+-------+------------------------------------------------------------+
|24    |9      |Reserved                                                    |
+------+-------+------------------------------------------------------------+
|33    |7      |Continuation extension (reserved before)                    |
+------+-------+------------------------------------------------------------+
|33    |4      |Reserved                                                    |
+------+-------+------------------------------------------------------------+
|37    |1      |Extension type(0x1) (reserved before)                       |
+------+-------+------------------------------------------------------------+
|38    |2      |Payload length (reserved before)                            |
+------+-------+------------------------------------------------------------+
|40    |*      |EID Array Area – variable length (32 bytes * EID Number)    |
+------+-------+------------------------------------------------------------+
|*     |*      |SMCDv2 optional area (used to called SMCDv2 extension)      |
+------+-------+------------------------------------------------------------+

notes:

     1. newly V2 EXTENSION use several reserved octets to form a completed
extension. Note that none of the existing fields have their offsets changed
within the PROPOSAL message.

     2. the size of SMCv2 EXTENSION plus maximum size of EID Array Area is
much bigger than the highest number that one octet can represent. To be
compatible with 'legacy V2 Extension', there are only 2 reserved octets left to
place type and length fields. therefore, we use Continuation Extension to solve
it.

Continuation Extension Format:

+------+-------+-------------------------------+
|0     |4      |Reserved                       |
+------+-------+-------------------------------+
|4     |1      |Extension type(0x1)            |
+------+-------+-------------------------------+
|5     |*      |payload length                 |
+------+-------+-------------------------------+
|*     |*      |Continuation data              |
+------+-------+-------------------------------+

notes:

     1. Indicate that the content of this extension is continuation of
the content of its previous extension.

     2. In order to be compatible with some existing extensions,
when the reserved bytes that can be used are not enough to represent
its maximum length.


CLC ACCEPT MESSAGE (SMC-DV2 FORMAT) / CLC CONFIRM MESSAGE (SMC-Dv2 FORMAT)

+------+-------+---------------------------------------------------+
|34    |32     |EID (Negotiated Common EID selected by the server) |
+------+-------+---------------------------------------------------+
|66    |4      |Reserved                                           |
+------+-------+---------------------------------------------------+
|70    |*      |Extensions Area                                    |
+------+-------+---------------------------------------------------+
|70    |2      |number of Extensions  (reserved before)            |
+------+-------+---------------------------------------------------+
|72    |38     |First Contact Extension -                          |
|      |       |only present when first contact flag is on         |
+------+-------+---------------------------------------------------+
|72    |6      |First Contact Extension Header                     |
+------+-------+---------------------------------------------------+
|72    |2      |Reserved                                           |
+------+-------+---------------------------------------------------+
|74    |4      |FCE Header                                         |
+------+-------+---------------------------------------------------+
|74    |1      |FCE Header - reserved                              |
+------+-------+---------------------------------------------------+
|75    |1      |FCE Header Flag 1 (bit 8)                          |
+------+-------+---------------------------------------------------+
|76    |1      |Extension type (0x4) (reserved before)             |
+------+-------+---------------------------------------------------+
|77    |1      |Payload length (0x20) (reserved before)		   |
+------+-------+---------------------------------------------------+
|78    |32     |FCE Peer Host Name                                 |
+------+-------+---------------------------------------------------+
|110   |*      |other available Extension (when applicable)        |
+------+-------+---------------------------------------------------+
|*     |4      |Eye catcher ‘SMCD’ (EBCDIC) message end            |
+------+-------+---------------------------------------------------+

CLC ACCEPT MESSAGE (SMC-RV2 FORMAT)

+------+-------+---------------------------------------------------+
|64    |32     |EID (Negotiated EID selected by server)            |
+------+-------+---------------------------------------------------+
|96    |4      |Reserved                                           +
+------+-------+---------------------------------------------------+
|100   |*      |Extension Area                                     |
+------+-------+---------------------------------------------------+
|100   |2      |number of Extension  (reserved before)             |
+------+-------+---------------------------------------------------+
|102   |38     |First Contact Extension -                          |
|      |       |only present when first contact flag is on         |
+------+-------+---------------------------------------------------+
|102   |6      |First Contact Extension Header                     |
+------+-------+---------------------------------------------------+
|102   |2      |reserved                                           |
+------+-------+---------------------------------------------------+
|104   |4      |FCE Header                                         |
+------+-------+---------------------------------------------------+
|104   |1      |FCE Header - reserved                              |
+------+-------+---------------------------------------------------+
|105   |1      |FCE Header Flag 1 (bit 8)                          |
+------+-------+---------------------------------------------------+
|106   |1      |Extension type (0x4) (reserved before)             |
+------+-------+---------------------------------------------------+
|107   |1      |Payload length (0x20) (reserved before)            |
+------+-------+---------------------------------------------------+
|108   |32     |FCE Peer Host Name                                 |
+------+-------+---------------------------------------------------+
|140   |16     |Padding Extension	(reserved before)	   |
+------+-------+---------------------------------------------------+
|156   |*      |other available Extension (when applicable)        |
+------+-------+---------------------------------------------------+
|*     |4      |Eye catcher ‘SMCR’ (EBCDIC) message end            |
+------+-------+---------------------------------------------------+

notes:

     1. none of the existing fields have their offsets changed
within the message.


First Contact Extension Format:

+------+-------+----------------------------------------------------------------+
|0     |6      |First Contact Extension Header                                  |
+------+-------+----------------------------------------------------------------+
|0     |2      |Reserved                                                        |
+------+-------+----------------------------------------------------------------+
|2     |1      |FCE Header Flag 0                                               |
+------+-------+----------------------------------------------------------------+
|3     |1      |FCE Header Flag 1                                               |
+------+-------+----------------------------------------------------------------+
|4     |1      |Extension type (0x4) (reserved before)                          |
+------+-------+----------------------------------------------------------------+
|5     |1      |Payload length (0x20) (reserved before)                         |
+------+-------+----------------------------------------------------------------+
|6     |32     |FCE Peer Host Name (ASCII character - padded with ASCII blanks) |
+------+-------+----------------------------------------------------------------+

notes:

     1. newly First Contact Extension borrows 2 octets from the
reserved fields in the upper near part to form a completed extension.


CLC CONFIRM MESSAGE (SMC-RV2 FORMAT)

+------+-------+---------------------------------------------------+
|64    |32     |EID (Negotiated EID selected by server)            |
+------+-------+---------------------------------------------------+
|96    |4      |Reserved                                           |
+------+-------+---------------------------------------------------+
|100   |*      |Extension Area                                     |
+------+-------+---------------------------------------------------+
|100   |2      |number of Extension  (reserved before)             |
+------+-------+---------------------------------------------------+
|102   |38     |First Contact Extension -                          |
|      |        only present when first contact flag is on         |
+------+-------+---------------------------------------------------+
|102   |6      |First Contact Extension Header                     |
+------+-------+---------------------------------------------------+
|102   |2      |reserved                                           |
+------+-------+---------------------------------------------------+
|104   |4      |FCE Header                                         |
+------+-------+---------------------------------------------------+
|104   |1      |FCE Header - reserved                              |
+------+-------+---------------------------------------------------+
|105   |1      |FCE Header Flag 1 (bit 8)                          |
+------+-------+---------------------------------------------------+
|106   |1      |Extension type (0x4)  (reserved before)            |
+------+-------+---------------------------------------------------+
|107   |1      |Payload length (0x20)                              |
+------+-------+---------------------------------------------------+
|108   |32     |FCE Peer Host Name                                 |
+------+-------+---------------------------------------------------+
|140   |9      |PADDING extension (reserved before)                |
+------+-------+---------------------------------------------------+
|149   |*      |Client RoCEv2 GID Extension                        |
+------+-------+---------------------------------------------------+
|149   |7      |Client RoCEv2 GID Extension Header(reserved before)|
+------+-------+---------------------------------------------------+
|156   |*      |FCE Client RoCEv2 GID List                         |
+------+-------+---------------------------------------------------+
|*     |*      |other available Extension (when applicable)        |
+------+-------+---------------------------------------------------+
|*     |4      |Eye catcher ‘SMCR’ (EBCDIC) message end            |
+------+-------+---------------------------------------------------+

notes:

     1. Client RoCEv2 GID was once part of the First Contact Extension, and now it's
standalone extension.

Client RoCEv2 GID Extension Format:

+-+----+-------+---------------------------------------------------+
|0     |*      |Client RoCEv2 GID                                  |
+------+-------+---------------------------------------------------+
|0     |4      |Reserved                                           |
+------+-------+---------------------------------------------------+
|4     |1      |Extension type(0x5)                                |
+------+-------+---------------------------------------------------+
|5     |2      |Payload length                                     |
+------+-------+---------------------------------------------------+
|7     |*      |Client RoCEv2 GID List                             |
+------+-------+---------------------------------------------------+
|7     |4      |GID List Header                                    |
+------+-------+---------------------------------------------------+
|7     |1      |GID List No of Entries (1 - 8)                     |
+------+-------+---------------------------------------------------+
|8     |3      |Reserved                                           |
+------+-------+---------------------------------------------------+
|11    |*      |GID List Array Area                                |
+------+-------+---------------------------------------------------+
|11    |16     |GID List Entry - RoCEv2 IP address (IPv4 or IPv6)  |
+------+-------+---------------------------------------------------+
+*     |*      |End of Client GID List                             |
+------+-------+---------------------------------------------------+

notes:

     1.  newly Client RoCEv2 GID Extension borrows 7 octets from the
reserved fields in the upper near part to form a completed extension.

     2. none of the existing fields have their offsets changed
within the CONFIRM message.
