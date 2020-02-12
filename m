Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 112EA15A556
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 10:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbgBLJx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 04:53:26 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47870 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbgBLJx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 04:53:26 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01C9r4SF044806;
        Wed, 12 Feb 2020 03:53:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581501184;
        bh=vEONNyeQ1okA5mEXXDjoFtDaeMJjiqqcwncztDc/e0k=;
        h=To:From:Subject:CC:Date;
        b=ohZxuxooxuUHeFJ25wOXV7IuywDK9jJNp/0uDb0xlglNXw/GUTvsXhpkxfhOzIpgO
         YkPo6AolaNhFoawRsekKT1adruUH6g3zP0eLtIyWjEd+btFGyTSjPxLEUZasbqijLq
         of9iN9Lzm3nOMsXLgU1735MjPvkgGg+6JgLvk/AA=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01C9r3Z4113661
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 03:53:04 -0600
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 12
 Feb 2020 03:53:02 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 12 Feb 2020 03:53:02 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01C9r1og005754;
        Wed, 12 Feb 2020 03:53:01 -0600
To:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Subject: CHECKSUM_COMPLETE question
CC:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Message-ID: <da2b1a2f-b8f7-21de-05c2-9a30636ccf9f@ti.com>
Date:   Wed, 12 Feb 2020 11:52:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I'd like to ask expert opinion and clarify few points about HW RX checksum offload.

1) CHECKSUM_COMPLETE - from description in <linux/skbuff.h>
  * CHECKSUM_COMPLETE:
  *
  *   This is the most generic way. The device supplied checksum of the _whole_
  *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
  *   hardware doesn't need to parse L3/L4 headers to implement this.

My understanding from above is that HW, to be fully compatible with Linux, should produce CSUM
starting from first byte after EtherType field:
  (6 DST_MAC) (6 SRC_MAC) (2 EtherType) (...                   ...)
                                         ^                       ^
                                         | start csum            | end csum
and ending at the last byte of Ethernet frame data.
- if packet is VLAN tagged then VLAN TCI and real EtherType included in CSUM,
   but first VLAN TPID doesn't
- pad bytes may/may not be included in csum


2) I've found some difference between IPv4 and IPv6 csum processing of fragmented packets

Fragmented IPv4 UDP packet:
  - driver fills skb->csum and sets skb->ip_summed = CHECKSUM_COMPLETE for every fragment
  - in ip_frag_queue() the ip_hdr is parsed, and polled, and packet queued, but
    there is *no* csum correction in this function for polled ip_hdr (no csum_sub() or similar calls)
^^^^
  - as result, in inet_frag_reasm_finish() the skb->csum field can be seen unmodified
  - if the same packet is sent over VLAN the skb->csum in inet_frag_reasm_finish() will be seen as modified due to
    skb_vlan_untag()->skb_pull_rcsum()

Fragmented IPv6 UDP packet:
  - driver fills skb->csum and sets skb->ip_summed = CHECKSUM_COMPLETE for every fragment
  - in ip6_frag_queue() the ipv6_hdr s parsed, and polled, and packet queued,
    *and csum corrected*
  
  ip6_frag_queue()
  ...
     	if (skb->ip_summed == CHECKSUM_COMPLETE) {
		const unsigned char *nh = skb_network_header(skb);
		skb->csum = csum_sub(skb->csum,
				     csum_partial(nh, (u8 *)(fhdr + 1) - nh,

Are there any reasons for such difference between IPv4 and IPv6?

3) few words about new HW i'm working with.
The HW can parse IP4/IP6 and UDP/TCP headers and generate csum including pseudo header checksum
which is working pretty well for non fragmented packets.

For fragmented packets (UDP for example):
- First fragments have the UDP header (including pseudo header) and data included in the count.
- Middle and last fragments have only data included in the count

As result when SUM_ALL(frag->csum) == 0xFFFF means packet csum is correct.

Above seems will not be working out of the box, at least not without csum manipulations simialar
to what is done in mellanox/mlx4/en_rx.c (check_csum(),get_fixed_ipv4_csum(), get_fixed_ipv6_csum())


Thanks you.

-- 
Best regards,
grygorii
