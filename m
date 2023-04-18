Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364A86E59FE
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjDRHA2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Apr 2023 03:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjDRHA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:00:27 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E28ACE
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 00:00:24 -0700 (PDT)
X-QQ-mid: bizesmtp82t1681801215t82no00y
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 18 Apr 2023 15:00:14 +0800 (CST)
X-QQ-SSF: 00400000000000N0R000000A0000000
X-QQ-FEAT: FW3BqzqOhZmV3iJkrmjeDpxA66cw8B6gN/35P1IPlDSPu7Eywq36KkyQZwrfF
        kUhHbqy2Ev8eTMO81wspRt9ABfT9SBdAPL9LQwFTXbCb0Se8xCA2sQ0c4Ct+bXmUHDCef/Q
        T+SYnCYNMyvGkHI3m1g6xRxBJTiZEEj1GXDPAaCqHE9zFspbjZkiPNz6O1u0a/izoLV+AnB
        5hhfvSknDMnCrc6qqUqEUiXHX5e8eXwyhyqhjV9sgdYQdTrBmRxVj4XHs38ni4qja51XqGt
        4FByg+6OW9oa+8Lx16bCTnZsLrDuR0L+0M4m3hfUYIHi1Q6xbA8EwqJpM0T69v1kmpbJxxt
        dSV2+iCdDgAZIJstkU/5PkZudJLC3Ef7r2S4X9nutpsWoP8Zxd+lx3+VX+g2GCYJ8vVEndx
        rwH3AOLJXGU=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 9698088460676227492
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [PATCH net-next v2 1/5] net: wangxun: libwx add tx offload
 functions
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <630e590e-fac3-5f69-688e-ac140ab3464e@huawei.com>
Date:   Tue, 18 Apr 2023 15:00:04 +0800
Cc:     netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4E862584-755D-4EC4-9588-DB0B14D64CD5@net-swift.com>
References: <20230417105457.82127-1-mengyuanlou@net-swift.com>
 <20230417105457.82127-2-mengyuanlou@net-swift.com>
 <630e590e-fac3-5f69-688e-ac140ab3464e@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2023年4月17日 20:35，Yunsheng Lin <linyunsheng@huawei.com> 写道：
> 
> On 2023/4/17 18:54, Mengyuan Lou wrote:
>> +
>> +static u8 wx_encode_tx_desc_ptype(const struct wx_tx_buffer *first)
>> +{
>> + u8 tun_prot = 0, l4_prot = 0, ptype = 0;
>> + struct sk_buff *skb = first->skb;
>> +
>> + if (skb->encapsulation) {
>> + union network_header hdr;
>> +
>> + switch (first->protocol) {
>> + case htons(ETH_P_IP):
>> + tun_prot = ip_hdr(skb)->protocol;
>> + if (ip_is_fragment(ip_hdr(skb)))
>> + goto encap_frag;
> 
> It seems you can do below:
> if (ip_is_fragment(ip_hdr(skb)))
> return WX_PTYPE_PKT_IP | WX_PTYPE_TYP_IPFRAG;
> 
> Instead of goto encap_frag to do the first->protocol and
> ip_is_fragment() checking again?
> 
>> + ptype = WX_PTYPE_TUN_IPV4;
>> + break;
>> + case htons(ETH_P_IPV6):
>> + tun_prot = wx_get_ipv6_proto(skb, skb_network_offset(skb));
>> + if (tun_prot == NEXTHDR_FRAGMENT)
>> + goto encap_frag;
> 
> Similar handling here?
> 
>> + ptype = WX_PTYPE_TUN_IPV6;
>> + break;
>> + default:
>> + goto exit;
> 
> Return 0 or return ptype directly instead of goto?
> 
> Similar comment as other 'goto exit'.
> 
>> + }
>> +
>> + if (tun_prot == IPPROTO_IPIP) {
> 
> ...
> 
>> + goto exit;
>> + }
>> + } else {
>> +encap_frag:
>> + switch (first->protocol) {
>> + case htons(ETH_P_IP):
>> + l4_prot = ip_hdr(skb)->protocol;
>> + ptype = WX_PTYPE_PKT_IP;
>> + if (ip_is_fragment(ip_hdr(skb))) {
>> + ptype |= WX_PTYPE_TYP_IPFRAG;
>> + goto exit;
>> + }
>> + break;
>> + case htons(ETH_P_IPV6):
>> + l4_prot = wx_get_ipv6_proto(skb, skb_network_offset(skb));
>> + ptype = WX_PTYPE_PKT_IP | WX_PTYPE_PKT_IPV6;
>> + if (l4_prot == NEXTHDR_FRAGMENT) {
>> + ptype |= WX_PTYPE_TYP_IPFRAG;
>> + goto exit;
>> + }
>> + break;
>> + case htons(ETH_P_1588):
>> + ptype = WX_PTYPE_L2_TS;
>> + goto exit;
>> + case htons(ETH_P_FIP):
>> + ptype = WX_PTYPE_L2_FIP;
>> + goto exit;
>> + case htons(ETH_P_LLDP):
>> + ptype = WX_PTYPE_L2_LLDP;
>> + goto exit;
>> + case htons(ETH_P_CNM):
>> + ptype = WX_PTYPE_L2_CNM;
>> + goto exit;
>> + case htons(ETH_P_PAE):
>> + ptype = WX_PTYPE_L2_EAPOL;
>> + goto exit;
>> + case htons(ETH_P_ARP):
>> + ptype = WX_PTYPE_L2_ARP;
>> + goto exit;
>> + default:
>> + ptype = WX_PTYPE_L2_MAC;
> 
> Is it ok to set ptype to WX_PTYPE_L2_MAC for first->protocol != ETH_P_IP
> && first->protocol != ETH_P_IPV6? Does hw need to do checksum/tso or other thing
> about those packet? if not, setting WX_PTYPE_L2_MAC seems enough?
> 
    • The hardware needs to parse these packets with these ptype bits.
> Also, some macro and variable are still not used, such as WX_PTYPE_L2_FCOE_VFT_FCRDY
> and vft_shadow, it would be better to remove it for now, and add it as needed.
> 

