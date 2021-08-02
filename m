Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F763DD61E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhHBM5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:57:24 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:45230 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233678AbhHBM5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:57:22 -0400
X-UUID: be321d17faa848ce8adf61ad9d539a67-20210802
X-UUID: be321d17faa848ce8adf61ad9d539a67-20210802
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1587694583; Mon, 02 Aug 2021 20:57:10 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 2 Aug 2021 20:57:08 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 2 Aug 2021 20:57:07 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        <chao.song@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next v2] ipv6: add IFLA_INET6_RA_MTU to expose mtu value in the RA message
Date:   Mon, 2 Aug 2021 20:40:39 +0800
Message-ID: <20210802124039.13231-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210802031924.3256-1-rocco.yue@mediatek.com>
References: <20210802031924.3256-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-31 at 11:17 -0600, David Ahern wrote:
On 7/30/21 7:52 PM, Rocco Yue wrote:

> IFLA_INET6_RA_MTU set. You can set "reject_message" in the policy to
> return a message that "IFLA_INET6_RA_MTU can not be set".

Hi David,

Regarding setting "reject_message" in the policy, after reviewing
the code, I fell that it is unnecessary, because the cost of
implementing it seems to be a bit high, which requires modifying
the function interface. The reasons is as follows:

The parameter "struct netlink_ext_ack *extack" is not exposed in the
function inet6_validate_link_af(), and the last argument when calling
nla_parse_nested_deprecated() is NULL, which makes the user space not
notified even if reject_message is set.

static int inet6_validate_link_af(...)
{
...
	err = nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla,
					  inet6_af_policy, NULL);
...
}


Only when extack is not NULL, reject_message is valid.

static int validate_nla(...)
{
...
	switch (pt->type) {
	case NLA_REJECT:
		if (extack && pt->reject_message) {
			NL_SET_BAD_ATTR(extack, nla);
			extack->_msg = pt->reject_message;
			return -EINVAL;
		}
		err = -EINVAL;
		goto out_err;
...
}


Thanks
Rocco
