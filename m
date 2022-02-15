Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A8D4B6537
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiBOIIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:08:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiBOIIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:08:36 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4212C672
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 00:08:26 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JyYWl1NxPz1FDBg;
        Tue, 15 Feb 2022 16:04:03 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 16:08:23 +0800
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        <pablo@netfilter.org>, <keescook@chromium.org>, <alobakin@pm.me>,
        <nbd@nbd.name>, <herbert@gondor.apana.org.au>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Subject: Why vlan_dev can not follow real_dev mtu change from smaller to
 bigger
Message-ID: <6ffd8030-28ff-396b-5f94-a2e9fd8ef9fd@huawei.com>
Date:   Tue, 15 Feb 2022 16:08:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Recently, I did some tests about mtu change for vlan device
and real_dev. I found that vlan_dev's mtu could not follow its
real_dev's mtu change from smaller to bigger.

For example:
Firstly, change real_dev's mtu from 1500 to 256, vlan_dev's mtu
follow change from 1500 to 256.
Secondly, change real_dev's mtu from 256 to 1500, but vlan_dev's
mtu is still 256.

I fond the code as following. But I could not understand the
limitations. Is there anyone can help me?

static int vlan_device_event(struct notifier_block *unused, unsigned long event,
			     void *ptr)
{
	...

	case NETDEV_CHANGEMTU:
		vlan_group_for_each_dev(grp, i, vlandev) {
			if (vlandev->mtu <= dev->mtu)
				continue;

			dev_set_mtu(vlandev, dev->mtu);
		}
		break;
	...
}

Thank you for your reply.

