Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C432C6E86
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 03:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgK1CiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 21:38:05 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8055 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729604AbgK1CgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 21:36:22 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CjbFs0wC4zhcHy;
        Sat, 28 Nov 2020 10:35:45 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 10:36:00 +0800
Subject: Re: [PATCH] powerpc: fix the allyesconfig build
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Daniel Axtens" <dja@axtens.net>, Joel Stanley <joel@jms.id.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-renesas-soc@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20201128122819.32187696@canb.auug.org.au>
 <20201127175642.45502b20@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <382701ba-c50e-18cf-83be-60eeab228372@huawei.com>
Date:   Sat, 28 Nov 2020 10:36:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201127175642.45502b20@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/28 9:56, Jakub Kicinski wrote:
> On Sat, 28 Nov 2020 12:28:19 +1100 Stephen Rothwell wrote:
>> There are 2 drivers that have arrays of packed structures that contain
>> pointers that end up at unaligned offsets.  These produce warnings in
>> the PowerPC allyesconfig build like this:
>>
>> WARNING: 148 bad relocations
>> c00000000e56510b R_PPC64_UADDR64   .rodata+0x0000000001c72378
>> c00000000e565126 R_PPC64_UADDR64   .rodata+0x0000000001c723c0
>>
>> They are not drivers that are used on PowerPC (I assume), so mark them
>> to not be built on PPC64 when CONFIG_RELOCATABLE is enabled.
> 
> 😳😳
> 
> What's the offending structure in hisilicon? I'd rather have a look
> packing structs with pointers in 'em sounds questionable.
> 
> I only see these two:
> 
> $ git grep packed drivers/net/ethernet/hisilicon/
> drivers/net/ethernet/hisilicon/hns/hnae.h:struct __packed hnae_desc {
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.h:struct __packed hns3_desc {

I assmue "struct __packed hnae_desc" is the offending structure, because
flag_ipoffset field is defined as __le32 and is not 32 bit aligned.

struct __packed hnae_desc {
	__le64 addr;							//0
	union {
		struct {						//64
			union {
				__le16 asid_bufnum_pid;
				__le16 asid;
			};
			__le16 send_size;				//92
			union {
				__le32 flag_ipoffset;			//*108*
				struct {
					__u8 bn_pid;
					__u8 ra_ri_cs_fe_vld;
					__u8 ip_offset;
					__u8 tse_vlan_snap_v6_sctp_nth;
				};
			};
			__le16 mss;
			__u8 l4_len;
			__u8 reserved1;
			__le16 paylen;
			__u8 vmid;
			__u8 qid;
			__le32 reserved2[2];
		} tx;

		struct {
			__le32 ipoff_bnum_pid_flag;
			__le16 pkt_len;
			__le16 size;
			union {
				__le32 vlan_pri_asid;
				struct {
					__le16 asid;
					__le16 vlan_cfi_pri;
				};
			};
			__le32 rss_hash;
			__le32 reserved_1[2];
		} rx;
	};
};

> .
> 
