Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F14E4C758
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 08:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfFTGRT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jun 2019 02:17:19 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55612 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFTGRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 02:17:18 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x5K6HCMf015697, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x5K6HCMf015697
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 20 Jun 2019 14:17:12 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Thu, 20 Jun
 2019 14:17:11 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "palmer@sifive.com" <palmer@sifive.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: skb_to_sgvec() casuses sg_pcopy_to_buffer() wrong
Thread-Topic: skb_to_sgvec() casuses sg_pcopy_to_buffer() wrong
Thread-Index: AdUnKF3JjX6iqdk4SWCfeWKY5qIZzA==
Date:   Thu, 20 Jun 2019 06:17:10 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F189FDF5@RTITMBSVM03.realtek.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use skb_to_sgvec() to set scatter list, and sometime we would get a
sg->offset which is more than PAGE_SIZE. Call sg_pcopy_to_buffer()
with this scatter list would get wrong data.

In sg_miter_get_next_page(), you would get wrong miter->__remaining,
when the sg->offset is more than PAGE_SIZE.

static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
{
	if (!miter->__remaining) {
		struct scatterlist *sg;
		unsigned long pgoffset;

		if (!__sg_page_iter_next(&miter->piter))
			return false;

		sg = miter->piter.sg;
		pgoffset = miter->piter.sg_pgoffset;

		miter->__offset = pgoffset ? 0 : sg->offset;
		miter->__remaining = sg->offset + sg->length -
				(pgoffset << PAGE_SHIFT) - miter->__offset;
		miter->__remaining = min_t(unsigned long, miter->__remaining,
					   PAGE_SIZE - miter->__offset);
	}

	return true;
}

Best Regards,
Hayes

