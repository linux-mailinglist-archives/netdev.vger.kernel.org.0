Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B06268802B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjBBOdD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Feb 2023 09:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjBBOdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:33:02 -0500
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BB7210D
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 06:32:56 -0800 (PST)
X-QQ-mid: bizesmtp79t1675348358tbnbjxae
Received: from smtpclient.apple ( [115.227.175.252])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 02 Feb 2023 22:32:36 +0800 (CST)
X-QQ-SSF: 00400000000000M0O000000A0000000
X-QQ-FEAT: 3M0okmaRx3huBSPZ9xS1hR5u+s1eAwIqGxBc7yxjBKCBkRUKe17koEsEETFZw
        6wdap2EHve+Tf3qCJWpy9E6irGYn9jt1hNY83nmpe1b7m4OlPJ7X5oj5DUeWA2nMc+WAyeq
        FtRyev8Qb6hKH9cLBT6ZHDz+JQarMz/r1pF4U+psOs9W9OxIwpoCuLCE6sC3JslNYbu6AW5
        b0CQPTjOHKe7EMOtNDVvSsoetwmCRqNTcI+Xl4e1aGQm+BDokNlXooSMsPAENZNO67W/+TM
        K6zNl34OMw5NI0SiauRYiXLO+I5gQw8siwL4LOwiMAEl83FBOOh8Ed2oSIaEo5AQE6msxux
        kx39/Z4C7kvPutPj/IslMdOWHp/4cUp6w903JzniQgRieTVTSAIwMZV4Y/gK02eiR2XSM9f
        oeP/ZRB1crpQ0faJqg7Lelq8aL8NdVTJ
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next v2 05/10] net: libwx: Allocate Rx and Tx
 resources
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <20230201215112.37a72893@kernel.org>
Date:   Thu, 2 Feb 2023 22:32:36 +0800
Cc:     netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>,
        =?utf-8?B?5byg5a6H5byY?= <yuhongzhang@net-swift.com>,
        =?utf-8?B?5byg546y546y?= <linglingzhang@net-swift.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1752DEC1-E8DC-4BA5-A422-3D53DAF48993@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
 <20230131100541.73757-6-mengyuanlou@net-swift.com>
 <20230201215112.37a72893@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our device is a different design from Intel’s product. The protocol of receive/transmit queue between driver and ASIC is similar to Intel 82599. If you are familiar with Intel design, the knowledge could save you a lot of time to understand the operation flows. For example, the receive/transmit descriptors are submitted to the queues. ASIC fetches the descriptors from host memory and processes them. Done bit is set to the writeback descriptor in the same queue. But there are many differences in receive/transmit descriptor definition and register implementation. These differences may need your attention. For example, we have packet type field defined in receive/transmit descriptor. Driver uses the info to get ASIC parse result and deliver host info to ASIC. And comparing with 82599, we have a few different features such as QCN, qinq, vxlan and etc.

> 2023年2月2日 13:51，Jakub Kicinski <kuba@kernel.org> 写道：
> 
> On Tue, 31 Jan 2023 18:05:36 +0800 Mengyuan Lou wrote:
>> +/* Transmit Descriptor */
>> +union wx_tx_desc {
>> +	struct {
>> +		__le64 buffer_addr; /* Address of descriptor's data buf */
>> +		__le32 cmd_type_len;
>> +		__le32 olinfo_status;
>> +	} read;
>> +	struct {
>> +		__le64 rsvd; /* Reserved */
>> +		__le32 nxtseq_seed;
>> +		__le32 status;
>> +	} wb;
>> +};
>> +
>> +/* Receive Descriptor */
>> +union wx_rx_desc {
>> +	struct {
>> +		__le64 pkt_addr; /* Packet buffer address */
>> +		__le64 hdr_addr; /* Header buffer address */
>> +	} read;
>> +	struct {
>> +		struct {
>> +			union {
>> +				__le32 data;
>> +				struct {
>> +					__le16 pkt_info; /* RSS, Pkt type */
>> +					__le16 hdr_info; /* Splithdr, hdrlen */
>> +				} hs_rss;
>> +			} lo_dword;
>> +			union {
>> +				__le32 rss; /* RSS Hash */
>> +				struct {
>> +					__le16 ip_id; /* IP id */
>> +					__le16 csum; /* Packet Checksum */
>> +				} csum_ip;
>> +			} hi_dword;
>> +		} lower;
>> +		struct {
>> +			__le32 status_error; /* ext status/error */
>> +			__le16 length; /* Packet length */
>> +			__le16 vlan; /* VLAN tag */
>> +		} upper;
>> +	} wb;  /* writeback */
>> +};
> 
> How close of a copy of Intel Niantic is your device?
> 

